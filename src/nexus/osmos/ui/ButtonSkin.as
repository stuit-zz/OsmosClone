package nexus.osmos.ui
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 *  Base button skin class
	 */
	public class ButtonSkin extends Sprite
	{
		// UI ELEMENTS
		private var _title:String;
		private var _tf:TextField;
		private var _bg:Shape;
		
		public function ButtonSkin(title:String)
		{
			super();
			
			_title = title;
			initTextField();
		}
		
		//
		// PROTECTED METHODS
		//
		
		/**
		 *  create title textfield
		 */
		protected function initTextField():void
		{
			const format:TextFormat = new TextFormat('Helvetica,Arial,_sans', 16, 0x444444, true);
			
			if (_tf && contains(_tf))
			{
				removeChild(_tf);
				_tf = null;
			}
			
			_tf = new TextField();
			_tf.autoSize = TextFieldAutoSize.CENTER;
			_tf.defaultTextFormat = format;
			_tf.text = _title;
			_tf.addEventListener(Event.ADDED, tf_onAddedHandler);
			addChild(_tf);
		}
		
		/**
		 *  draw button background
		 */
		protected function drawBackground():void
		{
			_bg = new Shape();
			_bg.graphics.beginFill(0x999999);
			_bg.graphics.drawRoundRect(0, 0, _tf.textWidth + 100, _tf.textHeight + 50, 5, 5);
			_bg.graphics.endFill();
			addChildAt(_bg, 0);
		}
		
		//
		// EVENT HANDLERS
		//
		
		/**
		 *  creating bg and centering textfield after it's being added to stage
		 */
		protected function tf_onAddedHandler(event:Event):void
		{
			drawBackground();
			_tf.removeEventListener(Event.ADDED, tf_onAddedHandler);
			_tf.x = _bg.width / 2 - _tf.textWidth / 2;
			_tf.y = _bg.height / 2 - _tf.textHeight / 2;
		}
	}
}