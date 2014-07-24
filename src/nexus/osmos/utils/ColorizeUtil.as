package nexus.osmos.utils
{
	/**
	 *  Utility class to work with colors in game
	 */
	public class ColorizeUtil
	{
		private static const _colors:Vector.<uint> = new Vector.<uint>();
		private static var _steps:int = 0;
		
		public function ColorizeUtil(fromColor:Array, toColor:Array, steps:int = 10)
		{
			_steps = steps;
			const len:int = _steps - 1;
			for (var i:int = 0; i <= len; i++)
			{
				_colors.push(getRatioBasedColor(fromColor, toColor, i / len));
			}
		}
		
		//
		// PUBLIC STATIC METHODS
		//
		
		/**
		 *  provide ratio between 0.0 to 1.0 to get color from array
		 */
		public static function getColor(ratio:Number):int
		{
			if (!_colors.length)
				throw new Error('Please instantiate ColorizeUtil class first');
			
			return _colors[int(Math.floor(ratio * (_steps - 1)))];
		}
		
		/**
		 *  convert RGB to unsigned integer
		 */
		public static function getInt(color:Array):int
		{
			return (color[0]<<16 | color[1]<<8 | color[2]);
		}
		
		//
		// PRIVATE METHODS
		//
		
		/**
		 *  getting color between 2 colors based on provided ratio (0.0 to 1.0)
		 */
		private function getRatioBasedColor(color1:Array, color2:Array, ratio:Number):uint
		{
			var r:uint = color1[0];
			var g:uint = color1[1];
			var b:uint = color1[2];
			r += (color2[0] - r) * ratio;
			g += (color2[1] - g) * ratio;
			b += (color2[2] - b) * ratio;
			return getInt([r,g,b]);
		}
	}
}