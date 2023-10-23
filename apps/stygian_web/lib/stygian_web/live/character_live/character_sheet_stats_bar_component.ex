defmodule StygianWeb.CharacterLive.CharacterSheetStatsBarComponent do
  @moduledoc """
  Contains a functional component that renders the stats bar.
  """

  use StygianWeb, :html

  @doc """
  Renders the stats bar.
  """
  attr :stat_name, :string, required: true
  attr :percentage, :float, required: true
  attr :bar_bg_color, :string, required: true
  attr :internal_text_color, :string, required: false, default: "zinc-100"
  attr :external_text_color, :string, required: false, default: "zinc-900"

  def stat_bar(assigns) do
    ~H"""
    <div class="flex flex-col justify-center">
      <p class="text-xl pt-3 font-report">
        <%= @stat_name %>
      </p>

      <div class="w-full h-6 bg-transparent rounded-full border border-zinc-700 flex flex-row">
        <div class={"h-6 rounded-full text-center #{@bar_bg_color}"} style={"width: #{@percentage}%"}>
          <span :if={@percentage >= 12.0} class={"text-#{@internal_text_color}"}>
            <%= @percentage %> %
          </span>
        </div>

        <div :if={@percentage < 12.0} class={"pl-2 text-#{@external_text_color}"}>
          <%= @percentage %> %
        </div>
      </div>
    </div>
    """
  end
end
