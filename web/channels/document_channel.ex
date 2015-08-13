defmodule Docs.DocumentChannel do
  use Docs.Web, :channel

  def join("documents:" <> doc_id, params, socket) do
    {:ok, assign(socket, :doc_id, doc_id)}
  end

  def handle_in("text_change", %{"delta" => delta}, socket) do
    broadcast_from! socket, "text_change", %{delta: delta}
    {:reply, :ok, socket}
  end
end
