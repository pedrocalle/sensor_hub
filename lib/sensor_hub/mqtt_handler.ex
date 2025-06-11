defmodule SensorHub.MqttHandler do
  @behaviour Tortoise.Handler
  require Logger

  def init(opts), do: {:ok, opts}

  def connection(status, state) do
    Logger.info("📡 MQTT Connection status: #{inspect(status)}")
    {:ok, state}
  end

  def handle_message(topic, payload, state) do
    topic_str = Enum.join(topic, "/")
    Logger.info("📨 Mensagem recebida no tópico #{topic_str}: #{payload}")

    case Jason.decode(payload) do
      {:ok, map} -> Logger.info("Payload decodificado: #{inspect(map)}")
      {:error, _} -> Logger.warning("❗ Não foi possível decodificar o payload")
    end

    {:ok, state}
  end

  def subscription(status, topic_filter, state) do
    Logger.info(
      "📝 Subscrição status #{inspect(status)} para tópico #{Enum.join(topic_filter, "/")}"
    )

    {:ok, state}
  end

  def terminate(reason, _state) do
    Logger.error("❌ Handler terminado: #{inspect(reason)}")
    :ok
  end
end
