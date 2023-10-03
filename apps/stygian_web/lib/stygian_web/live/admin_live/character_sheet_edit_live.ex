defmodule StygianWeb.AdminLive.CharacterSheetEditLive do
  @moduledoc """
  This page allows to edit the character sheet and characteristics.
  """

  use StygianWeb, :container_live_view

  alias Stygian.Characters

  alias StygianWeb.AdminLive.CharacterSheetEditExp
  alias StygianWeb.AdminLive.CharacterSheetEditStatus

  @impl true
  def mount(_, _, socket) do
    {:ok,
     socket
     |> assign_characters()}
  end

  @impl true
  def handle_info({:update, level, message}, socket) do
    {:noreply,
     socket
     |> assign(level, message)}
  end

  @impl true
  def handle_info({:update_exp, %{"character_id" => character_id} = params}, socket) do
    case Characters.assign_experience_points(character_id, params) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Esperienza assegnata con successo.")}

      {:error, _changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "C'è stato un errore nell'assegnazione dell'esperienza.")}
    end
  end

  @impl true
  def handle_info({:update_status, %{"character_id" => character_id} = params}, socket) do
    case Characters.assign_experience_points(character_id, params) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Esperienza assegnata con successo.")}

      {:error, _changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "C'è stato un errore nell'assegnazione dell'esperienza.")}
    end
  end

  defp assign_characters(socket) do
    assign_async(socket, :characters, fn ->
      {:ok,
       %{
         characters: Characters.list_characters_slim()
       }}
    end)
  end
end
