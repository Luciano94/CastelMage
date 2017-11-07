package entities.weapons;

import entities.WeaponBase;
import flixel.FlxG;
import flixel.FlxObject;

class WeaponShuriken extends WeaponBase 
{
	private var speed:Int;

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		speed = Reg.weaponSpeNormalSpeed;
		acceleration.y = Reg.gravity;
		loadGraphic(AssetPaths.weaponShuriken__png, false, 14, 14);
	}
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		checkTravel();
		checkBoundaries();
	}
	override public function reset(X:Float, Y:Float):Void 
	{
		super.reset(X, Y);
		
		velocity.y = Reg.weaponShuYSpeed;
	}
	
	private function checkBoundaries():Void 
	{
		if (y > camera.scroll.y + FlxG.height)
			kill();
	}
	
	private function checkTravel():Void 
	{
		//angularVelocity = 720;
		if (facing == FlxObject.RIGHT)
		{
			velocity.x = speed;
			angularVelocity = 1540;
		}
		else
		{
			velocity.x = -speed;
			angularVelocity = -1540;
		}
	}
	
	override public function getType():String
	{
		return "Shuriken";
	}
}