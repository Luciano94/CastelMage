package;

class Reg 
{	
	// Player
	static public var playerNormalSpeed:Int = 75;
	static public var playerJumpSpeed:Int = -500;
	static public var playerStairsSpeed:Int = 50;
	static public var gravity:Int = 1600;
	static public var playerMaxHealth:Int = 100;
	static public var playerMaxLives:Int = 3;
	// Weapon Spear
	static public var weaponSpeNormalSpeed:Int = 200;
	static public var weaponSpeMaxDistance:Int = 150;
	// Weapon Shuriken
	static public var weaponShuNormalSpeed:Int = 275;
	static public var weaponShuYSpeed:Int = -300;
	// Weapon Potion
	static public var weaponPotNormalSpeed:Int = 180;
	static public var weaponPotYSpeed:Int = -150;
	// Pause
	static public var paused:Bool = false;
	// Enemy
	static public var speedEnemy:Int = 75;
	static public var pathSpeed:Int = 50;
	static public var trackDist:Int = 100;
	static public var atkDist:Int = 40;
	static public var batAtkDist:Int = 10;
	static public var maxMinions:Int = 3;
	static public var minionTime:Int = 5;
	static public var atkTime:Int = 120;
	static public var timeToTrk:Int = 360;
	static public var preAtkTime: Int = 60;
	static public var AELifePoints:Int = 5;
}