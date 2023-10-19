defmodule StygianWeb.RestLive.CharacterRestComponents do
  @moduledoc """
  A collection of functional components that will isolate certain functionalities.
  """

  use StygianWeb, :html

  @doc """
  A series of checkboxes that will represent the selected occupied slots.
  """
  def slots_resume(assigns) do
    ~H"""
    <h3 class="mb-4 font-semibold text-gray-900 dark:text-white">Identification</h3>
    <ul class="items-center w-full text-sm font-medium text-gray-900 bg-white border border-gray-200 rounded-lg sm:flex dark:bg-gray-700 dark:border-gray-600 dark:text-white">
      <li class="w-full border-b border-gray-200 sm:border-b-0 sm:border-r dark:border-gray-600">
        <div class="flex items-center pl-3">
          <input
            id="vue-checkbox-list"
            type="checkbox"
            value=""
            class="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-700 dark:focus:ring-offset-gray-700 focus:ring-2 dark:bg-gray-600 dark:border-gray-500"
          />
          <label
            for="vue-checkbox-list"
            class="w-full py-3 ml-2 text-sm font-medium text-gray-900 dark:text-gray-300"
          >
            Vue JS
          </label>
        </div>
      </li>
      <li class="w-full border-b border-gray-200 sm:border-b-0 sm:border-r dark:border-gray-600">
        <div class="flex items-center pl-3">
          <input
            id="react-checkbox-list"
            type="checkbox"
            value=""
            class="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-700 dark:focus:ring-offset-gray-700 focus:ring-2 dark:bg-gray-600 dark:border-gray-500"
          />
          <label
            for="react-checkbox-list"
            class="w-full py-3 ml-2 text-sm font-medium text-gray-900 dark:text-gray-300"
          >
            React
          </label>
        </div>
      </li>
      <li class="w-full border-b border-gray-200 sm:border-b-0 sm:border-r dark:border-gray-600">
        <div class="flex items-center pl-3">
          <input
            id="angular-checkbox-list"
            type="checkbox"
            value=""
            class="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-700 dark:focus:ring-offset-gray-700 focus:ring-2 dark:bg-gray-600 dark:border-gray-500"
          />
          <label
            for="angular-checkbox-list"
            class="w-full py-3 ml-2 text-sm font-medium text-gray-900 dark:text-gray-300"
          >
            Angular
          </label>
        </div>
      </li>
      <li class="w-full dark:border-gray-600">
        <div class="flex items-center pl-3">
          <input
            id="laravel-checkbox-list"
            type="checkbox"
            value=""
            class="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-700 dark:focus:ring-offset-gray-700 focus:ring-2 dark:bg-gray-600 dark:border-gray-500"
          />
          <label
            for="laravel-checkbox-list"
            class="w-full py-3 ml-2 text-sm font-medium text-gray-900 dark:text-gray-300"
          >
            Laravel
          </label>
        </div>
      </li>
    </ul>
    """
  end
end
