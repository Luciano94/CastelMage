package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxObject;
import flixel.addons.util.FlxFSM;
import flixel.math.FlxVelocity;

enum StatesB
{
	NORMALMOV;
	INVIMOV;
	CHASE;
}
class Boss extends FlxSprite 
{
	private var currentState:StatesB;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		currentState = StatesB.STATE1;
	}
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		stateMachine();
	}
	function stateMachine() 
	{
		switch (currentState) 
		{
			case StatesB.NORMALMOV:
				
			case StatesB.INVIMOV:
				
			case StatesB.CHASE:
				FlxVelocity.accelerateTowardsPoint();
		}
	}
}