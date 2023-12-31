defmodule StygianWeb.Presence do
  @moduledoc """
  The presence implementation for the current project, with a list of helpers to manage the characters
  in the online list.
  """

  use Phoenix.Presence,
    otp_app: :stygian_web,
    pubsub_server: StygianWeb.PubSub

  alias StygianWeb.Presence

  require Logger

  @user_activity_topic "user_activity"

  def get_online_topic, do: @user_activity_topic

  def init(_opts) do
    {:ok, %{}}
  end

  @doc """
  Tracks the user around the map pages.
  """
  def track_user(pid, user, character, map \\ nil, is_chat \\ false)

  def track_user(pid, user, character, map, is_chat) when is_map(character) do
    %{id: character_id} = character = Map.put(character, :user, user)

    Presence.track(
      pid,
      @user_activity_topic,
      character_id,
      %{
        character: map_character(character),
        map: map_map(map, is_chat)
      }
    )
  end

  def track_user(_, _, _, _, _), do: {:error, "No character created."}

  def list_users do
    Presence.list(@user_activity_topic)
    |> map_presences()
  end

  def handle_metas(topic, _diff, presences, state) do
    # Manually broadcasting the event, as it's not being broadcasted apparently.
    presences =
      presences
      |> map_presences()

    StygianWeb.Endpoint.broadcast(topic, "presence_diff", presences)
    {:ok, state}
  end

  defp map_map(%{id: map_id, name: map_name}, is_chat),
    do: %{id: map_id, name: map_name, is_chat: is_chat}

  defp map_map(_, _), do: %{id: nil, name: "Mappa principale", is_chat: false}

  defp map_presences(presences) do
    presences
    |> Map.to_list()
    |> Enum.map(&map_onlines/1)
    |> Enum.reduce(%{}, &match_presence/2)
  end

  defp match_presence(%{map: %{name: map_name} = character_map, character: character}, map) do
    if Map.has_key?(map, map_name) do
      info = map[map_name]
      Map.replace(map, map_name, [%{character: character, map: character_map} | info])
    else
      Map.put(map, map_name, [%{character: character, map: character_map}])
    end
  end

  defp match_presence(wrong_match, map) do
    Logger.error("Error while mapping presences: #{inspect(wrong_match)}")
    map
  end

  defp map_character(%{
         id: character_id,
         name: character_name,
         user: character_user,
         avatar: character_avatar,
         small_avatar: character_small_avatar
       }),
       do: %{
         id: character_id,
         name: character_name,
         user: map_user(character_user),
         avatar: character_small_avatar || character_avatar
       }

  defp map_user(%{id: user_id, username: user_name}), do: %{id: user_id, name: user_name}

  defp map_onlines({_, %{metas: [%{character: character, map: map} | _]}}) do
    %{
      map: map,
      character: character
    }
  end

  defp map_onlines({_, [%{character: character, map: map} | _]}) do
    %{
      map: map,
      character: character
    }
  end
end
