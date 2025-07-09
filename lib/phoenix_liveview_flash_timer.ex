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

  import Phoenix.LiveView

  @default_timeout 5000

  defmacro __using__(_opts) do
    quote do
      import Phoenix.LiveView, except: [put_flash: 3]
      import PhoenixLiveViewFlashTimer, only: [put_flash: 3, put_flash: 4]

      def handle_info(:clear_flash, socket) do
        {:noreply, Phoenix.LiveView.clear_flash(socket)}
      end
    end
  end

  @doc """
  on_mount callback that automatically starts flash timer for controller flash messages.
  """
  def on_mount(:default, _params, _session, socket) do
    timeout = get_timeout()

    if connected?(socket) and has_flash_messages?(socket) do
      Process.send_after(self(), :clear_flash, timeout)
    end

    {:cont, socket}
  end

  @doc """
  Enhanced put_flash that automatically sets a timer to clear the flash message.
  """
  def put_flash(socket, kind, message) do
    put_flash(socket, kind, message, get_timeout())
  end

  def put_flash(socket, kind, message, timeout) do
    socket = Phoenix.LiveView.put_flash(socket, kind, message)

    if connected?(socket) do
      Process.send_after(self(), :clear_flash, timeout)
    end

    socket
  end

  defp has_flash_messages?(socket) do
    flash = socket.assigns[:flash] || %{}
    flash != %{} and not Enum.empty?(flash)
  end

  defp get_timeout do
    Application.get_env(:phoenix_liveview_flash_timer, :default_timeout, @default_timeout)
  end
end
