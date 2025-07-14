import gleam/bytes_tree
import gleam/erlang/process
import gleam/http/request.{type Request}
import gleam/http/response.{
  type Response, new as new_response, set_body, set_header,
}
import gleam/io
import logging

@external(erlang, "Elixir.DatabaseUtil.TaskFunctions", "get_all_tasks")
pub fn get_all_tasks() -> String

import mist.{type Connection, type ResponseData}

pub fn logs() {
  logging.configure()
  logging.set_level(logging.Debug)
}

pub fn route(req: Request(Connection)) -> Response(ResponseData) {
  case request.path_segments(req) {
    [] -> {
      io.println("Base route hit")
      new_response(200)
      |> set_header("content-type", "text/plain")
      |> set_body(mist.Bytes(
        "Welcome to Another TODO" |> bytes_tree.from_string,
      ))
    }

    ["task"] -> {
      let tasks = get_all_tasks()

      io.println("DEBUG tasks: " <> tasks)

      new_response(200)
      |> set_header("content-type", "application/json")
      |> set_body(mist.Bytes(tasks |> bytes_tree.from_string))
    }
    _ ->
      new_response(404)
      |> set_body(mist.Bytes("request not found" |> bytes_tree.from_string))
  }
}

pub fn main() {
  logging.configure()
  logging.set_level(logging.Debug)
  route
  |> mist.new
  |> mist.bind("127.0.0.1")
  |> mist.port(4001)
  |> mist.start
  process.sleep_forever()
}
