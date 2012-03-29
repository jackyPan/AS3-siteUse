package com.horidream.components
{
	import com.horidream.core.ButtonBase;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.GlowFilter;
	
	public class SingleFrameButton extends ButtonBase
	{
		private var _statusEffect:Array;
		private var useDeaultEffects:Boolean;
		public static var boarderColor:Array = [0xFF9900,0x999900];
		public static var boarderAlpha:Number = 1;
		public function SingleFrameButton(view:MovieClip,useDeaultEffects:Boolean = true,statusEffect:Array = null)
		{
			super(view);
			this.useDeaultEffects = useDeaultEffects;
			this._statusEffect = statusEffect;
			
			
		}		
		
		
		


		public function get statusEffect():Array
		{
			return _statusEffect;
		}
		
		public function set statusEffect(value:Array):void
		{
			_statusEffect = value;
		}
		protected override function onMouseOut(event:MouseEvent):void
		{
			if(useDeaultEffects){
				this.filters = [];
			}else{
				if(statusEffect && statusEffect[0]){
					this.filters = [statusEffect[0]];
				}else{
					this.filters = [];
				}
			}
		}
		protected override function onMouseOver(event:MouseEvent):void
		{
			if(useDeaultEffects){
				this.filters = [getDefaultFilter(1)];
			}else{
				if(statusEffect && statusEffect[1])
					this.filters = [statusEffect[1]];
			}
			//置顶
//			if(this.parent){
//				this.parent.swapChildrenAt(this.parent.getChildIndex(this),this.parent.numChildren-1);
//			}
			super.onMouseOver(event);
		}
		protected override function onMouseDown(event:MouseEvent):void
		{
			if(useDeaultEffects){
				this.filters = [getDefaultFilter(2)];
			}else{
				if(statusEffect && statusEffect[2])
					this.filters = [statusEffect[2]];
			}
			super.onMouseDown(event);
		}
		
//		protected override function onMouseUp(event:MouseEvent):void
//		{
//			if(view.getRect(view).contains(view.mouseX,view.mouseY)){
//				this.filters = useDeaultEffects?[getDefaultFilter(1)]:[statusEffect[1]];
//			}else{
//				if(statusEffect && statusEffect[0]){
//					this.filters = [statusEffect[0]];
//				}else{
//					this.filters = [getDefaultFilter(0)];
//				}
//			}
//		}
		
		
		private function getDefaultFilter(n:int):BitmapFilter{
			switch(n){
				case 0:
					return null;
					break;
				case 1:
					return new GlowFilter(boarderColor[0],boarderAlpha,6,6,3);
					break;
				case 2:
					return new GlowFilter(boarderColor[1],boarderAlpha,6,6,3);
//					return new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0])
					break;
				default:
					return null;
					break;
			}
		}
	}
}