package aleiiioa.systems.renderer;

import aleiiioa.components.core.collision.CollisionsListener;
import aleiiioa.components.core.rendering.BoundingBox;
import aleiiioa.components.core.position.GridPosition;

class BoundingBoxRenderer extends echoes.System{
    var gameScroller:h2d.Layers;
    var IDLE_LOGICAL_COLOR :Int = 0x00b3b0;
	var IDLE_PHYSICAL_COLOR:Int = 0x00ff80;

    public function new(scroller:h2d.Layers){
        this.gameScroller = scroller;
    }

    @a function onEntityAdd(bb:BoundingBox,gp:GridPosition){
        bb.attachX = gp.attachX;
        bb.attachY = gp.attachY;
    }
    @r function onEntityRemove(bb:BoundingBox) {
        bb.debugBounds.remove();
		bb.debugCollisions.remove();
    }
	@u function updateCollisions(bb:BoundingBox,gp:GridPosition,cl:CollisionsListener) {
		if(ui.Console.ME.hasFlag("collisions")){
			bb.physicalCollisionsStatus = IDLE_PHYSICAL_COLOR;
			bb.logicalCollisionsStatus  = IDLE_LOGICAL_COLOR;
			
			if(cl.onInteract){
				bb.logicalCollisionsStatus = 0xf98602;
			}
			if(cl.onDroneInteractLauncher){
				bb.logicalCollisionsStatus = 0x02f91b;
			}
			
			if(cl.onContact){
				bb.physicalCollisionsStatus = 0xb50000;
			}
		}
	}

    @u function updateDebugBounds(bb:BoundingBox,gp:GridPosition,cl:CollisionsListener) {
        bb.attachX = gp.attachX;
        bb.attachY = gp.attachY;
        debugRequest(bb);
        renderAllDebugs(bb);
    }
	
	private function renderDebugCollisions(bb:BoundingBox){


		bb.debugCollisions.clear();

		// Inner Radius
		bb.debugCollisions.lineStyle(3,bb.physicalCollisionsStatus,1);
		bb.debugCollisions.drawCircle(bb.centerX - bb.attachX, bb.centerY - bb.attachY,bb.innerRadius);

		// Outer Radius
		bb.debugCollisions.lineStyle(4,bb.logicalCollisionsStatus,1);
		bb.debugCollisions.drawCircle(bb.centerX - bb.attachX, bb.centerY - bb.attachY,bb.outerRadius);

	
	}


    private function renderDebugBounds(bb:BoundingBox) {
		var c = Col.randomRGB(0.9,0.3,0.3);
		bb.debugBounds.clear();

		// Bounds rect
		bb.debugBounds.lineStyle(1, c, 0.5);
		bb.debugBounds.drawRect(bb.left - bb.attachX, bb.top - bb.attachY, bb.wid, bb.hei);

		// Attach point
		bb.debugBounds.lineStyle(0);
		bb.debugBounds.beginFill(c, 0.8);
		bb.debugBounds.drawRect(-1, -1, 3, 3);
		bb.debugBounds.endFill();

		// Center
		bb.debugBounds.lineStyle(1, c, 0.3);
		bb.debugBounds.drawCircle(bb.centerX - bb.attachX, bb.centerY - bb.attachY, 3);

		/* // Radius
		bb.debugBounds.lineStyle(3,Blue,1);
		bb.debugBounds.drawCircle(bb.centerX - bb.attachX, bb.centerY - bb.attachY,bb.innerRadius); */
	}

	private function disableDebugBounds(bb:BoundingBox) {
		if (bb.debugBounds != null) {
			bb.debugBounds.remove();
			bb.debugBounds = null;
		}
	}

	private function enableDebugBounds(bb:BoundingBox) {
		if (bb.debugBounds == null) {
			bb.debugBounds = new h2d.Graphics();
			this.gameScroller.add(bb.debugBounds, Const.DP_TOP);
		}
		bb.invalidateDebugBounds = true;
	}

	private function disableDebugCollisions(bb:BoundingBox) {
		if (bb.debugCollisions != null) {
			bb.debugCollisions.remove();
			bb.debugCollisions = null;
		}
	}

	private function enableDebugCollisions(bb:BoundingBox) {
		if (bb.debugCollisions == null) {
			bb.debugCollisions = new h2d.Graphics();
			this.gameScroller.add(bb.debugCollisions, Const.DP_TOP);
		}
		bb.invalidateCollisions = true;
	}
	
	function renderAllDebugs(bb:BoundingBox) {

		// Debug bounds
		if (bb.debugBounds != null) {
			if (bb.invalidateDebugBounds) {
				bb.invalidateDebugBounds = false;
				renderDebugBounds(bb);
			}
			bb.debugBounds.x = Std.int(bb.attachX);
			bb.debugBounds.y = Std.int(bb.attachY);
		}
		// Debug Collisions
		if (bb.debugCollisions != null) {
			if (bb.invalidateCollisions) {
				bb.invalidateCollisions = false;
				
			}	
			renderDebugCollisions(bb);
			bb.debugCollisions.x = Std.int(bb.attachX);
			bb.debugCollisions.y = Std.int(bb.attachY);
		}

	}

	function debugRequest(bb:BoundingBox) {
		#if debug
		// Show bounds (with `/bounds` in console)
		if (ui.Console.ME.hasFlag("bounds") && bb.debugBounds == null)
			enableDebugBounds(bb);

		// Hide bounds
		if (!ui.Console.ME.hasFlag("bounds") && bb.debugBounds != null)
			disableDebugBounds(bb);

		if (ui.Console.ME.hasFlag("collisions") && bb.debugCollisions == null)
			enableDebugCollisions(bb);

		// Hide bounds
		if (!ui.Console.ME.hasFlag("collisions") && bb.debugCollisions != null)
			disableDebugCollisions(bb);
		#end
	}
}