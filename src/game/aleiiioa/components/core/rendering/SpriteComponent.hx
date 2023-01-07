package aleiiioa.components.core.rendering;


@:forward
abstract SpriteComponent(HSprite) from HSprite to HSprite {
     
    public inline function new(spriteStr:String) {
        this = new HSprite(Assets.tiles);
        this.set(spriteStr);
    }

}
