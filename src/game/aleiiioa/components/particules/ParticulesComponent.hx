package aleiiioa.components.particules;

import aleiiioa.shaders.SmokeShader.SmokeShader;
import h2d.Bitmap;
import dn.Cooldown;

class ParticulesComponent {
    
    public var bitmap:Bitmap;
    public var shader:SmokeShader;
    
    public var cd:Cooldown;
    public var lifetime:Float;
    
    public var shrink:Float;
    public var rotation:Float = Math.PI*1/60;
    
    public var scaleX:Float=1;
    public var scaleY:Float=1;
    
    public var alpha  :Float  =1;
    
    public var collide:Bool  =true;
    public var gravity:Float =0.;
    public var frict:Float   =0.;

    public var lifeRatio(get,never):Float; inline function get_lifeRatio() return cd.getRatio("alive");
   
    public function new(_lifetime:Float,?_collide:Bool=false,?_frict:Float=0,?_gravity:Float=0) {
        
        lifetime= _lifetime;
        collide = _collide;
        frict   = _frict;
        gravity = _gravity;
        shrink  = 1/lifetime;

        cd = new Cooldown(Const.FPS);
        cd.setS("alive",lifetime);
       
    }
}