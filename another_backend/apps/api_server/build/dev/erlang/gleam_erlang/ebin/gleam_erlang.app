{application, gleam_erlang, [
    {vsn, "1.2.0"},
    {applications, [gleam_stdlib]},
    {description, "Types and functions for programs running on Erlang!"},
    {modules, [gleam@erlang@application,
               gleam@erlang@atom,
               gleam@erlang@charlist,
               gleam@erlang@node,
               gleam@erlang@port,
               gleam@erlang@process,
               gleam@erlang@reference,
               gleam_erlang_ffi]},
    {registered, []}
]}.
