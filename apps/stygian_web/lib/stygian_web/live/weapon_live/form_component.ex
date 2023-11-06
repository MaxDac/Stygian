defmodule StygianWeb.WeaponLive.FormComponent do
  use StygianWeb, :live_component

  alias Stygian.Weapons

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage weapon records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="weapon-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:image_url]} type="text" label="Image url" />
        <.input field={@form[:required_skill_min_value]} type="number" label="Required skill min value" />
        <.input field={@form[:damage_bonus]} type="number" label="Damage bonus" />
        <.input field={@form[:cost]} type="number" label="Cost" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Weapon</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{weapon: weapon} = assigns, socket) do
    changeset = Weapons.change_weapon(weapon)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"weapon" => weapon_params}, socket) do
    changeset =
      socket.assigns.weapon
      |> Weapons.change_weapon(weapon_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"weapon" => weapon_params}, socket) do
    save_weapon(socket, socket.assigns.action, weapon_params)
  end

  defp save_weapon(socket, :edit, weapon_params) do
    case Weapons.update_weapon(socket.assigns.weapon, weapon_params) do
      {:ok, weapon} ->
        notify_parent({:saved, weapon})

        {:noreply,
         socket
         |> put_flash(:info, "Weapon updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_weapon(socket, :new, weapon_params) do
    case Weapons.create_weapon(weapon_params) do
      {:ok, weapon} ->
        notify_parent({:saved, weapon})

        {:noreply,
         socket
         |> put_flash(:info, "Weapon created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end