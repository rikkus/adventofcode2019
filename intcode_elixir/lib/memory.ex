defmodule Memory do
  def addressing_mode(0), do: :position
  def addressing_mode(1), do: :immediate
  def addressing_mode(2), do: :relative

  @type mem_t :: :array.array()
  @type ip_t :: non_neg_integer
  @type relative_base_t :: integer
  @type value_t :: integer
  @type addressing_mode_t :: :position | :immediate | :relative

  ### Reading

  def fetch(mem, index, opts) do
    log("Fetching from #{inspect(:array.to_list(mem))} at #{index}", opts)
    ret = :array.get(index, mem)
    log("Fetched #{ret}", opts)
    ret
  end

  @spec get(
          mem_t,
          ip_t,
          relative_base_t,
          addressing_mode_t,
          value_t,
          Map.t()
        ) :: any
  defp get(_mem, _ip, _relative_base, :immediate, value, opts) do
    log("get immediate value (#{value}) = #{value}", opts)
    result = value
    log(" -> #{result}", opts)
    result
  end

  defp get(mem, ip, _relative_base, :position, offset, opts) do
    log("get (addressing mode :position): ip (#{ip}) + offset (#{offset}) = #{ip + offset}", opts)
    result = :array.get(offset, mem)
    log(" -> #{result}", opts)
    result
  end

  defp get(mem, ip, relative_base, :relative, relative_offset, opts) do
    log("get (addressing mode :relative): ip = #{ip}, relative_offset = #{relative_offset}, relative_base = #{relative_base}", opts)
    result = :array.get(relative_base + relative_offset, mem)
    log(" -> #{result}", opts)
    result
  end

  def read(mem, ip, relative_base, {value, addressing_mode}, opts \\ []),
    do: get(mem, ip, relative_base, addressing_mode, value, opts)

  ### Writing

  defp put(mem, ip, _relative_base, offset, :position, value, opts) do
    log("put (addressing mode :position) at ip (#{ip}) + offset (#{offset}) = #{ip + offset}, value = #{value}", opts)
    :array.set(offset, value, mem)
  end

  defp put(mem, ip, relative_base, offset, :relative, value, opts) do
    log("put (addressing mode :relative): ip = #{ip}, offset = #{offset}, relative_base = #{relative_base}, value = #{value}", opts)
    :array.set(relative_base + offset, value, mem)
  end

  def write(mem, ip, relative_base, {offset, addressing_mode}, value, opts \\ []),
    do: put(mem, ip, relative_base, offset, addressing_mode, value, opts)

  ### Logging

  def log(message, opts) do
    if Keyword.get(opts, :debug, false) == true do
      IO.puts(message)
    end
  end
end
