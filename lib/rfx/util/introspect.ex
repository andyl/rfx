# Thank you @dimitarvp for posting the sample code!!
# https://elixirforum.com/t/load-all-modules-implementing-a-behaviour-in-escript/33348/4?u=andyl

defmodule Rfx.Util.Introspect do
  def modules_belonging_to_namespace(namespace)
      when is_binary(namespace) do
    :code.all_available()
    |> Enum.filter(fn {name, _file, _loaded} ->
      String.starts_with?(to_string(name), "Elixir." <> namespace)
    end)
    |> Enum.map(fn {name, _file, _loaded} ->
      name |> List.to_atom()
    end)
  end

  def ensure_all_modules_loaded(namespace)
      when is_binary(namespace) do
    modules_belonging_to_namespace(namespace)
    |> :code.ensure_modules_loaded()
  end

  def behaviours(mod)
      when is_atom(mod) do
    # Convert resulting list to [] if list of behaviours is nil
    mod.module_info()
    |> get_in([:attributes, :behaviour])
    |> List.wrap()
  end

  def has_function?(module, funspec = {_func, _arity}) do
    module.module_info()[:exports]
    |> Enum.member?(funspec)
  end

  def implementors(namespace, behaviour)
      when is_binary(namespace) and is_atom(behaviour) do
    ensure_all_modules_loaded(namespace)

    modules_belonging_to_namespace(namespace)
    |> Enum.filter(&(behaviour in behaviours(&1)))
  end
end
