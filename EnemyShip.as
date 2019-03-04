package 
{
	import flash.display.MovieClip;
	
	public class EnemyShip extends Mover 
	{
	    public function EnemyShip()
		{
			super();
			//this.type = "enemyship";
			this.x = Math.random() * 800 + 800;
			this.y = Math.random() * 600;
			this.pointValue = 20;
			this.strength = 3;
			this.speedX = -5 - Math.random() * 5;
			this.speedY = 0;
			this.gunStrength = 5;
		}
	}
}