package entities.obstacles;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

class Ladder extends FlxSprite 
{

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
		loadGraphic(AssetPaths.ladder__png, true, 32, 128);
		immovable = true;
	}
}