defmodule StygianWeb.CharacterLive.CharacterSheetUpdateLive do
  @moduledoc """
  This LiveView updates the character notes information.
  """

  use StygianWeb, :container_live_view

  alias Stygian.Characters

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_form()}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.h1>Modifica Scheda</.h1>

    <div class="text-center">
      <.link navigate={~p"/character/sheet"} class="font-report text-lg text-brand">
        Torna alla scheda
      </.link>
    </div>

    <.simple_form class="space-y-5" for={@form} phx-submit="update" phx-change="validate">
      <.input type="textarea" label="Biografia" field={@form[:biography]} phx-debounce="blur" />

      <.input type="textarea" label="Descrizione" field={@form[:description]} phx-debounce="blur" />

      <.input type="textarea" label="Note" field={@form[:notes]} phx-debounce="blur" />

      <.input field={@form[:avatar]} label="Avatar" phx-debounce="500" />

      <.input field={@form[:small_avatar]} label="Avatar per la Chat" phx-debounce="500" />

      <.button>Salva</.button>
    </.simple_form>
    """
  end

  @impl true
  def handle_event(
        "validate",
        %{"character" => character_params},
        %{assigns: %{current_character: current_character}} = socket
      ) do
    form =
      current_character
      |> Characters.change_character_notes(character_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, :form, form)}
  end

  @impl true
  def handle_event(
        "update",
        %{"character" => character_params},
        %{assigns: %{current_character: current_character}} = socket
      ) do
    case Characters.update_character_sheet(current_character, character_params) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Scheda aggiornata con successo.")
         |> push_navigate(to: ~p"/character/sheet")}

      {:error, changeset} ->
        form =
          changeset
          |> Map.put(:action, :update)
          |> to_form()

        {:noreply, assign(socket, :form, form)}
    end
  end

  defp assign_form(%{assigns: %{current_character: current_character}} = socket) do
    form =
      current_character
      |> Characters.change_character_notes()
      |> to_form()

    assign(socket, form: form)
  end
end
