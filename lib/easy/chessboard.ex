defmodule Exercism.Chessboard do

  @spec rank_range :: Range.t()
  def rank_range, do: 1..8

  @spec file_range :: Range.t()
  def file_range, do: ?A..?H

  @spec ranks :: [integer()]
  def ranks, do: rank_range() |> Range.to_list

  @spec files :: [String.t()]
  def files, do: file_range() |> Enum.map(&<<&1::utf8>>)
end
