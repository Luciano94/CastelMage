package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.math.FlxRandom;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;

enum BossStates
{
	IDLE;
	MOVING;
	CHASE;
	CHASEINVI;
}
class Boss extends FlxSprite 
{
	private var currentState:BossStates;
	private var player:Player;
	private var hit:Bool;
	private var healthBoss:Int;
	private var canIAttack:Int;
	private var yesYouCanAtk:Int;	// Timers
	private var canIMove:Int;		//
	private var yesYouCanMove:Int;	//
	private var originialPosY:Int;	//
	private var r:FlxRandom;
	private var p:FlxPoint;
	private var posX:Int;
	private var posY:Int;
	private var speedX:Float;
	private var speedY:Float;
	
	public function new(?X:Float=0, ?Y:Float=0, _player:Player) 
	{
		super(X, Y);
		//loadGraphic();
		makeGraphic(50, 50, 0x12344657);
		//animation.add();
		//animation.play();
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.LEFT, true, false);
		
		currentState = BossStates.IDLE;
		speedX = speedY = Reg.speedBoss;
		velocity.set(speedX, speedY);
		player = _player;
		hit = false;
		healthBoss = Reg.playerMaxHealth;
		canIAttack = 0;
		yesYouCanAtk = 3;
		canIMove = 0;
		yesYouCanMove = Reg.timeToMoveBoss;
		originialPosY = Y;
		r = new FlxRandom();
		p = new FlxPoint();
		posX = 0;
		posY = 0;
	}
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		stateMachine();
	}
	function stateMachine() // http://haxeflixel.com/documentation/enemies-and-basic-ai/
	{
		switch (currentState) 
		{
			case BossStates.IDLE:
				thinking();
			case BossStates.MOVING:
				takingAWalk();
			case BossStates.CHASE:
				attacking();
			case BossStates.CHASEINVI:
				attacking();
		}
	}
	function thinking() 
	{
		velocity.set(0, 0);
		//animation.play("idle");
		if (canIAttack < yesYouCan) // Doesn't attack
		{
			if (canIMove < yesYouCanMove) // Doesn't move
				canIMove++;
			else // Moves
			{
				canIAttack++;
				do 
				{
					posX = r.int(0, camera.width - width);
				} while (posX == player.x);
				posY = r.int(originialPosY - 70, originialPosY + 50);
				p.set(posX, posY);
				FlxVelocity.moveTowardsPoint(this, p, speedX);
				if (velocity.x > 0)
					facing = FlxObject.RIGHT;
				else
					facing = FlxObject.LEFT;
				currentState = BossStates.MOVING;
			}
		}
		else // Attacks
		{
			yesYouCanAtk = r.int(2, 3);
			canIAttack = 0;
			posX = x;
			posY = y;
			if(health >= Reg.playerMaxHealth / 4)
				currentState = BossStates.CHASE;
			else
				currentState = BossStates.CHASEINVI;
		}
	}
	function takingAWalk() 
	{
		//animation.play("moving");
		if (facing == FlxObject.RIGHT)
			if (x >= player.x)
				currentState = BossStates.IDLE;
		else
			if (x <= player.x)
				currentState = BossStates.IDLE;
	}
	function attacking() 
	{
		switch (hit) 
		{
			case false:
				if(!FlxG.collide(this, player)) 
					FlxVelocity.accelerateTowardsPoint(this, player, 50, 500);
				else
				{
					hit == true;
					player.health -= 10;
					p.set(posX, posY);
				}
			case true:
				FlxVelocity.moveTowardsPoint(this, p, speedX);
				if (facing == FlxObject.RIGHT)
					if (x >= player.x)
						currentState = BossStates.IDLE;
				else
					if (x <= player.x)
						currentState = BossStates.IDLE;
		}
	}
}