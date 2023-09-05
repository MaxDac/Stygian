defmodule StygianWeb.TransactionsLive.TransactionsLive do
  @moduledoc """
  This page allows cigs transactions between characters.
  """

  use StygianWeb, :container_live_view
  
  @impl true
  def mount(_params, _session, socket) do
    IO.inspect(socket, label: "socket")
    {:ok, socket}
  end
end
