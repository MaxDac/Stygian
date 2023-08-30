defmodule StygianWeb.AdminLive.CharacterNpcCreationLive do
  @moduledoc """
  Creates a new NPC.
  """

  use StygianWeb, :container_live_view

  import StygianWeb.CharacterLive.CharacterCompletionSelectorComponent

  alias Stygian.Characters
  alias Stygian.Characters.CharacterSkill
  alias Stygian.Characters.NpcCreationRequest
  alias Stygian.Skills

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_skills()
     |> assign_ages()
     |> assign_form()}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.h1>PNG - Creazione</.h1>

    <.simple_form for={@form} phx-change="validate" phx-submit="create">
      <.input field={@form[:name]} phx-debounce="blur" label="Nome" />

      <.input field={@form[:avatar]} phx-debounce="blur" label="Avatar" />

      <.input field={@form[:small_avatar]} phx-debounce="blur" label="Avatar per la Chat" />

      <.input
        field={@form[:age]}
        label="Età del personaggio"
        type="select"
        options={@ages}
      />

      <.input field={@form[:sin]} phx-debounce="blur" label="Peccato del PNG" />

      <.button>
        Salva
      </.button>

      <div :for={%{skill: skill, value: value} <- @skills}>
        <.attribute_selector skill={skill} value={value} kind="skill" on_plus="plus" on_minus="minus" />
      </div>
    </.simple_form>
    """
  end

  @doc """
  It seems that the validation is mandatory to load the updated form values in the back-end,
  otherwise every other event triggered by the plus/minus buttons to change the attributes would
  delete all the values in the form.

  Added the deboucing mechanism to all the form input anyway.
  """
  @impl true
  def handle_event("validate", %{"npc_creation_request" => params}, socket) do
    {:noreply,
     socket
     |> assign_form(params)}
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
  def handle_event(
        "create",
        %{"npc_creation_request" => params},
        %{assigns: %{skills: skills}} = socket
      ) do
    %{valid?: valid?} =
      %NpcCreationRequest{}
      |> NpcCreationRequest.changeset(params)

    if valid? do
      case Characters.create_npc(params, skills) do
        {:ok, _} ->
          {:noreply, redirect(socket, to: ~p"/admin/npcs")}

        {:error, %Ecto.Changeset{}} ->
          {:noreply,
           socket
           |> put_flash(:error, "Errore durante la creazione del PNG")
           |> assign_form(params)}
      end
    else
      {:noreply, assign_form(socket, params)}
    end
  end

  defp assign_skills(socket) do
    skills =
      Skills.list_preloaded_skills()
      |> Enum.map(fn
        %{is_attribute: true} = skill ->
          %CharacterSkill{skill: skill, skill_id: skill.id, value: 4}

        skill ->
          %CharacterSkill{skill: skill, skill_id: skill.id, value: 0}
      end)

    assign(socket, :skills, skills)
  end

  defp assign_ages(socket) do
    ages = [
      {"Adulto", :adult},
      {"Giovane (potrai selezionare più attributi, ma meno skill)", :young},
      {"Mezza Età (potrai selezionare più skills, ma meno attributi)", :old}
    ]

    assign(socket, :ages, ages)
  end

  defp assign_form(socket, params \\ %{}) do
    form =
      %NpcCreationRequest{}
      |> NpcCreationRequest.changeset(params)
      |> to_form()

    assign(socket, :form, form)
  end
end
