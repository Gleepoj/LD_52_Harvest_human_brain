package aleiiioa.systems.dialog;

import aleiiioa.components.dialog.YarnDialogListener;
import aleiiioa.components.dialog.YarnDialogConponent;

class DialogYarnSystem extends echoes.System {
    public function new() {
        
    }

    @a function onDialogAdded(yd:YarnDialogConponent,yl:YarnDialogListener) {
        yd.start();
    }

    @u function updateDialogListener(dt:Float,ydial:YarnDialogConponent,yl:YarnDialogListener) {
        yl.cd.update(dt);
        
        yl.lastEvent = yl.newEvent;
        yl.lastText = yl.text;
       
        yl.newEvent = ydial.currentEvent;
        yl.option = ydial.currentOptions;
        yl.text = ydial.currentText;

        if(yl.onStep || yl.onEvent){
            orderListener(yl);
        }
    }
    
    function orderListener(yl:YarnDialogListener){
        yl.newEvent.send(yl);
    }
}
