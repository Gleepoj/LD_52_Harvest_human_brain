package aleiiioa.systems.logic;

import aleiiioa.components.logic.ActionComponent;
import aleiiioa.components.core.velocity.VelocityAnalogSpeed;
import h3d.Vector;
import aleiiioa.components.core.collision.CollisionsListener;
import aleiiioa.components.core.velocity.DynamicBodyComponent;
import aleiiioa.components.core.position.TargetGridPosition;
import aleiiioa.components.tools.GrappleFSM;
import aleiiioa.components.core.rendering.SpriteComponent;
import aleiiioa.components.core.InputComponent;
import aleiiioa.components.core.rendering.DebugLabel;
import aleiiioa.components.tools.LauncherFSM;

class LauncherLogicSystem extends echoes.System {
    var launcher_currentState:Launcher_State;
    var droneLoad:Float;
    var rewind:Float = 0.05;
    var grapplePower:Float = 3.;
    var grabState:Bool;
    var debug:Float =0.;
    var autoRecall:Bool = false;

    public function new() {
    
    }

    @a function onGrappleAdded(en:echoes.Entity,gr:GrappleFSM,spr:SpriteComponent){
        
        spr.set(Assets.drone);
        spr.anim.registerStateAnim(AssetsDictionaries.anim_drone.fly_open,1,3,()->gr.state == Idle);
        spr.anim.registerStateAnim(AssetsDictionaries.anim_drone.fly_close,1,3,()->gr.state == Recall);
        spr.anim.registerStateAnim(AssetsDictionaries.anim_drone.fly_release,1,3);

    }

    @a function onLauncherAdded(en:echoes.Entity,launcher:LauncherFSM,spr:SpriteComponent){
       
        spr.set(Assets.launcher);
        spr.anim.registerStateAnim(AssetsDictionaries.anim_launcher.idle,      1,()->launcher.currentState == Idle);
        spr.anim.registerStateAnim(AssetsDictionaries.anim_launcher.recall,    1,()->launcher.currentState == Recall);
        spr.anim.registerStateAnim(AssetsDictionaries.anim_launcher.dock_empty,1,()->launcher.currentState == Docked);
        spr.anim.registerStateAnim(AssetsDictionaries.anim_launcher.load,      1,()->launcher.currentState == Loaded);
        spr.anim.registerStateAnim(AssetsDictionaries.anim_launcher.expulse,   1,()->launcher.currentState == Expulse);

    }

    @u function launcherDirection(launcher:LauncherFSM,vas:VelocityAnalogSpeed,spr:SpriteComponent){
        
        var accel = 0.05;
        var moment = 0.06;

        if(launcher.cd.has("OnChangeDir")){
            //launcher.xSpeed *= -1;
            //launcher.angleOffset *= -1;
            //trace("changedir");
        }

        if(launcher.direction == 1 && launcher.xSpeed <=0.3){
            launcher.xSpeed += accel;
            launcher.angleOffset += moment;
        }

        if(launcher.direction == -1 && launcher.xSpeed >=-0.3){
            launcher.xSpeed -= accel;
            launcher.angleOffset -= moment;
        }

        vas.xSpeed = launcher.xSpeed;
        spr.rotation =  launcher.angleOffset;
        
    }
    @u function setAutoRecall(en:echoes.Entity,gr:GrappleFSM,cl:CollisionsListener,ac:ActionComponent,input:InputComponent){
        if(gr.state == Expulse && cl.onHitHorizontal)
            autoRecall = true;

        if(gr.state == Recall)
            autoRecall = false;

        
        if(input.ca.isDown(ActionX)){
            if(launcher_currentState == Docked){
                 if(gr.load < gr.maxLoad)
                    gr.load += 0.05;
            }

        }
        

        grabState = gr.onGrab;
        gr.grab_state = ac.grab;
    }
  
    @u function inputStateMachine(dt:Float,launcher:LauncherFSM,input:InputComponent,label:DebugLabel,cl:CollisionsListener){
        launcher.cd.update(dt);

        if(input.ca.isDown(ActionX) || autoRecall){
            launcher.next(Recall);
            //if(launcher.currentState == Docked)
        }

        if(!input.ca.isDown(ActionX)){
            //launcher.next(Idle);
            launcher.next(Expulse);
            
             
            //launcher.next(Loaded);
        }

        
        if(launcher.currentState == Recall && cl.onDroneInteractLauncher )
            launcher.next(Docked);

        if(launcher.currentState == Docked && droneLoad >= 1. && grabState == false)
            launcher.next(Loaded);
        
        
        
        //launcher.switchToRegisteredTransition();
        launcher.debugLabelUpdate(label);
        launcher_currentState = launcher.currentState;
    }
    
    @u function synchronizeState(en:echoes.Entity,dt:Float,gr:GrappleFSM,dpc:DynamicBodyComponent,lab:DebugLabel,tgp:TargetGridPosition){
        gr.cd.update(dt);
        gr.set_synchronized_state(launcher_currentState);
        
        lab.v = gr.onRelease;//gr.claw_state; //dpc.euler.toString();
        droneLoad = gr.load;
    }


    @u function dronePhysics(en:echoes.Entity,gr:GrappleFSM,tpos:TargetGridPosition,dpc:DynamicBodyComponent,cl:CollisionsListener,inp:InputComponent){
        
        dpc.target = tpos.gpToVector();
        switch gr.state {
            case Idle:
                gr.load = 0;
                if(!cl.onDroneInteractLauncher){
                    dpc.seek(tpos.gpToVector(),1.11);
                    dpc.arrival(tpos.gpToVector());
                }
            case Recall:
                gr.load = 0;
                //gr.lock();
                dpc.seek(tpos.gpToVector(),2.2);
                dpc.arrival(tpos.gpToVector());
            case Docked:
                dpc.stick(tpos.gpToVector());
                //if(gr.load < gr.maxLoad)
                 //   gr.load += 0.05;
            case Loaded:
                //gr.released();
                dpc.stick(tpos.gpToVector());
            case Expulse:
                if(gr.load >= 0)
                    gr.load -= rewind/7;
                //gr.released();
                dpc.seek(tpos.gpToVector(),1.8+(gr.load*0.75));
                dpc.arrival(tpos.gpToVector());
                dpc.addForce(new Vector(0,(gr.load*grapplePower)*0.5));
        }

        
        if(gr.load > gr.maxLoad)
            gr.load = gr.maxLoad;
        
        if(gr.load < 0)
            gr.load = 0;
        
    }
}