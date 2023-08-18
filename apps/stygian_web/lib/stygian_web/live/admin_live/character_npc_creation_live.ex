defmodule StygianWeb.AdminLive.CharacterNpcCreationLive do
  @moduledoc """
  Creates a new NPC.
  """
  
  use StygianWeb, :container_live_view

  import StygianWeb.CharacterLive.CharacterCompletionSelectorComponent

  alias Stygian.Characters.CharacterSkill
  alias Stygian.Characters.NpcCreationRequest
  alias Stygian.Skills

  @impl true
  def mount(_params, _session, socket) do
    {:ok, 
     socket
     |> assign_skills()
     |> assign_form()}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.h1>PNG - Creazione</.h1> 
    
    <.simple_form
      for={@form}
      phx-submit="create">
      
      <.input
        field={@form[:name]}
        label="Nome" />

      <.input
        field={@form[:avatar]}
        label="Nome" />

      <.button>
        Salva
      </.button>

      <div :for={%{skill: skill, value: value} <- @skills}>
        <.attribute_selector
          skill={skill}
          value={value}
          kind="skill"
          on_plus="plus"
          on_minus="minus"
        />
      </div>

    </.simple_form>
    """
  end

  @impl true
  def handle_event("plus", %{"skill" => skill_id}, %{assigns: %{skills: skills}} = socket) do
    skill_id = String.to_integer(skill_id)

    skills =
      skills
      |> Enum.map(fn 
        %{skill_id: ^skill_id, value: value} = s -> Map.put(s, :value, value + 1)
        s -> s
      end)

    {:noreply, assign(socket, :skills, skills)}
  end

  @impl true
  def handle_event("minus", %{"skill" => skill_id}, %{assigns: %{skills: skills}} = socket) do
    skill_id = String.to_integer(skill_id)

    skills =
      skills
      |> Enum.map(fn 
        %{skill_id: ^skill_id, value: value} = s -> Map.put(s, :value, value - 1)
        s -> s
      end)

    {:noreply, assign(socket, :skills, skills)}
  end

  @impl true
  def handle_event("create", %{"npc_creation_request" => params}, %{assigns: %{skills: skills}} = socket) do
    IO.inspect params, label: "npc params"
    {:noreply, socket}
  end

  defp assign_skills(socket) do
    skills = 
      Skills.list_skills()
      |> Enum.map(&%CharacterSkill{skill: &1, skill_id: &1.id, value: 0})

    assign(socket, :skills, skills)
  end

  defp assign_form(socket) do
    form =
      %NpcCreationRequest{}
      |> NpcCreationRequest.changeset()
      |> to_form()

    assign(socket, :form, form)
  end
end
