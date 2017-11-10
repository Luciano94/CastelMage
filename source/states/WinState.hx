package states;

import entities.Player;
import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class WinState extends FlxSubState 
{
	private var levelCleared:FlxText;
	private var scoreInfo:FlxText;
	private var instructions:FlxText;
	private var highestScore:FlxText;
	
	public function new(BGColor:FlxColor=0x2200000) 
	{
		super(BGColor);
		
		levelClearedSetUp();
		instructionsSetUp();
		scoreInfoSetUp();
	}
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
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
	
	private function levelClearedSetUp():Void 
	{
		levelCleared = new FlxText(0, FlxG.height / 2 - 32, FlxG.width, "Level Cleared", 14, true);
		levelCleared.color = FlxColor.GREEN;
		levelCleared.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.WHITE, 1, 1);
		levelCleared.alignment = FlxTextAlign.CENTER;
		levelCleared.scrollFactor.set(0, 0);
		add(levelCleared);
	}
	
	private function instructionsSetUp()
	{
		instructions = new FlxText(0, FlxG.height / 2 + 48, FlxG.width, "Press ESC to go to the main menu", 8, true);
		instructions.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.GRAY, 1, 1);
		instructions.alignment = FlxTextAlign.CENTER;
		instructions.scrollFactor.set(0, 0);
		add(instructions);
	}
	
	private function scoreInfoSetUp():Void
	{
		scoreInfo = new FlxText(0, FlxG.height / 2 + 16, FlxG.width, "You scored " + Reg.score + " points", 8, true);
		scoreInfo.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.GRAY, 1, 1);
		scoreInfo.alignment = FlxTextAlign.CENTER;
		scoreInfo.scrollFactor.set(0, 0);
		add(scoreInfo);
		
		highestScore = new FlxText(0, FlxG.height / 2 + 32, FlxG.width, "Highest Score: " + Reg.highestScore, 8, true);
		highestScore.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.GRAY, 1, 1);
		highestScore.alignment = FlxTextAlign.CENTER;
		highestScore.scrollFactor.set(0, 0);
		add(highestScore); 
	}
}