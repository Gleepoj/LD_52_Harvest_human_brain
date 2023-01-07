package aleiiioa.builders;

import echoes.Entity;

import aleiiioa.components.core.velocity.*;
import aleiiioa.components.core.position.*;
import aleiiioa.components.core.collision.*;
import aleiiioa.components.particules.*;


class ParticulesBuilders {
    

    public static function randParticule(gpemit:GridPosition,speedRange:Float,lifetime:Float,?body:Bool=false,?customPhysics:Bool=false,?fric:Float=0) {
            
        var pa  = new ParticulesComponent(lifetime,body,0.001);
        var bmp = new BitmapComponent(Assets.smoke,0.5);

        var gp  = new GridPosition(gpemit.cx,gpemit.cy,gpemit.xr,gpemit.yr);
        var ang = M.frandRange(-Math.PI,Math.PI);
        var spx = Math.cos(ang)*M.frandRange(0.2,1); 
        var spy = Math.sin(ang)*M.frandRange(0.2,1); 
        var vas = new VelocityAnalogSpeed(spx,spy);
        var vc  = new VelocityComponent(body,customPhysics);
        var cl  = new CollisionsListener();
        var ent = new echoes.Entity().add(pa,bmp,gp,vas,vc,cl);
        return ent;
    }

    public static function smokeParticule(gpemit:GridPosition,dirX:Float,dirY:Float,lifetime:Float,?seed:Int = 0,?body:Bool=false,?customPhysics:Bool=false,?fric:Float=0) {
        var pa  = new ParticulesComponent(lifetime,body,fric);
        var bmp = new BitmapComponent(Assets.smoke,0.5,null,seed);
        var gp  = new GridPosition(gpemit.cx,gpemit.cy,gpemit.xr,gpemit.yr);
        var vas = new VelocityAnalogSpeed(dirX,dirY);
        
        var vc  = new VelocityComponent(body,customPhysics);
        var cl  = new CollisionsListener();
        var ent = new echoes.Entity().add(pa,bmp,gp,vas,vc,cl);
        return ent;
    }

    public static function emitter() {
        var em = new EmitterComponent();
        var gp = new GridPosition(5,10);
        new echoes.Entity().add(em,gp);
    }
}