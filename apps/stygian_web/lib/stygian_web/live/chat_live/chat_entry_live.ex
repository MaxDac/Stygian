defmodule StygianWeb.ChatLive.ChatEntryLive do
  @moduledoc """
  A collection of functional components that will enable representing the chat entries.
  """

  use StygianWeb, :html

  @doc """
  Creates the chat entry in the chat window.
  """
  def chat_entry(%{chat: %{type: :master}} = assigns) do
    ~H"""
    <div class="font-typewriter text-white text-medium text-[1rem] text-center not-format w-full">
      <%= raw(Earmark.as_html!(@chat.text)) %>
    </div>
    """
  end

  def chat_entry(%{chat: %{type: :off}} = assigns) do
    ~H"""
    <div class="text-medium text-brand text-[1rem] flex justify-start space-x-5 mb-5">
      <div class="w-full pl-8">
        <div class="font-typewriter text-sm text-zinc-700">
          <%= chat_time(@chat.inserted_at) %> - <%= @chat.character.name %>
        </div>
        <div class="font-typewriter text-sm text-zinc-500 not-format">
          <%= raw(Earmark.as_html!(@chat.text)) %>
        </div>
      </div>
    </div>
    """
  end

  def chat_entry(%{chat: %{type: :dices}} = assigns) do
    ~H"""
    <div class="text-medium text-brand text-[1rem] flex justify-start space-x-5 mb-5">
      <.chat_avatar chat={@chat} />
      <div class="w-full">
        <div class="font-report">
          <%= chat_time(@chat.inserted_at) %> - <%= @chat.character.name %>
        </div>
        <div class="font-typewriter text-rose-500 not-format">
          <%= raw(Earmark.as_html!(@chat.text)) %>
        </div>
      </div>
    </div>
    """
  end

  def chat_entry(%{chat: %{type: :special}} = assigns) do
    ~H"""
    <div class="text-medium text-brand text-[1rem] flex justify-start space-x-5 mb-5">
      <.chat_avatar chat={@chat} />
      <div class="w-full">
        <div class="font-report">
          <%= chat_time(@chat.inserted_at) %> - <%= @chat.character.name %>
        </div>
        <div class="font-typewriter text-brand not-format">
          <%= raw(Earmark.as_html!(@chat.text)) %>
        </div>
      </div>
    </div>
    """
  end

  def chat_entry(assigns) do
    ~H"""
    <div class="text-medium text-brand text-[1rem] flex justify-start space-x-5 mb-5">
      <.chat_avatar chat={@chat} />
      <div class="w-full">
        <div class="font-report">
          <%= chat_time(@chat.inserted_at) %> - <%= @chat.character.name %>
        </div>
        <div class="font-typewriter text-zinc-300 not-format">
          <%= raw(Earmark.as_html!(@chat.text)) %>
        </div>
      </div>
    </div>
    """
  end

  def chat_time(chat_time), do: Calendar.strftime(chat_time, "%d/%m/%y %I:%M")

  def chat_avatar(assigns) do
    ~H"""
    <div class="not-format h-full flex mt-2">
      <img
        class="rounded-full h-10 w-10 align-middle"
        src={@chat.character.small_avatar || @chat.character.avatar}
        alt="Avatar"
      />
    </div>
    """
  end
end
