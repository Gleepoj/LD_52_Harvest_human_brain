package aleiiioa.systems.core;

import echoes.Entity;
import aleiiioa.components.core.collision.CollisionsListener;
import aleiiioa.components.core.velocity.*;
import aleiiioa.components.core.position.GridPosition;

class VelocitySystem extends echoes.System {
	public function new() {}
	public var level(get,never) : Level; inline function get_level() return Game.ME.level;
	
	@u function updateVelocity(en:Entity,gp:GridPosition,vc:VelocityComponent,vas:VelocityAnalogSpeed,cl:CollisionsListener) {
		
		if(!vc.physicBody && vc.customPhysics){	
			vc.dx = vas.xSpeed;
			vc.dy = vas.ySpeed;
			fixedUpdate(gp,vc,cl);
		}
		
		if(vc.physicBody && vc.customPhysics){
			vc.dx = vas.xSpeed;
			vc.dy = vas.ySpeed;
			fixedUpdate(gp,vc,cl);
		}

		if(vc.physicBody && !vc.customPhysics){
		
			if(cl.onGround)
				cl.cd.setS("recentlyOnGround",0.01);

			if(!cl.onGround){
				vc.dy += 0.1;
			}

			if( vas.ySpeed != 0 ) {
				vc.dy += vas.ySpeed;
			}

			if( vas.xSpeed != 0 ) {
				var speed = 0.3;
				vc.dx += vas.xSpeed * speed;
			}

			vas.xSpeed = 0;
			vas.ySpeed = 0;

			fixedUpdate(gp,vc,cl);
			applyFriction(vc);
		}
	}

	function fixedUpdate(gp:GridPosition, vc:VelocityComponent, cl:CollisionsListener) {
		var steps = M.ceil((M.fabs(vc.dxTotal) + M.fabs(vc.dyTotal)) / 0.33);
		if (steps > 0) {
			var n = 0;
			while (n < steps) {
				// X movement
				gp.xr += vc.dxTotal / steps;

				if (vc.dxTotal != 0){
					if(vc.physicBody)
						onPreStepX(gp,cl); // <---- Add X collisions checks and physics in here
				}
				while (gp.xr > 1) {
					gp.xr--;
					gp.cx++;
				}
				while (gp.xr < 0) {
					gp.xr++;
					gp.cx--;
				}

				// Y movement
				gp.yr += vc.dyTotal / steps;

				if (vc.dyTotal != 0){
					if(vc.physicBody)
						onPreStepY(gp,cl,vc); // <---- Add Y collisions checks and physics in here
				}
				while (gp.yr > 1) {
					gp.yr--;
					gp.cy++;
				}
				while (gp.yr < 0) {
					gp.yr++;
					gp.cy--;
				}

				n++;
			}
		}
	}

	function applyFriction(vc:VelocityComponent) {
		// X frictions
		vc.dx *= vc.frictX;
		vc.bdx *= vc.bumpFrictX;
		if (M.fabs(vc.dx) <= 0.0005)
			vc.dx = 0;
		if (M.fabs(vc.bdx) <= 0.0005)
			vc.bdx = 0;

		// Y frictions
		vc.dy *= vc.frictY;
		vc.bdy *= vc.bumpFrictY;
		if (M.fabs(vc.dy) <= 0.0005)
			vc.dy = 0;
		if (M.fabs(vc.bdy) <= 0.0005)
			vc.bdy = 0;
	
	}

	/** Apply a bump/kick force to entity **/
	public function bump(x:Float, y:Float, vc:VelocityComponent) {
		vc.bdx += x;
		vc.bdy += y;
	}

	/** Reset velocities to zero **/
	public function cancelVelocities(vc:VelocityComponent) {
		vc.dx = vc.bdx = 0;
		vc.dy = vc.bdy = 0;
	}

	/** Called at the beginning of each X movement step **/
	function onPreStepX(gp:GridPosition,cl:CollisionsListener) {
		// Right collision
		if( gp.xr>0.6 && level.hasCollision(gp.cx+1,gp.cy) )
			gp.xr = 0.6;
		
		// Left collision
		if( gp.xr<0.3 && level.hasCollision(gp.cx-1,gp.cy) )
			gp.xr = 0.3;
	}

	/** Called at the beginning of each Y movement step **/
	function onPreStepY(gp:GridPosition,cl:CollisionsListener,vc:VelocityComponent) {
		
		// Land on ground
		if( gp.yr>1 && level.hasCollision(gp.cx,gp.cy+1) ) {
			vc.dy  = 0;
			vc.bdy = 0;
			gp.yr = 1;
			cl.cd.setS("landing",0.005);
		}

		
		// Ceiling collision
		if( gp.yr<=0.5 && level.hasCollision(gp.cx,gp.cy-1) )
			gp.yr = 0.5;
	}
}
