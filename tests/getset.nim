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


Test.generate


test "getters and setters":
    var t = Test(a: 2, b: 10)
    assert t.a == 2
    t.b = 3
    assert t.b == 3