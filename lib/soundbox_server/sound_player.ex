defmodule SoundboxServer.SoundPlayer do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, nil, [])
  end

  def init(nil) do
    port = Port.open({:spawn, "mpg123 -"}, [:binary])
    {:ok, port}
  end

  def play(pid, key) do
    GenServer.cast(pid, {:play, key})
  end

  def handle_cast({:play, key}, port) do
    [{_, file}] = :dets.lookup(:mp3, key)
    Port.command(port, file)
    {:noreply, port}
  end
end
