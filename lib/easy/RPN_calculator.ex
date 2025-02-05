defmodule Exercism.RPNCalculator do
  def calculate!(stack, operation), do: operation.(stack)

  def calculate(stack, operation), do: (try do {:ok, operation.(stack)} rescue _ -> :error end)

  def calculate_verbose(stack, operation), do: (try do {:ok, operation.(stack)} rescue e -> {:error, Exception.message(e)} end)
end
