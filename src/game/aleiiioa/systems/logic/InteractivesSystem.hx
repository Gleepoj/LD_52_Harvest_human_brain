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
    var grapplePower:Float = 3;
    var rewind:Float = 0.05;
    var lastState:GrappleState;
    var lastHome:Bool;

    public function new() {
        UIBuilders.slider("GrapplePower",function() return  grapplePower, function(v)  grapplePower = v, 0.5,5);
        UIBuilders.slider("RewindPower",function() return  rewind, function(v)  rewind = v, 0.05,0.9);
    }
   
    @u function grappleStateAction(en:echoes.Entity,gr:GrappleComponent,tpos:TargetGridPosition,dpc:DynamicBodyComponent,cl:CollisionsListener,inp:InputComponent){
        
        if(gr.state == Idle){
            dpc.seek(tpos.gpToVector(),0.3);
            dpc.arrival(tpos.gpToVector());
        }
        if(gr.state == Launch){
            dpc.seek(tpos.gpToVector(),0.3+gr.load);
            dpc.arrival(tpos.gpToVector());
            dpc.addForce(new Vector(0,gr.load*grapplePower));
            
            if(gr.load >0)
                gr.load -= rewind/10;
            //if load == 0 => rewind 
        }

        if(gr.state == Rewind){
            dpc.seek(tpos.gpToVector(),0.4);
            dpc.arrival(tpos.gpToVector());
        }

        if(gr.state == Charge){
            dpc.seek(tpos.gpToVector(),0.4+gr.load);
            dpc.arrival(tpos.gpToVector());
            if(gr.load < gr.maxLoad){
                gr.load += 0.05;
                //trace("charge");
            }
        }

        if(gr.state == Autorewind){
            dpc.seek(tpos.gpToVector(),1.2);
            dpc.arrival(tpos.gpToVector());
        }

        if(gr.load > gr.maxLoad){
            gr.load = gr.maxLoad;
            //trace("ok max load");
        }
        
    }

    @u function grappleCommand(en:echoes.Entity,ac:ActionComponent,gr:GrappleComponent,dpc:DynamicBodyComponent,tpos:TargetGridPosition,cl:CollisionsListener,vas:VelocityAnalogSpeed,inp:InputComponent){
        gr.home = false;
        
        if(dpc.location.distance(tpos.gpToVector())<20)
            gr.home = true;
        
        if(lastHome != gr.home){
           /*  if(gr.home == false)
                trace("left home");

            if(gr.home == true)
                trace("homing"); */
        }
        
        lastHome  = gr.home;
        lastState = gr.state;

        
        if(!inp.ca.isDown(ActionX)){
            if(gr.home == true && gr.state != Launch)
                gr.state = Idle;
            
            if(lastActionX != inp.ca.isDown(ActionX))
                if(gr.home == true)
                    gr.state = Launch;
        }

        if(inp.ca.isDown(ActionX)){
            gr.state = Charge;
        }

        if(gr.state == Launch && gr.load <= 0 ){
            gr.state = Rewind;
        }

      /*   if(lastActionX != inp.ca.isDown(ActionX)){
            gr.state = Launch;
        } */

      /*   if(lastActionX != inp.ca.isDown(ActionX)){
            if(!inp.ca.isDown(ActionX) && !cl.cd.has("grapple_is_launch")){
                cl.cd.setS("grapple_is_launch",0.1);
                gr.state = Launch;
            }
        }
      
        if(gr.state == Launch && gr.load <= 0 ){
            gr.state = Rewind;
        }

        if(gr.state == Launch && inp.ca.isPressed(ActionX)){
            cl.cd.unset("grapple_is_launch");
            gr.state = Rewind;
        }
        
        if(gr.state == Launch && cl.onGround){
            gr.state = Autorewind;
        } */

        if(gr.load > gr.maxLoad){
            gr.load = gr.maxLoad;
            //trace("max load");
        }
        
        lastActionX = inp.ca.isDown(ActionX);
        
        if(lastState != gr.state){
            var s = gr.state;
            //
            //trace('State : $s');
        }
    }

    @u function updateInteractCooldown(dt:Float,ic:InteractiveComponent) {
        ic.cd.update(dt);
    }

    @u function playerGrabObject(gr:GrappleComponent,cl:CollisionsListener,inp:InputComponent,ac:ActionComponent) {
        if(cl.onInteract && inp.ca.isPressed(ActionX)){
            ac.query = true;
        }
    }


    @u function playerThrowCatchable(gr:GrappleComponent,inp:InputComponent,ac:ActionComponent,vc:VelocityComponent,cl:CollisionsListener){
        if(ac.grab && !inp.ca.isDown(ActionX)){
           
            ac.grab = false;
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