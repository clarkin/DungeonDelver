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
		[Embed(source = "../assets/crown_coin.png")] private var crownCoinPNG:Class;
		[Embed(source = "../assets/spectre.png")] private var spectrePNG:Class;
		
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
		
		public var treasure_icon_left:FlxSprite, monster_icon_left:FlxSprite, treasure_icon_right:FlxSprite, monster_icon_right:FlxSprite;
		public var treasure_icon_label_left:FlxText, monster_icon_label_left:FlxText, treasure_icon_label_right:FlxText, monster_icon_label_right:FlxText; 
		
		public var player_alive:Boolean = true;
		public var player_treasure:int = 0;
		public var player_life:int = 5;
		public var player_treasure_label:FlxText, player_life_label:FlxText;
		
		public var leaveBtn:FlxButton;
		public var treasure_tile:Tile;
		public var treasure_tile_linked:Boolean = false;
		
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
			treasure_tile = new Tile("hint_treasure_room");
			addTileAt(treasure_tile, starting_point.x, starting_point.y - (Tile.TILESIZE * 8));
			
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
			treasure_icon_left = new FlxSprite(66, 225, crownCoinPNG);
			explorationChoice.add(treasure_icon_left);
			treasure_icon_label_left = new FlxText(66, 225, 26, "1");
			treasure_icon_label_left.setFormat(null, 8, 0xFFFFFF, "left", 0x666666);
			explorationChoice.add(treasure_icon_label_left);
			monster_icon_left = new FlxSprite(110, 225, spectrePNG);
			explorationChoice.add(monster_icon_left);
			monster_icon_label_left = new FlxText(110, 225, 26, "1");
			monster_icon_label_left.setFormat(null, 8, 0xFFFFFF, "left", 0x666666);
			explorationChoice.add(monster_icon_label_left);
			treasure_icon_right = new FlxSprite(318, 225, crownCoinPNG);
			explorationChoice.add(treasure_icon_right);
			treasure_icon_label_right = new FlxText(318, 225, 26, "1");
			treasure_icon_label_right.setFormat(null, 8, 0xFFFFFF, "left", 0x666666);
			explorationChoice.add(treasure_icon_label_right);
			monster_icon_right = new FlxSprite(362, 225, spectrePNG);
			explorationChoice.add(monster_icon_right);
			monster_icon_label_right = new FlxText(362, 225, 26, "1");
			monster_icon_label_right.setFormat(null, 8, 0xFFFFFF, "left", 0x666666);
			explorationChoice.add(monster_icon_label_right);
			explorationChoice.add(explorationTiles);
			explorationChoice.visible = false;
			
			player_treasure_label = new FlxText(-50, -50, 200, "Treasure: 0");
			player_treasure_label.setFormat(null, 20, 0xFFFF00, "left", 0x999900);
			add(player_treasure_label);
			leaveBtn = new FlxButton(160, -50, "Leave Now", leaveDungeon);
			add(leaveBtn);
			player_life_label = new FlxText(420, -50, 200, "Life: 5");
			player_life_label.setFormat(null, 20, 0xFF0000, "left", 0xFFCCCC);
			add(player_life_label);
			
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
			
			
			player_treasure_label.text = "Treasure: " + player_treasure;
			player_life_label.text = "Life: " + player_life;
			
			super.update();
			checkControls();
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
				if (choosingTile) {
					for each (var explorationTile:Tile in explorationTiles.members) {
						//trace("checking tile at " + explorationTile.x + ", " + explorationTile.y);
						if (explorationTile.overlapsPoint(clicked_at)) {
							chooseTile(explorationTile);
						}
					}
				} else {
					var found_highlight:Boolean = false;
					for each (var highlight:Tile in highlights.members) {
						//trace("checking highlight at " + highlight.x + ", " + highlight.y);
						if (highlight.alive && highlight.overlapsPoint(clicked_at)) {
							//trace("click at " + clicked_at.x + ", " + clicked_at.y);
							//trace("highlight at " + highlight.x + ", " + highlight.y);
							found_highlight = true;
							choosingHighlight = highlight;
							showTileChoice();					
						} 
					}
					if (!found_highlight && treasure_tile.overlapsPoint(clicked_at)) {
						//trace("exploring treasure room!");
						player_treasure += 10;
						
						var treasure_room_tile:Tile = new Tile("room_treasure")
						addTileAt(treasure_room_tile, treasure_tile.x, treasure_tile.y);
						treasure_tile.kill();
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
			FlxG.mouse.reset();
		}
		
		public function chooseRightTile():void {
			chooseTile(explorationTiles.members[1]);
			FlxG.mouse.reset();
		}
		
		public function chooseTile(tile:Tile):void {
			choosingTile = false;
			explorationChoice.visible = false;
			player_treasure += tile.treasure_cards;
			player_life -= tile.monster_cards;
			if (player_life <= 0) {
				player_alive = false;
				leaveDungeon();
			}
			
			addTileAt(tile, choosingHighlight.x, choosingHighlight.y);
			choosingHighlight.kill();
		}
		
		public function showTileChoice():void {
			choosingTile = true;
			explorationTiles.clear();  //possible mem leak
			var _new_tile:Tile = tileManager.GetRandomTile(choosingHighlight.higlight_entrance);
			_new_tile.x = 84;
			_new_tile.y = 168;
			explorationTiles.add(_new_tile);
			if (_new_tile.treasure_cards > 0) {
				treasure_icon_label_left.text = _new_tile.treasure_cards.toString();
				treasure_icon_label_left.visible = true;
				treasure_icon_left.visible = true;
			} else {
				treasure_icon_label_left.visible = false;
				treasure_icon_left.visible = false;
			}
			if (_new_tile.monster_cards > 0) {
				monster_icon_label_left.text = _new_tile.monster_cards.toString();
				monster_icon_label_left.visible = true;
				monster_icon_left.visible = true;
			} else {
				monster_icon_label_left.visible = false;
				monster_icon_left.visible = false;
			}
			_new_tile = tileManager.GetRandomTile(choosingHighlight.higlight_entrance);
			_new_tile.x = 336;
			_new_tile.y = 168;
			if (_new_tile.treasure_cards > 0) {
				treasure_icon_label_right.text = _new_tile.treasure_cards.toString();
				treasure_icon_label_right.visible = true;
				treasure_icon_right.visible = true;
			} else {
				treasure_icon_label_right.visible = false;
				treasure_icon_right.visible = false;
			}
			if (_new_tile.monster_cards > 0) {
				monster_icon_label_right.text = _new_tile.monster_cards.toString();
				monster_icon_label_right.visible = true;
				monster_icon_right.visible = true;
			} else {
				monster_icon_label_right.visible = false;
				monster_icon_right.visible = false;
			}
			explorationTiles.add(_new_tile);							
			explorationChoice.visible = true;		
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
								//trace("direction " + direction + " filled by " + this_tile.type);
								if (this_tile.type == "hint_treasure_room") {
									treasure_tile_linked = true;
								}
								filled = true;
								break;
							}
						}
						
						if (!filled) { 
							addHighlight(new_x, new_y, direction);
						}
					}
					
				}
			}
			
		}
		
		public function addHighlight(X:int, Y:int, from_direction:int):void {
			var new_highlight:Tile = new Tile("highlight", X, Y);
			new_highlight.higlight_entrance = Tile.oppositeDirection(from_direction);
			highlights.add(new_highlight);
		}
		
		public function leaveDungeon():void {
			FlxG.switchState(new GameOverState(player_treasure, player_alive));
		}
	}
}