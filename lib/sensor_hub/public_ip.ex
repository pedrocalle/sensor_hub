defmodule SensorHub.PublicIP do
  def get_public_ip do
    {:ok, %HTTPoison.Response{body: ip}} = HTTPoison.get("https://api.ipify.org")
    ip
  end
end
