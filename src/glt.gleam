import gleam/erlang/process
import gleam/io
import gleam/otp/actor
import greeter
import printer

pub fn main() {
  let assert Ok(greeter) = actor.start(Nil, greeter.loop)
  let assert Ok(printer) =
    actor.start_spec(actor.Spec(
      fn() { printer.init(greeter) },
      100,
      printer.loop,
    ))

  actor.send(printer, printer.Start(5))

  io.println("^C-a to exit lol")
  process.sleep_forever()
}
