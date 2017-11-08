defmodule SoundboxServerWeb.SoundChannelTest do
  use SoundboxServerWeb.ChannelCase

  alias SoundboxServerWeb.SoundChannel

  setup do
    {:ok, _, socket} =
      socket("user_id", %{})
      |> subscribe_and_join(SoundChannel, "sound:lobby")

    {:ok, socket: socket}
  end

  test "push_button triggers a sound", %{socket: socket} do
    ref = push(socket, "push_button", %{id: 1})
    assert_reply(ref, :ok)
  end
end
