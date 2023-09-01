defmodule StygianWeb.GuideLive.GuideIntroductionLive do
  @moduledoc false

  use StygianWeb, :html

  @doc false
  def introduction(assigns) do
    ~H"""
    <.guide_p>
      Stygian &egrave; un gioco di ruolo in cui i personaggi interagiscono via chat.
    </.guide_p>
    """
  end
end
