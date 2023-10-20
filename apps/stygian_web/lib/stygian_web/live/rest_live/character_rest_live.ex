defmodule StygianWeb.RestLive.CharacterRestLive do
  @moduledoc """
  The live view that will allow the user to access its rest options.
  """

  use StygianWeb, :container_live_view

  alias Stygian.Characters

  alias StygianWeb.RestLive.CharacterRestSelectorLive

  @impl true
  def mount(_, _, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("simple-rest", _, socket) do
    {:noreply,
     socket
     |> handle_rest()}
  end

  @impl true
  def handle_info({:notification, message}, socket) do
    {:noreply, put_flash(socket, :info, message)}
  end

  defp handle_rest(%{assigns: %{current_character: current_character}} = socket) do
    case Characters.rest_character(current_character) do
      {:ok, character} ->
        socket
        |> assign(:current_character, character)
        |> put_flash(:info, "Hai riposato con successo.")
        |> redirect(to: ~p"/")

      {:error, error} when is_binary(error) ->
        socket
        |> put_flash(:error, error)

      {:error, _} ->
        socket
        |> put_flash(
          :error,
          "C'è stato un errore in fase di riposo, contatta un admin per maggiori informazioni."
        )
    end
  end
end
