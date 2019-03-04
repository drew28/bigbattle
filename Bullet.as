package 
{
	import flash.display.MovieClip;
	
	public class Bullet extends Mover 
	{
	    public function Bullet()
		{
			super();
			//this.type = "bullet";
			this.strength = 5;
		}
		
		/** Hit detection for bullet and removing from stage
		 *
		 */
		public function bulletCollide(gunStrength:Number, moverArray:Array):void
		{
			for each(var mover:Mover in moverArray)
				if(mover)
					if(this.hitTestObject(mover))
					{
						mover.strength -= this.strength;
						if(mover.strength < 0)
							mover.removeFlag = true;
						if(gunStrength < 4)
							this.removeFlag = true;
					}
		}
		
	}
}