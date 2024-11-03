alias Exercism.Rpg.{Edible, LoafOfBread, ManaPotion, EmptyBottle, Poison}
defimpl Edible, for: LoafOfBread do
  def eat(_item, character), do: {nil, %{character | health: character.health + 5}}
end

defimpl Edible, for: ManaPotion do
  def eat(item, character), do: {%EmptyBottle{}, %{character | mana: character.mana + item.strength}}
end

defimpl Edible, for: Poison do
  def eat(_item, character), do: {%EmptyBottle{}, %{character | health: 0}}
end
