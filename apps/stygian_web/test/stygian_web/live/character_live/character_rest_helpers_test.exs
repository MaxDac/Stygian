defmodule StygianWeb.CharacterLive.CharacterRestHelpersTest do
  use StygianWeb.ConnCase

  import StygianWeb.RestLive.CharacterRestHelpers
  alias Stygian.Rest.RestAction

  describe "CharacterRestHelpers" do
    test "get_resume_state/2 correctly compute the resumed state" do
      state = [
        %RestAction{
          id: 1,
          name: "Rest",
          slots: 2
        },
        %RestAction{
          id: 2,
          name: "Read",
          slots: 2
        },
      ]

      assert get_resume_state(state, 5) == ["Rest", "Rest", "Read", "Read", nil]
    end
  end
end
