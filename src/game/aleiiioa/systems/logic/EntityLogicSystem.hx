package aleiiioa.systems.logic;

import aleiiioa.builders.EntityBuilders;
import aleiiioa.components.core.collision.CollisionsListener;
import aleiiioa.components.logic.SpawnerPointComponent;
import aleiiioa.components.core.position.GridPosition;
import aleiiioa.components.particules.EmitterComponent;
import aleiiioa.components.logic.InteractiveComponent;
import aleiiioa.components.flags.logic.*;
import aleiiioa.builders.VfxBuilders;
import aleiiioa.components.flags.collision.IsDiedFlag;

class EntityLogicSystem  extends echoes.System{
    public var lastSpawnState:Bool = false;

    public function new() {
        
    }

    @u function spawnerUpdate(pos:GridPosition,spp:SpawnerPointComponent,cl:CollisionsListener){
        
    



        if(!cl.cd.has("spawn_cooldown")){
            cl.cd.setS("spawn_cooldown",spp.spawnRest);
            if(lastSpawnState == true){
                spp.onSpawn = true;
                lastSpawnState = false;
            }
        }
        
        if(spp.onSpawn){
            EntityBuilders.chouxPeteur(pos.cx-1,pos.cy);
            spp.onSpawn = false;
        }

        if(cl.cd.has("spawn_cooldown"))
            lastSpawnState = true;
    }

    @u function bombBehavior(en:echoes.Entity,bomb:BombFlag,ic:InteractiveComponent,em:EmitterComponent,gp:GridPosition){
        
        
        if(ic.isGrabbed && !ic.cd.has("countdown")){
            //ic.cd.setS("countdown",3);
        }
        
        if(ic.cd.has("countdown")){
            if(ic.cd.getRatio("countdown") <= 0.05){
             VfxBuilders.bombSmoke(em,gp);
             en.add(new IsDiedFlag());
            }
        }

    }
}