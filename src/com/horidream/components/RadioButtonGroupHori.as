package com.horidream.components
{
	/**
	 * Copyright 2010. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Dec 13, 2010
	 */
	import com.horidream.core.ButtonBase;
	import com.horidream.util.QuickSetter;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	import org.osflash.signals.Signal;
	
	
	public class RadioButtonGroupHori extends ButtonGroupHori
	{
		public var freezeTime:int;
		private var lastTime:int=0;
		public function RadioButtonGroupHori()
		{
		}




		public function get selectedIndex():int
		{
			if(currentButton){
				return btArr.indexOf(currentButton);
			}else{
				return -1;
			}
		}


		public function reset():void{
			if(currentButton){
				currentButton.selected = false;
				currentButton = null;
			}
		}
		
		public function select(index:int):void
		{
			if(setSelectionAt(index)){
				selectSignal.dispatch(index);
			}
		}
		public function setSelectionAt(index:int):Boolean
		{
			var bt:ButtonBase = getButtonAt(index);
			if(bt && (bt!=currentButton)){
				if(currentButton){
					(currentButton).selected = false;
				}
				currentButton = bt;
				currentButton.selected = true;
				if(bt.parent && needSort)
					bt.parent.setChildIndex(bt,bt.parent.numChildren-1);
				return true;
			}else if(bt){
				currentButton.selected = true;
				if(bt.parent && needSort)
					bt.parent.setChildIndex(bt,bt.parent.numChildren-1);
			}
			return false;
		}
		public function sortDepth(leftOnTop:Boolean = true):void
		{
			var len:int = this.length;
			for(var i:int = 0;i<len;i++){
				var index:int = leftOnTop?len-1-i:i;
				var btn:ButtonBase = getButtonAt(index);
				btn.parent.addChild(btn);
			}
			currentButton.parent.setChildIndex(currentButton,currentButton.parent.numChildren-1);
		}
		protected override function onClick(e:MouseEvent):void
		{
			if(e.currentTarget.pause){
				return;
			}
			if(freezeTime){
				var currentTime:int = getTimer();
				if((currentTime-lastTime)<freezeTime)
				{
					return;
				}else{
					lastTime = currentTime;
				}
			}
			if(currentButton){
				currentButton.selected = false;
			}
			currentButton = e.currentTarget as ButtonBase;
			(currentButton).selected = true;
			var index:int = btArr.indexOf(e.currentTarget);
			if(needSort)
				sortDepth();
			selectSignal.dispatch(index);
			
		}
		
	}
}