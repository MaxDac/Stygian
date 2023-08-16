defmodule StygianWeb.FormHelpersTest do
  @moduledoc """
  Tests the form helpers.
  """

  use ExUnit.Case

  alias StygianWeb.FormHelpers

  describe "Form Helpers tests" do
    test "sanitize_field/1 correctly strips all the HTML tags from the string" do
      inner_value = "Something"
      value = "<div style=\"color: black;\">#{inner_value}</div>"
      assert inner_value == FormHelpers.sanitize_field(value)
    end

    test "sanitize_field/1 does not strip incomplete HTML tags" do
      inner_value = "Something"
      value = "<div style=\"color: black;\"#{inner_value}</div>"
      assert "" == FormHelpers.sanitize_field(value)
    end

    test "sanitize_field/1 does not change non-string values" do
      value = 1
      assert value == FormHelpers.sanitize_field(value)
    end

    test "sanitize_fields/1 converts only the string values in the form map" do 
      inner_value = "Something"
      value = "<div style=\"color: black;\">#{inner_value}</div>"
      id = 1
      name = "Some Name"

      map = %{
        "text" => value,
        "id" => id,
        "name" => name
      }

      assert got_map = FormHelpers.sanitize_fields(map)
      assert id == got_map["id"]
      assert name == got_map["name"]
      assert inner_value == got_map["text"]
    end
  end
end
