defmodule SoundboxServer.SoundPlayer do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, nil, opts)
  end

  def init(nil) do
    {:ok, nil}
  end

  def play(pid \\ __MODULE__, key) do
    GenServer.cast(pid, {:play, key})
  end

  def handle_cast({:play, key}, state) do
    port = Port.open({:spawn, device()}, [:binary])
    try do
      case :dets.lookup(:mp3, key) do
        [{_, _, file}] -> Port.command(port, file)
        _ -> nil
      end
      {:noreply, state}
    after
      Port.close(port)
    end
  end

  defp device do
    Application.get_env(:soundbox_server, :audio_player, "mpg123 -")
  end
end
