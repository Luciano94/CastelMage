package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;

enum States
{
	MOVE;
	JUMP;
	DEAD;
	DOORTRIGGER;
}
class Player extends FlxSprite 
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
	}
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		movement();
	}
	
	function movement() 
	{
		if (FlxG.keys.pressed.RIGHT)	//Right
			velocity.x += Reg.speedX;
		if (FlxG.keys.pressed.LEFT)		//Left
			velocity.x += -Reg.speedX;
		if (FlxG.keys.justPressed.S)	//Jump
			velocity.y +=
	}
}