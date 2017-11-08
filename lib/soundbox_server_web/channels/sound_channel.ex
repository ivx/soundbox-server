defmodule SoundboxServerWeb.SoundChannel do
  use SoundboxServerWeb, :channel

  def join("sound:lobby", payload, socket) do
    {:ok, get_buttons(), socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("get_buttons", _, socket) do
    {:reply, {:ok, get_buttons()}, socket}
  end

  def handle_in("push_button", %{"id" => id}, socket) do
    SoundboxServer.SoundPlayer.play(SoundboxServer.SoundPlayer, id)
    {:reply, :ok, socket}
  end

  def handle_in("edit_button", %{"id" => id, "title" => title}, socket) do
    result =
      SoundboxServer.Storage.update_title(SoundboxServer.Storage, id, title)

    {:reply, result, socket}
  end

  defp get_buttons do
    %{data: SoundboxServer.Buttons.all()}
  end
end
