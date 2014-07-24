package nexus.osmos.screens
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import nexus.osmos.ui.ButtonSkin;
	
	/**
	 *  Winning screen
	 */
	public class WinScreen extends BaseScreen
	{
		// PRIVATE CONSTS
		private const GAP:int = 20;
		
		// UI ELEMENTS
		private const messageLabel:TextField = new TextField();
		private const restartButton:Sprite = new Sprite();
		
		public function WinScreen()
		{
			super();
		}
		
		//
		// OVERRIDEN METHODS
		//
		
		override protected function initialize():void
		{
			super.initialize();
			
			var format:TextFormat = new TextFormat('Helvetica,Arial,_sans', 25, 0x00ff00, true);
			
			messageLabel.autoSize = TextFieldAutoSize.CENTER;
			messageLabel.defaultTextFormat = format;
			messageLabel.text = 'You WON!';
			addChild(messageLabel);
			
			var skin:ButtonSkin = new ButtonSkin('PLAY AGAIN');
			restartButton.addEventListener(MouseEvent.CLICK, restartButton_onClickHandler);
			restartButton.mouseChildren = false;
			restartButton.buttonMode = true;
			restartButton.addChild(skin);
			addChild(restartButton);
		}
		
		override protected function draw():void
		{
			super.draw();
			
			const topY:Number = _screenHeight / 2 - (messageLabel.height + restartButton.height + GAP) / 2;
			
			messageLabel.x = _screenWidth / 2 - messageLabel.width / 2;
			messageLabel.y = topY;
			
			restartButton.x = _screenWidth / 2 - restartButton.width / 2;
			restartButton.y = messageLabel.y + messageLabel.height + GAP;
		}
		
		//
		// EVENT HANDLERS
		//
		
		private function restartButton_onClickHandler(event:MouseEvent):void
		{
			ScreenNavigator.instance.showScreen(Screens.GAME_SCREEN);
		}
		
		//
		// DESTRUCTOR
		//
		
		override public function dispose():void
		{
			super.dispose();
			
			removeChild(messageLabel);
			
			removeChild(restartButton);
			restartButton.removeEventListener(MouseEvent.CLICK, restartButton_onClickHandler);
		}
	}
}