defmodule Sleepwatching.SleepIQ.API do
  defp base(), do: "https://api.sleepiq.sleepnumber.com/rest"

  def login(), do: base <> "/login"
  def bed(), do: base <> "/bed"
  def bed_status(id), do: base <> "/bed/#{id}/status"
  def family_status(), do: base <> "/bed/familyStatus"
  def pause_mode(id), do: base <> "/bed/#{id}/pauseMode"
  def registration(), do: base <> "/registration"
  def sleeper(), do: base <> "/sleeper"
  def sleep_slice_data(), do: base <> "/sleepSliceData"
  def sleep_data(), do: base <> "/sleepData"

  def session(username, password) do
    response = HTTPotion.put(login, body: Poison.encode!(%{login: username, password: password}), headers: headers)

    handle_response(response)
    |> Map.merge(%{cookies: unmarshal_cookies(response.headers["set-cookie"])})
  end


  def get(session, endpoint, query \\ %{}) do
    HTTPotion.get(
    endpoint,
    query: Map.merge(%{"_k" => session.key}, query),
    headers: headers |> Keyword.merge(["Cookie": marshal_cookies(session.cookies)]),
    )
    |> handle_response
  end

  defp handle_response(response) do
    case response do
      %{status_code: 200, headers: _headers, body: body} ->
        Poison.decode!(body)
        |> atomize_keys
      _ ->
        IO.inspect response
        %{status_code: response.status_code}
    end
  end

  defp headers() do
    [
      "X-App-Version": "2.4.4",
      "User-Agent": "SleepWatching",
      "Content-Type": "application/json",
      "Accept": "application/json",
    ]
  end

  defp unmarshal_cookies(cookie_string) do
    cookie_string
    |> Enum.map(fn entry ->
      String.split(entry, ";")
      |> List.first
    end)
    |> Enum.reduce(%{}, fn entry, acc ->
      [key, value] = String.split(entry, "=")
      Map.put(acc, key, value)
    end)
  end

  defp marshal_cookies(cookies) do
    cookies
    |> Enum.map(fn {k, v} -> Enum.join([k,v], "=") end)
    |> Enum.join(";")
  end

  # This is poor practice in Elixir/Erlang, but for a small app, it's probably okay.
  defp atomize_keys(data) when is_map(data) do
    Enum.reduce(data, %{}, fn ({k, v}, acc) ->
      Map.put(acc, String.to_atom(k), atomize_keys(v))
    end)
  end
  defp atomize_keys(data) when is_list(data) do
    Enum.map(data, fn item -> atomize_keys(item) end)
  end
  defp atomize_keys(data), do: data
end
