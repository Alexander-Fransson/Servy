defmodule Servy.Plugins do

  alias Servy.Conv

  #skriver varning när status är 404
  def track(%Conv{status: 404, path: path} = conv) do
    if Mix.env != :test do
     IO.puts  "Warning! #{path} is on the loose."
    end
    conv
  end

  def track(%Conv{} = conv), do: conv

  #ändrar path wildlife till wildthings, annars sjickar den bara konv vidare
  def rewrite_path( conv = %Conv{path: "/wildlife"}) do
    %{conv | path: "/wildthings"}
  end

  def rewrite_path(%Conv{} = conv), do: conv

  #skriver ut conv
  def log(%Conv{} = conv) do
    if Mix.env == :dev do
      IO.inspect conv
    end
    conv
  end

end
