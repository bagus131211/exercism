defmodule Exercism.Rpg.CharacterSheet do
alias Exercism.Rpg.CharacterSheet

  @spec welcome :: :ok
  def welcome, do: IO.puts "Welcome! Let's fill out your character sheet together."

  @spec ask_name :: String.t()
  def ask_name, do: IO.gets("What is your character's name?\n") |> String.trim

  @spec ask_class :: String.t()
  def ask_class, do: IO.gets("What is your character's class?\n") |> String.trim

  @spec ask_level :: pos_integer()
  def ask_level, do: IO.gets("What is your character's level?\n") |> String.trim |> String.to_integer

  def run do
  CharacterSheet.welcome
  %{name: CharacterSheet.ask_name, class: CharacterSheet.ask_class, level: CharacterSheet.ask_level}
  |> IO.inspect(label: "Your character")
  end
end
