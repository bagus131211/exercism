defmodule Exercism.Sieve do
  @moduledoc """
  Instructions
    Your task is to create a program that implements the Sieve of Eratosthenes algorithm to find all
    prime numbers less than or equal to a given number.

    A prime number is a number larger than 1 that is only divisible by 1 and itself.
    For example, 2, 3, 5, 7, 11, and 13 are prime numbers.
    By contrast, 6 is not a prime number as it not only divisible by 1 and itself, but also by 2 and 3.

    To use the Sieve of Eratosthenes, you first create a list of all the numbers between 2 and your given number.
    Then you repeat the following steps:

      Find the next unmarked number in your list (skipping over marked numbers). This is a prime number.
      Mark all the multiples of that prime number as not prime.
      You keep repeating these steps until you've gone through every number in your list. At the end, all the unmarked numbers are prime.

    Note
      The tests don't check that you've implemented the algorithm, only that you've come up with the correct list of primes.
      To check you are implementing the Sieve correctly,
      a good first test is to check that you do not use division or remainder operations.

    Example
      Let's say you're finding the primes less than or equal to 10.

        List out 2, 3, 4, 5, 6, 7, 8, 9, 10, leaving them all unmarked.
        2 is unmarked and is therefore a prime. Mark 4, 6, 8 and 10 as "not prime".
        3 is unmarked and is therefore a prime. Mark 6 and 9 as not prime (marking 6 is optional - as it's already been marked).
        4 is marked as "not prime", so we skip over it.
        5 is unmarked and is therefore a prime. Mark 10 as not prime (optional - as it's already been marked).
        6 is marked as "not prime", so we skip over it.
        7 is unmarked and is therefore a prime.
        8 is marked as "not prime", so we skip over it.
        9 is marked as "not prime", so we skip over it.
        10 is marked as "not prime", so we stop as there are no more numbers to check.
        You've examined all numbers and found 2, 3, 5, and 7 are still unmarked, which means they're the primes less than or equal to 10.
  """

  @doc """
  Generates a list of primes up to a given limit.

    Example:

      iex(76)> Exercism.Sieve.primes_to 100
      [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97]
      iex(77)> Exercism.Sieve.primes_to 10
      [2, 3, 5, 7]
      iex(78)> Exercism.Sieve.primes_to 15
      [2, 3, 5, 7, 11, 13]

  """
  @spec primes_to(non_neg_integer) :: [non_neg_integer]
  def primes_to(limit) when limit >= 2, do:
    2..limit
      |> Enum.map(& %{point: &1, state: :unmarked})
      |> (& Enum.reduce(&1, &1, fn %{point: point, state: :unmarked}, acc ->
          if point > :math.sqrt(limit), do:
            acc,
          else:
            (filtered = acc |> Enum.filter(fn p -> p.state == :unmarked end)
              filtered
                |> Enum.reduce_while(filtered, fn %{point: next}, acc2 ->
                    if point * next <= limit,
                      do:
                        (new_acc = Enum.map(acc2, fn %{point: p} = item ->
                          if p == point * next, do: %{item | state: :marked}, else: item
                        end)
                        {:cont, new_acc}),
                      else:
                        ({:halt, acc2})
                    end))
      end)).()
      |> Enum.filter(& &1.state == :unmarked)
      |> Enum.map(& &1.point)

  def primes_to(_), do: []
end
