defmodule TestGS do
  use GenServer

  def start_link(_state \\ 0) do
    GenServer.start_link(__MODULE__, 0, name: __MODULE__)
  end

  def init(_) do
    {:ok, []}
  end

  def handle_info(any, state) do
    {:noreply, state ++ ["message: #{any}"]}
  end

  def handle_cast({:async, msg}, state) do
    {:noreply, state ++ ["async: #{msg}"]}
  end

  def handle_call(:get_data, _, state) do
    {:reply, state, state}
  end

  def handle_call(:sync, _, state) do
    {:reply, :sync_msg, state}
  end

  def async(msg) do
    GenServer.cast(__MODULE__, {:async, msg})
  end

  def print() do
    GenServer.call(__MODULE__, :get_data)
  end

  def sync() do
    GenServer.call(__MODULE__, :sync)
  end

  def send_msg(msg) do
    send(__MODULE__, msg)
  end
end
