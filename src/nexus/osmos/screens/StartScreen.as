package nexus.osmos.screens
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import nexus.osmos.ui.ButtonSkin;
	
	/**
	 *  Welcome screen
	 */
	public class StartScreen extends BaseScreen
	{
		// UI ELEMENTS
		private var startButton:Sprite;
		
		public function StartScreen()
		{
			super();
		}
		
		//
		// OVERRIDEN METHODS
		//
		
		override protected function initialize():void
		{
			super.initialize();
			
			// setting screen's opening animation type
			transitionType = BaseScreen.TRANSITION_LEFT;
			
			const skin:ButtonSkin = new ButtonSkin('PLAY');
			startButton = new Sprite();
			startButton.mouseChildren = false;
			startButton.addChild(skin);
			startButton.addEventListener(MouseEvent.CLICK, startButton_onClickHandler);
			startButton.buttonMode = true;
			addChild(startButton);
		}
		
		override protected function draw():void
		{
			super.draw();
			
			startButton.x = _screenWidth / 2 - startButton.width / 2;
			startButton.y = _screenHeight / 2 - startButton.height / 2;
		}
		
		//
		// EVENT HANDLERS
		//
		
		private function startButton_onClickHandler(event:MouseEvent):void
		{
			ScreenNavigator.instance.showScreen(Screens.GAME_SCREEN);
		}
	}
}