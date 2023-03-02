package aleiiioa.components.logic;

class ContainerSharedComponent {
    public var suggested:Array<Int> = [];
    public var containers:Map<Int,Container_State> = new Map();
    public var current_position:Int = 0; // 1/2/3 
    var full:Bool = false;

    public var isFull(get,never):Bool; inline function get_isFull() return full;
    
    public function new(){
        containers.set(1,Empty);
        containers.set(2,Empty);
        containers.set(3,Empty);
    }

    public function fillContainer(type:Container_State){
        //trace(type);
        if(!isFull){
          current_position += 1;
          containers.set(current_position,type);
          //trace(current_position);
        }

        if(current_position == 3)
            full = true;
    }

    function emptyContainers(){
        full = false;
    }

    public function clearContainer(){
        current_position = 0;
        containers.set(1,Empty);
        containers.set(2,Empty);
        containers.set(3,Empty);
        emptyContainers();
    }
}