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
    "/dev/ttyUSB0"
    |> File.stream!
    |> Enum.each(fn id ->
      IO.inspect(id)
    end)

    {:noreply, nil}
  end
end