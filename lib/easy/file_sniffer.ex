defmodule Exercism.FileSniffer do
  @media_type [
    %{type: "ELF", extension: "exe", media: "application/octet-stream", signature: <<0x7F, 0x45, 0x4C, 0x46>>},
    %{type: "BMP", extension: "bmp", media: "image/bmp", signature: <<0x42, 0x4D>>},
    %{type: "PNG", extension: "png", media: "image/png", signature: <<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A>>},
    %{type: "JPG", extension: "jpg", media: "image/jpg", signature: <<0xFF, 0xD8, 0xFF>>},
    %{type: "GIF", extension: "gif", media: "image/gif", signature: <<0x47, 0x49, 0x46>>},
  ]

  @spec type_from_extension(String.t()) :: String.t() | nil
  def type_from_extension(extension), do: @media_type |> Enum.find(& &1.extension === extension) |> (&(&1 && &1.media)).()

  @spec type_from_binary(binary()) :: String.t() | nil
  def type_from_binary(file_binary) when is_binary(file_binary), do:
   file_binary
   |> binary_part(0, min(16, byte_size(file_binary)))
   |> match_signature

  def type_from_binary(_), do: nil

  defp match_signature(binary), do:
    @media_type
    |> Enum.find_value(nil, &match_signature?(&1, binary))

  defp match_signature?(%{signature: signature, media: media}, binary), do: (if binary =~ signature, do: media)

  # defp match_signature_with_bitstring?(%{signature: signature, media: media}, binary) do
  #   size = byte_size(signature)
  #   case binary do
  #     <<^signature::binary-size(size), _::binary>> -> media
  #     _ -> nil
  #   end
  # end

  @spec verify(binary(), String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def verify(file_binary, extension) do
    binary_type = type_from_binary(file_binary)
    if (type_from_extension(extension) == binary_type && binary_type != nil), do: {:ok, binary_type}, else: {:error, "Warning, file format and file extension do not match."}
  end
end
