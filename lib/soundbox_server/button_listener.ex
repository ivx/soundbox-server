defmodule SoundboxServer.ButtonListener do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, nil, [])
  end

  def init(nil) do
    Process.send_after(self(), :open_tty, 10)
    {:ok, nil}
  end

  def handle_info(:open_tty, _) do
    port = Port.open({:spawn, "cat /dev/ttyUSB0"}, [:binary])
    receive_from_button(port)
    {:noreply, nil}
  end

  defp receive_from_button(port) do
    receive do
      {^port, {:data, id}} -> 
        IO.inspect(id)
    end
    receive_from_button(port)
  end
end