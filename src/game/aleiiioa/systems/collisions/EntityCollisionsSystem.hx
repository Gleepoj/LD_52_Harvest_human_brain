package aleiiioa.systems.collisions;

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

    var events:InstancedCollisionEvent;

    public function new() {
        events = new InstancedCollisionEvent();
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

    @u function playerInInteractArea(gp:GridPosition,flag:PlayerFlag,cl:CollisionsListener) {
        var head = ALL_CATCHABLE.entities.head;
        var playerPos = gp.gpToVector();

        while (head != null){
            var obj = head.value;
            var objPos = obj.get(GridPosition).gpToVector();
            if(playerPos.distance(objPos)<10){
                cl.lastEvent = events.allowInteract;
                orderListener(cl);
            }
            head = head.next;
        }
    }

    
    @u function CatchableInInteractArea(catchable:CatchableFlag,gp:GridPosition,cl:CollisionsListener) {
        var player = PLAYER.entities.head.value;
        var pgp = player.get(GridPosition);
        var playerPos = pgp.gpToVector();
        var objPos = gp.gpToVector();

        if(playerPos.distance(objPos)<10){
            cl.lastEvent = events.allowInteract;
            orderListener(cl);
        }
        
    }


    function orderListener(cl:CollisionsListener){
        if (cl.lastEvent!=null)
            cl.lastEvent.send(cl);
    }
}