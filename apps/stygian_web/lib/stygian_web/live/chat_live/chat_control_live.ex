defmodule StygianWeb.ChatLive.ChatControlLive do
  use StygianWeb, :live_component

  alias Stygian.Maps
  alias Stygian.Maps.Chat

  def update(assigns, socket) do
    {:ok,
      socket
      |> assign(assigns)
      |> assign_form()
    }
  end

  def render(assigns) do
    ~H"""
    <div>
      <.simple_form for={@form} id="chat_input" phx-submit="send_chat_input" phx-target={@myself}>
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
    IO.inspect(params, label: "the form params with myself specified")
    {:noreply, socket}
  end

  defp assign_form(%{assigns: %{map: map, current_character: current_character}} = socket) do
    form =
      %Chat{}
      |> Maps.change_chat(%{map_id: map.id, character_id: current_character.id})
      |> to_form()

    assign(socket, :form, form)
  end
end
