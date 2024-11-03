defmodule Exercism.Forth do
  @moduledoc """
  Instructions
    Implement an evaluator for a very simple subset of Forth.

    Forth is a stack-based programming language. Implement a very basic evaluator for a small subset of Forth.

    Your evaluator has to support the following words:

      +, -, *, / (integer arithmetic)
      DUP, DROP, SWAP, OVER (stack manipulation)
    Your evaluator also has to support defining new words using the customary syntax: : word-name definition ;.

    To keep things simple the only data type you need to support is signed integers of at least 16 bits size.

    You should use the following rules for the syntax: a number is a sequence of one or more (ASCII) digits,
    a word is a sequence of one or more letters, digits, symbols or punctuation that is not a number.
    (Forth probably uses slightly different rules, but this is close enough.)

    Words are case-insensitive.
  """

  alias Exercism.Forth.{DivisionByZero, InvalidWord, StackUnderflow, UnknownWord}
  @opaque evaluator :: %{stack: [integer], dictionary: map}

  @doc """
  Create a new evaluator.

    ## Example:

      iex(45)> n = Exercism.Forth.new
      %{dictionary: %{}, stack: []}

  """
  @spec new :: evaluator
  def new, do: %{stack: [], dictionary: %{}}

  @doc """
  Evaluate an input string, updating the evaluator state.

    ## Example:

      iex(46)> e = Exercism.Forth.eval n, "-1 -2 -3 -4 -5"
      %{dictionary: %{}, stack: [-5, -4, -3, -2, -1]}

      iex(47)> e = Exercism.Forth.eval n, "1 2 3 4 5"
      %{dictionary: %{}, stack: [5, 4, 3, 2, 1]}

      iex(48)> e = Exercism.Forth.eval n, "1 +"
      ** (Exercism.Forth.StackUnderflow) stack underflow
          (exercism 0.1.0) lib/hard/forth.ex:47: Exercism.Forth.process_token/2
          (elixir 1.17.2) lib/enum.ex:2531: Enum."-reduce/3-lists^foldl/2-0-"/3
          iex:48: (file)

      iex(48)> e = Exercism.Forth.eval n, "+"
      ** (Exercism.Forth.StackUnderflow) stack underflow
          (exercism 0.1.0) lib/hard/forth.ex:47: Exercism.Forth.process_token/2
          (elixir 1.17.2) lib/enum.ex:2531: Enum."-reduce/3-lists^foldl/2-0-"/3
          iex:48: (file)

      iex(48)> e = Exercism.Forth.eval n, "1 2 +"
      %{dictionary: %{}, stack: [3]}

      iex(49)> e = Exercism.Forth.eval n, "1\x002\x013\n4\r5 6\t7"
      %{dictionary: %{}, stack: [7, 6, 5, 4, 3, 2, 1]}

      iex(50)> e = Exercism.Forth.eval n, "3 4 -"
      %{dictionary: %{}, stack: [-1]}

      iex(52)> e = Exercism.Forth.eval n, "2 8 *"
      %{dictionary: %{}, stack: [16]}

      iex(53)> e = Exercism.Forth.eval n, "12 3 /"
      %{dictionary: %{}, stack: [4]}

      iex(55)> e = Exercism.Forth.eval n, "8 0 /"
      ** (Exercism.Forth.DivisionByZero) division by zero
          (exercism 0.1.0) lib/hard/forth.ex:23: Exercism.Forth.process_token/2
          (elixir 1.17.2) lib/enum.ex:2531: Enum."-reduce/3-lists^foldl/2-0-"/3
          iex:55: (file)

      iex(55)> e = Exercism.Forth.eval n, "1 2 + 4 -"
      %{dictionary: %{}, stack: [-1]}                   # combination operation

      iex(56)> e = Exercism.Forth.eval n, "2 4 * 3 /"
      %{dictionary: %{}, stack: [2]}

      iex(60)> e = Exercism.Forth.eval n, "1 DUP"
      %{dictionary: %{}, stack: [1, 1]}

      iex(61)> e = Exercism.Forth.eval n, "1 2 dup"
      %{dictionary: %{}, stack: [2, 2, 1]}

      iex(62)> e = Exercism.Forth.eval n, "1 drop"
      %{dictionary: %{}, stack: []}

      iex(63)> e = Exercism.Forth.eval n, "1 2 drop"
      %{dictionary: %{}, stack: [1]}

      iex(64)> e = Exercism.Forth.eval n, "1 2 swap"
      %{dictionary: %{}, stack: [1, 2]}                   # look like not swapped but later on format stack it'll reversed

      iex(71)> e = Exercism.Forth.eval n, "1 2 3 swap"
      %{dictionary: %{}, stack: [2, 3, 1]}

      iex(74)> e = Exercism.Forth.eval n, "1 2 3 over"
      %{dictionary: %{}, stack: [2, 3, 2, 1]}

      iex(92)> e = Exercism.Forth.eval n, ": dup-twice dup dup ;"
      %{dictionary: %{"dup-twice" => "dup dup"}, stack: []}
      iex(93)> e2 = Exercism.Forth.eval e, "1 dup-twice"
      %{dictionary: %{"dup-twice" => "dup dup"}, stack: [1, 1, 1]}

      iex(94)> e = Exercism.Forth.eval n, ": countup 1 2 3 ;"
      %{dictionary: %{"countup" => "1 2 3"}, stack: []}
      iex(95)> e2 = Exercism.Forth.eval e, "countup"
      %{dictionary: %{"countup" => "1 2 3"}, stack: [3, 2, 1]}

      iex(96)> e = Exercism.Forth.eval n, ": foo dup ;"
      %{dictionary: %{"foo" => "dup"}, stack: []}
      iex(97)> e2 = Exercism.Forth.eval e, ": foo dup dup ;"
      %{dictionary: %{"foo" => "dup dup"}, stack: []}
      iex(98)> e3 = Exercism.Forth.eval e2, "1 foo"
      %{dictionary: %{"foo" => "dup dup"}, stack: [1, 1, 1]}

      iex(99)> e = Exercism.Forth.eval n, ": swap dup ;"        # can overwrite known function
      %{dictionary: %{"swap" => "dup"}, stack: []}
      iex(100)> e2 = Exercism.Forth.eval e, "1 swap"
      %{dictionary: %{"swap" => "dup"}, stack: [1, 1]}

      iex(7)> e = Exercism.Forth.eval n, ": + * ;"
      %{dictionary: %{"+" => "*"}, stack: []}
      iex(8)> e2 = Exercism.Forth.eval e, " 1 2 +"
      %{dictionary: %{"+" => "*"}, stack: [2]}

      iex(42)> e = Exercism.Forth.eval n, ": foo 10 ;"
      %{dictionary: %{"foo" => "10"}, stack: []}
      iex(43)> e2 = Exercism.Forth.eval e, ": foo foo 1 + ;"
      %{dictionary: %{"foo" => "10 1 +"}, stack: []}
      iex(44)> e3 = Exercism.Forth.eval e2, "foo"
      %{dictionary: %{"foo" => "10 1 +"}, stack: [11]}

  """
  @spec eval(evaluator, String.t()) :: evaluator
  def eval(ev, s), do: (
    if String.starts_with?(s, ":"), do:
      s |> process_token_with_dictionary(ev),
    else:
      s |> String.downcase |> String.split(~r/\s+|(?<!\B-)[^\w-+\-*\/:]+/u, trim: true) |> Enum.reduce(ev, &process_token/2)
  )

  defp process_token("+" = token, %{stack: [a, b | rest], dictionary: dictionary} = evaluator), do: (
    if dictionary[token] !== nil, do: eval(evaluator, dictionary[token]), else: %{evaluator | stack: [a + b | rest]}
  )

  defp process_token("-" = token, %{stack: [a, b | rest], dictionary: dictionary} = evaluator), do: (
    if dictionary[token] !== nil, do: eval(evaluator, dictionary[token]), else: %{evaluator | stack: [b - a | rest]}
  )

  defp process_token("*" = token, %{stack: [a, b | rest], dictionary: dictionary} = evaluator), do: (
    if dictionary[token] !== nil, do: eval(evaluator, dictionary[token]), else: %{evaluator | stack: [a * b | rest]}
  )

  defp process_token("/", %{stack: [a | _]}) when a == 0, do: raise DivisionByZero

  defp process_token("/" = token, %{stack: [a, b | rest], dictionary: dictionary} = evaluator), do: (
    if dictionary[token] !== nil, do: eval(evaluator, dictionary[token]), else: %{evaluator | stack: [div(b, a) | rest]}
  )

  defp process_token("dup", %{stack: [a | _] = stack} = evaluator), do: %{evaluator | stack: [a | stack]}

  defp process_token("drop", %{stack: [_ | rest]} = evaluator), do: %{evaluator | stack: rest}

  defp process_token("swap", %{stack: [a, b | rest]} = evaluator), do: %{evaluator | stack: [b, a | rest]}

  defp process_token("over", %{stack: [_, b | _] = stack} = evaluator), do: %{evaluator | stack: [b | stack]}

  defp process_token(token, evaluator) when is_binary(token), do: (
    cond do
      Regex.match?(~r/^[-]?\d+$/, token) -> %{evaluator | stack: [String.to_integer(token) | evaluator.stack]}
      Map.has_key?(evaluator.dictionary, String.downcase(token)) -> eval(evaluator, Map.get(evaluator.dictionary, String.downcase(token)))
      token not in ~w(- + / * swap dup over drop) -> raise UnknownWord, word: token
      true -> raise StackUnderflow
    end
  )

  defp process_token_with_dictionary(token, evaluator), do: (
    case Regex.run(~r/^:\s*(\S+)\s+(.+?)\s*;\s*/, token, capture: :all_but_first), do:
      (
        [word, definition] ->
          if Regex.match?(~r/^[-]?\d+$/, word), do: (raise InvalidWord, word: word)
          new_definition =
            definition
            |> String.split(~r/\s+/, trim: true)
            |> Enum.flat_map(fn def ->
                case evaluator.dictionary[def], do: (
                  nil -> [def]
                  value -> String.split(value, ~r/\s+/, trim: true)
                )
              end)
            |> Enum.join(" ")
          %{evaluator | dictionary: Map.put(evaluator.dictionary, String.downcase(word), new_definition)}
        _ -> raise InvalidWord, word: token
      )
    )

  @doc """
  Return the current stack as a string with the element on top of the stack
  being the rightmost element in the string.

    ## Example:

      iex(12)> e = Exercism.Forth.eval n, "-1 -2 -3 -4 -5"
      %{dictionary: %{}, stack: [-5, -4, -3, -2, -1]}
      iex(13)> Exercism.Forth.format_stack e
      "-1 -2 -3 -4 -5"

  """
  @spec format_stack(evaluator) :: String.t()
  def format_stack(%{stack: [], dictionary: dictionary}), do: dictionary |> Map.values |> Enum.join(" ")

  def format_stack(%{stack: stack}), do: stack |> Enum.reverse |> Enum.join(" ")

  defmodule StackUnderflow do
    defexception []
    def message(_), do: "stack underflow"
  end

  defmodule InvalidWord do
    defexception word: nil
    def message(e), do: "invalid word: #{inspect(e.word)}"
  end

  defmodule UnknownWord do
    defexception word: nil
    def message(e), do: "unknown word: #{inspect(e.word)}"
  end

  defmodule DivisionByZero do
    defexception []
    def message(_), do: "division by zero"
  end
end
