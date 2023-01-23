package aleiiioa.systems.logic;

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
    var rewind:Float = 0.05;
    var grapplePower:Float = 3.;

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
        //spr.anim.registerStateAnim(AssetsDictionaries.anim_launcher.docked,1);

    }
  
    @u function inputStateMachine(dt:Float,launcher:LauncherFSM,input:InputComponent,label:DebugLabel){
        launcher.cd.update(dt);
        
        if(input.ca.isDown(ActionY)){
            launcher.next(Recall);
        }

        if(!input.ca.isDown(ActionY)){
            launcher.next(Idle);
        }

        if(input.ca.isPressed(ActionX)){
          /*   if(launcher.currentState == Recall)
                launcher.next(Docked);

            if(launcher.currentState == Docked)
                launcher.next(Loaded); */
        }

        launcher.switchToRegisteredTransition();
        launcher.debugLabelUpdate(label);
        launcher_currentState = launcher.currentState;
    }
    
    @u function synchronizeState(en:echoes.Entity,gr:GrappleFSM,spr:SpriteComponent){
        gr.set_synchronized_state(launcher_currentState);
    }


    @u function dronePhysics(en:echoes.Entity,gr:GrappleFSM,tpos:TargetGridPosition,dpc:DynamicBodyComponent,cl:CollisionsListener,inp:InputComponent){
        
        switch gr.state {
            case Idle:
                dpc.seek(tpos.gpToVector(),0.6);
                dpc.arrival(tpos.gpToVector());
            case Recall:
                dpc.seek(tpos.gpToVector(),2);
                dpc.arrival(tpos.gpToVector());
            case Docked:
                dpc.seek(tpos.gpToVector(),0.4+gr.load);
                dpc.arrival(tpos.gpToVector());
                if(gr.load < gr.maxLoad){
                    gr.load += 0.05;
                    gr.bonus = 0.;
                }
            case Loaded:
            case Expulse:
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
}