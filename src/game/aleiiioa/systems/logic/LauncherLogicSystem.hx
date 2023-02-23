package aleiiioa.systems.logic;

import aleiiioa.components.flags.logic.FixedDebugLabel;
import aleiiioa.builders.UIBuilders;
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
    var grapplePower:Float = 6.;
    var grabState:Bool;
    var debug:Float =0.;
    var autoRecall:Bool = false;
    var ss = 0;

    var boost = 1.;
    
    var accel = 0.5;

    var len = 2.4;
    var gravity = 0.71;
    var damping = 0.79;

    var recallSpeed  = 3.4;
    var expulseSpeed = 3.4;

    var linearDamping = 0.91;
    var maxSpeed = 0.41;
    var loadSpeed = 0.08;

    var flabel = 0.;

    public function new() {
        #if debug
            UIBuilders.slider("accel",  function() return accel,   function(v) accel = v, 0.01,0.5);
            UIBuilders.slider("len",    function() return len,     function(v) len = v, 0.1,4);
            UIBuilders.slider("gravity",function() return gravity, function(v) gravity = v, 0.1,4);
            UIBuilders.slider("damping",function() return damping, function(v) damping = v, 0.1,4);     
            UIBuilders.slider("recall", function() return recallSpeed , function(v) recallSpeed = v, 2.2,5);
            UIBuilders.slider("expulse",function() return expulseSpeed, function(v) expulseSpeed = v, 1.8,5); 
            UIBuilders.slider("linearDamping",function()  return linearDamping, function(v) linearDamping = v, 0.800,0.999);    
            UIBuilders.slider("maxSpeed",     function()  return maxSpeed,      function(v) maxSpeed = v, 0.3,0.9);  
            UIBuilders.slider("grapplePower", function()  return grapplePower,  function(v) grapplePower = v, 2.,9.);  
            UIBuilders.slider("loadSpeed",    function()  return loadSpeed,     function(v) loadSpeed = v, 0.03,0.09);  
            UIBuilders.debugFloat(flabel,40,30);
        #end
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

    @u function launcherDirection(launcher:LauncherFSM,vas:VelocityAnalogSpeed,spr:SpriteComponent,inp:InputComponent){
        
        var sx = launcher.xSpeed * launcher.direction;

        launcher.acceleration = (-1*gravity/len)*Math.sin(launcher.angle) + (1*sx/len)*Math.cos(launcher.angle);
        launcher.velocity += launcher.acceleration ;
        launcher.velocity *= damping;
        launcher.angle    += launcher.velocity;

        if(launcher.cd.has("OnChangeDir")){
            boost = 1.5;
        }

        if(inp.ca.isDown(MoveRight) && launcher.xSpeed <=maxSpeed){
            launcher.xSpeed += accel;
        }

        if(inp.ca.isDown(MoveLeft)  && launcher.xSpeed <=maxSpeed){
            launcher.xSpeed += accel;
        }

        if(launcher.xSpeed > maxSpeed){
            launcher.xSpeed = maxSpeed;
        }

        launcher.xSpeed *= linearDamping;
        flabel = M.pretty(launcher.xSpeed,2);
        vas.xSpeed = launcher.xSpeed * launcher.direction;
        spr.rotation =  launcher.angle;
        
    }

    @u function setAutoRecall(en:echoes.Entity,gr:GrappleFSM,cl:CollisionsListener,ac:ActionComponent,input:InputComponent){
        if(gr.state == Expulse && cl.onHitHorizontal)
            autoRecall = true;

        if(gr.state == Recall)
            autoRecall = false;
  
        if(input.ca.isDown(ActionX)){
            if(launcher_currentState == Docked){
                 if(gr.load < gr.maxLoad)
                    gr.load += loadSpeed;
            }
        }

        grabState = gr.onGrab;
        gr.grab_state = ac.grab;
    }
  
    @u function inputStateMachine(dt:Float,launcher:LauncherFSM,input:InputComponent,label:DebugLabel,cl:CollisionsListener){
        launcher.cd.update(dt);

        if(input.ca.isDown(ActionX) || autoRecall){
            launcher.next(Recall);
        }
        if(!input.ca.isDown(ActionX)){
            launcher.next(Expulse);
        }
        if(launcher.currentState == Recall && cl.onDroneInteractLauncher )
            launcher.next(Docked);

        if(launcher.currentState == Docked && droneLoad >= 1. && grabState == false)
            launcher.next(Loaded);
        
        launcher.debugLabelUpdate(label);
        launcher_currentState = launcher.currentState;
    }
    
    @u function synchronizeState(en:echoes.Entity,dt:Float,gr:GrappleFSM,dpc:DynamicBodyComponent,lab:DebugLabel,tgp:TargetGridPosition){
        gr.cd.update(dt);
        gr.set_synchronized_state(launcher_currentState);
        
        //lab.v = flabel;//gr.claw_state; //dpc.euler.toString();
        droneLoad = gr.load;
    }

    @u function flabelrender(f:FixedDebugLabel,dl:DebugLabel){
        dl.v = flabel;
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
                dpc.seek(tpos.gpToVector(),recallSpeed);
                dpc.arrival(tpos.gpToVector());
            case Docked:
                dpc.stick(tpos.gpToVector());
            case Loaded:
                dpc.stick(tpos.gpToVector());
            case Expulse:
                if(gr.load >= 0)
                    gr.load -= rewind/7;    
                dpc.seek(tpos.gpToVector(),expulseSpeed+(gr.load*0.75));
                dpc.arrival(tpos.gpToVector());
                dpc.addForce(new Vector(0,(gr.load*grapplePower)*0.5));
        }
    
        if(gr.load > gr.maxLoad)
            gr.load = gr.maxLoad;
        
        if(gr.load < 0)
            gr.load = 0;
        
    }
}