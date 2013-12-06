// ported from here https://github.com/cassiozen/AS3-State-Machine
part of statemachine;

class State
{
  String name;
  dynamic from;
  Function enter;
  Function exit;
  State _parent;
  List children;
  
  State({String name, 
                 dynamic from:null, 
                 Function enter:null,
                 Function exit:null,
                 State parent:null})
  {
    this.name       = name;
    if(from == null)
    {
      from = "*";
    }
    this.enter    = enter;
    this.exit     = exit;
    this.children     = [];
    if(parent == null)
    {
      _parent = parent;
      _parent.children.add(this);
    }
  }
  
  State get parent
  {
    return _parent;
  }
  
  void set parent(State value)
  {
    _parent = value;
    _parent.children.add(this);
  }
  
  State get root
  {
    State parentState = _parent;
    if(parentState != null)
    {
      while(parentState.parent != null)
      {
        parentState = parentState.parent;
      }
    }
    return parentState;
  }
  
  List get parents
  {
    List parentList = [];
    State parentState = _parent;
    if(parentState != null)
    {
      parentList.add(parentState);
      while(parentState.parent != null)
      {
        parentState = parentState.parent;
        parentList.add(parentState);
      }
    }
    return parentList;
  }
  
}