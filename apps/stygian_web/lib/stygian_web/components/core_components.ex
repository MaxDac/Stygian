defmodule StygianWeb.CoreComponents do
  @moduledoc """
  Provides core UI components.

  At the first glance, this module may seem daunting, but its goal is
  to provide some core building blocks in your application, such as modals,
  tables, and forms. The components are mostly markup and well documented
  with doc strings and declarative assigns. You may customize and style
  them in any way you want, based on your application growth and needs.

  The default components use Tailwind CSS, a utility-first CSS framework.
  See the [Tailwind CSS documentation](https://tailwindcss.com) to learn
  how to customize them or feel free to swap in another framework altogether.
  """
  use Phoenix.Component

  alias Phoenix.LiveView.JS
  import StygianWeb.Gettext

  alias Phoenix.HTML.Form
  alias Phoenix.HTML.FormField

  @doc """
  Renders a modal.

  ## Examples

      <.modal id="confirm-modal">
        This is a modal.
      </.modal>

  JS commands may be passed to the `:on_cancel` to configure
  the closing/cancel event, for example:

      <.modal id="confirm" on_cancel={JS.navigate(~p"/posts")}>
        This is another modal.
      </.modal>

  """
  attr :id, :string, required: true
  attr :show, :boolean, default: false
  attr :on_cancel, JS, default: %JS{}
  slot :inner_block, required: true

  def modal(assigns) do
    ~H"""
    <div
      id={@id}
      phx-mounted={@show && show_modal(@id)}
      phx-remove={hide_modal(@id)}
      data-cancel={JS.exec(@on_cancel, "phx-remove")}
      class="relative z-50 hidden"
    >
      <div
        id={"#{@id}-bg"}
        class="bg-container-background/80 fixed inset-0 transition-opacity"
        aria-hidden="true"
      />
      <div
        class="fixed inset-0 overflow-y-auto"
        aria-labelledby={"#{@id}-title"}
        aria-describedby={"#{@id}-description"}
        role="dialog"
        aria-modal="true"
        tabindex="0"
      >
        <div class="flex min-h-full items-center justify-center">
          <div class="w-full max-w-3xl p-4 sm:p-6 lg:py-8">
            <.focus_wrap
              id={"#{@id}-container"}
              phx-window-keydown={JS.exec("data-cancel", to: "##{@id}")}
              phx-key="escape"
              phx-click-away={JS.exec("data-cancel", to: "##{@id}")}
              class="shadow-black/10 ring-brand/10 border border-brand-inactive relative hidden rounded-2xl bg-container-background p-14 shadow-lg ring-1 transition"
            >
              <div class="absolute top-6 right-5">
                <button
                  phx-click={JS.exec("data-cancel", to: "##{@id}")}
                  type="button"
                  class="-m-3 flex-none p-3 opacity-20 hover:opacity-40"
                  aria-label={gettext("close")}
                >
                  <.icon name="close" class="h-4 w-4" />
                </button>
              </div>
              <div id={"#{@id}-content"}>
                <%= render_slot(@inner_block) %>
              </div>
            </.focus_wrap>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Renders flash notices.

  ## Examples

      <.flash kind={:info} flash={@flash} />
      <.flash kind={:info} phx-mounted={show("#flash")}>Welcome Back!</.flash>
  """
  attr :id, :string, default: "flash", doc: "the optional id of flash container"
  attr :flash, :map, default: %{}, doc: "the map of flash messages to display"
  attr :title, :string, default: nil
  attr :kind, :atom, values: [:info, :error], doc: "used for styling and flash lookup"
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the flash container"

  slot :inner_block, doc: "the optional inner block that renders the flash message"

  def flash(assigns) do
    ~H"""
    <div
      :if={msg = render_slot(@inner_block) || Phoenix.Flash.get(@flash, @kind)}
      d={@id}
      phx-click={JS.push("lv:clear-flash", value: %{key: @kind}) |> hide("##{@id}")}
      role="alert"
      class={[
        "fixed top-2 right-2 w-80 sm:w-96 z-50 rounded-lg p-3 ring-1 font-typewriter",
        @kind == :info && "bg-container-background text-brand ring-brand fill-container-background",
        @kind == :error &&
          "bg-container-background text-rose-300 shadow-md ring-rose-700 fill-container-background"
      ]}
      {@rest}
    >
      <p :if={@title} class="flex items-center gap-1.5 text-sm font-semibold leading-6">
        <.icon :if={@kind == :info} name="info" class="h-2 w-2" />
        <.icon :if={@kind == :error} name="exclamation" class="h-2 w-2" />
        <%= @title %>
      </p>
      <p class="mt-2 text-sm leading-5"><%= msg %></p>
      <button type="button" class="group absolute top-1 right-1 p-2" aria-label={gettext("close")}>
        <.icon name="close" class="h-3 w-3 opacity-40 group-hover:opacity-70" />
      </button>
    </div>
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  def flash_group(assigns) do
    ~H"""
    <.flash kind={:info} title="OK" flash={@flash} />
    <.flash kind={:error} title="Errore" flash={@flash} />
    <.flash
      id="client-error"
      kind={:error}
      title="We can't find the internet"
      phx-disconnected={show(".phx-client-error #client-error")}
      phx-connected={hide("#client-error")}
      hidden
    >
      Attempting to reconnect <.icon name="reconnect" class="ml-1 h-3 w-3 animate-spin" />
    </.flash>

    <.flash
      id="server-error"
      kind={:error}
      title="Something went wrong!"
      phx-disconnected={show(".phx-server-error #server-error")}
      phx-connected={hide("#server-error")}
      hidden
    >
      Hang in there while we get back on track
      <.icon name="reconnect" class="ml-1 h-3 w-3 animate-spin" />
    </.flash>
    """
  end

  @doc """
  Renders a simple form.

  ## Examples

      <.simple_form for={@form} phx-change="validate" phx-submit="save">
        <.input field={@form[:email]} label="Email"/>
        <.input field={@form[:username]} label="Username" />
        <:actions>
          <.button>Save</.button>
        </:actions>
      </.simple_form>
  """
  attr :for, :any, required: true, doc: "the datastructure for the form"
  attr :as, :any, default: nil, doc: "the server side parameter to collect all input under"

  attr :class, :string,
    default: "",
    required: false,
    doc: "the custom class to apply to the form internal div tag"

  attr :rest, :global,
    include: ~w(autocomplete name rel action enctype method novalidate target multipart),
    doc: "the arbitrary HTML attributes to apply to the form tag"

  slot :inner_block, required: true
  slot :actions, doc: "the slot for form actions, such as a submit button"

  def simple_form(assigns) do
    ~H"""
    <.form :let={f} for={@for} as={@as} {@rest}>
      <div class={"space-y-8 flex flex-col #{@class}"}>
        <%= render_slot(@inner_block, f) %>
        <div :for={action <- @actions} class="mt-2 flex items-center justify-between gap-6">
          <%= render_slot(action, f) %>
        </div>
      </div>
    </.form>
    """
  end

  @doc """
  Renders a button.

  ## Examples

      <.button>Send!</.button>
      <.button phx-click="go" class="ml-2">Send!</.button>
  """
  attr :type, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled form name value)

  slot :inner_block, required: true

  def button(assigns) do
    ~H"""
    <button
      type={@type}
      class={[
        "phx-submit-loading:opacity-75 rounded-md font-typewriter bg-controls bg-repeat",
        "text-md font-semibold leading-6 text-black hover:drop-shadow-lg active:text-black/80 py-2 px-3",
        @class
      ]}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </button>
    """
  end

  @doc """
  Renders an input with label and error messages.

  A `FormField` may be passed as argument,
  which is used to retrieve the input name, id, and values.
  Otherwise all attributes may be passed explicitly.

  ## Types

  This function accepts all HTML input types, considering that:

    * You may also set `type="select"` to render a `<select>` tag

    * `type="checkbox"` is used exclusively to render boolean values

    * For live file uploads, see `Phoenix.Component.live_file_input/1`

  See https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input
  for more information.

  ## Examples

      <.input field={@form[:email]} type="email" />
      <.input name="my-input" errors={["oh no!"]} />
  """
  attr :id, :any, default: nil
  attr :name, :any
  attr :label, :string, default: nil
  attr :value, :any
  attr :placeholder, :string, default: nil
  attr :floating, :boolean, default: false, doc: "Implements the input with a floating label"

  attr :type, :string,
    default: "text",
    values: ~w(checkbox color date datetime-local email file hidden month number password
               range radio search select tel text textarea time url week)

  attr :field, FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :errors, :list, default: []
  attr :checked, :boolean, doc: "the checked flag for checkbox inputs"
  attr :prompt, :string, default: nil, doc: "the prompt for select inputs"
  attr :options, :list, doc: "the options to pass to Form.options_for_select/2"
  attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"

  attr :rest, :global,
    include: ~w(accept autocomplete capture cols disabled form list max maxlength min minlength
                multiple pattern placeholder readonly required rows size step)

  slot :inner_block

  def input(%{field: %FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(field.errors, &translate_error(&1)))
    |> assign_new(:name, fn -> if assigns.multiple, do: field.name <> "[]", else: field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> input()
  end

  def input(%{type: "checkbox", value: value} = assigns) do
    assigns =
      assign_new(assigns, :checked, fn -> Form.normalize_value("checkbox", value) end)

    ~H"""
    <div phx-feedback-for={@name} class="flex flex-row items-center h-5">
      <div>
        <input type="hidden" name={@name} value="false" />
        <input
          type="checkbox"
          id={@id}
          name={@name}
          value="true"
          checked={@checked}
          class="w-4 h-4 rounded bg-gray-50 focus:ring-3 focus:ring-brand dark:bg-gray-700 dark:border-brand dark:focus:ring-brand dark:ring-offset-brand dark:focus:ring-offset-brand"
          {@rest}
        />
      </div>
      <label for="terms" class="ml-2 text-sm font-medium text-brand"><%= @label %></label>
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  def input(%{type: "select"} = assigns) do
    ~H"""
    <div phx-feedback-for={@name}>
      <.label for={@id}><%= @label %></.label>
      <select
        id={@id}
        name={@name}
        class="mt-2 block w-full text-lg font-typewriter text-black bg-controls rounded-md shadow-sm focus:ring-0"
        multiple={@multiple}
        {@rest}
      >
        <option :if={@prompt} value=""><%= @prompt %></option>
        <%= Form.options_for_select(@options, @value) %>
      </select>
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  def input(%{type: "textarea"} = assigns) do
    ~H"""
    <div phx-feedback-for={@name} class="h-28">
      <.label for={@id}><%= @label %></.label>
      <textarea
        id={@id}
        name={@name}
        placeholder={@placeholder}
        data-tooltip-target="textarea-error-tooltip"
        class={[
          "mt-2 block w-full rounded-md font-typewriter text-black text-md focus:ring-0 sm:text-sm sm:leading-6",
          "min-h-24 h-24 phx-no-feedback:border-brand-inactive phx-no-feedback:focus:border-brand-inactive",
          "bg-controls drop-shadow-[0_35px_35px_rgba(255,255,255,0.25)]",
          @errors != [] && "border-rose-400 focus:border-rose-400"
        ]}
        {@rest}
      ><%= Form.normalize_value("textarea", @value) %></textarea>
      <.error_tooltip tooltip_target_id="textarea-error-tooltip" errors={@errors} />
    </div>
    """
  end

  def input(%{type: "hidden"} = assigns) do
    ~H"""
    <input type="hidden" name={@name} id={@id} value={Form.normalize_value(@type, @value)} />
    """
  end

  # This input implements the floating label design.
  def input(%{floating: true} = assigns) do
    ~H"""
    <div phx-feedback-for={@name} class="relative mt-5">
      <input
        type={@type}
        id={@id}
        name={@name}
        value={Form.normalize_value(@type, @value)}
        placeholder=" "
        class={[
          "block px-2.5 pb-2.5 pt-4 w-full font-typewriter text-md text-black bg-controls rounded-md",
          "appearance-none focus:outline-none focus:ring-0 peer",
          @errors != [] && "border-rose-400 focus:border-rose-400"
        ]}
      />
      <label
        for={@id}
        class={[
          "absolute font-typewriter text-sm text-black duration-300 transform",
          "-translate-y-4 scale-75 top-2 z-10 origin-[0] bg-controls px-2 rounded-2xl",
          "peer-focus:px-2 peer-focus:text-black peer-placeholder-shown:scale-100",
          "peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2",
          "peer-focus:top-2 peer-focus:scale-75 peer-focus:-translate-y-4 left-1"
        ]}
      >
        <%= @label %>
      </label>
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  # All other inputs text, datetime-local, url, password, etc. are handled here...
  def input(assigns) do
    ~H"""
    <div phx-feedback-for={@name}>
      <.label for={@id}><%= @label %></.label>
      <input
        type={@type}
        name={@name}
        id={@id}
        value={Form.normalize_value(@type, @value)}
        class={[
          "font-typewriter text-md font-medium bg-controls text-black rounded-md block w-full p-2.5",
          @errors != [] && "border-rose-400 focus:border-rose-400"
        ]}
        {@rest}
      />
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  @doc """
  Renders a label.
  """
  attr :for, :string, default: nil
  slot :inner_block, required: true

  def label(assigns) do
    ~H"""
    <label
      for={@for}
      class="font-berolina block mb-2 text-lg font-medium text-gray-900 dark:text-brand"
    >
      <%= render_slot(@inner_block) %>
    </label>
    """
  end

  @doc """
  Generates a generic error message.
  """
  slot :inner_block, required: true

  def error(assigns) do
    ~H"""
    <p class="mt-3 flex gap-3 text-sm leading-6 text-rose-600 phx-no-feedback:hidden">
      <.icon name="exclamation" class="mt-0.5 h-5 w-5 flex-none" />
      <%= render_slot(@inner_block) %>
    </p>
    """
  end

  @doc """
  Generates an error message packed in a tooltip.
  """
  attr :tooltip_target_id, :string, default: "tooltip-default"
  attr :errors, :list, required: true

  def error_tooltip(assigns) do
    ~H"""
    <div
      id={@tooltip_target_id}
      role="tooltip"
      class={
        "absolute z-10 invisible inline-block px-3 py-2 text-sm font-medium"
        <> "text-rose-300 transition-opacity duration-300 rounded-lg shadow-sm"
        <> "opacity-0 tooltip bg-gray-700"
        <> if @errors == [], do: " hidden", else: ""
      }
    >
      <span :for={msg <- @errors}><%= msg %></span>
      <div class="tooltip-arrow" data-popper-arrow></div>
    </div>
    """
  end

  @doc """
  Renders a header with title.
  """
  attr :class, :string, default: nil

  slot :inner_block, required: true
  slot :subtitle
  slot :actions

  def header(assigns) do
    ~H"""
    <header class={[@actions != [] && "flex items-center justify-between gap-6", @class]}>
      <div>
        <h1 class="text-lg font-semibold leading-8 font-berolina text-brand">
          <%= render_slot(@inner_block) %>
        </h1>
        <p :if={@subtitle != []} class="mt-2 text-sm leading-6 text-brand-inactive">
          <%= render_slot(@subtitle) %>
        </p>
      </div>
      <div class="flex-none"><%= render_slot(@actions) %></div>
    </header>
    """
  end

  @doc ~S"""
  Renders a table with generic styling.

  ## Examples

      <.table id="users" rows={@users}>
        <:col :let={user} label="id"><%= user.id %></:col>
        <:col :let={user} label="username"><%= user.username %></:col>
      </.table>
  """
  attr :id, :string, required: true
  attr :rows, :list, required: true
  attr :row_id, :any, default: nil, doc: "the function for generating the row id"
  attr :row_click, :any, default: nil, doc: "the function for handling phx-click on each row"

  attr :row_item, :any,
    default: &Function.identity/1,
    doc: "the function for mapping each row before calling the :col and :action slots"

  slot :col, required: true do
    attr :label, :string
  end

  slot :action, doc: "the slot for showing user actions in the last table column"

  def table(assigns) do
    assigns =
      with %{rows: %Phoenix.LiveView.LiveStream{}} <- assigns do
        assign(assigns, row_id: assigns.row_id || fn {id, _item} -> id end)
      end

    ~H"""
    <div class="overflow-y-auto px-4 sm:overflow-visible sm:px-0 rounded-lg">
      <table class="w-full bg-controls rounded-lg">
        <thead class="text-ls text-zinc-900 text-left">
          <tr>
            <th :for={col <- @col} class="pt-4 pl-1 font-typewriter"><%= col[:label] %></th>
            <th class="relative p-0 pb-4"><span class="sr-only"><%= gettext("Actions") %></span></th>
          </tr>
        </thead>
        <tbody
          id={@id}
          phx-update={match?(%Phoenix.LiveView.LiveStream{}, @rows) && "stream"}
          class="relative divide-y divide-black border-t border-black text-sm leading-6 text-zinc-900 font-typewriter"
        >
          <tr :for={row <- @rows} id={@row_id && @row_id.(row)} class="group not-format">
            <td
              :for={{col, i} <- Enum.with_index(@col)}
              phx-click={@row_click && @row_click.(row)}
              class="relative p-0"
            >
              <div class="block py-4 pr-6 pl-1">
                <span class={["relative", i == 0 && "font-semibold text-zinc-900"]}>
                  <%= render_slot(col, @row_item.(row)) %>
                </span>
              </div>
            </td>
            <td :if={@action != []} class="w-[170px] relative p-0">
              <div class="w-full text-center inline-flex justify-center rounded-md shadow-sm align-middle">
                <span :for={action <- @action}>
                  <%= render_slot(action, @row_item.(row)) %>
                </span>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end

  @doc """
  The link for the buttons in a table.
  """
  attr :navigate, :string,
    required: false,
    default: nil,
    doc: """
    Navigates from a LiveView to a new LiveView.
    The browser page is kept, but a new LiveView process is mounted and its content on the page
    is reloaded. It is only possible to navigate between LiveViews declared under the same router
    `Phoenix.LiveView.Router.live_session/3`. Otherwise, a full browser redirect is used.
    """

  attr :patch, :string,
    required: false,
    default: nil,
    doc: """
    Patches the current LiveView.
    The `handle_params` callback of the current LiveView will be invoked and the minimum content
    will be sent over the wire, as any other LiveView diff.
    """

  attr :rest, :global,
    include: ~w(download hreflang referrerpolicy rel target type),
    doc: """
    Additional HTML attributes added to the `a` tag.
    """

  attr :class, :string,
    required: false,
    default: nil,
    doc: "The custom class to apply to the link"

  slot :inner_block, required: true

  def table_link(assigns) do
    ~H"""
    <.link
      navigate={@navigate}
      patch={@patch}
      class={"focus:outline-none text-zinc-900 bg-controls hover:bg-brand focus:ring-4 focus:ring-green-300 font-medium text-sm p-2 border border-zinc-900 #{@class}"}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </.link>
    """
  end

  @doc """
  The left link for the buttons in a table, positioned at the right-hand side.
  """
  attr :class, :string,
    required: false,
    default: nil,
    doc: "The custom class to apply to the link"

  attr :rest, :global,
    include: ~w(navigate patch download hreflang referrerpolicy rel target type),
    doc: """
    Additional HTML attributes added to the `a` tag.
    """

  slot :inner_block, required: true

  def table_link_right(assigns) do
    ~H"""
    <.table_link class={"border-l-zinc-900 rounded-r-lg #{@class}"} {@rest}>
      <%= render_slot(@inner_block) %>
    </.table_link>
    """
  end

  @doc """
  The right link for the buttons in a table.
  """
  attr :class, :string,
    required: false,
    default: nil,
    doc: "The custom class to apply to the link"

  attr :rest, :global,
    include: ~w(navigate patch download hreflang referrerpolicy rel target type),
    doc: """
    Additional HTML attributes added to the `a` tag.
    """

  slot :inner_block, required: true

  def table_link_left(assigns) do
    ~H"""
    <.table_link class={"rounded-l-lg border-r-zinc-900 #{@class}"} {@rest}>
      <%= render_slot(@inner_block) %>
    </.table_link>
    """
  end

  @doc """
  The standalone link for the buttons in a table.
  """
  attr :class, :string,
    required: false,
    default: nil,
    doc: "The custom class to apply to the link"

  attr :rest, :global,
    include: ~w(navigate patch download hreflang referrerpolicy rel target type),
    doc: """
    Additional HTML attributes added to the `a` tag.
    """

  slot :inner_block, required: true

  def table_link_standalone(assigns) do
    ~H"""
    <.table_link class={"rounded-lg border-r-zinc-900 #{@class}"} {@rest}>
      <%= render_slot(@inner_block) %>
    </.table_link>
    """
  end

  @doc """
  Renders a data list.

  ## Examples

      <.list>
        <:item title="Title"><%= @post.title %></:item>
        <:item title="Views"><%= @post.views %></:item>
      </.list>
  """
  slot :item, required: true do
    attr :title, :string, required: true
  end

  def list(assigns) do
    ~H"""
    <div class="mt-14">
      <dl class="-my-4 divide-y divide-brand font-typewriter">
        <div :for={item <- @item} class="flex gap-4 py-4 text-sm leading-6 sm:gap-8">
          <dt class="w-1/4 flex-none text-brand"><%= item.title %></dt>
          <dd class="text-brand-inactive"><%= render_slot(item) %></dd>
        </div>
      </dl>
    </div>
    """
  end

  @doc """
  Renders an icon.
  Each icon SVG must be added manually
  """
  attr :name, :string, required: true
  attr :class, :string, default: nil

  def icon(%{name: "close"} = assigns) do
    ~H"""
    <svg
      class={"#{@class} text-zinc-100"}
      aria-hidden="true"
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 14 14"
    >
      <path
        stroke="currentColor"
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6"
      />
    </svg>
    """
  end

  def icon(%{name: "info"} = assigns) do
    ~H"""
    <svg
      class={"#{@class} text-zinc-100"}
      aria-hidden="true"
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 20 20"
    >
      <path
        stroke="currentColor"
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M8 9h2v5m-2 0h4M9.408 5.5h.01M19 10a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"
      />
    </svg>
    """
  end

  def icon(%{name: "exclamation"} = assigns) do
    ~H"""
    <svg
      class={"#{@class} text-zinc-100"}
      aria-hidden="true"
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 20 20"
    >
      <path
        stroke="currentColor"
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M10 11V6m0 8h.01M19 10a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"
      />
    </svg>
    """
  end

  def icon(%{name: "reconnect"} = assigns) do
    ~H"""
    <svg aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 20 18">
      <path
        stroke="currentColor"
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="m1 14 3-3m-3 3 3 3m-3-3h16v-3m2-7-3 3m3-3-3-3m3 3H3v3"
      />
    </svg>
    <svg
      class={"#{@class} text-zinc-100"}
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      stroke-width="1.5"
      stroke="currentColor"
      class="w-6 h-6"
    >
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        d="M16.023 9.348h4.992v-.001M2.985 19.644v-4.992m0 0h4.992m-4.993 0l3.181 3.183a8.25 8.25 0 0013.803-3.7M4.031 9.865a8.25 8.25 0 0113.803-3.7l3.181 3.182m0-4.991v4.99"
      />
    </svg>
    """
  end

  def icon(assigns) do
    ~H"""
    <svg
      class={"#{@class} text-zinc-100"}
      aria-hidden="true"
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 20 20"
    >
      <path
        stroke="currentColor"
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M10 11V6m0 8h.01M19 10a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"
      />
    </svg>
    """
  end

  ## JS Commands

  def show(js \\ %JS{}, selector) do
    JS.show(js,
      to: selector,
      transition:
        {"transition-all transform ease-out duration-300",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
         "opacity-100 translate-y-0 sm:scale-100"}
    )
  end

  def hide(js \\ %JS{}, selector) do
    JS.hide(js,
      to: selector,
      time: 200,
      transition:
        {"transition-all transform ease-in duration-200",
         "opacity-100 translate-y-0 sm:scale-100",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"}
    )
  end

  def show_modal(js \\ %JS{}, id) when is_binary(id) do
    js
    |> JS.show(to: "##{id}")
    |> JS.show(
      to: "##{id}-bg",
      transition: {"transition-all transform ease-out duration-300", "opacity-0", "opacity-100"}
    )
    |> show("##{id}-container")
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.focus_first(to: "##{id}-content")
  end

  def hide_modal(js \\ %JS{}, id) do
    js
    |> JS.hide(
      to: "##{id}-bg",
      transition: {"transition-all transform ease-in duration-200", "opacity-100", "opacity-0"}
    )
    |> hide("##{id}-container")
    |> JS.hide(to: "##{id}", transition: {"block", "block", "hidden"})
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.pop_focus()
  end

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    # When using gettext, we typically pass the strings we want
    # to translate as a static argument:
    #
    #     # Translate the number of files with plural rules
    #     dngettext("errors", "1 file", "%{count} files", count)
    #
    # However the error messages in our forms and APIs are generated
    # dynamically, so we need to translate them by calling Gettext
    # with our gettext backend as first argument. Translations are
    # available in the errors.po file (as we use the "errors" domain).
    if count = opts[:count] do
      Gettext.dngettext(StygianWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(StygianWeb.Gettext, "errors", msg, opts)
    end
  end

  @doc """
  Translates the errors for a field from a keyword list of errors.
  """
  def translate_errors(errors, field) when is_list(errors) do
    for {^field, {msg, opts}} <- errors, do: translate_error({msg, opts})
  end

  @doc """
  Renders an area link.

  ## Examples

      <.area shape="rect" coords="100,100,200,200" navigate={~p"/posts"} alt="LinkName" />
  """
  attr :navigate, :any, required: true

  attr :rest, :global,
    include: ~w(coords shape alt),
    doc: "the arbitrary HTML attributes to apply to the area tag"

  def area(assigns) do
    ~H"""
    <area href={@navigate} data-phx-link="redirect" data-phx-link-state="push" {@rest} />
    """
  end

  @doc """
  The default `h1` component.
  """
  attr :class, :string,
    required: false,
    default: "",
    doc: "the custom class to apply to the h1 tag"

  slot :inner_block, doc: "the title to render"

  def h1(assigns) do
    ~H"""
    <h1 class={"text-center font-berolina #{@class}"}>
      <%= render_slot(@inner_block) %>
    </h1>
    """
  end

  @doc """
  The default `h2` component.
  """
  attr :class, :string,
    required: false,
    default: "",
    doc: "the custom class to apply to the h1 tag"

  slot :inner_block, doc: "the title to render"

  def h2(assigns) do
    ~H"""
    <h2 class={"text-center font-berolina #{@class}"}>
      <%= render_slot(@inner_block) %>
    </h2>
    """
  end

  @doc """
  The default `h3` component.
  """
  attr :class, :string,
    required: false,
    default: "",
    doc: "the custom class to apply to the h1 tag"

  slot :inner_block, doc: "the title to render"

  def h3(assigns) do
    ~H"""
    <h3 class={"text-center font-berolina #{@class}"}>
      <%= render_slot(@inner_block) %>
    </h3>
    """
  end

  @doc """
  The default `hr` component.
  """
  attr :class, :string,
    required: false,
    default: "",
    doc: "the custom class to apply to the hr tag"

  def hr(assigns) do
    ~H"""
    <hr class={"border-2 border-brand shadow-md shadow-brand-inactive #{@class}"} />
    """
  end

  @doc """
  The default link at the top of the page to return to the previous page.
  """
  attr :class, :string,
    required: false,
    default: "",
    doc: "the custom class to apply to the h1 tag"

  attr :rest, :global,
    include: ~w(navigate patch download hreflang referrerpolicy rel target type),
    doc: """
    Additional HTML attributes added to the `a` tag.
    """

  slot :inner_block, doc: "the title to render"

  def return_link(assigns) do
    ~H"""
    <div class="flex flex-row justify-center">
      <.link class={"font-typewriter text-md #{@class}"} {@rest}>
        <%= render_slot(@inner_block) %>
      </.link>
    </div>
    """
  end

  @doc """
  The spinner. This component will be used to represent a loading component.
  """
  attr :class, :string,
    required: false,
    default: "",
    doc: "the custom class to apply to the spinner tag"

  def spinner(assigns) do
    ~H"""
    <div role="status">
      <svg
        aria-hidden="true"
        class="w-8 h-8 mr-2 animate-spin text-gray-600 fill-brand"
        viewBox="0 0 100 101"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
      >
        <path
          d="M100 50.5908C100 78.2051 77.6142 100.591 50 100.591C22.3858 100.591 0 78.2051 0 50.5908C0 22.9766 22.3858 0.59082 50 0.59082C77.6142 0.59082 100 22.9766 100 50.5908ZM9.08144 50.5908C9.08144 73.1895 27.4013 91.5094 50 91.5094C72.5987 91.5094 90.9186 73.1895 90.9186 50.5908C90.9186 27.9921 72.5987 9.67226 50 9.67226C27.4013 9.67226 9.08144 27.9921 9.08144 50.5908Z"
          fill="currentColor"
        />
        <path
          d="M93.9676 39.0409C96.393 38.4038 97.8624 35.9116 97.0079 33.5539C95.2932 28.8227 92.871 24.3692 89.8167 20.348C85.8452 15.1192 80.8826 10.7238 75.2124 7.41289C69.5422 4.10194 63.2754 1.94025 56.7698 1.05124C51.7666 0.367541 46.6976 0.446843 41.7345 1.27873C39.2613 1.69328 37.813 4.19778 38.4501 6.62326C39.0873 9.04874 41.5694 10.4717 44.0505 10.1071C47.8511 9.54855 51.7191 9.52689 55.5402 10.0491C60.8642 10.7766 65.9928 12.5457 70.6331 15.2552C75.2735 17.9648 79.3347 21.5619 82.5849 25.841C84.9175 28.9121 86.7997 32.2913 88.1811 35.8758C89.083 38.2158 91.5421 39.6781 93.9676 39.0409Z"
          fill="currentFill"
        />
      </svg>
      <span class="sr-only">Loading...</span>
    </div>
    """
  end

  @doc """
  The default `h1` component.
  """
  attr :class, :string,
    required: false,
    default: "",
    doc: "the custom class to apply to the h1 tag"

  slot :inner_block, doc: "the title to render"

  def guide_h1(assigns) do
    ~H"""
    <.h1 class={"pt-2 #{@class}"}>
      <%= render_slot(@inner_block) %>
    </.h1>
    """
  end

  @doc """
  The default `h2` component.
  """
  attr :class, :string,
    required: false,
    default: "",
    doc: "the custom class to apply to the h2 tag"

  slot :inner_block, doc: "the title to render"

  def guide_h2(assigns) do
    ~H"""
    <.h2 class={"pt-2 #{@class}"}>
      <%= render_slot(@inner_block) %>
    </.h2>
    """
  end

  @doc """
  The guide paragraph.
  """
  attr :class, :string,
    required: false,
    default: nil,
    doc: "The custom class to apply to the paragraph"

  slot :inner_block, doc: "The content of the paragraph"

  def guide_p(assigns) do
    ~H"""
    <p class={"font-normal #{@class}"}>
      <%= render_slot(@inner_block) %>
    </p>
    """
  end
end
