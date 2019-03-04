package {
	import flash.display.MovieClip;

	public class Mover extends MovieClip {

		//We need different speeds for different particles.
		//These variables can be accessed from the main movie, because they are public.
		public var friction:Number;
		public var minSpeed:Number;
		public var maxSpeed:Number;
		public var pointValue:Number;
		public var previousX:Number;
		public var previousY:Number;
		public var speedX:Number;
		public var speedY:Number;
		public var strength:Number;
        public var type:String;
		
		public var gunStrength:Number;
		

		public var applySpeedLimit:Boolean;
		public var checkIfStopped:Boolean;
		public var boundaryCheck:String;
		
		public var removeFlag:Boolean;
		
		public function Mover():void {
 			friction = .99;
			speedX = 0;
	        speedY = 0;
			maxSpeed = 30;
			
			applySpeedLimit = false,
			checkIfStopped = false,
			boundaryCheck = "jumpLeftToRight"			
			
			removeFlag = false;
		}
				
		public function applyFriction():void 
		{
			this.speedX *= friction;
			this.speedY *= friction;
		}
		
		public var applyMove:Function;
		
		public function applyRotation():void 
		{
			this.rotation = (180/Math.PI) * Math.atan2(this.speedY, this.speedX) + 90;
		}
	}
}