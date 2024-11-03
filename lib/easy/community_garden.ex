defmodule Plot do
  @enforce_keys [:plot_id, :registered_to]
  defstruct [:plot_id, :registered_to]
end

defmodule Exercism.CommunityGarden do
  def start(opts \\ []), do: Agent.start(fn -> %{plots: [], counter: 0} end, opts)

  def list_registrations(pid), do: Agent.get(pid, & &1.plots)

  def register(pid, register_to), do:
    Agent.get_and_update(pid, &{%Plot{plot_id: &1.counter + 1, registered_to: register_to}, %{&1 |
      plots: [%Plot{plot_id: &1.counter + 1, registered_to: register_to} | &1.plots],
      counter: &1.counter + 1}})

  def release(pid, plot_id), do:
    Agent.update(pid, & %{&1 | plots: (for plot <- &1.plots, plot.plot_id !== plot_id, do: plot)})

  def get_registration(pid, plot_id), do:
    Agent.get(pid, &find_plot(&1.plots, plot_id))

  defp find_plot(plots, plot_id), do:
    Enum.find(plots, &(&1.plot_id == plot_id)) || {:not_found, "plot is unregistered"}
end
