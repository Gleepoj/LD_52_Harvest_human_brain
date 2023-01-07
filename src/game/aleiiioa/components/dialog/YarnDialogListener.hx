package aleiiioa.components.dialog;

import dn.Cooldown;
import aleiiioa.systems.dialog.DialogEvent;

class YarnDialogListener {
    
    public var cd:Cooldown;

    public var events = new InstancedDialogEvent();
    public var lastEvent:DialogEvent;
    public var newEvent:DialogEvent;

    public var lastText:String;
    
    public var text:String;
    public var option:Array<String>;
    public var selector:Int;

    public var attachX:Float;
    public var attachY:Float;
    
    public var onStep(get,never):Bool;
        inline function get_onStep() return lastText != text; 
        
    public var onEvent(get,never):Bool;
        inline function get_onEvent() return lastEvent != newEvent;

    public var onAsk(get,never):Bool;
        inline function get_onAsk() return cd.has("ask") ;

    public var onSpeak(get,never):Bool;
        inline function get_onSpeak() return cd.has("speak");

    public var onEnd(get,never):Bool;
        inline function get_onEnd() return cd.has("end");
    
    public var onPause(get,never):Bool;
        inline function get_onPause() return  cd.has("pause");

    public var onAnswer(get,never):Bool;
        inline function get_onAnswer() return  cd.has("answer");

    public function new(dr:DialogReferenceComponent) {
        lastEvent = null;
        newEvent = null;
        attachX = dr.attachX;
        attachY = dr.attachY;
        cd = new Cooldown(Const.FIXED_UPDATE_FPS);
    }
}
