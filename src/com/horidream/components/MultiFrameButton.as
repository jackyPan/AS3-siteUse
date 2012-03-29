package com.horidream.components
{
	import com.horidream.core.ButtonBase;
	import com.horidream.display.decorators.YoyoMovieClip;
	import com.horidream.events.EventBus;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class MultiFrameButton extends ButtonBase
	{
		
		public function MultiFrameButton(view:MovieClip)
		{
			super(view);
			this.view = new YoyoMovieClip(view);			
			this.view.backwardPlayTo(1);
		}


		



		public function get origin():MovieClip
		{
			return view.origin;
		}
		
		protected override function onMouseDown(event:MouseEvent):void
		{
//			view.gotoAndStop(view.totalFrames);
			view.forwardPlayTo(view.totalFrames);
			super.onMouseDown(event);
		}
		protected override function onMouseOut(event:MouseEvent):void
		{
//			if(!pause)
				view.backwardPlayTo(1);
		}

		protected override function onMouseOver(event:MouseEvent):void
		{
			view.forwardPlayTo(view.totalFrames-1);
			super.onMouseOver(event);
		}

		protected override function onMouseUp(event:MouseEvent):void
		{
			view.gotoAndStop(view.totalFrames-1);
		}

		
		
	}
}