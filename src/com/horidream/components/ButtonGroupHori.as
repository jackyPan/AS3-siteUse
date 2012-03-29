package com.horidream.components
{
	import com.horidream.core.ButtonBase;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import org.osflash.signals.Signal;

	/**
	 * Copyright 2010. All rights reserved. 
	 *
	 * @author 	Horidream
	 * @since 	Dec 18, 2010 9:13:26 AM
	 */
	public class ButtonGroupHori
	{
		protected var currentButton:ButtonBase;
		protected var btArr:Array = [];
		public var selectSignal:Signal = new Signal(int);
		public var rollOverSignal:Signal = new Signal(int);
		public var rollOutSignal:Signal = new Signal(int);
		public var needSort:Boolean = false;
		private var _disabled:Boolean = false
		public function ButtonGroupHori()
		{
		}


		public function get disabled():Boolean
		{
			return _disabled;
		}

		public function set disabled(value:Boolean):void
		{
			_disabled = value;
			var tempB:ButtonBase;
			if(_disabled){
				for each(tempB in btArr){
					tempB.pause = true;
				}
			}else{
				for each(tempB in btArr){
					tempB.pause = false;
				}
				
			}
		}

		public function get length():int{
			return btArr.length;
		}
		public function add(bt:ButtonBase):void{
			if(btArr.indexOf(bt) == -1){
				btArr.push(bt);
				bt.addEventListener(MouseEvent.CLICK,onClick);
				bt.addEventListener(MouseEvent.ROLL_OVER,onRollOver);
				bt.addEventListener(MouseEvent.ROLL_OUT,onRollOut);
			}
		}

		

		
		public function addMulti(...arr):void{
			for (var i:int = 0; i < arr.length; i++)
			{
				var element:ButtonBase = arr[i] as ButtonBase;
				add(element);
			}
		}
		public function addRawMovieClip(mc:MovieClip):void{
			if(mc.totalFrames>1){
				add(new MultiFrameButton(mc));
			}else{
				add(new SingleFrameButton(mc));
			}
		}
		public function addMultiRawMovieClip(...arr):void{
			for (var i:int = 0; i < arr.length; i++)
			{
				var element:MovieClip = arr[i] as MovieClip;
				if(element)
					addRawMovieClip(element);
			}
		}
		public function getButtonAt(index:int):ButtonBase{
			return btArr[index] as ButtonBase;
		}
		protected function onClick(e:MouseEvent):void
		{
			currentButton = e.currentTarget as ButtonBase;
			if(currentButton.pause){
				return;
			}
			var index:int = btArr.indexOf(e.currentTarget);
			selectSignal.dispatch(index);
			e.stopImmediatePropagation();
			
		}
		private function onRollOver(e:MouseEvent):void
		{
			if(e.currentTarget.pause){
				return;
			}
			var len:int = btArr.length-1;
			var bt:ButtonBase = e.currentTarget as ButtonBase;
			var parent:DisplayObjectContainer = bt.parent;
			if(needSort){
				bt.parent.setChildIndex(bt,bt.parent.numChildren-1);
			}
			var index:int = btArr.indexOf(e.currentTarget);
			rollOverSignal.dispatch(index);
		}
		public function pauseAll():void
		{
			for each(var btn:ButtonBase in btArr)
			{
				btn.pause = true;
			}
		}
		public function unpauseAll():void
		{
			for each(var btn:ButtonBase in btArr)
			{
				btn.pause = false;
			}
		}
		private function onRollOut(e:MouseEvent):void
		{
			var index:int = btArr.indexOf(e.currentTarget);
			rollOutSignal.dispatch(index);
			if(currentButton && currentButton.parent && needSort)
				currentButton.parent.setChildIndex(currentButton,currentButton.parent.numChildren-1);
		}
	}
}