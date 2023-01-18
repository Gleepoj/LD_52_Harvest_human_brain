package aleiiioa.components.core.rendering;

class CollisionCircle {
    public var invalidateDebugBounds:Bool = false;
	public var debugBounds : Null<h2d.Graphics> ;

	/** Pixel width of entity **/
	public var wid(default,set) : Float = Const.GRID;
		inline function set_wid(v) { invalidateDebugBounds=true;  return wid=v; }

	/** Pixel height of entity **/
	public var hei(default,set) : Float = Const.GRID;
		inline function set_hei(v) { invalidateDebugBounds=true;  return hei=v; }

	public var attachX :Float = 0 ;
	public var attachY :Float = 0 ;

	public var pivotX :Float ; // a initialize avec sprite
	public var pivotY :Float ;
	
	public var cHei: Int;
	public var cWid: Int; 


	/** Inner radius in pixels (ie. smallest value between width/height, then divided by 2) **/
	public var innerRadius(get,never) : Float;
		inline function get_innerRadius() return M.fmin(wid,hei)*0.5;

	/** "Large" radius in pixels (ie. biggest value between width/height, then divided by 2) **/
	public var largeRadius(get,never) : Float;
		inline function get_largeRadius() return M.fmax(wid,hei)*0.5;


	public function new(spr:SpriteComponent) {

		pivotX = spr.pivot.centerFactorX;
		pivotY = spr.pivot.centerFactorY;

		wid = spr.tile.width  * spr.scaleX;
		hei = spr.tile.height * spr.scaleY;
	}
    
}