package entities.obstacles;

import entities.PowerUp;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxRandom;
import flixel.system.FlxAssets.FlxGraphicAsset;

class Barrel extends FlxSprite 
{
	private var random:FlxRandom;
	private var powerUpIndex:Int;
	
	public function new(?X:Float=0, ?Y:Float=0)
	{
		super(X, Y);
		
		loadGraphic(AssetPaths.barrel__png, true, 32, 36);
		random = new FlxRandom();
		animation.add("destroy", [1, 2, 3, 4], 12, false);
	}
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (animation.name == "destroy" && animation.finished)
		{
			kill();
		}
	}
	
	public function preKill(powerUps):Void
	{
		animation.play("destroy");
		solid = false;
		if (random.bool(45))
		{
			powerUpIndex = random.int(0, 6);
			var powerUp = new PowerUp(x + 8, y + 20, powerUpIndex);
			powerUps.add(powerUp);
		}
	}	
}