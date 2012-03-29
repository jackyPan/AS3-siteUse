package com.horidream.graphics
{
	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Oct 9, 2011
	 */
	import flash.display.Sprite;
	
	public class TestCircle extends Sprite
	{
		public function TestCircle(x:Number = 0,y:Number = 0,radius:Number = 50,color:Number = 0xFF0000,alpha:Number = 1)
		{
			this.graphics.beginFill(color,alpha);
			this.graphics.drawCircle(x,y,radius);
			this.graphics.endFill();
		}
		public function moveTo(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
	}
}