defmodule Docs.DocumentController do
  use Docs.Web, :controller

  def show(conn, %{"id" => name} = params ) do
    render conn, "show.html", name: name
  end
end
