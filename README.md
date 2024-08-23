# pcl

A package for parsing [PCL](https://github.com/mine-tech-oficial/pcl) files.

[![Package Version](https://img.shields.io/hexpm/v/pcl)](https://hex.pm/packages/pcl)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/pcl/)

## Quickstart

To check the capabilities of this package, just run the following example:

```gleam
import pcl

pub fn main() {
  // Your input string
  let input = "hello: \"world\""
  // Parse the input string
  let output = pcl.parse(input)
  // Check if the parsing was successful
  assert Ok(value) = output
  // Print the parsed value
  io.debug(value)
}
```

Further documentation can be found at <https://hexdocs.pm/pcl>.

## Installation

To install this package, run the following command:

```sh
gleam add pcl
```

The docs are available at <https://hexdocs.pm/pcl>.
