defmodule Exercism.LogParser do
  @spec valid_line?(String.t()) :: boolean()
  def valid_line?(line), do: Regex.match?(~r/^\[(DEBUG|INFO|WARNING|ERROR)\]/, line)

  @spec split_line(String.t()) :: [String.t()]
  def split_line(line), do: Regex.split(~r/<[*~=\-]+>|<>/, line)

  @spec remove_artifacts(String.t()) :: String.t()
  def remove_artifacts(line), do: Regex.replace(~r/end-of-line\d+/i, line, <<>>)

  @spec tag_with_user_name(String.t()) :: String.t()
  def tag_with_user_name(line), do: Regex.replace(~r/(.*?)(User\s+(\S+))/, line, "[USER] \\3 \\1\\2", global: false)
end
