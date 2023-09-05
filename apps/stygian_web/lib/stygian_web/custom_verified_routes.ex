defmodule StygianWeb.CustomVerifiedRoutes do
  @moduledoc """
  Adds new functions that allows managing the result of the verified routes.
  """

  @http_url_match ~r/(https?:\/\/.*)(:\d*)\/?(.*)/

  @doc """
  Transforms the url by stripping the port and substituting `http` with `https`.
  This will be done only on production.
  """
  @spec remove_verified_route_port(verified_route :: String.t()) :: String.t()
  def remove_verified_route_port(verified_route)

  def remove_verified_route_port("http://" <> rest),
    do: remove_verified_route_port("https://" <> rest)

  def remove_verified_route_port(verified_route) when is_binary(verified_route) do
    case Regex.run(@http_url_match, verified_route) do
      [_, host, _, ""] -> host
      [_, host, _, rest] -> "#{host}/#{rest}"
      # No match, the verified_route will be considered well formed but without a port.
      _ -> verified_route
    end
  end
end
