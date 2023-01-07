package aleiiioa.components.particules;

import ldtk.Entity;
import h2d.Bitmap;
import h2d.SpriteBatch.BatchElement;
import h2d.Tile;

class EmitterComponent {
    
    public var cd:dn.Cooldown;
    public var tick:Float = 10;

    public var layer  : h2d.Layers;
    public var nbParticules: Int = 0;
    public var maxParticules:Int = 5000;

    public function new() {
        cd = new dn.Cooldown(Const.FPS);

        layer = new h2d.Layers();
        Game.ME.scroller.add(layer,Const.DP_BG);
		layer.name = "VFX";    
    }

    public function addBitmap(en:echoes.Entity) {
        var b = en.get(BitmapComponent);
        layer.add(b.bitmap);
    }

}