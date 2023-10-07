defmodule StygianWeb.EffectLive.FormComponent do
  use StygianWeb, :live_component

  alias Stygian.Objects

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage effect records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="effect-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:value]} type="number" label="Value" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Effect</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{effect: effect} = assigns, socket) do
    changeset = Objects.change_effect(effect)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"effect" => effect_params}, socket) do
    changeset =
      socket.assigns.effect
      |> Objects.change_effect(effect_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"effect" => effect_params}, socket) do
    save_effect(socket, socket.assigns.action, effect_params)
  end

  defp save_effect(socket, :edit, effect_params) do
    case Objects.update_effect(socket.assigns.effect, effect_params) do
      {:ok, effect} ->
        notify_parent({:saved, effect})

        {:noreply,
         socket
         |> put_flash(:info, "Effect updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_effect(socket, :new, effect_params) do
    case Objects.create_effect(effect_params) do
      {:ok, effect} ->
        notify_parent({:saved, effect})

        {:noreply,
         socket
         |> put_flash(:info, "Effect created successfully")
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
