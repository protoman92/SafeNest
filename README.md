# SafeNest

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![CocoaPods](https://img.shields.io/cocoapods/v/SafeNest.svg)
[![Build Status](https://travis-ci.org/protoman92/SafeNest.svg?branch=master)](https://travis-ci.org/protoman92/SafeNest)
[![Coverage Status](https://coveralls.io/repos/github/protoman92/SafeNest/badge.svg?branch=master)](https://coveralls.io/github/protoman92/SafeNest?branch=master)

Safe nest for all the swifties. The nest provides dynamic, JSON-like storage and exposes methods to access/update nested values.

## Usage

To use this nest:

```swift
import SafeNest

let nest1 = SafeNest.builder().build()
let nest2 = SafeNest.empty()

let nest3 = SafeNest.empty()
  .cloneBuilder()
  .with(initialObject: ["a" : 1])
  .with(pathSeparator: "$")                     // Now you need to use "a$b$c$d"
  .build()
```

To access the value at any node, use:

```swift
nest.value(at: String);
```

The parameter of this function should be a String whose components are joined with the specified **pathSeparator** (which is by default "."). The return values are wrapped in a **Try** instance to allow mapping/flatMapping <https://github.com/protoman92/SwiftFP/blob/master/SwiftFP/Try.swift>. For example:

```swift
nest.value(at: "a.b.c.d.e")                     // Returns type Try<Any>
nest.value(at: "a.b.c.d.e").cast(Int.self)      // Returns type Try<Int>
nest.value(at: "a.b.c.d.e").cast(String.self)   // Returns type Try<String>
nest.decode<D>(at: "a.b.c.d.e, ofType: D)       // Returns type Try<D>, where D: Decodable
```

In order to update the value at some node, call:

```swift
try nest.update(at: String, value: Any)         // This method mutates
try nest.updating(at: String, value: Any)       // This method returns a new nest.
try nest.encode(at: String, value: Encodable)   // This method encodes an object and deposit at a node.
```

The nest will update the value at that node, and if necessary create new dictionaries along the way.

Please note that currently only [String : Any] dict and [Any] array are supported. Generally this should be fine, considering the types of payload that could arrive from a backend server.

## Usage with Redux

A nest can serve as the global state container for a Redux-based application like so:

- The client receives a payload such as:

```json
{
  "a": { "b": [1, 2, 3, { "c": { "d": "This is so nested" } }] },
  "b": { "c": { "0": 1, "1": 2, "2": 3, "3": 4 } }
}
```

- It can then access nested properties with:

```swift
nest.value(at: "a.b.0")                         // Returns Try.success(1)
nest.value(at: "b.c.1")                         // Returns Try.success(2)
nest.value(at: "a.b.3.c.d")                     // Returns Try.success("This is so nested")
nest.value(at: "a.b.3.d.e")                     // Returns Try.failure("...")
```

- We can then use these values to drive state changes.

For a more concrete example, check out the demo included in this repository, or visit the demo at <https://github.com/protoman92/HMReactiveRedux-Swift>.
