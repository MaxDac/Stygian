defmodule Stygian.Dices do
  @moduledoc """
  This module handles everything related to the dices throwing.
  """

  alias Stygian.Characters
  alias Stygian.Maps

  alias Stygian.Characters.CharacterSkill
  alias Stygian.Maps.Map, as: LandMap

  @type chat_entry_request() :: %{
          character: Character.t(),
          map: LandMap.t(),
          attribute: CharacterSkill.t(),
          skill: CharacterSkill.t(),
          modifier: integer(),
          difficulty: pos_integer()
        }

  @doc """
  Creates a chat entry for a dice throw.

  The `dice_thrower` function is a function that takes the number of faces of the dice and returns the result of the throw.
  It has been abstracted for test purposes.
  """
  @spec create_dice_throw_chat_entry(request :: chat_entry_request(), dice_thrower :: function()) ::
          {:ok, Chat.t()} | {:error, Ecto.Changeset.t()}
  def create_dice_throw_chat_entry(
        %{
          character: %{id: character_id},
          map: %{id: map_id},
          attribute: %{skill_id: attribute_id},
          skill: %{skill_id: skill_id},
          modifier: modifier,
          difficulty: difficulty
        } = request,
        dice_thrower
      ) do
    {attribute_value, skill_value} = {
      Characters.get_character_skill_effect_value(character_id, attribute_id),
      Characters.get_character_skill_effect_value(character_id, skill_id)
    }

    chat_explanation = get_chat_explanation(request)
    base = attribute_value + skill_value + modifier
    dice_result = dice_thrower.(20)

    result = base + dice_result

    {result_type, text} =
      case {dice_result, result} do
        {1, _} ->
          {:failed_dices, "ottenendo un fallimento critico"}

        {20, _} ->
          {:dices, "ottenendo un successo critico"}

        {_, n} when n < difficulty ->
          {:failed_dices, "ottenendo un fallimento"}

        _ ->
          {:dices, "ottenendo un successo"}
      end

    chat_text = "#{chat_explanation} #{text} (#{base} + #{dice_result})."

    Maps.create_chat(%{
      character_id: character_id,
      map_id: map_id,
      text: chat_text,
      type: result_type
    })
  end

  defp get_chat_explanation(%{
         attribute: %{skill: %{name: attribute_name}},
         skill: %{skill: %{name: skill_name}},
         modifier: modifier,
         difficulty: difficulty
       }) do
    modifier_text =
      case modifier do
        n when n > 0 -> " + #{n}"
        n when n < 0 -> " - #{abs(n)}"
        _ -> ""
      end

    "Ha effettuato un tiro di #{attribute_name} + #{skill_name}#{modifier_text} con Diff. #{difficulty}"
  end
end
