package aleiiioa.components.core.rendering;

class SpriteExtension{
    public var interpolateSprPos = true;    
    public var dir(default,set) = 1;
		
	inline function set_dir(v) {
		return dir = v>0 ? 1 : v<0 ? -1 : dir;
	}

	public var pivotX(default,set) : Float = 0.5;
    
	function set_pivotX(v) {
		pivotX = M.fclamp(v,0,1);
        return pivotX;
	}


	public var pivotY(default,set) : Float = 1;
    
	function set_pivotY(v) {
		pivotY = M.fclamp(v,0,1);
        return pivotY;
	}
 
    public var sprScaleX = 1.0;
	public var sprScaleY = 1.0;

    public var squashX = 1.0;
	public var squashY = 1.0;

    
	public var shakePowX = 0.;
	public var shakePowY = 0.;
	
	/** Color matrix transformation applied to sprite **/
	public var colorMatrix : h3d.Matrix;   
	public var baseColor : h3d.Vector;
	public var blinkColor : h3d.Vector;
    
	//Position on screen (ie. absolute)//
	

    public function new() {
        
    }

    
}