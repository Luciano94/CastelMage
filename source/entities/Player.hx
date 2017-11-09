package entities;

import entities.weapons.WeaponPotion;
import entities.weapons.WeaponShuriken;
import entities.weapons.WeaponNormal;
import entities.weapons.WeaponSpear;
import flash.display.Shape;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.effects.FlxFlicker;
import flixel.util.FlxColor;
import states.MenuState;
import states.PlayState;

enum States
{
	IDLE;
	MOVING;
	JUMPING;
	ATTACKING;
	CROUCHED;
	CLIMBING_LADDERS;
	BEING_HIT;
	DEAD;
}
enum WeaponStates
{
	SINWEA;
	WEASPEAR;
	WEASHURIKEN;
	WEAPOTION;
}
class Player extends FlxSprite
{
	public var currentState(get, null):States;
	public var weaponCurrentState(get, null):WeaponStates;
	private var speed:Int;
	private var jumpSpeed:Int;
	private var stairsSpeed:Int;
	public var weaponN(get, null):WeaponNormal;
	private var weaponSpear:WeaponSpear;
	private var weaponShuriken:WeaponShuriken;
	private var weaponPotion(get, null):WeaponPotion;
	private var hp:Int;
	static public var lives(get, null):Int = 3;
	public var ammo(get, null):Int;
	public var isTouchingLadder(null, set):Bool;
	public var isOnTopOfLadder(null, set):Bool;
	public var isUnderLadder(null, set):Bool;
	private var hasJustBeenHit:Bool;
	private var inmortalityTime:Float;
	private var willDieFromFall:Bool;
	@:isVar public var powerUpJustPicked(get, set):Bool;
	public var hasLost(get, null):Bool;

	public function new(?X:Float=0, ?Y:Float=0)
	{
		super(X, Y);

		// Attributes Inicialization
		currentState = States.IDLE;
		weaponCurrentState = WeaponStates.SINWEA;
		speed = Reg.playerNormalSpeed;
		jumpSpeed = Reg.playerJumpSpeed;
		stairsSpeed = Reg.playerStairsSpeed;
		acceleration.y = Reg.gravity;
		hp = Reg.playerMaxHealth;
		isTouchingLadder = false;
		isOnTopOfLadder = false;
		isUnderLadder = false;
		ammo = 0;
		inmortalityTime = 0;
		hasJustBeenHit = false;
		willDieFromFall = false;
		powerUpJustPicked = false;
		hasLost = false;

		// Weapons Creation
		weaponN = new WeaponNormal(x + width, y + height / 3);
		weaponN.kill();
		weaponSpear = new WeaponSpear(x + width / 2, y + height / 3);
		weaponSpear.kill();
		weaponShuriken = new WeaponShuriken(x + width / 2, y + height / 3);
		weaponShuriken.kill();
		weaponPotion = new WeaponPotion(x + width, y + height / 3);
		weaponPotion.kill();
		FlxG.state.add(weaponN);
		FlxG.state.add(weaponSpear);
		FlxG.state.add(weaponShuriken);
		FlxG.state.add(weaponPotion);

		// Player Facings
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.LEFT, true, false);

		// Animations
		loadGraphic(AssetPaths.player__png, true, 32, 48);
		animation.add("idle", [0, 1], 6, true);
		animation.add("move", [2, 3, 4], 6, true);
		animation.add("jump", [5, 6], 9, false);
		animation.add("attack", [7, 8, 0], 9, false);
		animation.add("crouch", [9], 6, false);
		animation.add("crouchAttack", [10, 11], 9, false);
		animation.add("climbLadders", [12, 13], 6, false);
		animation.add("beHit", [14], 6, false);
		animation.add("die", [7, 8], 3, false);
	}
	
	override public function update(elapsed:Float):Void
	{
		stateMachine();
		checkAmmo();
		checkBoundaries();
		checkInmortality(elapsed);
		fallingDamage();
		trace(currentState.getName());
		
		super.update(elapsed);
	}
	
	override public function kill():Void
	{
		FlxG.sound.play(AssetPaths.playerDeath__wav);
		FlxG.camera.flash(FlxColor.RED, 1);
		FlxG.camera.shake(0.02, 1);
		lives--;
		hasLost = true;
		super.kill();
	}
	
	private function stateMachine():Void
	{
		switch (currentState)
		{
			case States.IDLE:
				animation.play("idle");
				
				moveHor();
				jump();
				attack();
				crouch();
				climbLadders();
				
				if (hasJustBeenHit && inmortalityTime == 0)
					currentState = States.BEING_HIT;
				else
				{
					if (velocity.x != 0)
						currentState = States.MOVING;
					else
					{
						if (velocity.y != 0 && !weaponN.alive && acceleration.y != 0 && !isTouching(FlxObject.FLOOR))
							currentState = States.JUMPING;
						else
						{
							if (weaponN.alive)
								currentState = States.ATTACKING;
							else 
							{
								if (height == 36)
									currentState = States.CROUCHED;
								else
									if (acceleration.y == 0)
										currentState = States.CLIMBING_LADDERS;
							}
						}	
					}
				}
				

			case States.MOVING:
				animation.play("move");

				moveHor();
				jump();
				attack();
				
				if (hasJustBeenHit && inmortalityTime == 0)
					currentState = States.BEING_HIT;
				else
				{
					if (velocity.x == 0)
						currentState = States.IDLE;
					else
					{
						if (velocity.y != 0 && !weaponN.alive  && !isTouching(FlxObject.FLOOR))
							currentState = States.JUMPING;
						else
							if (weaponN.alive)
								currentState = States.ATTACKING;
					}
				}
				
						
			case States.JUMPING:
				if (animation.name != "jump")
					animation.play("jump");

				attack();
				
				if (hasJustBeenHit && inmortalityTime == 0)
					currentState = States.BEING_HIT;
				else
				{
					if (velocity.y == 0 || velocity.y == Reg.elevatorSpeed || velocity.y == -Reg.elevatorSpeed)
					{
						if (!willDieFromFall)
						{
							if (velocity.x == 0)
								currentState = States.IDLE;
							else
								currentState = States.MOVING;
						}
						else
							hp = 0;
					}
					else
						if (weaponN.alive)
							currentState = States.ATTACKING;
				}
				
			case States.ATTACKING:
				if (height == 48)
				{
					if (animation.name != "attack")
						animation.play("attack");
				}
				else
					if (animation.name != "crouchAttack")
						animation.play("crouchAttack");

				if (velocity.y != 0 && velocity.x != 0)
				{
					if (facing == FlxObject.RIGHT)
						velocity.x = speed;
					else
						velocity.x = -speed;
				}
				else
					velocity.x = 0;

				weaponN.velocity.x = velocity.x;
				weaponN.velocity.y = velocity.y;

				if ((animation.name == "attack" || animation.name == "crouchAttack") && animation.finished)
				{
					weaponN.kill();
					if (hasJustBeenHit && inmortalityTime == 0)
						currentState = States.BEING_HIT;
					else
					{
						if (velocity.y != 0)
							currentState = States.JUMPING;
						else
						{
							if (velocity.x != 0)
								currentState = States.MOVING;
							else
							{
								if (height == 36)
									currentState = States.CROUCHED;
								else
									currentState = States.IDLE;
							}
						}
					}
				}
				
			case States.CLIMBING_LADDERS:
				if (velocity.y != 0)
					animation.play("climbLadders");
				
				velocity.set(0, 0);
				climbLadders();
				if (hasJustBeenHit && inmortalityTime == 0)
				{
					acceleration.y = Reg.gravity;
					currentState = States.BEING_HIT;	
				}
				else
				{
					if (!isTouchingLadder || isTouching(FlxObject.FLOOR))
					{
						acceleration.y = Reg.gravity;
						if (velocity.y != 0 && !isTouching(FlxObject.FLOOR))
							currentState = States.JUMPING;
						else
						{
							if (velocity.x != 0)
								currentState = States.MOVING;
							else
								currentState = States.IDLE;
						}
					}
				}
				
			case States.CROUCHED:
				animation.play("crouch");
				
				attack();
				
				if (hasJustBeenHit && inmortalityTime == 0)
					currentState = States.BEING_HIT;
				else
				{
					if (!FlxG.keys.pressed.DOWN)
					{
						height = 48;
						y -= 12;
						updateHitbox();
						currentState = States.IDLE;
					}
					else
						if (weaponN.alive)
							currentState = States.ATTACKING;
				}
				
			case States.BEING_HIT:
				if (animation.name != "beHit")
					animation.play("beHit");
				
				if (animation.name == "beHit" && animation.finished)
				{
					if (velocity.y != 0)
						currentState = States.JUMPING;
					else
					{
						if (velocity.x != 0)
							currentState = States.MOVING;
						else
							currentState = States.IDLE;
					}
				}
						
			case States.DEAD:
				if (animation.name != "die")
					animation.play("die");
				
				if (animation.name == "die" && animation.finished)
					kill();

		}
	}
	private function moveHor():Void
	{
		velocity.x = 0;
		if (FlxG.keys.pressed.RIGHT)
		{
			velocity.x = speed;
			facing = FlxObject.RIGHT;
		}
		if (FlxG.keys.pressed.LEFT)
		{
			velocity.x = -speed;
			facing = FlxObject.LEFT;
		}
	}
	private function jump():Void
	{
		if (FlxG.keys.justPressed.S)
		{
			velocity.y += jumpSpeed;
		}
	}
	private function attack():Void
	{
		if (FlxG.keys.justPressed.A)
		{			
			if (!weaponSpear.alive && !weaponShuriken.alive && !weaponPotion.alive)
				WeaponBase.pFacing = facing;
			if (!FlxG.keys.pressed.UP)
			{
				FlxG.sound.play(AssetPaths.playerAttack__wav);
				if (facing == FlxObject.RIGHT)
					weaponN.reset(x + width, y + height / 3 - 4);
				else
					weaponN.reset(x - width, y + height / 3 - 4);
			}
			else
			{
				if (ammo > 0 && !weaponSpear.alive && !weaponShuriken.alive && !weaponPotion.alive)
					FlxG.sound.play(AssetPaths.throwWeapon__wav);
				switch (weaponCurrentState)
				{
					case WeaponStates.SINWEA:

					case WeaponStates.WEASPEAR:
						if (!weaponSpear.alive && ammo > 0)
						{
							if (facing == FlxObject.RIGHT)
								weaponSpear.reset(x + width / 2, y + height / 3 - 4);
							else
								weaponSpear.reset(x - width / 2, y + height / 3 - 4);
							currentState = States.ATTACKING;
							ammo--;
						}
					case WeaponStates.WEASHURIKEN:
						if (!weaponShuriken.alive && ammo > 0)
						{
							if (facing == FlxObject.RIGHT)
								weaponShuriken.reset(x + width * 4 / 5, y + height / 4);
							else
								weaponShuriken.reset(x - width * 2 / 5, y + height / 4);
							currentState = States.ATTACKING;
							ammo--;
						}
					case WeaponStates.WEAPOTION:
						if (!weaponPotion.alive && ammo > 0)
						{
							if (facing == FlxObject.RIGHT)
								weaponPotion.reset(x + width - weaponPotion.width / 2, y + height / 3);
							else
								weaponPotion.reset(x - weaponPotion.width / 2, y + height / 3);
							currentState = States.ATTACKING;
							ammo--;
						}
				}
			}
		}
	}
	private function crouch():Void
	{
		if (FlxG.keys.pressed.DOWN && !isTouchingLadder)
		{	
			offset.y = 12;
			height = 36;
		}
	}
	
	private function climbLadders():Void
	{
		if (isTouchingLadder)
		{
			if (FlxG.keys.pressed.UP && !isOnTopOfLadder)
			{
				acceleration.y = 0;
				velocity.y = -stairsSpeed;
			}
			if (FlxG.keys.pressed.DOWN && !isUnderLadder)
			{
				acceleration.y = 0;
				velocity.y = stairsSpeed;
			}
		}
	}
	
	private function checkAmmo():Void
	{
		if (ammo == 0)
			weaponCurrentState = WeaponStates.SINWEA;
	}
	
	public function getSecondaryWeapon():WeaponBase
	{
		switch (weaponCurrentState) 
		{
			case WeaponStates.SINWEA:
				return weaponN;
			case WeaponStates.WEAPOTION:
				return weaponPotion;
			case WeaponStates.WEASHURIKEN:
				return weaponShuriken;
			case WeaponStates.WEASPEAR:
				return weaponSpear;
		}
	}
	
	public function getDamage(damage:Int):Void
	{
		if (!hasJustBeenHit)
		{
			FlxG.sound.play(AssetPaths.playerDamaged__wav);
			FlxG.camera.flash(FlxColor.RED, 0.5);
			FlxG.camera.shake(0.01, 0.4);
			hp -= damage;
			if (hp > 0)
			{
				hasJustBeenHit = true;
				inmortalityTime = 0;
				FlxFlicker.flicker(this, 2, 0.08, true, true);
			}
			else
				currentState = States.DEAD;
		}
	}
	
	private function checkInmortality(elapsed:Float):Void 
	{
		if (hasJustBeenHit)
			inmortalityTime += elapsed;
		if (inmortalityTime >= 2)
			hasJustBeenHit = false;
	}
	
	private function checkBoundaries():Void 
	{
		if (!inWorldBounds())
			kill();
	}
	
	private function fallingDamage():Void 
	{
		if (velocity.y > 900)
			willDieFromFall = true;
	}
	
	public function collectPowerUp(powerUp:PowerUp):Void
	{
		switch (powerUp.whichPowerUp)
		{
			case 0:
				if (hp <= Reg.playerMaxHealth - Reg.healthPackPoints)
				{
					FlxG.sound.play(AssetPaths.pickUpLife__wav);
					hp += Reg.healthPackPoints;
					powerUpJustPicked = true;
				}
				else
					if (hp < Reg.playerMaxHealth)
					{
						FlxG.sound.play(AssetPaths.pickUpLife__wav);
						health = Reg.playerMaxHealth;
						powerUpJustPicked = true;
					}
			case 1:
				if (lives < 3)
				{
					FlxG.sound.play(AssetPaths.pickUpLife__wav);
					lives += 1;
					powerUpJustPicked = true;
				}
			case 2:
				if (weaponCurrentState != WeaponStates.WEASPEAR)
				{
					FlxG.sound.play(AssetPaths.weaponPickUp__wav);
					weaponCurrentState = WeaponStates.WEASPEAR;
					ammo = Reg.weaponInitialAmmo;
					powerUpJustPicked = true;
				}
				else
				{
					FlxG.sound.play(AssetPaths.ammoPickUp__wav);
					if (ammo < Reg.playerMaxAmmo - Reg.weaponInitialAmmo)
						ammo += Reg.weaponInitialAmmo;
					else
						ammo = Reg.playerMaxAmmo;
					powerUpJustPicked = true;
				}
			
			case 3:
				if (weaponCurrentState != WeaponStates.WEASHURIKEN)
				{
					FlxG.sound.play(AssetPaths.weaponPickUp__wav);
					weaponCurrentState = WeaponStates.WEASHURIKEN;
					ammo = Reg.weaponInitialAmmo;
					powerUpJustPicked = true;
				}
				else
				{
					FlxG.sound.play(AssetPaths.ammoPickUp__wav);
					if (ammo < Reg.playerMaxAmmo - Reg.weaponInitialAmmo)
						ammo += Reg.weaponInitialAmmo;
					else
						ammo = Reg.playerMaxAmmo;
					powerUpJustPicked = true;
				}
					
			case 4:
				if (weaponCurrentState != WeaponStates.WEAPOTION)
				{
					FlxG.sound.play(AssetPaths.weaponPickUp__wav);
					weaponCurrentState = WeaponStates.WEAPOTION;
					ammo = Reg.weaponInitialAmmo;
					powerUpJustPicked = true;
				}
				else
				{
					FlxG.sound.play(AssetPaths.ammoPickUp__wav);
					if (ammo < Reg.playerMaxAmmo - Reg.weaponInitialAmmo)				
						ammo += Reg.weaponInitialAmmo;
					else
						ammo = Reg.playerMaxAmmo;
					powerUpJustPicked = true;
				}
			case 5:
				if (weaponCurrentState != WeaponStates.SINWEA)
				{
					FlxG.sound.play(AssetPaths.ammoPickUp__wav);
					if (ammo < Reg.playerMaxAmmo - Reg.ammoPackPoints)
						ammo += Reg.ammoPackPoints;
					else
						ammo = Reg.playerMaxAmmo;
					powerUpJustPicked = true;
				}
				
			case 6:
				FlxG.sound.play(AssetPaths.pickUpCoin__wav);
				Reg.score += 5;
				powerUpJustPicked = true;
		}
	}
	
	static function get_lives():Int 
	{
		return lives;
	}
	
	function get_ammo():Int 
	{
		return ammo;
	}
	
	function get_weaponCurrentState():WeaponStates 
	{
		return weaponCurrentState;
	}
	
	function set_isTouchingLadder(value:Bool):Bool 
	{
		return isTouchingLadder = value;
	}
	
	function get_currentState():States 
	{
		return currentState;
	}
	
	function set_isOnTopOfLadder(value:Bool):Bool 
	{
		return isOnTopOfLadder = value;
	}
	
	function set_isUnderLadder(value:Bool):Bool 
	{
		return isUnderLadder = value;
	}
	
	function get_weaponN():WeaponNormal 
	{
		return weaponN;
	}
	
	public function get_weaponPotion():WeaponPotion 
	{
		return weaponPotion;
	}
	function get_powerUpJustPicked():Bool 
	{
		return powerUpJustPicked;
	}
	
	function set_powerUpJustPicked(value:Bool):Bool 
	{
		return powerUpJustPicked = value;
	}
	
	static public function setLives(value:Int)
	{
		lives = value;
	}
	
	function get_hasLost():Bool 
	{
		return hasLost;
	}
}