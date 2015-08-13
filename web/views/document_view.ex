defmodule Docs.DocumentView do
  use Docs.Web, :view

  def render("show.html", assigns) do
    "showing document #{assigns.name}"
  end
end
