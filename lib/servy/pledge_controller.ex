defmodule Servy.PledgeController do
  alias Servy.PledgeServer

  def create(conv, %{"name" => name, "amount" => amount}) do
    #sjickar pledge till extern service och catchar det
    PledgeServer.create_pledge(name, String.to_integer(amount))

    %{ conv | status: 201, resp_body: "#{name} pledged #{amount}!"}
  end

  def index(conv) do
    #tar de tre nyaste pledgarna från catchen
    pledgeds = PledgeServer.recent_pledges()

    %{conv | status: 200, resp_body: (inspect pledgeds)}
  end
end
