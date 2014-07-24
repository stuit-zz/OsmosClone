package nexus.osmos.object
{
	
	/**
	 *  Player object
	 */
	public class PlayerObject extends CollidableObject
	{
		public function PlayerObject(radius:Number, speed:Number)
		{
			super(radius, speed);
		}
		
		//
		// PUBLIC METHODS
		//
		
		/**
		 *  applying drag force to player object
		 */
		public function applyDragForce(xpos:Number, ypos:Number, force:Number):void
		{
			const rad:Number = Math.atan2(ypos - y, xpos - x);
			
			_velX += -Math.cos(rad) * force;
			_velY += -Math.sin(rad) * force;
		}
	}
}