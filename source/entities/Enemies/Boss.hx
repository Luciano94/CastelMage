package entities.enemies;

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
	private var speedX:Float;
	private var hit:Bool;
	private var healthBoss:Int;
	private var canIAttack:Int;
	private var yesYouCanAtk:Int;	// Timers
	private var canIMove:Int;		//
	private var yesYouCanMove:Int;	//
	private var originalX:Float;
	private var originalY:Float;
	private var r:FlxRandom;
	private var p:FlxPoint;
	private var posX:Float;
	private var posY:Float;
	private var timeChasing:Int;
	
	public function new(?X:Float=0, ?Y:Float=0, _player:Player) 
	{
		super(X, Y);
		//loadGraphic();
		makeGraphic(25, 25);
		//animation.add();
		//animation.play();
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.LEFT, true, false);
		
		currentState = BossStates.IDLE;
		speedX = Reg.speedBoss;
		velocity.set(0, 0);
		player = _player;
		hit = false;
		healthBoss = Reg.playerMaxHealth;
		canIAttack = 0;
		yesYouCanAtk = 3;
		canIMove = 0;
		yesYouCanMove = Reg.timeToMoveBoss;
		originalX = X;
		originalY = Y;
		r = new FlxRandom();
		p = new FlxPoint();
		posX = 0;
		posY = 0;
		timeChasing = 0;
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
				if (FlxG.overlap(player.weaponN, this) || FlxG.overlap(player.getSecondaryWeapon(), this))
				{
					health -= 10;
					canIMove = 0;
				}
			case BossStates.MOVING:
				takingAWalk();
				if (FlxG.overlap(player.weaponN, this) || FlxG.overlap(player.getSecondaryWeapon(), this))
				{
					health -= 10;
					currentState = BossStates.IDLE;
				}
			case BossStates.CHASE:
				attacking();
				if (FlxG.overlap(player.weaponN, this) || FlxG.overlap(player.getSecondaryWeapon(), this))
				{
					OMGICollide();
					health -= 10;
				}
			case BossStates.CHASEINVI:
				attacking();
				if (FlxG.overlap(player.weaponN, this) || FlxG.overlap(player.getSecondaryWeapon(), this))
				{
					OMGICollide();
					health -= 10;
					//animation.play("moving");
				}
		}
	}
	function thinking() 
	{
		velocity.set(0, 0);
		//animation.play("idle");
		if (canIAttack < yesYouCanAtk) // Doesn't attack
		{
			if (canIMove < yesYouCanMove) // Doesn't move
				canIMove++;
			else // Moves
			{
				canIAttack++;
				canIMove = 0;
				posX = r.float(originalX - camera.width / 2, originalX + camera.width / 2 - width);
				posY = r.float(originalY - 20, originalY + 30);
				p.set(posX, posY);
				
				if (x <= posX)
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
		FlxVelocity.moveTowardsPoint(this, p, speedX);
		
		if (facing == FlxObject.RIGHT)
			if (x >= p.x)
				currentState = BossStates.IDLE;
		else
			if (x <= p.x)
				currentState = BossStates.IDLE;
	}
	function attacking() 
	{
		timeChasing++;
		switch (hit) 
		{
			case false:
				if(!FlxG.collide(this, player)) 
					FlxVelocity.accelerateTowardsPoint(this, player.getPosition(), 50, 300);
				else
					OMGICollide();
					if (timeChasing >= 25)
						player.health -= 20;
					else
						player.health -= 10;
			case true:
				FlxVelocity.moveTowardsPoint(this, p, speedX); // It moves to the point it was before the chase
				if (facing == FlxObject.RIGHT)
					if (x >= p.x)
						currentState = BossStates.IDLE;
				else
					if (x <= p.x)
						currentState = BossStates.IDLE;
		}
	}
	function OMGICollide() 
	{
		hit == true;
		p.set(posX, posY);
		timeChasing = 0;
	}
}