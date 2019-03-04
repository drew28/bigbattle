package 
{
	import flash.display.MovieClip;
	
	public class EnemyBoss extends Mover 
	{
	    public function EnemyBoss()
		{
			super();
			//this.type = "boss";
			this.x = 800 + 20 + (Math.random() * 800);
			this.y = Math.random() * 600;
			this.pointValue = 2000;
			this.strength = 2000;
		}
	}
}