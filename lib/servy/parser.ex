defmodule Servy.Parser do

  #kallar importen det sista efter punkten
  alias Servy.Conv

  #delar upp stringen vid varje paragraf, varje rad och sedan varje mällanrum på första raden
  def parse(request) do
    [top, params_string] = String.split(request, "\r\n\r\n")
    [request_line | header_lines] = String.split( top, "\r\n")
    [method, path, _] = String.split(request_line, " ")

    IO.inspect header_lines

    headers = parse_headers(header_lines, %{})
    params = parse_params(headers["Content-Type"],params_string)

    #sätter method och path i structen
    %Conv{
      method: method,
      path: path,
      params: params,
      headers: headers
    }
  end

  #deligerar de olika hedersarna till en map
  def parse_headers([head|tail], headers) do
    [key, value] = String.split(head, ": ")
    headers = Map.put(headers, key, value)
    parse_headers(tail, headers)
  end

  def parse_headers([], headers), do: headers

  @doc """
  Parses the given dtring in the form of 'key1=value1&key2=value2'
  into a map with coresponding keys and values

  ## Examples
    iex> params_string = "name=Baloo&type=Brown"
    iex> Servy.Parser.parse_params("application/x-www-form-urlencoded",params_string) == %{"name" => "Baloo", "type" => "Brown"}
  """
  def parse_params("application/x-www-form-urlencoded",params_string) do
    params_string |> String.trim |> URI.decode_query
  end

  def parse_params(_,_), do: %{}
end
