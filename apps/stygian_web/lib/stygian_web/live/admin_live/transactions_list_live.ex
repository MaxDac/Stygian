defmodule StygianWeb.AdminLive.TransactionsListLive do
  @moduledoc """
  A page with a list of different transactions.
  """

  use StygianWeb, :container_live_view

  alias Stygian.Transactions
  alias StygianWeb.AdminLive.TransactionsListFilters

  @impl true
  def mount(_, _, socket) do
    {:ok, stream(socket, :transactions, Transactions.list_transactions_complete())}
  end

  @impl true
  def handle_info({:apply, params}, socket) do
    IO.inspect(params, label: "params")
    {:noreply, stream(socket, :transactions, Transactions.list_transactions_complete(params))}
  end
end
