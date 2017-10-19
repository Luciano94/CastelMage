package source.states;

import entities.Player;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;

class PlayState extends FlxState
{
	private var player:Player;
	private var floor:FlxSprite; // Temporary
	
	override public function create():Void
	{
		super.create();
		FlxG.worldBounds.set(0, 0, 512, 480);
		
		player = new Player(100, 100);
		floor = new FlxSprite(100, camera.height - 30);
		floor.makeGraphic(400, 32);
		floor.immovable = true;
		
		camera.follow(player);
		
		add(player);
		add(floor);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		FlxG.collide(player, floor);
	}
}