package aleiiioa.systems.logic;

import aleiiioa.components.tools.GrappleStatusData;
import aleiiioa.systems.collisions.CollisionEvent.Event_OnContact;
import aleiiioa.components.tools.GrappleStatusData;
import aleiiioa.components.core.rendering.SpriteComponent;
import aleiiioa.builders.UIBuilders;
import h3d.Vector;
import echoes.Entity;
import echoes.View;

import aleiiioa.components.logic.*;
import aleiiioa.components.flags.hierarchy.*;
import aleiiioa.components.flags.logic.*;

import aleiiioa.components.core.InputComponent;
import aleiiioa.components.core.collision.CollisionsListener;
import aleiiioa.components.core.position.*;
import aleiiioa.components.core.velocity.*;

class InteractivesSystem extends echoes.System {
    
    var ALL_PLAYERS :View<GridPosition,PlayerFlag>;
    var ALL_GRAPPLE :View<GridPosition,GrappleStatusData>;
    var ALL_CATCHABLE:View<CatchableFlag,InteractiveComponent>;
    var lastActionX:Bool = false;
    var diedWithoutUnlink:Bool = false;
    

    public function new() {
    }


    @u function updateInteractCooldown(dt:Float,ic:InteractiveComponent) {
        ic.cd.update(dt);
    }

    @u function grappleGrabObject(gr:GrappleStatusData,cl:CollisionsListener,inp:InputComponent,ac:ActionComponent) {
        if(cl.onContact && inp.ca.isPressed(ActionX)){
            ac.query = true;
        }
    }


    @u function releaseCatchable(gr:GrappleStatusData,inp:InputComponent,ac:ActionComponent,vc:VelocityComponent,cl:CollisionsListener){
        //if(ac.grab && !en.exists())
        if(diedWithoutUnlink){
            diedWithoutUnlink = false;
            ac.grab = false;
        }
        
        if(ac.grab && !inp.ca.isDown(ActionX)){
            ac.grab = false;
            gr.load = 0;
            
            var head = ALL_CATCHABLE.entities.head;
            cl.cd.setS("has_drop",0.001);

            while (head != null){
                var catchable = head.value;
                var catchableIc = catchable.get(InteractiveComponent);
                if(catchableIc.isGrabbed){
                    unlinkObject(catchable);
                    throwObject(catchable,vc);
                }
                head = head.next;
            }
        }
    }

    @u function catchableIsGrabbedByPlayer(en:echoes.Entity,catchable:CatchableFlag,cl:CollisionsListener) {

        if(cl.onInteract){
            var head = ALL_GRAPPLE.entities.head;
            while (head != null){
                var player = head.value;
                var playerAc:ActionComponent  = player.get(ActionComponent);

                if(playerAc.query){  
                    var mgp = player.get(MasterGridPosition);
                    linkObject(en,mgp);
                    playerAc.grab = true;
                    playerAc.query= false;
                }
                head = head.next;
            }
        }
    }
    
    @r function onRemoveGrabbedGilles(en:echoes.Entity,catchable:CatchableFlag,g:BonhommeComponent){
        if(en.exists(ChildFlag)){
            diedWithoutUnlink = true;
        }
    }

    function linkObject(en:echoes.Entity,mgp:MasterGridPosition) {
        en.add(new GridPositionOffset(0,1));
        en.add(mgp);
        en.add(new ChildFlag());
        en.get(InteractiveComponent).isGrabbed = true;           
    }

    function unlinkObject(en:echoes.Entity) {
        en.get(InteractiveComponent).isGrabbed = false;
        en.remove(MasterGridPosition);
        en.remove(GridPositionOffset);
        en.remove(ChildFlag);
    }

    function throwObject(en:echoes.Entity,vc:VelocityComponent){ 
        en.get(VelocityAnalogSpeed).xSpeed = 0;
        en.get(VelocityAnalogSpeed).ySpeed = 0;
    }

}