package aleiiioa.components.logic;

class ContainerSharedComponent {
    public var suggested:Array<Int> = [];
    var containers:Map<Int,Int> = new Map();
    public var current_position:Int = 1; // 1/2/3 
    
    public function new(){
        containers.set(1,0);
        containers.set(2,0);
        containers.set(3,0);
    }
}