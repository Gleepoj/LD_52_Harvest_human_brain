package aleiiioa.systems.logic;

import aleiiioa.components.logic.BrainSuckerComponent;
import aleiiioa.components.core.rendering.SquashComponent;
import h3d.Vector;
import aleiiioa.components.core.rendering.SpriteExtension;
import aleiiioa.components.logic.MethanizerComponent;
import aleiiioa.components.core.rendering.SpriteComponent;
import aleiiioa.components.core.velocity.VelocityAnalogSpeed;
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
    public var level(get,never) : Level; inline function get_level() return Game.ME.level;

    var sysEnergyOutput:Float = 0.; // nb de gilles dans methaniseur;
    var sysEnergyConsumption:Float = 0.001; // nb de gilles dans IA;

    var addCorpse:Bool = false;
    var addBrain:Bool = false;
    var addEscape:Bool = false;

    public function new() {
        
    }

    @u function onGilleAdded(spr:SpriteComponent,gil:GilleFlag){
        spr.set(Assets.gille);
        spr.scale(2);
        //spr.anim.registerStateAnim(AssetsDictionaries.anim_gille.idle_anim, 3);
        spr.anim.registerStateAnim(AssetsDictionaries.anim_gille.walk,1);
    }

    @u function gilleWalk(vas:VelocityAnalogSpeed,ic:InteractiveComponent,gille:GilleFlag) {
        if(!ic.isGrabbed){
            if(gille.right == true)
                vas.xSpeed = 0.03;

            if(gille.right == false)
                vas.xSpeed = -0.03;
        }
    }

    @u function gillecollide(en:echoes.Entity,pos:GridPosition,gille:GilleFlag,cl:CollisionsListener) {
 /*            if(level.hasMethaniseur(pos.cx,pos.cy) && !en.exists(IsDiedFlag)){
                en.add(new IsDiedFlag());
                addCorpse = true;
                //trace(" is methanize ");
            } */

            if(cl.onContactDoor && !en.exists(IsDiedFlag)){
                en.add(new IsDiedFlag());
                addCorpse = true;
            }

            if(level.hasShredder(pos.cx,pos.cy) && !en.exists(IsDiedFlag)){
                en.add(new IsDiedFlag());
                addBrain = true;
                //trace(" is shred");
            }

            if(level.hasMetro(pos.cx,pos.cy) && !en.exists(IsDiedFlag)){
                en.add(new IsDiedFlag());
                addEscape = true;
                //trace(" is on Metro");
            }
    }
    
    @u function methanizerUpdate(met:MethanizerComponent,spr:SpriteComponent,se:SpriteExtension,sq:SquashComponent){
        met.energyConsomption = sysEnergyConsumption;

        if(addCorpse){
            addCorpse = false;
            met.corpse += 1;
            sq.squashX *=1.6;
            sq.squashY *=0.8;
            //trace(met.corpse);
            //trace("add corpse");
            //trace(met.energyOutput);
        }

        met.digestion -= sysEnergyConsumption;

        if(met.digestion <=0 ){
           met.corpse -= 1;
           met.digestion = met.digestTime;
           sq.squashX *=0.3;
           sq.squashY *=1.8;
           //trace("digest");
        }

        met.energyOutput = 1-(1/met.corpse);
        sysEnergyOutput = met.energyOutput;
        //var col = new Vector(se.baseColor.r,se.baseColor.b,se.baseColor.g + met.energyOutput);
        //spr.colorize(col.toColor());

    }

    @u function brainUpdate(br:BrainSuckerComponent,spr:SpriteComponent,se:SpriteExtension,sq:SquashComponent){
        //met.energyConsomption = sysEnergyConsumption;

        var factor =  0.01*sysEnergyOutput;

        if(addBrain){
            addBrain = false;
            br.brains += 1;
            sq.squashX *=1.6;
            sq.squashY *=0.8;
           
        }

        if(br.brains > 1){
            br.digestion -= factor;
        }
        //met.digestion -= sysEnergyConsumption;

        if(br.digestion <=1 ){
           br.brains -= 1;
           br.digestion = br.digestTime;
           sq.squashX *=0.3;
           sq.squashY *=1.8;
           //trace("digest brain");
           //trace('factor $factor');
        }

        br.accuracy =  1-(1/br.brains);
        br.energyConsumption = br.brains;

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
            EntityBuilders.gille(pos.cx,pos.cy);
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