import macros


template get* {.pragma.}
template set* {.pragma.}
template setget* {.pragma.}


proc createGetter(identDef: NimNode, typeName: string): NimNode =
  let name = identDef[0][0]
  let fieldType = identDef[1]
  result = newProc(postfix(name, "*"), [
    fieldType,
    newIdentDefs(ident("this"), ident(typeName)),
    ], newStmtList(newTree(nnkDotExpr, ident("this"), name))
  )


proc createSetter(identDef: NimNode, typeName: string): NimNode =
  let name = identDef[0][0]
  let fieldType = identDef[1]
  result = newProc(postfix(name, "*"), [
    ident("void"),
    newIdentDefs(ident("this"), newTree(nnkVarTy, ident(typeName))),
    newIdentDefs(ident("value"), fieldType)
    ], newStmtList(newAssignment(newTree(nnkDotExpr, ident("this"), name), ident("value")))
  )


proc fields(node: NimNode): seq[NimNode] =
  node.expectKind nnkTypeDef 
  let objectTyIdent =
    if node[2].kind == nnkObjectTy: node[2]
    elif node[2].kind == nnkRefTy: node[2][0]
    else: raise newException(OSError, "Wrong")
  for identDef in objectTyIdent[2]:
    result.add(identDef)


proc getFieldsWithPragma(node: NimNode, pragmaName: string): seq[NimNode] =
  for field in node.fields:
    let pragmaExpr = field[0]
    if pragmaExpr.kind != nnkPragmaExpr: continue
    for child in pragmaExpr[1].children:
      if $child == pragmaName:
        result.add(field)


proc hasPragma(node: NimNode, pragmaName: string): bool =
  node.expectKind nnkTypeDef
  echo node.treeRepr
  if node[0].kind != nnkPragmaExpr: return false
  for pragma in node[1].children:
    if pragma.strVal == pragmaName: return true


macro generate*[T](t: typedesc[T]): untyped =
  result = newStmtList()
  let typeImpl = t.getTypeInst[1].getImpl
  let className =
    if typeImpl[0].kind == nnkSym: typeImpl[0].strVal
    elif typeImpl[0].kind == nnkPragmaExpr: typeImpl[0][0].strVal
    else: raise newException(OSError, "Something wrong with type structure")

  let allFieldsSetGets = typeImpl.hasPragma("setget")
  let allFieldsGetters = typeImpl.hasPragma("get") or allFieldsSetGets
  let allFieldsSetters = typeImpl.hasPragma("set") or allFieldsSetGets

  if allFieldsGetters:
    for field in typeImpl.fields:
      result.add(createGetter(field, className))
  
  if allFieldsSetters:
    for field in typeImpl.fields:
      result.add(createSetter(field, className))

  for field in typeImpl.getFieldsWithPragma("get"):
    result.add(createGetter(field, className))
  
  for field in typeImpl.getFieldsWithPragma("set"):
    result.add(createSetter(field, className))
  
  for field in typeImpl.getFieldsWithPragma("setget"):
    result.add(createGetter(field, className))
    result.add(createSetter(field, className))
