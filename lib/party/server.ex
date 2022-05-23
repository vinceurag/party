defmodule Party.Server do
  use GenServer

  def start_link(initial_state \\ []) do
    GenServer.start_link(__MODULE__, initial_state)
  end

  def reset(), do: GenServer.cast({:via, PartitionSupervisor, {Party.Servers, self()}}, :reset)

  def prepend(value) do
    GenServer.cast({:via, PartitionSupervisor, {Party.Servers, self()}}, {:prepend, value})
  end

  def inspect() do
    GenServer.call({:via, PartitionSupervisor, {Party.Servers, self()}}, :inspect)
  end

  @impl true
  def init(state \\ []) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:prepend, value}, state) do
    {:noreply, [value | state]}
  end

  @impl true
  def handle_cast(:reset, _state), do: {:noreply, []}

  @impl true
  def handle_call(:inspect, _from, state), do: {:reply, state, state}
end
