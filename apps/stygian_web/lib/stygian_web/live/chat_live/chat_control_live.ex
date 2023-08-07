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

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_form()}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class={@class}>
      <.simple_form
        class="p-0"
        for={@form}
        id="chat_input"
        phx-submit="send_chat_input"
        phx-target={@myself}
      >
        <.input type="hidden" field={@form[:map_id]} />
        <.input type="hidden" field={@form[:character_id]} />
        <.input type="hidden" field={@form[:type]} />
        <div class="flex flex-row justify-between">
          <div class="w-full p-5">
            <.input
              id={@textarea_id}
              field={@form[:text]}
              type="textarea"
              placeholder="Scrivi la tua azione qui..."
              phx-hook="ChatInput"
            />
          </div>

          <div class="flex flex-col max-w-10 justify-evenly">
            <.button id="chat-input-sender" phx-disable-with="Inviando..." class="w-full">
              Invia
            </.button>
            <.button type="button" disabled="true" phx-disable-with="..." class="w-full">
              Dadi
            </.button>
          </div>
        </div>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def handle_event("send_chat_input", params, socket) do
    case create_chat_entry(params) do
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

  defp assign_form(%{assigns: %{map: map, current_character: current_character}} = socket) do
    form =
      %Chat{}
      |> Maps.change_chat(%{
        map_id: map.id,
        character_id: current_character.id,
        text: nil,
        type: :text
      })
      |> to_form()

    socket
    |> assign(:form, form)
  end

  defp create_chat_entry(%{"chat" => chat_params} = _params) do
    Maps.create_chat(chat_params)
  end

  # This function sends the update to the parent live view, that in turn will update this component.
  # Please refer to the module documentation for more information.
  defp notify_parent_for_update(socket) do
    send(self(), {:chat_input_sent, %{}})
    socket
  end
end
