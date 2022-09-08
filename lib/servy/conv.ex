defmodule Servy.Conv do

  #basicly en module, matchar en likadan map
  defstruct method: "",
            path: "",
            params: %{},
            headers: %{},
            resp_content_type: "text/html",
            resp_body: "",
            status: nil

  def full_status(conv) do
    "#{conv.status} #{status_reason(conv.status)}"
  end

  #tar en statuskod och returnar en förklaring
  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unotherized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end

end
