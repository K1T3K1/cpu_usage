defmodule CPU.Analyzer.Test do
  use ExUnit.Case
  doctest CPU.Application

  test "Usage calculation" do
    prev = %{name: "prev", user_proc: 1155, nice: 120, system: 185, idle: 230, iowait: 204, irq: 215, softirq: 0}
    current = %{name: "current", user_proc: 1234, nice: 150, system: 220, idle: 280, iowait: 208, irq: 233, softirq: 0}
    assert CPU.Analyzer.calculate_usage(prev, current) == 75
  end
  test "Calc_Vals(prev)" do
    prev = %{name: "prev", user_proc: 1155, nice: 120, system: 185, idle: 230, iowait: 204, irq: 215, softirq: 0}
    assert CPU.Analyzer.calc_vals(prev) == %{idle: 434, active: 1675, total: 2109}
  end
  test "Calc_Vals(current)" do
    current = %{name: "current", user_proc: 1234, nice: 150, system: 220, idle: 280, iowait: 208, irq: 233, softirq: 0}
    assert CPU.Analyzer.calc_vals(current) == %{idle: 488, active: 1837, total: 2325}
  end
end
