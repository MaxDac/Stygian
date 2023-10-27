defmodule StygianWeb.AdminLive.MapChatDashboardLogComponents do
  @moduledoc """
  This component will show the chat logs for the selected filters.
  """

  use StygianWeb, :html

  @doc """
  Renders the chat logs.
  """
  attr :chats, :list, required: true

  def chat_logs(assigns) do
    ~H"""
    <div class="mt-5">
      <ul>
        <li :for={{_, chat_entry} <- @chats}>
          <.chat_log_entry chat_entry={chat_entry} />
        </li>
      </ul>
    </div>
    """
  end

  @doc """
  Renders a single chat entry.
  """
  attr :chat_entry, :map, required: true

  def chat_log_entry(assigns) do
    ~H"""
    <div class="mt-5 not-format flex flex-col">
      <span class="font-normal text-white text-sm">
        <span class="text-brand font-bold">Ora: </span>
        <.chat_log_date chat_inserted_at={@chat_entry.inserted_at} />
        <span class="text-brand font-bold">Tipo: </span><%= @chat_entry.type %> /
        <span class="text-brand font-bold">Personaggio: </span><%= @chat_entry.character.name %>
      </span>
      <span class="font-normal text-white text-sm">
        <%= @chat_entry.text %>
      </span>
    </div>
    """
  end

  @doc """
  Prints the inserted at datetime as a string in the chat.
  """
  attr :chat_inserted_at, NaiveDateTime, required: true

  def chat_log_date(assigns) do
    ~H"""
    <%= NaiveDateTime.to_string(@chat_inserted_at) %>
    """
  end
end
