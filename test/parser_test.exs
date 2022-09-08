defmodule ParserTest do
  use ExUnit.Case
  doctest Servy.Parser

  import Servy.Handler, only: [handle: 1]

  test "GET /api/bears" do
    request = """
    GET /api/bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\nContent-Length: 1079\r\n\r\n[{\"type\":\"Spirit-Black\",\"name\":\"Fredrik\",\"id\":1,\"hibernating\":true},{\"type\":\"Spirit-Black\",\"name\":\"Lars\",\"id\":2,\"hibernating\":true},{\"type\":\"Black\",\"name\":\"Axel\",\"id\":3,\"hibernating\":true},{\"type\":\"Black\",\"name\":\"Kruger\",\"id\":4,\"hibernating\":true},{\"type\":\"Black\",\"name\":\"Greger\",\"id\":5,\"hibernating\":true},{\"type\":\"Kodiak-Brown\",\"name\":\"Padington\",\"id\":6,\"hibernating\":false},{\"type\":\"Kodiak-Brown\",\"name\":\"Stevie\",\"id\":7,\"hibernating\":false},{\"type\":\"Kodiak-Brown\",\"name\":\"Rotherford\",\"id\":8,\"hibernating\":false},{\"type\":\"Kodiak-Brown\",\"name\":\"Johnson\",\"id\":9,\"hibernating\":false},{\"type\":\"Polar\",\"name\":\"Jason\",\"id\":10,\"hibernating\":false},{\"type\":\"Polar\",\"name\":\"Anabel\",\"id\":11,\"hibernating\":false},{\"type\":\"Grizzly-Brown\",\"name\":\"James\",\"id\":12,\"hibernating\":true},{\"type\":\"Grizzly-Brown\",\"name\":\"Jermy\",\"id\":13,\"hibernating\":true},{\"type\":\"Grizzly-Brown\",\"name\":\"Rebecca\",\"id\":14,\"hibernating\":true},{\"type\":\"Panda\",\"name\":\"Tomas\",\"id\":15,\"hibernating\":true},{\"type\":\"Sun\",\"name\":\"Luca\",\"id\":16,\"hibernating\":true},{\"type\":\"Sun\",\"name\":\"Harry\",\"id\":17,\"hibernating\":true}]\n"


    assert response == expected_response
  end

  test "GET /wildthings" do
    request = """
    GET /wildthings HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """
    response = handle(request)

    assert response == """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 20\r
    \r
    Bears, Lions, Tigers
    """
  end

  test "GET bears/:id" do

    request = """
    GET /bears/1 HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """
    response = handle(request)

    assert response == """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 74\r
    \r
    <h1>Show Bear</h1>
    <p>
    Is Fredrik Hibernating <strong> true </strong>
    </p>
    """
  end

  test "Create bear" do

    request = """
    POST /bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Content-Type: application/x-www-form-urlencoded\r
    Content-Length: 21\r
    \r
    name=Baloo&type=Brown
    """

    response = handle(request)

    assert response == """
    HTTP/1.1 201 Created\r
    Content-Type: text/html\r
    Content-Length: 43\r
    \r
    Created the bear Baloo who is a Brown Bear.
    """
  end

end
