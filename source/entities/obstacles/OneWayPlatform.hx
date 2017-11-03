package entities.obstacles;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

class OneWayPlatform extends FlxSprite 
{

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
		loadGraphic(AssetPaths.oneWayPlatform__png);
		allowCollisions = FlxObject.UP;
		immovable = true;
	}
	
}