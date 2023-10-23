defmodule Stygian.StygianTest do
  use Stygian.DataCase

  describe "id_from_params/1" do
    test "correctly converts a string" do
      assert Stygian.id_from_params("1") == 1
    end

    test "correctly converts an integer" do
      assert Stygian.id_from_params(1) == 1
    end

    test "does not convert nil" do
      assert Stygian.id_from_params(nil) == nil
    end

    test "does not convert an empty string" do
      assert Stygian.id_from_params("") == nil
    end

    test "does not convert some other type" do
      assert Stygian.id_from_params(["something else"]) == nil
    end
  end
end
