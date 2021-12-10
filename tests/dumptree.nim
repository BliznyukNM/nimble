import macros

dumpTree:
  type A* = ref object
  type B* {.setget.} = ref object

  type Type* {.setget.} = ref object
    field {.getter, setter.}: float
    emptyField: int

  proc getField*(this: Type): int = this.field
  proc setField*(this: var Type, field: int) = this.field = field