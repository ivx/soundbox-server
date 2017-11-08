defmodule SoundboxServer.SoundPlayer do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, nil, opts)
  end

  def init(nil) do
    port = Port.open({:spawn, device()}, [:binary])
    Process.send_after(self(), :check_port_alive, 1000)

    {:ok, port}
  end

  def play(pid \\ __MODULE__, key) do
    GenServer.cast(pid, {:play, key})
  end

  def handle_cast({:play, key}, port) do
    [{_, _, file}] = :dets.lookup(:mp3, key)
    Port.command(port, file)
    {:noreply, port}
  end

  def handle_info(:check_port_alive, port) do
    new_port =
      if Port.info(port),
        do: port,
        else: Port.open({:spawn, device()}, [:binary])

    Process.send_after(self(), :check_port_alive, 1000)
    {:noreply, new_port}
  end

  defp device do
    Application.get_env(:soundbox_server, :audio_player, "mpg123 -")
  end
end
