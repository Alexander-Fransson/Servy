defmodule Servy.Handler do

  @moduledoc """
  Handles http docs
  """

  alias Servy.Conv
  alias Servy.BearController

  #importerar moduler, numret stpr för funktionens antal parametrar
  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
  import Servy.Parser, only: [parse: 1]
  import Servy.VideoCam, only: [get_snapshot: 1]

  #Skapar konstant för path till pages dir
  @pages_path Path.expand("../../pages" ,__DIR__)

  #kör alla funktioner i en pipeline. |> betyder sätt in i nästa funktion
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> format_response
  end

  #routes som sätter status och body

  def route(%Conv{method: "POST", path: "/pledges"} = conv) do
    Servy.PledgeController.create(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/pledges"} = conv) do
    Servy.PledgeController.index(conv)
  end

  def route(%Conv{ method: "GET", path: "/sensors"} = conv) do
    #pid står för process id
    #requesten processerna körs i ordning trotts att de tar olika lång tid att bli klara
    task = Task.async(fn -> Servy.Tracker.get_location("Anabel") end)

    snapshots = ["cam-1","cam-2","cam-3"]
    |> Enum.map(&Task.async(fn -> get_snapshot(&1) end))
    |> Enum.map(&Task.await/1)

    find_polarbear = Task.await(task)

    %{conv | status: 200, resp_body: inspect {snapshots, find_polarbear}}

  end

  def route(%Conv{ method: "GET", path: "/hibernate/" <> time } = conv) do

    #delayed
    time |> String.to_integer |> :timer.sleep
    %{ conv | status: 200, resp_body: "Awake!"}
  end
  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %{ conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/api/bears"} = conv) do
    Servy.Api.BearController.index(conv)
  end

  #name=Baloo&type=Brown
  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    BearController.create(conv, conv.params)
  end

  #<> lägger ihop binaries som strings och ints. man kan också knyta en variabel till det värdersom blir läggs ihop. "ko/" <> 1; "ko/" <> id; id=1
  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.show(conv,params)
  end

  # läser fil och ger error meddelanden vid mislyckande
  def route(%Conv{method: "GET", path: "/about"} = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read
    |> file_handler(conv)
  end

  #default all patterns matched funktion dom reternar ett error meddelande
  def route(%Conv{path: path} = conv) do
    %{conv | status: 404, resp_body: "no #{path} here!"}
  end

  def file_handler({:error, :enoent},conv) do
    %{ conv | status: 404, resp_body: "File not found"}
  end

  def file_handler({:error , reason},conv) do
    %{ conv | status: 500, resp_body: "File error #{reason}"}
  end

  def file_handler({:ok, content},conv) do
    %{ conv | status: 200, resp_body: content}
  end

  # def route(%{method: "GET", path: "/about"} = conv) do

  #   #hittar den absoluta pathen till pages mappen och sätter ihop det med fil namnet
  #   file = Path.expand("../../pages", __DIR__)|> Path.join("about.html")

  #   case File.read(file) do
  #     {:ok, content} ->
  #       %{ conv | status: 200, resp_body: content}

  #     {:error, :enoent} ->
  #       %{ conv | status: 404, resp_body: "File not found"}

  #     {:error , reason} ->
  #       %{ conv | status: 500, resp_body: "File error #{reason}"}
  #   end
  # end


  #skriver en response string med conv datan enligt HTTP
  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    Content-Type: #{conv.resp_content_type}\r
    Content-Length: #{String.length(conv.resp_body)}\r
    \r
    #{conv.resp_body}
    """
  end

end
