package aleiiioa.builders;



import hxd.Math;
import aleiiioa.components.logic.SpawnerPointComponent;
import aleiiioa.components.flags.hierarchy.TargetedFlag;
import aleiiioa.components.flags.hierarchy.TargeterFlag;

import aleiiioa.components.flags.physics.TopDownPhysicsFlag;
import aleiiioa.components.flags.physics.DynamicBodyFlag;
import aleiiioa.components.flags.physics.KinematicBodyFlag;
import aleiiioa.components.flags.physics.PlateformerPhysicsFlag;
import aleiiioa.components.logic.GrappleComponent;
import aleiiioa.components.flags.hierarchy.ChildFlag;
import aleiiioa.components.flags.logic.CatchableFlag;
import aleiiioa.components.flags.hierarchy.MasterFlag;
import aleiiioa.components.logic.InteractiveComponent;
import aleiiioa.components.logic.ActionComponent;
import h3d.Vector;
import echoes.Entity;

import aleiiioa.components.core.InputComponent;
import aleiiioa.components.flags.logic.*;
import aleiiioa.components.flags.collision.*;

import aleiiioa.components.particules.*;
import aleiiioa.components.dialog.*;

import aleiiioa.components.core.camera.*;
import aleiiioa.components.core.rendering.*;
import aleiiioa.components.core.velocity.*;
import aleiiioa.components.core.position.*;
import aleiiioa.components.core.collision.*;



class EntityBuilders {    

    public static function pnj(cx:Int,cy:Int,yarnDialogName:String) {
        //Physics Component
        var pos = new GridPosition(cx,cy);
        var vas = new VelocityAnalogSpeed(0,0);
        var vc  = new VelocityComponent(true);
        var cl  = new CollisionsListener();
        
        //Rendering Component
        var spr = new SpriteComponent(D.tiles.fxCircle15);
        var sq  = new SquashComponent();
        var se  = new SpriteExtension();
        se.baseColor = new Vector(0.3,0.8,0.6);

        //Logic and Dialog Component
        var ic    = new InteractiveComponent();
        var em    = new EmitterComponent();
        var yarn  = new DialogReferenceComponent(yarnDialogName,pos.attachX,pos.attachY);
        
        //Flags
        var pnj   = new PNJFlag();
        var body  = new BodyFlag();   
        var catchable = new CatchableFlag();
        
        
        new echoes.Entity().add(pos,vas,vc,cl,spr,sq,se,ic,em,yarn,pnj,body,catchable);
        // Uncomment next entity creation and comment previous one to remove catchable behavior 
        // new echoes.Entity().add(pos,vas,vc,cl,spr,sq,se,ic,em,yarn,pnj,body);
    }

    public static function spawnPoint(cx:Int,cy:Int) {
        //Physics Component
        var pos = new GridPosition(cx,cy);
        var cl  = new CollisionsListener();
        
        //Rendering Component
        var spr = new SpriteComponent(D.tiles.Square);
        spr.pivot.setCenterRatio(0.5,0.5);
        var sq  = new SquashComponent();
        var se  = new SpriteExtension();
        var bb  = new BoundingBox(spr);
        se.baseColor = new Vector(0.3,0.3,0.9);

        var spp = new SpawnerPointComponent();
        
        new echoes.Entity().add(pos,cl,spr,sq,se,bb,spp);

    }
    
    public static function chouxPeteur(cx:Int,cy:Int) {

        //Physics Component
        var pos = new GridPosition(cx,cy);
        var vas = new VelocityAnalogSpeed(0,0);
        var vc  = new VelocityComponent(true);
        var cl  = new CollisionsListener();
        
        //Rendering Component
        var spr = new SpriteComponent(D.tiles.fxCircle15);
        spr.pivot.setCenterRatio(0.5,0.5);
        var sq  = new SquashComponent();
        var se  = new SpriteExtension();
        se.baseColor = new Vector(0.3,0.2,0.8);
        var bb  = new BoundingBox(spr);

        //Logic and Dialog Component
        var ic    = new InteractiveComponent();
        var em    = new EmitterComponent();
        
        //Flags
        var body = new BodyFlag(); 
        var bomb = new BombFlag();
        var catchable = new CatchableFlag();
        var plateformer = new PlateformerPhysicsFlag();
        var kinematic = new KinematicBodyFlag();
        
        
        new echoes.Entity().add(pos,vas,vc,cl,spr,sq,bb,se,ic,em,body,bomb,catchable,plateformer,kinematic);
    }

    public static function gille(cx:Int,cy:Int) {

        //Physics Component
        var rand = M.randRange(1,2);
        var bool:Bool = false;
        
        if(rand >1)
            bool = true;

        var right = bool;

        var pos = new GridPosition(cx,cy);
        var vas = new VelocityAnalogSpeed(0,0);

        if(right){
            pos.cx += 1;
            vas.xSpeed = 1;
        }

        if(!right){
            pos.cx -= 1;
            vas.xSpeed = -1;
        }

        var vc  = new VelocityComponent(true);
        var cl  = new CollisionsListener();
        
        //Rendering Component
        var spr = new SpriteComponent(D.tiles.gille);
        spr.pivot.setCenterRatio(0.5,0.5);
        spr.scale(2);

        var sq  = new SquashComponent();
        var se  = new SpriteExtension();
        se.sprScaleX = 2;
        se.sprScaleY = 2;
        se.baseColor = new Vector(1,1,1);
        var bb  = new BoundingBox(spr);
      

        //Logic and Dialog Component
        var ic    = new InteractiveComponent();
        var em    = new EmitterComponent();
        
        //Flags
        var gille = new GilleFlag();
        gille.right = right;

        var body = new BodyFlag(); 
        var bomb = new BombFlag();
        var catchable = new CatchableFlag();
        var plateformer = new PlateformerPhysicsFlag();
        var kinematic = new KinematicBodyFlag();
        
        
        new echoes.Entity().add(pos,vas,vc,cl,spr,sq,bb,se,ic,body,bomb,catchable,plateformer,kinematic,gille);
    }

    public static function player(cx:Int,cy:Int) {
        
        //Physics Component
        var pos = new GridPosition(cx,cy);
        var vas = new VelocityAnalogSpeed(0,0);
        var vc  = new VelocityComponent(true,true);
        var cl  = new CollisionsListener();
        
        //Hierarchy Component and Flag (to attach any entity depending on player position)
        var mpos   = new MasterGridPosition(cx,cy);
        var tpos   = new TargetGridPosition(cx,cy);
        var master = new MasterFlag();

        //Rendering Component
        var spr = new SpriteComponent(D.tiles.fxCircle15);
        spr.pivot.setCenterRatio(0.5,0.5);
        var sq  = new SquashComponent();
        var se  = new SpriteExtension();
        se.baseColor = new Vector(0.5,0.2,0.6);
        var bb  = new BoundingBox(spr);
        
    

        //Logic and Dialog Component
        var ic = new InteractiveComponent();
        var em = new EmitterComponent();
        var ac = new ActionComponent();
        var inp= new InputComponent();
        
        //Flags
        var body   = new BodyFlag();   
        var player = new PlayerFlag();
        var kinematic = new KinematicBodyFlag();
        var targeted = new TargetedFlag();
        var td = new TopDownPhysicsFlag();

        
        new echoes.Entity().add(pos,vas,vc,cl,tpos,mpos,spr,bb,sq,se,ic,em,ac,inp,body,player,master,kinematic,td,targeted);

        //Grapple 
         
         var mpos   = new MasterGridPosition(cx,cy);
         var master = new MasterFlag();

         //Physics Component
         var pos = new GridPosition(cx,cy+1);
         var vas = new VelocityAnalogSpeed(0,0);
         var vc  = new VelocityComponent(true,true);
         var cl  = new CollisionsListener();
         
         //Hierarchy Component and Flag (to attach any entity depending on player position)

         //Rendering Component
         var spr = new SpriteComponent(D.tiles.fxCircle15);
         spr.pivot.setCenterRatio(0.5,0.5);
         var sq  = new SquashComponent();
         var se  = new SpriteExtension();
         var bb  = new BoundingBox(spr);
         se.baseColor = new Vector(0,0.2,0.2);
         
     
 
         //Logic and Dialog Component
         var ic  = new InteractiveComponent();
         var em  = new EmitterComponent();
         var ac  = new ActionComponent();
         var gr  = new GrappleComponent();
         
         //Flags 
         var body   = new BodyFlag(); 
         var sw     = new DynamicBodyComponent();
         
         var dyn = new DynamicBodyFlag();
         var targeter = new TargeterFlag();  
        

         new echoes.Entity().add(pos,vas,vc,sw,cl,tpos,mpos,master,spr,bb,gr,sq,se,ic,em,ac,inp,body,dyn,targeter);


    }

    
    public static function cameraFocus(cx:Int,cy:Int) {
        
        var pos  = new GridPosition(cx,cy);
        var vas = new VelocityAnalogSpeed(0,0);
        var vc  = new VelocityComponent(false,true);


        var spr = new SpriteComponent(D.tiles.Square);
        var se  = new SpriteExtension();
        se.baseColor = new Vector(1,0,0,1);
    
        
        var foc = new CameraFocusComponent();
        vas.ySpeed = foc.cameraScrollingSpeed;

        var focus = new echoes.Entity().add(foc,pos,vas,vc,spr,se);
        return focus;
    }

}

