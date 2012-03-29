package com.horidream.effects
{
	import com.horidream.util.QuickSetter;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	

	/**
	 * Copyright 2010. All rights reserved. 
	 *
	 * @author 	Horidream
	 * @since 	Oct 15, 2010 10:54:53 AM
	 */
	public class ShowLayer extends Sprite
	{
		public function ShowLayer()
		{
			QuickSetter.disableMouse(this);
		}
		
		public function showInOut(fromTarget:DisplayObject,toTarget:DisplayObject):ShowLayer
		{
			var sl:ShowLayer = new ShowLayer();
			var mother:DisplayObjectContainer = fromTarget.parent;
			QuickSetter.swapDisplayObject(sl,fromTarget);
			
			
			
			
			
			
			
			
			return sl;
		}
	}
}