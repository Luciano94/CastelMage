package;
import flixel.math.FlxRandom;

class Reg 
{	
	// Player
	static public var playerNormalSpeed:Int = 75;
	static public var playerJumpSpeed:Int = -500;
	static public var playerStairsSpeed:Int = 50;
	static public var playerMaxHealth:Int = 100;
	static public var playerMaxLives:Int = 3;
	static public var playerMaxAmmo:Int = 20;
	static public var playerNormalDamage:Int = 20;
	// Weapon Spear
	static public var weaponSpeNormalSpeed:Int = 200;
	static public var weaponSpeMaxDistance:Int = 150;
	static public var spearDamage:Int = 30;
	// Weapon Shuriken
	static public var weaponShuNormalSpeed:Int = 275;
	static public var weaponShuYSpeed:Int = -300;
	static public var shurikenDamage:Int = 40;
	// Weapon Potion
	static public var weaponPotNormalSpeed:Int = 180;
	static public var weaponPotYSpeed:Int = -150;
	static public var poisonDamage:Int = 50;
	// Game
	static public var paused:Bool = false;
	static public var gravity:Int = 1600;
	static public var score:Int = 0;
	// Enemies
	static public var speedEnemy:Int = 50;
	static public var pathSpeed:Int = 50;
	static public var trackDist:Int = 100;
	static public var atkDist:Int = 35;
	static public var batAtkDist:Int = 10;
	static public var maxMinions:Int = 5;
	static public var minionTime:Int = 2;
	static public var atkTime:Int = 120;
	static public var timeToTrk:Int = 360;
	static public var preAtkTime:Int = 60;
	static public var zombieLifePoints:Int = 40;
	static private var shamanLifePoints:Int = 50;
	static public var armoredEnemyLifePoints:Int = 60;
	static public var zombieAtkDamage:Int = 15;
	static public var batAtkDamage:Int = 5;
	static public var shamanAtkDamage:Int = 10;
	static public var armoredEnemyAtkDamage:Int = 20;
	static public var minionAtkDamage:Int = 10;
	// Boss
	static public var speedBoss:Int = 75;
	static public var timeToMoveBoss:Int = 20;
	//Obstacles
	static public var movingPlatformSpeed:Int = 32;
	static public var movingPlatformTravelDistance:Int = 320;
	static public var elevatorSpeed:Int = 16;
	static public var elevatorTravelDistance:Int = 320;
	// Power Ups
	static public var random:FlxRandom = new FlxRandom();
	static public var numberOfPowerUps:Int = 6;
	static public var healthPackPoints:Int = 25;
	static public var ammoPackPoints:Int = 10;
	static public var weaponInitialAmmo:Int = 5;
}