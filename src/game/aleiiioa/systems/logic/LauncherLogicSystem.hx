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

    var accel  :Float = 0.5;
    var len    :Float = 2.4;
    var gravity:Float = 0.71;
    var angularDamping:Float = 0.79;
    var linearDamping :Float = 0.91;
    //var maxSpeed      :Float = 0.51;//0.41

    // Drone Parameter

    var recallSpeed  :Float = 3.4;
    var expulseSpeed :Float = 3.4;
    var slowdown     :Float = 0.99;
    var grapplePower :Float = 2.3;// grapple launch speed
    var loadSpeed    :Float = 0.08;

    var droneBoost  :Float = 0.002;
    var droneMaxLoad:Float = 3.;
    


    public function new() {
        #if debug
            //UIBuilders.slider("accel",  function() return accel,   function(v) accel = v, 0.01,0.5);
            //UIBuilders.slider("len",    function() return len,     function(v) len = v, 0.1,4);
            //UIBuilders.slider("gravity",function() return gravity, function(v) gravity = v, 0.1,4);
            //UIBuilders.slider("angularDamping",function() return angularDamping, function(v) angularDamping = v, 0.1,4);     
            //UIBuilders.slider("linearDamping",function()  return linearDamping, function(v) linearDamping = v, 0.800,0.999);    
            //UIBuilders.slider("maxSpeed",     function()  return maxSpeed,      function(v) maxSpeed = v, 0.3,0.9);  
            
            UIBuilders.slider("Drone : launchSpeed", function()  return grapplePower, function(v) grapplePower = v, 2.,9.);  
            //UIBuilders.slider("Drone : reloadSpeed",    function()  return loadSpeed,     function(v) loadSpeed = v, 0.03,0.09);  
            //UIBuilders.slider("Drone : recallSpeed", function() return recallSpeed , function(v) recallSpeed = v, 2.2,5);
            //UIBuilders.slider("Drone : expulseOffset",function() return expulseSpeed, function(v) expulseSpeed = v, 1.8,5);  
            UIBuilders.slider("Drone : BoostSpeed", function()  return droneBoost,    function(v) droneBoost   = v, 0.05,0.2); 
            UIBuilders.slider("Drone : maxLoad",    function()  return droneMaxLoad,  function(v) droneMaxLoad = v, 1.,4.); 
            UIBuilders.slider("Drone : slowdown",   function()  return slowdown,     function(v) slowdown     = v, 0.9,1); 
        #end
          
    }


    @a function onGrappleAdded(en:echoes.Entity,gr:GrappleStatusData,spr:SpriteComponent){
        spr.set(Assets.drone);
        spr.anim.registerStateAnim(AssetsDictionaries.anim_drone.fly_open,1,3,()->gr.state == Free);
        spr.anim.registerStateAnim(AssetsDictionaries.anim_drone.fly_close,1,3,()->gr.state == Free);
        spr.anim.registerStateAnim(AssetsDictionaries.anim_drone.fly_release,1,3);
    }

    @a function onLauncherAdded(en:echoes.Entity,launcher:LauncherFSM,spr:SpriteComponent){ 
        spr.set(Assets.launcher);
        spr.anim.registerStateAnim(AssetsDictionaries.anim_launcher.idle,      1,()->launcher.currentState == Free);
        spr.anim.registerStateAnim(AssetsDictionaries.anim_launcher.recall,    1,()->launcher.currentState == Free);
        spr.anim.registerStateAnim(AssetsDictionaries.anim_launcher.dock_empty,1,()->launcher.currentState == Loaded);
        spr.anim.registerStateAnim(AssetsDictionaries.anim_launcher.load,      1,()->launcher.currentState == Charging);
        spr.anim.registerStateAnim(AssetsDictionaries.anim_launcher.expulse,   1,()->launcher.currentState == Expulse);
    }

    @u function launcherPhysics(launcher:LauncherBodyComponent,fsm:LauncherFSM,vas:VelocityAnalogSpeed,spr:SpriteComponent,inp:InputComponent){
        var sx = launcher.xSpeed * launcher.direction;

        launcher.acceleration = (-1*gravity/len)*Math.sin(launcher.angle) + (1*sx/len)*Math.cos(launcher.angle);
        launcher.velocity += launcher.acceleration ;
        launcher.velocity *= angularDamping;
        launcher.angle    += launcher.velocity;

        
        if(fsm.cd.has("onDock")){
            accel += (droneLoad*droneBoost);
        }

        if(inp.ca.isDown(MoveRight) && launcher.xSpeed <= launcher.maxSpeed){
            launcher.xSpeed += accel;
        }

        if(inp.ca.isDown(MoveLeft)  && launcher.xSpeed <= launcher.maxSpeed){
            launcher.xSpeed += accel;
        }

        if(launcher.xSpeed > launcher.maxSpeed && !fsm.cd.has("onDock")){
            launcher.xSpeed = launcher.maxSpeed;
        }

        launcher.xSpeed *= linearDamping;
        vas.xSpeed = launcher.xSpeed * launcher.direction;
        spr.rotation =  launcher.angle;
        linearDamping = 0.91;
    }


    @u function setAutoRecall(en:echoes.Entity,gr:GrappleStatusData,cl:CollisionsListener,ac:ActionComponent,input:InputComponent){
        
        if(gr.state == Expulse){
            if(cl.onHitHorizontal)
                autoRecall = true;
            //if(gr.load <= 0.2)
               // autoRecall = true;
        }

/*         
        if(gr.state == Free)
            autoRecall = true; */
  
        if(input.ca.isDown(ActionX)){
            if(launcher_currentState == Loaded){
                 if(gr.load < droneMaxLoad)
                    gr.load += loadSpeed;
                linearDamping = 0.85;
            }
            if(launcher_currentState == Charging){
                if(gr.load < droneMaxLoad)
                   gr.load += loadSpeed*0.9;
                linearDamping = 0;
           }
        }

    
        grabState = gr.onGrab;
        gr.grab_state = ac.grab;
    }
  
    @u function inputStateMachine(dt:Float,launcher:LauncherFSM,input:InputComponent,label:DebugLabel,cl:CollisionsListener){
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

        if(launcher.currentState == Loaded && input.ca.isDown(ActionX)){
            launcher.next(Charging);
            autoRecall = false;
        }

        if(launcher.currentState == Charging && droneLoad >= 1. && grabState == false)
            launcher.next(Charged);
        
        //if(launcher.currentState != Loaded)
          //  launcher.cd.unset("onDock");

        launcher.debugLabelUpdate(label);
        launcher_currentState = launcher.currentState;
    }
    
    @u function synchronizeState(en:echoes.Entity,dt:Float,gr:GrappleStatusData,dpc:DynamicBodyComponent,lab:DebugLabel,tgp:TargetGridPosition){
        gr.cd.update(dt);
        gr.set_synchronized_state(launcher_currentState);
        
        lab.v = M.pretty(droneLoad,1);
        droneLoad = gr.load;
    }

    @u function dronePhysics(en:echoes.Entity,gr:GrappleStatusData,tpos:TargetGridPosition,dpc:DynamicBodyComponent,cl:CollisionsListener,inp:InputComponent){
        
       dpc.target = tpos.gpToVector();
        switch gr.state {
            case Free:
                gr.load = 0;
                dpc.seek(tpos.gpToVector(),recallSpeed);
                dpc.arrival(tpos.gpToVector());
/*                 gr.load = 0;
                if(!cl.onDroneInteractLauncher){
                    dpc.seek(tpos.gpToVector(),1.11);
                    dpc.arrival(tpos.gpToVector());
                } */
            case Loaded:
                dpc.stick(tpos.gpToVector());
            case Charging:
                dpc.stick(tpos.gpToVector());
            case Charged:
                dpc.stick(tpos.gpToVector());
            case Expulse:
                if(gr.load >= 0)
                    gr.load *= slowdown;
                    
                //gr.load -= slowdown/7;    
                dpc.seek(tpos.gpToVector(),expulseSpeed+(gr.load*0.75));
                dpc.arrival(tpos.gpToVector());
                dpc.addForce(new Vector(0,(gr.load*grapplePower)*0.5));
        } 
    
        if(gr.load > droneMaxLoad)
            gr.load = droneMaxLoad;
        
        if(gr.load < 0)
            gr.load = 0;
        
    }
}