defmodule JSONStream do
  def init(stream_path), do:
    %{stream_path: Enum.reverse(stream_path), stack: [], path: []}

  def handle_event(:end_json, %{stack: stack}), do: stack
  def handle_event(:start_object,%{stack: stack,path: path}=state) do
    %{state| stack: [%{}|stack], path: [nil|path]}
  end
  def handle_event(:start_array,%{stack: stack,path: path}=state) do
    %{state| stack: [[]|stack], path: [0|path]}
  end
  def handle_event(end_val,%{stack: stack, path: path, stream_path: stream_path}=state) when end_val in [:end_object,:end_array] do
    {stack,path} = finish(stack,path,match?([_,_|^stream_path],path))
    %{state| stack: stack, path: path}
  end
  def handle_event({_, val},%{stack: stack, path: path, stream_path: stream_path}=state) do
    {stack,path} = insert(val,stack,path,match?([_|^stream_path],path))
    %{state| stack: stack, path: path}
  end

  defp insert(value,[],path,_), do: {value,path}
  defp insert(key,[%{}=obj|rest],[_|path],_), do: {[{key,obj}|rest],[key|path]}
  defp insert(value,[{key,%{}=obj}|rest],path,false), do: {[Map.put(obj,key,value)|rest],path}
  defp insert(value,[{key,%{}=obj}|rest],path,true) do
    Process.put(:stream_acc,[{key,value}|Process.get(:stream_acc,[])])
    {[obj|rest],path}
  end
  defp insert(value,[arr|rest],[currkey|path],false) when is_list(arr), do: {[[value|arr]|rest],[currkey+1|path]}
  defp insert(value,[arr|rest],[currkey|path],true) when is_list(arr) do
    Process.put(:stream_acc,[value|Process.get(:stream_acc,[])])
    {[arr|rest],[currkey+1|path]}
  end
  defp insert(_,_,_,_), do: throw(:badarg)

  defp finish([%{}=map],[_|path],_), do: {map,path}
  defp finish([%{}=map|rest],[_|path],stream?), do: insert(map,rest,path,stream?)
  defp finish([arr],[_|path],_) when is_list(arr), do: {Enum.reverse(arr),path}
  defp finish([arr|rest],[_|path],stream?) when is_list(arr), do: insert(Enum.reverse(arr), rest, path,stream?)
  defp finish(_,_,_), do: throw(:badarg)

  def stream(bin_stream,stream_path) do
    stream = bin_stream |> Stream.concat([:endbin]) |> 
      Stream.transform(fn-> :jsx.decoder(__MODULE__,stream_path,[:stream]) end,fn
        "",curr-> {[],curr}
        :endbin,curr->
          Process.put(:end_acc,curr.(:end_json))
          {[],nil}
        bin,curr->
          {:incomplete, curr} = curr.(bin)
          acc = Process.get(:stream_acc,[])
          Process.put(:stream_acc,[])
          {acc,curr}
      end, fn _curr->
        Process.delete(:stream_acc)
      end)
    {stream,fn-> Process.get(:end_acc,:stream_not_finished); Process.delete(:end_acc) end}
  end
end
