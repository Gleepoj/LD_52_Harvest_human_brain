package aleiiioa.systems.logic;


import aleiiioa.components.logic.LauncherBodyComponent;
import aleiiioa.builders.UIBuilders;
import aleiiioa.components.logic.ActionComponent;
import aleiiioa.components.core.velocity.VelocityAnalogSpeed;
import h3d.Vector;
import aleiiioa.components.core.collision.CollisionsListener;
import aleiiioa.components.core.velocity.DynamicBodyComponent;
import aleiiioa.components.core.position.TargetGridPosition;
import aleiiioa.components.tools.GrappleStatusData;
import aleiiioa.components.core.rendering.SpriteComponent;
import aleiiioa.components.core.InputComponent;
import aleiiioa.components.core.rendering.DebugLabel;
import aleiiioa.components.tools.LauncherFSM;

class LauncherLogicSystem extends echoes.System {
    //Shared State component

    var launcher_currentState:Launcher_State;
    var droneLoad :Float;
    var grabState :Bool;
    var autoRecall:Bool = false;
    
    // Launcher parameter
    var launcherDamping :Float = 0.;
  

    // Drone Parameter

    var recallSpeed  :Float = 3.4;
    var expulseSpeed :Float = 3.4;
    var slowdown     :Float = 0.99;
    var grapplePower :Float = 2.3;// grapple launch speed
    var loadSpeed    :Float = 0.08;
    
    ////shared drone load 

    var droneBoost  :Float = 0.002;
    var droneMaxLoad:Float = 3.;
    


    public function new() {
          
    }


    @a function onGrappleAdded(en:echoes.Entity,gr:GrappleStatusData,spr:SpriteComponent){
        spr.set(Assets.drone);
        spr.anim.registerStateAnim(AssetsDictionaries.anim_drone.fly_open,1,3,()->gr.state == Expulse);
        spr.anim.registerStateAnim(AssetsDictionaries.anim_drone.fly_close,1,3,()->gr.state == Free);
        spr.anim.registerStateAnim(AssetsDictionaries.anim_drone.fly_release,1,3);
    }

    @a function onLauncherAdded(en:echoes.Entity,launcher:LauncherFSM,spr:SpriteComponent){ 
        spr.set(Assets.launcher);
        spr.anim.registerStateAnim(AssetsDictionaries.anim_launcher.free,    1,()->launcher.currentState == Free);
        spr.anim.registerStateAnim(AssetsDictionaries.anim_launcher.loaded,  1,()->launcher.currentState == Loaded);
        spr.anim.registerStateAnim(AssetsDictionaries.anim_launcher.charging,1,()->launcher.currentState == Charging);
        spr.anim.registerStateAnim(AssetsDictionaries.anim_launcher.charged, 1,()->launcher.currentState == Charged);
        spr.anim.registerStateAnim(AssetsDictionaries.anim_launcher.expulse, 1,()->launcher.currentState == Expulse);
    }

    @u function launcherPhysics(launcher:LauncherBodyComponent,fsm:LauncherFSM,vas:VelocityAnalogSpeed,spr:SpriteComponent,inp:InputComponent){
        
        launcher.computePendulum();

        launcher.linearDamping = launcherDamping;
        //easing drone dock ()
        if(fsm.cd.has("onDock")){
            launcher.accel += (droneLoad*droneBoost);
        }

        if(inp.ca.isDown(MoveRight) && launcher.xSpeed <= launcher.maxSpeed){
            launcher.xSpeed += launcher.accel;
        }

        if(inp.ca.isDown(MoveLeft)  && launcher.xSpeed <= launcher.maxSpeed){
            launcher.xSpeed += launcher.accel;
        }

        if(launcher.xSpeed > launcher.maxSpeed && !fsm.cd.has("onDock")){
            launcher.xSpeed = launcher.maxSpeed;
        }

        launcher.xSpeed *= launcher.linearDamping;
        vas.xSpeed = launcher.xSpeed * launcher.direction;
        spr.rotation =  launcher.angle;
        launcherDamping = launcher.initialDamping;
    }
  
    @u function inputLauncherStateMachine(dt:Float,launcher:LauncherFSM,input:InputComponent,label:DebugLabel,cl:CollisionsListener){
        launcher.cd.update(dt);

        if(autoRecall == true && launcher.currentState == Expulse)
            launcher.next(Free);

        if(!input.ca.isDown(ActionX)){
            launcher.next(Expulse);
        }

        if(launcher.currentState == Free && cl.onDroneInteractLauncher ){
            launcher.next(Loaded);
            launcher.cd.setS("onDock",0.002);
        }

        if(launcher.currentState == Loaded && input.ca.isDown(ActionX) && grabState == false){
            launcher.next(Charging);
            launcher.cd.unset("onDock");
        }

        if(launcher.currentState == Charging && droneLoad >= droneMaxLoad && grabState == false)
            launcher.next(Charged);
        
        if(launcher.currentState != Loaded)
            launcher.cd.unset("onDock");

        launcher.debugLabelUpdate(label);
        launcher_currentState = launcher.currentState;
    }
    
    @u function synchronizeState(en:echoes.Entity,dt:Float,gr:GrappleStatusData,dpc:DynamicBodyComponent,lab:DebugLabel,tgp:TargetGridPosition){
        gr.cd.update(dt);
        gr.set_synchronized_state(launcher_currentState);
        
        lab.v = M.pretty(droneLoad,1);
        droneLoad = gr.load;
    }
    

    @u function droneLogic(en:echoes.Entity,gr:GrappleStatusData,cl:CollisionsListener,ac:ActionComponent,input:InputComponent){
        switch gr.state {
            case Free:
                gr.load = 0;
                autoRecall = true;
            case Loaded: 
                autoRecall = false;    
            case Charging:
                if(gr.load < droneMaxLoad)
                    gr.load += loadSpeed;
                launcherDamping = 0.5;
            case Charged:
                if(gr.load < droneMaxLoad)
                    gr.load += loadSpeed*0.9;
                launcherDamping = 0;
            case Expulse:
                if(gr.load >= 0)
                    gr.load *= slowdown;
                if(cl.onHitHorizontal)
                    autoRecall = true;                    
                if(gr.load <= 0.2)
                    autoRecall = true;
        } 

        if(gr.load > droneMaxLoad)
            gr.load = droneMaxLoad;
        
        if(gr.load < 0)
            gr.load = 0;
      
        grabState = gr.onGrab;
        gr.grab_state = ac.grab;
    }
    
    @u function dronePhysics(en:echoes.Entity,gr:GrappleStatusData,tpos:TargetGridPosition,dpc:DynamicBodyComponent){
        
       dpc.target = tpos.gpToVector();
        
       switch gr.state {
            case Free:
                dpc.seek(tpos.gpToVector(),recallSpeed);
                dpc.arrival(tpos.gpToVector());
            case Loaded:
                dpc.stick(tpos.gpToVector());
            case Charging:
                dpc.stick(tpos.gpToVector());
            case Charged:
                dpc.stick(tpos.gpToVector());
            case Expulse:    
                dpc.seek(tpos.gpToVector(),expulseSpeed+(gr.load*0.75));
                dpc.arrival(tpos.gpToVector());
                dpc.addForce(new Vector(0,(gr.load*grapplePower)*0.5));
        } 
        
    }
}