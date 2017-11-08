defmodule SoundboxServer.ButtonListener do
  use GenServer

  alias SoundboxServer.SoundPlayer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def init(:ok) do
    port = Port.open({:spawn, command()}, [:binary])
    Process.send_after(self(), :check_port_alive, 1000)

    {:ok, port}
  end

  def handle_info({port, {:data, id}}, port) do
    button = id |> String.trim() |> String.to_integer()
    SoundPlayer.play(SoundboxServer.SoundPlayer, button)
    {:noreply, port}
  rescue
    _ -> {:noreply, port}
  end

  def handle_info(:check_port_alive, port) do
    new_port =
      if Port.info(port),
        do: port,
        else: Port.open({:spawn, command()}, [:binary])

    Process.send_after(self(), :check_port_alive, 1000)
    {:noreply, new_port}
  end

  defp command do
    "cat " <> Application.get_env(:soundbox_server, :button_tty, "/dev/null")
  end
end
