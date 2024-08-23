import birdie
import gleeunit
import gleeunit/should
import pcl
import pprint

pub fn main() {
  gleeunit.main()
}

pub fn many_properties_test() {
  "hello: \"world\"	
world: \"hello\""
  |> pcl.parse
  |> should.be_ok
  |> pprint.format
  |> birdie.snap("Many properties")
}

pub fn underscore_variable_test() {
  "hello_world: \"hi!\""
  |> pcl.parse
  |> should.be_ok
  |> pprint.format
  |> birdie.snap("Underscore variable")
}

pub fn string_test() {
  "hello: \"world\""
  |> pcl.parse
  |> should.be_ok
  |> pprint.format
  |> birdie.snap("String")
}

pub fn integer_test() {
  "integer37: 37"
  |> pcl.parse
  |> should.be_ok
  |> pprint.format
  |> birdie.snap("Integer")
}

pub fn float_test() {
  "float37: 37.37"
  |> pcl.parse
  |> should.be_ok
  |> pprint.format
  |> birdie.snap("Float")
}

pub fn true_test() {
  "bool: true"
  |> pcl.parse
  |> should.be_ok
  |> pprint.format
  |> birdie.snap("True")
}

pub fn false_test() {
  "bool: false"
  |> pcl.parse
  |> should.be_ok
  |> pprint.format
  |> birdie.snap("False")
}

pub fn nested_object_test() {
  "hello: object
  world: \"hello\"
  end"
  |> pcl.parse
  |> should.be_ok
  |> pprint.format
  |> birdie.snap("Nested object")
}

pub fn very_nested_object_test() {
  "hello: object
world: object
testing: \"does it work?\"
end
another: object
parameter: 123
end
again: 123.01
end"
  |> pcl.parse
  |> should.be_ok
  |> pprint.format
  |> birdie.snap("Very nested object")
}

pub fn int_list_test() {
  "ints: list
  - 123
  - 456
end"
  |> pcl.parse
  |> should.be_ok
  |> pprint.format
  |> birdie.snap("List of Ints")
}

pub fn float_list_test() {
  "floats: list
  - 123.456
  - 789.012
end"
  |> pcl.parse
  |> should.be_ok
  |> pprint.format
  |> birdie.snap("List of Floats")
}

pub fn string_list_test() {
  "strings: list
  - \"hello\"
  - \"world\"
end"
  |> pcl.parse
  |> should.be_ok
  |> pprint.format
  |> birdie.snap("List of Strings")
}

pub fn object_list_test() {
  "objects: list
- hello: \"world\"
  world: 123
- bye: \"planet\"
  planet: 456
end"
  |> pcl.parse
  |> should.be_ok
  |> pprint.format
  |> birdie.snap("List of Objects")
}

pub fn list_of_lists_test() {
  "lists: list
- more: list
  - 123
  - 456
  end
- things: list
  - \"hello\"
  - \"world\"
  end
end"
  |> pcl.parse
  |> should.be_ok
  |> pprint.format
  |> birdie.snap("List of Lists")
}

pub fn many_types_list_test() {
  "types: list
- 123
- 123.456
- \"hello\"
end"
  |> pcl.parse
  |> should.be_error
  |> pprint.format
  |> birdie.snap("List of Many Types")
}
