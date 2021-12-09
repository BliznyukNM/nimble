import macros


template get* {.pragma.}
template set* {.pragma.}


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


proc getPragmas(node: NimNode, pragmaName: string): seq[NimNode] =
  node.expectKind nnkTypeDef
  let objectTyIdent = if node[2].kind == nnkObjectTy: node[2] elif node[2].kind == nnkRefTy: node[2][0] else: raise newException(OSError, "Wrong")
  let identDefs = objectTyIdent[2]
  for identDef in identDefs:
    let pragmaExpr = identDef[0]
    if pragmaExpr.kind != nnkPragmaExpr: continue
    for child in pragmaExpr[1].children:
      if $child == pragmaName:
        result.add(identDef)
        break


macro generate*[T](t: typedesc[T]): untyped =
  result = newStmtList()
  let typeImpl = t.getTypeInst[1].getImpl

  let getters = typeImpl.getPragmas("get")
  for getter in getters: 
    result.add(createGetter(getter, typeImpl[0].strVal))
  
  let setters = typeImpl.getPragmas("set")
  for setter in setters:
    result.add(createSetter(setter, typeImpl[0].strVal))
