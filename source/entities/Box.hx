package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

class Box extends FlxSprite 
{
	public function new(X:Float, Y:Float, Width:Int, Height:Int) 
	{
		super(X, Y);
		makeGraphic(1, 1, 0x00000000);
		width = Width;
		height = Height;
	}
	
}