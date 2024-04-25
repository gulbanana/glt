import gleam/erlang/process.{type Subject}
import gleam/function.{identity}
import gleam/io
import gleam/otp/actor
import greeter

pub type State {
  State(self: Subject(Message), greeter: Subject(greeter.Message), count: Int)
}

pub type Message {
  Start(count: Int)
  Loop
}

pub fn init(greeter: Subject(greeter.Message)) {
  let subject = process.new_subject()
  let state = State(subject, greeter, 0)
  let selector =
    process.new_selector()
    |> process.selecting(subject, identity)

  actor.Ready(state, selector)
}

pub fn loop(message: Message, state: State) {
  case message {
    Start(count) -> {
      actor.send(state.self, Loop)
      actor.continue(State(..state, count: count))
    }
    Loop -> {
      case state.count {
        0 -> actor.Stop(process.Normal)
        x -> {
          let greeting =
            actor.call(state.greeter, greeter.Greet("World", _), 100)
          io.println(greeting)
          actor.send(state.self, Loop)
          actor.continue(State(..state, count: x - 1))
        }
      }
    }
  }
}
