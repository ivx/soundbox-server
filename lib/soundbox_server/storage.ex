defmodule SoundboxServer.Storage do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, nil, opts)
  end

  def init(nil) do
    Process.flag(:trap_exit, true)
    {:ok, :mp3} = :dets.open_file(:mp3, type: :set)
  end

  def terminate(_, _) do
    :dets.close(:mp3)
  end

  def save(pid, {key, title, data}) do
    GenServer.cast(pid, {:save, key, title, data})
  end

  def update_title(pid, id, title) do
    GenServer.call(pid, {:update_title, id, title})
  end

  def handle_cast({:save, key, title, data}, state) do
    true = :dets.insert_new(:mp3, {key, title, data})
    {:noreply, state}
  end

  def handle_call({:update_title, id, title}, _from, state) do
    [{^id, _, file}] = :dets.lookup(:mp3, id)

    {:reply, :dets.insert(:mp3, [{id, title, file}]), state}
  end
end
