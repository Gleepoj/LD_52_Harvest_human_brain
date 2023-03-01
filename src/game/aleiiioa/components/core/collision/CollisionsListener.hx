package aleiiioa.components.core.collision;


import dn.Cooldown;
import aleiiioa.systems.collisions.CollisionEvent;


class CollisionsListener {
    //public var onPnjArea:Bool = false;
    public var cd:Cooldown;
    
    public var lastEvent:CollisionEvent;

    public var on_land:Bool   = false;
    public var on_ground:Bool = false;
    public var on_left:Bool   = false;
    public var on_right:Bool  = false;
    public var on_ceil:Bool   = false;
    public var on_fall:Bool   = false;
    public var on_jump:Bool   = false;
    public var on_east:Bool   = false;
    public var on_west:Bool   = false;
    public var on_bounce:Bool = false;
    public var on_hit_vertical:Bool = false;
    public var on_hit_horizontal:Bool = false;
    
    public var onShoot(get,never):Bool;
        inline function get_onShoot() return cd.has("shoot");

    public var onInteract(get,never):Bool;
        inline function get_onInteract() return cd.has("interact");

    public var onDroneInteractLauncher(get,never):Bool;
        inline function get_onDroneInteractLauncher() return cd.has("drone_launcher");

    public var onContact(get,never):Bool;
        inline function get_onContact() return cd.has("contact");

    public var onContactDoor(get,never):Bool;
        inline function get_onContactDoor() return cd.has("contact_door");

    public var onSwallowGille(get,never):Bool;
        inline function get_onSwallowGille() return cd.has("swallow_gille");

    public var onSwallowJohn(get,never):Bool;
        inline function get_onSwallowJohn() return cd.has("swallow_john");
    
    public var onArea(get,never):Bool;
        inline function get_onArea() return cd.has("pnj ready");

    public var onBounce(get,never):Bool;
        inline function get_onBounce() return cd.has("bounce") ;

    public var onHitVertical(get,never):Bool;
        inline function get_onHitVertical() return cd.has("hit_vertical") ;

    public var onHitHorizontal(get,never):Bool;
        inline function get_onHitHorizontal() return cd.has("hit_horizontal") ;

    public var recentlyOnGround(get,never):Bool;
        inline function get_recentlyOnGround() return cd.has("recentlyOnGround");
    
    public var onLanding(get,never):Bool;
        inline function get_onLanding() return cd.has("landing");

    public var onGround(get,never):Bool;
        inline function get_onGround() return on_ground;
     
    public var onLeft(get,never):Bool;
        inline function get_onLeft() return on_left;
    
    public var onRight(get,never):Bool;
        inline function get_onRight() return on_right;
    
    public var onCeil(get,never):Bool;
        inline function get_onCeil() return on_ceil;
    
    public var onFall(get,never):Bool;
        inline function get_onFall() return on_fall;
    
    public var onJump(get,never):Bool;
        inline function get_onJump() return on_jump;
    
    public var onEast(get,never):Bool;
        inline function get_onEast() return on_east;
    
    public var onWest(get,never):Bool;
        inline function get_onWest() return on_west;

    public var onSouth(get,never):Bool;
        inline function get_onSouth() return on_fall;
    
    public var onNorth(get,never):Bool;
        inline function get_onNorth() return on_jump;
   
    
    public function new(){
        lastEvent = new Event_Reset();
        cd = new Cooldown(Const.FIXED_UPDATE_FPS);
    }
}