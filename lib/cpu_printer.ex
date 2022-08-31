defmodule CPU.Printer do
  use GenServer

    def start_link(name) do
      GenServer.start_link(__MODULE__, name , name: CPUPrinter)
    end

    def display_usage(pid, usage_data) do
      GenServer.cast(pid, {:print_data, usage_data})
    end

    def init(state) do
      {:ok, state, 2000}
    end


    def handle_cast({:print_data, usage_data}, _state) do
      data_to_screen(usage_data)
      {:noreply, :ok}
    end

    def data_to_screen(usage_data) do
      format_data(usage_data)
    end

    def format_data(usage_data) do
      IO.puts("")
      IO.puts(" ______________")
      IO.puts("| CORE | USAGE |")
      for core_number <- 0..length(usage_data)-1 do
        current_core = Enum.fetch!(usage_data, core_number)
        usage = :erlang.float_to_binary(current_core[:usage], [decimals: 2])
        case current_core do
          %{core: 0, usage: _} ->
            IO.puts("| CPU  | " <> usage <> " |")
          _args ->
            IO.puts("| CPU" <> Integer.to_string(current_core[:core]) <> " | " <> usage <> " |")
        end
      end
    end
end
