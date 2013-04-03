package
{
	import org.flixel.*; 
	[SWF(width = "800", height = "600", backgroundColor = "#000000")] 
	[Frame(factoryClass="Preloader")]
 
	public class DungeonDelver extends FlxGame
	{
		public function DungeonDelver()
		{
			
			super(800, 600, MenuState, 1); 
		}
	}
}