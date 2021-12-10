# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

import unittest

import nimbok


type Test* = ref object
  a {.get.}: int
  b {.get, set.}: int
  c: int
  d {.setget.}: float
Test.generate


type Test2* {.setget.} = object
  a: int
  b: float
Test2.generate


type Test3* {.set, get.} = object
  a: int
  b: float
Test3.generate


test "getters and setters":
  var t = Test(a: 2, b: 10)
  assert t.a == 2
  t.b = 3
  assert t.b == 3


test "setget":
  var t = Test(d: 10.5)
  assert t.d == 10.5
  t.d = 0.34
  assert t.d == 0.34


test "type setget":
  var t = Test2(a: 1, b: 0.45)
  assert t.a == 1
  t.b = 0.5
  assert t.b == 0.5


test "type set and get":
  var t = Test2(a: 3, b: 0.66)
  assert t.a == 3
  t.b = 0.78
  assert t.b == 0.78