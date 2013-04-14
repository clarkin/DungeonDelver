package
{
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import flash.geom.*;
	import org.flixel.*;
	import org.flixel.system.FlxTile;
 
	public class PlayState extends FlxState
	{
		[Embed(source = "../assets/question_marks.png")] private var questionMarksPNG:Class;
		
		public var tileManager:TileManager;
		public var tiles:FlxGroup = new FlxGroup();
		public var highlights:FlxGroup = new FlxGroup();
		public var explorationChoice:FlxGroup = new FlxGroup();
		public var cameraFocus:FlxSprite = new FlxSprite();
		public var questionMarks:FlxSprite;
		public var explorationTiles:FlxGroup = new FlxGroup();
		
		public static const starting_point:Point = new Point(210, 420);
		
		public var choosingHighlight:Tile;
		public var choosingTile:Boolean = false;
		
		override public function create():void {
			//FlxG.visualDebug = true;
			//FlxG.camera.setBounds(0, 0, 462, 462);
			//FlxG.worldBounds = new FlxRect(0, 0, 462, 462);
			
			tileManager = new TileManager();
			//for (var i:int = 0; i < 100; i++) {
			//	var new_tile:Tile = tileManager.GetRandomTile(TileManager.NORTH);
			//}
			
			var starting_tile:Tile = new Tile("corr_dead1");
			addTileAt(starting_tile, starting_point.x, starting_point.y);
			var treasure_Tile:Tile = new Tile("spec_treasure");
			addTileAt(treasure_Tile, starting_point.x, starting_point.y - (Tile.TILESIZE * 8));
			
			var blank_tile:Tile;
			var i:int;
			var new_x:int = starting_point.x;
			var new_y:int = starting_point.y;
			for (i = 1; i <= 5; i++) {
				blank_tile = new Tile("empty");
				new_x += Tile.TILESIZE;
				addTileAt(blank_tile, new_x, new_y);
			}
			for (i = 1; i <= 10; i++) {
				blank_tile = new Tile("empty");
				new_y -= Tile.TILESIZE;
				addTileAt(blank_tile, new_x, new_y);
			}
			for (i = 1; i <= 10; i++) {
				blank_tile = new Tile("empty");
				new_x -= Tile.TILESIZE;
				addTileAt(blank_tile, new_x, new_y);
			}
			for (i = 1; i <= 10; i++) {
				blank_tile = new Tile("empty");
				new_y += Tile.TILESIZE;
				addTileAt(blank_tile, new_x, new_y);
			}
			for (i = 1; i <= 4; i++) {
				blank_tile = new Tile("empty");
				new_x += Tile.TILESIZE;
				addTileAt(blank_tile, new_x, new_y);
			}
			
			questionMarks = new FlxSprite(0, 0, questionMarksPNG);
			explorationChoice.add(questionMarks);
			var leftButton:FlxButton = new FlxButton(66, 274, "Choose", chooseLeftTile);
			explorationChoice.add(leftButton);
			var rightButton:FlxButton = new FlxButton(319, 274, "Choose", chooseRightTile);
			explorationChoice.add(rightButton);
			//var new_tile:Tile = new Tile("corr_fourway");
			//explorationTiles.add(new_tile);
			//new_tile = new Tile("room_fourway");
			//explorationTiles.add(new_tile);
			explorationChoice.add(explorationTiles);
			explorationChoice.visible = false;
			
			//cameraFocus.x = starting_point.x + Tile.TILESIZE;
			//cameraFocus.y = starting_point.y + Tile.TILESIZE;
			//FlxG.camera.follow(cameraFocus, FlxCamera.STYLE_TOPDOWN_TIGHT);
			//add(cameraFocus); //todo move camera directly rather than following fake sprite
			FlxG.camera.focusOn(new FlxPoint(210 + Tile.TILESIZE / 2, 210 + Tile.TILESIZE / 2));
			
			add(tiles);
			add(highlights);
			add(explorationChoice);
		}
		
		override public function update():void {
			checkControls();
			
			super.update();
		}
		
		private function checkControls():void {
			checkMouseHover();
			checkMouseClick();
			checkKeyboard();
		}
		
		public function checkMouseHover():void {
			
		}
		
		public function checkMouseClick():void {
			if (FlxG.mouse.justReleased()) {
				var clicked_at:FlxPoint = FlxG.mouse.getWorldPosition();
				//trace("click at " + clicked_at.x + ", " + clicked_at.y);
				if (choosingTile) {
					for each (var explorationTile:Tile in explorationTiles.members) {
						//trace("checking tile at " + explorationTile.x + ", " + explorationTile.y);
						if (explorationTile.overlapsPoint(clicked_at)) {
							chooseTile(explorationTile);
						}
					}
				} else {
					for each (var highlight:Tile in highlights.members) {
						//trace("checking highlight at " + highlight.x + ", " + highlight.y);
						if (highlight.alive && highlight.overlapsPoint(clicked_at)) {
							//trace("click at " + clicked_at.x + ", " + clicked_at.y);
							//trace("highlight at " + highlight.x + ", " + highlight.y);
							
							choosingHighlight = highlight;
							choosingTile = true;
							
							explorationTiles.clear();
							var _new_tile:Tile = tileManager.GetRandomTile(highlight.higlight_entrance);
							_new_tile.x = 84;
							_new_tile.y = 168;
							//_new_tile.x = choosingHighlight.x - Tile.TILESIZE * 0.8;
							//_new_tile.y = choosingHighlight.y - Tile.TILESIZE / 2;
							explorationTiles.add(_new_tile);
							_new_tile = tileManager.GetRandomTile(highlight.higlight_entrance);
							_new_tile.x = 336;
							_new_tile.y = 168;
							//_new_tile.x = choosingHighlight.x + Tile.TILESIZE * 0.8;
							//_new_tile.y = choosingHighlight.y - Tile.TILESIZE / 2;
							explorationTiles.add(_new_tile);							
							explorationChoice.visible = true;							
						}
					}
				}
			}
		}
		
		public function checkKeyboard():void {
			if (FlxG.keys.justReleased("SPACE")) {
				trace("*** RESET ***");
				FlxG.switchState(new PlayState);
			} else if (FlxG.keys.pressed("UP")) {
				cameraFocus.acceleration.y -= 50;
			} else if (FlxG.keys.pressed("RIGHT")) {
				cameraFocus.acceleration.x += 50;
			} else if (FlxG.keys.pressed("DOWN")) {
				cameraFocus.acceleration.y += 50;
			} else if (FlxG.keys.pressed("LEFT")) {
				cameraFocus.acceleration.x -= 50;
			} else {
				cameraFocus.acceleration.x = cameraFocus.acceleration.y = cameraFocus.velocity.x = cameraFocus.velocity.y = 0;
			}
			
			//cameraFocus
		}
		
		public function chooseLeftTile():void {
			chooseTile(explorationTiles.members[0]);
		}
		
		public function chooseRightTile():void {
			chooseTile(explorationTiles.members[1]);
		}
		
		public function chooseTile(tile:Tile):void {
			choosingTile = false;
			explorationChoice.visible = false;
			addTileAt(tile, choosingHighlight.x, choosingHighlight.y);
			choosingHighlight.kill();
		}
		
		public function addTileAt(tile:Tile, X:int, Y:int):void {
			tile.x = X;
			tile.y = Y;
			tiles.add(tile);
			//trace("adding tile at " + X + "," + Y);
			
			if (tile.type.indexOf("corr") == 0 || tile.type.indexOf("room") == 0) { 
				for each (var direction:int in tileManager.all_directions) {
					//trace ("checking " + direction + " for tile of type " + tile.type);
					if (tile.checkExit(direction)) {
						//trace("adding new highlight to " + direction);
						var new_x:int = X;
						var new_y:int = Y;
						if (direction == TileManager.NORTH)
							new_y -= Tile.TILESIZE;
						else if (direction == TileManager.EAST)
							new_x += Tile.TILESIZE;
						else if (direction == TileManager.SOUTH)
							new_y += Tile.TILESIZE;
						else if (direction == TileManager.WEST)
							new_x -= Tile.TILESIZE;
						
						//don't add highlight if that tile is already filled 
						var filled:Boolean = false;
						for each (var this_highlight:Tile in highlights.members) {
							if (this_highlight.x == new_x && this_highlight.y == new_y) {
								filled = true;
								break;
							}
						}
						for each (var this_tile:Tile in tiles.members) {
							if (this_tile.x == new_x && this_tile.y == new_y) {
								filled = true;
								break;
							}
						}
						
						if (!filled) 
							addHighlight(new_x, new_y, direction);
					}
					
				}
			}
			
		}
		
		public function addHighlight(X:int, Y:int, from_direction:int):void {
			var new_highlight:Tile = new Tile("highlight", X, Y);
			new_highlight.higlight_entrance = Tile.oppositeDirection(from_direction);
			highlights.add(new_highlight);
		}
	}
}