package entities.weapons;

import entities.WeaponBase;
import flixel.FlxObject;
/**
 * ...
 * @author Aleman5
 */
class WeaponSpear extends WeaponBase 
{
	private var speed:Int;
	private var initialPoint:Float;

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		speed = Reg.weaponNormalSpeed;
		initialPoint = 0;
		loadGraphic(AssetPaths.weaponSpear__png, true, 30, 12);
		animation.add("wp1", [/*0, 2, 4, 6, 8, 10, 12, 14, 16, 18, */20], 44, false);
		/*animation.add("wp1", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,
							  14, 15, 16, 17, 18, 19, 20, 21], 88, false);*/
		animation.play("wp1");
	}
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		if (facing == FlxObject.RIGHT)
		{
			velocity.x = speed;
			if (x - initialPoint >= Reg.weaponMaxDistance)
				kill();
		}
		else
		{
			velocity.x = -speed;
			if (x - initialPoint <= -Reg.weaponMaxDistance)
				kill();
		}
	}
	override public function reset(X:Float, Y:Float):Void 
	{
		super.reset(X, Y);
		animation.play("wp1");
		initialPoint = X;
	}
}