package entities.enemies;

import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author holis
 */
class Minion extends Zombie 
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset, _player:Player) 
	{
		super(X, Y, SimpleGraphic, _player);
		loadGraphic(AssetPaths.Minion__png, true, 16, 46);
		animation.add("idle", [0], false);
		animation.add("move", [1, 2, 3, 4], 12, true);
	}
	
	override public function reset(X:Float, Y:Float):Void 
	{
		super.reset(X, Y);
	}
}