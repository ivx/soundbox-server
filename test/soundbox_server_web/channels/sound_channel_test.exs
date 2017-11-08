defmodule SoundboxServerWeb.SoundChannelTest do
  use SoundboxServerWeb.ChannelCase

  alias SoundboxServerWeb.SoundChannel

  setup do
    {:ok, _, socket} =
      socket("user_id", %{})
      |> subscribe_and_join(SoundChannel, "sound:lobby")

    {:ok, socket: socket}
  end

  test "get_buttons replies with buttons", %{socket: socket} do
    ref = push(socket, "get_buttons")

    assert_reply(ref, :ok, %{
      data: [
        %{id: 0, title: "Button0"},
        %{id: 1, title: "new title"},
        %{id: 2, title: "Button2"},
        %{id: 3, title: "Button 3"},
        %{id: 4, title: "Button 4"},
        %{id: 5, title: "Button 5"},
        %{id: 6, title: "Button 6"},
        %{id: 7, title: "Button 7"},
        %{id: 8, title: "Button 8"},
        %{id: 9, title: "Button 9"},
        %{id: 10, title: "Button 10"},
        %{id: 11, title: "Button 11"},
        %{id: 12, title: "Button 12"},
        %{id: 13, title: "Button 13"},
        %{id: 14, title: "Button 14"},
        %{id: 15, title: "Button 15"},
        %{id: 16, title: "Button 16"},
        %{id: 17, title: "Button 17"},
        %{id: 18, title: "Button 18"},
        %{id: 19, title: "Button 19"}
      ]
    })
  end

  test "push_button triggers a sound", %{socket: socket} do
    ref = push(socket, "push_button", %{id: 1})
    assert_reply(ref, :ok)
  end

  test "edit_button changes the title", %{socket: socket} do
    ref = push(socket, "edit_button", %{id: 1, title: "new title"})
    assert_reply(ref, :ok)
  end
end
