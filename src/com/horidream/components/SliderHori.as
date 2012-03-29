package com.horidream.components
{
	import com.horidream.util.QuickSetter;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.osflash.signals.Signal;

	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Apr 28, 2011
	 */
	public class SliderHori extends Sprite
	{
		public static const HORIZONTAL:String = "horizontal";
		public static const VERTICAL:String = "vertical";
		protected var _dragger:Sprite;
		protected var _rail:Sprite;
		protected var initX:Number;
		protected var initY:Number;
		protected var _backClick:Boolean = true;
		protected var _value:Number = 0;
		protected var _max:Number = 100;
		protected var _min:Number = 0;
		protected var _orientation:String;
		protected var _tick:Number = 0.01;
		public var changed:Signal = new Signal(Number);
		private var initDraggerPoint:Point;
		public function SliderHori(dragger:Sprite,rail:Sprite,orientation:String = SliderHori.HORIZONTAL)
		{
			this._orientation = orientation;
			this._dragger = dragger;
			this._rail = rail;
			
			
			init();
		}
		private function init():void
		{
			
			this.x = _rail.x;
			this.y = _rail.y;
			this.transform.matrix = _rail.transform.matrix.clone();
			QuickSetter.autoAlign(_rail,this,1);
			_rail.transform.matrix = new Matrix();
			QuickSetter.swapDisplayObject(this,_rail);
			addChild(_rail);
			addChild(_dragger);
			
			if(_orientation == HORIZONTAL)
			{
				QuickSetter.autoAlign(_dragger,_rail,4);
			}else{
				QuickSetter.autoAlign(_dragger,_rail,2);
			}
			initDraggerPoint = new Point(_dragger.x,_dragger.y);
			_dragger.addEventListener(MouseEvent.MOUSE_DOWN, onDrag);
			_dragger.buttonMode = true;
			_dragger.useHandCursor = true;
			if(_backClick)
			{
				_rail.addEventListener(MouseEvent.MOUSE_DOWN, onBackClick);
			}
			else
			{
				_rail.removeEventListener(MouseEvent.MOUSE_DOWN, onBackClick);
			}
		}
		protected function onDrag(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onDrop);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onSlide);
			if(_orientation == HORIZONTAL)
			{
				_dragger.startDrag(false, new Rectangle(initDraggerPoint.x, initDraggerPoint.y, _rail.width - _dragger.width, 0));
			}
			else
			{
				_dragger.startDrag(false, new Rectangle(initDraggerPoint.x, initDraggerPoint.y, 0, _rail.height - _dragger.height));
			}
		}
		protected function onDrop(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onDrop);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onSlide);
			_dragger.stopDrag();
		}
		protected function onSlide(event:MouseEvent):void
		{
			var oldValue:Number = _value;
			if(_orientation == HORIZONTAL)
			{
				_value = _dragger.x / (_rail.width - _dragger.width) * (_max - _min) + _min;
			}
			else
			{
				_value = (_dragger.y) / (_rail.height - _dragger.height) * (_max - _min) + _min;
//				_value = (_rail.height - _dragger.height - _dragger.y) / (_rail.height - _dragger.height) * (_max - _min) + _min;
			}
			if(_value != oldValue)
			{
				changed.dispatch(_value);
			}
		}
		protected function onBackClick(event:MouseEvent):void
		{
			if(_orientation == HORIZONTAL)
			{
				_dragger.x = mouseX - _dragger.width / 2;
				_dragger.x = Math.max(_dragger.x, 0);
				_dragger.x = Math.min(_dragger.x, _rail.width - _dragger.width);
				_value = _dragger.x / (_rail.width - _dragger.width) * (_max - _min) + _min;
			}
			else
			{
				_dragger.y = mouseY - _dragger.height / 2;
				_dragger.y = Math.max(_dragger.y, 0);
				_dragger.y = Math.min(_dragger.y, _rail.height - _dragger.height);
				_value = (_dragger.y) / (_rail.height - _dragger.height) * (_max - _min) + _min;
//				_value = (_rail.height - _dragger.height - _dragger.y) / (_rail.height - _dragger.height) * (_max - _min) + _min;
			}
			changed.dispatch(_value);
			
		}
		protected function correctValue():void
		{
			if(_max > _min)
			{
				_value = Math.min(_value, _max);
				_value = Math.max(_value, _min);
			}
			else
			{
				_value = Math.max(_value, _max);
				_value = Math.min(_value, _min);
			}
		}
		protected function positionHandle():void
		{
			var range:Number;
			if(_orientation == HORIZONTAL)
			{
				range = _rail.width - _dragger.width;
				_dragger.x = (_value - _min) / (_max - _min) * range;
			}
			else
			{
				range = _rail.height - _dragger.height;
				_dragger.y = (_value - _min) / (_max - _min) * range;
//				_dragger.y = _rail.height - _rail.width - (_value - _min) / (_max - _min) * range;
			}
		}
		public function set backClick(b:Boolean):void
		{
			_backClick = b;
		}
		public function get backClick():Boolean
		{
			return _backClick;
		}
		
		/**
		 * Sets / gets the current value of this slider.
		 */
		public function set value(v:Number):void
		{
			_value = v;
			correctValue();
			positionHandle();
			changed.dispatch(_value);
		}
		public function get value():Number
		{
			return Math.round(_value / _tick) * _tick;
		}
		
		/**
		 * Gets the value of the slider without rounding it per the tick value.
		 */
		public function get rawValue():Number
		{
			return _value;
		}
		
		/**
		 * Gets / sets the maximum value of this slider.
		 */
		public function set maximum(m:Number):void
		{
			_max = m;
			correctValue();
			positionHandle();
		}
		public function get maximum():Number
		{
			return _max;
		}
		
		/**
		 * Gets / sets the minimum value of this slider.
		 */
		public function set minimum(m:Number):void
		{
			_min = m;
			correctValue();
			positionHandle();
		}
		public function get minimum():Number
		{
			return _min;
		}
		
		/**
		 * Gets / sets the tick value of this slider. This round the value to the nearest multiple of this number. 
		 */
		public function set tick(t:Number):void
		{
			_tick = t;
		}
		public function get tick():Number
		{
			return _tick;
		}
	}
}