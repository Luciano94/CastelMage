package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxObject;

/**
 * ...
 * @author Aleman5
 */
class WeaponSpear extends FlxSprite 
{
	private var speed:Int;

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		speed = Reg.weaponNormalSpeed;
		loadGraphic(AssetPaths.weaponSpear__png, true, 30, 12);
		animation.add("wp1", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,
							  14, 15, 16, 17, 18, 19, 20, 21], 88, false);
		animation.play("wp1");
	}
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		animation.play("wp1");
		if (facing == FlxObject.RIGHT)
			velocity.x = speed;
		else
			velocity.x = -speed;
	}
}