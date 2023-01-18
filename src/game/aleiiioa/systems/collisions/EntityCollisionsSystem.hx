package aleiiioa.systems.collisions;

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
    var ALL_CATCHABLE:View<CatchableFlag,InteractiveComponent>;
    var PLAYER :View<GridPosition,PlayerFlag>;
    var GRAPPLE:View<GridPosition,GrappleComponent>;
    
    var ACCURACY:Int=0;

    var events:InstancedCollisionEvent;

    public function new() {
        events = new InstancedCollisionEvent();
    }
    
    @u function getAccuracy(br:BrainSuckerComponent){
        ACCURACY = br.brains;
    }

    @u function playerInDialogArea(gp:GridPosition,flag:PlayerFlag,cl:CollisionsListener) {
        var head = ALL_PNJ.entities.head;
        var playerPos = gp.gpToVector();

        while (head != null){
            var pnj = head.value;
            var pnjPos = pnj.get(GridPosition).gpToVector();
            if(playerPos.distance(pnjPos)<30){
                cl.lastEvent = events.allowDialog;
                orderListener(cl);
            }
            head = head.next;
        }
    }

    @u function pnjInDialogArea(gp:GridPosition,flag:PNJFlag,cl:CollisionsListener) {
        var player = PLAYER.entities.head.value;
        var pgp = player.get(GridPosition);
        var playerPos = pgp.gpToVector();
        var pnjPos = gp.gpToVector();

        if(playerPos.distance(pnjPos)<30){
            cl.lastEvent = events.allowDialog;
            orderListener(cl);
        }
        
    }
   


    @u function grappleInInteractArea(gp:GridPosition,flag:GrappleComponent,cl:CollisionsListener,bb:BoundingBox) {
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
        
    }


    function orderListener(cl:CollisionsListener){
        if (cl.lastEvent!=null)
            cl.lastEvent.send(cl);
    }
}