defmodule SoundboxServer.Storage do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, nil, opts)
  end

  def init(nil) do
    Process.flag(:trap_exit, true)
    {:ok, :mp3} = :dets.open_file(:mp3, [type: :set])
  end

  def terminate(_, _) do
    :dets.close(:mp3)
  end

  def save(pid, {key, caption, data}) do
    GenServer.cast(pid, {:save, key, caption, data})
  end

  def handle_cast({:save, key, caption, data}, state) do
    true = :dets.insert_new(:mp3, {key, caption, data})
    {:noreply, state}
  end
end
