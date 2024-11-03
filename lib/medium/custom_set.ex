defmodule Exercism.CustomSet do
  @opaque t :: %__MODULE__{map: map}

  defstruct map: %{}

  @doc """
  New set of yours

    Example:

      iex(56)> n = Exercism.CustomSet.new []
      %Exercism.CustomSet{map: %{}}
      iex(57)> v = Exercism.CustomSet.new [1,2,2,3,3,4,4,4,4]
      %Exercism.CustomSet{map: %{1 => true, 2 => true, 3 => true, 4 => true}}

  """
  @spec new(Enum.t()) :: t
  def new([]), do: %__MODULE__{}

  def new(enumerable), do: enumerable |> Enum.uniq |> Enum.into(%{}, & {&1, true}) |> then(& %__MODULE__{map: &1})

  @doc """
  Check if you set empty or not

    Example:

      iex(58)> Exercism.CustomSet.empty? n
      true
      iex(59)> Exercism.CustomSet.empty? v
      false

  """
  @spec empty?(t) :: boolean
  def empty?(custom_set), do: map_size(custom_set.map) == 0

  @doc """
  Check if your set is contains mentioned element

    Example:

      iex(60)> Exercism.CustomSet.contains? n, 4
      false
      iex(61)> Exercism.CustomSet.contains? v, 4
      true

  """
  @spec contains?(t, any) :: boolean
  def contains?(custom_set, element), do: Map.has_key?(custom_set.map, element)

  @doc """
  Check if set1 is subset of set 2

    Example:

      iex(62)> Exercism.CustomSet.subset? n, v
      true
      iex(63)> Exercism.CustomSet.subset? v, n
      false
      iex(64)> Exercism.CustomSet.subset? n2, v
      true

  """
  @spec subset?(t, t) :: boolean
  def subset?(custom_set_1, custom_set_2), do: Map.keys(custom_set_1.map) |> Enum.all?(&Map.has_key?(custom_set_2.map, &1))

  @doc """
  Check if set1 is disjoint of anaother set2

    Example:

      iex(65)> Exercism.CustomSet.disjoint? n, v
      true
      iex(66)> Exercism.CustomSet.disjoint? v, n
      true
      iex(67)> Exercism.CustomSet.disjoint? n2, v
      false
      iex(68)> Exercism.CustomSet.disjoint? n1, v
      false
      iex(69)> Exercism.CustomSet.disjoint? v, n1
      false

  """
  @spec disjoint?(t, t) :: boolean
  def disjoint?(custom_set_1, custom_set_2), do: intersection(custom_set_1, custom_set_2) |> empty?

  @doc """
  Check if two sets is equal each other

    Example:

      iex(70)> Exercism.CustomSet.equal? n, v
      false
      iex(71)> Exercism.CustomSet.equal? n1, v
      false
      iex(72)> Exercism.CustomSet.equal? n2, v
      true

  """
  @spec equal?(t, t) :: boolean
  def equal?(custom_set_1, custom_set_2), do: subset?(custom_set_1, custom_set_2) && subset?(custom_set_2, custom_set_1)

  @doc """
  Add new element to existing set

    Example:

      iex(73)> Exercism.CustomSet.add v, 5
      %Exercism.CustomSet{
        map: %{1 => true, 2 => true, 3 => true, 4 => true, 5 => true}
      }
      iex(74)> Exercism.CustomSet.add n, 5
      %Exercism.CustomSet{map: %{5 => true}}

  """
  @spec add(t, any) :: t
  def add(%__MODULE__{map: map}, element), do: %__MODULE__{map: Map.put(map, element, true)}

  @doc """
  Get intersection from set1 and set2

    Example:

      iex(75)> Exercism.CustomSet.intersection v, n
      %Exercism.CustomSet{map: %{}}
      iex(76)> Exercism.CustomSet.intersection n, v
      %Exercism.CustomSet{map: %{}}
      iex(77)> Exercism.CustomSet.intersection n1, v
      %Exercism.CustomSet{map: %{1 => true, 2 => true, 3 => true}}
      iex(78)> Exercism.CustomSet.intersection v, n1
      %Exercism.CustomSet{map: %{1 => true, 2 => true, 3 => true}}
      iex(79)> Exercism.CustomSet.intersection v, n2
      %Exercism.CustomSet{map: %{1 => true, 2 => true, 3 => true, 4 => true}}
      iex(80)> Exercism.CustomSet.intersection n2, v
      %Exercism.CustomSet{map: %{1 => true, 2 => true, 3 => true, 4 => true}}

  """
  @spec intersection(t, t) :: t
  def intersection(custom_set_1, custom_set_2), do:
    %__MODULE__{
      map: Enum.reduce(Map.keys(custom_set_1.map), %{},
        fn key, acc -> if contains?(custom_set_2, key), do: Map.put(acc, key, true), else: acc end)
    }

  @doc """
  Get diff between two sets

    Example:

      iex(82)> Exercism.CustomSet.difference v, n
      %Exercism.CustomSet{map: %{1 => true, 2 => true, 3 => true, 4 => true}}
      iex(83)> Exercism.CustomSet.difference n, v
      %Exercism.CustomSet{map: %{}}
      iex(84)> Exercism.CustomSet.difference v, n1
      %Exercism.CustomSet{map: %{4 => true}}

  """
  @spec difference(t, t) :: t
  def difference(custom_set_1, custom_set_2), do:
  %__MODULE__{
    map: Enum.reduce(Map.keys(custom_set_1.map), %{},
      fn key, acc -> if not contains?(custom_set_2, key), do: Map.put(acc, key, true), else: acc end)
  }

  @doc """
  Merge 2 maps

    Example:

      iex(86)> Exercism.CustomSet.union v, n
      %Exercism.CustomSet{map: %{1 => true, 2 => true, 3 => true, 4 => true}}
      iex(87)> Exercism.CustomSet.union n, n1
      %Exercism.CustomSet{map: %{1 => true, 2 => true, 3 => true}}
      iex(88)> Exercism.CustomSet.union n1, n2
      %Exercism.CustomSet{map: %{1 => true, 2 => true, 3 => true, 4 => true}}
      iex(89)> Exercism.CustomSet.union v, n2
      %Exercism.CustomSet{map: %{1 => true, 2 => true, 3 => true, 4 => true}}

  """
  @spec union(t, t) :: t
  def union(custom_set_1, custom_set_2), do: Map.merge(custom_set_1.map, custom_set_2.map) |> then(& %__MODULE__{map: &1})
end
