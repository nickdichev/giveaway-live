defmodule GiveawayWeb.Live.Helpers do
  @doc """
  Determine if a LiveView process should re-subscribe to a PubSub topic.

  It is expected that the socket assigns have a `:subscribed` key with a true/false
  value indicating if the process has already subscribed.
  """
  def subscribe?(true, %{subscribed: false}), do: true
  def subscribe?(_, _), do: false
end
