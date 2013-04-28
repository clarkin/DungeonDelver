package
{
	import org.flixel.*;

	public class GameOverState extends FlxState
	{
		public var finalScore:int = 0;
		public var survived:Boolean = true;

		public function GameOverState(finalScore:int, survived:Boolean)
		{
			this.finalScore = finalScore;
			this.survived = survived;
		}

		override public function create():void
		{
			var titleString:String = "You made it out!";
			var resultsString:String = "You managed to find " + finalScore.toString() + " treasure!";
			if (!survived) {
				titleString = "You died!";
				resultsString = "You had found " + finalScore.toString() + " treasure so far..";
			}
			
			var title:FlxText = new FlxText(0, 100, 800, titleString);
			title.setFormat(null, 24, 0xFF3333CC, "center");
			
			var results:FlxText = new FlxText(0, 200, 800, resultsString);
			results.setFormat(null, 16, 0xFFFFFFCC, "center");
			
			var startOverBtn:FlxButton = new FlxButton(350, 400, "Try Again", startGame);
			
			add(title);
			add(results);
			add(startOverBtn);
			
		}
		
		override public function update():void {
			
			super.update();
		}

		private function startGame():void
		{
			FlxG.switchState(new PlayState);
		}
	}
}