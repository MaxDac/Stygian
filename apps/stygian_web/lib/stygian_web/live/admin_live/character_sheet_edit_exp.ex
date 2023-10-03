defmodule StygianWeb.AdminLive.CharacterSheetEditExp do
  @moduledoc """
  Form to handle the assignation of experience points.
  """

  use StygianWeb, :live_component

  alias Stygian.Characters.CharacterExpForm

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.h2>Assegna esperienza</.h2>

      <.simple_form
        for={@form}
        id="character-exp-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <div class="flex flex-row justify-evenly">
          <.character_selection
            characters={@characters}
            field={@form[:character_id]}
            label="Personaggio"
          />

          <.input
            field={@form[:experience]}
            label="Punti Esperienza"
            type="select"
            value={1}
            options={@available_exp}
          />
        </div>

        <.button type="submit">Assegna</.button>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_available_exp()
     |> assign_form()}
  end

  @impl true
  def handle_event("validate", %{"character_exp_form" => params}, socket) do
    {:noreply, assign_form(socket, params)}
  end

  @impl true
  def handle_event("save", %{"character_exp_form" => params}, socket) do
    send_form(params)
    {:noreply, assign_form(socket)}
  end

  defp assign_available_exp(socket) do
    available_exp_points =
      -3..3
      |> Enum.map(fn
        x -> {Integer.to_string(x), x}
      end)

    assign(socket, :available_exp, available_exp_points)
  end

  defp assign_form(socket, attrs \\ %{}) do
    form =
      %CharacterExpForm{}
      |> CharacterExpForm.changeset(attrs)
      |> to_form()

    assign(socket, :form, form)
  end

  defp send_form(params) do
    send(self(), {:update_exp, params})
  end
end
