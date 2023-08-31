defmodule StygianWeb.UserRegistrationLive do
  use StygianWeb, :login_live_view

  alias Stygian.Accounts
  alias Stygian.Accounts.User

  import StygianWeb.UserRegistrationDisclaimer

  @impl true
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Registrazione dell'utente
        <:subtitle>
          Già registrato?
          <.link navigate={~p"/users/log_in"} class="font-semibold text-brand hover:underline">
            Log in
          </.link>
          <br />
          <.link phx-click="open_disclaimer" class="font-semibold text-brand hover:underline">
            Disclaimer
          </.link>
        </:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="registration_form"
        phx-submit="save"
        phx-change="validate"
        phx-trigger-action={@trigger_submit}
        action={~p"/users/log_in?_action=registered"}
        method="post"
      >
        <.error :if={@check_errors}>
          C'è stato un errore in fase di registrazione, controlla gli errori o contatta un admin su Discord.
        </.error>

        <.input field={@form[:email]} type="email" label="Email" floating required />

        <.input field={@form[:username]} label="Username" floating required />

        <.input field={@form[:password]} type="password" label="Password" floating required />

        <:actions>
          <.button phx-disable-with="Creating account..." class="w-full">Crea un account</.button>
        </:actions>
      </.simple_form>

      <.modal
        :if={@show_disclaimer}
        id="dice-thrower-modal"
        show
      >
        <.disclaimer />
      </.modal>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_disclaimer_state()
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Accounts.change_user_registration(user)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  @impl true
  def handle_event("open_disclaimer", _, socket) do
    {:noreply, assign(socket, :show_disclaimer, true)}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end

  defp assign_disclaimer_state(socket) do
    assign(socket, :show_disclaimer, false)
  end
end
