package aleiiioa.systems.core;


import aleiiioa.components.flags.physics.PlateformerPhysicsFlag;
import aleiiioa.components.flags.physics.TopDownPhysicsFlag;
import aleiiioa.components.flags.physics.KinematicBodyFlag;
import aleiiioa.components.flags.physics.DynamicBodyFlag;
import h3d.Vector;
import aleiiioa.components.core.rendering.BoundingBox;
import echoes.Entity;
import aleiiioa.components.core.collision.CollisionsListener;
import aleiiioa.components.flags.collision.CollisionLayer;
import aleiiioa.components.core.velocity.*;
import aleiiioa.components.core.position.GridPosition;

class VelocitySystem extends echoes.System {
	public function new() {}
	public var level(get,never) : Level; inline function get_level() return Game.ME.level;
	

	@u function dynamicOnHitWall(vhc:DynamicBodyComponent,cl:CollisionsListener,vc:VelocityComponent){
        //vc.collide = false;
		
		if(cl.onWest && cl.onLeft)
			cl.cd.setS("hit_vertical",0.01);
		
		if(cl.onEast && cl.onRight)
			cl.cd.setS("hit_vertical",0.01);
		
		if(cl.onNorth && cl.onCeil)
			cl.cd.setS("hit_horizontal",0.01);
		
		if(cl.onSouth && cl.onGround)
			cl.cd.setS("hit_horizontal",0.01);

		/* if(cl.onHitHorizontal && !cl.cd.has("bounce_wall_cd")){
            vhc.acceleration.scale(0.95);
			var norm = new Vector(0,0);

            if(cl.onCeil)
               norm = new Vector(0,1);

            if(cl.onGround)
                norm = new Vector(0,-1);
			var r = vhc.acceleration.reflect(norm);
			vhc.clearForce();
			vhc.addForce(r);
			
            cl.cd.setS("bounce_wall_cd",0.01);
            cl.cd.unset("hit_horizontal");
        }

		

        if(cl.onHitVertical && !cl.cd.has("bounce_wall_cd")){
            vhc.acceleration.scale(0.95);
			var norm = new Vector(0,0);
            if(cl.onLeft)
               norm = new Vector(1,0);

            if(cl.onRight)
                norm = new Vector(-1,0);
			var r = vhc.acceleration.reflect(norm);
			vhc.clearForce();
			vhc.addForce(r);
			
            cl.cd.setS("bounce_wall_cd",0.01);
            cl.cd.unset("hit_vertical");
        }  */
    }
    
	@u function updateDynamicBody(en:Entity,gp:GridPosition,vc:VelocityComponent,dpc:DynamicBodyComponent,cl:CollisionsListener,dyn:DynamicBodyFlag){
		
		vc.dx = dpc.euler.x;
		vc.dy = dpc.euler.y;

	}

    @u function updateTopDownBody(en:Entity,gp:GridPosition,vc:VelocityComponent,vas:VelocityAnalogSpeed,cl:CollisionsListener,kb:KinematicBodyFlag,td:TopDownPhysicsFlag) {
        
		vc.dx = vas.xSpeed;
		vc.dy = vas.ySpeed;

    }

    @u function updatePlateformerBody(gp:GridPosition,vc:VelocityComponent,vas:VelocityAnalogSpeed,cl:CollisionsListener,kb:KinematicBodyFlag,pl:PlateformerPhysicsFlag) {
			if(cl.onGround && cl.onFall){
				cl.cd.setS("landing",0.005);
			}

			if(cl.onGround){
				cl.cd.setS("recentlyOnGround",0.01);// coyote time
			}

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

			vc.applyFriction();
	}

	@u function fixedUpdate(en:echoes.Entity,gp:GridPosition,vc:VelocityComponent,bb:BoundingBox) {
		var steps = M.ceil((M.fabs(vc.dxTotal) + M.fabs(vc.dyTotal)) / 0.33);
		if (steps > 0) {
			var n = 0;
			while (n < steps) {
				// X movement
				gp.xr += vc.dxTotal / steps;

				if (vc.dxTotal != 0){
					if(vc.collide)
						onPreStepX(en,gp,bb,vc); // <---- Add X collisions checks and physics in here
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
					if(vc.collide)
						onPreStepY(en,gp,bb,vc); // <---- Add Y collisions checks and physics in here
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

	/** Called at the beginning of each X movement step **/
	function onPreStepX(en:Entity,gp:GridPosition,bb:BoundingBox,vc:VelocityComponent) {
		//Right collision
		if(gp.xr>=1-bb.sxr && level.hasCollision(gp.cx+bb.cxb,gp.cy)){
			gp.xr = 1-bb.sxr;
		}
		//Left collision
		if(gp.xr<=bb.sxr && level.hasCollision(gp.cx-bb.cxb,gp.cy)){
			gp.xr = bb.sxr;	
		}

		if(bb.cHei>1){
		var top = gp.cy - Math.floor(bb.cHei/2);
			
			for (i in 0...bb.cHei){
				var yt = top +i;	
				if(gp.xr>=1-bb.sxr && level.hasCollision(gp.cx+bb.cxb,yt)){
					gp.xr = 1-bb.sxr;
				}
			//Left collision
				if(gp.xr<=bb.sxr && level.hasCollision(gp.cx-bb.cxb,yt)){
					gp.xr = bb.sxr;	
				}

			}
		}

		/* if(en.exists(CollisionLayer)){
			var layer = en.get(CollisionLayer);
			if(layer.layer == 1){
				if( gp.xr>=1-bb.sxr && level.hasFence(gp.cx+bb.cxb,gp.cy) )
					gp.xr =1-bb.sxr;
				
				// Left collision
				if( gp.xr<=bb.sxr && level.hasFence(gp.cx-bb.cxb,gp.cy) )
					gp.xr = bb.sxr;
			}
		} */
	}

	/** Called at the beginning of each Y movement step **/
	function onPreStepY(en:Entity,gp:GridPosition,bb:BoundingBox,vc:VelocityComponent) {		
		
		if( gp.yr<=bb.syr && level.hasCollision(gp.cx,gp.cy-bb.cyb) )
			gp.yr = bb.syr;

		if( gp.yr>=1-bb.syr && level.hasCollision(gp.cx,gp.cy+bb.cyb) ){
			gp.yr =1-bb.syr;
			vc.dy = 0 ;
			vc.bdy = 0;
		}
		
		/* if(en.exists(CollisionLayer)){
			var layer = en.get(CollisionLayer);
			if(layer.layer == 1){
				if( gp.yr<=bb.syr && level.hasFence(gp.cx,gp.cy-bb.cyb) )
					gp.yr = bb.syr;
		
				if( gp.yr>=1-bb.syr && level.hasFence(gp.cx,gp.cy+bb.cyb) ){
					gp.yr =1-bb.syr;
					vc.dy = 0 ;
					vc.bdy = 0;
				}	
			}
		} */
	}
}
