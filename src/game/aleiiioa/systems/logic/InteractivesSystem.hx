package aleiiioa.systems.logic;

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
    var ALL_CATCHABLE:View<CatchableFlag,InteractiveComponent>;
    var lastActionX:Bool = false;
    
    public function new() {
        
    }

    @u function grappleUpdate(en:echoes.Entity,gr:GrappleComponent,cl:CollisionsListener,vas:VelocityAnalogSpeed, gpos:GridPositionOffset,inp:InputComponent){
        
        if(lastActionX != inp.ca.isDown(ActionX)){
            if(!inp.ca.isDown(ActionX) && !cl.cd.has("grapple_is_launch") && !cl.cd.has("rewind")){
                cl.cd.setS("grapple_is_launch",0.1);
                gr.load = 0;
                
            }
        }

        if(cl.cd.has("grapple_is_launch")){
            gpos.oyr += 0.2 ;
        }

        
        if(cl.cd.has("grapple_is_launch") && inp.ca.isPressed(ActionX)){
            cl.cd.unset("grapple_is_launch");
            cl.cd.setS("rewind",1);
           // trace("rewind");
        }

        if(cl.cd.has("rewind")){
            gpos.oyr -= 0.3 ;
            if(gpos.oyr <= 1){
                gpos.oyr =1;
                cl.cd.unset("rewind");
            }

        }

        if(inp.ca.isDown(ActionX)){
            
            if(gr.load < gr.maxLoad){
                gr.load += 0.05;
               
            }
        }

        if(gr.load > gr.maxLoad){
            gr.load = gr.maxLoad;
           // trace("max load");
        }
        
        lastActionX = inp.ca.isDown(ActionX);

    }

    @u function updateInteractCooldown(dt:Float,ic:InteractiveComponent) {
        ic.cd.update(dt);
    }

    @u function playerGrabObject(pl:PlayerFlag,cl:CollisionsListener,inp:InputComponent,ac:ActionComponent) {
        if(cl.onInteract && inp.ca.isPressed(ActionX)){
            ac.query = true;
        }
    }


    @u function playerThrowCatchable(pl:PlayerFlag,inp:InputComponent,ac:ActionComponent,vc:VelocityComponent){
        if(ac.grab && inp.ca.isPressed(ActionX)){
            var head = ALL_CATCHABLE.entities.head;

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
            var head = ALL_PLAYERS.entities.head;
    
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
    

    function linkObject(en:echoes.Entity,mgp:MasterGridPosition) {
        en.add(new GridPositionOffset(0,-1));
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
        en.get(VelocityAnalogSpeed).xSpeed = vc.dx * 20;
        en.get(VelocityAnalogSpeed).ySpeed = -2;
    }

}