defmodule StygianWeb.CharacterController do
  @moduledoc """
  Controller used to populate the session with the current character after creation.
  """

  use StygianWeb, :controller

  alias Stygian.Characters

  @doc """
  This endpoint is used to add the character to the session right after its creation.
  This would normally require the user to logout and login again, but by redirecting to this controller endpoint
  from the creation completion LiveView, the flow will have access to the conn session, and it will be able to
  re-render the desired LiveView anyway using the `live_render` function.

  The function will normally try to get the character from the route params, if that does not exist, it will try to get
  the first character belonging to the user, as it's done in the login.
  """
  def handle_create(conn, %{"character_id" => character_id}) do
    # Getting the user id from the assigns populated through the browser pipeline using the fetch_current_user plug
    user_id = conn.assigns.current_user.id

    # Adding the character to the session
    if Characters.character_belongs_to_user?(character_id, user_id) do
      conn
      |> put_session(:character_id, character_id)
      |> put_flash(:info, "Il personaggio è stato creato con successo!")
      # Redirecting instead of rendering the live view directly, because this way guarantess the execution of the
      # route automatic mounts, that populates the character automatically.
      |> redirect(to: ~p"/character/sheet")
    else
      conn
      |> put_flash(
        :error,
        "C'è stato qualche problema in fase di creazione, contatta un admin per ulteriori informazioni."
      )
      |> redirect(to: ~p"/")
    end
  end

  def handle_create(conn, _params) do
    # Getting the user id from the assigns populated through the browser pipeline using the fetch_current_user plug
    user_id = conn.assigns.current_user.id

    # Adding the character to the session
    character = Characters.get_user_first_character(user_id)

    case character do
      %{id: character_id} ->
        conn
        |> put_session(:character_id, character_id)
        # Redirecting instead of rendering the live view directly, because this way guarantess the execution of the
        # route automatic mounts, that populates the character automatically.
        |> redirect(to: ~p"/character/sheet")

      _ ->
        conn
        |> put_flash(
          :error,
          "C'è stato qualche problema in fase di creazione, contatta un admin per ulteriori informazioni."
        )
        |> redirect(to: ~p"/")
    end
  end

  @doc """
  This endpoint selects the npc character for the admin, and puts it into the session.
  """
  def handle_admin_selection(%{assigns: %{current_user: %{admin: true}}} = conn, %{"character_id" => character_id}) do
    %{npc: is_npc, name: character_name} = Characters.get_character(character_id)

    if is_npc do
      conn
      |> put_session(:character_id, character_id)
      |> put_flash(:info, "Hai selezionato il personaggio #{character_name}")
      |> redirect(to: ~p"/admin/npcs")
    else
      conn
      |> put_flash(:error, "Non puoi selezionare un personaggio non npc.")
      |> redirect(to: ~p"/admin/npcs")
    end
  end
end
