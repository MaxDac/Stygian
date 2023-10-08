defmodule StygianWeb.EffectLive.FormComponent do
  use StygianWeb, :live_component

  alias Stygian.Objects
  alias Stygian.Skills

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
        <.object_selection objects={@objects} field={@form[:object_id]} label="Oggetto" />

        <.skill_selection skills={@skills} field={@form[:skill_id]} label="Skill" />

        <.input field={@form[:value]} type="number" label="Value" />

        <:actions>
          <.button phx-disable-with="Salvando...">Salva effetto</.button>
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
     |> assign_objects()
     |> assign_skills()
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
    case Objects.update_effect(socket.assigns.effect, effect_params)
         |> IO.inspect(label: "save result") do
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

  defp assign_objects(socket) do
    assign_async(socket, :objects, fn ->
      {:ok,
       %{
         objects: Objects.list_objects()
       }}
    end)
  end

  defp assign_skills(socket) do
    assign_async(socket, :skills, fn ->
      {:ok,
       %{
         skills: Skills.list_skills()
       }}
    end)
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
