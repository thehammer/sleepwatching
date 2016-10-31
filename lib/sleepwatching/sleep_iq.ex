defmodule Sleepwatching.SleepIQ do
  alias Timex.Format.DateTime.Formatter, as: TimeFormatter
  alias Sleepwatching.SleepIQ.API

  def start(username, password), do: Agent.start_link(fn -> API.session(username, password) end, name: __MODULE__)
  def family_status(), do: Agent.get(__MODULE__, fn session -> API.get(session, API.family_status) end)
  def beds(), do: Agent.get(__MODULE__, fn session -> API.get(session, API.bed).beds end)
  def bed_status(id), do: Agent.get(__MODULE__, fn session -> API.get(session, API.bed_status(id)) end)
  def pause_mode(id), do: Agent.get(__MODULE__, fn session -> API.get(session, API.pause_mode(id)) end)
  def registration(), do: Agent.get(__MODULE__, fn session -> API.get(session, API.registration) end)
  def sleepers(), do: Agent.get(__MODULE__, fn session -> API.get(session, API.sleeper).sleepers end)
  def sleep_slice_data(), do: sleep_slice_data(TimeFormatter.format!(current_slice_date, "%F", :strftime))
  def sleep_slice_data(date), do: Agent.get(__MODULE__, fn session -> API.get(session, API.sleep_slice_data, %{date: date}) end)
  def sleep_data(), do: sleep_data(TimeFormatter.format!(current_slice_date, "%F", :strftime))
  def sleep_data(date, interval \\ "D1"), do: Agent.get(__MODULE__, fn session -> API.get(session, API.sleep_data, %{date: date, interval: interval}) end)

  def current_slice_date do
    Timex.local
    |> Timex.shift(hours: 12)
    |> Timex.to_datetime(Timex.Timezone.local)
    |> Timex.to_erl
  end

  def current_slice_index do
    {{_, _, _},{hours, minutes, _}} = current_slice_date
    hours * 6 + div(minutes, 10)
  end
end
