package entities.weapons;

import entities.WeaponBase;
import flixel.FlxObject;

class WeaponNormal extends WeaponBase 
{
	public function new(X:Float, Y:Float) 
	{
		super(X, Y);
		
		loadGraphic(AssetPaths.normalAttack__png, true, 30, 12);
		animation.add("normalAttack", [0, 1, 2, 3, 4, 5], 18, false);
		animation.play("normalAttack");
	}
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		animation.play("normalAttack");
	}
	
	override public function getType():String
	{
		return "Normal";
	}
}