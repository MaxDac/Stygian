defmodule StygianWeb.CharacterLive.CharacterCompletionLive do
  use StygianWeb, :container_live_view

  alias Stygian.Characters
  alias Stygian.Characters.Character

  @impl true
  def mount(_params, _session, socket = %{assigns: %{current_user: current_user}}) do
    case Characters.get_user_character?(current_user) do
      %{step: 1} ->
        form =
          %Character{}
          |> Characters.change_character_name_and_avatar(%{user_id: current_user.id})
          |> to_form()

        {:ok,
          socket
          |> assign(form: form)
        }

      # Character already created, redirecting to completion
      %{step: 2} ->
        {:ok,
          socket
          |> put_flash(:info, "Hai gi&agrave; completato la creazione del personaggio.")
          |> push_navigate(to: ~p"/character/sheet")}

      _ ->
        {:ok,
          socket
          |> put_flash(:error, "Troppo presto! Devi prima fornire le informazioni generali sul personaggio.")
          |> push_navigate(to: ~p"/character/create")}
    end
  end
end
