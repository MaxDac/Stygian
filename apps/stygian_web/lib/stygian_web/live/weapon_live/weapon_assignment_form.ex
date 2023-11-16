defmodule StygianWeb.WeaponLive.WeaponAssignmentForm do
  @moduledoc """
  Allows addition of association records between characters and weapons.
  """

  use StygianWeb, :live_component

  alias Stygian.Weapons
  alias Stygian.Weapons.WeaponAssignForm

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_form()
     |> assign_weapons()}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.h1>Assegna un'arma al personaggio</.h1>

      <.simple_form
        id="weapon_assignment_form"
        for={@form}
        phx-target={@myself}
        phx-change="validate"
        phx-submit="add_weapon"
      >
        <.input type="hidden" field={@form[:character_id]} value={@character_id} />

        <.weapon_selection label="Arma" weapons={@weapons} field={@form[:weapon_id]} />

        <.button type="submit">
          Aggiungi
        </.button>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def handle_event("validate", %{"weapon_assign_form" => params}, socket) do
    {:noreply, assign_form(socket, params)}
  end

  @impl true
  def handle_event("add_weapon", %{"weapon_assign_form" => params}, socket) do
    changeset =
      %WeaponAssignForm{}
      |> WeaponAssignForm.changeset(params)
      |> IO.inspect(label: "Changeset")

    if changeset.valid? do
      {:noreply,
       socket
       |> assign_weapon_to_character(changeset)}
    else
      {:noreply, assign_form(socket, params)}
    end
  end

  defp assign_form(socket, attrs \\ %{}) do
    form =
      %WeaponAssignForm{}
      |> WeaponAssignForm.changeset(attrs)
      |> to_form()

    assign(socket, :form, form)
  end

  defp assign_weapons(socket) do
    assign_async(socket, :weapons, fn ->
      {
        :ok,
        %{
          weapons: Weapons.list_weapons()
        }
      }
    end)
  end

  defp assign_weapon_to_character(
         socket,
         %{
           changes: %{
             character_id: character_id,
             weapon_id: weapon_id
           },
           valid?: true
         } = _changeset
       ) do
    case Weapons.add_weapon_to_character(character_id, weapon_id) do
      {:ok, _} ->
        socket
        |> put_flash(:info, "Arma aggiunta con successo")
        |> push_patch(to: ~p"/admin/weapons/assign")

      {:error, _} ->
        socket
        |> put_flash(:error, "Errore durante l'aggiunta dell'arma")
        |> push_patch(to: ~p"/admin/weapons/assign")
    end
  end
end
