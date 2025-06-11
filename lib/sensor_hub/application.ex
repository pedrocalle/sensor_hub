defmodule SensorHub.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children =
      [
        {
          Tortoise.Connection,
          client_id: "sensor_hub_receiver",
          server: {Tortoise.Transport.Tcp, host: ~c"broker.hivemq.com", port: 1883},
          handler: {SensorHub.MqttHandler, []},
          subscriptions: [{"greenhouse/sensores", 0}]
        }
      ] ++ target_children()

    opts = [strategy: :one_for_one, name: MqttReceiver.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  if Mix.target() == :host do
    defp target_children() do
      [
        # Children that only run on the host during development or test.
        # In general, prefer using `config/host.exs` for differences.
        #
        # Starts a worker by calling: Host.Worker.start_link(arg)
        # {Host.Worker, arg},
      ]
    end
  else
    defp target_children() do
      [
        # Children for all targets except host
        # Starts a worker by calling: Target.Worker.start_link(arg)
        # {Target.Worker, arg},
      ]
    end
  end
end
