package aleiiioa.components.core.position;

import h3d.Vector;

class GridPosition {
    
	/** Grid X/Y coordinate **/
    public var cx = 0;
    public var cy = 0;
	/** Sub-grid X/Y ratio coordinate (from 0.0 to 1.0) **/
    public var xr = 0.5;
    public var yr = 1.0;

	public var lastFixedUpdateX = 0.;
	public var lastFixedUpdateY = 0.;
    
	public var attachX(get,never) : Float; inline function get_attachX() return (cx+xr)*Const.GRID;
	public var attachY(get,never) : Float; inline function get_attachY() return (cy+yr)*Const.GRID;

	public var prevFrameattachX : Float = -Const.INFINITE;
	public var prevFrameattachY : Float = -Const.INFINITE;

    public var isMoving(get,never):Bool;inline function get_isMoving() return prevFrameattachY != attachY && prevFrameattachX != attachX; 

    //y!=null ? y : x;
    public function new(_cx:Int,_cy:Int,?_xr:Float,?_yr:Float) {
        cx = _cx;
        cy = _cy;
        xr = _xr!=null ? _xr : 0.5;
        yr = _yr!=null ? _yr : 1;
    }

    public function gpToVector() {
        return new Vector(attachX,attachY);
    }
}