#erlang server

# server() ->
#   {ok, LSock} = gen_tcp:listen(5678, [binary, {packet, 0},
#                                       {active, false}]),
#   {ok, Sock} = gen_tcp:accept(LSock),
#   {ok, Bin} = do_recv(Sock, []),
#   ok = gen_tcp:close(Sock),
#   ok = gen_tcp:close(LSock),
#   Bin.

# do_recv(Sock, Bs) ->
#   case gen_tcp:recv(Sock, 0) of
#       {ok, B} ->
#           do_recv(Sock, [Bs, B]);
#       {error, closed} ->
#           {ok, list_to_binary(Bs)}
#   end.

defmodule Servy.HttpServer do

  #startar servern på den givna porten
  def start(port) when is_integer(port) and port > 1023 do
    #skapar en lyssnar socket
    {:ok, listen_socket} =
      :gen_tcp.listen(port, [:binary, packet: :raw, active: false, reuseaddr: true])
    IO.puts "\nListening on port: #{port}...\n"

    accept_loop(listen_socket)
  end

  #accepterar klient anknytningar på socketen vi lysnar på
  def accept_loop(listen_socket) do
    IO.puts "Waiting to accept connection...\n"
    {:ok, client_socket} = :gen_tcp.accept(listen_socket)
    IO.puts "Connection accepted!\n"

    spawn(fn -> serve(client_socket) end) #spawn gör funktion async
    accept_loop(listen_socket)
  end

  #tar emot ett request i en socket och sjickar tillbaka på samma socket
  def serve(client_socket) do
    IO.puts "#{inspect self()}: Working on it"
    client_socket
    |> read_request
    |> Servy.Handler.handle
    |> write_response(client_socket)
  end

  #tar emot request på klient socketen
  def read_request(client_socket) do
    {:ok, request} = :gen_tcp.recv(client_socket, 0)
    IO.puts "Received request:\n"
    IO.puts request
    request
  end

  #ger et generiskt http res
  def generate_response(_req) do
    """
    HTTP/1.1 200 OK\r
    Content-Type: text/plain\r
    Content-Length: 6\r
    \r
    Body
    """
  end

  #skriver svaret
  def write_response(response, client_socket) do
    :ok = :gen_tcp.send(client_socket,response)

    IO.puts "Response Sent:\n"
    IO.puts response

    :gen_tcp.close(client_socket)
  end

  # def server() do
  #   {:ok, lsock} = :gen_tcp.listen(5678, [:binary, packet: 0,
  #                                         active: false])
  #   {:ok, sock} = :gen_tcp.accept(lsock)
  #   {:ok, bin} = :gen_tcp.recv(sock, 0)

  #   #send
  #   :ok = :gen_tcp.close(sock)
  #   bin

  # end

end
