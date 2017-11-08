package entities.enemies;

import flixel.system.FlxAssets.FlxGraphicAsset;

class Minion extends Zombie 
{

	public function new(?X:Float=0, ?Y:Float=0, _player:Player) 
	{
		super(X, Y, _player);
		loadGraphic(AssetPaths.Minion__png, true, 16, 46);
		animation.add("idle", [0], false);
		animation.add("move", [1, 2, 3, 4], 12, true);
	}
	
	override public function reset(X:Float, Y:Float):Void 
	{
		super.reset(X, Y);
	}
	
	override public function kill():Void
	{
		super.kill();
		Reg.score += 3;
	}
}