package entities.obstacles;

class UnstablePlatform extends OneWayPlatform 
{
	public var playerIsOnTop(null, set):Bool;
	private var timer:Float;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
		loadGraphic(AssetPaths.unstablePlatform__png, true, 32, 16);
		playerIsOnTop = false;
		timer = 0;
		animation.add("break", [0, 1, 2], 2, false);
	}
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		checkStability(elapsed);
		checkBoundaries();
	}
	
	private function checkStability(elapsed:Float):Void 
	{
		if (playerIsOnTop)
		{
			if (animation.name != "break")
				animation.play("break");
			timer += elapsed;
		}
		if (timer >= 1)
		{
			acceleration.y = Reg.gravity;
		}
	}
	
	private function checkBoundaries():Void 
	{
		if (!isOnScreen())
			kill();
	}
	
	function set_playerIsOnTop(value:Bool):Bool 
	{
		return playerIsOnTop = value;
	}
}