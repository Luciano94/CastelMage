package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

class Box extends FlxSprite 
{
	public function new(X:Float, Y:Float, Width:Int, Height:Int) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.normalAttack__png, true, 30, 12);
		width = Width;
		height = Height;
		animation.add("normalAttack", [0, 1, 2, 3, 4, 5], 18, false);
		animation.play("normalAttack");
	}
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		animation.play("normalAttack");
	}
}