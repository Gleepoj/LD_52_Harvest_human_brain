package aleiiioa.systems.logic;

import aleiiioa.shaders.PaletteShader;
import aleiiioa.components.core.rendering.SquashComponent;
import h3d.Vector;
import aleiiioa.components.core.rendering.SpriteExtension;
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

            if(cl.onContactDoor && !en.exists(IsDiedFlag)){
                en.add(new IsDiedFlag());
                addCorpse = true;
            }

            if(level.hasMetro(pos.cx,pos.cy) && !en.exists(IsDiedFlag)){
                en.add(new IsDiedFlag());
                addEscape = true;
            }
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