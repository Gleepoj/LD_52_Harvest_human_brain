package aleiiioa.components.core.velocity;

import h3d.Vector;

class DynamicBodyComponent {
    
    public var maxSpeed = 10.;//0.8
    public var maxForce = 0.5;//0.05
    public var friction = 0.99;//0.99
    
    public var mass = 1;// * Math.random(2);//Math.random(3);
    public var radius = 7.5;
   

    public var orientation:Vector;
    
    public var location :Vector;
    public var target   :Vector;
    public var velocity :Vector;
    public var steering :Vector;

    public var desired  :Vector;
    public var stream   :Vector;
   
    public var acceleration:Vector;
    public var euler:Vector;

    public var isFleeing:Bool = false;
    public var isSeeking:Bool = false;
    public var isStick  :Bool = false;

    public var steeringAngle(get,never):Float; inline function get_steeringAngle() return steering.getPolar();
    public var vehiculeAngle(get,never):Float; inline function get_vehiculeAngle() return orientation.getPolar();
    public var bodyAngle(get,never):Float; inline function get_bodyAngle() return acceleration.getPolar();
    
    public var speed (get,never):Float; inline function get_speed() return velocity.length();
    
    public var boundRadius(get,never):Float; inline function get_boundRadius() return radius*1.2; 
    public var origin(get,never):Vector; inline function get_origin() return new Vector(0,-1,0,0);
    public var zero(get,never):Vector; inline function get_zero() return new Vector(0,0,0,0);

    public var board(get,never):Vector; inline function get_board() return new Vector(Math.cos(vehiculeAngle + Math.PI/2),Math.sin(vehiculeAngle + Math.PI/2));
    public var predicted(get,never):Vector; inline function get_predicted() return VectorUtils.predict(location,acceleration);
    
    public function new (){
        
        location     = new Vector(0,0,0,0);
        target       = new Vector(0,0,0,0);

        velocity     = new Vector(0,0,0,0);
        steering     = new Vector(0,0,0,0);
        orientation  = new Vector(0,0,0,0);
        
        acceleration = new Vector(0,0,0,0);
        desired      = new Vector(0,0,0,0);
        stream       = new Vector(0,0,0,0);
       
        euler = new Vector(0,0,0,0);

    }

    public function addForce(f:Vector){
        isStick = false;
        var a = acceleration.clone();
        var c = VectorUtils.clampVector(f,maxSpeed);
        //if(c.length()> 3)
          //  trace("add force issue");
        
        acceleration = a.add(f);
    }

    public function addTorque(a:Float){
        isStick = false;
        var o = steeringAngle;
        steering =  new Vector(Math.cos(o+a)*1,Math.sin(o+a)*1).normalized();
    }
    
    public function stick(target_location:Vector){
        isStick = true;
        clearForce();
        var tar = target_location;
    
        location.x = tar.x;
        location.y = tar.y;
    }

    public function seek(target_location:Vector,?scale:Float = 0.01){
        isStick = false;

        var tar = target_location;
        var at = M.angTo(location.x,location.y,tar.x,tar.y);
            
        steering.x = Math.cos(at)*1;
        steering.y = Math.sin(at)*1;

        velocity = steering.multiply(scale);
        addForce(velocity);
    }

    public function flee(predator_location:Vector,?fear:Float = 1.2) {
        isStick = false;

        var target = predator_location;
        var t = target.sub(location);
        var dist = t.length();
        var at = M.angTo(location.x,location.y,target.x,target.y);
        steering.x = Math.cos(at)*-1;
        steering.y = Math.sin(at)*-1;
        var speed = M.fclamp(1+1/dist,0,2);
        velocity = steering.multiply(0.02);
        velocity.scale(speed);
        velocity.scale(fear);
        addForce(velocity);
    }
    


    public function arrival(target_location:Vector) {
        isStick = false;

        var target = target_location;
        
        if(target.x > 1 && target.y > 1){
            var t = target.sub(location);
            var dist = 5/t.length();// 5 
            var frict = 1-dist;
            acceleration.scale(frict);
            velocity.scale(frict);
            friction = frict;
        }
        
    }

    public function clearForce() {
        acceleration = zero;
        steering = zero;
        velocity = zero;
        desired = zero;
    }

    public function accelerationFriction(){
        var af = new Vector();
        var accel = new Vector(M.maxPrecision(acceleration.x,2),M.maxPrecision(acceleration.y,2),0,0);
        var f = M.fclamp(friction,0.01,maxSpeed); 
        
        af.lerp(zero,accel,f);
        
        acceleration = af;
       // acceleration = accel;

        if(af.length()> 4){
            acceleration = zero;
            //trace("friction issue");
            //trace(accel.toString());
            //trace(af.toString());
            //trace(friction);
        }

    }   
}