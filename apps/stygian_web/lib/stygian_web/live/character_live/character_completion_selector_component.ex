defmodule StygianWeb.CharacterLive.CharacterCompletionSelectorComponent do
  use StygianWeb, :html

  alias Stygian.Skills.Skill

  attr :skill, Skill, required: true
  attr :value, :integer, required: true
  attr :kind, :string, required: true
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
          class="inline-flex items-center px-2 py-2 text-sm font-medium text-brand bg-transparent border border-brand rounded-xl hover:bg-brand hover:text-black focus:z-10 focus:ring-2 focus:ring-black focus:bg-brand focus:text-black"
        >
          <svg
            class="w-[12px] h-[12px]"
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
        <span
          type="button"
          disabled
          class="font-typewriter text-lg inline-flex items-center justify-center font-medium text-brand bg-transparent min-w-[50px]"
        >
          <%= @value %>
        </span>
        <button
          type="button"
          phx-click={@on_plus}
          phx-value-kind={@kind}
          phx-value-skill={@skill.id}
          class="inline-flex items-center px-2 py-2 text-sm font-medium text-brand bg-transparent border border-brand rounded-xl hover:bg-brand hover:text-black focus:z-10 focus:ring-2 focus:ring-black focus:bg-brand focus:text-black"
        >
          <svg
            class="w-[12px] h-[12px]"
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
