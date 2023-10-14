defmodule StygianWeb.ChatLive.ChatDiceThrowerLive do
  @moduledoc """
  LiveView for the dice thrower.
  """

  use StygianWeb, :live_component

  alias Stygian.Characters.DiceThrower

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_form()}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.h2>Tiro dei Dadi</.h2>

      <div class="flex flex-col justify-evenly">
        <.simple_form for={@form} phx-target={@myself} phx-submit="submit" class="space-y-3">
          <.input
            field={@form[:attribute_id]}
            label="Attributo"
            type="select"
            options={to_options(@attributes)}
          />

          <.input field={@form[:skill_id]} label="Skill" type="select" options={to_options(@skills)} />

          <.input
            field={@form[:modifier]}
            label="Modificatore"
            type="select"
            options={range_as_options(-3..3)}
          />

          <.input
            field={@form[:difficulty]}
            label="Difficoltà"
            type="select"
            options={range_as_options(10..30)}
          />

          <.button phx-disable-with="Sending..." class="w-full">
            Tira
          </.button>
        </.simple_form>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("submit", %{"dice_thrower" => params}, socket) when is_map(params) do
    changeset = DiceThrower.changeset(%DiceThrower{}, params)

    if changeset.valid? do
      insert_dice_chat(socket, params)
    else
      {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp assign_form(socket) do
    form =
      %DiceThrower{
        attribute_id: 1,
        skill_id: 1,
        modifier: 0,
        difficulty: 20
      }
      |> DiceThrower.changeset()
      |> to_form()

    assign(socket, :form, form)
  end

  defp to_options(list) do
    Enum.map(list, fn %{id: id, skill: %{name: name}} -> {name, id} end)
  end

  defp range_as_options(range) do
    Enum.map(range, fn value -> {value, value} end)
  end

  defp insert_dice_chat(socket, params) do
    params =
      params
      |> Map.new(fn {key, value} -> {String.to_atom(key), String.to_integer(value)} end)

    send(self(), {:chat_dices, params})

    {:noreply, socket}
  end
end
