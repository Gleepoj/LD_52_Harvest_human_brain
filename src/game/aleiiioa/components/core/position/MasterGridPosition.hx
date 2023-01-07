package aleiiioa.components.core.position;
import aleiiioa.components.core.position.GridPosition;

class MasterGridPosition extends GridPosition{
    public var isMasterAlive = true;
    public function new(_cx:Int,_cy:Int,?_xr:Float,?_yr:Float) {
        super(_cx,_cy,_xr,_yr);
    }
}