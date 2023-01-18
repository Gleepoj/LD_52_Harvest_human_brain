package aleiiioa.systems.collisions;

import echoes.core.RestrictedLinkedList;
import echoes.utils.LinkedList.LinkedNode;
import h3d.Vector;
import echoes.Entity;
import aleiiioa.components.core.rendering.BoundingBox;
import aleiiioa.components.logic.BrainSuckerComponent;
import aleiiioa.components.logic.GrappleComponent;
import aleiiioa.components.flags.logic.CatchableFlag;
import aleiiioa.components.logic.InteractiveComponent;
import aleiiioa.components.flags.logic.*;
import echoes.View;

import aleiiioa.systems.collisions.CollisionEvent.InstancedCollisionEvent;
import aleiiioa.components.core.collision.CollisionsListener;
import aleiiioa.components.core.position.GridPosition;

class EntityCollisionsSystem extends echoes.System {
    var ALL_PNJ:View<GridPosition,PNJFlag>;
    var ALL_CATCHABLE:View<CatchableFlag,InteractiveComponent,GridPosition,BoundingBox,CollisionsListener>;
    var PLAYER :View<GridPosition,PlayerFlag>;
    var GRAPPLE:View<GridPosition,GrappleComponent>;
    
    var ACCURACY:Int=0;

    var events:InstancedCollisionEvent;

    public function new() {
        events = new InstancedCollisionEvent();
    }

    function orderListener(cl:CollisionsListener){
        if (cl.lastEvent!=null)
            cl.lastEvent.send(cl);
    }
    
    @u function getAccuracy(br:BrainSuckerComponent){
        ACCURACY = br.brains;
    }

    @u function grappleGetCatchable(flag:GrappleComponent,gp:GridPosition,cl:CollisionsListener,bb:BoundingBox){
     
        preCollide(gp,bb,cl,ALL_CATCHABLE.entities.head);
        collide(gp,bb,cl,ALL_CATCHABLE.entities.head);
    }

    function preCollide(gp:GridPosition,bb:BoundingBox,cl:CollisionsListener,_head:Dynamic){
        var head = _head;
        var grapplePos = gp.gpToVector();

        while (head != null){
            var object:echoes.Entity   = head.value;
            var objectBB :BoundingBox  = object.get(BoundingBox);
            var objectPos:Vector       = object.get(GridPosition).gpToVector();
            

            var collision_radius = (bb.outerRadius + objectBB.outerRadius);

            if(grapplePos.distance(objectPos) < collision_radius ){
                var objectCL  = object.get(CollisionsListener);
                cl.lastEvent = events.allowInteract;
                orderListener(cl);
                objectCL.lastEvent = events.allowInteract;
                orderListener(objectCL);
            }
            head = head.next;
        }
    }

    function collide(gp:GridPosition,bb:BoundingBox,cl:CollisionsListener,_head:Dynamic){
        var head = _head;
        var grapplePos = gp.gpToVector();

        while (head != null){
            var object:echoes.Entity   = head.value;
            var objectBB :BoundingBox  = object.get(BoundingBox);
            var objectPos:Vector       = object.get(GridPosition).gpToVector();
            

            var collision_radius = (bb.innerRadius + objectBB.innerRadius);

            if(grapplePos.distance(objectPos) < collision_radius ){
                var objectCL  = object.get(CollisionsListener);
                cl.lastEvent = events.allowContact;
                orderListener(cl);
                objectCL.lastEvent = events.allowContact;
                orderListener(objectCL);
            }
            head = head.next;
        }
    }

/*     function collide(collider:Entity,collided:View<>){
        
    } */

   /*  @u function grappleInInteractArea(gp:GridPosition,flag:GrappleComponent,cl:CollisionsListener,bb:BoundingBox) {
        var head = ALL_CATCHABLE.entities.head;
        var grapplePos = gp.gpToVector();

        while (head != null){
            var object = head.value;
            var objectPos = object.get(GridPosition).gpToVector();
            var objectBB  = object.get(BoundingBox);
            

            var collision_radius = (bb.outerRadius + objectBB.outerRadius);
            if(grapplePos.distance(objectPos) < collision_radius ){
                cl.lastEvent = events.allowInteract;
                orderListener(cl);
            }
            head = head.next;
        }
    }

    
    @u function CatchableInInteractArea(catchable:CatchableFlag,gp:GridPosition,cl:CollisionsListener,bb:BoundingBox) {
        var grabber = GRAPPLE.entities.head.value;
        
        var grabberPos= grabber.get(GridPosition).gpToVector();
        var grabberBB = grabber.get(BoundingBox); 
        
        var objectPos = gp.gpToVector();
        var collision_radius = (bb.outerRadius + grabberBB.outerRadius);

        if(grabberPos.distance(objectPos) < collision_radius){
            cl.lastEvent = events.allowInteract;
            orderListener(cl);
        }
        
    } */



}