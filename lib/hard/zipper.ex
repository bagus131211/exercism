defmodule Exercism.Zipper do
  alias Exercism.{BinTree, Zipper}

  defstruct focus: nil, path: []

  @type t :: %Zipper{
    focus: BinTree.t() | nil,
    path: []
  }

  @doc """
  Get a zipper focused on the root node.
  """
  @spec from_tree(BinTree.t()) :: Zipper.t()
  def from_tree(bin_tree), do: %Zipper{focus: bin_tree}

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Zipper.t()) :: BinTree.t()
  def to_tree(%Zipper{focus: nil}), do: nil

  def to_tree(%Zipper{focus: focus, path: []}), do: focus

  def to_tree(zipper), do: zipper |> up |> to_tree

  @doc """
  Get the value of the focus node.
  """
  @spec value(Zipper.t()) :: any
  def value(zipper), do: zipper.focus.value

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Zipper.t()) :: Zipper.t() | nil
  def left(zipper), do: (if zipper.focus.left, do:
    %Zipper{focus: zipper.focus.left, path: [{:left, %BinTree{value: value(zipper), right: zipper.focus.right}} | zipper.path]})

  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Zipper.t()) :: Zipper.t() | nil
  def right(zipper), do: (if zipper.focus.right, do:
    %Zipper{focus: zipper.focus.right, path: [{:right, %BinTree{value: value(zipper), left: zipper.focus.left}} | zipper.path]})

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(t) :: t | nil
  def up(%Zipper{path: []}), do: nil

  def up(%Zipper{focus: focus, path: [{dir, parent} | path]}), do: %Zipper{focus: %{parent | dir => focus}, path: path}

  # def up(%Zipper{path: [{:left, parent} | path]}), do: %Zipper{focus: parent, path: path}

  # def up(%Zipper{path: [{:right, parent} | path]}), do: %Zipper{focus: parent, path: path}

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Zipper.t(), any) :: Zipper.t()
  def set_value(zipper, value), do: %Zipper{zipper | focus: %BinTree{zipper.focus | value: value}}

  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_left(zipper, left), do: %Zipper{zipper | focus: %BinTree{zipper.focus | left: left}}

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_right(zipper, right), do: %Zipper{zipper | focus: %BinTree{zipper.focus | right: right}}
end
