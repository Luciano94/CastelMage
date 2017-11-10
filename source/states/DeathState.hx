package states;

import entities.Player;
import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class DeathState extends FlxSubState
{
	private var death:FlxText;
	private var gameOver:FlxText;
	private var instructions:FlxText;

	public function new(BGColor:FlxColor= 0x22000000)
	{
		super(BGColor);

		if (Player.lives > 0)
		{
			deathSetUp();
			instructionsSetUp("Death");
		}
		else
		{
			gameOverSetUp();
			instructionsSetUp("Game Over");
		}

	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.R)
			if (Player.lives > 0)
			{
				FlxG.sound.play(AssetPaths.menuSelection__wav);
				Reg.score = 0;
				FlxG.camera.fade(FlxColor.BLACK, 0.5, false, function()
				{
					FlxG.switchState(new PlayState()); 
				});
			}
		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.sound.play(AssetPaths.menuSelection__wav);
			Reg.score = 0;
			Player.setLives(3);
			FlxG.mouse.visible = true;
			FlxG.camera.fade(FlxColor.BLACK, 0.5, false, function()
			{
				FlxG.switchState(new MenuState()); 
			});
		}
	}

	private function deathSetUp():Void
	{
		death = new FlxText(0, FlxG.height / 2 - 32, FlxG.width, "You Have Died", 14, true);
		death.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.GRAY, 1, 1);
		death.alignment = FlxTextAlign.CENTER;
		death.scrollFactor.set(0, 0);
		add(death);
	}

	private function gameOverSetUp():Void
	{
		gameOver = new FlxText(0, FlxG.height / 2, FlxG.width, "Game Over", 14, true);
		gameOver.color = FlxColor.RED;
		gameOver.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.WHITE, 1, 1);
		gameOver.alignment = FlxTextAlign.CENTER;
		gameOver.scrollFactor.set(0, 0);
		add(gameOver);
	}
	
	private function instructionsSetUp(instr:String):Void
	{
		if (instr == "Death")
			instructions = new FlxText(0, FlxG.height / 2 + 48, FlxG.width, "Press R to restart", 8, true);
		else
			instructions = new FlxText(0, FlxG.height / 2 + 48, FlxG.width, "Press ESC to go to the main menu", 8, true);

		instructions.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.GRAY, 1, 1);
		instructions.alignment = FlxTextAlign.CENTER;
		instructions.scrollFactor.set(0, 0);
		add(instructions);
	}
}