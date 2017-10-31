package states;

import entities.Player;
import entities.PowerUp;
import entities.weapons.WeaponNormal;
import flixel.FlxCamera;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.FlxObject;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	// Player
	public var player:Player;
	private var loader:FlxOgmoLoader;
	private var tilemap:FlxTilemap;
	private var hud:HUD;
	private var playerHealth:FlxBar;
	private var score:Int;
	//private var stairs:FlxTypedGroup<FlxSprite>;	Experimental Feature.

	override public function create():Void
	{
		super.create();
		
		FlxG.mouse.visible = false;
		score = 0;
		
		//stairs = new FlxTypedGroup<FlxSprite>();
		tilemapSetUp();
		loader.loadEntities(entityCreator, "Entities");
		//add(stairs);
		FlxG.worldBounds.set(0, 0, 5120, 512);
		cameraSetUp();
		hudSetUp();	
	}

	override public function update(elapsed:Float):Void
	{
		if (!Reg.paused)
		{
			super.update(elapsed);
		}
		FlxG.collide(player, tilemap);
		//FlxG.overlap(player, stairs, contactStairs);
			
		checkPause();
		hud.updateHUD(player.lives, player.weaponCurrentState.getName(), player.ammo, score, Reg.paused);
		//player.isNextToStairs = false;
	}

	private function entityCreator(entityName:String, entityData:Xml):Void
	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));

		switch (entityName)
		{
			case "Player":
				player = new Player(x, y);
				add(player);
			//case "Stairs":
				//var stair = new FlxSprite(x, y, AssetPaths.stairs__png);
				//stairs.add(stair);
		}
	}
	
	private function checkPause():Void
	{
		if (FlxG.keys.justPressed.ENTER)
			Reg.paused = !Reg.paused;
	}
	
	private function tilemapSetUp():Void 
	{
		loader = new FlxOgmoLoader(AssetPaths.Level__oel);
		tilemap = loader.loadTilemap(AssetPaths.tileset__png, 16, 16, "Tiles");
		for (i in 0...8)
			tilemap.setTileProperties(i, FlxObject.NONE);
		for (i in 8...10)
			tilemap.setTileProperties(i, FlxObject.ANY);
		for (i in 11...19)
			tilemap.setTileProperties(i, FlxObject.NONE);
		add(tilemap);
	}
	
	private function cameraSetUp():Void 
	{
		camera.follow(player, FlxCameraFollowStyle.PLATFORMER, 2);
		camera.setScrollBounds(0, 5120, 0, 512);
	}
	
	private function hudSetUp():Void 
	{
		hud = new HUD();
		add(hud);
	
		playerHealth = new FlxBar(10, 10, FlxBarFillDirection.LEFT_TO_RIGHT, 68, 12, player, "hp", 0, 100, true);
		playerHealth.scrollFactor.set(0, 0);
		add(playerHealth);
	}
	
	//private function contactStairs(p:Player, s:FlxSprite):Void
	//{
		//p.isNextToStairs = true;
	//}
}