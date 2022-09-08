defmodule Servy.Tracker do
  def get_location(wildthing) do
    :timer.sleep(500)

    location = %{
      "Anabel" => %{ lat: "22.3225 N", lng: "102.6698 W"},
      "Jason" => %{ lat: "22.3227 N", lng: "103.6698 W"},
    }

    Map.get(location, wildthing)
  end
end
