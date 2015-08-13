defmodule Docs.DocumentChannel do
  use Docs.Web, :channel

  def join("documents:" <> doc_id, params, socket) do
    {:ok, assign(socket, :doc_id, doc_id)}
  end
end
