# JSONStream [![Hex.pm](https://img.shields.io/hexpm/v/json_stream.svg)](https://hex.pm/packages/json_stream) [![Documentation](https://img.shields.io/badge/documentation-gray)](https://hexdocs.pm/json_stream)
[![Build Status](https://github.com/kbrw/json_stream/actions/workflows/.github/workflows/elixir.yml/badge.svg)](https://github.com/kbrw/json_stream/actions/workflows/elixir.yml)

Small but useful wrapper above the erlang's JSON parsing toolkit [jsx](https://hex.pm/packages/jsx)
to stream json elements from an Elixir binary stream.

## Usage

```elixir
stream_path = ["data", 1, "actions"]
{actions_stream, doc_fun} =
  "example.json"
  |> File.stream!([],2048)
  |> JSONStream.stream(stream_path)

Enum.to_list(actions_stream )
# Will output:
# [
#   %{"link" => "http://www.facebook.com/X998/posts/Y998", "name" => "Like"},
#   %{"link" => "http://www.facebook.com/X998/posts/Y998", "name" => "Comment"}
# ]

doc_fun.()
# Will output:
# %{
#   "data" => [
#     %{
#       "actions" => [
#         %{
#           "link" => "http://www.facebook.com/X999/posts/Y999",
#           "name" => "Comment"
#         },
#         %{"link" => "http://www.facebook.com/X999/posts/Y999", "name" => "Like"}
#       ],
#       "created_time" => "2010-08-02T21:27:44+0000",
#       "from" => %{"id" => "X12", "name" => "Tom Brady"},
#       "id" => "X999_Y999",
#       "message" => "Looking forward to 2010!",
#       "type" => "status",
#       "updated_time" => "2010-08-02T21:27:44+0000"
#     },
#     %{
#       "actions" => [],
#       "created_time" => "2010-08-02T21:27:44+0000",
#       "from" => %{"id" => "X18", "name" => "Peyton Manning"},
#       "id" => "X998_Y998",
#       "message" => "Where's my contract?",
#       "type" => "status",
#       "updated_time" => "2010-08-02T21:27:44+0000"
#     }
#   ]
# }
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
  ```elixir
  def deps do
    [{:json_stream, "~> 0.0.2"}]
  end
  ```

2. Ensure json_stream is started before your application:
  ```elixir
  def application do
    [applications: [:json_stream]]
  end
  ```
