package com.horidream.components
{
	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Jan 30, 2011
	 */
	import com.horidream.core.ButtonBase;
	import com.horidream.util.HoriMath;
	import com.horidream.util.QuickSetter;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.osflash.signals.Signal;
	
	public class SwitchStatusButton extends Sprite
	{
		private var statusList:Array = [];
		private var _currentStatusIndex:int = 0;
		private var currentBtn:ButtonBase;
		public var statusChanged:Signal = new Signal(int);
		public function SwitchStatusButton(container:DisplayObjectContainer = null)
		{
			if(container)
				container.addChild(this);
		}


		public function get currentStatusIndex():int
		{
			return _currentStatusIndex;
		}

		public function set currentStatusIndex(value:int):void
		{
			_currentStatusIndex = HoriMath.getValidPeriodValue(value,0,statusList.length);
			QuickSetter.swapDisplayObject(currentBtn,statusList[_currentStatusIndex]);
			currentBtn = statusList[_currentStatusIndex];
		}

		public function addStatus(btn:ButtonBase):void{
			if(!currentBtn){
				currentBtn = btn;
				addChild(currentBtn);
			}else{
				QuickSetter.removeSelf(btn);
			}
			statusList[statusList.length] = btn;
//			btn.addEventListener(MouseEvent.CLICK,onClick);
		}
//		private function onClick(e:MouseEvent):void
//		{
//			currentStatusIndex++;
//			statusChanged.dispatch(currentStatusIndex);
//		}
	}
}