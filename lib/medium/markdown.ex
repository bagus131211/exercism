defmodule Exercism.Markdown do
  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

      iex> Markdown.parse("This is a paragraph")
      "<p>This is a paragraph</p>"

      iex> Markdown.parse("# Header!\\n* __Bold Item__\\n* _Italic Item_")
      "<h1>Header!</h1><ul><li><strong>Bold Item</strong></li><li><em>Italic Item</em></li></ul>"

      iex(2)> Exercism.Markdown.parse "_This will be italic_"
      "<p><em>This will be italic</em></p>"

      iex(4)> Exercism.Markdown.parse "This will _be_ __mixed__"
      "<p>This will <em>be</em> <strong>mixed</strong></p>"

  """
  @spec parse(String.t()) :: String.t()
  def parse(m), do: m |> String.split("\n") |> Enum.map(&process/1) |> Enum.join |> list_tags

  defp list_tags(content), do:
    content
      |> String.replace("<li>", "<ul><li>", global: false)
      |> String.reverse
      |> String.replace(">il/<", ">lu/<>il/<", global: false)
      |> String.reverse

  defp process(line), do:
    (cond do:
      (
        header?(line) -> parse_header(line)
        li?(line) -> parse_li(line)
        true -> parse_paragraph(line)
      )
    )

  defp header?(line), do: String.starts_with?(line, "#") && !String.starts_with?(line, "#######")

  defp li?(line), do: line |> String.starts_with?("*")

  defp parse_header(line), do: line |> extract_header_and_content |> header_tags

  defp header_tags({level, content}), do: "<h#{level}>#{content}</h#{level}>"

  defp extract_header_and_content(line) do
    [head | content] = String.split(line, " ", parts: 2)
    {String.length(head), Enum.join(content, " ")}
  end

  defp parse_li(line), do: line |> String.trim_leading("* ") |> replace_syntax |> tag_enclosing("li")

  defp parse_paragraph(line), do: line |> replace_syntax |> tag_enclosing("p")

  defp replace_syntax(word), do:
    word |> String.replace(~r/__([\w\s]+)__/u, "<strong>\\1</strong>") |> String.replace(~r/_([\w\s]+)_/u, "<em>\\1</em>")

  defp tag_enclosing(content, tag), do: "<#{tag}>#{content}</#{tag}>"
end
