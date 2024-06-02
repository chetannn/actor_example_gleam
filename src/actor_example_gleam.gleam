import actor/mailbox
import gleam/io

pub fn main() {
  let assert Ok(mailbox) = mailbox.new()
  mailbox.add_item(mailbox, "Hello")
  mailbox.add_item(mailbox, "Wassup?")
  mailbox.add_item(mailbox, "Cool")
  mailbox.add_item(mailbox, "Hy")

  let assert Ok(value) = mailbox.take_item(mailbox, "Cool")
  let assert Ok(value2) = mailbox.take_item(mailbox, "Hello")

  io.println(value)
  io.println(value2)
}
