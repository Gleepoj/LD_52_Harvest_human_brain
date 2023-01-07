package aleiiioa.systems.particules;

import aleiiioa.builders.VfxBuilders;
import aleiiioa.components.core.collision.CollisionsListener;
import aleiiioa.builders.ParticulesBuilders;
import aleiiioa.components.core.position.GridPosition;
import aleiiioa.components.particules.*;


class ParticulesSystem extends echoes.System {

    public function new() {
    }
    
    @a function onEmitterAdded(em:EmitterComponent,gp:GridPosition) {
    }

    @u private function updateEmitter(dt:Float,em:EmitterComponent,gp:GridPosition,cl:CollisionsListener){
        em.cd.update(dt);

        if(cl.onLanding && !em.cd.has("cooldown")){
            em.cd.setS("cooldown",0.3);
            VfxBuilders.landing(em,gp);
        }
    }

    @u function updateShaderLifetime(p:ParticulesComponent,bmp:BitmapComponent){
        var l = p.lifeRatio;
        bmp.shader.ratio = l;
    
    }

    @u function deletePart(dt:Float,en:echoes.Entity,p:ParticulesComponent,bmp:BitmapComponent) {
        p.cd.update(dt);
        
        p.scaleX -= 0.0001;
        p.scaleY -= 0.0001;
        p.alpha  -= p.shrink;

        if(!p.cd.has("alive")){
            bmp.bitmap.remove();
            en.destroy();
        }
    }


}