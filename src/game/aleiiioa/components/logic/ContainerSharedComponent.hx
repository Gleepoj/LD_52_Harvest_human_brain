package aleiiioa.components.logic;

class ContainerSharedComponent {
    public var suggested:Array<Int> = [];
    public var containers:Map<Int,Container_State> = new Map();
    public var current_position:Int = 1; // 1/2/3 
    
    public function new(){
        containers.set(1,Empty);
        containers.set(2,Empty);
        containers.set(3,Empty);
    }

    public function fillContainer(type:Container_State){
        containers.set(current_position,type);
        current_position += 1;

        if(current_position > 3)
            clearContainer();
    }

    public function clearContainer(){
        current_position = 1;
        containers.set(1,Empty);
        containers.set(2,Empty);
        containers.set(3,Empty);
    }
}