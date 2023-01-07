package tools;

import h3d.Vector;

class VectorUtils {
    // not a pure vector projection: return vecproj + a ligth offset for path steering behavior (var f)
    public static function vectorProjection(_aLocation:Vector,_predictLocation:Vector,_bLocation:Vector) {
            var u = _bLocation.sub(_aLocation);
            var uBis = _bLocation.sub(_aLocation);
            var v = _predictLocation.sub(_aLocation);
            
            var sp = scalarProjection(u,v);
        
            uBis.normalize();
            var p = uBis.multiply(sp);
            var offset = uBis.multiply(Math.abs(0.3*sp));
            var n = p.add(offset);
            return _aLocation.add(n);
        }
    
    public static function scalarProjection(_u:Vector,v:Vector){
            var u = _u.normalized();
            return v.dot(u);
    }

    public static function divideVector(vec:Vector,f:Float) {
        var v = vec.clone();
        return new Vector(v.x / f, v.y / f, v.z / f, v.w);
    }
//chiasse molle
    public static function limitVector(vector:Vector,max:Float){
/* 		var _v:Vector = new Vector();
        var _temp:Vector = vector.clone();
        var lSq = vector.lengthSq();
		if(lSq > max*max){
			_temp = divideVector(vector,Math.sqrt(lSq));
			_v = _temp.scale(max);
		}
        return _temp; */
	}

    public static function clampVector(vector:Vector,max:Float){
        
        var v = vector.clone();
        var x = M.fclamp(v.x,-max,max);
        var y = M.fclamp(v.y,-max,max);

        return new Vector(x,y,0,0);
    }


    public static function predict(_location:Vector,_velocity:Vector) {
        var p = _velocity.clone();
        p.normalize();
        p.scale(10);
        var predict = _location.add(p);
        return predict;
    }
}