import macros

dumpTree:
  type Type* = ref object
    field {.getter, setter.}: float
    emptyField: int

  proc getField*(this: Type): int = this.field
  proc setField*(this: var Type, field: int) = this.field = field