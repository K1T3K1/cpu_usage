defmodule CPU.Analyzer.Test do
  use ExUnit.Case
  doctest CPU.Application

  test "Usage calculation" do
    prev = [%CPU.Core{name: "prev", user_proc: "1155", nice: "120", system: "185", idle: "230", iowait: "204", irq: "215", softirq: "0"}]
    current = [%CPU.Core{name: "current", user_proc: "1234", nice: "150", system: "220", idle: "280", iowait: "208", irq: "233", softirq: "0"}]
    assert CPU.Analyzer.process_data(prev, current) == [%{core: 0, usage: 75}]
  end
  test "Calc_Vals(prev)" do
    prev = %CPU.Core{name: "prev", user_proc: "1155", nice: "120", system: "185", idle: "230", iowait: "204", irq: "215", softirq: "0"}
    assert CPU.Analyzer.calc_vals(prev) == %{idle: 434, active: 1675, total: 2109}
  end
  test "Calc_Vals(current)" do
    current = %CPU.Core{name: "current", user_proc: "1234", nice: "150", system: "220", idle: "280", iowait: "208", irq: "233", softirq: "0"}
    assert CPU.Analyzer.calc_vals(current) == %{idle: 488, active: 1837, total: 2325}
  end
end
