defmodule ShoppingCartWeb.CartLive.Index do
  use ShoppingCartWeb, :live_view
  alias ShoppingCartWeb.CartLive.ProductItem

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        total_items: 0
      )

    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    name=params["name"] || "Guest"
    {:noreply, assign(socket, name: name)}
  end

  def render(assigns) do
    ~H"""
    hi <%= @name %> <%= self() |> :erlang.pid_to_list() %>

    <div class="w-full max-w-md p-6 bg-white rounded-lg shadow-md">
      <h2 class="text-2xl font-semibold mb-3">Shopping Cart - Total Items: <%= @total_items %></h2>

      <.live_component :for={id <- 1..3} module={ProductItem} id={id} />
    </div>
    """
  end

  def handle_info(:add, socket) do
    {:noreply, update(socket, :total_items, &(&1 + 1))}
  end
end
