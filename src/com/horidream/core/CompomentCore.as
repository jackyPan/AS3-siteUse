package com.horidream.core
{
	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Aug 12, 2011
	 */
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	import org.osflash.signals.Signal;
	
	public class CompomentCore extends Sprite
	{
		
		public var changed:Signal = new Signal();
		public function CompomentCore(container:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0)
		{
			
			
			move(xpos, ypos);
			init();
			if(container != null)
			{
				container.addChild(this);
			}
			changed.add(onChanged);
		}
		
		protected function onChanged():void
		{
						
		}
		
		protected function init():void
		{
		}
		
		public function move(xpos:Number, ypos:Number):void
		{
			x = Math.round(xpos);
			y = Math.round(ypos);
		}
	}
}