package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxObject;

class WeaponN extends FlxSprite 
{
	public function new(X:Float, Y:Float) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.normalAttack__png, true, 30, 12);
		animation.add("normalAttack", [0, 1, 2, 3, 4, 5], 18, false);
		animation.play("normalAttack");
		
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.LEFT, true, false);
	}
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		animation.play("normalAttack");
	}
}