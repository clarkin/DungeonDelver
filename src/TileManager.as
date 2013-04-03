package  
{
	import org.flixel.*;
	
	public class TileManager 
	{
		public static const NORTH:int = 1;
		public static const EAST:int  = 2;
		public static const SOUTH:int = 4;
		public static const WEST:int  = 8;
		
		public var all_directions:Array = new Array(NORTH, EAST, SOUTH, WEST);
		public var all_tiles:Array = new Array();
		
		public function TileManager() {
			//create one of every tile
			for (var i:int = 0; i < Tile.ALL_TILES.length; i++) {
				all_tiles.push(new Tile(Tile.ALL_TILES[i]));
			}
		}
		
		public function GetRandomTile(entrance:int = NORTH):Tile {
			var searching:Boolean = true;
			var this_tile:Tile;
			while (searching) {
				this_tile = all_tiles[Math.floor(Math.random() * (all_tiles.length))];
				//trace("trying " + this_tile.type);
				if (this_tile.checkExit(entrance)) {
					searching = false;
				}
				
			}
			
			//trace("found " + this_tile.type);
			return new Tile(this_tile.type);
		}
		
		
		
	}

}