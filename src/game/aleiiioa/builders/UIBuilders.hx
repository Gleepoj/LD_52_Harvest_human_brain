package aleiiioa.builders;

import aleiiioa.components.flags.logic.FixedDebugLabel;
import aleiiioa.components.core.position.GridPosition;
import aleiiioa.components.core.rendering.DebugLabel;
import aleiiioa.components.dialog.DialogReferenceComponent;
import aleiiioa.components.dialog.UIBubble;
import aleiiioa.components.dialog.UIOption;
import aleiiioa.components.dialog.UIDialog;

import aleiiioa.components.dialog.YarnDialogConponent;
import aleiiioa.components.dialog.YarnDialogListener;

import aleiiioa.components.ui.UICheckComponent;
import aleiiioa.components.ui.UISliderComponent;

class UIBuilders {
    
    ////////ACTORS////////////////
        public static function slider(label : String, get : Void -> Float, set : Float -> Void, min : Float = 0., max : Float = 1.) {
            var usc = new UISliderComponent(label,get,set,min,max);
            new echoes.Entity().add(usc);
        }

        public static function debugFloat(float:Float,cx:Int,cy:Int){
            var dl = new DebugLabel();
            var gp = new GridPosition(cx,cy);
            var fl = new FixedDebugLabel();
            dl.v = float;

            new echoes.Entity().add(dl,gp,fl);
        }

        public static function check(label : String, get : Void -> Bool, set : Bool -> Void) {
            var ucc = new UICheckComponent(label,get,set);
            new echoes.Entity().add(ucc);
        }

        public static function dialogEntity(_yarnFile:DialogReferenceComponent){
            
            var ydc = new YarnDialogConponent(_yarnFile);
            var ydl = new YarnDialogListener(_yarnFile);

            var ui    = new UIDialog();
            var uiBub = new UIBubble();
            var uiOpt = new UIOption();

            new echoes.Entity().add(ydc,ydl,ui,uiBub,uiOpt);
        }
    }