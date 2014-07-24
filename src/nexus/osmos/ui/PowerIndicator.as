package nexus.osmos.ui
{
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import nexus.osmos.utils.ColorizeUtil;
	
	/**
	 *  Indicator to show the power of the applying force on the player object
	 */
	public class PowerIndicator extends Sprite
	{
		// UI ELEMENTS
		private const _frame:Shape = new Shape();
		private const _bar:Shape = new Shape();
		
		// PROPS
		private var _scale:Number = 0;
		
		public function PowerIndicator()
		{
			super();
			
			// creating progress bar
			drawBody();
			addChild(_bar);
			
			// creating 'power' frame
			_frame.graphics.lineStyle(1, 0x999999);
			_frame.graphics.drawRect(0, 0, 50, 10);
			_frame.graphics.endFill();
			addChild(_frame);
		}
		
		//
		// GETTERS AND SETTERS
		//
		
		/**
		 *  provide value between 0.0 and 1.0 to scale progress bar
		 */
		public function set power(value:Number):void
		{
			_scale = value;
			drawBody();
		}
		
		//
		// PRIVATE METHODS
		//
		
		/**
		 *  drawing progress bar
		 */
		private function drawBody():void
		{
			_bar.graphics.beginFill(ColorizeUtil.getColor(_scale));
			_bar.graphics.drawRect(1, 1, 49, 9);
			_bar.graphics.endFill();
			_bar.scaleX = _scale;
		}
	}
}