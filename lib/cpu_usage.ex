defmodule CpuUsage.Application do
use Application

  @moduledoc """
System Supervisor for the whole app
Provides app keepup
Provides path to /proc/stat
"""



def start(_type, _args) do
  Supervisor.start_link(
  [
    CpuUsage.Reader
  ],
  strategy: :one_for_one
  )

end

end
