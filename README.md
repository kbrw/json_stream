# JSONStream

Small but useful wrapper above erlang `jsx` to stream
json elements from an Elixir binary stream.

## Usage

```elixir
stream_path = ["data",1,"actions"]
{actions_stream,doc_fun} = File.stream!("example.json",[],2048)
  |> JSONStream.stream(stream_path)
```

`stream_path` describe the JSON path (string for map key and integer
for array index), to the Array/Object you want to stream Element/{key,value}.

`actions_stream` is the stream of element in case `stream_path`
targets an array, or a stream of `{k,v}` in case `stream_path`
targets a map.

`doc_fun` is a function `()->doc` where `doc` will be the whole
parsed json document, but without the elements from the stream. It
will be accessible only after the whole stream will be runned.
Else, `doc_fun.()-> :stream_not_finished`.

## Installation

The package can be installed as:

  1. Add json_stream to your list of dependencies in `mix.exs`:

        def deps do
          [{:json_stream, "~> 0.0.1"}]
        end

  2. Ensure json_stream is started before your application:

        def application do
          [applications: [:json_stream]]
        end

