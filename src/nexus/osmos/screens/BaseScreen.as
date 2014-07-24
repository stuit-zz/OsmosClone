package nexus.osmos.screens
{
	import com.greensock.TweenLite;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 *  Base screen class
	 */
	public class BaseScreen extends Sprite
	{
		// PUBLIC STATIC CONSTS
		public static const TRANSITION_COMPLETE:String = 'tr_complete';
		public static const TRANSITION_UP:String = 'up';
		public static const TRANSITION_LEFT:String = 'left';
		public static const TRANSITION_RIGHT:String = 'right';
		
		// GLOBAL PROPS
		public var transitionType:String = TRANSITION_RIGHT;
		
		// UI ELEMENTS
		protected var _bg:Shape;
		
		// PROTECTED PROPS
		protected var _screenWidth:Number = 0;
		protected var _screenHeight:Number = 0;
		
		public function BaseScreen()
		{
			addEventListener(Event.ADDED_TO_STAGE, screen_onAddedToStage);
		}
		
		//
		// PUBLIC METHODS
		//
		
		/**
		 *  visualize screen
		 */
		public function show():void
		{
			visible = false;
			animate();
		}
		
		//
		// PROTECTED METHODS
		//
		
		/**
		 *  this method should be overriden and used to initialize the screen when added to stage
		 */
		protected function initialize():void
		{
			_bg = new Shape();
			_bg.graphics.beginFill(0xffffff);
			_bg.graphics.drawRect(0, 0, _screenWidth, _screenHeight);
			_bg.graphics.endFill();
			addChild(_bg);
		}
		
		/**
		 *  this method should be overriden to position added ui elements of the screen
		 */
		protected function draw():void
		{
			
		}
		
		//
		// PRIVATE METHOD
		//
		
		/**
		 *  opening animation
		 */
		private function animate():void
		{
			var fromX:Number = 0;
			var fromY:Number = 0;
			
			switch (transitionType)
			{
				case TRANSITION_UP:
					fromY = -_screenHeight;
					break;
				case TRANSITION_LEFT:
					fromX = -_screenWidth;
					break;
				case TRANSITION_RIGHT:
					fromX = _screenHeight;
					break;
			}
			TweenLite.fromTo(this, .4, {x: fromX, y:fromY}, {x:0, y:0, onComplete: transition_onCompleteHandler, onStart: transition_onStartHandler});
		}
		
		//
		// EVENT HANDLERS
		//
		
		private function screen_onAddedToStage(event:Event):void
		{
			_screenWidth = stage.stageWidth;
			_screenHeight = stage.stageHeight;
			
			initialize();
			draw();
		}
		
		private function transition_onStartHandler():void
		{
			visible = true;
		}
		
		private function transition_onCompleteHandler():void
		{
			dispatchEvent(new Event(TRANSITION_COMPLETE));
		}
		
		//
		// DESTRUCTOR METHOD
		//
		
		/**
		 *  this method should be overriden and used to dispose all elements in screen before it becomes null
		 */
		public function dispose():void
		{
			
		}
	}
}