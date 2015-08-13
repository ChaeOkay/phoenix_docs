defmodule Docs.DocumentController do
  use Docs.Web, :controller

  def show(conn, %{"id" => name} = params ) do
    text(conn, "Showing doc! #{name}")
  end
end
