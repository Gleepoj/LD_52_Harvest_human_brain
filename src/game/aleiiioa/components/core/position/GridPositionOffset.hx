package aleiiioa.components.core.position;

// Is used with MasterGridPosition here is the data for offsetting an "subentity" from a master position
class GridPositionOffset {
    
    public var ocx:Int;
    public var ocy:Int;
    public var oxr:Float;
    public var oyr:Float;

    public function new(x:Int,y:Int) {
        ocx = x;
        ocy = y;  
        oxr = 0;
        oyr = 0; 
    }

    public function setXYratio(_xr:Float,_yr:Float) {
        oxr = _xr;
        oyr = _yr;
    }
}