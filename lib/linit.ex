defmodule Linit do
  @moduledoc """
  It is a simple backoff implementation, which tries to get fun running in
  intervals.
  """
  use GenServer
  require Logger

  defstruct [fun: nil, message: nil, error_fun: nil, ms: nil]
  @default_interval 10000

  @doc """
  Backoff initialization process.

  ## Options

    * `ms`        - interval in miliseconds
    * `message`   - message for initialization
    * `error_fun` - fun for formating an error, can be used to crash process for unknown error


  """
  def start_link(fun, opts) do
    config = %Linit{fun: fun, message: opts[:message], ms: opts[:ms] || @default_interval,
                    error_fun: opts[:error_fun]}
    GenServer.start_link(Linit, config)
  end

  @doc false
  def init(%Linit{} = state) do
    send(self, :check)
    {:ok, state}
  end

  @doc false
  def handle_info(:check, %{fun: fun, ms: ms} = state) do
    try do
      fun.()
      {:stop, {:shutdown, :normal}, state}
    catch
      class, error ->
        formated = case state.error_fun do
          nil -> "#{inspect {class, error}}"
          formatter -> formatter.({class, error})
        end
        Logger.error("initialization of #{state.message} failed, try in #{ms} ms, error: #{formated}")
        Process.send_after(self, :check, ms)
        {:noreply, state}
    end
  end
end
