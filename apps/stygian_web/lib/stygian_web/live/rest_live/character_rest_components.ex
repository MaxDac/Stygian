defmodule StygianWeb.RestLive.CharacterRestComponents do
  @moduledoc """
  A collection of functional components that will isolate certain functionalities.
  """

  use StygianWeb, :html

  alias Phoenix.LiveView.AsyncResult

  @doc """
  A series of checkboxes that will represent the selected occupied slots.
  """
  attr :state, :list, required: true

  def slots_resume(assigns) do
    ~H"""
    <ul class="items-center w-full font-typewriter text-brand sm:flex">
      <li :for={name <- @state} class="w-full">
        <.slot_resume_item name={name} />
      </li>
    </ul>
    """
  end

  @doc """
  A checkbox that represents an occupied slot.
  """
  attr :name, :string, required: true
  def slot_resume_item(assigns) do
    ~H"""
    <div class="flex items-center pl-3">
      <input
        id="vue-checkbox-list"
        type="checkbox"
        class="w-4 h-4 text-brand bg-gray-100 border-brand rounded"
        disabled
        checked={not is_nil(@name)}
      />
      <label for="vue-checkbox-list" class="w-full py-3 ml-2 text-sm font-medium text-brand">
        <%= @name %>
      </label>
    </div>
    """
  end

  @doc """
  Exposes a list of rest actions.
  """
  attr :field, FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :label, :string, default: nil
  attr :rest_actions, AsyncResult, required: true
  attr :rest, :global

  def rest_action_selection(assigns) do
    ~H"""
    <.async_result :let={rest_actions} assign={@rest_actions}>
      <:loading><.spinner /></:loading>
      <:failed :let={_reason}>Errore nel caricare le azioni di riposo.</:failed>

      <.input
        label={@label}
        field={@field}
        type="select"
        prompt="Seleziona l'azione di riposo"
        options={rest_actions}
        {@rest}
      />
    </.async_result>
    """
  end

  @doc """
  Renders a button with the plus icon.

  ## Examples

      <.plus_button>Send!</.plus_button>
      <.plus_button phx-click="go" class="ml-2">Send!</.plus_button>
  """
  attr :type, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled form name value)
  attr :title, :string, required: true

  def plus_button(assigns) do
    ~H"""
    <.button type={@type} class={@class} {@rest}>
      <div class="w-full flex justify-center">
        <div class="flex flex-row items-center">
          <svg
            class="w-4 h-4 text-zinc-900 mr-2"
            aria-hidden="true"
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 18 18"
          >
            <path
              stroke="currentColor"
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M9 1v16M1 9h16"
            />
          </svg>
          <%= @title %>
        </div>
      </div>
    </.button>
    """
  end
end
