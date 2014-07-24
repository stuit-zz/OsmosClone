package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import nexus.osmos.screens.GameOverScreen;
	import nexus.osmos.screens.GameScreen;
	import nexus.osmos.screens.ScreenNavigator;
	import nexus.osmos.screens.Screens;
	import nexus.osmos.screens.StartScreen;
	import nexus.osmos.screens.WinScreen;
	import nexus.osmos.utils.ColorizeUtil;
	
	[SWF(frameRate="60",backgroundColor="0xffffff",width="550",height="400")]
	public class OsmosClone extends Sprite
	{
		// LOADED DATA LIMITS
		private const MAX_OBJECTS:int = 30;
		private const MIN_RADIUS:int = 2;
		private const MAX_RADIUS:int = 50;
		
		// LOADED DATA
		private var configData:Object;
		
		// UI ELEMENTS
		private var screenNav:ScreenNavigator;
		
		public function OsmosClone()
		{
			loadConfig();
		}
		
		/**
		*  loading json file from {root}/system/config.json
		*/
		private function loadConfig():void
		{
			const ldr:URLLoader = new URLLoader();
			ldr.addEventListener(Event.COMPLETE, configData_onLoadCompleteHandler);
			ldr.load(new URLRequest("config.json"));
		}
		
		/**
		*  checking for loaded data for not exceeding the limits
		*/
		private function configData_onLoadCompleteHandler(event:Event):void
		{
			configData = JSON.parse(event.target.data);
			
			// IMPORTANT: need to initialize utility class FIRST
			new ColorizeUtil(configData.config.enemy.color1, configData.config.enemy.color2);
			if (configData.config.enemyNum > MAX_OBJECTS)
				configData.config.enemyNum = MAX_OBJECTS;
			else if (configData.config.enemyNum < 1)
				configData.config.enemyNum = 1;
			
			if (configData.config.enemy.minRadius < MIN_RADIUS)
				configData.config.enemy.minRadius = MIN_RADIUS;
			else if (configData.config.enemy.minRadius > MAX_RADIUS)
				configData.config.enemy.minRadius = MAX_RADIUS - 1;
			
			if (configData.config.enemy.maxRadius > MAX_RADIUS)
				configData.config.enemy.maxRadius = MAX_RADIUS;
			else if (configData.config.enemy.maxRadius < MIN_RADIUS)
				configData.config.enemy.maxRadius = MIN_RADIUS + 1;
			
			const max:Number = Math.max(configData.config.enemy.maxRadius, configData.config.enemy.minRadius);
			const min:Number = Math.min(configData.config.enemy.maxRadius, configData.config.enemy.minRadius);
			configData.config.enemy.maxRadius = max;
			configData.config.enemy.minRadius = min;
			
			initInterface();
		}
		
		/**
		*  building interface and initializing ScreenNavigator
		*  which is used to manage ingame screens
		*/
		private function initInterface():void
		{
			screenNav = ScreenNavigator.instance;
			
			// IMPORTANT: attach display object container to screen navigator FIRST
			screenNav.initWithDisplayContainer(this);
			
			screenNav.addScreen(StartScreen, Screens.START_SCREEN);
			screenNav.addScreen(GameScreen, Screens.GAME_SCREEN, {playerColor:ColorizeUtil.getInt(configData.config.user.color), 
																  playerRadius: configData.config.user.radius, 
																  playerSpeed: configData.config.user.speed, 
																  enemyNum:configData.config.enemyNum, 
																  enemySpeed: configData.config.enemy.speed,
																  minRadius: configData.config.enemy.minRadius,
																  maxRadius: configData.config.enemy.maxRadius});
			screenNav.addScreen(GameOverScreen, Screens.GAMEOVER_SCREEN);
			screenNav.addScreen(WinScreen, Screens.WIN_SCREEN);
			
			screenNav.showScreen(Screens.START_SCREEN);
		}
	}
}