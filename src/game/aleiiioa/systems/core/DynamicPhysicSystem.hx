package aleiiioa.systems.core;

import aleiiioa.components.flags.physics.DynamicBodyFlag;
import aleiiioa.components.flags.physics.PlateformerPhysicsFlag;
import h3d.Vector;

import echoes.Entity;
import echoes.System;

import aleiiioa.builders.UIBuilders;


import aleiiioa.flags.physics.*;

import aleiiioa.components.core.position.*;
import aleiiioa.components.core.velocity.DynamicBodyComponent;
import aleiiioa.components.core.collision.CollisionsListener;

//import aleiiioa.components.tool.wind.solver.SolverUVComponent;
//ajouter un threshold en dessous duquel les particule reagissent pas
//dpc.addTorque((streamDir*stream.length())*0.2);   
//if(stream.length() < 0.45)
//   stream = new Vector(0,0);

class  DynamicPhysicSystem extends System {
    
    public var streamForce:Float = 0.05;
    
    public function new() {
        //UIBuilders.slider("StreamForce",function() return streamForce, function(v) streamForce = v, 0.01,0.8);
        //UIBuilders.slider("MaxForce", function() return dpc.maxForce, function(v) dpc.maxForce = v, 0, 2);
        //UIBuilders.slider("Speed", function() return dpc.maxSpeed, function(v) dpc.maxSpeed = v, 0, 1);
        //UIBuilders.slider("Friction",function() return dpc.friction, function(v) dpc.friction = v, 0.90, 1);
    }

    @a function onAddDynamicBodyComponent(dpc:DynamicBodyComponent){
        
        dpc.steering    = dpc.origin;
        dpc.orientation = dpc.origin;
        dpc.maxForce  = 0.93;
        dpc.maxSpeed  = 0.16;
        
    }

    @u function updateVehicule(dpc:DynamicBodyComponent,gp:GridPosition){
                   
        dpc.location.x = gp.attachX;
        dpc.location.y = gp.attachY;
             
    }

  
    @u function integrateGravity(dpc:DynamicBodyComponent,cl:CollisionsListener,pt:PlateformerPhysicsFlag,dyn:DynamicBodyFlag){
        if(!cl.onGround || !cl.onBounce)
          dpc.addForce(new Vector(0,0.002));
    }

    @u function integrateSteeringForce(dpc:DynamicBodyComponent,dyn:DynamicBodyFlag){

        var angularMoment = new Vector();
        
        angularMoment.lerp(dpc.steering,dpc.orientation,dpc.maxForce);
        angularMoment.normalize();

        var integrate = dpc.orientation.add(angularMoment);
        
        dpc.orientation = integrate;
        dpc.steering.normalize();
        
        dpc.orientation.normalize();
    }

    @u function computeNewPosition(dpc:DynamicBodyComponent,dyn:DynamicBodyFlag) {
        dpc.accelerationFriction();
        dpc.euler = eulerIntegration(dpc);
        
    }

    

    private function eulerIntegration(dpc:DynamicBodyComponent){
      
        var v = dpc.acceleration;
        var clamp_integration:Vector = VectorUtils.clampVector(v,dpc.maxSpeed);
    
        if(clamp_integration.length()>4)
            trace("clamped integration problem");
    
    
       // return  clamp_integration;
       return v;
    } 
 
}