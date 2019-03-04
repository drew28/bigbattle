package {
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;	
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import flash.ui.Keyboard;	

	public class SpaceShooter extends MovieClip
	{
		//private var levelGenerator:Level;
const TESTINGTESTING123:Boolean = false;		
		
		var gameContainer:MovieClip;
		var currentLevel:Number;
		
		//  Max Number of Each Mover on stage
		private var numberOfAsteroids:Number;
		private var numberOfBullets:Number;
		private var numberOfBulletPowerUps:Number;
		private var numberOfEnemyShips:Number;
		private var numberOfHealthPowerUps:Number;
		private var numberOfStars:Number;
		
		//  Minimum number of shootables before the array is filled
		private var minAsteroids:Number;
		private var minEnemyShips:Number;
		
		//  Min and Max number of Fragments in  a particle explosion
		private var minFragments:Number;
		private var maxFragments:Number;
		
		// keeps tracks of how many EnemyShips are destroyed
		private var bossFrame:Number;
		private var bossCount:Number;
		private var shipsDestroyed:Number;
		
		//  Mover containers of display objects
		private var asteroidsArray:Array;
		private var bulletsArray:Array;
		private var bulletPowerUpsArray:Array;
		private var enemyBossesArray:Array;
		private var enemyShipsArray:Array;		
		private var enemyBulletsArray:Array;
		private var fragmentsArray:Array;
		private var healthPowerUpsArray:Array;
		private var starsArray:Array;
		private var levelArray:Array;
		
		//  Player instantiation and key inputs
		private var player:PlayerShip;
		private var left:Boolean;
		private var down:Boolean;
		private var right:Boolean;
		private var up:Boolean;
		private var firing:Boolean;
		
		//  Boss mover
		private var boss:EnemyBoss;
		
		//  Game variables
		private var score:Number;
		private var healthMeter:HealthMeter;
		
		//  Sound channels and variables
		public var soundChannel:SoundChannel;
		private var globalVolume:Number;
		private var large_explode_snd:LargeExplosionSound;
		private var explode_snd:ExplosionSound;
		private var gunshot_snd:GunshotSound;
		private var small_gunshot_snd:SmallGunshotSound;
		private var large_gunshot_snd:LargeGunshotSound;
		
		private var musicChannel:SoundChannel;
		private var levelMusic0:Sound;//LevelMusic0;
		
		// Create a shared-object named "highScores"
		public var score_txt:TextField;
		//public var tulipSharedObject:SharedObject = SharedObject.getLocal("highScores", "/");
		
		private var startButton:StartButton;
		private var titleScreen:TitleScreen;
		private var gameOverScreen:GameOverScreen;
		
		public var usingMouse:Boolean;
		private var gameState:int;
		private var CONTINUE:int;
		private var GAMEOVER:int;
		private var PAUSE:int;
		private var STARTING:int;
		
		public var STAGEWIDTH:Number;
		public var STAGEHEIGHT:Number;
		public var lastBlockInLevel:LevelTerrain;
		
		var levelOverLayArray:Array;
		//var endOfLevel:Boolean;
		
		
		//  Class constructor includes Event.ADDED_TO_STAGE only because other functions need to access stage
		public function SpaceShooter() 
		{
			//stage.align = StageAlign.TOP_LEFT;
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			//stage.addEventListener(ProgressEvent.PROGRESS, preLoad);
			addEventListener(Event.ADDED_TO_STAGE, showStartPopUp);
		}
		
		/*public function preLoad(e:ProgressEvent)
		{
			trace("preloading: loaded:" + e.bytesLoaded + " of " + e.bytesTotal);
			trace(e.toString());
		}
		*/
		public function init(e:MouseEvent):void
		{
			startButton.removeEventListener(MouseEvent.CLICK, init);
			removeChild(startButton);
			if(titleScreen.parent != null)
				removeChild(titleScreen);
			if(gameOverScreen)
				if(gameOverScreen.parent != null)
					removeChild(gameOverScreen);			
			
					
			//  Game Variables
			trace("Creating game variables.");
			numberOfEnemyShips = 0;
			numberOfAsteroids = 0;
			numberOfStars = 50;
			minEnemyShips = 3;
			minAsteroids = 1;
			minFragments = 10;
			maxFragments = 50;
			
			bossFrame = 0;
			bossCount = 51;
			shipsDestroyed = 0;
			
			
			
			trace("Creating MovieClip containers.");
			asteroidsArray = new Array();
			bulletsArray = new Array();
			bulletPowerUpsArray = new Array();
			enemyBossesArray = new Array();
			enemyShipsArray = new Array();
			enemyBulletsArray = new Array();
			fragmentsArray = new Array();
			healthPowerUpsArray = new Array();
			starsArray = new Array();

			
			trace("Creating sounds.");
			soundChannel = new SoundChannel();
			musicChannel = new SoundChannel();
			globalVolume = .25;
			large_explode_snd = new LargeExplosionSound();
			explode_snd = new ExplosionSound();
			gunshot_snd = new GunshotSound();
			large_gunshot_snd = new LargeGunshotSound();
			small_gunshot_snd = new SmallGunshotSound();

			levelMusic0 = new Sound();// = new LevelMusic0();
			
			var mover:Mover;
			
			/**
			 *  Ever think about using a static factory? or a builder function
			 */
			
			trace("Generating stars.");
			for(var i = 0; i < numberOfStars; i++)
			{
				var star:Star = new Star(STAGEWIDTH, STAGEHEIGHT);
				mover = setMover(star, star.x, star.y, star.speedX, star.speedY, false, false, "jumpLeftToRight");
				mover.alpha = Math.random();
				addChild(star);
				starsArray.push(star);
			}
			/*
			trace("Generating Enemyships.");
			for(i = 0; i < numberOfEnemyShips; i++) 
			{
				var enemyShip:EnemyShip = new EnemyShip();
				mover = setMover(enemyShip, STAGEWIDTH + 200 + (enemyShip.height * i), 400, 10,	enemyShip.speedY, true, false, "enterFromRight");
				addChild(mover);
				enemyShipsArray.push(mover);
			}
			
			trace("Generating Asteroids.");
			for(i = 0; i < numberOfAsteroids; i++) 
			{
				var asteroid:Asteroid = new Asteroid();
			    mover = setMover(asteroid,asteroid.x, asteroid.y, asteroid.speedX, asteroid.speedY, false, false, "bounceAllSides");
				addChild(mover);
				asteroidsArray.push(mover);
			}
			*/
			
			//levelGenerator = new Level();
			createLevel();
			
			
			//Mouse.hide();
			//
			//add target icon and drag to mouse
			//
			initPlayer();
			initScore();
			initHealthMeter();
			
			trace("Assigning Listeners");
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);				
			stage.addEventListener(Event.ENTER_FRAME, rotatePlayer);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, shootPlayerBullet);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, shootPlayerBullet);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
			
			var transform:SoundTransform = soundChannel.soundTransform;
			transform.volume = globalVolume;
			soundChannel.soundTransform = transform;
			
			up = false;
			down = false;
			left = false;
			right = false;
			firing = false;
			
			usingMouse = true;
			
			CONTINUE = 0;
			GAMEOVER = 1;
			STARTING = 2;
			PAUSE = 3;
			
			gameState = CONTINUE;
			//endOfLevel = false;
			
			
		}
		
		
		public function createLevel():void
		{
			trace("Generating Terrain.");
			
			if(currentLevel == 1)
				levelMusic0.load(new URLRequest("level0.mp3"));
			include "level0.as" //load data from external file, just like level generator

			if(!musicChannel)
				levelMusic0.load(new URLRequest("level0.mp3"));
			musicChannel = levelMusic0.play(0,int.MAX_VALUE);
			
			levelOverLayArray = new Array();
			
			
			
			levelArray = new Array();
			var tb:LevelTerrain = new LevelTerrain(); //for non-levelterrains
			lastBlockInLevel = new LevelTerrain();
			lastBlockInLevel.x = 0;
			for (var row:int = 0; row < level.length; row ++)
				for (var col:int = 0; col < level[row].length; col++)
				{
					if(level[row][col] == 7)
					{
						var enemyShip:EnemyShip = new EnemyShip();
						
						enemyShip.x = 800 + (25 * col);
						enemyShip.y = (600 - (level.length * 25)) + 25 * row;
						enemyShip.strength *= currentLevel;
						var shipMover = setMover(enemyShip, enemyShip.x, enemyShip.y, tb.speedX, 0, true, false, "levelTerrain");
						addChild(shipMover);
						enemyShipsArray.push(shipMover);
					}
					else if(level[row][col] == 6)
					{
						var healthPowerUp:HealthPowerUp = new HealthPowerUp();
						
						healthPowerUp.x = 800 + (25 * col);
						healthPowerUp.y = (600 - (level.length * 25)) + (25 * row);
						
						var hpuMover = setMover(healthPowerUp, healthPowerUp.x, healthPowerUp.y, tb.speedX, 0, false, false, "levelTerrain");
						healthPowerUpsArray.push(hpuMover);
						addChild(hpuMover);
					}
					else if(level[row][col] == 5)
					{
						var bulletPowerUp:BulletPowerUp = new BulletPowerUp();
						
						bulletPowerUp.x = 800 + (25 * col);
						bulletPowerUp.y = (600 - (level.length * 25)) + (25 * row);
						
						var bpuMover = setMover(bulletPowerUp, bulletPowerUp.x, bulletPowerUp.y, tb.speedX, 0, false, false, "levelTerrain");
						bulletPowerUpsArray.push(bpuMover);
						addChild(bpuMover);
					}
					else if(level[row][col] > 0) // only create a levelTerrain block if there is one
					{
						var terrainBlock:LevelTerrain = new LevelTerrain();
						terrainBlock.x = 800 + (terrainBlock.width * col);
						if(lastBlockInLevel.x < terrainBlock.x)
							lastBlockInLevel = terrainBlock;
						terrainBlock.y = (600 - (level.length * 25)) + (25 * row);//(level.length * terrainBlock.height * row) ;
						var mover = setMover(terrainBlock, terrainBlock.x, terrainBlock.y, terrainBlock.speedX, terrainBlock.speedY,false, false,"levelTerrain");
						//trace("x: " + terrainBlock.x + "y: " + terrainBlock.y);
						mover.gotoAndStop(level[row][col]);
						levelArray.push(mover);
						mover.scaleX = 1;
						addChild(mover);
					}
				}
				
			var levelOverLay:LevelOverLay = new LevelOverLay();
			for(var i:int = 1; i <= levelOverLay.totalFrames; i++)
			{
				levelOverLay = new LevelOverLay();
				levelOverLay.x = 800 * i;
				levelOverLay.gotoAndStop(i);
				var m = setMover(levelOverLay, levelOverLay.x, 0, levelOverLay.speedX, levelOverLay.speedY,false, false,"levelTerrain");
				levelOverLayArray.push(m);
				m.visible = true;
				addChild(m);
			}			
				
				
		}
		
		private function createBoss():void
		{
			//trace("\t\t\t\tx: "+levelArray[levelArray.length - 1].x);
			if(enemyBossesArray[0] == null)
			{
				boss = new EnemyBoss();
				
				boss.gotoAndStop(++bossFrame);
				
				boss.x = STAGEWIDTH / 2;
				boss.y = STAGEHEIGHT / 2;
				boss.speedX = 0;
				boss.speedY = 0;
				
				boss.applyMove = function()
				{
					//blank!
				}
			
				addChild(boss);
				
				if(musicChannel)
					musicChannel.stop();
				//bossMusicChannel = .play();
				enemyBossesArray[0] = boss;
			
				//bossCount += 51;
				//endOfLevel = true;
			}
			/*else
			{
				enemyBossesArray[0].removeFlag = true;
				currentLevel++;
				//createLevel();
			}*/

		}


		public function enterFrameHandler(e:Event):void 
		{
			switch(gameState)
			{
				case CONTINUE: 
						continueGame();
					break;
				case GAMEOVER:
						//finish moving the explosion of the player ship
						if(getNumberOfMovers(fragmentsArray))
						{
							moveMovers(levelArray);
							moveMovers(fragmentsArray);	
							moveMovers(bulletsArray);
							moveMovers(asteroidsArray);
							moveMovers(bulletPowerUpsArray);
							moveMovers(enemyBossesArray);
							moveMovers(enemyShipsArray);
							moveMovers(enemyBulletsArray);
							moveMovers(healthPowerUpsArray);
							moveMovers(starsArray);
							moveMovers(levelOverLayArray);
						}
						else
						{
							showEndPopUp();
							gameState = PAUSE;
						}
					break;
				case PAUSE:
						//blank
					break;
				default: gameState = CONTINUE;
			}
		}
		
		private function showStartButton():void
		{
			startButton = new StartButton();
			startButton.buttonMode = true;
			startButton.x = (STAGEWIDTH / 2) + 100;
			startButton.y = (STAGEHEIGHT / 2) + 50;
			startButton.addEventListener(MouseEvent.CLICK, init);
			
			/*gameContainer.*/addChild(startButton);
		}
		
		/** showStartPopUp take the Event.ADDED_TO_STAGE event and sets the 
		 *  stage dimensions and instantiates gameContainer, adds the
		 *  title screen and start button.
		 */
		private function showStartPopUp(e:Event):void
		{
			//instantiate gameContainer size
			STAGEWIDTH = 800;
			STAGEHEIGHT = 600;
			
			/*gameContainer = new MovieClip();
			gameContainer.width = STAGEWIDTH;
			gameContainer.height = STAGEHEIGHT;
			addChild(gameContainer);
			*/
			titleScreen = new TitleScreen();
			addChild(titleScreen);
			currentLevel = 1;
			
			showStartButton();
		} 
		
		private function initPlayer():void
		{
			player = new PlayerShip();
			player.friction = .9;
			player.applyMove = function()
			{
				//  Obey the Speed Limit!
				if(left && this.speedX > -this.maxSpeed)
					this.speedX--;
				if(right && this.speedX < this.maxSpeed)
					this.speedX++;
				if(up && this.speedY > -this.maxSpeed)
					this.speedY--;
				if(down && this.speedY < this.maxSpeed)
					this.speedY++;
				

				
				//  Move the ship
				this.x += this.speedX;
				this.y += this.speedY;
				
				this.applyFriction();
				
				//should the spaceship bounce?
				// It will multiply either -1 or 0 to apply the bounce
				var bounce:Number = 0; 
				
				//  Boundary Check the ship
				if (this.x > STAGEWIDTH) 
				{
					this.x = STAGEWIDTH;
					this.speedX *= bounce;
				} 
				else if (this.x < 0) 
				{
					this.x = 0;
					this.speedX *= bounce;
				}
				if (this.y > STAGEHEIGHT) 
				{
					this.y = STAGEHEIGHT-5;
					this.speedY *= bounce;
				} 
				else if (this.y < 20) 
				{
					this.y = 20;
					this.speedY *= bounce;
				}
if(!TESTINGTESTING123){
				//if(this.buffer == false) //causes problems?!
				//{
					
					/**
					 *  Hit detection for PlayerShip
					 */
					
					var net:int = 0;
					var gross:int = 0;
					
					
					/**
					 *  Check if the ship hits any HealthPowerUps
					 *  iterates through whole array searching for non-null entities
					 */
					for each(var enemyShip:EnemyShip in enemyShipsArray)
					{
						if(enemyShip != null && enemyShip.visible)
						{
							net++;
							if(this.hitTestObject(enemyShip))
							{
								this.strength -= enemyShip.strength;
							}
						}
					}
					gross += enemyShipsArray.length;
										
					/**
					 *  
					 *  iterates through whole array searching for non-null entities
					 */
					for each(var enemyBullet:EnemyBullet in enemyBulletsArray)
					{
						if(enemyBullet != null && enemyBullet.visible)
						{
							net++;
							if(this.hitTestObject(enemyBullet))
							{
								this.strength -= enemyBullet.strength;
								enemyBullet.removeFlag = true;
							}
						}
					}
					gross += enemyBulletsArray.length;

					/**
					 *  
					 *  iterates through whole array searching for non-null entities
					 */
					for each(var asteroid:Asteroid in asteroidsArray)
					{
						if(asteroid != null && asteroid.visible)
						{
							net++;
							if(this.hitTestObject(asteroid))
							{
								this.strength -= asteroid.strength;
							}
						}
					}
					gross += asteroidsArray.length;
					
					/**
					 *  Check if the ship hits any HealthPowerUps
					 *  iterates through whole array searching for non-null entities
					 */
					for each(var hpu:HealthPowerUp in healthPowerUpsArray)
					{
						if(hpu != null && hpu.visible)
						{
							net++;
							if(this.hitTestObject(hpu))
							{
								this.strength += hpu.strength;
								hpu.removeFlag = true;
								if(this.strength > 100)
								{
									this.strength = 100;
								}
							}
						}
					}
					gross += healthPowerUpsArray.length;
					
					/**
					 *  Check if the ship hits any BulletPowerUps
					 *  iterates through whole array searching for non-null entities
					 */
					for each(var bpu:BulletPowerUp in bulletPowerUpsArray)
					{
						if(bpu != null && bpu.visible)
						{
							net++;
							if(this.hitTestObject(bpu))
							{
								this.gunStrength += bpu.strength;
								bpu.removeFlag = true;
							}
						}
					}
					gross += bulletPowerUpsArray.length;
					
					/**
					 *  Check if the ship hits any EnemyBosses
					 *  iterates through whole array searching for non-null entities
					 */
					//for each(i = 0; i < enemyBossesArray.length; i++)
					//{
						if(enemyBossesArray[0] != null)
						{
							if(this.hitTestObject(enemyBossesArray[0]))
							{
								this.strength -= enemyBossesArray[0].strength;
							}
						}
					//}
					
					/**
					 *  Check if the ship hits the level.
					 */
					for each(var terrainBlock:LevelTerrain in levelArray)
					{
						if(terrainBlock != null && terrainBlock.visible == true)
						{
							net++;
							if(this.hitTestObject(terrainBlock))
							{
								this.removeFlag = true;
							}
						}
					}
					gross += levelArray.length;
					//trace("net: " + net + "\t\tgross: " + gross);
}
					/**
					 *  Kill the ship!
					 */
					if(this.strength < 0 || this.removeFlag == true)
					{
						if(this.parent != null)
						{
							soundChannel = explode_snd.play();
							if(musicChannel)
								musicChannel.stop();
							//var explode_gif:Explosion_gif = new Explosion_gif();
							//explode_gif.x = this.x;
							//explode_gif.y = this.y;
							//addChild(explode_gif);
							explode(this.x, this.y, "large");
							delete this;
							this.parent.removeChild(this);
							
							trace("Removing listeners");
							
							stage.removeEventListener(Event.ENTER_FRAME, rotatePlayer);
							stage.removeEventListener(MouseEvent.MOUSE_DOWN, shootPlayerBullet);
							stage.removeEventListener(MouseEvent.MOUSE_WHEEL, shootPlayerBullet);
							stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
							stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
							
							gameState = GAMEOVER;
						}
					}
				//}
			}
			
			
			addChild(player);
		}
		
		private function initScore():void
		{
			score = 0;
			if(score_txt)
			{
				removeChild(score_txt);
				score_txt = null;
			}
			if(!score_txt)
			{
				trace("Generating score field.");
				score_txt = new TextField();
				score_txt.autoSize = TextFieldAutoSize.LEFT;
				score_txt.background = false;
				score_txt.x = 550;
				score_txt.y = 50;
				score_txt.selectable = false;
				score_txt.border = false;
				score_txt.width = 200;
				score_txt.height = 25;
				
				var scoreFormat:TextFormat = new TextFormat();
				scoreFormat.color = 0xFFFFFF;
				scoreFormat.size = 24;
				score_txt.defaultTextFormat = scoreFormat;
				addChild(score_txt);
			}
		}
		
		private function initHealthMeter():void
		{
			if(healthMeter)
			{
				removeChild(healthMeter);
				healthMeter = null;
			}			
			if(!healthMeter)
			{
				trace("Generating health meter.");
				healthMeter = new HealthMeter();
				healthMeter.gotoAndStop(player.strength);
				healthMeter.x = 50;
				healthMeter.y = 50;
				addChild(healthMeter);
			}
		}
		
		public function onKeyPress(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.UP || e.keyCode == 87)
				up = true;
			if(e.keyCode == Keyboard.DOWN || e.keyCode == 83)
				down = true;
			if(e.keyCode == Keyboard.LEFT || e.keyCode == 65)
				left = true;
			if(e.keyCode == Keyboard.RIGHT || e.keyCode == 68)
				right = true;
			if(e.keyCode == Keyboard.SPACE)
				firing = true;
			if(e.keyCode == 82)
				usingMouse = !usingMouse;
		}

		public function onKeyRelease(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.UP || e.keyCode == 87)
				up = false;
			if(e.keyCode == Keyboard.DOWN || e.keyCode == 83)
				down = false;
			if(e.keyCode == Keyboard.LEFT || e.keyCode == 65)
				left = false;
			if(e.keyCode == Keyboard.RIGHT || e.keyCode == 68)
				right = false;
			if(e.keyCode == Keyboard.SPACE)
				firing = false;
			if(e.keyCode == 80)
				if(gameState == PAUSE)
					gameState = CONTINUE;
				else
					gameState = PAUSE;
		}
		
		
		
		
		
		// game over functions
		private function showEndPopUp():void
		{
			destroyAll();
			gameOverScreen = new GameOverScreen();
			gameOverScreen.x = STAGEWIDTH / 2;
			gameOverScreen.y = STAGEHEIGHT / 2;
			addChild(gameOverScreen);
			
			showStartButton();
		}
		
		private function destroyAll():void
		{
			//removeAll(fragmentsArray);	
			removeAll(bulletsArray);
			removeAll(asteroidsArray);
			removeAll(bulletPowerUpsArray);
			removeAll(enemyBossesArray);
			removeAll(enemyShipsArray);
			removeAll(enemyBulletsArray);
			removeAll(healthPowerUpsArray);
			removeAll(starsArray);
			removeAll(levelArray);
			removeAll(levelOverLayArray);
			removeAll(fragmentsArray);
		}
		
		private function removeAll(array:Array):void
		{
			for(var i:int = 0; i < array.length; i++)
				if(array[i])
					if(array[i].parent != null)
					{
						removeChild(array[i]);
						delete array[i];
					}
		}
		
		
		
		
		
		
		
		
		
		// in-game functions
		private function continueGame():void
		{
			if(player)
				player.applyMove();

			moveMovers(levelArray);
			moveMovers(fragmentsArray);	
			moveMovers(bulletsArray);
			moveMovers(asteroidsArray);
			moveMovers(bulletPowerUpsArray);
			moveMovers(enemyBossesArray);
			moveMovers(enemyShipsArray);
			moveMovers(enemyBulletsArray);
			moveMovers(healthPowerUpsArray);
			moveMovers(starsArray);	
			moveMovers(levelOverLayArray);
			
			/*if(enemyBossesArray[0] == null)
			{
				if(getNumberOfMovers(enemyShipsArray) < minEnemyShips)
				{
					fillArray(enemyShipsArray,"enemyship");
					//sendPowerUp();
				}			
				if(getNumberOfMovers(asteroidsArray) < minAsteroids)
				{
					fillArray(asteroidsArray,"asteroid");
				}
			}*/
			healthMeter.gotoAndStop(player.strength);
			if(firing)
				fire();

			if(lastBlockInLevel)
			{
				if(lastBlockInLevel.x < 0)
				{
					createBoss();
					lastBlockInLevel = null;
				}
			}
			else if(enemyBossesArray[0] == null && lastBlockInLevel == null)
			{
				currentLevel++;
				createLevel();
				removeChild(healthMeter);
				addChild(healthMeter);
			}
			setScore();
		}
		
		

		
		public function fire():void
		{
			var bullet:Bullet = new Bullet();
			var mover = setMover(bullet,
								 player.x,
								 player.y,
								 (bullet.maxSpeed * 1.6) * Math.sin(player.rotation * (Math.PI / 180)),
								 -(bullet.maxSpeed * 1.6) * Math.cos(player.rotation * (Math.PI / 180)), 
								 false, 
								 false, 
								 "removeFromStage"
								 );
			
			mover.gotoAndStop(Math.ceil(player.gunStrength));
			mover.strength *= player.gunStrength;
			mover.applyMove();
			mover.applyRotation();
			addChild(mover);
			bulletsArray.push(mover);
			if(player.gunStrength < 4)
			{
				soundChannel = small_gunshot_snd.play();
			}
			else
			{
				soundChannel = large_gunshot_snd.play();
			}
		}
		
		public function enemyFire(enemyShip:Mover):void
		{
			var bullet:EnemyBullet = new EnemyBullet();
			var mover = setMover(bullet,
								 enemyShip.x,
								 enemyShip.y,
								 (bullet.maxSpeed * .5) * Math.sin(enemyShip.rotation * (Math.PI / 180)),
								 -(bullet.maxSpeed * .5) * Math.cos(enemyShip.rotation * (Math.PI / 180)),
								 false,
								 false,
								 "removeFromStage"
								 );
			mover.gotoAndStop(Math.ceil(player.gunStrength));
			mover.strength = 5;
			mover.applyMove();
			mover.applyRotation();
			addChild(mover);
			enemyBulletsArray.push(mover);
		}
		
		
		private function setScore():void
		{
			score_txt.text = "Score: " + this.score;
			removeChild(score_txt);
			addChild(score_txt);
		}
		
		public function shootPlayerBullet(e:Event):void
		{
			if(player.gunStrength < 4 && getNumberOfMovers(bulletsArray) < 10)
			{
				fire();
			}
			else if(getNumberOfMovers(bulletsArray) < 2)
			{
				fire();
			}
		}
		
		/*//This function applies gravity to two movers
		public function applyGravity(instanceOne:Mover, instanceTwo:Mover, distance:Number):void 
		{
			var G:Number = 6.6;
			if (distance != 0) 
			{
				distance /= 2;
				var force:Number = G * ((instanceOne.scaleX * instanceTwo.scaleX ) / (distance ^ 2));
		
				//if instance one is higher than instance two
				if(instanceOne.y < instanceTwo.y)
				{
					instanceOne.speedY += force; 
					instanceTwo.speedY -= force;
				}
				else
				{
					instanceOne.speedY -= force;
					instanceTwo.speedY += force;
				}
				
				if(instanceOne.x < instanceTwo.x)
				{
					instanceOne.speedX += force;
					instanceTwo.speedX -= force;
				}
				else
				{
					instanceOne.speedX -= force;
					instanceTwo.speedX += force;
				}
			}
			else
			{
				instanceOne.speedX = Math.random() * 2;
				instanceOne.speedY = Math.random() * 2; 
				instanceTwo.speedX = Math.random() * 2;
				instanceTwo.speedY = Math.random() * 2; 
			}
		}*/

		public function rotatePlayer(e:Event):void
		{
			var dx:Number = mouseX - player.x;
			var dy:Number = mouseY - player.y;
			var radians:Number = Math.atan2(dy,dx);
			
			//do not rotate if there's no mouse present
			if(usingMouse)
				player.rotation = (radians * 180 / Math.PI) + 90;
			else
				player.rotation = 90;
			
			//if player ship is upside down
			if(player.rotation > 0)
				player.scaleX = 1;
			else
				player.scaleX = -1;
		}		
		
		public function rotateShip(enemyShip:EnemyShip):void
		{
			if(enemyShip.visible == true)
			{
				var dx:Number = player.x - enemyShip.x;
				var dy:Number = player.y - enemyShip.y;
				var radians:Number = Math.atan2(dy,dx);
				
				enemyShip.rotation = (radians * 180 / Math.PI) + 90;
				if(enemyShip.rotation > 0)
					enemyShip.scaleX = 1;
				else
					enemyShip.scaleX = -1;
			}
		}
		
		public function setMover(mover:Mover, 
								 setX:Number, setY:Number, 
								 speedX:Number, speedY:Number, 
								 applySpeedLimit:Boolean, 
								 checkIfStopped:Boolean, 
								 boundaryCheck:String
								 ):Mover
		{
			//set the starting position
			mover.x = setX; //Math.random() * STAGEWIDTH;
			mover.y = setY; //Math.random() * STAGEHEIGHT;
			mover.speedX = speedX;
			mover.speedY = speedY;
			mover.applySpeedLimit = applySpeedLimit;
			mover.checkIfStopped = checkIfStopped;
			mover.boundaryCheck = boundaryCheck;
			
			if(mover.boundaryCheck == "enterFromRight" || mover.boundaryCheck == "onePassFromRight")
			{
				//mover.x = STAGEWIDTH + Math.round(Math.random() * 200) + 100;
				if(mover.speedX > 0)
					mover.speedX *= -1;
				mover.speedY = 0;
			}
			
			mover.applyMove = function()
			{					
				//check speed limits
				if(this.applySpeedLimit)
				{
					if(this.speedX > this.maxSpeed)
						this.speedX = this.maxSpeed;
					if(this.speedY > this.maxSpeed)
						this.speedY = this.maxSpeed;
					if(this.speedX < -this.maxSpeed)
						this.speedX = -this.maxSpeed;
					if(this.speedY < -this.maxSpeed)
						this.speedY = -this.maxSpeed;
				}
				
				//Move to a new location		
				this.x += this.speedX;
				this.y += this.speedY;					
				
				//check if locations are the same
				if(this.checkIfStopped)
				{
					if(this.x == this.previousX && this.y == this.previousY)
					{
						//trace(this.name + " has stopped moving.");
						this.speedX = Math.random() * 2;
						this.speedY = Math.random() * 2;
					}

					//track last location
					this.previousX = this.x;
					this.previousY = this.y;
				}
				
				//Check the boundaries
				if(this.boundaryCheck == "jumpLeftToRight")
				{
					if (this.x > STAGEWIDTH) 
					{
						this.x = 0;
						//STAGEWIDTH - this.width/2;
						//this.speedX *= -1;
					} 
					else if (this.x < 0) 
					{
						this.x = STAGEWIDTH;
						//this.x = this.width/2;
						//this.speedX *= -1;
					}
					if (this.y > STAGEHEIGHT) 
					{
						this.y = STAGEHEIGHT;
						this.speedY *= -1;
					} 
					else if (this.y < 0) 
					{
						this.y = 0;
						this.speedY *= -1;
					}
				}
				else if(this.boundaryCheck == "enterFromRight")
				{
					if (this.x < 0) 
					{
						this.x = STAGEWIDTH + Math.round(Math.random() * 200) + 100;
						this.y = Math.random() * STAGEHEIGHT;
					}
				}
				else if(this.boundaryCheck == "bounceAllSides")
				{
					if(this.x > STAGEWIDTH)
					{
						this.x = STAGEWIDTH - this.width / 2;
						this.speedX *= -1;
					}
					else if(this.x < this.width / 2)
					{
						this.x = this.width / 2;
						this.speedX *= -1;
					}
					if (this.y > STAGEHEIGHT) 
					{
						this.y = STAGEHEIGHT;
						this.speedY *= -1;
					} 
					else if (this.y < 0) 
					{
						this.y = 0;
						this.speedY *= -1;
					}
				}
				else if(this.boundaryCheck == "removeFromStage")
				{
					if(this.x > STAGEWIDTH || this.x < 0 || this.y > STAGEHEIGHT || this.y < 0)
						this.removeFlag = true;
				}				
				else if(mover.boundaryCheck == "OnePassFromRight")
				{
					if(this.x < 0)
						this.removeFlag = true;
				}
				else if(mover.boundaryCheck == "levelTerrain")
				{
					if(this.x < (this.width + 100) * -1)
					{
						this.removeFlag = true;
						this.visible = false;
						//trace("removing terrain");
					}
					//trace(this.x + " < " + this.width);
				}

				if(this is Bullet)
				{
					/**
					 *  What bullets can collide with
					 */
					 
					this.bulletCollide(player.gunStrength,enemyShipsArray);
					this.bulletCollide(player.gunStrength,asteroidsArray);
					this.bulletCollide(player.gunStrength,enemyBossesArray);
					this.bulletCollide(0,levelArray);
				}
			}
			
			return mover;
		}		
		
		public function sendPowerUp(/*startX:Number, startY:Number*/):void
		{
			var powerUp:Mover;
			var probabilityOfHealthPowerup = Math.random() * 10;
			
			if(probabilityOfHealthPowerup < 10)
			{
				var healthPowerUp:HealthPowerUp = new HealthPowerUp();
				powerUp = setMover(healthPowerUp,
									healthPowerUp.x,//startX,
									healthPowerUp.y,//startY,
									healthPowerUp.speedX,
									healthPowerUp.speedY,
									false,
									false,
									"onePassFromRight"
									);
				healthPowerUpsArray.push(powerUp);
			}
			else
			{
				var bulletPowerUp:BulletPowerUp = new BulletPowerUp();
				powerUp = setMover(bulletPowerUp,
									bulletPowerUp.x,//startX,
									bulletPowerUp.y,//startY,
									bulletPowerUp.speedX,
									bulletPowerUp.speedY,
									false,
									false,
									"onePassFromRight"
									);
				bulletPowerUpsArray.push(powerUp);
			}
			addChild(powerUp);
		}
		
		public function fillArray(array:Array,type:String):void
		{
			for(var i = 0; i < array.length; i++)
			{
				if(array[i] == null)
				{
					var mover:Mover;
					if(type == "enemyship")
					{
						var enemyShip:EnemyShip = new EnemyShip();
						mover = setMover(enemyShip,						//mover
										 enemyShip.x,					//x-pos
										 enemyShip.y,					//y-pos
										 enemyShip.speedX,				//speedX
										 enemyShip.speedY, 				//speedY
										 true, 							//speedlimit
										 false, 						//nostop
										 "enterFromRight"				//boundary
										 );
					}
					else if(type == "asteroid")
					{
						var asteroid:Asteroid = new Asteroid();
						mover = setMover(asteroid,
										 asteroid.x,
										 asteroid.y,
										 asteroid.speedX,
										 asteroid.speedY, false, false, "bounceAllSides"
										 );
					}

					addChild(mover);
					array[i] = mover;
				}
			}
		}				
				
		public function moveMovers(array:Array):void 
		{
			for (var i=0; i < array.length; i++) 
			{
				if(array[i] != null)
				{
					if(array[i].removeFlag && array[i].parent != null)
					{
						if(!isNaN(array[i].pointValue))
							this.score += array[i].pointValue;
						if(array[i] is EnemyShip || array[i] is Asteroid)
						{
							if(array[i].visible)
								explode(array[i].x, array[i].y, "small");
							shipsDestroyed++;
						}
						if(array[i] is EnemyBoss)
						{
							explode(array[i].x, array[i].y, "large");
						}
						array[i].parent.removeChild(array[i]);
						array[i] = null;
					}
					else
					{
						var mover = array[i];
		
						mover.applyMove();
						
						if(mover.x > -(mover.width + 10) && mover.x < STAGEWIDTH+mover.width)
						{
							if(mover.y > -(mover.height + 10) && mover.y < STAGEHEIGHT+mover.height)
								mover.visible = true;
						}
						else
							mover.visible = false;
						
						//mover.applyFriction();
						/*if(mover.hitTestObject(player.net.ring_mc) && player.currentFrame > 1)
						{
							score += mover.pointValue;
							trace(score);
							removeChild(mover);
						}*/
						
						if( ! (mover is LevelTerrain) )
						{
							mover.applyRotation();
						
						if(mover.rotation > 0)
							mover.scaleX = 1;
						else
							mover.scaleX = -1;				
						}
						
						if(mover is EnemyShip)
						{
							rotateShip(mover);
							if(mover.x < 705 && mover.x > 700)
								enemyFire(mover);
						}
						
					}
				}
			}
		}
		
		/**  returns the amount of non-null entities in array
		 *  @param array to count
		 */
		public function getNumberOfMovers(array:Array):int
		{
			var total:int = 0;
			for(var i:int = 0; i < array.length; i++)
				if(array[i] != null)
					total++;
			return total;
		}
		
		
		/**
		 *  Creates a particle explosion at (startX, startY)
		 */
		public function explode(startX:Number, startY:Number, type:String):void
		{
			var mover:Mover;
			for(var i = 0; i < maxFragments; i++) 
			{
				var particle:Particle = new Particle();
			    mover = setMover(particle,
								 startX,
								 startY,
								 particle.speedX,
								 particle.speedY,
								 false, true, "removeFromStage"
								 );
				mover.alpha = Math.random() * .75;
				mover.gotoAndStop(Math.round(Math.random()*20)+1);
				mover.applyMove = function()
				{
					if(this is Particle)
					{
						this.alpha *= .97;
						if(this.alpha <= .24)
						{
							this.removeFlag = true;
						}
						this.x += this.speedX;
						this.y += this.speedY;
					}
				}
				addChild(mover);
				fragmentsArray.push(mover);
			}
			
			
			if(type == "small")
			{
				if(soundChannel)
					soundChannel = explode_snd.play();
			}
			else if(type == "large")
			{
				var bossExplosion:SoundChannel = new SoundChannel();
				bossExplosion = large_explode_snd.play();
				
				explode(startX-20,startY-20,"small");
				explode(startX+20,startY,   "small");
				explode(startX-20,startY+20,"small");
				explode(startX+20,startY-20,"small");
			}
			
			
			var explode_gif:Explosion_gif = new Explosion_gif();
			explode_gif.x = startX;
			explode_gif.y = startY;
			addChild(explode_gif);
		}
		
	} // end class
} // end package
 




