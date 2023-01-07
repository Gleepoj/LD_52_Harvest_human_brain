package aleiiioa.systems.logic;

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
    var ALL_GRAPPLE :View<GridPosition,GrappleComponent>;
    var ALL_CATCHABLE:View<CatchableFlag,InteractiveComponent>;
    var lastActionX:Bool = false;
    var grapplePower:Float = 2.75;
    var rewind:Float = 0.05;

    public function new() {
        UIBuilders.slider("GrapplePower",function() return  grapplePower, function(v)  grapplePower = v, 0.5,5);
        UIBuilders.slider("RewindPower",function() return  rewind, function(v)  rewind = v, 0.05,0.9);
    }

    @u function grappleUpdate(en:echoes.Entity,gr:GrappleComponent,dpc:DynamicBodyComponent,mpos:MasterGridPosition,cl:CollisionsListener,vas:VelocityAnalogSpeed,inp:InputComponent){
        
        dpc.seek(mpos.gpToVector(),0.1 + gr.load);
        dpc.arrival(mpos.gpToVector());
       
        if(lastActionX != inp.ca.isDown(ActionX)){
            if(!inp.ca.isDown(ActionX) && !cl.cd.has("grapple_is_launch")){
                cl.cd.setS("grapple_is_launch",0.1);
                
                //gr.load = 0;

            }
        }

        if(cl.cd.has("grapple_is_launch")){
            
            dpc.addForce(new Vector(0,gr.load*grapplePower));
            
            if(gr.load >0)
                gr.load -= rewind/10;
            
        }

        
        if(cl.cd.has("grapple_is_launch") && inp.ca.isPressed(ActionX)){
            cl.cd.unset("grapple_is_launch");
            cl.cd.setS("rewind",1);
           // trace("rewind");
        }

        if(cl.cd.has("rewind")){
       /*      gpos.oyr -= 0.3 ;
            if(gpos.oyr <= 1){
                gpos.oyr =1;
                cl.cd.unset("rewind");
            } */

        }

        if(inp.ca.isDown(ActionX)){
            
            if(gr.load < gr.maxLoad){
                gr.load += 0.05;
                //trace("charge");
            }
        }

        if(gr.load > gr.maxLoad){
            gr.load = gr.maxLoad;
            //trace("max load");
        }
        
        lastActionX = inp.ca.isDown(ActionX);

    }

    @u function updateInteractCooldown(dt:Float,ic:InteractiveComponent) {
        ic.cd.update(dt);
    }

    @u function playerGrabObject(gr:GrappleComponent,cl:CollisionsListener,inp:InputComponent,ac:ActionComponent) {
        if(cl.onInteract && inp.ca.isPressed(ActionX)){
            ac.query = true;
        }
    }


    @u function playerThrowCatchable(gr:GrappleComponent,inp:InputComponent,ac:ActionComponent,vc:VelocityComponent){
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
        en.get(VelocityAnalogSpeed).xSpeed = vc.dx * 20;
        en.get(VelocityAnalogSpeed).ySpeed = -2;
    }

}