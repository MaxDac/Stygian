defmodule StygianWeb.RestLive.CharacterRestSelectorLive do
  @moduledoc """
  This live component will handle the form to select the activities to perform during the rest.
  """

  use StygianWeb, :live_component

  import StygianWeb.RestLive.CharacterRestComponents

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)}
  end
end
