package aleiiioa.components.logic;

class DoorComponent {

    var open:Bool = true;
   

    public var isOpen(get,never):Bool; inline function get_isOpen() return open;

    public function new(){

    }

    public function openDoor() {
        if(!isOpen)
            open = true;
    }

    public function closeDoor() {
        if(isOpen)
            open = false;
    }
}