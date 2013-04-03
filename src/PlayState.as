package
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import org.flixel.*;
 
	public class PlayState extends FlxState
	{
		public var tileManager:TileManager;
		public var tiles:FlxGroup = new FlxGroup();
		public var highlights:FlxGroup = new FlxGroup();
		public var cameraFocus:FlxSprite = new FlxSprite();
		
		public static const starting_point:Point = new Point(400, 400);
		
		override public function create():void {
			//FlxG.visualDebug = true;
			//FlxG.camera.setBounds(0, 0, 800, 1000);
			//FlxG.worldBounds = new FlxRect(0, 0, 800, 1000);
			
			tileManager = new TileManager();
			//for (var i:int = 0; i < 100; i++) {
			//	var new_tile:Tile = tileManager.GetRandomTile(TileManager.NORTH);
			//}
			
			var starting_tile:Tile = new Tile("corr_dead1");
			addTileAt(starting_tile, starting_point.x, starting_point.y);
			
			cameraFocus.x = starting_point.x + Tile.TILESIZE;
			cameraFocus.y = starting_point.y + Tile.TILESIZE;
			FlxG.camera.follow(cameraFocus, FlxCamera.STYLE_TOPDOWN_TIGHT);
			//add(cameraFocus); //todo move camera directly rather than following fake sprite
			
			add(tiles);
			add(highlights);
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
				for each (var highlight:Tile in highlights.members) {
					//trace("checking highlight at " + highlight.x + ", " + highlight.y);
					if (highlight.alive && highlight.overlapsPoint(clicked_at)) {
						//trace("click at " + clicked_at.x + ", " + clicked_at.y);
						//trace("highlight at " + highlight.x + ", " + highlight.y);
						var new_tile:Tile = tileManager.GetRandomTile(highlight.higlight_entrance);
						addTileAt(new_tile, highlight.x, highlight.y);
						cameraFocus.x = highlight.x + Tile.TILESIZE;
						cameraFocus.y = highlight.y + Tile.TILESIZE;
						highlight.kill();
						//highlights.remove(highlight, true);
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
		
		public function addTileAt(tile:Tile, X:int, Y:int):void {
			tile.x = X;
			tile.y = Y;
			tiles.add(tile);
			
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
		
		public function addHighlight(X:int, Y:int, from_direction:int):void {
			var new_highlight:Tile = new Tile("highlight", X, Y);
			new_highlight.higlight_entrance = Tile.oppositeDirection(from_direction);
			highlights.add(new_highlight);
		}
	}
}