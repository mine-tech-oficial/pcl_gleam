import gleam/list
import gleam/option.{None, Some}
import gleam/result
import gleam/set
import nibble
import nibble/lexer

pub type Token {
  Hyphen
  Colon
  End

  VariableName(String)

  ObjectT
  ListT
  TrueT
  FalseT

  StringT(String)
  IntT(Int)
  FloatT(Float)
}

pub type Value {
  String(String)
  Int(Int)
  Float(Float)
  Bool(Bool)
  Object(List(#(String, Value)))
  List(List(Value))
}

pub type Error {
  LexerError(lexer.Error)
  ParserError(List(nibble.DeadEnd(Token, Nil)))
}

pub fn parse(source) {
  let tokens = lexer.run(source, lexer())
  case tokens {
    Ok(tokens) -> result.map_error(nibble.run(tokens, parser()), ParserError)
    Error(error) -> Error(LexerError(error))
  }
}

fn lexer() {
  lexer.simple([
    lexer.token("-", Hyphen),
    lexer.token(":", Colon),
    lexer.keyword("object", "\\s", ObjectT),
    lexer.keyword("list", "\\s", ListT),
    lexer.keyword("end", "\\s", End),
    lexer.keyword("true", "\\s", TrueT),
    lexer.keyword("false", "\\s", FalseT),
    lexer.variable(set.from_list(["object", "end"]), VariableName),
    lexer.string("\"", StringT),
    lexer.number(IntT, FloatT),
    //
    lexer.comment("//", fn(_) { Nil })
      |> lexer.ignore,
    lexer.whitespace(Nil)
      |> lexer.ignore,
  ])
}

fn parser() {
  nibble.many(expression_parser())
}

fn expression_parser() {
  use variable <- nibble.do(take_variable())
  use _ <- nibble.do(nibble.token(Colon))
  use value <- nibble.do(
    nibble.one_of([take_value(), take_object(), take_array()]),
  )

  // let value_name = case value {
  //   String(value) -> "\"" <> value <> "\""
  //   Int(value) -> int.to_string(value)
  //   Float(value) -> float.to_string(value)
  //   Object(value) -> "{" <> pprint.format(value) <> "}"
  // }

  nibble.return(#(variable, value))
}

fn take_value() {
  use token <- nibble.take_map("a value")

  case token {
    StringT(value) -> Some(String(value))
    IntT(value) -> Some(Int(value))
    FloatT(value) -> Some(Float(value))
    TrueT -> Some(Bool(True))
    FalseT -> Some(Bool(False))
    _ -> None
  }
}

fn take_object() {
  use _ <- nibble.do(nibble.token(ObjectT))
  use value <- nibble.do(nibble.many(nibble.lazy(expression_parser)))
  use _ <- nibble.do(nibble.token(End))

  // Some(value)
  nibble.return(Object(value))
}

fn take_variable() {
  use token <- nibble.take_map("a variable")

  case token {
    VariableName(name) -> Some(name)
    StringT(name) -> Some(name)
    _ -> None
  }
}

fn take_array() {
  use value <- nibble.do(take_array_help())

  case value {
    List(values) ->
      case multiple_types(values) {
        False -> nibble.return(value)
        True -> nibble.fail("Can't have multiple types in a list")
      }
    _ -> nibble.fail("This should never happen")
  }
}

fn take_array_help() {
  use _ <- nibble.do(nibble.token(ListT))
  use _ <- nibble.do(nibble.token(Hyphen))
  use value <- nibble.do(nibble.sequence(
    nibble.one_of([
      take_value(),
      nibble.lazy(take_array),
      nibble.map(nibble.many(nibble.lazy(expression_parser)), Object),
    ]),
    nibble.token(Hyphen),
  ))
  use _ <- nibble.do(nibble.token(End))

  // Some(value)
  nibble.return(List(value))
}

fn multiple_types(values) {
  list.fold_until(
    values,
    #(False, result.unwrap(list.first(values), Int(0))),
    fn(acc, value) {
      case value, acc {
        String(_), #(_, String(_)) -> list.Continue(#(False, value))
        Int(_), #(_, Int(_)) -> list.Continue(#(False, value))
        Float(_), #(_, Float(_)) -> list.Continue(#(False, value))
        Object(_), #(_, Object(_)) -> list.Continue(#(False, value))
        List(_), #(_, List(_)) -> list.Continue(#(False, value))
        _, _ -> list.Stop(#(True, value))
      }
    },
  ).0
}
