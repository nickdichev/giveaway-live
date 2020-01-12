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

  def handle_event(
        "right_button_click",
        _value,
        %{
          assigns: %{
            right_button_action: right_button_action,
            right_button_param: right_button_param
          }
        } = socket
      ) do
    send(
      self(),
      {:modal_button_clicked, %{action: right_button_action, param: right_button_param}}
    )

    {:noreply, socket}
  end

  def handle_event(
        "left_button_click",
        _value,
        %{
          assigns: %{
            left_button_action: left_button_action,
            left_button_param: left_button_param
          }
        } = socket
      ) do
    send(self(), {:modal_button_clicked, %{action: left_button_action, param: left_button_param}})

    {:noreply, socket}
  end
end
