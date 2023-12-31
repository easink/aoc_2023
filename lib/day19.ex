defmodule AoC.Day19 do
  @moduledoc """
  """

  def part1(filename) do
    filename
    |> parse()
    |> workflows()
    |> Enum.map(&Map.values/1)
    |> List.flatten()
    |> Enum.sum()
  end

  def part2(filename) do
    filename
    |> parse()
    |> walk_workflows()
  end

  defp walk_workflows({workflow, _part_rows}) do
    walk_workflows(workflow, workflow["in"], "in", [])
  end

  defp walk_workflows(_workflow, _exprs, "R", _expr_acc), do: 0

  defp walk_workflows(_workflow, _exprs, "A", expr_acc) do
    full = {1, 4000}
    parts = %{"x" => full, "m" => full, "a" => full, "s" => full}

    expr_acc
    |> Enum.reduce(parts, fn {part, cmp, n_parts, _dest}, parts_acc ->
      %{parts_acc | part => correct(parts_acc[part], cmp, n_parts)}
    end)
    |> Enum.map(fn {_part, {min, max}} -> max - min + 1 end)
    |> Enum.product()
  end

  defp walk_workflows(_workflow, [], _name, _expr_acc), do: 0

  defp walk_workflows(workflow, [expr | exprs], name, expr_acc) do
    {_name, _cmp, _n_parts, dest} = expr
    neg_expr = negate_expr(expr)
    next = walk_workflows(workflow, exprs, name, [neg_expr | expr_acc])

    jumped = walk_workflows(workflow, workflow[dest], dest, [expr | expr_acc])

    jumped + next
  end

  defp correct({min, max}, ?>, n_parts), do: {max(min, n_parts + 1), max}
  defp correct({min, max}, ?<, n_parts), do: {min, min(max, n_parts - 1)}

  defp negate_expr({name, ?>, n_parts, dest}), do: {name, ?<, n_parts + 1, dest}
  defp negate_expr({name, ?<, n_parts, dest}), do: {name, ?>, n_parts - 1, dest}

  defp workflows({workflow, part_rows}) do
    Enum.filter(part_rows, fn parts -> accepted?(parts, workflow, "in") end)
  end

  defp accepted?(_parts, _workflow, "A"), do: true
  defp accepted?(_parts, _workflow, "R"), do: false

  defp accepted?(parts, workflow, name) do
    {_name, _cmp, _n_parts, dest} = find(parts, workflow[name])
    accepted?(parts, workflow, dest)
  end

  defp find(parts, expressions) do
    Enum.find(expressions, fn
      {part, ?>, n_parts, _dest} -> parts[part] > n_parts
      {part, ?<, n_parts, _dest} -> parts[part] < n_parts
    end)
  end

  defp parse(filename) do
    filename
    |> File.read!()
    |> String.split("\n\n")
    |> Enum.map(&String.split/1)
    |> parse_data()
  end

  defp parse_data([workflows, parts]) do
    {
      parse_workflows(workflows, %{}),
      parse_parts(parts, [])
    }
  end

  # {x=787,m=2655,a=1222,s=2876}

  defp parse_parts([], acc), do: Enum.reverse(acc)

  defp parse_parts([part_row | part_rows], acc) do
    row =
      part_row
      |> String.split(["{", "}", ","], trim: true)
      |> Enum.map(&parse_part/1)
      |> Enum.into(%{})

    parse_parts(part_rows, [row | acc])
  end

  defp parse_part(<<part::binary-size(1), "=", parts::binary>>) do
    {part, String.to_integer(parts)}
  end

  # px{a<2006:qkq,m>2090:A,rfg}

  defp parse_workflows([], acc), do: acc

  defp parse_workflows([workflow | workflows], acc) do
    [name | rules] = String.split(workflow, ["{", "}", ","], trim: true)

    rules = Enum.map(rules, &parse_rule/1)
    acc = Map.put(acc, name, rules)
    parse_workflows(workflows, acc)
  end

  defp parse_rule(rule) do
    case String.split(rule, ":") do
      # dummy expression
      [name] ->
        {"a", ?>, 0, name}

      [<<part::binary-size(1), cmp, parts::binary>>, name] ->
        n_parts = String.to_integer(parts)
        {part, cmp, n_parts, name}
    end
  end
end
