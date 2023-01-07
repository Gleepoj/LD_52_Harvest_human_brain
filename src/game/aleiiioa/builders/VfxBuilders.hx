package aleiiioa.builders;

import aleiiioa.components.core.position.GridPosition;
import aleiiioa.components.particules.EmitterComponent;

class VfxBuilders {

    
    private static function emitParticule(em:EmitterComponent,gp:GridPosition,spx:Float,spy:Float,lifetime:Float,seed:Int,?body:Bool = false,?customPhysics:Bool = false){
        var e = ParticulesBuilders.smokeParticule(gp,spx,spy,lifetime,seed,body,customPhysics);
        em.addBitmap(e);
    }
    
    private static function emitRandParticule(em:EmitterComponent,gp:GridPosition,sprange:Float,lifetime:Float,?body:Bool = false,?customPhysics:Bool = false){
         var e = ParticulesBuilders.randParticule(gp,sprange,lifetime,body,customPhysics);
         em.addBitmap(e);
    }

    public static function landing(em:EmitterComponent,gp:GridPosition) {
        for(p in 0...5){
            emitRandParticule(em,gp,0.2,1,true,true);
        }
        
        for (right in 0...2){
            var r = right*0.02;
            emitParticule(em,gp,-0.2-r,0,0.3,3,false,true);
        }
        
        for (left in 0...5){
            var l = left*0.02;
            emitParticule(em,gp,0.2+l,0,0.3,3,false,true);
        }
    }
    
    public static function bombSmoke(em:EmitterComponent,gp:GridPosition) {
        for(p in 0...100){
            emitRandParticule(em,gp,0.6,3,true,true);
        }
        
        for (right in 0...5){
            var r = right*0.05;
            emitParticule(em,gp,-0.2-r,0,1,3,false,true);
        }
        
        for (left in 0...5){
            var l = left*0.05;
            emitParticule(em,gp,0.2+l,0,1,3,false,true);
        }
    }

    
}