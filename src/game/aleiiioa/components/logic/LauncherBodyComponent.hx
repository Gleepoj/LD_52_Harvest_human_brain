package aleiiioa.components.logic;

import aleiiioa.builders.UIBuilders;

class LauncherBodyComponent {
    // Physics
    public var xSpeed:Float = 0;
    public var angle :Float  = 0 - Math.PI/4;
    public var velocity:Float = 0;
    public var acceleration:Float = 0;
    public var direction:Int      = 0;
    public var linearDamping :Float = 0.91;

    //Parameters
  
    public var maxSpeed:Float = 0.51; 
    public var accel  :Float = 0.5;
    public var len    :Float = 2.4;
    public var gravity:Float = 0.71;
    public var angularDamping:Float = 0.79;
    public var initialDamping:Float = 0.91; // LinearDamping base value


    public function new() {
      #if debug   
            UIBuilders.slider("L_maxSpeed",     function()  return maxSpeed,      function(v) maxSpeed = v, 0.3,0.9); 
            UIBuilders.slider("L_accel",  function() return accel,   function(v) accel = v, 0.01,0.5);
            UIBuilders.slider("L_initialDamping",function() return initialDamping, function(v) initialDamping = v, 0.800,0.999);   
            
            UIBuilders.slider("L_len",    function() return len,     function(v) len = v, 0.1,4);
            UIBuilders.slider("L_gravity",function() return gravity, function(v) gravity = v, 0.1,4);
            UIBuilders.slider("L_angularDamping",function() return angularDamping, function(v) angularDamping = v, 0.1,4);      
      #end
    }

    public function computePendulum(){
        var sx = xSpeed * direction;
        acceleration = (-1*gravity/len)*Math.sin(angle) + (1*sx/len)*Math.cos(angle);
        velocity += acceleration ;
        velocity *= angularDamping;
        angle    += velocity;
    }
}