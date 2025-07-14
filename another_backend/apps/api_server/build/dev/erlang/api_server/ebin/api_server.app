{application, api_server, [
    {vsn, "1.0.0"},
    {applications, [gleam_erlang,
                    gleam_http,
                    gleam_json,
                    gleam_otp,
                    gleam_stdlib,
                    gleam_yielder,
                    gleeunit,
                    logging,
                    mist,
                    rebar_mix]},
    {description, ""},
    {modules, [api_server,
               api_server@@main,
               api_server_test]},
    {registered, []}
]}.
