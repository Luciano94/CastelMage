package entities.obstacles;
import flixel.FlxObject;

class Elevator extends OneWayPlatform 
{
	private var speed:Int;
	private var direction:Int;
	private var yStartUp:Float;
	private var travelDistance:Int;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
		loadGraphic(AssetPaths.movingPlatform__png, true, 48, 16);
		speed = Reg.elevatorSpeed;
		travelDistance = Reg.elevatorTravelDistance;
		yStartUp = Y;
		direction = FlxObject.DOWN;
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
		if (direction == FlxObject.DOWN)
			velocity.y = speed;
		else
			velocity.y = -speed;
	}
	
	private function checkDirection():Void 
	{
		if (direction == FlxObject.DOWN && y >= yStartUp + travelDistance)
		{
			direction = FlxObject.UP;
			yStartUp = y;
		}
		else
			if (direction == FlxObject.UP && y <= yStartUp - travelDistance)
			{
				direction = FlxObject.DOWN;
				yStartUp = y;
			}
	}
}