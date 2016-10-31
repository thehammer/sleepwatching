defmodule Sleepwatching.PageController do
  use Sleepwatching.Web, :controller
  alias Sleepwatching.SleepIQ
  alias Sleepwatching.SSDPDevice

  def index(conn, _params) do
    conn
    |> render("index.html", devices: SSDPDevice.discover(SSDPDevice.Service.ircc))
  end

  def renderers(conn, _params) do
    conn
    |> render("renderers.html", devices: SSDPDevice.discover(SSDPDevice.Service.rendering_control))
  end

  def confirm(conn, params) do
    device = SSDPDevice.discover("urn:schemas-sony-com:service:IRCC:1")
    |> Enum.find(fn {id, _info} -> id == params["id"] end)

    conn
    |> render("confirm.html", device: device)
  end

  def turn_off(conn, params) do
    conn
    |> text(SSDPDevice.turn_off(params["uuid"]) |> Poison.encode!)
  end

  def confirmed(conn, params) do
    conn
    |> render("confirmed.html", id: params["id"])
  end

  def sleepiq(conn, params) do
    SleepIQ.start(params["email"], params["password"])
    |> IO.inspect

    conn
    |> render("sleepiq.html", beds: SleepIQ.beds, sleepers: SleepIQ.sleepers, family_status: SleepIQ.family_status)
  end
end
