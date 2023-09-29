defmodule StygianWeb.EntitiesSelectors do
  @moduledoc """
  A collection of selectors components that allow selecting various entities 
  defined in the application.
  """
  use Phoenix.Component

  import StygianWeb.CoreComponents

  alias Phoenix.LiveView.AsyncResult

  @doc """
  Exposes a list of characters.
  To guarantee maximum performance, the list of characters must be provided in input as an assign.
  """
  attr :field, FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :label, :string, default: nil
  attr :characters, :list, required: true

  def character_selection(%{characters: %AsyncResult{}} = assigns) do
    ~H"""
    <.async_result :let={characters} assign={@characters}>
      <:loading><.spinner /></:loading>
      <:failed :let={_reason}>Errore nel caricare i personaggi.</:failed>

      <.character_selection characters={characters} field={@field} label={@label} />
    </.async_result>
    """
  end

  def character_selection(%{characters: characters} = assigns) do
    options =
      characters
      |> Enum.map(&{&1.name, &1.id})

    assigns =
      assigns
      |> Map.put(:options, options)
      |> Map.delete(:characters)

    character_selection(assigns)
  end

  def character_selection(assigns) do
    ~H"""
    <div>
      <.input
        field={@field}
        label={@label}
        type="select"
        prompt="Seleziona il personaggio"
        options={@options}
      />
    </div>
    """
  end

  @doc """
  Exposes a list of objects.
  To guarantee maximum performance, the list of objects must be provided in input as an assign.
  """
  attr :field, FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :label, :string, default: nil
  attr :objects, :list, required: true

  def object_selection(%{objects: %AsyncResult{}} = assigns) do
    ~H"""
    <.async_result :let={objects} assign={@objects}>
      <:loading><.spinner /></:loading>
      <:failed :let={_reason}>Errore nel caricare gli oggetti.</:failed>

      <.object_selection objects={objects} field={@field} label={@label} />
    </.async_result>
    """
  end

  def object_selection(%{objects: objects} = assigns) do
    options =
      objects
      |> Enum.map(&{&1.name, &1.id})

    assigns =
      assigns
      |> Map.put(:options, options)
      |> Map.delete(:objects)

    object_selection(assigns)
  end

  def object_selection(assigns) do
    ~H"""
    <div>
      <.input
        field={@field}
        label={@label}
        type="select"
        prompt="Seleziona l'oggetto"
        options={@options}
      />
    </div>
    """
  end
end