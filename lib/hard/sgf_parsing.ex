defmodule Exercism.SgfParsing do
  defmodule Sgf do
    defstruct properties: %{}, children: []
  end

  @type sgf :: %Sgf{properties: map, children: [sgf]}

  @doc """
  Parse a string into a Smart Game Format tree

    ## Example:

      iex(489)> Exercism.SgfParsing.parse "(;A[B](;B[C])(;C[D]))"
      {:ok,
      %Exercism.SgfParsing.Sgf{
        properties: %{"A" => ["B"]},
        children: [
          %Exercism.SgfParsing.Sgf{properties: %{"B" => ["C"]}, children: []},
          %Exercism.SgfParsing.Sgf{properties: %{"C" => ["D"]}, children: []}
        ]
      }}

      iex(490)> Exercism.SgfParsing.parse "(;A[b][c][d])"
      {:ok, %Exercism.SgfParsing.Sgf{properties: %{"A" => ["b", "c", "d"]}, children: []}}

      iex(492)> Exercism.SgfParsing.parse "(;A[\\]])"
      {:ok, %Exercism.SgfParsing.Sgf{properties: %{"A" => ["]"]}, children: []}}

      iex(493)> Exercism.SgfParsing.parse "(;A[\\\\])"
      {:ok, %Exercism.SgfParsing.Sgf{properties: %{"A" => ["\\"]}, children: []}}

  """
  @spec parse(encoded :: String.t()) :: {:ok, sgf} | {:error, String.t()}
  def parse(encoded) when is_binary(encoded), do: (
    cond do
      encoded in ["",";"] -> {:error, "tree missing"}
      encoded === "()" -> {:error, "tree with no nodes"}
      encoded === "(;)" -> {:ok, %Sgf{}}
      true -> parse_tree(encoded)
    end
  )

  defp parse_tree(encoded) do
    try do
      encoded
        |> String.replace(~r/\\\t/, " ")
        |> String.replace(~r/\\\n/, "")
        |> String.replace(~r/\\t/, "t")
        |> String.replace(~r/\\n/, "n")
        |> String.replace(~r/\t/, " ")
        |> String.replace("\\\\", "**")
        |> String.replace(~r/\[(\w+)\[/, "[\\1\\[")
        |> String.replace("\\[", "<")
        |> String.replace("\\]", ">")
        |> String.replace("][", ",")
        |> upcases?
        |> then(&Regex.scan(~r/(;?)([A-Z]+)\[([^\[\]]+)\]/, &1))
        |> delimiters?
        |> Enum.map(fn [_, tree, key, value] ->
          [tree, Map.new([{key, normalize(value)}])]
        end)
        |> Enum.reduce(%{children: []}, &merge/2)
        |> then(&{:ok, struct(Sgf, &1)})
    catch
      error -> {:error, error}
    end
  end

  defp upcases?(encoded), do:
    Regex.scan(~r/(\w)\[/, encoded, capture: :all_but_first)
    |> List.flatten
    |> Enum.all?(& &1 == String.upcase(&1))
    |> (case do
          true -> encoded
          false -> throw "property must be in uppercase"
       end)

  defp delimiters?([]), do: throw "properties without delimiter"

  defp delimiters?(nodes), do: nodes

  defp normalize(value), do:
    value
      |> String.replace("**", "\\")
      |> String.replace("<", "\[")
      |> String.replace(">", "\]")
      |> String.replace("\\n", "\n")
      |> String.replace("\\t", " ")
      |> String.split(",")

  defp merge([tree, map], acc), do: (
    IO.inspect({tree, map, acc})
    cond do
      tree == ";" && !acc[:properties] -> Map.merge(acc, %{properties: map})
      tree == "" -> %{acc | properties: Map.merge(acc.properties, map)}
      true -> %{acc | children: acc.children ++ [%Sgf{properties: map}]}
    end
  )

  #----------------------------------------- Working but unfinished -------------------------------------------------
  # @spec parse(encoded :: String.t()) :: {:ok, sgf} | {:error, String.t()}
  # def parse(encoded) when is_binary(encoded) do
  #   trimmed = String.trim(encoded)
  #   if String.starts_with?(trimmed, "(") and String.ends_with?(trimmed, ")") do
  #     trimmed
  #     |> String.slice(1..-2//1)
  #     |> parse_tree()
  #   else
  #     {:error, "tree missing"}
  #   end
  # end

  # defp parse_tree(encoded) do
  #   case parse_nodes(encoded) do
  #     {:error, reason} -> {:error, reason}
  #     {nil, _} -> {:error, "tree with no nodes"}
  #     {sgf_node, ""} -> {:ok, sgf_node}
  #     _ -> {:error, "properties without delimiter"}
  #   end
  # end

  # defp parse_nodes(encoded) do
  #   case parse_node(encoded) do
  #     {:error, _} = error -> error
  #     {parsed_node, rest} when not is_nil(parsed_node) ->
  #       {children, remaining} = parse_child_nodes(rest)
  #       {%Sgf{parsed_node | children: children}, remaining}
  #     _ -> {nil, encoded}
  #   end
  # end

  # defp parse_child_nodes(""), do: {[], ""}
  # defp parse_child_nodes(encoded) do
  #   Regex.scan(~r/(;[A-Z]\[[^\]]*\])|(\(\s*[^()]*\s*\))/, encoded)
  #     |> Enum.reduce({[], encoded}, fn match, {children, remaining} ->
  #       case List.first(match) do
  #       nil -> {children, remaining}  # If there's no valid child match
  #       child ->
  #       # Recursively parse the child node
  #       case parse_nodes(child) do
  #         {:error, _} = error -> error
  #         {child_node, rest} ->
  #           {[child_node | children], String.trim(rest)}
  #         end
  #       end
  #     end)
  # end

  # defp parse_node(encoded) do
  #   encoded = Regex.replace(~r/([^;]*?;[A-Z]\[(?:[^\\\]]|\\.)*\]((?:\[[^\]]*\])*)(?=[^;]*$)|[^;]*)/, encoded, "\\1")
  #   case String.split(encoded, ";", parts: 2) do
  #     [_empty, ""] -> {%Sgf{}, ""}
  #     [_empty, rest] ->
  #       case parse_properties(rest) do
  #         {:error, _} = error -> error
  #         {properties, remaining} -> {%Sgf{properties: properties, children: []}, remaining}
  #       end
  #     _ -> {nil, encoded}
  #   end
  # end

  # defp parse_properties(encoded) do
  #   cond do
  #     # Detect a property with no delimiter (e.g., (;A))
  #     String.match?(encoded, ~r/^[A-Z]$/) ->
  #       {:error, "properties without delimiter"}

  #     # Check for lowercase properties and throw error if any are found
  #     String.match?(encoded, ~r/(^|;)[a-z]+\[.*\]/) ->
  #       {:error, "property must be in uppercase"}

  #     true ->
  #       # Parse valid properties
  #       # [result, key, value] = if :binary.matches(encoded, ";") |> length >= 1 do
  #       #   [result, key, value] = Regex.run(~r/([A-Z]+)\[((?:[^\\\]]|\\.)+)\]/, encoded) |> IO.inspect
  #       #   value = parse_property_values(value)
  #       #   [result, key, value]
  #       # else
  #       #   [_, key | _] = Regex.run(~r/^([A-Z]+)/, encoded)
  #       #   values = Regex.scan(~r/\[((?:[^\\\]]|\\.)+)\]/, encoded) |> Enum.map(fn [_, value] -> value end)

  #       #   [result, key, value] = [encoded, key, values |> Enum.flat_map(&parse_property_values/1)]
  #       #   [result, key, value]
  #       # end
  #       process_encoded = String.split(encoded, ";") |> List.first
  #       matches = Regex.scan(~r/([A-Z]+)\[((?:[^\\\]]|\\.)+)\]/, process_encoded, captures: :all_but_first) |> IO.inspect
  #       result = matches |> Enum.reduce(%{}, fn [_ , key, val], acc ->
  #         value = parse_property_values(val)
  #         updated = Map.update(acc, key, [value], fn v -> [value | v] end)
  #         updated
  #       end)

  #       remaining_str = String.replace(encoded, process_encoded, "")
  #       {result, remaining_str}
  #   end
  # end

  # defp parse_property_values(value) do
  #   String.split(value, "][")
  #   |> Enum.map(fn v ->
  #     v
  #     |> String.replace("\t", " ")
  #     |> String.replace("\\]", "]")
  #     |> String.replace("\\\\", "\\")
  #     |> String.trim()
  #   end)
  # end
end
