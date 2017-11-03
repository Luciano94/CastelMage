package entities.obstacles;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.system.FlxAssets.FlxGraphicAsset;

class MovingPlatform extends OneWayPlatform 
{
	private var speed:Int;
	private var direction:Int;
	private var xStartUp:Float;
	private var travelDistance:Int;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
		loadGraphic(AssetPaths.movingPlatform__png, true, 48, 16);
		speed = Reg.movingPlatformSpeed;
		travelDistance = Reg.movingPlatformTravelDistance;
		xStartUp = X;
		direction = FlxObject.RIGHT;
		animation.add("PGB", [0, 1, 2], 6, true);
		animation.play("PGB");		
	}
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		checkDirection();
		move();
	}
	
	private function move():Void 
	{
		if (direction == FlxObject.RIGHT)
			velocity.x = speed;
		else
			velocity.x = -speed;
	}
	
	private function checkDirection():Void 
	{
		if (direction == FlxObject.RIGHT && x >= xStartUp + travelDistance)
		{
			direction = FlxObject.LEFT;
			xStartUp = x;
		}
		else
			if (direction == FlxObject.LEFT && x <= xStartUp - travelDistance)
			{
				direction = FlxObject.RIGHT;
				xStartUp = x;
			}
	}
}