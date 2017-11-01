package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxObject;

enum StatesB
{
	STATE1;
	STATE2;
	STATE3;
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
			case StatesB.STATE1:
				
			case StatesB.STATE2:
				
			case StatesB.STATE3:
				
		}
	}
}