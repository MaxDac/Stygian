defmodule StygianWeb.ChatLive.ChatControlLive do
  use StygianWeb, :live_component

  alias Stygian.Maps
  alias Stygian.Maps.Chat

  alias StygianWeb.ChatLive.ChatHelpers

  @impl true
  def update(assigns, socket) do
    {:ok,
      socket
      |> assign(assigns)
      |> assign_form()
    }
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class={@class}>
      <.simple_form for={@form} id="chat_input" phx-submit="send_chat_input" phx-target={@myself}>
        <.input type="hidden" field={@form[:map_id]} />
        <.input type="hidden" field={@form[:character_id]} />
        <.input type="hidden" field={@form[:type]} />
        <.input
          field={@form[:text]}
          type="textarea"
          placeholder="Scrivi la tua azione qui..."
          label="Chat" />

        <.button phx-disable-with="Sending..." class="w-full">
          Invia
        </.button>
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
          |> assign_form()
        }

      {:error, _} ->
        {:noreply,
          socket
          |> put_flash(:error, "Errore durante l'invio del messaggio.")
          |> assign_form()
        }
    end
  end

  defp assign_form(%{assigns: %{map: map, current_character: current_character}} = socket) do
    form =
      %Chat{}
      |> Maps.change_chat(%{
        map_id: map.id,
        character_id: current_character.id,
        type: :text
      })
      |> to_form()

    assign(socket, :form, form)
  end

  defp create_chat_entry(%{"chat" => chat_params} = _params) do
    Maps.create_chat(chat_params)
  end
end
