package aleiiioa.systems.logic;

import aleiiioa.components.tools.GrappleFSM;
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
    var ALL_GRAPPLE :View<GridPosition,GrappleFSM>;
    var ALL_CATCHABLE:View<CatchableFlag,InteractiveComponent>;
    var lastActionX:Bool = false;
    var diedWithoutUnlink:Bool = false;
    

    public function new() {
        //UIBuilders.slider("GrapplePower",function() return  grapplePower, function(v)  grapplePower = v, 0.5,5);
        //UIBuilders.slider("RewindPower",function() return  rewind, function(v)  rewind = v, 0.05,0.9);
    }


    @u function updateInteractCooldown(dt:Float,ic:InteractiveComponent) {
        ic.cd.update(dt);
    }

    @u function playerGrabObject(gr:GrappleFSM,cl:CollisionsListener,inp:InputComponent,ac:ActionComponent) {
        if(cl.onInteract && inp.ca.isPressed(ActionX)){
            ac.query = true;
        }
    }


    @u function playerThrowCatchable(gr:GrappleFSM,inp:InputComponent,ac:ActionComponent,vc:VelocityComponent,cl:CollisionsListener){
        //if(ac.grab && !en.exists())
        if(diedWithoutUnlink){
            diedWithoutUnlink = false;
            ac.grab = false;
        }
        
        if(ac.grab && !inp.ca.isDown(ActionX)){
            ac.grab = false;
            //trace("release gille");
            //trace(gr.state);
            var head = ALL_CATCHABLE.entities.head;
            gr.load = 0 ;
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
    
    @r function onRemoveGrabbedGilles(en:echoes.Entity,catchable:CatchableFlag,g:GilleFlag){
        if(en.exists(ChildFlag)){
            //trace("Died without unlink");
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