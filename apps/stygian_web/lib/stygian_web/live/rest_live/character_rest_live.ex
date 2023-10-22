defmodule StygianWeb.RestLive.CharacterRestLive do
  @moduledoc """
  The live view that will allow the user to access its rest options.
  """

  use StygianWeb, :container_live_view

  alias Stygian.Rest

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

  @doc """
  This message is being sent from the complex rest component.
  """
  @impl true
  def handle_info({:complex_rest, actions}, socket) do
    {:noreply, handle_complex_rest(socket, actions)}
  end

  defp handle_rest(%{assigns: %{current_character: current_character}} = socket) do
    current_character
    |> Rest.rest_character()
    |> handle_rest_result(socket)
  end

  defp handle_complex_rest(%{assigns: %{current_character: current_character}} = socket, actions) do
    current_character
    |> Rest.rest_character_complex(actions)
    |> handle_rest_result(socket)
  end

  defp handle_rest_result({:ok, character}, socket),
    do:
      socket
      |> assign(:current_character, character)
      |> put_flash(:info, "Hai riposato con successo.")
      |> redirect(to: ~p"/")

  defp handle_rest_result({:error, error}, socket) when is_binary(error),
    do:
      socket
      |> put_flash(:error, error)

  defp handle_rest_result({:error, _}, socket),
    do:
      socket
      |> put_flash(
        :error,
        "C'è stato un errore in fase di riposo, contatta un admin per maggiori informazioni."
      )
end
