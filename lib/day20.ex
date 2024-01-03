defmodule AoC.Day20 do
  @moduledoc """
  """
  alias :queue, as: Q

  def part1(filename) do
    filename
    |> parse()
    |> press_button(1000)
    |> elem(2)
    |> Enum.reduce([0, 0], fn
      {_name, :high}, [lows, highs] -> [lows, highs + 1]
      {_name, :low}, [lows, highs] -> [lows + 1, highs]
    end)
    |> Enum.product()
  end

  def part2(filename) do
    # my cycles: [3931, 3989, 3907, 3967]
    filename
    |> parse()
    |> press_button_until("rx")
    |> Enum.reduce(&lcm/2)
  end

  def dottify(filename) do
    IO.puts("digraph {")

    for {name, {type, outputs}} <- parse(filename) do
      case type do
        :flip_flop -> IO.puts("#{name} [shape=box]")
        :conjunction -> IO.puts("#{name} [shape=hexagon]")
        _ -> IO.puts("#{name} [shape=ellipse]")
      end

      for output <- outputs, do: IO.puts("#{name} -> #{output}")
    end

    IO.puts("}")
  end

  defp parse(filename) do
    filename
    |> File.stream!()
    |> Enum.map(&String.trim_trailing/1)
    |> Enum.map(&String.split(&1, " -> "))
    |> Enum.map(&parse_row/1)
    |> Enum.into(%{})
    |> add_unnamed()
  end

  defp parents(modules, module) do
    modules
    |> Enum.filter(fn {_name, {_type, outputs}} -> outputs == [module] end)
    |> Enum.map(fn {name, _} -> name end)
  end

  defp press_button_until(modules, module) do
    [parent] = parents(modules, module)
    parent_pulse = {parent, :high}
    state = reset_state(modules)

    {:broadcaster, outputs} = modules["broadcaster"]

    [output | _outputs] = outputs
    {state_acc, _pq, first} = press_button_until(modules, output, state, parent_pulse, 0)
    {state_acc, _pq, second} = press_button_until(modules, output, state_acc, parent_pulse, first)
    {state_acc, _pq, third} = press_button_until(modules, output, state_acc, parent_pulse, second)
    {_state_acc, _pq, forth} = press_button_until(modules, output, state_acc, parent_pulse, third)

    [first, second, third, forth]
  end

  defp press_button_until(modules, start, state, parent_pulse, i) do
    pulse = {start, "broadcaster", :low}
    pq = Q.in(pulse, Q.new())
    {state_acc, _pq, pulses} = process(modules, pq, [], state)

    if parent_pulse in pulses do
      {state_acc, pq, i + 1}
    else
      press_button_until(modules, start, state_acc, parent_pulse, i + 1)
    end
  end

  defp press_button(modules, times) do
    state = reset_state(modules)

    Enum.reduce(1..times, {state, Q.new(), []}, fn _i, {state_acc, pq_acc, pulses_acc} ->
      pulse = {"button", "broadcaster", :low}
      process(modules, Q.in(pulse, pq_acc), [{"broadcaster", :low} | pulses_acc], state_acc)
    end)
  end

  defp processing(modules, pq, from, pulse, pulses, outputs, state) do
    pq =
      Enum.reduce(outputs, pq, fn output, pq_acc ->
        Q.in({from, output, pulse}, pq_acc)
      end)

    Enum.reduce(outputs, {state, pq, pulses}, fn output, {state_acc, pq_acc, pulses_acc} ->
      process(modules, pq_acc, [{output, pulse} | pulses_acc], state_acc)
    end)
  end

  defp process(modules, pq, pulses, state) do
    {{:value, {from, name, pulse}}, pq} = Q.out(pq)
    {type, outputs} = modules[name]

    case {type, pulse} do
      {:broadcaster, _pulse} ->
        processing(modules, pq, name, pulse, pulses, outputs, state)

      {:flip_flop, :high} ->
        {state, pq, pulses}

      {:flip_flop, :low} ->
        {on_off, pulse} = if state[name] == :on, do: {:off, :low}, else: {:on, :high}
        state = %{state | name => on_off}

        processing(modules, pq, name, pulse, pulses, outputs, state)

      {:conjunction, _pulse} ->
        state = put_in(state, [name, from], pulse)
        input_values = Map.values(state[name])

        pulse = if Enum.all?(input_values, &(&1 == :high)), do: :low, else: :high

        processing(modules, pq, name, pulse, pulses, outputs, state)

      {:unnamed, _pulse} ->
        {state, pq, pulses}
    end
  end

  defp reset_state(modules) do
    Enum.reduce(modules, %{}, fn
      {input, {:flip_flop, outputs}}, state ->
        state
        |> Map.put(input, :off)
        |> add_conjunction(input, outputs, modules)

      {input, {:conjunction, outputs}}, state ->
        state
        |> add_conjunction(input, outputs, modules)

      _rest, state ->
        state
    end)
  end

  defp add_conjunction(state, input, outputs, modules) do
    Enum.reduce(outputs, state, fn output, state_acc ->
      if type(modules, output) == :conjunction do
        Map.merge(state_acc, %{output => %{input => :low}}, fn _k, v1, v2 ->
          Map.merge(v1, v2)
        end)
      else
        state_acc
      end
    end)
  end

  defp type(modules, module) do
    {type, _list} = modules[module]
    type
  end

  defp add_unnamed(modules) do
    named_modules = Map.keys(modules)

    ref_modules =
      modules
      |> Map.values()
      |> Enum.map(&elem(&1, 1))
      |> List.flatten()
      |> Enum.uniq()

    (ref_modules -- named_modules)
    |> Enum.reduce(modules, fn unamed_module, acc ->
      Map.put(acc, unamed_module, {:unnamed, []})
    end)
  end

  defp parse_row([name, list]) do
    list = String.split(list, ", ")

    case name do
      "broadcaster" -> {name, {:broadcaster, list}}
      <<?%, var::binary>> -> {var, {:flip_flop, list}}
      <<?&, var::binary>> -> {var, {:conjunction, list}}
    end
  end

  def lcm(a, b) do
    div(a * b, Integer.gcd(a, b))
  end
end
