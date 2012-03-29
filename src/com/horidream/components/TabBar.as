package com.horidream.components
{
	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Feb 24, 2011
	 */
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	
	public class TabBar extends Sprite
	{
		private var btnGroup:RadioButtonGroupHori;
		private var viewStack:ViewStack;
		private var currentIndex:int = -1;
		public function TabBar(container:DisplayObjectContainer,rec:Rectangle = null, autoFit:int = 5)
		{
			btnGroup = new RadioButtonGroupHori();
			viewStack = new ViewStack(container,rec,autoFit);
			btnGroup.selectSignal.add(onBtnGroupSelect);
		}

		private function onBtnGroupSelect(n:int):void
		{
			viewStack.showAt(n);	
			currentIndex = n;
		}
		public function showTabAt(index:int):void
		{
			btnGroup.select(index);
		}
		public function addTab(btn:MovieClip,view:DisplayObject):void
		{
			btnGroup.addRawMovieClip(btn);
			viewStack.add(view);
		}
		public function setAutoFit(autoFit:int = 5,fitRatio:Number = .95):void
		{
			viewStack.autoFit = autoFit;
			viewStack.fitRatio = fitRatio;
			if(currentIndex>-1)
				viewStack.render();
		}
	}
}