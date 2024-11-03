defmodule Exercism.LinkedList do
  @moduledoc """
  You work for a music streaming company.

  You've been tasked with creating a playlist feature for your music player application.

  Instructions
    Write a prototype of the music player application.

    For the prototype, each song will simply be represented by a number.
    Given a range of numbers (the song IDs), create a singly linked list.

    Given a singly linked list, you should be able to reverse the list to play the songs in the opposite order.

  Note
    The linked list is a fundamental data structure in computer science, often used in the implementation of other data structures.

    The simplest kind of linked list is a singly linked list. That means that each element (or "node") contains data,
    along with something that points to the next node in the list.

  If you want to dig deeper into linked lists, check out this article that explains it using nice drawings.
  """
  @opaque t :: {any, t} | nil

  @doc """
  Construct a new LinkedList

    Example:

      iex(26)> n = Exercism.LinkedList.new
      nil

  """
  @spec new() :: t
  def new(), do: nil

  @doc """
  Push an item onto a LinkedList

    Example:

      iex(27)> Exercism.LinkedList.push n, 20
      {20, nil}

  """
  @spec push(t, any()) :: t
  def push(nil, elem), do: {elem, nil}

  def push(list, elem), do: {elem, list}

  @doc """
  Counts the number of elements in a LinkedList

    Example:

      iex(32)> Exercism.LinkedList.count n
      3

  """
  @spec count(t) :: non_neg_integer()
  def count(nil), do: 0

  def count({_, tail}), do: 1 + count(tail)

  @doc """
  Determine if a LinkedList is empty

    Example:

      iex(33)> Exercism.LinkedList.empty? n
      false

  """
  @spec empty?(t) :: boolean()
  def empty?(list), do: list |> count == 0

  @doc """
  Get the value of a head of the LinkedList

    Example:

      iex(35)> Exercism.LinkedList.peek n
      {:ok, 21}
      iex(36)> x = Exercism.LinkedList.new
      nil
      iex(37)> Exercism.LinkedList.peek x
      {:error, :empty_list}

  """
  @spec peek(t) :: {:ok, any()} | {:error, :empty_list}
  def peek(nil), do: {:error, :empty_list}

  def peek({head, _}), do: {:ok, head}

  @doc """
  Get tail of a LinkedList

    Example:

      iex(38)> Exercism.LinkedList.tail n
      {:ok, {20, {20, nil}}}
      iex(39)> Exercism.LinkedList.tail x
      {:error, :empty_list}

  """
  @spec tail(t) :: {:ok, t} | {:error, :empty_list}
  def tail(nil), do: {:error, :empty_list}

  def tail({_, tail}), do: {:ok, tail}

  @doc """
  Remove the head from a LinkedList

    Example:

      iex(40)> Exercism.LinkedList.pop n
      {:ok, 21, {20, {20, nil}}}
      iex(41)> Exercism.LinkedList.pop x
      {:error, :empty_list}

  """
  @spec pop(t) :: {:ok, any(), t} | {:error, :empty_list}
  def pop(nil), do: {:error, :empty_list}

  def pop({head, tail}), do: {:ok, head, tail}

  @doc """
  Construct a LinkedList from a stdlib List

    Example:

      iex(47)> Exercism.LinkedList.from_list []
      nil
      iex(48)> Exercism.LinkedList.from_list [:a, :b]
      {:a, {:b, nil}}

  """
  @spec from_list(list()) :: t
  def from_list([]), do: new()

  def from_list([head | tail]), do: push(from_list(tail), head)

  @doc """
  Construct a stdlib List LinkedList from a LinkedList

    Example:

      iex(59)> Exercism.LinkedList.to_list nil
      []
      iex(60)> Exercism.LinkedList.to_list {:a, {:b, {:c, nil}}}
      [:a, :b, :c]

  """
  @spec to_list(t) :: list()
  def to_list(nil), do: []

  def to_list({head, tail}), do: [head | to_list(tail)]

  @doc """
  Reverse a LinkedList

    Example:

      iex(61)> Exercism.LinkedList.reverse {:a, {:b, {:c, nil}}}
      {:c, {:b, {:a, nil}}}

  """
  @spec reverse(t) :: t
  def reverse(list), do: reverse(list, new())

  defp reverse(nil, acc), do: acc

  defp reverse({head, tail}, acc), do: reverse(tail, push(acc, head))
end
