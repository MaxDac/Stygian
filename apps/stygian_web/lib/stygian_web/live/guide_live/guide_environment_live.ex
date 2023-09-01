defmodule StygianWeb.GuideLive.GuideEnvironmentLive do
  @moduledoc false

  use StygianWeb, :html

  def environment(assigns) do
    ~H"""
    <.guide_p>
      Ambientazione
    </.guide_p>
    """
  end
end
