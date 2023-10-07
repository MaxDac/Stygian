defmodule StygianWeb.ChatLive.ChatControlLive do
  @moduledoc """
  This live component is responsible for rendering the chat input form and handling the chat input submission.

  In order to reset the state after the chat entry is sent, an update will be sent to the parent live view to update
  this component externally.

  To update the textarea in particular, having that the liveview only updates what's needed and nothing more,
  the ID of the textarea is set from the assigns. This way, the parent live view can update the ID assigned to
  the textarea, forcing it to re-render only in response to the update sent by this component, avoiding updates
  when the chat screen will update in response of external events.
  """
  use StygianWeb, :live_component

  alias Stygian.Maps
  alias Stygian.Maps.Chat

  alias StygianWeb.ChatLive.ChatHelpers
  alias StygianWeb.FormHelpers

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(assigns)}
  end

  @impl true
  def handle_event("send_chat_input", %{"chat" => chat_params}, socket) do
    case chat_params |> parse_input(socket) |> create_chat_entry() do
      {:ok, chat_entry} ->
        {:noreply,
         socket
         |> ChatHelpers.handle_chat_created(chat_entry)
         |> notify_parent_for_update()}

      {:error, _} ->
        {:noreply,
         socket
         |> put_flash(:error, "Errore durante l'invio del messaggio.")}
    end
  end

  @impl true
  def handle_event("validate_input", %{"chat" => chat_params}, %{} = socket) do
    chat_params =
      chat_params
      |> parse_input(socket)

    form =
      %Chat{}
      |> Maps.change_chat(chat_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, :form, form)}
  end

  defp assign_form(socket, %{map: map, current_character: current_character} = assigns) do
    assign_form(socket, map, current_character)
  end

  defp assign_form(%{assigns: %{map: map, current_character: current_character}} = socket, assigns) do
    assign_form(socket, map, current_character)
  end

  defp assign_form(socket, map, character) do
    form =
      %Chat{}
      |> Maps.change_chat(%{
        map_id: map.id,
        character_id: character.id,
        text: nil,
        type: :text
      })
      |> to_form()

    assign(socket, :form, form)
  end

  defp create_chat_entry(chat_params) do
    chat_params
    |> FormHelpers.sanitize_fields()
    |> Maps.create_chat()
  end

  # This function sends the update to the parent live view, that in turn will update this component.
  # Please refer to the module documentation for more information.
  defp notify_parent_for_update(socket) do
    send(self(), {:chat_input_sent, %{}})
    socket
  end

  # Parses the input of the chat to determine which type of chat entry to create.
  defp parse_input(
         %{"text" => "***" <> chat_input} = attrs,
         %{assigns: %{current_user: %{admin: true}}} = _socket
       ),
       do:
         attrs
         |> Map.put("text", chat_input)
         |> Map.put("type", :master)

  defp parse_input(%{"text" => "+ " <> chat_input} = attrs, _),
    do:
      attrs
      |> Map.put("text", chat_input)
      |> Map.put("type", :off)

  defp parse_input(attrs, _),
    do:
      attrs
      |> Map.put("type", :text)

  defp dices_active?(nil), do: false
  defp dices_active?(_), do: true
end
