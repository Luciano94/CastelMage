package entities.weapons;

import entities.WeaponBase;
import flixel.FlxObject;

class WeaponSpear extends WeaponBase 
{
	private var speed:Int;
	private var initialPoint:Float;
	private var maxDistance:Int;

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
		speed = Reg.weaponSpeNormalSpeed;
		maxDistance = Reg.weaponSpeMaxDistance;
		initialPoint = 0;
		loadGraphic(AssetPaths.weaponSpear__png, true, 30, 12);
		animation.add("wp1", [21], 44, false);
		animation.play("wp1");
	}
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		checkTravel();
	}
	override public function reset(X:Float, Y:Float):Void 
	{
		super.reset(X, Y);
		
		animation.play("wp1");
		initialPoint = X;
	}
	
	private function checkTravel():Void 
	{
		if (facing == FlxObject.RIGHT)
		{
			velocity.x = speed;
			if (x - initialPoint >= maxDistance)
				kill();
		}
		else
		{
			velocity.x = -speed;
			if (x - initialPoint <= -maxDistance)
				kill();
		}
	}
	
	override public function getType():String
	{
		return "Spear";
	}
}