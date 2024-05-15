defmodule ShoppingCart.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ShoppingCartWeb.Telemetry,
      ShoppingCart.Repo,
      {DNSCluster, query: Application.get_env(:shopping_cart, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ShoppingCart.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ShoppingCart.Finch},
      # Start a worker by calling: ShoppingCart.Worker.start_link(arg)
      # {ShoppingCart.Worker, arg},
      # Start to serve requests, typically the last entry
      ShoppingCartWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ShoppingCart.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ShoppingCartWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
