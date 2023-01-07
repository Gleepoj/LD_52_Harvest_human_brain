package aleiiioa.systems.dialog;

import aleiiioa.components.dialog.DialogReferenceComponent;
import h2d.Flow;
import dn.heaps.FlowBg;
import h2d.Flow.FlowLayout;
import h2d.Flow.FlowAlign;

import aleiiioa.components.dialog.YarnDialogListener;
import aleiiioa.components.dialog.UIOption;
import aleiiioa.components.dialog.UIDialog;
import aleiiioa.components.dialog.UIBubble;


class DialogUISystem extends echoes.System {
    
    
    public function new() {
        
    }

    @a public function onBubbleAdded(udc:UIDialog,b:UIBubble,ydl:YarnDialogListener){
        
        b.flow = new h2d.Flow(udc.dialogLayer);
        b.flow.setPosition(ydl.attachX,ydl.attachY + Game.ME.scroller.y);

        b.flow.layout = Vertical;
        b.flow.multiline = true;
        b.flow.reverse = true;
        b.flow.verticalSpacing = 5;
        b.flow.padding = 10;
    
        
        var tile = Assets.tiles.getTile(D.tiles.uiBar);
		b.bubble = new dn.heaps.FlowBg(tile, 2,b.flow);
        
        b.bubble.horizontalSpacing = 5;
        b.bubble.paddingHorizontal = 20;
        b.bubble.paddingVertical = 20;
        b.bubble.colorizeBg(0xA26AE3);

        b.text = new h2d.Text(getFont(),b.bubble);

    }

    
    @a public function onOptionFlowAdded(ud:UIDialog,o:UIOption){
        
        o.flow = new h2d.Flow(ud.dialogLayer);

        o.flow.layout = Horizontal;
        o.flow.multiline = true;
        o.flow.verticalSpacing = 5;
        o.flow.padding = 10;
    }

    @u public function updateDialogText(ydl:YarnDialogListener,b:UIBubble,o:UIOption) {
        
        if(ydl.onSpeak && b.text.text != ydl.text){
            b.bubble.removeChild(b.text);
            b.text = new h2d.Text(getFont(),b.bubble);
            b.text.text = ydl.text;
            b.text.maxWidth = 300;
            b.text.textAlign = Left; 
            b.bubble.reflow();    
        }

        if(ydl.onAsk && ydl.onEvent){
           o.flow.setPosition(b.flow.x,b.flow.y +b.flow.outerHeight);

           for (choice in ydl.option){
                newOptionBubble(choice,o,b);
           }        
           ydl.cd.setS("pause",0.3);
        }
        
        if(ydl.onAnswer && !ydl.onPause){
            o.flow.removeChildren();
            o.bubbles = new Array<FlowBg>();
            ydl.cd.setS("pause",0.3);
        }
    }

    private function getFont() {
        return hxd.res.DefaultFont.get();
    }

    public function newOptionBubble(text:String,o:UIOption,b:UIBubble){
       
        var tile = Assets.tiles.getTile(D.tiles.uiBar);
		var f = new dn.heaps.FlowBg(tile,2,o.flow);
		
        f.horizontalSpacing = 5;
        f.paddingHorizontal = 20;
        f.paddingVertical = 20;
        
        f.colorizeBg(0xA56FF7);
        
        f.reverse = true;
        f.horizontalAlign = FlowAlign.Right;
        f.layout = FlowLayout.Horizontal; 
    

        var tf = new h2d.Text(getFont(), f);
        tf.text = text;
        tf.maxWidth = 300;
        tf.textAlign = Left;

        o.bubbles.push(f);
    }

    @u function colorizeOption(o:UIOption,yl:YarnDialogListener){
        
        for(bubble in o.bubbles){
            bubble.colorizeBg(0xA56FF7);
        }

        if(o.bubbles.length > 0){
            if(yl.selector < o.bubbles.length)
                o.bubbles[yl.selector].colorizeBg(0xFF6F44);
        }

    }

    
    @r function onRemoveBubble(b:UIBubble){
        b.flow.removeChildren();
    }

    @r function onRemoveOption(o:UIOption){
        o.flow.removeChildren();
    }

}

 