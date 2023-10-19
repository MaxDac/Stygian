defmodule StygianWeb.RestLive.CharacterRestComponents do
  @moduledoc """
  A collection of functional components that will isolate certain functionalities.
  """

  use StygianWeb, :html

  alias Phoenix.LiveView.AsyncResult

  @doc """
  A series of checkboxes that will represent the selected occupied slots.
  """
  def slots_resume(assigns) do
    ~H"""
    <ul class="items-center w-full font-typewriter text-brand sm:flex">
      <li 
        class="w-full"
        :for={_ <- 0..3}
      >
        <.slot_resume_item />
      </li>
    </ul>
    """
  end

  @doc """
  A checkbox that represents an occupied slot.
  """
  def slot_resume_item(assigns) do
    ~H"""
    <div class="flex items-center pl-3">
      <input
        id="vue-checkbox-list"
        type="checkbox"
        class="w-4 h-4 text-brand bg-gray-100 border-brand rounded"
        disabled
        checked={true}
      />
      <label
        for="vue-checkbox-list"
        class="w-full py-3 ml-2 text-sm font-medium text-brand"
      >
        Vue JS
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
end
