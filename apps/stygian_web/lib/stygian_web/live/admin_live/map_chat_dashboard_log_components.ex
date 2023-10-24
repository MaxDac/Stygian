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
    <div class="mt-5">
      <%= @chat_entry.text %>
    </div>
    """
  end
end
