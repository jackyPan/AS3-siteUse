package com.horidream.display
{
	import com.horidream.util.HoriMath;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	Horidream
	 * @since 	May 11, 2011 10:20:15 PM
	 */
	public class BitmapDataScroll
	{
		private var _bitmapData:BitmapData;
		private var offset:Point;
		private var _x:int;
		private var _y:int;



		public function BitmapDataScroll(bmd:BitmapData)
		{
			this._bitmapData = bmd;
			offset = new Point();
		}

		public function update():void
		{
			this._bitmapData = bitmapData;
		}
		public function get bitmapData():BitmapData
		{
			return generateBitmapdata();
		}

		public function set bitmapData(value:BitmapData):void
		{
			_bitmapData = value;
		}

		public function get x():int
		{
			return _x;
		}
		
		public function set x(value:int):void
		{
			var validValue:int = HoriMath.getValidPeriodValue(value,0,_bitmapData.width);
			if(_x!=validValue){
				_x = validValue;
			}
		}

		public function get y():int
		{
			return _y;
		}

		public function set y(value:int):void
		{
			var validValue:int = HoriMath.getValidPeriodValue(value,0,_bitmapData.height);
			if(_y!=validValue){
				_y = validValue;
			}
		}
		
		private function generateBitmapdata():BitmapData
		{
			var bmd:BitmapData = _bitmapData.clone();
			var w:int = bmd.width;
			var h:int = bmd.height;
			bmd.fillRect(bmd.rect,0x00FFFFFF);
			bmd.copyPixels(_bitmapData,new Rectangle(0,0,_x,_y),new Point(w-_x,h-_y));
			bmd.copyPixels(_bitmapData,new Rectangle(_x,0,w-_x,_y),new Point(0,h-_y));
			bmd.copyPixels(_bitmapData,new Rectangle(0,_y,_x,h-_y),new Point(w-_x,0));
			bmd.copyPixels(_bitmapData,new Rectangle(_x,_y,w-_x,w-_y),new Point(0,0));
			return bmd;
		}
		
		
	}
}