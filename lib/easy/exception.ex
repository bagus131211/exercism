defmodule Exercism.Exception do
  alias Exercism.Exception.{DivisionByZeroError, StackUnderflowError}

  def divide(stack) when length(stack) < 2, do: (raise StackUnderflowError, "when dividing")

  def divide([0 | _tail]), do: (raise DivisionByZeroError)

  def divide([a, b | _rest]), do: div(b, a)

  defmodule DivisionByZeroError do
    defexception message: "division by zero occurred"
  end

  defmodule StackUnderflowError do
    defexception message: "stack underflow occurred"

    @impl true
    def exception(term) do
      case term do
        context when is_binary(context) -> %StackUnderflowError{message: "stack underflow occured, context: #{context}"}
        _ -> %StackUnderflowError{}
      end
    end
  end
end
