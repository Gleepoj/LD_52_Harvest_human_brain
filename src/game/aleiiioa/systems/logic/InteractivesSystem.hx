package aleiiioa.systems.logic;

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
    var ALL_GRAPPLE :View<GridPosition,GrappleComponent>;
    var ALL_CATCHABLE:View<CatchableFlag,InteractiveComponent>;
    var lastActionX:Bool = false;
    var grapplePower:Float = 3;
    var rewind:Float = 0.05;
    var droneLastState:GrappleState;
    var droneIsDocked:Bool = false;
    var droneIsReleased:Bool = false;
    var lastHome:Bool;
    

    public function new() {
        UIBuilders.slider("GrapplePower",function() return  grapplePower, function(v)  grapplePower = v, 0.5,5);
        UIBuilders.slider("RewindPower",function() return  rewind, function(v)  rewind = v, 0.05,0.9);
    }

    @a function onLauncherAdded(en:echoes.Entity,pl:PlayerFlag,spr:SpriteComponent){
        spr.set(Assets.launcher);
        spr.anim.registerStateAnim(AssetsDictionaries.anim_launcher.idle,1);
        spr.anim.registerStateAnim(AssetsDictionaries.anim_launcher.recall,1);
        spr.anim.registerStateAnim(AssetsDictionaries.anim_launcher.home,1);
        spr.anim.registerStateAnim(AssetsDictionaries.anim_launcher.load,1);
        spr.anim.registerStateAnim(AssetsDictionaries.anim_launcher.docked,1);
    }

    @a function onGrappleAdded(en:echoes.Entity,gr:GrappleComponent,spr:SpriteComponent){
        spr.set(Assets.drone);
        spr.anim.registerStateAnim(AssetsDictionaries.anim_drone.fly_open,1,3);
        spr.anim.registerStateAnim(AssetsDictionaries.anim_drone.fly_close,1,3);
        spr.anim.registerStateAnim(AssetsDictionaries.anim_drone.fly_release,1,3);
        //spr.anim.registerStateAnim(AssetsDictionaries.anim_drone.grab,1);
        //spr.anim.registerStateAnim(AssetsDictionaries.anim_drone.docked,1);
        //spr.anim.registerStateAnim(AssetsDictionaries.anim_drone.load,1,1);
        //spr.anim.registerStateAnim(AssetsDictionaries.anim_drone.release,1);
        
    }

    @u function launcherState(en:echoes.Entity,inp:InputComponent,launch:LauncherComponent){
        if(!inp.ca.isDown(ActionX)){
            launch.state = Idle;
            if(droneIsReleased){
                launch.state = Expulse;
            }
        }
        if(inp.ca.isDown(ActionX)){
            if(lastHome == true && droneLastState == Charge){
                if(!droneIsDocked)
                    launch.state = Load;
                if(droneIsDocked)
                    launch.state = Docked;
            }
            if(lastHome == false){
                launch.state = Recall;
            }

        }
    }
    
    @u function launcherAnim(en:echoes.Entity,pl:PlayerFlag,spr:SpriteComponent,launch:LauncherComponent){
        if(launch.state == Idle){
            spr.anim.play(AssetsDictionaries.anim_launcher.idle);
        }
           
        if(launch.state == Load){
            spr.anim.play(AssetsDictionaries.anim_launcher.load);
            spr.anim.stopOnLastFrame();
        }
        
        if(launch.state == Docked){
            spr.anim.play(AssetsDictionaries.anim_launcher.docked);
        }
        
        if(launch.state == Recall){
            spr.anim.play(AssetsDictionaries.anim_launcher.recall);
        }
        
        if(launch.state == Expulse){
            spr.anim.play(AssetsDictionaries.anim_launcher.home);
        }

    }

    @u function grappleStateAnim(en:echoes.Entity,gr:GrappleComponent,tpos:TargetGridPosition,spr:SpriteComponent,ac:ActionComponent){
        var stateChange:Bool = gr.state != droneLastState; 

        if(stateChange){
            if(gr.state == Idle){
                spr.anim.playAndLoop(AssetsDictionaries.anim_drone.fly_release);
            }
            if(gr.state == Launch){
                spr.anim.playAndLoop(AssetsDictionaries.anim_drone.fly_open);
            }

            if(gr.state == Rewind){
                if(ac.grab == true)
                    spr.anim.playAndLoop(AssetsDictionaries.anim_drone.fly_close);
                
                if(ac.grab == false)
                    spr.anim.playAndLoop(AssetsDictionaries.anim_drone.fly_release);
            }

            if(gr.state == Charge){
                spr.anim.play(AssetsDictionaries.anim_drone.load);
                spr.anim.stopOnLastFrame();
            }

            if(gr.state == Autorewind){
                /* if(ac.grab == true)
                    spr.anim.play(AssetsDictionaries.anim_drone.fly_close);
        
                if(ac.grab == false)
                    spr.anim.play(AssetsDictionaries.anim_drone.fly_release);
                */       
            }

            if(gr.load > gr.maxLoad){
            
            }
        }
        
    }
    
    @u function grappleStateAction(en:echoes.Entity,gr:GrappleComponent,tpos:TargetGridPosition,dpc:DynamicBodyComponent,cl:CollisionsListener,inp:InputComponent){
        
        if(gr.state == Idle){
            dpc.seek(tpos.gpToVector(),0.8);
            dpc.arrival(tpos.gpToVector());
        }

        if(gr.state == Rewind){
            dpc.seek(tpos.gpToVector(),1.4);
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

        if(gr.state == Launch){
           
            
            dpc.seek(tpos.gpToVector(),0.3+gr.load);
            dpc.arrival(tpos.gpToVector());
            dpc.addForce(new Vector(0,gr.load*grapplePower));
            
            if(gr.load >0)
                gr.load -= rewind/10;
            
        }

        if(gr.load > gr.maxLoad){
            gr.load = gr.maxLoad;
            //trace("ok max load");
        }
        
    }

    @u function grappleCommand(en:echoes.Entity,ac:ActionComponent,gr:GrappleComponent,dpc:DynamicBodyComponent,tpos:TargetGridPosition,cl:CollisionsListener,vas:VelocityAnalogSpeed,inp:InputComponent){
        gr.home = false;
        droneIsDocked = false;
        droneIsReleased = false;
        
        if(dpc.location.distance(tpos.gpToVector())<20)
            gr.home = true;
        
        lastHome  = gr.home;
        droneLastState = gr.state;

        if(lastHome != gr.home){
  
        }
        


        
        if(!inp.ca.isDown(ActionX)){
            if(gr.home == false && gr.state != Launch)
                gr.state = Idle;
            
            if(lastActionX != inp.ca.isDown(ActionX)){
                if(gr.state == Charge){
                    gr.state = Launch;
                    droneIsReleased = true;
                }
            }
        }

        if(inp.ca.isDown(ActionX) && gr.home && !ac.grab){
            gr.state = Charge;
        }

        if(inp.ca.isDown(ActionX) && !gr.home){
            gr.state = Rewind;
        }

        if(gr.state == Launch && gr.load <= 0 ){
            gr.state = Idle;
        }

        if(gr.load >= gr.maxLoad){
            gr.load = gr.maxLoad;
            droneIsDocked = true;
        }
        
        lastActionX = inp.ca.isDown(ActionX);
        
        if(droneLastState != gr.state){
            var s = gr.state;
           // trace('State : $s');
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
            trace("release gille");
            trace(gr.state);
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