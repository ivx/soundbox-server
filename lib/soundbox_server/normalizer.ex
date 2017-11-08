defmodule SoundboxServer.Normalizer do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, nil, opts)
  end

  def init(nil) do
    {:ok, nil}
  end

  def normalize(pid \\ __MODULE__, file) do
    GenServer.call(pid, {:normalize, file})
  end

  def handle_call({:normalize, data}, _from, state) do
    {:ok, path} = Briefly.create
    File.write!(path, data)
    :ok = {:spawn, command(path)}
    |> Port.open([:binary])
    |> wait_for_normalization

    {:reply, File.read!(path), state}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end

  defp wait_for_normalization(port) do
    if Port.info(port) do
      wait_for_normalization(port)
    else
      :ok
    end
  end

  defp command(path) do
    "mp3gain -r -k #{path}"
  end
end
