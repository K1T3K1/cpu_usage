defmodule CPU.Printer.Test do
  use ExUnit.Case
  doctest CPU.Application

  test "Printer" do
    assert CPU.Printer.data_to_screen([%{core: 0, usage: 50.0}]) == [:ok]
  end
end
