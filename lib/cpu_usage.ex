defmodule CPU.Application do
use Application

  @moduledoc """
System Supervisor for the whole app
Provides app keepup
"""

def start(_type, _args) do
  Supervisor.start_link(
  [
    CPU.Reader,
    CPU.Analyzer,
    CPU.Printer
  ],
  strategy: :one_for_one
  )

end

end
