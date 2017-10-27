package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxObject;
/**
 * ...
 * @author Aleman5
 */
class WeaponBase extends FlxSprite 
{
	static public var pFacing:Int;

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.LEFT, true, false);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		facing = pFacing;
	}
}