defmodule StygianWeb.CustomVerifiedRoutesTest do
  @moduledoc """
  Tests the custom verified routes functions.
  """

  use ExUnit.Case

  alias StygianWeb.CustomVerifiedRoutes

  describe "remove_verified_route_port/1" do
    test "forces the https to the url" do
      url = "http://test"
      expected_url = "https://test"
      assert expected_url == CustomVerifiedRoutes.remove_verified_route_port(url)
    end

    test "removes the port from the url" do
      url = "https://test:4000"
      expected_url = "https://test"
      assert expected_url == CustomVerifiedRoutes.remove_verified_route_port(url)
    end

    test "removes the port and forces the https in the url" do
      url = "http://test:4000"
      expected_url = "https://test"
      assert expected_url == CustomVerifiedRoutes.remove_verified_route_port(url)
    end

    test "forces the https to the url with other sections" do
      url = "http://test/something-else"
      expected_url = "https://test/something-else"
      assert expected_url == CustomVerifiedRoutes.remove_verified_route_port(url)
    end

    test "removes the port from the url with other sections" do
      url = "https://test:4000/something-else"
      expected_url = "https://test/something-else"
      assert expected_url == CustomVerifiedRoutes.remove_verified_route_port(url)
    end

    test "removes the port and forces the https in the url with other sections" do
      url = "http://test:4000/something-else"
      expected_url = "https://test/something-else"
      assert expected_url == CustomVerifiedRoutes.remove_verified_route_port(url)
    end

    test "removes the port from the production host" do
      url = "http://realfootball.cloud:4000/something-else"
      expected_url = "https://realfootball.cloud/something-else"
      assert expected_url == CustomVerifiedRoutes.remove_verified_route_port(url)
    end
  end
end
