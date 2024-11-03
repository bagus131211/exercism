defmodule Exercism.DancingDots.Animation do
  @type dot :: Exercism.DancingDots.Dot.t
  @type opts :: keyword
  @type error :: any
  @type frame_number :: pos_integer

  @callback init(opts) :: {:ok, opts} | {:error, error}
  @callback handle_frame(dot, frame_number, opts) :: dot

  defmacro __using__(_) do
    quote do
      @behaviour Exercism.DancingDots.Animation
      def init(opts), do: {:ok, opts}
      defoverridable init: 1
    end
  end
end

defmodule Exercism.DancingDots.Flickr do
  use Exercism.DancingDots.Animation

  @impl Exercism.DancingDots.Animation
  def handle_frame(dot, frame_number, _opts), do:
    dot |> (& if rem(frame_number, 4) == 0, do: %{&1 | opacity: &1.opacity / 2}, else: &1).()
end

defmodule Exercism.DancingDots.Xoom do
  use Exercism.DancingDots.Animation

  @impl Exercism.DancingDots.Animation
  def init(opts), do:
   opts
   |> Keyword.get(:velocity)
   |> is_number
   |> (& if !&1,
      do: {:error, "The :velocity option is required, and its value must be a number. Got: #{inspect(Keyword.get(opts, :velocity))}"},
      else: {:ok, opts}).()

  @impl Exercism.DancingDots.Animation
  def handle_frame(dot, frame_number, opts), do:
   dot |> (& %{&1 | radius: &1.radius + (frame_number - 1) * opts[:velocity]}).()
end
