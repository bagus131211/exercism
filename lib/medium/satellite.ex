defmodule Exercism.Satellite do
  @moduledoc """
  Imagine you need to transmit a binary tree to a satellite approaching Alpha Centauri and you have limited bandwidth.
  Since the tree has no repeating items it can be uniquely represented by its pre-order and in-order traversals.

  Write the software for the satellite to rebuild the tree from the traversals.

  A pre-order traversal reads the value of the current node before (hence "pre") reading the left subtree in pre-order.
  Afterwards the right subtree is read in pre-order.

  An in-order traversal reads the left subtree in-order then the current node and finally the right subtree in-order.
  So in order from left to right.

  For example the pre-order traversal of this tree is [a, i, x, f, r]. The in-order traversal of this tree is [i, a, f, x, r]

        a
      / \
      i   x
        / \
        f   r
  Note: the first item in the pre-order traversal is always the root.
  """

  @typedoc """
  A tree, which can be empty, or made from a left branch, a node and a right branch
  """
  @type tree :: {} | {tree, any, tree}

  @doc """
  Build a tree from the elements given in a pre-order and in-order style

    Example:

      iex(14)> Exercism.Satellite.build_tree ~w(a i x f r), ~w(i a f x r)
      {:ok, {{{}, "i", {}}, "a", {{{}, "f", {}}, "x", {{}, "r", {}}}}}

      iex(15)> Exercism.Satellite.build_tree [], []
      {:ok, {}}

      iex(16)> Exercism.Satellite.build_tree [:a, :b], [:a, :b, :d]
      {:error, "traversals must have the same length"}

      iex(17)> Exercism.Satellite.build_tree [:a, :b, :e], [:a, :b, :c]
      {:error, "traversals must have the same elements"}

      iex(21)> Exercism.Satellite.build_tree [:a, :b, :a], [:a, :a, :b]
      {:error, "traversals must contain unique items"}

  """
  @spec build_tree(preorder :: [any], inorder :: [any]) :: {:ok, tree} | {:error, String.t()}

  def build_tree(preorder, inorder), do:
    (cond do:
      (
        length(preorder) !== length(inorder) -> {:error, "traversals must have the same length"}
        Enum.sort(preorder) !== Enum.sort(inorder) -> {:error, "traversals must have the same elements"}
        Enum.frequencies(preorder) |> Enum.any?(fn {_key, count} -> count > 1 end) -> {:error, "traversals must contain unique items"}
        true -> {:ok, traverse(preorder, inorder)}
      )
    )

  defp traverse([], []), do: {}

  defp traverse([head | tail], inorder) do
    {left_in, [_head | right_in]} = inorder |> Enum.split_while(& &1 !== head)

    left_pre = tail |> Enum.take(left_in |> length)
    right_pre = tail |> Enum.drop(left_in |> length)

    left_sub_tree = traverse(left_pre, left_in)
    right_sub_tree = traverse(right_pre, right_in)

    {left_sub_tree, head, right_sub_tree}
  end
end
