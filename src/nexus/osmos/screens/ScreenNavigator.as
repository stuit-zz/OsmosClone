package nexus.osmos.screens
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	/**
	 *  In game screens navigation helper
	 */
	public class ScreenNavigator
	{
		// Singleton's instance
		private static var _instance:ScreenNavigator;
		
		// PRIVATE PROPS
		private const _screens:Dictionary = new Dictionary();
		private var _target:DisplayObjectContainer;
		private var _currScreen:BaseScreen;
		
		public function ScreenNavigator(enforcer:SingletonEnforcer)
		{
		}
		
		//
		// GETTERS AND SETTERS
		//
		
		/**
		 *  get singleton instance
		 */
		public static function get instance():ScreenNavigator
		{
			if (!_instance)
				_instance = new ScreenNavigator(new SingletonEnforcer());
			return _instance;
		}
		
		/**
		 *  active screen
		 */
		public function get currentScreen():BaseScreen
		{
			return _currScreen;
		}
		
		//
		// PUBLIC METHODS
		//
		
		/**
		 *  first initialize with display object container
		 */
		public function initWithDisplayContainer(target:DisplayObjectContainer):void
		{
			_target = target;
		}
		
		/**
		 *  registering screen
		 *  screen:Class - screen class to be registered
		 *  name:String - name id of the screen
		 *  props:Object - object with properties for global variables of the screen class
		 */
		public function addScreen(screen:Class, name:String, props:Object = null):void
		{
			if (_screens[name])
				return;
			
			const scrn:Object = new screen();
			if (scrn is BaseScreen)
			{
				for (var prop:String in props)
				{
					scrn[prop] = props[prop];
				}
				_screens[name] = scrn;
				BaseScreen(_screens[name]).addEventListener(BaseScreen.TRANSITION_COMPLETE, screen_onTransitionCompleteHandler);
			}
		}
		
		/**
		 *  show screen with given name id
		 */
		public function showScreen(name:String):void
		{
			if (!_target)
				throw new Error('Please init with display container first');
			
			_target.addChild(_screens[name]);
			_screens[name].show();
		}
		
		//
		// EVENT HANDLERS
		//
		
		private function screen_onTransitionCompleteHandler(event:Event):void
		{
			if (_currScreen && _target.contains(_currScreen))
			{
				_currScreen.dispose();
				_target.removeChild(_currScreen);
				_currScreen = null;
			}
			
			_currScreen = event.target as BaseScreen;
		}
	}
}

internal class SingletonEnforcer
{
	
}