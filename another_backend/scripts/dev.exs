# scripts/dev.exs
defmodule GleamRunner do
  def run do
    # Add build paths
    paths = [
      "apps/api_server/build/dev/erlang/gleam_stdlib/ebin",
      "apps/api_server/build/dev/erlang/gleam_erlang/ebin",
      "apps/api_server/build/dev/erlang/gleam_otp/ebin",
      "apps/api_server/build/dev/erlang/gleam_http/ebin",
      "apps/api_server/build/dev/erlang/mist/ebin",
      "apps/api_server/build/dev/erlang/glisten/ebin",
      "apps/api_server/build/dev/erlang/logging/ebin",
      "apps/api_server/build/dev/erlang/api_server/ebin"
    ]

    Enum.each(paths, fn path ->
      :code.add_pathz(Path.expand(path) |> to_charlist())
    end)

    # Start the server synchronously so the process stays alive
    :api_server.main()
  end
end

GleamRunner.run()
