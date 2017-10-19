package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.FlxObject;

/**
 * ...
 * @author ...
 */
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
	private var speedX:Int;
	private var speedXBoosted:Int;
	private var speedYJump:Int;
	private var speedXJump:Int;
	private var gravity:Int;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		currentState = States.MOVE;
		speedX = Reg.speedXPlayer;
		speedXBoosted = Reg.speedXPlayerBoosted;
		speedYJump = Reg.speedJumpPlayer;
		speedXJump = 0;
		gravity = Reg.gravity;
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.LEFT, true, false);
		
		loadGraphic(AssetPaths.bichi__png, true, 16, 16);
		animation.add("idle", [0, 1, 2, 1], 6, true);
		animation.add("move", [6, 7, 8, 9, 10, 11], 8, true);
		animation.add("jump", [13], false);
		animation.add("death", [3]);
		animation.add("attack", [3]);
		
		scale.set(2, 2); // Temporary
		updateHitbox();  //
		
		acceleration.y = gravity;
		currentState = States.IDLE;
	}
	override public function update(elapsed:Float):Void
	{
		stateMachine();
		
		super.update(elapsed);
		
	}
	
	function stateMachine() 
	{
		switch (currentState) 
		{
			case States.IDLE:
				animation.play("idle");
				moveHor();
				jump(false);
				
				if (velocity.x != 0)
					currentState = States.MOVE;
			case States.MOVE:
				animation.play("move");
				moveHor();
				jump(true);
				
				if (velocity.x == 0)
					currentState = States.IDLE;
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

	function moveHor() 
	{
		velocity.x = 0;
		
		if (FlxG.keys.pressed.RIGHT)
		{
			//if(!pUpBoost)
				velocity.x += speedX;
			//else
			//	velocity.x += speedXBoosted;
		}
		if (FlxG.keys.pressed.LEFT)
		{
			//if(!pUpBoost)
				velocity.x += -speedX;
			//else
			//	velocity.x += -speedXBoosted;
		}
		if (FlxG.keys.justPressed.S)
		{
			velocity.y += speedYJump;
		}
		
		if (velocity.x < 0)
			facing = FlxObject.LEFT;
		if (velocity.x > 0)
			facing = FlxObject.RIGHT;
		
	}
	
	function jump(moving:Bool) // This variable tells if the Player is moving or not
	{
		if (FlxG.keys.justPressed.S){
			if (moving)
			{
				if(velocity.x > 0)
					speedXJump = speedX;
				else
					speedXJump = -speedX;
				currentState = States.JUMPING;
			}
			else
				currentState = States.JUMPING;
		}
	}
	
}