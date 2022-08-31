defmodule CPU.Analyzer do
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, name , name: CPUAnalyzer)
  end

  def req_analysis(pid, {prev, current}) do
    GenServer.cast(pid, {:analyze, prev, current})
  end


  def init(state) do
    {:ok, state, 2000}
  end

  def handle_cast({:analyze, prev, current}, _state) do
    analyze_data(prev, current)
    {:noreply, :ok}
  end

  def analyze_data(prev, current) do
    CPU.Printer.display_usage(CPUPrinter, process_data(prev, current))
  end

  def process_data(prev_list, current_list) do
    for current_core <- 0..length(prev_list)-1 do
      prev_map = calc_vals(Enum.fetch!(prev_list, current_core))
      current_map = calc_vals(Enum.fetch!(current_list, current_core))
      calc_usage(prev_map, current_map, current_core)
    end
  end


  def calc_vals(struct) do
    parsed_struct = Enum.into(Enum.map(Map.delete(Map.from_struct(struct), :name), fn {key, value} -> {key, elem(Integer.parse(value, 10), 0)} end), %{})
    idle = parsed_struct[:idle] + parsed_struct[:iowait]
    active = parsed_struct[:user_proc] + parsed_struct[:nice] + parsed_struct[:system] + parsed_struct[:irq] + parsed_struct[:softirq]
    %{idle: idle, active: active, total: idle + active}
  end

  def calc_usage(prev_core, current_core, core_number) do
      totald = current_core[:total] - prev_core[:total]
      idled = current_core[:idle] - prev_core[:idle]
      %{core: core_number, usage: (((totald - idled)/totald)*100)}
  end
end
