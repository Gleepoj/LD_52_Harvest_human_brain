package aleiiioa.builders;



import aleiiioa.components.logic.BonhommeComponent;
import aleiiioa.shaders.PaletteShader;
import haxe.ds.Map;
import aleiiioa.components.logic.ContainerComponent;
import aleiiioa.components.logic.ContainerSharedComponent;
import aleiiioa.components.logic.DigesterSharedComponent;
import aleiiioa.components.logic.DoorComponent;
import aleiiioa.components.tools.DigesterFSM;
import aleiiioa.components.tools.GrappleFSM;
import aleiiioa.components.tools.LauncherFSM;
import aleiiioa.components.logic.StaticBouleComponent;
import aleiiioa.components.logic.StaticBrainComponent;
import aleiiioa.components.logic.LauncherComponent;
import hxd.Math;
import aleiiioa.components.logic.SpawnerPointComponent;
import aleiiioa.components.flags.hierarchy.TargetedFlag;
import aleiiioa.components.flags.hierarchy.TargeterFlag;

import aleiiioa.components.flags.physics.TopDownPhysicsFlag;
import aleiiioa.components.flags.physics.DynamicBodyFlag;
import aleiiioa.components.flags.physics.KinematicBodyFlag;
import aleiiioa.components.flags.physics.PlateformerPhysicsFlag;
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

    public static function boule(cx:Int,cy:Int,id:Int) {
        //Physics Component
        var pos = new GridPosition(cx,cy);
        var cl  = new CollisionsListener();
        
        //Rendering Component
        var spr = new SpriteComponent(D.tiles.gille_boule);
        spr.pivot.setCenterRatio(0.5,0.5);
        //spr.visible = false;
        var sq  = new SquashComponent();
        var se  = new SpriteExtension();
        var bb  = new BoundingBox(spr);
        se.baseColor = new Vector(1,1,1);

        var boule = new StaticBouleComponent(id);
        //var spp = new SpawnerPointComponent();
        
        new echoes.Entity().add(pos,cl,spr,sq,se,bb,boule);

    }

    public static function brain(cx:Int,cy:Int,id:Int) {
        //Physics Component
        var pos = new GridPosition(cx,cy);
        var cl  = new CollisionsListener();
        
        //Rendering Component
        var spr = new SpriteComponent(D.tiles.brain);
        spr.pivot.setCenterRatio(0.5,0.5);
        //spr.visible = false;
        var sq  = new SquashComponent();
        var se  = new SpriteExtension();
        var bb  = new BoundingBox(spr);
        se.baseColor = new Vector(1,1,1);

        var brain = new StaticBrainComponent(id);
        var dl = new DebugLabel();
        
  
        //var spp = new SpawnerPointComponent();
        
        new echoes.Entity().add(pos,cl,spr,sq,se,bb,brain,dl);

    }

    
    
    public static function spawnPoint(cx:Int,cy:Int) {
        //Physics Component
        var pos = new GridPosition(cx,cy);
        var cl  = new CollisionsListener();
        
        //Rendering Component
        var spr = new SpriteComponent(D.tiles.Square);
        spr.pivot.setCenterRatio(0.5,0.5);
        spr.visible = false;
        var sq  = new SquashComponent();
        var se  = new SpriteExtension();
        var bb  = new BoundingBox(spr);
        se.baseColor = new Vector(0.3,0.3,0.9);

        var spp = new SpawnerPointComponent();
        
        new echoes.Entity().add(pos,cl,spr,sq,se,bb,spp);

    }

    public static function methanizer(cx:Int,cy:Int) {
        //Physics Component
        var pos = new GridPosition(cx,cy);
        var cl  = new CollisionsListener();
        var dsc = new DigesterSharedComponent();
        var container_shared = new ContainerSharedComponent();
        
        //Rendering Component
        var spr = new SpriteComponent(D.tiles.methanizer);
        spr.pivot.setCenterRatio(0.5,0.5);
        
        var sq  = new SquashComponent();
        var se  = new SpriteExtension();
        var bb  = new BoundingBox(spr);

        spr.scale(0.5);
        se.sprScaleX = 0.5;
        se.sprScaleY = 0.5;

        se.baseColor = new Vector(0.05,0.5,0.05);

        var digester = new DigesterFSM();
        var dl = new DebugLabel();
        
        
        new echoes.Entity().add(pos,cl,spr,sq,se,bb,digester,dsc,container_shared,dl);

        // MOUTH
        var pos = new GridPosition(cx,cy-1);
        var cl  = new CollisionsListener();
        
        var spr = new SpriteComponent(D.tiles.fxCircle15);
        var sq  = new SquashComponent();
        var se  = new SpriteExtension();
        
        spr.pivot.setCenterRatio(0.5,0.5);
        //spr.scale(2);
        //se.sprScaleX = 2;
        //se.sprScaleY = 2;
        se.baseColor = new Vector(0.3,0.1,0.6);
        
        var bb  = new BoundingBox(spr);
        
        var door = new DoorComponent();

        new echoes.Entity().add(pos,cl,spr,sq,se,bb,door,dsc,container_shared);

        //CONTAINER
        var pos = new GridPosition(cx,cy +2);
        var cl  = new CollisionsListener();
        
        var spr = new SpriteComponent(D.tiles.fxCircle15);
        var sq  = new SquashComponent();
        var se  = new SpriteExtension();
        spr.pivot.setCenterRatio(0.5,0.5);
        se.baseColor = new Vector(0.9,0.1,0.6);
        spr.scale(0.5);
        se.sprScaleX = 0.5;
        se.sprScaleY = 0.5;
        var bb  = new BoundingBox(spr);
        
        var container = new ContainerComponent(3);

        new echoes.Entity().add(pos,cl,spr,sq,se,bb,container,container_shared);

        var pos = new GridPosition(cx,cy + 3);
        var cl  = new CollisionsListener();
        
        var spr = new SpriteComponent(D.tiles.fxCircle15);
        var sq  = new SquashComponent();
        var se  = new SpriteExtension();
        spr.pivot.setCenterRatio(0.5,0.5);
        se.baseColor = new Vector(0.8,0.1,0.6);
        spr.scale(0.5);
        se.sprScaleX = 0.5;
        se.sprScaleY = 0.5;
        var bb  = new BoundingBox(spr);
        
        var container = new ContainerComponent(2);

        new echoes.Entity().add(pos,cl,spr,sq,se,bb,container,container_shared);

        var pos = new GridPosition(cx,cy + 4);
        var cl  = new CollisionsListener();
        
        var spr = new SpriteComponent(D.tiles.fxCircle15);
        var sq  = new SquashComponent();
        var se  = new SpriteExtension();
        spr.pivot.setCenterRatio(0.5,0.5);
        se.baseColor = new Vector(0.7,0.1,0.6);
        spr.scale(0.5);
        se.sprScaleX = 0.5;
        se.sprScaleY = 0.5;
        var bb  = new BoundingBox(spr);
        
        var container = new ContainerComponent(1);

        new echoes.Entity().add(pos,cl,spr,sq,se,bb,container,container_shared);


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
        
        var pos = new GridPosition(cx,cy);
        var vas = new VelocityAnalogSpeed(0,0);
        
        
        //Physics Component
        var rdir = M.randRange(1,2);
        var rcolor = M.randRange(1,2);
        
        if(rdir == 2)
            rdir = -1;

        if(rcolor ==2)
            rcolor = -1;

        var dir = rdir;
        var color = rcolor;

        var bonhomme = new BonhommeComponent(dir,color);

        var vc  = new VelocityComponent(true);
        var cl  = new CollisionsListener();
        
        //Rendering Component
        var spr = new SpriteComponent(D.tiles.gille);
        spr.pivot.setCenterRatio(0.5,0.5);
        //spr.scale(1);

        var sq  = new SquashComponent();
        var se  = new SpriteExtension();
        //se.sprScaleX = 2;
        //se.sprScaleY = 2;
        se.baseColor = new Vector(1,1,1);
        var bb  = new BoundingBox(spr);      


        //Logic and Dialog Component
        var ic    = new InteractiveComponent();
        
        //Flags
        //gille.right = color;

        if(color == -1){
            var colorSwap:Map<Int,Int> = new Map();
            colorSwap.set(0x505acc,0xd8ab53);
            colorSwap.set(0x4d5182,0xe2672a);
            colorSwap.set(0x9badb7,0x56baa1);
    
            var shader = new PaletteShader(colorSwap);
            spr.addShader(shader);
            //gille.color = -1;
        }


        var body = new BodyFlag();
        var catchable = new CatchableFlag();
        var plateformer = new PlateformerPhysicsFlag();
        var kinematic = new KinematicBodyFlag();
        
        var dl = new DebugLabel();
        
        if(bonhomme.color == 1){
           var gille = new GilleFlag();
           new echoes.Entity().add(pos,vas,vc,cl,spr,sq,bb,se,ic,body,catchable,plateformer,kinematic,gille,bonhomme,dl);
        }

             
        if(bonhomme.color == -1){
            var john = new JohnFlag();
            new echoes.Entity().add(pos,vas,vc,cl,spr,sq,bb,se,ic,body,catchable,plateformer,kinematic,john,bonhomme,dl);
         }
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
        var spr = new SpriteComponent(D.tiles.gille);
        spr.pivot.setCenterRatio(0.5,0.5);
        //spr.scale(2.);
       
        var sq  = new SquashComponent();
        var se  = new SpriteExtension();
        //se.sprScaleX = 2.;
        //se.sprScaleY = 2.;

        se.baseColor = new Vector(1,1,1);
        var bb  = new BoundingBox(spr);
        
    

        //Logic and Dialog Component
        var ic = new InteractiveComponent();
        var em = new EmitterComponent();
        var ac = new ActionComponent();
        var inp= new InputComponent();
        var launcher = new LauncherFSM();
        
        //Flags
        var body   = new BodyFlag();   
        var player = new PlayerFlag();
        var kinematic = new KinematicBodyFlag();
        var targeted = new TargetedFlag();
        var td = new TopDownPhysicsFlag();
        var label = new DebugLabel();

        
        new echoes.Entity().add(pos,vas,vc,cl,tpos,mpos,spr,bb,sq,se,ic,em,ac,inp,body,player,master,kinematic,td,launcher,targeted,label);

        /////DRONE////
         
         var mpos   = new MasterGridPosition(cx,cy);
         var master = new MasterFlag();

         //Physics Component
         var pos = new GridPosition(cx,cy+6);
         var vas = new VelocityAnalogSpeed(0,0);
         var vc  = new VelocityComponent(true,true);
         var cl  = new CollisionsListener();
         
         //Hierarchy Component and Flag (to attach any entity depending on player position)

         //Rendering Component
         var spr = new SpriteComponent(D.tiles.drone);
         spr.pivot.setCenterRatio(0.5,0.5);
         var sq  = new SquashComponent();
         var se  = new SpriteExtension();
         var bb  = new BoundingBox(spr);
         se.baseColor = new Vector(1,1,1);
         
         spr.scale(0.7);
         se.sprScaleX = 0.7;
         se.sprScaleY = 0.7;
     
 
         //Logic and Dialog Component
         var ic  = new InteractiveComponent();
         var em  = new EmitterComponent();
         var ac  = new ActionComponent();
         var gr  = new GrappleFSM();
         
         //Flags 
         var body   = new BodyFlag(); 
         var sw     = new DynamicBodyComponent();
         
         var dyn = new DynamicBodyFlag();
         var targeter = new TargeterFlag();
         var label = new DebugLabel();  
        

         new echoes.Entity().add(pos,vas,vc,sw,cl,tpos,mpos,master,spr,bb,gr,sq,se,ic,em,ac,inp,body,dyn,targeter,label);

 
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

