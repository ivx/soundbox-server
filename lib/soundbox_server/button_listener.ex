defmodule SoundboxServer.ButtonListener do
  use GenServer

  require Logger

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def init(:ok) do
    port = Port.open({:spawn, device()}, [:binary])
    Process.send_after(self(), :check_port_alive, 1000)

    {:ok, port}
  end

  def handle_info({port, {:data, id}}, port) do
    {:noreply, port}
  end

  def handle_info(:check_port_alive, port) do
    new_port = if Port.info(port),
      do: port,
      else: Port.open({:spawn, device()}, [:binary])

    Process.send_after(self(), :check_port_alive, 1000)
    {:noreply, new_port}
  end

  defp device do
    Application.get_env(:soundbox_server, :button_tty, "cat /dev/null")
  end
end
