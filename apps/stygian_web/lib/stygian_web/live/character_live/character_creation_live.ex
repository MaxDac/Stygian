defmodule StygianWeb.CharacterLive.CharacterCreationLive do
  use StygianWeb, :container_live_view

  alias Stygian.Characters
  alias Stygian.Characters.Character

  @impl true
  def mount(
        _params,
        _session,
        %{assigns: %{current_user: %{confirmed_at: confirmed_at} = current_user}} = socket
      )
      when not is_nil(confirmed_at) do
    case Characters.get_user_character?(current_user) do
      nil ->
        form =
          %Character{}
          |> Characters.change_character_name_and_avatar(%{user_id: current_user.id})
          |> to_form()

        {:ok,
         socket
         |> assign_ages()
         |> assign(form: form)}

      # Character already created, redirecting to completion
      %{step: 1} ->
        {:ok,
         socket
         # Removed as it's not an error.
         # |> put_flash(
         #   :error,
         #   "Devi completare la creazione del personaggio prima di accedere alla sua scheda."
         # )
         |> push_navigate(to: ~p"/character/complete")}

      _ ->
        {:ok,
         socket
         |> put_flash(:error, "Hai gi&agrave; creato un personaggio.")
         |> push_navigate(to: ~p"/character/sheet")}
    end
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> put_flash(:error, "Devi confermare la tua email prima di poter creare un personaggio.")
     |> push_navigate(to: ~p"/")}
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

  defp assign_ages(socket) do
    ages = [
      {"Adulto", :adult},
      {"Giovane (potrai selezionare più attributi, ma meno skill)", :young},
      {"Mezza Età (potrai selezionare più skills, ma meno attributi)", :old}
    ]

    assign(socket, :ages, ages)
  end
end
