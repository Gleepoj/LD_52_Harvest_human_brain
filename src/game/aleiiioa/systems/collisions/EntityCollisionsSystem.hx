package aleiiioa.systems.collisions;

import aleiiioa.components.tools.LauncherFSM;
import aleiiioa.components.tools.GrappleFSM;
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
    var GRAPPLE:View<GridPosition,GrappleFSM>;
    var LAUNCHER:View<GridPosition,LauncherFSM>;
    
    var ACCURACY:Int=0;

    var events:InstancedCollisionEvent;

    public function new() {
        events = new InstancedCollisionEvent();
    }

    function orderListener(cl:CollisionsListener){
        if (cl.lastEvent!=null)
            cl.lastEvent.send(cl);
    }
    
    @u function grappleCollisions(flag:GrappleFSM,gp:GridPosition,cl:CollisionsListener,bb:BoundingBox){
     
        preCollide(gp,bb,cl,ALL_CATCHABLE.entities.head,events.interact);
        collide(gp,bb,cl,ALL_CATCHABLE.entities.head,events.contact);
        preCollide(gp,bb,cl,LAUNCHER.entities.head,events.drone_interact_launcher);
    }

    function preCollide(gp:GridPosition,bb:BoundingBox,cl:CollisionsListener,_head:Dynamic,_order:CollisionEvent){
        var head = _head;
        var grapplePos = gp.gpToVector();

        while (head != null){
            var object:echoes.Entity   = head.value;
            var objectBB :BoundingBox  = object.get(BoundingBox);
            var objectPos:Vector       = object.get(GridPosition).gpToVector();
    
            var collision_radius = (bb.outerRadius + objectBB.outerRadius);

            if(grapplePos.distance(objectPos) < collision_radius ){
                var objectCL = object.get(CollisionsListener);
                cl.lastEvent = _order;
                orderListener(cl);
                objectCL.lastEvent = _order;
                orderListener(objectCL);
            }
            head = head.next;
        }
    }

    function collide(gp:GridPosition,bb:BoundingBox,cl:CollisionsListener,_head:Dynamic,_order:CollisionEvent){
        var head = _head;
        var grapplePos = gp.gpToVector();

        while (head != null){
            var object:echoes.Entity   = head.value;
            var objectBB :BoundingBox  = object.get(BoundingBox);
            var objectPos:Vector       = object.get(GridPosition).gpToVector();
            
            var collision_radius = (bb.innerRadius + objectBB.innerRadius);

            if(grapplePos.distance(objectPos) < collision_radius ){
                var objectCL  = object.get(CollisionsListener);
                cl.lastEvent = _order;
                orderListener(cl);
                objectCL.lastEvent =_order;
                orderListener(objectCL);
            }
            head = head.next;
        }
    }

}