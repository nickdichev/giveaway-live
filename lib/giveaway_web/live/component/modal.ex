defmodule GiveawayWeb.Component.Modal do
  use Phoenix.LiveComponent

  alias GiveawayWeb.ComponentsView

  @defaults %{
    left_button: "Cancel",
    left_button_action: nil,
    left_button_param: nil,
    right_button: "OK",
    right_button_action: nil,
    right_button_param: nil
  }

  def mount(socket) do
    {:ok, socket}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, Map.merge(@defaults, assigns))}
  end

  def render(assigns) do
    ComponentsView.render("modal.html", assigns)
  end
end
