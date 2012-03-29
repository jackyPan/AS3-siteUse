package com.horidream.display.decorators
{
	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Mar 16, 2011
	 */
	import com.greensock.TweenMax;
	import com.horidream.core.MovieClipDecorator;
	import com.horidream.interfaces.IShowView;
	import com.horidream.util.QuickSetter;
	
	import flash.display.MovieClip;
	
	public class ShowViewMovieClip extends MovieClipDecorator implements IShowView
	{
		private var showInFromVars:Object;
		private var showOutToVars:Object;

		private var showOutTime:Number;
		private var showInTime:Number;
		private var initParams:Object;

		public function ShowViewMovieClip(decoratedMovieClip:MovieClip,showInFromVars:Object = null,showOutToVars:Object = null,showInTime:Number = .5,showOutTime:Number = .3)
		{
			var defaultShowInVars:Object = {y:-decoratedMovieClip.height,alpha:0};
			var defaultShowOutVars:Object = {y:decoratedMovieClip.height,alpha:0};
			this.showInFromVars = showInFromVars || defaultShowInVars;
			this.showOutToVars = showOutToVars || defaultShowOutVars;
			this.showOutToVars.onComplete = QuickSetter.removeSelf;
			this.showOutToVars.onCompleteParams = [this];
			this.showInTime = showInTime;
			this.showOutTime = showOutTime;
			super(decoratedMovieClip);
		}
		
		public function showIn():void
		{
			if(!initParams){
				initParams = {x:this.x,y:this.y,alpha:this.alpha};
			}
			QuickSetter.set(this,initParams);
			TweenMax.from(this,showInTime,showInFromVars);
			
		}
		
		public function showOut():void
		{
			TweenMax.to(this,showOutTime,showOutToVars);
		}
	}
}