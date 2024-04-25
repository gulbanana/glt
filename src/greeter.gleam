import gleam/erlang/process.{type Subject}
import gleam/otp/actor

pub type Message {
  Greet(person: String, reply: Subject(String))
}

pub fn loop(message: Message, state: Nil) {
  case message {
    Greet(person, reply) -> {
      actor.send(reply, "Hello, " <> person)
      actor.continue(state)
    }
  }
}
