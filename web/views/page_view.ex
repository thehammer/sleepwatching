defmodule Sleepwatching.PageView do
  use Sleepwatching.Web, :view

  def sleeper_names(bed, sleepers) do
    sleepers
    |> Enum.filter(fn sleeper -> sleeper.bedId == bed.bedId end)
    |> Enum.map(&(&1[:firstName]))
  end

  def bed_state(bed, family_status) do
    status = family_status.beds
    |> Enum.find(fn b -> b.bedId == bed.bedId end)
    case [status.leftSide.isInBed, status.rightSide.isInBed] do
      [true, true] -> "Both sides occupied"
      [true, false] -> "Left side occupied"
      [false, true] -> "Right side occupied"
      [false, false] -> "Unoccupied"
    end
  end
end
