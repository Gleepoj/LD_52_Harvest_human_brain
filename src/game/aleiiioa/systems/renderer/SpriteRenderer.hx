package aleiiioa.systems.renderer;

import h3d.Vector;
import echoes.System;
import aleiiioa.components.core.rendering.*;
//import aleiiioa.components.core.SpriteExtension;
import aleiiioa.components.core.position.GridPosition;

class SpriteRenderer extends echoes.System {
	var gameScroller:h2d.Layers;
	var game:Game;


	public function new(scroller:h2d.Layers,_game:Game) {
		this.gameScroller = scroller;
		this.game = _game;
	}

	@a function onEntityAdded(spr:SpriteComponent) {
		this.gameScroller.add(spr,Const.DP_FRONT);
		//spr.setCenterRatio(0.5,1);
		spr.alpha = 1;
	}
	
	@r function onEntityRemoved(spr:SpriteComponent) {
		spr.remove();
	}

	private function interpolateSpritePosition(gp:GridPosition){
		var _x = M.lerp(gp.lastFixedUpdateX, (gp.cx+gp.xr)*Const.GRID, game.getFixedUpdateAccuRatio());
		var _y = M.lerp(gp.lastFixedUpdateY, (gp.cy+gp.yr)*Const.GRID, game.getFixedUpdateAccuRatio()); 
		return new Vector(_x,_y);
	}

	private function setPivots(se:SpriteExtension,spr:SpriteComponent, x:Float, ?y:Float) {
		se.pivotX = x;
		se.pivotY = y!=null ? y : x;
	
		spr.setCenterRatio(se.pivotX, se.pivotY);
	}

	/** Briefly squash sprite on X (Y changes accordingly). "1.0" means no distorsion. **/
	private function setSquash(se:SpriteExtension,sq:SquashComponent) {
		se.squashX = sq.squashX;
		se.squashY = 2 - sq.squashX;
		
		se.squashX = 2 - sq.squashY;
		se.squashY = sq.squashY;
	}

	@u private function renderSprite(dt:Float,spr:SpriteComponent,gp:GridPosition,se:SpriteExtension,sq:SquashComponent) {
		if (se.interpolateSprPos){
			var interpolatePos = this.interpolateSpritePosition(gp);
			spr.x = interpolatePos.x;
			spr.y = interpolatePos.y;
		}
		if (!se.interpolateSprPos){
			spr.x = gp.attachX;
			spr.y = gp.attachY;
		}

		spr.scaleX = se.dir * se.sprScaleX * sq.squashX;
		spr.scaleY = se.sprScaleY * sq.squashY;

		sq.squashX += (1 - sq.squashX) * M.fmin(1, 0.2 * dt);
		sq.squashY += (1 - sq.squashY) * M.fmin(1, 0.2 * dt);		
	}


}
