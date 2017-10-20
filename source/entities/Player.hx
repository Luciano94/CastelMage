package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.FlxObject;

enum States
{
	IDLE;
	MOVE;
	JUMPING;
	DEAD;
	DOORTRIGGER;
}

class Player extends FlxSprite 
{
	private var currentState:States;
	private var speed:Int;
	private var jumpSpeed:Int;
	private var speedXJump:Int;
	private var gravity:Int;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		currentState = States.IDLE;
		speed = Reg.playerNormalSpeed;
		jumpSpeed = Reg.playerJumpSpeed;
		speedXJump = 0;
		acceleration.y = Reg.gravity;
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.LEFT, true, false);
		
		loadGraphic(AssetPaths.player__png, true, 40, 48);
		animation.add("idle", [0]);	// Temporary Animations (WORK IN PROGRESS)
		animation.add("move", [1, 2, 3], 6, true);
		animation.add("jump", [4, 5], 6, false);
		//animation.add("death", [3]);
		//animation.add("attack", [3]);
	}
	
	override public function update(elapsed:Float):Void
	{
		stateMachine();
		
		super.update(elapsed);
		
	}
	
	private function stateMachine():Void
	{
		switch (currentState) 
		{
			case States.IDLE:
				animation.play("idle");
				moveHor();
				jump(false);
				
				if (velocity.x != 0)
					currentState = States.MOVE;
				if (velocity.y != 0)
					currentState = States.JUMPING;
					
			case States.MOVE:
				animation.play("move");
				moveHor();
				jump(true);
				
				if (velocity.x == 0)
					currentState = States.IDLE;
				if (velocity.y != 0)
					currentState = States.JUMPING;
					
			case States.JUMPING:
				animation.play("jump");
				velocity.x = speedXJump;
				if (velocity.y == 0 && isTouching(FlxObject.FLOOR))
				{
					if (velocity.x == 0)
						currentState = States.IDLE;
					else
						currentState = States.MOVE;
					speedXJump = 0;
				}
			case States.DEAD:
				
			case States.DOORTRIGGER:
				
		}
	}

	private function moveHor():Void
	{
		velocity.x = 0;
		
		if (FlxG.keys.pressed.RIGHT)
		{
			velocity.x += speed;
		}
		if (FlxG.keys.pressed.LEFT)
		{
			velocity.x += -speed;
		}
		
		if (velocity.x < 0)
			facing = FlxObject.LEFT;
		if (velocity.x > 0)
			facing = FlxObject.RIGHT;
		
	}
	
	private function jump(moving:Bool):Void // This variable tells if the Player is moving or not
	{
		if (FlxG.keys.justPressed.S)
		{
			velocity.y += jumpSpeed;
			
			if (moving)
			{
				if (velocity.x > 0)
					speedXJump = speed;
				else
					speedXJump = -speed;
			}		
		}
	}
	
}