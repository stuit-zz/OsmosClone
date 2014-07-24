package nexus.osmos.object
{
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.events.Event;
	
	/**
	 *  Base class for collidable, moving objects on stage
	 */
	public class CollidableObject extends Shape
	{
		// PUBLIC STATICS
		public static const DESTROYED:String = "DESTROYED";
		
		// PUBLIC CONFIGS
		public var speed:int = 0;
		public var friction:Number = 1;
		
		// OBJECT PROPS
		protected var _radius:Number = 0;
		protected var _area:Number = 0;
		protected var _velX:Number = 0;
		protected var _velY:Number = 0;
		protected var _color:uint = 0x999999;
		protected var _mass:Number = 0;
		protected var _isColliding:Boolean = false;
		
		// INSTANCE PROPS
		private var _scale:Number = 1;
		private var _toScale:Number = 1;
		private var _startRadius:Number = 0;
		
		public function CollidableObject(radius:Number, speed:Number)
		{
			super();
			
			this.speed = speed;
			_radius = radius;
			
			// simplified mass
			_mass = _radius / 2;
			_startRadius = _radius;
			_area = _radius * _radius * Math.PI;
			drawBody();
		}
		
		
		//
		// GETTER AND SETTERS
		//
		public function get radius():Number
		{
			return _radius;
		}
		
		public function get area():Number
		{
			return _area;
		}
		
		public function get color():uint
		{
			return _color;
		}
		
		public function get isColliding():Boolean
		{
			return _isColliding;
		}
		
		public function set color(value:uint):void
		{
			if (color == value)
				return;
			
			_color = value;
			drawBody();
		}
		
		
		//
		// PUBLIC METHODS
		//
		
		/**
		*  setting movement vector
		*/
		public function setDirection(toX:Number, toY:Number):void
		{
			const rad:Number = Math.atan2(toY - y, toX - x);
			
			_velX = Math.cos(rad);
			_velY = Math.sin(rad);
		}
		
		/**
		*  appending area of other collided object, consuming last
		*/
		public function addArea(a:Number):void
		{
			_area += a;
			_radius = Math.sqrt(_area / Math.PI);
			_mass = _radius / 2;
			_toScale = _radius / _startRadius;
		}
		
		/**
		*  start to reduce the object in size
		*/
		public function shrink():void
		{
			_isColliding = true;
			_toScale = 0;
		}
		
		/**
		*  object state update
		*/
		public function update():void
		{
			// adding friction to velocity
			_velX *= friction;
			_velY *= friction;
			
			// making object to bounce when hits the stage borders
			if (x + radius >= stage.stageWidth)
				_velX = -Math.abs(_velX);
			else if (x - radius <= 0)
				_velX = Math.abs(_velX);
			
			if (y + radius >= stage.stageHeight)
				_velY = -Math.abs(_velY);
			else if (y - radius <= 0)
				_velY = Math.abs(_velY);
			
			// applying velocity effected by object's mass
			x += speed * _velX * (1 / _mass);
			y += speed * _velY * (1 / _mass);
			
			// resize object when it's collided with other one
			if (_toScale > _scale)
			{
				_scale += _scale / _toScale * .05;
				if (_scale > _toScale)
					_scale = _toScale;
				scaleX = scaleY = _scale;
			}
			else if (_toScale == 0)
			{
				_scale -= _scale * .5;
				scaleX = scaleY = _scale;
				if (_scale <= .1)
					destroy();
			}
		}
		
		
		//
		// PROTECTED METHODS
		//
		
		/**
		 *  drawing circle as a body of an object
		 */
		protected function drawBody():void
		{
			graphics.lineStyle(1, 0, 1, false, LineScaleMode.NONE);
			graphics.beginFill(_color);
			graphics.drawCircle(0, 0, _startRadius);
			graphics.endFill();
			scaleX = scaleY = _scale;
		}
		
		/**
		 *  destructure function
		 */
		protected function destroy():void
		{
			// unnecessary cleaning but can be usefull if object is used in object pool
			speed = 0;
			friction = 0;
			_radius = 0;
			_area = 0;
			_velX = 0;
			_velY = 0;
			_mass = 0;
			_scale = 1;
			_toScale = 1;
			_startRadius = 0;
			_isColliding = false;
			graphics.clear();
			dispatchEvent(new Event(DESTROYED));
		}
	}
}