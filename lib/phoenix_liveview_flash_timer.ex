defmodule PhoenixLiveViewFlashTimer do
  @moduledoc """
  Automatically clears flash messages after a specified timeout in Phoenix LiveView.

  This module provides automatic flash message clearing for both controller-set
  flash messages and LiveView put_flash calls.

  ## Installation

  Add to your `mix.exs`:

      {:phoenix_liveview_flash_timer, "~> 0.1.0"}

  ## Usage

  ### Basic Setup (LiveView flash messages only)

  In your `YourAppWeb` module:

      def live_view do
        quote do
          use Phoenix.LiveView
          use PhoenixLiveViewFlashTimer

          # ... rest of your code
        end
      end

  This will automatically clear flash messages created with `put_flash/3` in your LiveViews.

  ### Full Setup (Controller + LiveView flash messages)

  To also handle flash messages set by controllers (e.g., after form submissions, redirects),
  add the `on_mount` hook:

      def live_view do
        quote do
          use Phoenix.LiveView
          use PhoenixLiveViewFlashTimer
          on_mount PhoenixLiveViewFlashTimer  # Add this line for controller flash support

          # ... rest of your code
        end
      end

  ## Configuration

  You can configure the default timeout in your config:

      config :phoenix_liveview_flash_timer,
        default_timeout: 5000  # milliseconds (default: 5000)

  ## How it works

  - **LiveView flash messages**: When you call `put_flash(socket, :info, "Message")`,
    a timer is automatically started to clear the message after the specified timeout.

  - **Controller flash messages**: When you include `on_mount PhoenixLiveViewFlashTimer`,
    the module checks for existing flash messages during LiveView mount and starts
    a timer to clear them.

  ## Examples

      # In a LiveView - automatically cleared after 5 seconds
      socket = put_flash(socket, :info, "Data saved successfully!")

      # In a LiveView - custom timeout
      socket = put_flash(socket, :error, "Something went wrong", 10000)

      # In a controller - will be cleared after 5 seconds when LiveView mounts
      # (requires on_mount PhoenixLiveViewFlashTimer)
      conn
      |> put_flash(:info, "Account created successfully!")
      |> redirect(to: ~p"/dashboard")
  """

  # ... rest of your code
end
