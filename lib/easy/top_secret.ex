defmodule Exercism.TopSecret do
  def to_ast(string), do: string |> Code.string_to_quoted |> elem(1)

  def decode_secret_message_part({operator, _, [{:when, _, [{name, _, args} | _]}, _]} = ast_node, acc)
    when operator in [:def, :defp], do:
      {ast_node, [Atom.to_string(name) |> String.slice(0, length(args || [])) | acc]}

  def decode_secret_message_part({operator, _, [{name, _, args} | _]} = ast_node, acc)
    when operator in [:def, :defp], do:
      {ast_node, [Atom.to_string(name) |> String.slice(0, length(args || [])) | acc]}

  def decode_secret_message_part(ast_node, acc), do: {ast_node, acc}

  def decode_secret_message(string), do:
    string
    |> to_ast
    |> Macro.prewalk([], &decode_secret_message_part/2)
    |> elem(1)
    |> List.foldr("", &(&2 <> &1))
end
