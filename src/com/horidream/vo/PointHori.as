package com.horidream.vo
{
	import org.osflash.signals.DeluxeSignal;
	import org.osflash.signals.Signal;

	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	May 5, 2011
	 */
	public class PointHori
	{
		private var _x:Number;
		private var _y:Number;

		public var initX:Number;
		public var initY:Number;
		public var next:PointHori;
		
		public var update:Signal = new Signal();

		public function PointHori(x:Number,y:Number)
		{
			this._x = this.initX = x;
			this._y = this.initY = y;
			
		}
		public function get x():Number
		{
			return _x;
		}

		public function set x(value:Number):void
		{
			_x = value;
			update.dispatch()
		}

		public function get y():Number
		{
			return _y;
		}

		public function set y(value:Number):void
		{
			_y = value;
			update.dispatch()
		}
		public function moveTo(x:Number,y:Number):void
		{
			this._x = x;
			this._y = y;
			update.dispatch()
		}
		

		public function toString():String
		{
			return "PointHori{x:" + x + ", y:" + y + "}";
		}


	}
}