defmodule StygianWeb.AdminLive.TransactionsListFilters do
  @moduledoc """
  Collection of filters for the transactions page.
  """

  use StygianWeb, :live_component

  alias Stygian.Characters
  alias Stygian.Transactions.AdminListFilters

  @impl true
  def render(assigns) do
    ~H"""
    <div class="p-3">
      <.simple_form for={@form} id="transactions-list-filters" phx-target={@myself} phx-change="apply">
        <div class="flex flex-row space-x-5 justify-between">
          <.character_selection
            field={@form[:character_id]}
            label="Personaggio"
            characters={@characters}
          />

          <.input field={@form[:date_from]} label="Da:" type="datetime-local" />

          <.input field={@form[:date_to]} label="A:" type="datetime-local" />
        </div>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_characters()
     |> assign_form()}
  end

  @impl true
  def handle_event("apply", %{"admin_list_filters" => params}, socket) do
    %{changes: changes} =
      changeset =
      %AdminListFilters{}
      |> AdminListFilters.changeset(params)

    if changeset.valid? do
      send(self(), {:apply, changes})
      {:noreply, assign_form(socket, changeset)}
    else
      {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, changeset \\ nil) do
    form =
      if is_nil(changeset) do
        %AdminListFilters{
          date_from: NaiveDateTime.utc_now(),
          date_to: NaiveDateTime.add(NaiveDateTime.utc_now(), -24, :hour)
        }
        |> AdminListFilters.changeset()
      else
        changeset
      end
      |> to_form()
      |> IO.inspect(label: "form")

    assign(socket, :form, form)
  end

  defp assign_characters(socket) do
    assign_async(socket, :characters, fn ->
      {:ok,
       %{
         characters: Characters.list_characters_slim()
       }}
    end)
  end
end
