package aleiiioa.systems.renderer;

//import aleiiioa.components.core.SpriteExtension;
import aleiiioa.components.logic.DigesterSharedComponent;
import aleiiioa.components.logic.ContainerComponent;
import aleiiioa.components.tools.DigesterFSM;
import aleiiioa.components.logic.DoorComponent;
import aleiiioa.components.core.velocity.DynamicBodyComponent;
import aleiiioa.components.tools.GrappleStatusData;

import aleiiioa.components.logic.ActionComponent;
import h3d.Vector;
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

    @u function collideDebug(spr:SpriteComponent,se:SpriteExtension,cl:CollisionsListener) {
        spr.colorize(se.baseColor.toColor());
        
        if(cl.onArea){
            spr.colorize(0xFF0000);
        }

        if(cl.onContact){
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

     
    @u function digestDebug(spr:SpriteComponent,se:SpriteExtension,dig:DigesterFSM,dsc:DigesterSharedComponent){
        spr.colorize(se.baseColor.toColor());

        if(dig.currentState == Free)
            spr.colorize(0x16e446);
        
        if(dig.currentState == Digest)
            spr.colorize(0x5e16e4);

        if(dig.currentState == Accept)
            spr.colorize(0x047131);

        if(dig.currentState == Spit)
            spr.colorize(0x028739);

        
        if(dsc.bellyState == Gilles)
            spr.colorize(0xab08a5);

        if(dsc.bellyState == John)
            spr.colorize(0xeeff00);


    }

    @u function colorGrapple(spr:SpriteComponent,se:SpriteExtension,cl:CollisionsListener,ac:ActionComponent,gr:GrappleStatusData,dpc:DynamicBodyComponent) {
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

    @u function container(spr:SpriteComponent,se:SpriteExtension,con:ContainerComponent) {
        
        switch con.state {
            case Empty:
                spr.colorize(0x4605ea7b);
            case John:
                spr.colorize(0xe6d439);
            case Gilles:
                spr.colorize(0x3fa8e9);
        }
    }
    
}