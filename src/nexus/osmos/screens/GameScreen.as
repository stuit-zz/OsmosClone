package nexus.osmos.screens
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import nexus.osmos.object.CollidableObject;
	import nexus.osmos.object.PlayerObject;
	import nexus.osmos.ui.ButtonSkin;
	import nexus.osmos.ui.PowerIndicator;
	import nexus.osmos.utils.ColorizeUtil;
	
	/**
	 *  Game's main playing screen
	 */
	public class GameScreen extends BaseScreen
	{
		// GLOBAL SETTINGS
		public var playerColor:uint;
		public var playerRadius:Number;
		public var playerSpeed:Number;
		public var enemyNum:int;
		public var enemySpeed:Number;
		public var minRadius:Number;
		public var maxRadius:Number;
		
		// UI ELEMENTS
		private var startButton:Sprite;
		private var powerInd:PowerIndicator;
		
		// GAMEPLAY PROPS
		private var _player:PlayerObject;
		private var _objects:Vector.<CollidableObject>;
		private var _enemyArea:Number;
		private var _applyForce:Number;
		private var _gainingForce:Boolean;
		private var _clashOccured:Boolean;
		private var _paused:Boolean;
		
		// FPS
		private var _fps:int;
		private var _timer:Timer = new Timer(1000);
		
		public function GameScreen()
		{
			super();
		}
		
		//
		// OVERRIDEN METHODS
		//
		
		override protected function initialize():void
		{
			super.initialize();
			
			transitionType = BaseScreen.TRANSITION_UP;
			
			var skin:ButtonSkin = new ButtonSkin('START');
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
		// PRIVATE METHODS
		//
		
		/**
		 *  called when startButton is clicked
		 */
		private function startGame():void
		{
			// timer for fps counter
			_timer.addEventListener(TimerEvent.TIMER, onTime);
			_timer.start();
			
			// reseting props
			_objects = new Vector.<CollidableObject>();
			_enemyArea = 0;
			_applyForce = 0;
			_gainingForce = false;
			_clashOccured = true;
			_paused = false;
			
			// initing player object
			_player = new PlayerObject(playerRadius, playerSpeed);
			_player.addEventListener(CollidableObject.DESTROYED, obj_onDestroyHandler);
			_player.x = stage.stageWidth / 2;
			_player.y = stage.stageHeight / 2;
			_player.color = playerColor;
			_player.friction = .99;
			_objects.push(_player);
			addChild(_player);
			
			// initing enemies
			var obj:CollidableObject;
			var radii:Number;
			for (var i:int = 0; i < enemyNum; i++)
			{
				radii = Math.random() * (maxRadius - minRadius) + minRadius;
				obj = new CollidableObject(radii, enemySpeed);
				obj.addEventListener(CollidableObject.DESTROYED, obj_onDestroyHandler);
				setPosition(obj, (stage.stageWidth - obj.radius * 2) * Math.random() + obj.radius, (stage.stageHeight - obj.radius * 2) * Math.random() + obj.radius);
				obj.setDirection(Math.random() * stage.stageWidth, Math.random() * stage.stageHeight);
				_objects.push(obj);
				addChild(obj);
			}
			
			// initing power indicator to show pushing force to player object
			powerInd = new PowerIndicator();
			powerInd.visible = false;
			addChild(powerInd);
			
			// initing main game loop
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, stage_onMouseDownHandler, false, 0, true);
		}
		
		/**
		 *  search placing coordinates and position enemy on the stage
		 *  obj:CollidableObject - enemy object
		 *  xpos:int - x coordinate to search
		 *  ypos:int - y coordinate to search
		 */
		private function setPosition(obj:CollidableObject, xpos:int, ypos:int):void
		{
			var dist:Number;
			var item:CollidableObject;
			for (var i:int = _objects.length - 1; i >= 0; i--)
			{
				item = _objects[i];
				dist = Math.sqrt((xpos - item.x) * (xpos - item.x) + (ypos - item.y) * (ypos - item.y));
				if (dist < obj.radius + item.radius)
				{
					setPosition(obj, (stage.stageWidth - obj.radius * 2) * Math.random() + obj.radius, (stage.stageHeight - obj.radius * 2) * Math.random() + obj.radius);
					return;
				}
			}
			obj.x = xpos;
			obj.y = ypos;
		}
		
		/**
		 *  fps counter reset on every second
		 */
		private function onTime(event:TimerEvent):void
		{
			trace(_fps);
			_fps = 0;
		}
		
		/**
		 *  Main game loop
		 */
		private function onEnterFrame(event:Event):void
		{
			if (_paused)
				return;
			
			var item:CollidableObject;
			var maxA:Number = 0;
			var minA:Number = stage.stageWidth * stage.stageHeight;
			var i:int;
			const pA:Number = _player.area;
			
			// first update position and size, then check for collision and than decide enemy with min and max area
			for (i = _objects.length - 1; i >= 0; i--)
			{
				item = _objects[i];
				item.update();
				
				if (!item.isColliding)
					check(item);
				
				if (item == _player)
					continue;
				
				if (item.area > maxA)
					maxA = item.area;
				if (item.area < minA)
					minA = item.area;
			}
			
			_enemyArea = 0;
			var factor:Number = 0;
			
			// calculating overall enemy area and distributing enemy color according to player's area
			for (i = _objects.length - 1; i >= 0; i--)
			{
				item = _objects[i];
				if (item != _player)
				{
					_enemyArea += item.area;
					
					if (_clashOccured)
					{
						item.color = ColorizeUtil.getColor(1);
						if (item.area < pA)
						{
							factor = (item.area - minA) / (pA - minA);
							item.color = ColorizeUtil.getColor(factor * .5);
						}
						else
						{
							factor = (item.area - pA) / (maxA - pA);
							item.color = ColorizeUtil.getColor(factor * .5 + .5);
						}
					}
				}
			}
			
			if (_clashOccured)
				_clashOccured = false;
			
			// number of power applied to player object
			if (_gainingForce && _applyForce < 1)
			{
				_applyForce += .05;
			}
			
			// managing the power indicator
			if (powerInd)
			{
				powerInd.x = stage.mouseX - 20;
				powerInd.y = stage.mouseY + 20;
				powerInd.power = _applyForce;
			}
			
			// deciding win or loss
			if (_enemyArea < pA)
			{
				_paused = true;
				ScreenNavigator.instance.showScreen(Screens.WIN_SCREEN);
			}
			if (pA < minA || (_enemyArea - maxA + pA) < (_enemyArea - maxA))
			{
				_paused = true;
				ScreenNavigator.instance.showScreen(Screens.GAMEOVER_SCREEN);
			}
			
			_fps++;
		}
		
		/**
		 *  collision checking
		 *  obj:CollidableObject - object on the stage to be checked for collision
		 */
		private function check(obj:CollidableObject):void
		{
			var dist:Number;
			var item:CollidableObject;
			for (var i:int = _objects.length - 1; i >= 0; i--)
			{
				item = _objects[i];
				if (obj != item && !item.isColliding)
				{
					dist = Math.sqrt((obj.x - item.x) * (obj.x - item.x) + (obj.y - item.y) * (obj.y - item.y));
					if (dist < obj.radius + item.radius && obj.radius >= item.radius)
					{
						obj.addArea(item.area);
						item.shrink();
						_clashOccured = true;
						return;
					}
				}
			}
		}
		
		//
		// EVENT HANDLERS
		//
		
		private function stage_onMouseDownHandler(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, stage_onMouseUpHandler, false, 0, true);
			_gainingForce = true;
			powerInd.visible = true;
		}
		
		private function stage_onMouseUpHandler(event:MouseEvent):void
		{
			if (!stage || !_player)
				return;
				
			stage.removeEventListener(MouseEvent.MOUSE_UP, stage_onMouseUpHandler);
			_player.applyDragForce(stage.mouseX, stage.mouseY, _applyForce);
			_applyForce = 0;
			_gainingForce = false;
			powerInd.visible = false;
		}
		
		/**
		 *  called when object had been consumed by bigger one
		 */
		private function obj_onDestroyHandler(event:Event):void
		{
			if (event.target == _player)
			{
				_paused = true;
				ScreenNavigator.instance.showScreen(Screens.GAMEOVER_SCREEN);
			}
			
			var obj:CollidableObject;
			for (var i:int = _objects.length - 1; i >= 0; i--)
			{
				if (event.target == _objects[i])
				{
					obj = _objects.splice(i, 1)[0];
					obj.removeEventListener(CollidableObject.DESTROYED, obj_onDestroyHandler);
					removeChild(obj);
					obj = null;
					return;
				}
			}
		}
		
		private function startButton_onClickHandler(event:MouseEvent):void
		{
			startButton.visible = false;
			startGame();
		}
		
		//
		// DESTRUCTOR
		//
		
		override public function dispose():void
		{
			super.dispose();
			
			removeChild(startButton);
			startButton.removeEventListener(MouseEvent.CLICK, startButton_onClickHandler);
			startButton = null;
			
			var item:CollidableObject;
			for (var i:int = _objects.length - 1; i >= 0; i--)
			{
				item = _objects[i];
				if (item && contains(item))
				{
					removeChild(item);
					item.removeEventListener(CollidableObject.DESTROYED, obj_onDestroyHandler);
					item = null;
				}
			}
			_player = null;
			_objects.length = 0;
			_objects = null;
			_enemyArea = 0;
			_applyForce = 0;
			_gainingForce = false;
			_clashOccured = false;
			_paused = false;
			
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, onTime);
			
			stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, stage_onMouseDownHandler);
		}
	}
}