defmodule CpuUsage.Reader do
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
    CPUCore.coresToStruct(core_list, @cores)
    end
end

defmodule CPUCore do
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
      struct!(CPUCore, Enum.zip(key_list, String.split(hd(Enum.fetch!(core_list, current_core)), " ", trim: true)))
      |>Map.from_struct
    end
  end

end
