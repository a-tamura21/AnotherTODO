-module(api_server).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).
-define(FILEPATH, "src\\api_server.gleam").
-export([get_all_tasks/0, logs/0, route/1, main/0]).

-file("src\\api_server.gleam", 11).
-spec get_all_tasks() -> binary().
get_all_tasks() ->
    'Elixir.DatabaseUtil.TaskFunctions':get_all_tasks().

-file("src\\api_server.gleam", 15).
-spec logs() -> nil.
logs() ->
    logging_ffi:configure(),
    logging:set_level(debug).

-file("src\\api_server.gleam", 20).
-spec route(gleam@http@request:request(mist@internal@http:connection())) -> gleam@http@response:response(mist:response_data()).
route(Req) ->
    case gleam@http@request:path_segments(Req) of
        [] ->
            gleam_stdlib:println(<<"Base route hit"/utf8>>),
            _pipe = gleam@http@response:new(200),
            _pipe@1 = gleam@http@response:set_header(
                _pipe,
                <<"content-type"/utf8>>,
                <<"text/plain"/utf8>>
            ),
            gleam@http@response:set_body(
                _pipe@1,
                {bytes,
                    begin
                        _pipe@2 = <<"Welcome to Another TODO"/utf8>>,
                        gleam_stdlib:wrap_list(_pipe@2)
                    end}
            );

        [<<"task"/utf8>>] ->
            Tasks = 'Elixir.DatabaseUtil.TaskFunctions':get_all_tasks(),
            gleam_stdlib:println(<<"DEBUG tasks: "/utf8, Tasks/binary>>),
            _pipe@3 = gleam@http@response:new(200),
            _pipe@4 = gleam@http@response:set_header(
                _pipe@3,
                <<"content-type"/utf8>>,
                <<"application/json"/utf8>>
            ),
            gleam@http@response:set_body(
                _pipe@4,
                {bytes,
                    begin
                        _pipe@5 = Tasks,
                        gleam_stdlib:wrap_list(_pipe@5)
                    end}
            );

        _ ->
            _pipe@6 = gleam@http@response:new(404),
            gleam@http@response:set_body(
                _pipe@6,
                {bytes,
                    begin
                        _pipe@7 = <<"request not found"/utf8>>,
                        gleam_stdlib:wrap_list(_pipe@7)
                    end}
            )
    end.

-file("src\\api_server.gleam", 46).
-spec main() -> nil.
main() ->
    logging_ffi:configure(),
    logging:set_level(debug),
    _pipe = fun route/1,
    _pipe@1 = mist:new(_pipe),
    _pipe@2 = mist:bind(_pipe@1, <<"127.0.0.1"/utf8>>),
    _pipe@3 = mist:port(_pipe@2, 4001),
    mist:start(_pipe@3),
    gleam_erlang_ffi:sleep_forever().
