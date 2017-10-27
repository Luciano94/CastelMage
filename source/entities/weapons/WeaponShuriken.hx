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
		speed = Reg.weaponNormalSpeed;
		acceleration.y = Reg.gravity;
		loadGraphic(AssetPaths.weaponShuriken__png, false, 14, 14);
	}
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		angularVelocity = 720;
		if (facing == FlxObject.RIGHT)
		{
			velocity.x = Reg.weaponBNormalSpeed;
			angularVelocity = 1540;
		}
		else
		{
			velocity.x = -Reg.weaponBNormalSpeed;
			angularVelocity = -1540;
		}
		
		checkBoundaries();
	}
	override public function reset(X:Float, Y:Float):Void 
	{
		super.reset(X, Y);
		
		velocity.y = Reg.weaponYSpeed;
	}
	
	private function checkBoundaries():Void 
	{
		if (x < camera.scroll.x || x > camera.scroll.x + FlxG.width || y < camera.scroll.y || y > camera.scroll.y + FlxG.height)
			kill();
	}
}