defmodule Exercism.Grep do
  @moduledoc """
  Search files for lines matching a search string and return all matching lines.

  The Unix grep command searches files for lines that match a regular expression.
  Your task is to implement a simplified grep command, which supports searching for fixed strings.

  The grep command takes three arguments:

    The string to search for.
    Zero or more flags for customizing the command's behavior.
    One or more files to search in.
    It then reads the contents of the specified files (in the order specified), finds the lines that contain the search string, and finally returns those lines in the order in which they were found. When searching in multiple files, each matching line is prepended by the file name and a colon (':').

  Flags
  The grep command supports the following flags:

    -n Prepend the line number and a colon (':') to each line in the output, placing the number after the filename (if present).
    -l Output only the names of the files that contain at least one matching line.
    -i Match using a case-insensitive comparison.
    -v Invert the program -- collect all lines that fail to match.
    -x Search only for lines where the search string matches the entire line.
  """

  @doc """
    to grep from files with pattern

    Example:
      iex(127)> Exercism.Grep.grep "may", [], ["iliad.txt", "midsummer-night.txt", "paradise-lost.txt"]
        "midsummer-night.txt:Nor how it may concern my modesty,
         midsummer-night.txt:But I beseech your grace that I may know
         midsummer-night.txt:The worst that may befall me in this case,"
  """
  @spec grep(String.t(), [String.t()], [String.t()]) :: String.t()
  def grep(pattern, flags, files), do:
    files |> Enum.flat_map(&read/1) |> filter(pattern, flags) |> format(flags, files)

  defp read(file), do:
    (case File.read(file), do:
      (
        {:ok, content} ->
          content |> String.split("\r\n", trim: true) |> Enum.with_index(1) |> Enum.map(fn {line, idx} -> {line, idx, file} end)
        {:error, _} -> []
      )
    )

  defp filter(lines, pattern, flags), do:
    lines
     |> Enum.filter(fn {line, _idx, _file} ->
        line_to_check = if "-i" in flags, do: String.downcase(line), else: line
        string_to_match = if "-i" in flags, do: String.downcase(pattern), else: pattern
        matched = if "-x" in flags, do: line_to_check == string_to_match, else: String.contains?(line_to_check, string_to_match)
        if "-v" in flags, do: not matched, else: matched
      end)

  defp format(lines, flags, files), do:
    (
      case {"-n" in flags, "-l" in flags}, do:
        (
          {_, true} -> lines |> Enum.map(fn {_line, _idx, file} -> file <> "\n" end) |> Enum.uniq |> to_string
          {true, _} ->
            (lines
             |> Enum.map_join("\n", fn {line, idx, file} -> "#{if length(files) > 1, do: file <> ":"}#{idx}:#{line}" end)
             |> to_string) <> "\n"
          _ ->
            case length(files), do:
             (
              x when x > 1 -> (lines |> Enum.map_join("\n", fn {line, _idx, file} -> "#{file}:#{line}" end)) <> "\n"
              _ ->
                res = lines |> Enum.map_join("\n", fn {line, _idx, _file} -> line end) |> to_string
                if res == <<>>, do: <<>>, else: res <> "\n"
             )
        )
    )
end
