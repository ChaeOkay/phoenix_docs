defmodule Docs.MessageController do
  use Docs.Web, :controller

  alias Docs.Message

  plug :find_document
  plug :scrub_params, "message" when action in [:create, :update]

  def index(conn, _params) do
    messages = Repo.all(Message)
    render(conn, "index.html", messages: messages)
  end

  def new(conn, _params) do
    changeset = Message.changeset(%Message{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"message" => message_params}) do
    doc = conn.assigns.doc
    changeset = Message.changeset(%Message{}, message_params)

    case Repo.insert(changeset) do
      {:ok, _message} ->
        conn
        |> put_flash(:info, "Message created successfully.")
        |> redirect(to: document_message_path(conn, :index, doc))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  defp find_document(conn, _) do
    assign(conn, :doc,
      Repo.get!(Docs.Document, conn.params["document_id"]))
  end
end
