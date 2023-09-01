defmodule StygianWeb.GuideLive.GuideRulesLive do
  @moduledoc false

  use StygianWeb, :html

  def rules(assigns) do
    ~H"""
    <.guide_p>
      Regolamento
    </.guide_p>
    """
  end
end
