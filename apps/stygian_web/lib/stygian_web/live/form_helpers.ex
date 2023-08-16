defmodule StygianWeb.FormHelpers do
  @moduledoc """
  A collection of helpers for the HTML forms. 
  """

  @doc """
  Sanitizes all the fields in a form attributes.
  """
  @spec sanitize_fields(map :: term()) :: term()
  def sanitize_fields(map)

  def sanitize_fields(map) when is_map(map) do
    Map.new(map, fn {key, value} -> {key, sanitize_field(value)} end)
  end

  def sanitize_fields(other), do: other

  @doc """
  Sanitizes the field by stripping HTML tags from it.
  """
  @spec sanitize_field(field :: term()) :: term()
  def sanitize_field(field)

  def sanitize_field(field) when is_binary(field) do
    HtmlSanitizeEx.basic_html(field)
  end

  def sanitize_field(field), do: field
end
