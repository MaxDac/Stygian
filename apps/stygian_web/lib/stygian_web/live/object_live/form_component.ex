defmodule StygianWeb.ObjectLive.FormComponent do
  use StygianWeb, :live_component

  alias Stygian.Objects

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage object records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="object-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:image_url]} type="text" label="Image url" />
        <.input field={@form[:usages]} type="number" label="Utilizzi" />
        <.input field={@form[:health]} type="number" label="Salute" />
        <.input field={@form[:sanity]} type="number" label="Sanità" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Object</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{object: object} = assigns, socket) do
    changeset = Objects.change_object(object)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"object" => object_params}, socket) do
    changeset =
      socket.assigns.object
      |> Objects.change_object(object_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"object" => object_params}, socket) do
    save_object(socket, socket.assigns.action, object_params)
  end

  defp save_object(socket, :edit, object_params) do
    case Objects.update_object(socket.assigns.object, object_params) do
      {:ok, object} ->
        notify_parent({:saved, object})

        {:noreply,
         socket
         |> put_flash(:info, "Object updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_object(socket, :new, object_params) do
    case Objects.create_object(object_params) do
      {:ok, object} ->
        notify_parent({:saved, object})

        {:noreply,
         socket
         |> put_flash(:info, "Object created successfully")
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
