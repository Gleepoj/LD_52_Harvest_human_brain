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

	public var pivotX :Float ; // a initialize avec sprite
	public var pivotY :Float ;

	//Global xy ratio for collision ex: une sprite fait trois case de haut gxy = 1.5;
	
	// mid box
	public var gxr:Float;// inline function get_gxr()  return M.maxPrecision((wid/Const.GRID)/2,2);
	public var gyr:Float;// inline function get_gyr()  return M.maxPrecision((hei/Const.GRID)/2,2);
	
	// integral box
	public var cxb:Int;// inline function get_gxr()  return M.floor(gxr);
	public var cyb:Int; //inline function get_gyr()  return M.floor(gyr);	

	// substract ratio 
	public var sxr:Float;// inline function get_gxr()  return M.maxPrecision((wid/Const.GRID)/2,2);
	public var syr:Float;

	//Bounding box getters//
	public var left(get,never)  : Float; inline function get_left()  return attachX + (0-pivotX) * wid;
	public var right(get,never) : Float; inline function get_right() return attachX + (1-pivotX) * wid;
	public var top(get,never)   : Float; inline function get_top()   return attachY + (0-pivotY) * hei;
	public var bottom(get,never): Float; inline function get_bottom()return attachY + (1-pivotY) * hei;
	// Bounding box center//
	public var centerX(get,never) : Float; inline function get_centerX() return attachX + (0.5-pivotX) * wid;
	public var centerY(get,never) : Float; inline function get_centerY() return attachY + (0.5-pivotY) * hei;
	
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

		cHei = Math.floor(hei/Const.GRID);
		cWid = Math.floor(wid/Const.GRID);

		gxr = M.maxPrecision((wid/Const.GRID)/2,1);
		gyr = M.maxPrecision((hei/Const.GRID)/2,1);

		cxb = M.floor(gxr)+1 ;
		cyb = M.floor(gyr)+1 ;

		sxr = gxr-cxb+1;
		syr = gyr-cyb+1;
	}	
}