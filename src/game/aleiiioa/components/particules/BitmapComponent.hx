package aleiiioa.components.particules;

import h2d.BlendMode;
import h2d.Tile;
import aleiiioa.shaders.SmokeShader.SmokeShader;
import h2d.Bitmap;


class BitmapComponent {
    
    public var bitmap:Bitmap;
    public var shader:SmokeShader;

    
    public function new(_asset:Tile,?_scale:Float = 1,?_rotate:Float = null,?_seed:Int = 0,?_blend:BlendMode = Alpha) {
        
        var tile = _asset;
        tile = tile.center();

        bitmap = new h2d.Bitmap(tile);
        var tex =  bitmap.tile.getTexture();
        var ran = M.randRange(1,2);
       
        if(_seed != 0)
            ran = _seed;

        var ratio = 1;
        
        shader = new SmokeShader(tex,ran,ratio);
        
        bitmap.addShader(shader);
        bitmap.blendMode = _blend;
        
        bitmap.scaleX *= _scale;
        bitmap.scaleY *= _scale;   
        
        if(_rotate == null)
           bitmap.rotate((M.frandRange(-Math.PI*2,Math.PI*2)));
        
        if(_rotate != null)
            bitmap.rotate(_rotate);

        
         
    }
}