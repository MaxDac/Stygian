defmodule StygianWeb.EntitiesSelectors do
  @moduledoc """
  A collection of selectors components that allow selecting various entities 
  defined in the application.
  """
  use Phoenix.Component

  import StygianWeb.CoreComponents

  alias Phoenix.LiveView.AsyncResult

  @doc """
  Renders the selector for an entity with a dropdown.
  """
  attr :field, FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :label, :string, default: nil
  attr :empty_option, :string, required: true
  attr :entities, :list, required: true

  def entity_selection(%{entities: %AsyncResult{}} = assigns) do
    ~H"""
    <.async_result :let={entities} assign={@entities}>
      <:loading><.spinner /></:loading>
      <:failed :let={_reason}>Errore nel caricare le entità.</:failed>

      <.entity_selection 
        entities={entities} 
        field={@field} 
        label={@label}
        empty_option={@empty_option}
      />
    </.async_result>
    """
  end

  def entity_selection(%{entities: entities} = assigns) do
    options =
      entities
      |> Enum.map(&{&1.name, &1.id})

    assigns =
      assigns
      |> Map.put(:options, options)
      |> Map.delete(:entities)

    entity_selection(assigns)
  end

  def entity_selection(assigns) do
    ~H"""
    <div>
      <.input
        field={@field}
        label={@label}
        type="select"
        prompt={@empty_option}
        options={@options}
      />
    </div>
    """
  end

  @doc """
  Exposes a list of characters.
  To guarantee maximum performance, the list of characters must be provided in input as an assign.
  """
  attr :field, FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :label, :string, default: nil
  attr :characters, :list, required: true

  def character_selection(assigns) do
    ~H"""
    <.entity_selection
      field={@field}
      label={@label}
      empty_option="Seleziona il personaggio"
      entities={@characters}
    />
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

  def object_selection(assigns) do
    ~H"""
    <.entity_selection
      field={@field}
      label={@label}
      empty_option="Seleziona l'oggetto"
      entities={@objects}
    />
    """
  end

  @doc """
  Exposes a list of skills.
  To guarantee maximum performance, the list of skills must be provided in input as an assign.
  """
  attr :field, FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :label, :string, default: nil
  attr :skills, :list, required: true

  def skill_selection(assigns) do
    ~H"""
    <.entity_selection
      field={@field}
      label={@label}
      empty_option="Seleziona l'attributo"
      entities={@skills}
    />
    """
  end

  @doc """
  Exposes a list of maps.
  To guarantee maximum performance, the list of maps must be provided in input as an assign.
  """
  attr :field, FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :label, :string, default: nil
  attr :maps, :list, required: true

  def map_selection(assigns) do
    ~H"""
    <.entity_selection
      field={@field}
      label={@label}
      empty_option="Seleziona la location"
      entities={@maps}
    />
    """
  end

  @doc """
  Exposes a list of combat actions.
  """
  attr :field, FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :label, :string, default: nil
  attr :actions, :list, required: true

  def combat_action_selection(assigns) do
    ~H"""
    <.entity_selection
      field={@field}
      label={@label}
      empty_option="Seleziona l'azione"
      entities={@actions}
    />
    """
  end
end
