package 
{
	import flash.display.MovieClip;
	
	public class Asteroid extends Mover 
	{
	    public function Asteroid()
		{
			super();
			//this.type = "asteroid";
			this.x = (Math.round(Math.random() * 500)) + 400;
			this.y = Math.round(Math.random() * 600);
			this.speedX = Math.round(Math.random() * 10) - 5;
			this.speedY = Math.round(Math.random() * 10) - 5;
			this.pointValue = 5;
			this.strength = 10;
		}
	}
}