defmodule Servy.BearController do

  alias Servy.Wildthings
  alias Servy.Bear

  @template_path Path.expand("../../templates",__DIR__)

  #sjickar  en lista som en variabel till index.eex typ som express ejs
  defp render(conv, template, bindings \\ []) do
    content = @template_path
    |> Path.join(template)
    |> EEx.eval_file(bindings)

    %{ conv | status: 200, resp_body: content}
  end

  def index(conv) do
    #skapar en html lista sorterade i alfabetisk ordning från wildthings listan
    bears = Wildthings.list_bears()
    |> Enum.sort(&Bear.order_asc_by_name/2)

    render(conv,"index.eex",bears: bears)
  end

  def bear_item(b) do
    "<li>#{b.name} - #{b.type}</li>"
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)

    render(conv, "show.eex", bear: bear)
  end

  def create(conv, %{"name" => name, "type" => type} = _params) do
    %{ conv | status: 201, resp_body: "Created the bear #{name} who is a #{type} Bear."}
  end
end
