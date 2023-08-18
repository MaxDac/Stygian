defmodule StygianWeb.ChatLive.BookPrivateRoomLive do
  @moduledoc """
  Books a private room for the character and its guests.
  """

  use StygianWeb, :container_live_view

  alias Stygian.Characters
  alias Stygian.Maps
  alias Stygian.Maps.BookPrivateRoomRequest

  @impl true
  def mount(%{"map_id" => map_id}, _session, socket) do
    {:ok,
     socket
     |> assign_map(String.to_integer(map_id))}
  end

  @impl true
  def handle_event(
        "book",
        %{"book_private_room_request" => params},
        %{
          assigns: %{
            current_character: %{id: host_id},
            map: %{id: map_id}
          }
        } = socket
      ) do
    changeset =
      %BookPrivateRoomRequest{}
      |> BookPrivateRoomRequest.changeset(params)

    if changeset.valid? do
      character_ids =
        params
        |> Map.values()
        |> Enum.filter(fn
          "" -> false
          nil -> false
          p -> p
        end)
        |> Enum.map(&String.to_integer/1)
        |> MapSet.new()
        |> Enum.to_list()

      case Maps.book_private_room(map_id, host_id, character_ids) do
        :ok ->
          {:noreply,
           socket
           |> put_flash(:info, "Stanza prenotata per le prossime 3 ore")
           |> push_navigate(to: ~p"/chat/#{map_id}")}

        {:error, _changeset} ->
          {:noreply,
           socket
           |> put_flash(
             :info,
             "C'e' stato un errore nella prenotazione, contattare un admin per maggiori informazioni"
           )}
      end
    end
  end

  defp assign_map(%{assigns: %{current_character: %{id: current_character_id}}} = socket, map_id) do
    map =
      Maps.list_private_rooms()
      |> Enum.find(&(&1.id == map_id && &1.status == :free))

    is_character_host? =
      Maps.character_is_already_host?(current_character_id)

    case {map, is_character_host?} do
      {nil, _} ->
        socket
        |> put_flash(:error, "La stanza privata e' gia' occupata")
        |> push_navigate(to: ~p"/map/private")

      {_, true} ->
        socket
        |> put_flash(:error, "Hai gia' prenotato un'altra stanza.")
        |> push_navigate(to: ~p"/map/private")

      _ ->
        form =
          %BookPrivateRoomRequest{}
          |> BookPrivateRoomRequest.changeset(%{})
          |> to_form()

        characters =
          Characters.list_characters()
          |> Enum.filter(&(&1.id != current_character_id))

        socket
        |> assign(:map, map)
        |> assign(:characters, characters)
        |> assign(:form, form)
    end
  end
end
