defmodule JSONStream.Mixfile do
  use Mix.Project

  def project do
    [app: :json_stream,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: [
       maintainers: ["Arnaud Wetzel"],
       licenses: ["MIT"],
       links: %{ "GitHub" => "https://github.com/awetzel/json_stream" }
     ],
     description: """
     Small but useful wrapper above erlang `jsx` to stream json
     elements from an Elixir binary stream.
     """,
     deps: [{:jsx,"~> 2.8"}]]
  end

  def application do
    [applications: [:jsx]]
  end
end
