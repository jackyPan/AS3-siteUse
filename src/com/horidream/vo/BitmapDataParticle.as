package com.horidream.vo
{
	import flash.display.BitmapData;

	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Jun 10, 2011
	 */
	public class BitmapDataParticle
	{
		public var initX:Number;
		public var initY:Number;
		public var x:Number;
		public var y:Number;
		public var vx:Number;
		public var vy:Number;
		public var color:int;
		public var friction:Number = .96;
		public var next:BitmapDataParticle;
		public var bmd:BitmapData;
		public var canvas:BitmapData;
		public function BitmapDataParticle(size:uint,x:Number=0,y:Number=0)
		{
			bmd = new BitmapData(size,size,true,0x00FFFFFF);
			this.initX = x;
			this.initY = y;
		}
	}
}