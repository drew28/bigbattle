package 
{
	import flash.display.MovieClip;
	
	public class PlayerShip extends Mover 
	{
		public var buffer:Boolean;
		
	    public function PlayerShip()
		{
			super();
			//this.type = "playership";
			this.strength = 100;
			this.gunStrength = 1;
			this.speedX = 0;
			this.speedY = 0;
			this.x = 200;
			this.y = 200;			
		}
		
		
	}
}