defmodule StygianWeb.UserForgotPasswordLive do
  use StygianWeb, :login_live_view

  alias Stygian.Accounts

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Recupera password
        <:subtitle>Ti sarà inviato un link al tuo indirizzo di posta.</:subtitle>
      </.header>

      <.simple_form for={@form} id="reset_password_form" phx-submit="send_email">
        <.input
          field={@form[:email]}
          type="email"
          label="Email"
          floating
          required />
        <:actions>
          <.button phx-disable-with="Sending..." class="w-full">
            Invia
          </.button>
        </:actions>
        <:actions>
          <div class="w-full text-center flex justify-center space-x-5">
            <.link navigate={~p"/users/register"} class="font-semibold text-brand hover:underline">
              Registrati
            </.link>
            <.link navigate={~p"/users/log_in"} class="font-semibold text-brand hover:underline">
              Log in
            </.link>
          </div>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "user"))}
  end

  def handle_event("send_email", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_reset_password_instructions(
        user,
        &url(~p"/users/reset_password/#{&1}")
      )
    end

    info =
      "If your email is in our system, you will receive instructions to reset your password shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
