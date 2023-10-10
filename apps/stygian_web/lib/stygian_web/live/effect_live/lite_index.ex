defmodule StygianWeb.EffectLive.LiteIndex do
  @moduledoc """
  A light index to resume all the effects for a particular object
  """

  use StygianWeb, :live_component

  alias Stygian.Objects

  @impl true
  def update(%{object_id: object_id} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_effects(object_id)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <section>
      <.h3>Effetti dell'oggetto</.h3>

      <.return_link navigate={~p"/admin/object_effects/#{@object_id}"}>
        Lista degli effetti
      </.return_link>

      <.table id={"object_#{@object_id}_effects"} rows={@streams.object_effects}>
        <:col :let={{_id, %{object: object}}} label="Oggetto"><%= object.name %></:col>
        <:col :let={{_id, %{skill: skill}}} label="Skill"><%= skill.name %></:col>
        <:col :let={{_id, effect}} label="Valore"><%= effect.value %></:col>
      </.table>
    </section>
    """
  end

  defp assign_effects(socket, object_id) do
    stream(socket, :object_effects, Objects.list_object_effects(object_id))
  end
end
