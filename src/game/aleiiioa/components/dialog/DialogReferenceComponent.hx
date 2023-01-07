package aleiiioa.components.dialog;

class DialogReferenceComponent {
    public var reference:String;
    public var res:hxd.res.Any;
    public var attachX:Float;
    public var attachY:Float;
    
    public function new(yarnFileName:String,x:Float,y:Float) {
        reference = yarnFileName;
        //trace(yarnFileName);
        var path:String = "yarn/"+yarnFileName+".yarn";
        res = hxd.Res.loader.load(path); 
        attachX = x;
        attachX = y; 
    }
}