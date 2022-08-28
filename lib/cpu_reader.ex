defmodule CPU.Reader do
  use Task
  @path "/proc/stat"
  @cores 7

  @spec start_link(any) :: {:ok, pid}
  def start_link(_arg) do
    Task.start_link(&loop/0)
  end

  @spec loop :: no_return
  def loop() do
    core_list = File.stream!(@path)
    |> Stream.map(&String.split(&1, "\n", trim: true))
    |> Enum.slice(0, @cores)
    prevstruct = CPU.Core.coresToStruct(core_list, @cores)
    Process.sleep(1000)
    core_list = File.stream!(@path)
    |> Stream.map(&String.split(&1, "\n", trim: true))
    |> Enum.slice(0, @cores)
    currentstruct = CPU.Core.coresToStruct(core_list, @cores)
    send_cpu_info(prevstruct, currentstruct)
    loop()
  end

  defp send_cpu_info(prevstruct, currentstruct) do
    CPU.Analyzer.req_analysis(CPUAnalyzer, {prevstruct, currentstruct})
    {:ok, :normal}
  end

end

defmodule CPU.Core do
  defstruct [:name,
  :user_proc,
  :nice,
  :system,
  :idle,
  :iowait,
  :irq,
  :softirq]

  def coresToStruct(core_list, core_number) do
    for current_core <- 0..(core_number-1)  do
      key_list = [:name, :user_proc, :nice, :system, :idle, :iowait, :irq, :softirq]
      struct!(CPU.Core, Enum.zip(key_list, String.split(hd(Enum.fetch!(core_list, current_core)), " ", trim: true)))
    end
  end

end
