package
{
	public class Particle extends Mover
	{
		public function Particle()
		{
			super();
			this.maxSpeed = 25;
			this.minSpeed = -25;
			this.speedX = Math.floor(Math.random() * (this.maxSpeed - this.minSpeed + 1)) + this.minSpeed;
			this.speedY = Math.floor(Math.random() * (this.maxSpeed - this.minSpeed + 1)) + this.minSpeed;
			//this.type = "particle";
		}
	}
}