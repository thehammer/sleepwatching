defmodule Sleepwatching.SSDPDevice do
  import SweetXml

  defmodule Service do
    def ircc, do: "urn:schemas-sony-com:service:IRCC:1"
    def rendering_control, do: "urn:schemas-upnp-org:service:RenderingControl:1"
  end

  defmodule Code do
    def off, do: "AAAAAQAAAAEAAAAvAw=="
  end

  def find(uuid) do
    Nerves.SSDPClient.discover
    |> Map.get(uuid)
  end

  def discover(service_identifier) do
    Nerves.SSDPClient.discover
    |> Enum.filter(fn {id, _info} -> String.ends_with?(id, "::#{service_identifier}") end)
    |> Enum.filter(fn {_id, info} -> Map.has_key?(info, :location) end)
    |> Enum.map(fn {id, info} -> {id, metadata(info.location)} end)
  end

  defp metadata(location) do
    doc = HTTPotion.get(location).body

    doc
    |> xmap(
      name: ~x"//device/friendlyName/text()",
      make: ~x"//device/manufacturer/text()",
      model: ~x"//device/modelName/text()",
    )
    |> Map.merge(%{icon: "#{base_url(location)}#{icon_path(doc)}"})
  end

  defp base_url(location) do
    URI.parse(location)
    |> Map.put(:path, nil)
    |> Map.put(:query, nil)
    |> Map.put(:fragment, nil)
    |> URI.to_string
  end

  defp icon_path(doc) do
    icons = doc
            |> xpath(
              ~x"//device/iconList/icon"l,
              mimetype: ~x"./mimetype/text()"s,
              height: ~x"./height/text()"i,
              width: ~x"./width/text()"i,
              depth: ~x"./width/text()"i,
              url: ~x"./url/text()",
            )

    if Enum.any?(icons) do
      icons
      |> Enum.filter(fn icon -> icon[:mimetype] == "image/png" end)
      |> Enum.max_by(fn icon -> icon[:height] end)
      |> Map.get(:url)
    else
      ""
    end
  end

  def turn_off(uuid) do
    case find(uuid) do
      nil -> %{status_code: 404}
      device -> %{status_code: status_code} = device |> endpoint |> control(Code.off)
    end
  end

  defp endpoint(device) do
    "http://#{device.host}/sony/IRCC?"
  end

  defp control(endpoint, code) do
    HTTPotion.post(
      endpoint,
      body: ~s(<?xml version="1.0" encoding="utf-8"?><s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><s:Body><u:X_SendIRCC xmlns:u="urn:schemas-sony-com:service:IRCC:1"><IRCCCode>#{code}</IRCCCode></u:X_SendIRCC></s:Body></s:Envelope>),
      headers: [
        "User-Agent": "SleepWatching",
        "Content-Type": "text/xml",
        "SOAPAction": "urn:schemas-sony-com:service:IRCC:1#X_SendIRCC"
      ]
    )
  end
end
