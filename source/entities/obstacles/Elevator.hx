package entities.obstacles;
import flixel.FlxObject;

class Elevator extends OneWayPlatform 
{
	private var speed:Int;
	@:isVar public var direction(get, set):Int;
	@:isVar public var hasJustChangedDirection(get, set):Bool;
	private var timeSinceChange:Float;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
		loadGraphic(AssetPaths.movingPlatform__png, true, 48, 16);
		speed = Reg.elevatorSpeed;
		hasJustChangedDirection = false;
		timeSinceChange = 0;
		direction = FlxObject.DOWN;
		animation.add("PGB", [0, 1, 2], 6, true);
		animation.play("PGB");		
	}
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		checkMovement(elapsed);
		move();
	}
	
	private function move():Void 
	{
		if (direction == FlxObject.DOWN)
			velocity.y = speed;
		else
			velocity.y = -speed;
	}
	
	private function checkMovement(elapsed:Float):Void 
	{
		if (hasJustChangedDirection)
			timeSinceChange += elapsed;
		if (timeSinceChange >= 2)
		{
			timeSinceChange = 0;
			hasJustChangedDirection = false;
		}
	}
	
	function get_direction():Int 
	{
		return direction;
	}
	
	function set_direction(value:Int):Int 
	{
		return direction = value;
	}
	
	function get_hasJustChangedDirection():Bool 
	{
		return hasJustChangedDirection;
	}
	
	function set_hasJustChangedDirection(value:Bool):Bool 
	{
		return hasJustChangedDirection = value;
	}
}