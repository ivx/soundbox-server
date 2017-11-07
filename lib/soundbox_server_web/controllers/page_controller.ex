defmodule SoundboxServerWeb.PageController do
  use SoundboxServerWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
