defmodule StygianWeb.ChatLive.ChatLive do
  @moduledoc """
  This live view will render both the chat screen and the chat input.

  There was an issue with the reset of the textarea, where, when the chat input was sent, the textarea could not reset
  as the component didn't need the update.

  To force the update, the component will send a message to the genserver, that is the same of this live view that
  renders it, in order for this live view to update the id of the textarea, forcing the update of the component.

  This workaround prevented using JavaScript to update the state from the client.
  """

  use StygianWeb, :container_live_view

  require Logger

  alias Stygian.Characters
  alias Stygian.Maps

  alias StygianWeb.ChatLive.ChatCharacterResumeLive
  alias StygianWeb.ChatLive.ChatControlLive
  alias StygianWeb.ChatLive.ChatDiceThrowerLive
  alias StygianWeb.ChatLive.ChatHelpers
  alias StygianWeb.ChatLive.ObjectUsageLive
  alias StygianWeb.Presence

  import StygianWeb.ChatLive.ChatEntryLive

  @event_name_chat_created "chat_created"

  @doc """
  Returns the chat created event.
  """
  def get_event_chat_created, do: @event_name_chat_created

  @impl true
  def mount(%{"map_id" => map_id}, _session, socket) do
    {:ok,
     socket
     |> assign_map(map_id)
     |> assign(:show_dice_thrower, false)
     |> assign(:show_object_usage, false)
     |> assign(:show_character_resume, false)
     |> update_presence()
     |> assign_chat_entries(Maps.list_map_chats(map_id))
     |> assign_character_skills()
     |> ChatHelpers.subscribe_to_chat_events(map_id)
     |> assign_textarea_id()
     |> assign_dice_button_id()
     |> assign_use_object_id()
     |> assign_character_resume_id()
     |> check_private_room_allowance()}
  end

  @impl true
  def handle_info(%{event: @event_name_chat_created, payload: chat_entry}, socket) do
    {:noreply,
     socket
     |> assign_new_chat_entry(chat_entry)}
  end

  @impl true
  def handle_info({:chat_input_sent, _}, %{assigns: %{map: %{id: map_id}}} = socket) do
    send_update(ChatControlLive, id: map_id, textarea_id: new_textarea_id())
    {:noreply, socket}
  end

  @impl true
  def handle_info(:close_modal, socket) do
    {:noreply,
     socket
     |> assign(:show_dice_thrower, false)
     |> assign(:show_object_usage, false)
     |> assign(:show_character_resume, false)
     |> assign_dice_button_id()
     |> assign_use_object_id()
     |> assign_character_resume_id()}
  end

  # This is called when the dice thrower modal is closed
  @impl true
  def handle_info({:chat_dices, params}, socket) do
    {:noreply,
     socket
     |> add_dice_chat(params)
     |> assign_resetted_modal_state()}
  end

  @impl true
  def handle_info({:update_status, %{"character_id" => character_id} = params}, socket) do
    case Characters.assign_character_status(character_id, params) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Status cambiato con successo.")
         |> assign_resetted_modal_state()}

      {:error, _changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "C'è stato un errore nel cambio dello status del personaggio.")
         |> assign_resetted_modal_state()}
    end
  end

  # Dice button clicked
  @impl true
  def handle_event("open_dices", _params, socket) do
    {:noreply,
     socket
     |> assign(:show_dice_thrower, true)}
  end

  # Object button clicked
  @impl true
  def handle_event("open_objects", _params, socket) do
    {:noreply,
     socket
     |> assign(:show_object_usage, true)}
  end

  @impl true
  def handle_event("use_object", %{"id" => id}, %{assigns: %{map: %{id: map_id}}} = socket) do
    with {:ok, %{character_object: character_object}} <- Characters.use_object(id),
         {:ok, socket} <- add_use_object_chat(socket, character_object) do
      send_update(ChatControlLive, id: map_id, textarea_id: new_textarea_id())

      {:noreply,
       socket
       |> assign(:show_object_usage, false)
       |> assign_use_object_id()}
    else
      {:error, error} when is_binary(error) ->
        {:noreply,
         socket
         |> put_flash(:error, error)
         |> assign(:show_object_usage, false)
         |> assign_use_object_id()}

      _ ->
        {:noreply,
         socket
         |> put_flash(:error, "C'è stato un errore durante l'utilizzo dell'oggetto.")
         |> assign(:show_object_usage, false)
         |> assign_use_object_id()}
    end
  end

  @impl true
  def handle_event(
        "smoke_cig",
        _params,
        %{
          assigns: %{
            map: %{id: map_id},
            current_character: %{id: character_id}
          }
        } = socket
      ) do
    with {:ok, _} <- Characters.smoke_cig(character_id),
         {:ok, socket} <- add_smoke_cig_chat(socket) do
      send_update(ChatControlLive, id: map_id, textarea_id: new_textarea_id())

      {:noreply,
       socket
       |> assign(:show_object_usage, false)
       |> assign_use_object_id()
       |> push_navigate(to: ~p"/chat/#{map_id}")}
    else
      {:error, error} when is_binary(error) ->
        {:noreply,
         socket
         |> put_flash(:error, error)
         |> assign(:show_object_usage, false)
         |> assign_use_object_id()}

      _ ->
        {:noreply,
         socket
         |> put_flash(:error, "C'è stato un errore nell'attuare l'azione selezionata.")
         |> assign(:show_object_usage, false)
         |> assign_use_object_id()}
    end
  end

  @impl true
  def handle_event("open_character_resume", %{"character_id" => character_id}, socket) do
    {:noreply,
     socket
     |> assign_updated_resume_character_id(character_id)
     |> assign(:show_character_resume, true)}
  end

  @impl true
  def handle_params(%{"map_id" => map_id}, _, socket) do
    {:noreply,
     socket
     |> assign_map(map_id)
     # Updates the random number passed down with the component id to the live component to force it to update.
     |> assign_dice_button_id()
     |> assign_use_object_id()
     |> assign_character_resume_id()
     |> assign(:show_dice_thrower, false)
     |> assign(:show_object_usage, false)}
  end

  defp assign_new_chat_entry(%{assigns: %{chat_entries: chat_entries}} = socket, chat_entry) do
    assign_chat_entries(socket, chat_entries ++ [chat_entry])
  end

  defp assign_chat_entries(socket, chats) do
    assign(socket, :chat_entries, chats)
  end

  defp assign_map(socket, map_id) do
    map = Maps.get_map!(map_id)
    assign(socket, map: map)
  end

  defp assign_character_skills(%{assigns: %{current_character: %{id: character_id} = character}} = socket) when not is_nil(character_id) do
    {attributes, skills} =
      Characters.list_character_attributes_skills(character)

    socket
    |> assign(:attributes, attributes)
    |> assign(:skills, skills)
  end

  # This clause matches the admins that didn't select a NPC
  defp assign_character_skills(socket) do
    socket
    |> assign(:attributes, [])
    |> assign(:skills, [])
  end

  defp assign_textarea_id(socket) do
    assign(socket, :textarea_id, new_textarea_id())
  end

  defp assign_dice_button_id(socket) do
    assign(socket, :dice_button_id, new_dice_button_id())
  end

  defp assign_use_object_id(socket) do
    assign(socket, :use_object_id, new_use_object_id())
  end

  defp assign_character_resume_id(socket) do
    assign(socket, :character_resume_id, new_character_resume_id())
  end

  defp assign_updated_resume_character_id(socket, character_id) do
    assign(socket, :resume_character_id, character_id)
  end

  defp add_dice_chat(
         %{
           assigns: %{
             current_character: character,
             map: map,
             attributes: attributes,
             skills: skills
           }
         } = socket,
         %{
           attribute_id: attribute_id,
           skill_id: skill_id,
           modifier: modifier,
           difficulty: difficulty
         } = _params
       ) do
    attribute = Enum.find(attributes, fn a -> a.id == attribute_id end)
    skill = Enum.find(skills, fn s -> s.id == skill_id end)

    request = %{
      character: character,
      map: map,
      attribute: attribute,
      skill: skill,
      modifier: modifier,
      difficulty: difficulty
    }

    dice_thrower = &:rand.uniform/1

    case Maps.create_dice_throw_chat_entry(request, dice_thrower) do
      {:ok, chat} ->
        send_update(ChatControlLive, id: map.id)

        socket
        |> ChatHelpers.handle_chat_created(chat)

      error ->
        Logger.error("Error while registering chat: #{inspect(error)}")

        socket
        |> put_flash(:error, "Errore durante l'inserimento del messaggio.")
    end
  end

  defp add_use_object_chat(
         %{
           assigns: %{
             current_character: %{
               id: character_id
             },
             map: %{
               id: map_id
             }
           }
         } = socket,
         character_object
       ) do
    with {:ok, chat_entry} <-
           Maps.create_chat(%{
             map_id: map_id,
             character_id: character_id,
             text: "Ha usato #{character_object.object.name}",
             type: :special
           }) do
      {:ok, ChatHelpers.handle_chat_created(socket, chat_entry)}
    end
  end

  defp add_smoke_cig_chat(
         %{
           assigns: %{
             current_character: %{
               id: character_id
             },
             map: %{
               id: map_id
             }
           }
         } = socket
       ) do
    with {:ok, chat_entry} <-
           Maps.create_chat(%{
             map_id: map_id,
             character_id: character_id,
             text: "Si è acceso una sigaretta.",
             type: :special
           }) do
      {:ok, ChatHelpers.handle_chat_created(socket, chat_entry)}
    end
  end

  defp check_private_room_allowance(%{assigns: %{current_user: %{admin: true}}} = socket),
    do: socket

  defp check_private_room_allowance(
         %{
           assigns: %{
             map: %{id: map_id, private: true},
             current_character: %{id: current_character_id}
           }
         } = socket
       ) do
    if Maps.is_character_allowed?(map_id, current_character_id) do
      socket
    else
      socket
      |> put_flash(:error, "Non puoi accedere a questa stanza")
      |> push_navigate(to: ~p"/")
    end
  end

  defp assign_resetted_modal_state(socket) do
    socket
    |> assign(:show_dice_thrower, false)
    |> assign(:show_object_usage, false)
    |> assign(:show_character_resume, false)
    |> assign_dice_button_id()
    |> assign_use_object_id()
    |> assign_character_resume_id()
  end

  defp check_private_room_allowance(socket), do: socket

  defp new_textarea_id, do: "textarea-id-#{:rand.uniform(10)}"

  defp new_dice_button_id, do: "dice-button-id-#{:rand.uniform(10)}"

  defp new_use_object_id, do: "use-object-button-id-#{:rand.uniform(10)}"

  defp new_character_resume_id, do: "character-resume-id-#{:rand.uniform(10)}"

  defp update_presence(
         %{
           assigns: %{
             current_user: current_user,
             current_character: current_character,
             map: map
           }
         } = socket
       ) do
    if connected?(socket) do
      Presence.track_user(self(), current_user, current_character, map, true)
    end

    socket
  end
end
