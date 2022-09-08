defmodule Servy do
 use Application

 def start(_type, _args) do
  IO.puts "Starting the Application..."
  Servy.Superdupervicer.start_link()
 end
end
