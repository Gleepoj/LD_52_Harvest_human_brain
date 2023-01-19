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

class InstancedCollisionEvent {
    
    public var allowDialog  :Event_OnDialogArea;
    public var interact:Event_OnInteract;
    public var contact :Event_OnContact;

    public var reset :Event_Reset;

    public function new() {
        interact     = new Event_OnInteract();
        allowDialog  = new Event_OnDialogArea();
        contact      = new Event_OnContact();
        
        reset  = new Event_Reset();
    }
    
}