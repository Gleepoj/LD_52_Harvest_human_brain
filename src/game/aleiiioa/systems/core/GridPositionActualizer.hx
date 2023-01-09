package aleiiioa.systems.core;


import aleiiioa.components.flags.hierarchy.TargetedFlag;
import aleiiioa.components.flags.hierarchy.ChildFlag;
import aleiiioa.components.flags.hierarchy.MasterFlag;
import aleiiioa.components.core.position.*;


class GridPositionActualizer extends echoes.System {
    
    public function new() {
        
    }

    @a function onGridPositionAdded(gp:GridPosition) {
	   onPosManuallyChanged(gp);
    }

	
	@u function updateMasterGridPosition(mgp:MasterGridPosition,gp:GridPosition,mflag:MasterFlag) {
	  	mgp.cx = gp.cx;
		mgp.cy = gp.cy;
		mgp.xr = gp.xr;
		mgp.yr = gp.yr;
	}

		
	@u function updateTargetedGridPosition(tgp:TargetGridPosition,gp:GridPosition,tflag:TargetedFlag) {
	  tgp.cx = gp.cx;
	  tgp.cy = gp.cy+2;
	  tgp.xr = gp.xr;
	  tgp.yr = gp.yr;
  	}


	@u function updateChildPos(mgp:MasterGridPosition,gp:GridPosition,gpo:GridPositionOffset,cflag:ChildFlag) {
		gp.cx = mgp.cx + gpo.ocx;
		gp.cy = mgp.cy + gpo.ocy;
		gp.xr = mgp.xr + gpo.oxr;
		gp.yr = mgp.yr + gpo.oyr;

	}

	

    @u inline function ActualizeGridComponent(gp:GridPosition){
		onPosManuallyChanged(gp);
    }


	function setPosCase(gp:GridPosition,_cx:Int,_cy:Int) {
		gp.cx = _cx;
		gp.cy = _cy;
		gp.xr = 0.5;
		gp.yr = 1;
		onPosManuallyChanged(gp);
	}

    function setPosPixel(gp:GridPosition,x:Float, y:Float) {
		gp.cx = Std.int(x/Const.GRID);
		gp.cy = Std.int(y/Const.GRID);
		gp.xr = (x-gp.cx*Const.GRID)/Const.GRID;
		gp.yr = (y-gp.cy*Const.GRID)/Const.GRID;
		onPosManuallyChanged(gp);
	}

	function onPosManuallyChanged(gp:GridPosition) {
		if( M.dist(gp.attachX,gp.attachY,gp.prevFrameattachX,gp.prevFrameattachY) > Const.GRID*2 ) {
			gp.prevFrameattachX = gp.attachX;
			gp.prevFrameattachY = gp.attachY;
		}
		updateLastFixedUpdatePos(gp);
	}

	function finalUpdate(gp:GridPosition) {
		gp.prevFrameattachX = gp.attachX;
		gp.prevFrameattachY = gp.attachY;
	}

    function updateLastFixedUpdatePos(gp:GridPosition) {
		gp.lastFixedUpdateX = gp.attachX;
		gp.lastFixedUpdateY = gp.attachY;
	}

}