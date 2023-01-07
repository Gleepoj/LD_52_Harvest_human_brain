package aleiiioa.components.core.rendering;

class BoundingBox {
	public var invalidateDebugBounds:Bool = false;
	public var debugBounds : Null<h2d.Graphics> ;

	/** Pixel width of entity **/
	public var wid(default,set) : Float = Const.GRID;
		inline function set_wid(v) { invalidateDebugBounds=true;  return wid=v; }

	/** Pixel height of entity **/
	public var hei(default,set) : Float = Const.GRID;
		inline function set_hei(v) { invalidateDebugBounds=true;  return hei=v; }

	//public var wid : Float = Const.GRID; // a init avec spr
	//public var hei : Float = Const.GRID;

	public var attachX :Float = 0 ;
	public var attachY :Float = 0 ;

	public var pivotX :Float = 0.5; // a initialize avec sprite
	public var pivotY :Float = 1;

	//Bounding box getters//
	public var left(get,never)  : Float; inline function get_left()  return attachX + (0-pivotX) * wid;
	public var right(get,never) : Float; inline function get_right() return attachX + (1-pivotX) * wid;
	public var top(get,never)   : Float; inline function get_top()   return attachY + (0-pivotY) * hei;
	public var bottom(get,never): Float; inline function get_bottom()return attachY + (1-pivotY) * hei;
	// Bounding box center//
	public var centerX(get,never) : Float; inline function get_centerX() return attachX + (0.5-pivotX) * wid;
	public var centerY(get,never) : Float; inline function get_centerY() return attachY + (0.5-pivotY) * hei;

	/** Inner radius in pixels (ie. smallest value between width/height, then divided by 2) **/
	public var innerRadius(get,never) : Float;
		inline function get_innerRadius() return M.fmin(wid,hei)*0.5;

	/** "Large" radius in pixels (ie. biggest value between width/height, then divided by 2) **/
	public var largeRadius(get,never) : Float;
		inline function get_largeRadius() return M.fmax(wid,hei)*0.5;


	public function new() {
	}	
}