import gleam/erlang/process.{type Subject}
import gleam/otp/actor
import gleam/set.{type Set}

const timeout: Int = 5000

pub type Message {
  AddItem(item: String)
  TakeItem(reply_with: Subject(Result(String, Nil)), item: String)
  Shutdown
}

pub fn new() -> Result(Subject(Message), actor.StartError) {
  actor.start(set.new(), handle_message)
}

pub fn add_item(box: Subject(Message), item: String) -> Nil {
  actor.send(box, AddItem(item))
}

pub fn take_item(box: Subject(Message), item: String) -> Result(String, Nil) {
  actor.call(box, TakeItem(_, item), timeout)
}

pub fn close(box: Subject(Message)) -> Nil {
  actor.send(box, Shutdown)
}

fn handle_message(
  message: Message,
  box: Set(String),
) -> actor.Next(Message, Set(String)) {
  case message {
    Shutdown -> actor.Stop(process.Normal)
    AddItem(item) -> actor.continue(set.insert(box, item))
    TakeItem(client, item) ->
      case set.contains(box, item) {
        False -> {
          process.send(client, Error(Nil))
          actor.continue(box)
        }
        True -> {
          process.send(client, Ok(item))
          actor.continue(set.delete(box, item))
        }
      }
  }
}
