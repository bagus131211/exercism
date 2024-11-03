  defmodule Exercism.ZebraPuzzle do
    alias Exercism.ZebraPuzzle, as: ZP
    defstruct [:color, :nationality, :pet, :beverage, :hobby, :position]

    @nationalities [:englishman, :spaniard, :norwegian, :japanese, :ukrainian]
    @hobbies [:painting, :dancing, :chess, :reading, :football]
    @pets [:dog, :zebra, :horse, :snail, :fox]
    @beverages [:coffee, :water, :tea, :orange_juice, :milk]
    @colors [:yellow, :red, :blue, :ivory, :green]

    defp permutations([]), do: [[]]

    defp permutations(list), do: (
      for house <- list,
      rest <- permutations(list -- [house]), do:
        [house | rest]
    )

    defp neighbors?(pos1, pos2), do: abs(pos1 - pos2) === 1

    defp make_houses(keys), do: permutations([1,2,3,4,5]) |> Enum.map(fn houses -> keys |> Enum.zip(houses) |> Map.new end)

    defp backtracking, do: (
      for nationality <- make_houses(@nationalities),
      nationality.norwegian == 1,
      color <- make_houses(@colors),
      color.red == nationality.englishman,
      color.green == color.ivory + 1,
      neighbors?(nationality.norwegian, color.blue),
      beverage <- make_houses(@beverages),
      beverage.milk == 3,
      beverage.coffee == color.green,
      beverage.tea == nationality.ukrainian,
      pet <- make_houses(@pets),
      pet.dog == nationality.spaniard,
      hobby <- make_houses(@hobbies),
      neighbors?(hobby.reading, pet.fox),
      neighbors?(hobby.painting, pet.horse),
      hobby.chess == nationality.japanese,
      hobby.football == beverage.orange_juice,
      hobby.dancing == pet.snail,
      hobby.painting == color.yellow, do:
        %{color: color, nationality: nationality, hobby: hobby, pet: pet, beverage: beverage}
    )
    |> map_backtracking_result

    defp map_backtracking_result(result) do
      %{
        color: colors,
        nationality: nationalities,
        pet: pets,
        beverage: beverages,
        hobby: hobbies
      } = List.first(result)

      for position <- 1..5 do
        %ZP{
          position: position,
          color: find_key(colors, position),
          nationality: find_key(nationalities, position),
          pet: find_key(pets, position),
          beverage: find_key(beverages, position),
          hobby: find_key(hobbies, position)
        }
      end
    end

    defp find_key(map, position), do:
      map
      |> Enum.find(fn {_key, pos} -> pos == position end)
      |> elem(0)


    @doc """
    Determine who drinks the water
    """
    @spec drinks_water :: atom
    def drinks_water, do: Enum.find(backtracking(), & &1.beverage == :water).nationality

    @doc """
    Determine who owns the zebra
    """
    @spec owns_zebra :: atom
    def owns_zebra, do: Enum.find(backtracking(), & &1.pet == :zebra).nationality
  end
