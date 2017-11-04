package entities.obstacles;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

class Barrel extends FlxSprite 
{
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
		loadGraphic(AssetPaths.barrel__png, true, 32, 36);
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
	
	override public function kill():Void
	{
		super.kill();
	}
	
	public function preKill():Void
	{
		animation.play("destroy");
	}	
}