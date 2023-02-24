package aleiiioa.systems.renderer;

//import aleiiioa.components.core.SpriteExtension;
import aleiiioa.components.tools.DigesterFSM;
import aleiiioa.components.logic.DoorComponent;
import aleiiioa.components.core.velocity.DynamicBodyComponent;
import aleiiioa.components.tools.GrappleFSM;
import aleiiioa.components.logic.StaticBouleComponent;
import aleiiioa.components.logic.StaticBrainComponent;
import aleiiioa.components.logic.BrainSuckerComponent;
import aleiiioa.components.logic.MethanizerComponent;
import aleiiioa.components.logic.ActionComponent;
import h3d.Vector;
import aleiiioa.components.logic.GrappleComponent;
import aleiiioa.components.core.collision.CollisionsListener;
import aleiiioa.components.core.rendering.*;
import echoes.System;

class SpriteExtensionFx extends System {
    
    var NB_BRAIN:Int =0;
    var NB_BOULE:Int =0;

    public function new() {
        
    }
    
    @a function onAdded(spr:SpriteComponent,se:SpriteExtension) {
        if(se.baseColor != null)
            spr.colorize(se.baseColor.toColor());
    }

    @u function getCurrentBoule(met:MethanizerComponent){
        NB_BOULE = met.corpse;
    }
    @u function getCurrentBrain(br:BrainSuckerComponent){
        NB_BRAIN = br.brains;
    }

    @u function visibilytybrain(b:StaticBrainComponent,spr:SpriteComponent){
        if(b.id > NB_BRAIN)
           spr.visible = false; 

        if(b.id <= NB_BRAIN)
            spr.visible = true; 
    }

    @u function visibilytyboule(b:StaticBouleComponent,spr:SpriteComponent){
        if(b.id > NB_BOULE)
           spr.visible = false; 

        if(b.id <= NB_BOULE)
            spr.visible = true; 
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
    
    @u function doorDebug(spr:SpriteComponent,se:SpriteExtension,door:DoorComponent){
        //spr.colorize(se.baseColor.toColor());

        if(door.isOpen)
            spr.colorize(0x00ff00);

        if(!door.isOpen)
            spr.colorize(0xaa0000);
    }

     
    @u function digestDebug(spr:SpriteComponent,se:SpriteExtension,dig:DigesterFSM){
        //spr.colorize(se.baseColor.toColor());

        if(dig.currentState == Free)
            spr.colorize(0x1679e4);
        
        if(dig.currentState == Digest)
            spr.colorize(0x5e16e4);

        if(dig.currentState == Accept)
            spr.colorize(0x16e46c);

        if(dig.currentState == Spit)
            spr.colorize(0xe1e416);
    }

    @u function colorGrapple(spr:SpriteComponent,se:SpriteExtension,cl:CollisionsListener,ac:ActionComponent,gr:GrappleFSM,dpc:DynamicBodyComponent) {
       //var col:Vector = new Vector(gr.load,se.baseColor.g,se.baseColor.b);
       //spr.colorize(col.toColor());
       /* if(ac.grab == true){
        spr.colorize(0x008e68);
       }

       if(ac.grab == false){
        spr.colorize(0x022c21);
       } */
       //spr.rotation = 0;
       spr.visible = true;

       if(gr.state == Docked || gr.state == Loaded)
            spr.visible = false;

       spr.rotation = M.PIHALF + M.angTo(dpc.location.x,dpc.location.y,dpc.target.x,dpc.target.y-100);

       //if(gr.state == Expulse )
         //   spr.rotation = 0 ;

       

    }
    
    @u function colorMethanizer(spr:SpriteComponent,se:SpriteExtension,met:MethanizerComponent) {
        var col = new Vector(se.baseColor.r,se.baseColor.g+(met.corpse*0.1),se.baseColor.b);
        spr.colorize(col.toColor());
    }
    
    @u function colorBrain(spr:SpriteComponent,se:SpriteExtension,br:BrainSuckerComponent) {
        var col = new Vector(se.baseColor.r+(br.brains*0.1),se.baseColor.g,se.baseColor.b);
        spr.colorize(col.toColor());
    }

}