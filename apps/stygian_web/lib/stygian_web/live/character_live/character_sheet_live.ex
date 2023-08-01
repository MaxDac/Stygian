defmodule StygianWeb.CharacterLive.CharacterSheetLive do
  use StygianWeb, :container_live_view

  alias Stygian.Characters

  @impl true
  def mount(_params, _session, socket) do
    case Characters.get_user_character?(socket.assigns.current_user) do
      nil -> {:ok,
        socket
        |> put_flash(:error, "Devi creare un personaggio prima di accedere alla sua scheda.")
        |> push_navigate(to: ~p"/character/create")}

      %{step: 1} -> {:ok,
        socket
        |> put_flash(:error, "Devi completare la creazione del personaggio prima di accedere alla sua scheda.")
        |> push_navigate(to: ~p"/character/complete")}

      character -> {:ok, assign(socket, :character, character)}
    end
  end
end
