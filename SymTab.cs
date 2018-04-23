using System;
 
namespace Tastier { 

public class Obj { // properties of declared symbol
   public string name; // its name
   public int kind;    // var, proc, scope or constant
   public int type;    // its type if var (undef for proc)
   public int sort;    // whether it is a scalar or array.
   public int level;   // lexic level: 0 = global; >= 1 local
   public int adr;     // address (displacement) in scope
   public int arrSize; // The size of the inner array. 
   public Obj next;    // ptr to next object in scope
   // for scopes
   public Obj outer;   // ptr to enclosing scope
   public Obj locals;  // ptr to locally declared objects
   public int nextAdr; // next free address in scope
   public string parent; //The name of the struct the obj is in.
}

public class SymbolTable {

   const int // object kinds
      var = 0, proc = 1, scope = 2, constant = 3; 

   const int // types
      undef = 0, integer = 1, boolean = 2;
   const int // sort 
	   scalar=0, arrayOne = 1, arrayTwo = 2;

   public Obj topScope; // topmost procedure scope
   public int curLevel; // nesting level of current scope
   public Obj undefObj; // object node for erroneous symbols

   public bool mainPresent;
   
   Parser parser;
   
   public SymbolTable(Parser parser) {
      curLevel = -1; 
      topScope = null;
      undefObj = new Obj();
      undefObj.name = "undef";
      undefObj.kind = var;
      undefObj.type = undef;
      undefObj.level = 0;
      undefObj.adr = 0;
      undefObj.next = null;
      this.parser = parser;
      mainPresent = false;
   }

// open new scope and make it the current scope (topScope)
   public void OpenScope() {
      Obj scop = new Obj();
      scop.name = "";
      scop.kind = scope; 
      scop.outer = topScope; 
      scop.locals = null;
      scop.nextAdr = 0;
      topScope = scop; 
      curLevel++;
   }

// close current scope
   public void CloseScope() {

         Obj obj = topScope.locals;
	 if(obj != null && obj.level >0) Console.Write("; Local variables:\n");
         while (obj != null) { // for all objects in this scope
	    if(obj.kind == var && obj.level>0){
		String typeName = "undef";
		    if(obj.type == integer){
			typeName = "integer";
		    }else if(obj.type == boolean){
			typeName = "boolean";
		    }
		    Console.Write("; 	" + obj.name + " Type: " + typeName + " Address: " + obj.adr + "\n");
	    }
            obj = obj.next;
         }
         obj = topScope.locals;
	 if(obj != null && obj.level == 0) Console.Write("; Global variables:\n");
         while (obj != null) { // for all objects in this scope
	    if(obj.kind == var && obj.level == 0){
		String typeName = "undef";
		    if(obj.type == integer){
			typeName = "integer";
		    }else if(obj.type == boolean){
			typeName = "boolean";
		    }
		    Console.Write("; 	" + obj.name + " Type: " + typeName + " Address: " + obj.adr + "\n");
	    }
            obj = obj.next;
         }
         obj = topScope.locals;
	 if(obj != null) Console.Write("; Procedures:\n");
         while (obj != null) { // for all objects in this scope
	    if(obj.kind == proc){
		String typeName = "proc";
		    Console.Write("; 	" + obj.name + " Type: " + typeName + " Address: " + obj.adr + "\n");
	    }
            obj = obj.next;
         }
      	topScope = topScope.outer;
      	curLevel--;
   }

// open new sub-scope and make it the current scope (topScope)
   public void OpenSubScope() {
   // lexic level remains unchanged
      Obj scop = new Obj();
      scop.name = "";
      scop.kind = scope;
      scop.outer = topScope;
      scop.locals = null;
   // next available address in stack frame remains unchanged
      scop.nextAdr = topScope.nextAdr;
      topScope = scop;
   }

// close current sub-scope
   public void CloseSubScope() {
   // update next available address in enclosing scope
      topScope.outer.nextAdr = topScope.nextAdr;
   // lexic level remains unchanged
      topScope = topScope.outer;
   }
   // create new object node in current scope.
   public Obj NewObj(string name, int kind, int type){ 
     return NewObj(name, kind, type, scalar, 1, 0, "");
   }
   // create new object node in current scope member of a struct.
   public Obj NewObj(string name, int kind, int type, string parent){ 
     return NewObj(name, kind, type, scalar, 1, 0, parent);
   }
// create new object node in current scope extended for arrays.
   public Obj NewObj(string name, int kind, int type, int sort, int size, int arrSize){ 
	return NewObj(name, kind, type, sort, size, arrSize, "");
   }
// create new object node in current scope extended for arrays, that is a member of a struct.
   public Obj NewObj(string name, int kind, int type, int sort, int size, int arrSize, string parent) {
      Obj p, last; 
      Obj obj = new Obj();
      obj.name = name; obj.kind = kind;
      obj.type = type; obj.level = curLevel;
      obj.sort = sort;
      obj.parent = parent; 
      
      obj.next = null; 
      p = topScope.locals; last = null;
      while (p != null) { 
         if (p.name == name)
            parser.SemErr("name declared twice");
         last = p; p = p.next;
      }
      if (last == null)
         topScope.locals = obj; else last.next = obj;
      if (sort == scalar){
      	if (kind == var || kind == constant)
        	 obj.adr = topScope.nextAdr++;
      } else if(sort == arrayOne || sort == arrayTwo){
		obj.arrSize = arrSize;
	        obj.adr = topScope.nextAdr;
		topScope.nextAdr+=size;
      }
      return obj;
   }



// search for name in open scopes and return its object node
   public Obj Find(string name) {
      Obj obj, scope;
      scope = topScope;
      while (scope != null) { // for all open scopes
         obj = scope.locals;
         while (obj != null) { // for all objects in this scope
            if (obj.name == name) return obj;
            obj = obj.next;
         }
         scope = scope.outer;
      }
      parser.SemErr(name + " is undeclared");
      return undefObj;
   }

} // end SymbolTable

} // end namespace
