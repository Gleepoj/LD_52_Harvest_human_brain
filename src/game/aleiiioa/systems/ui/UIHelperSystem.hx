package aleiiioa.systems.ui;

import aleiiioa.components.core.position.GridPosition;
import aleiiioa.components.ui.UIMessageComponent;
import aleiiioa.components.ui.UICheckComponent;
import aleiiioa.components.ui.UISliderComponent;


//SAMPLE USAGE // Could be use everywhere in code 
        
//UIBuild.slider("Speed", function() return speed, function(v) speed = v, 0, 10);
//UIBuild.check("Button", function() return button, function(v)  button = v );

class UIHelperSystem extends echoes.System {
    
    var fui : h2d.Flow;
    
    public function new() {
        
        var helper = new h2d.Layers();
        Game.ME.root.add(helper,Const.DP_UI);
		helper.name = "Hud system";
		
        fui = new h2d.Flow(helper);
        
        fui.layout = Vertical;
        fui.verticalSpacing = 5;
        fui.padding = 10;
        
    }

    private function getFont() {
        return hxd.res.DefaultFont.get();
    }

    @a public function onSliderAdded(usc:UISliderComponent){
        
        var f = new h2d.Flow(fui);
        
        f.horizontalSpacing = 5;
    
        var tf = new h2d.Text(getFont(), f);
        tf.text = usc.label;
        tf.maxWidth = 70;
        tf.textAlign = Right;
    
        var sli = new h2d.Slider(100, 10, f);
        sli.minValue = usc.min;
        sli.maxValue = usc.max;
        sli.value = usc.get();

        var tf = new h2d.TextInput(getFont(), f);
        tf.text = "" + hxd.Math.fmt(sli.value);
        sli.onChange = function() {
            usc.set(sli.value);
            tf.text = "" + hxd.Math.fmt(sli.value);
            f.needReflow = true;
        };
        tf.onChange = function() {
            var v = Std.parseFloat(tf.text);
            if( Math.isNaN(v) ) return;
            sli.value = v;
            usc.set(v);
        };
    }

    @a  function onMessageAdded(m:UIMessageComponent){
              
        m.flow = new h2d.Flow(fui);
    
        var tile = Assets.tiles.getTile(D.tiles.uiBar);
		m.bubble = new dn.heaps.FlowBg(tile, 2,m.flow);
        
        m.bubble.paddingHorizontal = 20;
        m.bubble.paddingVertical = 20;
        m.bubble.setPosition(400,20);
        m.bubble.colorizeBg(0x6A0ED3);
        m.bubble.alpha = 1;
      
        m.text = new h2d.Text(getFont(),m.bubble);
        m.text.text = m.message;
    }

    @u  function updateMassage(m:UIMessageComponent){
        m.text.text = m.message;
    }

    @a  function onCheckAdded(ucc:UICheckComponent) {
            var f = new h2d.Flow(fui);
    
            f.horizontalSpacing = 5;
    
            var tf = new h2d.Text(getFont(), f);
            tf.text = ucc.label;
            tf.maxWidth = 70;
            tf.textAlign = Right;
    
            var size = 10;
            var b = new h2d.Graphics(f);
           
            function redraw() {
                b.clear();
                b.beginFill(0x808080);
                b.drawRect(0, 0, size, size);
                b.beginFill(0);
                b.drawRect(1, 1, size-2, size-2);
                if( ucc.get() ) {
                    b.beginFill(0xC0C0C0);
                    b.drawRect(2, 2, size-4, size-4);
                }
            }

            var i = new h2d.Interactive(size, size, b);
            i.onClick = function(_) {
                ucc.set(!ucc.get());
                redraw();
            };
            redraw();
        }
    
}

 