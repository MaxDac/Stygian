defmodule StygianWeb.CharacterLive.CharacterCreationLive do
  use StygianWeb, :container_live_view

  alias Stygian.Characters
  alias Stygian.Characters.Character

  @impl true
  def mount(_params, _session, %{assigns: %{current_user: current_user}} = socket) do
    case Characters.get_user_character?(current_user) do
      nil ->
        form =
          %Character{}
          |> Characters.change_character_name_and_avatar(%{user_id: current_user.id})
          |> to_form()

        {:ok,
         socket
         |> assign(form: form)}

      # Character already created, redirecting to completion
      %{step: 1} ->
        {:ok,
         socket
         |> put_flash(
           :error,
           "Devi completare la creazione del personaggio prima di accedere alla sua scheda."
         )
         |> push_navigate(to: ~p"/character/complete")}

      _ ->
        {:ok,
         socket
         |> put_flash(:error, "Hai gi&agrave; creato un personaggio.")
         |> push_navigate(to: ~p"/character/sheet")}
    end
  end

  @impl true
  def handle_event("validate", params, socket) do
    %{"character" => character_params} = params

    form =
      %Character{}
      |> Characters.change_character_name_and_avatar(character_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, form: form)}
  end

  @impl true
  def handle_event("create", params, socket) do
    %{"character" => character_params} = params

    case Characters.create_character(character_params) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Personaggio creato con successo.")
         |> push_navigate(to: ~p"/character/complete")}

      {:error, changeset} ->
        form =
          changeset
          |> Map.put(:action, :create)
          |> to_form()

        {:noreply, assign(socket, form: form)}
    end
  end
end
