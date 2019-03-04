package 
{
	import flash.display.MovieClip;
	
	public class PowerUp extends Mover 
	{
	    public function PowerUp()
		{
			super();
			this.pointValue = 3;
			this.x = 800 + 50;
			this.y = 600 * Math.random();
			this.speedX = -5;
			this.speedY = 0;
		}
	}
}