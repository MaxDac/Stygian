defmodule StygianWeb.ChatLive.ChatEntryLive do
  @moduledoc """
  A collection of functional components that will enable representing the chat entries.
  """

  use StygianWeb, :html

  alias Stygian.Combat

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
        <.chat_character_line chat={@chat} />
        <div class="font-typewriter text-green-500 not-format">
          <%= raw(Earmark.as_html!(@chat.text)) %>
        </div>
      </div>
    </div>
    """
  end

  def chat_entry(%{chat: %{type: :failed_dices}} = assigns) do
    ~H"""
    <div class="text-medium text-brand text-[1rem] flex justify-start space-x-5 mb-5">
      <.chat_avatar chat={@chat} />
      <div class="w-full">
        <.chat_character_line chat={@chat} />
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
        <.chat_character_line chat={@chat} />
        <div class="font-typewriter text-brand not-format">
          <%= raw(Earmark.as_html!(@chat.text)) %>
        </div>
      </div>
    </div>
    """
  end

  def chat_entry(
        %{
          chat: %{
            type: :confirm,
            chat_action_id: chat_action_id
          },
          current_character: %{
            id: current_character_id
          }
        } = assigns
      ) do
    case Combat.get_chat_action(chat_action_id) do
      %{defender_id: defender_id} when defender_id == current_character_id ->
        ~H"""
        <div class="text-medium text-brand text-[1rem] flex justify-start space-x-5 mb-5">
          <div class="w-full flex flex-row space-x-5 items-center">
            <div class="font-typewriter text-brand not-format">
              <%= raw(Earmark.as_html!(@chat.text)) %>
            </div>
            <.button phx-click={
              JS.push("confirm_combat_action", value: %{chat_action_id: @chat.chat_action_id})
            }>
              Conferma
            </.button>
            <.button phx-click={
              JS.push("cancel_combat_action", value: %{chat_action_id: @chat.chat_action_id})
            }>
              Rifiuta
            </.button>
          </div>
        </div>
        """

      _ ->
        ~H"""
        <!-- hidden -->
        """
    end
  end

  def chat_entry(%{chat: %{type: :action_result}} = assigns) do
    ~H"""
    <div class="text-medium text-brand text-[1rem] flex justify-start space-x-5 mb-5">
      <.chat_avatar chat={@chat} />
      <div class="w-full">
        <.chat_character_line chat={@chat} />
        <div class="font-typewriter text-rose-300 not-format">
          <u>
            <%= raw(Earmark.as_html!(@chat.text)) %>
          </u>
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
        <.chat_character_line chat={@chat} />
        <div class="font-typewriter text-zinc-300 not-format">
          <%= raw(Earmark.as_html!(@chat.text)) %>
        </div>
      </div>
    </div>
    """
  end

  @doc """
  The line with the time and the character name.
  """
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

  @doc """
  The chat entry time.
  """
  def chat_time(chat_time),
    do:
      chat_time
      |> NaiveDateTime.add(2, :hour)
      |> Calendar.strftime("%d/%m/%y %I:%M")

  @doc """
  The line with the time and the character name.
  """
  def chat_character_line(assigns) do
    ~H"""
    <div class="font-report">
      <.link phx-click={JS.push("open_character_resume", value: %{character_id: @chat.character.id})}>
        <%= chat_time(@chat.inserted_at) %> - <%= @chat.character.name %>
      </.link>
    </div>
    """
  end
end
