defmodule Servy.Fetcher do
  #typ async await
  def async(fun) do
    parent = self()

    spawn(fn -> send(parent, {self(), :result, fun.()}) end)
  end

  def get_results(pid) do
    receive do {^pid, :result, value} -> value end
  end

end
