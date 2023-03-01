package aleiiioa.systems.collisions;

import h3d.Vector;
import aleiiioa.components.core.collision.CollisionsListener;


interface CollisionEvent {
    public function send(cl:CollisionsListener):Void;    
}

class Event_Reset implements  CollisionEvent {
    public function new() {
    }

    public function send(cl:CollisionsListener) {
  
    }
}

class Event_OnDialogArea implements  CollisionEvent {
    public function new() {
    }

    public function send(cl:CollisionsListener) {
        cl.cd.setS("pnj ready",0.005);  
    }
}

class Event_OnInteract implements CollisionEvent {
    public function new() {
        
    }
    public function send(cl:CollisionsListener){
        cl.cd.setS("interact",0.001);
    }
}

class Event_OnContact implements CollisionEvent {
    public function new() {
        
    }
    public function send(cl:CollisionsListener){
        cl.cd.setS("contact",0.001);
    }
}

class Event_OnContactDoor implements CollisionEvent {
    public function new() {
        
    }
    public function send(cl:CollisionsListener){
        cl.cd.setS("contact_door",0.001);
    }
}

class Event_OnSwallowGille implements CollisionEvent {
    public function new() {
        
    }
    public function send(cl:CollisionsListener){
        cl.cd.setS("swallow_gille",0.001);
    }
}

class Event_OnSwallowJohn implements CollisionEvent {
    public function new() {
        
    }
    public function send(cl:CollisionsListener){
        cl.cd.setS("swallow_john",0.001);
    }
}

class Event_OnDroneInteractLauncher implements CollisionEvent {
    public function new() {
        
    }
    public function send(cl:CollisionsListener){
        cl.cd.setS("drone_launcher",0.001);
    }
}

class InstancedCollisionEvent {
    
    public var allowDialog  :Event_OnDialogArea;
    public var interact:Event_OnInteract;
    public var contact :Event_OnContact;
    public var drone_interact_launcher : Event_OnDroneInteractLauncher;
    public var contact_door:Event_OnContactDoor;
    public var swallow_gille:Event_OnSwallowGille;
    public var swallow_john:Event_OnSwallowJohn;

    public var reset :Event_Reset;

    public function new() {
        interact     = new Event_OnInteract();
        allowDialog  = new Event_OnDialogArea();
        
        contact      = new Event_OnContact();
        contact_door = new Event_OnContactDoor();
        drone_interact_launcher = new Event_OnDroneInteractLauncher();
        
        swallow_gille= new Event_OnSwallowGille();
        swallow_john = new Event_OnSwallowJohn();

        
        reset  = new Event_Reset();
    }
    
}