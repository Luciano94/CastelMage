package entities.weapons;

import entities.WeaponBase;
import flixel.FlxObject;

class WeaponPotion extends WeaponBase 
{
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		acceleration.y = Reg.gravity;
		loadGraphic(AssetPaths.weaponPotion__png, true, 33, 10);
		animation.add("flying", [0]);
		animation.add("dying", [1, 2, 3, 4], 8);
		
	}
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		if (animation.name == "flying")
		{
			velocity.x = Reg.weaponPotNormalSpeed;
			if (y == camera.)
				animation.play("dying");
		}
		else
		{
			velocity.y = 0;
			velocity.x = 0;
			if (animation.finished)
				kill();
		}
	}
	override public function reset(X:Float, Y:Float):Void 
	{
		super.reset(X, Y);
		animation.play("flying");
		velocity.y = Reg.weaponPotYSpeed;
	}
}