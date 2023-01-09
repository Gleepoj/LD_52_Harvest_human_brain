package aleiiioa.systems.renderer;

//import aleiiioa.components.core.SpriteExtension;
import aleiiioa.components.logic.BrainSuckerComponent;
import aleiiioa.components.logic.MethanizerComponent;
import aleiiioa.components.logic.ActionComponent;
import h3d.Vector;
import aleiiioa.components.logic.GrappleComponent;
import aleiiioa.components.core.collision.CollisionsListener;
import aleiiioa.components.core.rendering.*;
import echoes.System;

class SpriteExtensionFx extends System {
    public function new() {
        
    }
    
    @a function onAdded(spr:SpriteComponent,se:SpriteExtension) {
        if(se.baseColor != null)
            spr.colorize(se.baseColor.toColor());
    }

 

    @u function collideDebug(spr:SpriteComponent,se:SpriteExtension,cl:CollisionsListener) {
        spr.colorize(se.baseColor.toColor());
        
        if(cl.onArea){
            spr.colorize(0xFF0000);
        }

        if(cl.onInteract){
            spr.colorize(0x01AA74);
        }
  
      /*   if(cl.onGround){
            spr.colorize(0x3566D5);
        }
        if(cl.onRight){
            spr.colorize(0xbae1ff);
        }
        if(cl.onLeft){
            spr.colorize(0xbaffc9);
        }
        if(cl.onCeil){
            spr.colorize(0xeea990);
        }   */
    }

    @u function colorGrapple(spr:SpriteComponent,se:SpriteExtension,cl:CollisionsListener,ac:ActionComponent,gr:GrappleComponent) {
       var col:Vector = new Vector(gr.load,se.baseColor.g,se.baseColor.b);
       spr.colorize(col.toColor());
       /* if(ac.grab == true){
        spr.colorize(0x008e68);
       }

       if(ac.grab == false){
        spr.colorize(0x022c21);
       } */
    }
    @u function colorMethanizer(spr:SpriteComponent,se:SpriteExtension,met:MethanizerComponent) {
        var col = new Vector(se.baseColor.r,met.energyOutput,se.baseColor.b);
        spr.colorize(col.toColor());
    }
    
    @u function colorBrain(spr:SpriteComponent,se:SpriteExtension,br:BrainSuckerComponent) {
        var col = new Vector(br.accuracy,se.baseColor.g,se.baseColor.b);
        spr.colorize(col.toColor());
    }

}