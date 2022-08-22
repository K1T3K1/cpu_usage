defmodule CpuUsage.Reader do
  use Task

  @path "/proc/stat"

  def start_link(_arg) do
    Task.start_link(&loop/0)
  end

  def loop() do
    IO.puts(File.read!(@path))
    Process.sleep(100)
    loop()

  end
end
