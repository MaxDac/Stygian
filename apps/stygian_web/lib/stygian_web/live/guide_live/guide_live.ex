defmodule StygianWeb.GuideLive.GuideLive do
  @moduledoc """
  The home page of the guide.
  """

  use StygianWeb, :guide_live_view

  import StygianWeb.GuideLive.GuideComponentsLive

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"action" => action}, _uri, socket) do
    {:noreply,
     socket
     |> assign_action(String.to_atom(action))
     |> assign_menu_entries()}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply,
     socket
     |> assign_action(:introduction)
     |> assign_menu_entries()}
  end

  defp assign_menu_entries(%{assigns: %{action: action}} = socket) do
    entries =
      [
        %{title: "Introduzione", action: :introduction},
        %{title: "Ambientazione", action: :environment},
        %{title: "Creazione", action: :creation},
        %{title: "Regolamento", action: :rules},
        %{title: "Gameplay", action: :gameplay}
      ]
      |> Enum.map(&Map.put(&1, :active, &1.action == action))

    assign(socket, :menu_entries, entries)
  end

  defp assign_action(socket, action) do
    assign(socket, :action, action)
  end
end
