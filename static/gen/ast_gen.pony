
use "collections"

class ASTGen
  let defs:   List[_Def]               = defs.create()
  let unions: Map[String, Set[String]] = unions.create()
  
  new ref create() => None
  
  fun ref def(n: String):                 _DefFixed => _DefFixed(this, n)
  fun ref def_wrap(n: String, t: String): _DefWrap  => _DefWrap(this, n, t)
  
  fun string(): String =>
    let g: CodeGen = CodeGen
    
    // Declare each type union.
    for (name, types) in unions.pairs() do
      g.line("type " + name + " is (")
      let iter = types.values()
      for t in iter do
        g.add(t)
        if iter.has_next() then g.add(" | ") end
      end
      g.add(")")
      g.line()
    end
    
    // Declare each class def.
    for d in defs.values() do
      d.code_gen(g)
    end
    
    g.string()
  
  fun ref _add_to_union(u: String, m: String) =>
    try  unions(u).set(m)
    else unions(u) = Set[String].>set(m)
    end
