package aleiiioa.systems.renderer;

import aleiiioa.components.core.rendering.BoundingBox;
import aleiiioa.components.core.position.GridPosition;

class BoundingBoxRenderer extends echoes.System{
    var gameScroller:h2d.Layers;
    
    public function new(scroller:h2d.Layers){
        this.gameScroller = scroller;
    }

    @a function onEntityAdd(bb:BoundingBox,gp:GridPosition){
        bb.attachX = gp.attachX;
        bb.attachY = gp.attachY;
    }
    @r function onEntityRemove(bb:BoundingBox) {
        bb.debugBounds.remove();
    }
    @u function updateDebugBounds(bb:BoundingBox,gp:GridPosition) {
        bb.attachX = gp.attachX;
        bb.attachY = gp.attachY;
        debugRequest(bb);
        renderAllDebugs(bb);
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
	}

	function debugRequest(bb:BoundingBox) {
		#if debug
		// Show bounds (with `/bounds` in console)
		if (ui.Console.ME.hasFlag("bounds") && bb.debugBounds == null)
			enableDebugBounds(bb);

		// Hide bounds
		if (!ui.Console.ME.hasFlag("bounds") && bb.debugBounds != null)
			disableDebugBounds(bb);
		#end
	}
}