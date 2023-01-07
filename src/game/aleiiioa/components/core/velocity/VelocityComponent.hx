package aleiiioa.components.core.velocity;

class VelocityComponent {
  	/** X/Y velocity, in grid fractions **/
	  public var dx = 0.;
	  public var dy = 0.;
  
	  /** Uncontrollable bump X/Y velocity, usually applied by external factors (eg. a bumper in Sonic) **/
	  public var bdx = 0.;
	  public var bdy = 0.;
	  
	  // Velocities + bump velocities
	  public var dxTotal(get,never) : Float; inline function get_dxTotal() return dx+bdx;
	  public var dyTotal(get,never) : Float; inline function get_dyTotal() return dy+bdy;
	  public var averageSpeed(get,never):Float;inline function get_averageSpeed() return Math.abs(dxTotal+dyTotal); 
  
	  /** Multiplier applied on each frame to normal X/Y velocity 0.82**/
	  public var frictX = 0.84;//0.9;//0.82;
	  public var frictY = 0.94;//0.82;
  
	  /** Sets both frictX/Y at the same time **/
	  public var frict(never,set) : Float;
		  inline function set_frict(v) return frictX = frictY = v;
  
	  /** Multiplier applied on each frame to bump X/Y velocity **/
	  public var bumpFrictX = 0.93;
	  public var bumpFrictY = 0.93;
  
	  public var physicBody:Bool = false;
	  public var customPhysics:Bool = false;
	  public var collide:Bool = true;
	  
	//legacy a foutree en lair physic custom
	  public function new(?_physicBody:Bool = false,?_customPhysics:Bool = false,_col:Bool = true) {
		  physicBody = _physicBody;
		  customPhysics = _customPhysics;
		  collide = _col;
  
	  }
  
	  /** Apply a bump/kick force to entity **/
	  public function bump(x:Float, y:Float) {
		  bdx += x;
		  bdy += y;
	  }
  
	  /** Reset velocities to zero **/
	  public function cancelVelocities() {
		  dx = bdx = 0;
		  dy = bdy = 0;
	  }
  
	  public function applyFriction() {
		  // X frictions
		  dx *= frictX;
		  bdx *= bumpFrictX;
		  if (M.fabs(dx) <= 0.0005)
			  dx = 0;
		  if (M.fabs(bdx) <= 0.0005)
			  bdx = 0;
  
		  // Y frictions
		  dy *= frictY;
		  bdy *= bumpFrictY;
		  if (M.fabs(dy) <= 0.0005)
			  dy = 0;
		  if (M.fabs(bdy) <= 0.0005)
			  bdy = 0;
	  
	  }
  
  
	  
  }