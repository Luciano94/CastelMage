package entities.enemies;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.math.FlxRandom;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.effects.FlxFlicker;

enum BossStates
{
	IDLE;
	MOVING;
	CHASE;
	CHASEINVI;
	GOINGBACK;
}
class Boss extends FlxSprite 
{
	private var currentState:BossStates;
	private var player:Player;
	private var speedB:Float;
	private var healthBoss:Int;
	private var maxHealthBoss:Int;
	private var canIAttack:Int;
	private var yesYouCanAtk:Int;	// Timers
	private var canIMove:Int;		//
	private var yesYouCanMove:Int;	//
	private var originalX:Float;
	private var originalY:Float;
	private var r:FlxRandom;
	private var p:FlxObject;
	private var posX:Float;
	private var posY:Float;
	
	public function new(?X:Float=0, ?Y:Float=0, _player:Player) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.boss__png, true, 64, 64);
		scale.set(0.75, 0.75);
		updateHitbox();
		animation.add("moving", [0, 1, 2, 3, 4, 5], 20);
		animation.add("chasing", [5]);
		animation.add("chasingInvi", [6]);
		animation.play("moving");
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.LEFT, true, false);
		
		currentState = BossStates.IDLE;
		speedB = Reg.speedBoss;
		velocity.set(0, 0);
		player = _player;
		healthBoss = maxHealthBoss = Reg.playerMaxHealth;
		canIAttack = 0;
		yesYouCanAtk = 3;
		canIMove = 0;
		yesYouCanMove = Reg.timeToMoveBoss;
		originalX = X;
		originalY = Y;
		r = new FlxRandom();
		p = new FlxObject(1, 1, 1, 1);
		p.velocity.set(0, 0);
		FlxG.state.add(p);
		posX = 0;
		posY = 0;
		facing = FlxObject.RIGHT;
	}
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		stateMachine();
		trace(healthBoss);
		if (healthBoss <= 0)
			kill();
	}
	function stateMachine() // http://haxeflixel.com/documentation/enemies-and-basic-ai/
	{
		switch (currentState) 
		{
			case BossStates.IDLE:
				animation.play("moving");
				thinking();
				if (FlxG.collide(this, player))
				{
					player.getDamage(10);
					canIMove = 0;
				}
				else if (FlxG.overlap(player.weaponN, this) || FlxG.overlap(player.getSecondaryWeapon(), this))
				{
					if(!FlxFlicker.isFlickering(this))
						healthBoss -= 10;
					FlxFlicker.flicker(this, 3, 0.08, true, true);
					canIMove = 0;
				}
			case BossStates.MOVING:
				animation.play("moving");
				takingAWalk();
				if (FlxG.collide(this, player))
				{
					player.getDamage(10);
					currentState = BossStates.IDLE;
				}else if (FlxG.overlap(player.weaponN, this) || FlxG.overlap(player.getSecondaryWeapon(), this))
				{
					if(!FlxFlicker.isFlickering(this))
						healthBoss -= 10;
					FlxFlicker.flicker(this, 3, 0.08, true, true);
					currentState = BossStates.IDLE;
				}
			case BossStates.CHASE:
				animation.play("moving");
				attacking();
			case BossStates.CHASEINVI:
				animation.play("chasingInvi");
				attacking();
			case BossStates.GOINGBACK:
				animation.play("moving");
				goBack();
		}
	}
	function thinking() 
	{
		velocity.set(0, 0);
		if (canIAttack < yesYouCanAtk) // Doesn't attack
		{
			if (canIMove < yesYouCanMove) // Doesn't move
				canIMove++;
			else // Moves
			{
				canIAttack++;
				canIMove = 0;
				
				posX = r.float(originalX - camera.width / 2, originalX + width * 2);
				posY = r.float(originalY - 10, originalY + 30);
				p.set_x(posX);
				p.set_y(posY);
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
			p.set_x(posX);
			p.set_y(posY);
			if(healthBoss > 31)
				currentState = BossStates.CHASE;
			else
				currentState = BossStates.CHASEINVI;
		}
	}
	function takingAWalk() 
	{
		FlxVelocity.moveTowardsPoint(this, p.getPosition(), speedB);
		if (FlxG.overlap(this, p))
			currentState = BossStates.IDLE;
	}
	function attacking() 
	{
		if (!FlxG.overlap(this, player))
			FlxVelocity.moveTowardsPoint(this, player.getPosition(), speedB);
		else
		{
			currentState = BossStates.GOINGBACK;
			player.getDamage(10);
		}
		if (FlxG.overlap(player.weaponN, this) || FlxG.overlap(player.getSecondaryWeapon(), this))
		{
			currentState = BossStates.GOINGBACK;
			
			if(!FlxFlicker.isFlickering(this))
				healthBoss -= 10;
			FlxFlicker.flicker(this, 3, 0.08, true, true);
		}
	}
	function goBack() 
	{
		FlxVelocity.moveTowardsPoint(this, p.getPosition(), speedB); // It moves to the point it was before the chase
		if (velocity.x >= 0)
		{
			if (x >= p.x)
				currentState = BossStates.IDLE;
		}
		else
		{
			if (x <= p.x)
				currentState = BossStates.IDLE;
		}
	}
}