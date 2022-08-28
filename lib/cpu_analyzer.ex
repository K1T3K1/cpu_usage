defmodule CPU.Analyzer do
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, name , name: CPUAnalyzer)
  end

  def req_analysis(pid, {prev, current}) do
    GenServer.cast(pid, {:request, prev, current})
  end


  def init(state) do
    {:ok, state, 2000}
  end

  def handle_cast({:request, prev, current}, _state) do
    # __TODO__
    #prev and current are lists each containing all cores
    #gotta split those lists, then map from structs and calculate vals and usages latter

    prev = Map.from_struct(prev)
    current = Map.from_struct(current)
    calculate_usage(prev, current)
    {:noreply, :ok}
  end

  @spec calculate_usage(nil | maybe_improper_list | map, nil | maybe_improper_list | map) :: :ok
  def calculate_usage(prevstruct, currentstruct) do
    prev_map = calc_vals(prevstruct)
    current_map = calc_vals(currentstruct)
    totald = current_map[:total] - prev_map[:total]
    idled = current_map[:idle] - prev_map[:idle]
    IO.puts(((totald - idled)/totald)*100)
  end

  def calc_vals(struct) do
    idle = struct[:idle] + struct[:iowait]
    active = struct[:user_proc] + struct[:nice] + struct[:system] + struct[:irq] + struct[:softirq]
    %{idle: idle, active: active, total: idle + active}
  end

end
