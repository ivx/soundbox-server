defmodule SoundboxServer.Storage do
  use GenServer

  alias SoundboxServer.Normalizer

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

  def save(pid \\ __MODULE__, {key, title, data}) do
    GenServer.call(pid, {:save, key, title, data})
  end

  def update_title(pid \\ __MODULE__, id, title) do
    GenServer.call(pid, {:update_title, id, title})
  end

  def handle_call({:save, key, title, data}, _from, state) do
    result = :dets.insert(:mp3, {key, title, Normalizer.normalize(data)})
    {:reply, result, state}
  end

  def handle_call({:update_title, id, title}, _from, state) do
    result =
      case :dets.lookup(:mp3, id) do
        [{^id, _, file}] -> :dets.insert(:mp3, [{id, title, file}])
        [] -> :dets.insert_new(:mp3, [{id, title, <<>>}])
      end

    {:reply, result, state}
  end
end
