defmodule Exercism.Pov do
  @typedoc """
  A tree, which is made of a node with several branches
  """
  @type tree :: {any, [tree]}

  @doc """
  Reparent a tree on a selected node.
  """
  @spec from_pov(tree :: tree, node :: any) :: {:ok, tree} | {:error, atom}
  def from_pov({root, _children} = tree, node) when root === node, do: {:ok, tree}

  def from_pov(tree, node), do: (
    case find_node(tree, node, []), do: (
      nil -> {:error, :nonexistent_target}
      parent -> {:ok, reparent(parent)}
    )
  )

  defp find_node(tree, target, path \\ [])

  defp find_node({target, _children} = tree, target, path), do: Enum.reverse([tree | path])

  defp find_node({_value, []}, _target, _path), do: nil

  defp find_node({value, children}, target, path), do:
    children |> Enum.reduce_while(nil, fn child, _acc ->
      case find_node(child, target, [{value, children -- [child]} | path]), do: (
        nil -> {:cont, nil}
        found -> {:halt, found}
      )
    end)

  defp reparent([tree]), do: tree

  defp reparent([child, parent | path]), do: reparent([add_child(parent, child) | path])

  defp add_child({value, children}, child), do: {value, [child | children]}

  @doc """
  Finds a path between two nodes
  """
  @spec path_between(tree :: tree, from :: any, to :: any) :: {:ok, [any]} | {:error, atom}
  def path_between(tree, from, to), do: (
    with {:ok, new_tree} <- from_pov(tree, from),
      path when is_list(path) <- find_node(new_tree, to) do
    {:ok, path |> Enum.map(&elem(&1, 0))}
    else
      {:error, :nonexistent_target} -> {:error, :nonexistent_source}
      nil -> {:error, :nonexistent_destination}
    end
  )
end
