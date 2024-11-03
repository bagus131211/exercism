defmodule Exercism.TwoBucket do
  alias Exercism.TwoBucket
  defstruct [:bucket_one, :bucket_two, :moves]
  @type t :: %TwoBucket{bucket_one: integer, bucket_two: integer, moves: integer}

  @doc """
  Find the quickest way to fill a bucket with some amount of water from two buckets of specific sizes.

    ## Example:

      iex(23)> Exercism.TwoBucket.measure 3, 5, 1, :one
      {:ok, %Exercism.TwoBucket{bucket_one: 1, bucket_two: 5, moves: 4}}

      iex(24)> Exercism.TwoBucket.measure 3, 5, 1, :two
      {:ok, %Exercism.TwoBucket{bucket_one: 1, bucket_two: 3, moves: 8}}

      iex(66)> Exercism.TwoBucket.measure 2, 3, 3, :one
      {:ok, %Exercism.TwoBucket{bucket_one: 2, bucket_two: 3, moves: 2}}

  """
  @spec measure(
          size_one :: integer,
          size_two :: integer,
          goal :: integer,
          start_bucket :: :one | :two
        ) :: {:ok, TwoBucket.t()} | {:error, :impossible}
  def measure(size_one, size_two, goal, start_bucket), do: method(size_one, size_two, goal, start_bucket, MapSet.new)

  defp method(size_one, size_two, goal, :one, visited), do: solve(size_one, size_two, goal, size_one, 0, 1, visited)

  defp method(size_one, size_two, goal, :two, visited), do: solve(size_two, size_one, goal, size_two, 0, 1, MapSet.put(visited, :two))

  defp solve(size_one, size_two, target, bucket_one, bucket_two, moves, visited), do:
    (
      cond do:
      (
        MapSet.member?(visited, :two) and (bucket_one == target or bucket_two == target) ->
          {:ok, %TwoBucket{bucket_one: bucket_two, bucket_two: bucket_one, moves: moves}}
        bucket_one == target or bucket_two == target ->
          {:ok, %TwoBucket{bucket_one: bucket_one, bucket_two: bucket_two, moves: moves}}
        MapSet.member?(visited, {bucket_one, bucket_two}) ->
          {:error, :impossible}
        true ->
          new_visited = MapSet.put(visited, {bucket_one, bucket_two})
          [
            solve(size_one, size_two, target, size_one, bucket_two, moves + 1, new_visited), # filling bucket one
            solve(size_one, size_two, target, 0, bucket_two, moves + 1, new_visited),        # emptying bucket one
            solve(size_one, size_two, target, bucket_one, size_two, moves + 1, new_visited), # filling bucket two
            solve(size_one, size_two, target, bucket_one, 0, moves + 1, new_visited),        # emptying bucket two
            pour(bucket_one, bucket_two, target, size_one, size_two, moves, new_visited)     # casting each other
          ]
          |> Enum.reduce(nil, fn
            {:ok, result}, nil ->
              {:ok, result}
            {:ok, result}, {:ok, acc} ->
              if result.moves < acc.moves do
                {:ok, result}
              else
                {:ok, acc}
              end
            {:error, :impossible}, acc ->
              acc
            nil, acc ->
              acc
             end) || {:error, :impossible}
      )
    )

  defp pour(bucket_one, bucket_two, target, size_one, size_two, moves, visited), do:
    (
      if bucket_one > 0 and bucket_two < size_two, do:
        (
          cast = min(bucket_one, size_two - bucket_two)
          solve(size_one, size_two, target, bucket_one - cast, bucket_two + cast, moves + 1, visited)
        ),
      else:
        {:error, :impossible}
    )
end
