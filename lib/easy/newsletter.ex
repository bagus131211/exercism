defmodule Exercism.Newsletter do

  @spec read_emails(String.t()) :: [String.t()]
  def read_emails(path), do: path |> File.read! |> String.split("\r\n", trim: true)

  @spec open_log(String.t()) :: pid()
  def open_log(path), do: path |> File.open!([:write])

  @spec log_sent_email(pid(), String.t()) :: :ok
  def log_sent_email(pid, email), do: IO.puts(pid, "#{email}"); :ok

  @spec close_log(pid()) :: :ok
  def close_log(pid), do: File.close(pid)

  @spec send_newsletter(String.t(), String.t(), fun()) :: :ok | :error
  def send_newsletter(emails_path, log_path, send_fun) do
    pid = open_log(log_path)
    Enum.each(emails_path |> read_emails, fn email ->
      case send_fun.(email) do
        :ok -> log_sent_email(pid, email)
        _ -> :error
      end
    end)
    close_log(pid)
  end
end
