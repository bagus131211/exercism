defmodule Exercism.NeedForSpeed.RemoteControlCar do
  defstruct [
    :nickname,
    :color,
    battery_percentage: 100,
    distance_driven_in_meters: 0
  ]

  def new(color, nickname) when color in [:red, :blue, :green] do
    %Exercism.NeedForSpeed.RemoteControlCar{nickname: nickname, color: color}
  end

  def display_distance(%Exercism.NeedForSpeed.RemoteControlCar{distance_driven_in_meters: d}) do
    "#{d} meters"
  end

  def display_battery(%Exercism.NeedForSpeed.RemoteControlCar{battery_percentage: 0}) do
    "Battery empty"
  end

  def display_battery(%Exercism.NeedForSpeed.RemoteControlCar{battery_percentage: b}) do
    "Battery at #{b}%"
  end
end
