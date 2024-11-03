defmodule Exercism.LanguageList do
  def new, do: []

  def add(list, language), do: [language | list]

  def remove(list)

  def remove([_ | tail]), do: tail

  def first(list)

  def first([]), do: nil

  def first([head | _]) when head != [], do: head

  def count(list), do: list |> length

  def functional_list?(list), do: "Elixir" in list
end
