defmodule StygianWeb.UserLoginLive do
  use StygianWeb, :login_live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.simple_form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="ignore">
        <.input
          field={@form[:email]}
          placeholder="Email"
          type="email"
          label="Email"
          floating
          required
        />

        <.input
          field={@form[:password]}
          placeholder="Password"
          type="password"
          label="Password"
          floating
          required
        />

        <:actions>
          <.input field={@form[:remember_me]} type="checkbox" label="Mantieni sessione" />
          <.link href={~p"/users/reset_password"} class="text-sm font-semibold text-brand">
            Recupera password
          </.link>
        </:actions>
        <:actions>
          <.button phx-disable-with="Signing in..." class="w-full">
            Log in <span aria-hidden="true">→</span>
          </.button>
        </:actions>
        <:actions>
          <div class="w-full text-center">
            <.link navigate={~p"/users/register"} class="font-semibold text-brand hover:underline">
              Registrati
            </.link>
          </div>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = live_flash(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
