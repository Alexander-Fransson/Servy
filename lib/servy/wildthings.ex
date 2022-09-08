defmodule Servy.Wildthings do
  alias Servy.Bear

  #fake databas med björnar
  def list_bears do
    [
      %Bear{id: 1, name: "Fredrik", type: "Spirit-Black", hibernating: true },
      %Bear{id: 2, name: "Lars", type: "Spirit-Black", hibernating: true },
      %Bear{id: 3, name: "Axel", type: "Black", hibernating: true },
      %Bear{id: 4, name: "Kruger", type: "Black", hibernating: true },
      %Bear{id: 5, name: "Greger", type: "Black", hibernating: true },
      %Bear{id: 6, name: "Padington", type: "Kodiak-Brown", hibernating: false },
      %Bear{id: 7, name: "Stevie", type: "Kodiak-Brown", hibernating: false },
      %Bear{id: 8, name: "Rotherford", type: "Kodiak-Brown", hibernating: false },
      %Bear{id: 9, name: "Johnson", type: "Kodiak-Brown", hibernating: false },
      %Bear{id: 10, name: "Jason", type: "Polar", hibernating: false },
      %Bear{id: 11, name: "Anabel", type: "Polar", hibernating: false },
      %Bear{id: 12, name: "James", type: "Grizzly-Brown", hibernating: true },
      %Bear{id: 13, name: "Jermy", type: "Grizzly-Brown", hibernating: true },
      %Bear{id: 14, name: "Rebecca", type: "Grizzly-Brown", hibernating: true },
      %Bear{id: 15, name: "Tomas", type: "Panda", hibernating: true },
      %Bear{id: 16, name: "Luca", type: "Sun", hibernating: true },
      %Bear{id: 17, name: "Harry", type: "Sun", hibernating: true },
    ]
  end

  #returnar björnrn från fakedatabasen med matchande id
  def get_bear(id) when is_integer(id) do
    Enum.find(list_bears(), fn(b) -> b.id == id end)
  end

  def get_bear(id) when is_binary(id) do
    id |> String.to_integer |> get_bear
  end
end
