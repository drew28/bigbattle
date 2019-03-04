package  {
	
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.filesystem.File;
	
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import flash.display.MovieClip;
	import flash.display.Stage;	
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	public class LevelGenerator extends MovieClip {
		
		// Constants:
		// Public Properties:
		// Private Properties:
			var levelArray:Array;
			var numRows:int;
			var numCols:int;
		// Initialization:
		public function LevelGenerator() {
			numRows = 24;
			numCols = 500;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			include "level0.as"  //load data from external file, just like game.
			
			levelArray = new Array(numRows);
			for(var i:int = 0; i < levelArray.length; i++)
			{
				levelArray[i] = new Array(numCols);
			}
				
			for (var row:int = 0; row < levelArray.length; row ++)
				for (var col:int = 0; col < levelArray[row].length; col++)
					{
						var terrain:LevelTerrain = new LevelTerrain();
						levelArray[row][col] = terrain;
						levelArray[row][col].x = 25 * col; //(levelArray[row][col].width * col);
						levelArray[row][col].y = (25 * row);
						//levelArray[row][col].stop();
						levelArray[row][col].gotoAndStop(level[row][col] + 1)
						levelArray[row][col].buttonMode = true;
						levelArray[row][col].addEventListener(MouseEvent.CLICK, adjustBlock);
						addChild(levelArray[row][col]);
					}
					
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);				
				
		}
	
		// Public Methods:
		public function adjustBlock(e:MouseEvent):void
		{
			if(e.currentTarget.currentFrame < e.currentTarget.totalFrames)
			{
				e.currentTarget.nextFrame();
			}
			else
			{
				e.currentTarget.gotoAndStop(1);
			}
		}
		
		public function generateCode():void
		{
			var msg:String = "var level:Array = new Array( ";
			trace(msg);
			for (var row:int = 0; row < levelArray.length; row ++)
			{
				msg = "new Array(";
				for (var col:int = 0; col < levelArray[row].length; col++)
					{
						var frameValue:int = levelArray[row][col].currentFrame - 1;
						msg += frameValue;
						if(col < levelArray[row].length - 1)
							msg += ", ";
					}
				msg += ")";
				if(row < levelArray.length - 1)
					msg += ",";
				trace(msg);
			}
			trace(");");
		}
		/*
		public function loadMap():void
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loadData);
			loader.load(new URLRequest("level1.as"));			
		}
		
		public function loadData(e:Event):void
		{
			trace(e.data)
		}*/
		
		public function moveMap(moveValue:int):void
		{
			if(levelArray[0][0].x + moveValue < 0 && levelArray[numRows - 1][numCols - 1].x + moveValue > 775)
			{
			for (var row:int = 0; row < levelArray.length; row ++)
				for (var col:int = 0; col < levelArray[row].length; col++)
				{
					levelArray[row][col].x += moveValue;
					if(levelArray[row][col].x >= -5 && levelArray[row][col].x <= 805)
						levelArray[row][col].visible = true;
					else
						levelArray[row][col].visible = false;
				}
			}
		}
		
		public function onKeyPress(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.LEFT || e.keyCode == 65)
			{
				if(e.shiftKey == true)
					moveMap(775);
				else
					moveMap(25);
			}
			if(e.keyCode == Keyboard.RIGHT || e.keyCode == 68)
			{
				if(e.shiftKey == true)
					moveMap(-775);
				else
					moveMap(-25);
			}
			if(e.keyCode == 71 || e.keyCode == Keyboard.SPACE)
				createFile();
		}
		
		private function createFile():void {
			var newFile:File=File.desktopDirectory.resolvePath("level0.as");
			var fileStream:FileStream = new FileStream();
			fileStream.open(newFile, FileMode.WRITE);
			var msg:String = "var level:Array = new Array( \n";
			fileStream.writeUTFBytes(msg);
			for (var row:int = 0; row < levelArray.length; row ++)
			{
				msg = "new Array(";
				for (var col:int = 0; col < levelArray[row].length; col++)
					{
						var frameValue:int = levelArray[row][col].currentFrame - 1;
						msg += frameValue;
						if(col < levelArray[row].length - 1)
							msg += ", ";
					}
				msg += ")";
				if(row < levelArray.length - 1)
					msg += ",";
				fileStream.writeUTFBytes(msg + "\n");
			}
			fileStream.writeUTFBytes(");");

			fileStream.close();
		}
		
		// Protected Methods:
	}
	
}