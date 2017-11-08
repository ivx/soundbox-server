defmodule SoundboxServer.Buttons do
  @number_of_buttons 19

  def all do
    0..@number_of_buttons
    |> Enum.map(fn id ->
         case :dets.lookup(:mp3, id) do
           [{_, title, _}] ->
             %{id: id, title: title}

           [] ->
             %{id: id, title: "Button #{id}"}
         end
       end)
  end
end
