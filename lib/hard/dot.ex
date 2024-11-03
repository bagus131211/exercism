defmodule Exercism.Dot do
  @moduledoc """
  Instructions
  A Domain Specific Language (DSL) is a small language optimized for a specific domain.
  Since a DSL is targeted, it can greatly impact productivity/understanding by allowing the writer to declare what they want
  rather than how.

  One problem area where they are applied are complex customizations/configurations.

  For example the DOT language allows you to write a textual description of a graph which is then transformed into a
  picture by one of the Graphviz tools (such as dot). A simple graph looks like this:

    graph {
        graph [bgcolor="yellow"]
        a [color="red"]
        b [color="blue"]
        a -- b [color="green"]
    }
  Putting this in a file example.dot and running dot example.dot -T png -o example.png creates an image example.png
  with red and blue circle connected by a green line on a yellow background.

  Write a Domain Specific Language similar to the Graphviz dot language.

  Our DSL is similar to the Graphviz dot language in that our DSL will be used to create graph data structures. However, unlike the DOT Language, our DSL will be an internal DSL for use only in our language.

  More information about the difference between internal and external DSLs can be found here.
  """

  alias Exercism.Graph

  @doc """
    transform ast into dsl

      ## Example:
      iex(89)> code = quote do
      ...(89)> require Exercism.Dot
      ...(89)> Exercism.Dot.graph do
      ...(89)> a -- b[label: "Bad"]
      ...(89)> end
      ...(89)> end
      {:__block__, [],
      [
        {:require, [context: Elixir],
          [{:__aliases__, [alias: false], [:Exercism, :Dot]}]},
        {{:., [], [{:__aliases__, [alias: false], [:Exercism, :Dot]}, :graph]}, [],
          [
            [
              do: {:--, [context: Elixir, imports: [{2, Kernel}]],
              [
                {:a, [], Elixir},
                {{:., [from_brackets: true], [Access, :get]}, [from_brackets: true],
                  [
                    {:b, [context: Elixir, imports: [{1, IEx.Helpers}]], Elixir},
                    [label: "Bad"]
                  ]}
              ]}
            ]
          ]}
      ]}
      iex(91)> Code.eval_quoted(code)
      ** (ArgumentError) argument error
          (exercism 0.1.0) lib/hard/dot.ex:20: Exercism.Dot.parse_statement/2
          (exercism 0.1.0) expanding macro: Exercism.Dot.graph/1
          iex:91: (file)

      iex(91)> code = quote do
      ...(91)> require Exercism.Dot
      ...(91)> Exercism.Dot.graph do
      ...(91)> end
      ...(91)> end
      {:__block__, [],
      [
        {:require, [context: Elixir],
          [{:__aliases__, [alias: false], [:Exercism, :Dot]}]},
        {{:., [], [{:__aliases__, [alias: false], [:Exercism, :Dot]}, :graph]}, [],
          [[do: {:__block__, [], []}]]}
      ]}
      iex(92)> Code.eval_quoted(code)
      {%Exercism.Graph{attrs: %{}, nodes: %{}, edges: []}, []}

      iex(93)> code = quote do
      ...(93)> require Exercism.Dot
      ...(93)> Exercism.Dot.graph do
      ...(93)> a
      ...(93)> end
      ...(93)> end
      {:__block__, [],
      [
        {:require, [context: Elixir],
          [{:__aliases__, [alias: false], [:Exercism, :Dot]}]},
        {{:., [], [{:__aliases__, [alias: false], [:Exercism, :Dot]}, :graph]}, [],
          [[do: {:a, [], Elixir}]]}
      ]}
      iex(94)> Code.eval_quoted(code)
      {%Exercism.Graph{attrs: %{}, nodes: %{a: %{}}, edges: []}, []}

  """
  defmacro graph(do: block) do
    graph = parse_block(block, %Graph{}) |> Macro.escape
    quote do
      unquote(graph)
    end
  end

  defp parse_block(nil, graph), do: graph

  defp parse_block({:__block__, _, statements}, graph), do: statements |> Enum.reduce(graph, &parse_statement/2)

  defp parse_block(statement, graph), do: parse_statement(statement, graph)

  defp parse_statement({:graph, _, [attrs]}, graph), do: %{graph | attrs: Map.merge(graph.attrs, attrs |> Enum.into(%{}))}

  # error case for link
  defp parse_statement({:--, _, [_, {{:., _, [Access, :get]}, _, _}]}, _graph), do: raise ArgumentError

  # handle link with attributes like "f -- h(color: :grey)"
  defp parse_statement({:--, _, [{node1, _, _}, {node2, _, [attrs]}]}, graph), do:
    %{graph |
      nodes: Map.put_new(graph.nodes, node1, %{}) |> Map.put_new(node2, %{}),
      edges: [{node1, node2, attrs |> Enum.into(%{})} | graph.edges]}

  # handle link like "f -- h"
  defp parse_statement({:--, _, [{node1, _, _}, {node2, _, _}]}, graph), do:
    %{graph | nodes: Map.put_new(graph.nodes, node1, %{}) |> Map.put_new(node2, %{}), edges: [{node1, node2, %{}} | graph.edges]}

  # error case for link
  defp parse_statement({:--, _, _}, _graph), do: raise ArgumentError

  # error case for node
  defp parse_statement({node, _, [{{:., _, [Access, :get]}, _, _}]}, _graph) when is_atom(node), do: raise ArgumentError

  # handle node definitions with attribute like "a(color: :yellow)"
  defp parse_statement({node, _, [attrs]}, graph) when is_atom(node), do:
    %{graph | nodes: Map.put(graph.nodes, node, attrs |> Enum.into(%{}))}

  # handle node definitions like :a or :b
  defp parse_statement({node, _, _}, graph) when is_atom(node), do: %{graph | nodes: Map.put(graph.nodes, node, %{})}

  # else (error)
  defp parse_statement(_, _), do:  raise ArgumentError
end
