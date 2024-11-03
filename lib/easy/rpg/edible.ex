defprotocol Exercism.Rpg.Edible do
  @spec eat(struct(), struct()) :: tuple()
  def eat(item, character)
end
