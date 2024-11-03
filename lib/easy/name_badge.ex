defmodule Exercism.NameBadge do

  @spec print(pos_integer() | nil, String.t(), String.t() | nil) :: String.t()
  def print(id, name, department), do:
  "#{if id, do: "[#{id}] - "}#{name} - #{String.upcase(department || "OWNER")}"
end
