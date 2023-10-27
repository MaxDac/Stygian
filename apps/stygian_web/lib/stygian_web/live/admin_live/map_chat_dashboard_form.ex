defmodule StygianWeb.AdminLive.MapChatDashboardForm do
  @moduledoc """
  Form component to select the map and the time range to show the chat logs.
  """

  use StygianWeb, :live_component

  alias Stygian.Maps
  alias Stygian.Maps.MapChatsSelectionForm

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_maps()
     |> assign_form()}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        id="chat_log_selection_form"
        for={@form}
        phx-target={@myself}
        phx-change="validate"
        phx-submit="submit"
      >
        <div class="w-full flex flex-row justify-between space-x-5">
          <.map_selection field={@form[:map_id]} label="Mappa" maps={@maps} />

          <.input field={@form[:date_from]} label="Da:" type="datetime-local" />

          <.input field={@form[:date_to]} label="A:" type="datetime-local" />

          <.button type="submit">
            Cerca
          </.button>
        </div>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def handle_event("validate", %{"map_chats_selection_form" => params}, socket) do
    {:noreply, assign_form(socket, params)}
  end

  @impl true
  def handle_event("submit", %{"map_chats_selection_form" => params}, socket) do
    send_form(params)
      
    # There is no reason to reset the form in this case
    {:noreply, assign_form(socket, params)}
  end

  defp assign_maps(socket) do
    assign_async(socket, :maps, fn ->
      {:ok,
       %{
         maps: Maps.list_maps()
       }}
    end)
  end

  defp assign_form(socket, attrs \\ nil)

  defp assign_form(socket, nil) do
    form =
      %MapChatsSelectionForm{}
      |> MapChatsSelectionForm.changeset(%{
        date_from: DateTime.add(DateTime.utc_now(), -1, :hour),
        date_to: DateTime.utc_now()
      })
      |> to_form()

    socket
    |> assign(:form, form)
  end

  defp assign_form(socket, attrs) do
    form =
      %MapChatsSelectionForm{}
      |> MapChatsSelectionForm.changeset(attrs)
      |> to_form()

    socket
    |> assign(:form, form)
  end

  defp send_form(params) do
    send(self(), {:filters, params})
  end
end
