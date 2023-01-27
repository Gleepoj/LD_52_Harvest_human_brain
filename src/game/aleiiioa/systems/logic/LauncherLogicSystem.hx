package aleiiioa.systems.logic;

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
        spr.anim.registerStateAnim(AssetsDictionaries.anim_launcher.idle,1,  ()->launcher.currentState == Idle);
        spr.anim.registerStateAnim(AssetsDictionaries.anim_launcher.recall,1,()->launcher.currentState == Recall);
        spr.anim.registerStateAnim(AssetsDictionaries.anim_launcher.home,1,()->launcher.currentState == Docked);
        spr.anim.registerStateAnim(AssetsDictionaries.anim_launcher.load,1,()->launcher.currentState == Loaded);

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
    @u function setAutoRecall(en:echoes.Entity,gr:GrappleFSM,cl:CollisionsListener){
        if(gr.state == Expulse && cl.onHitHorizontal)
            autoRecall = true;

        if(gr.state == Recall)
            autoRecall = false;
    }
  
    @u function inputStateMachine(dt:Float,launcher:LauncherFSM,input:InputComponent,label:DebugLabel,cl:CollisionsListener){
        launcher.cd.update(dt);

        if(input.ca.isDown(ActionX) || autoRecall){
            launcher.next(Recall);
        }

        if(!input.ca.isDown(ActionX)){
            launcher.next(Idle);
            launcher.next(Expulse);
        }

        if(launcher.currentState == Recall && cl.onDroneInteractLauncher )
            launcher.next(Docked);

        if(launcher.currentState == Docked && droneLoad >= 1.)
            launcher.next(Loaded);
        
        
        
        launcher.switchToRegisteredTransition();
        launcher.debugLabelUpdate(label);
        launcher_currentState = launcher.currentState;
    }
    
    @u function synchronizeState(en:echoes.Entity,gr:GrappleFSM,dpc:DynamicBodyComponent,lab:DebugLabel,tgp:TargetGridPosition){
        
        gr.set_synchronized_state(launcher_currentState);
        lab.v = autoRecall; //dpc.euler.toString();
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
                dpc.seek(tpos.gpToVector(),2.2);
                dpc.arrival(tpos.gpToVector());
            case Docked:
                dpc.stick(tpos.gpToVector());
                if(gr.load < gr.maxLoad)
                    gr.load += 0.05;
            case Loaded:
                dpc.stick(tpos.gpToVector());
            case Expulse:
                if(gr.load >= 0)
                    gr.load -= rewind/7;
                
                
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