defmodule StygianWeb.CharacterLive.CharacterCompletionSelectorComponent do
  use StygianWeb, :html

  alias Stygian.Skills.Skill

  attr :skill, Skill, required: true
  attr :value, :integer, required: true
  attr :kind, :atom, required: true
  attr :on_plus, :string, required: true
  attr :on_minus, :string, required: true

  def attribute_selector(assigns) do
    ~H"""
    <div class="w-full flex flex-row align-center justify-between">
      <span><%= @skill.name %>:</span>
      <div class="inline-flex rounded-md shadow-sm" role="group">
        <button
          type="button"
          phx-click={@on_minus}
          phx-value-kind={@kind}
          phx-value-skill={@skill.id}
          class="inline-flex items-center px-4 py-2 text-sm font-medium text-brand bg-transparent border border-brand rounded-l-lg hover:bg-brand hover:text-brand focus:z-10 focus:ring-2 focus:ring-brand focus:bg-brand focus:text-brand"
        >
          <svg
            class="w-[12px] h-[12px] text-brand"
            aria-hidden="true"
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 18 2"
          >
            <path
              stroke="currentColor"
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M1 1h16"
            />
          </svg>
        </button>
        <button
          type="button"
          disabled
          class="font-typewriter text-lg inline-flex items-center px-4 py-2 font-medium text-brand bg-transparent border-t border-b border-brand hover:bg-brand hover:text-brand focus:z-10 focus:ring-2 focus:ring-brand focus:bg-brand focus:text-brand"
        >
          <%= @value %>
        </button>
        <button
          type="button"
          phx-click={@on_plus}
          phx-value-kind={@kind}
          phx-value-skill={@skill.id}
          class="inline-flex items-center px-4 py-2 text-sm font-medium text-brand bg-transparent border border-brand rounded-r-md hover:bg-brand hover:text-brand focus:z-10 focus:ring-2 focus:ring-brand focus:bg-brandh focus:text-brand"
        >
          <svg
            class="w-[12px] h-[12px] text-brand"
            aria-hidden="true"
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 18 18"
          >
            <path
              stroke="currentColor"
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M9 1v16M1 9h16"
            />
          </svg>
        </button>
      </div>
    </div>
    """
  end
end
