package com.horidream.display.decorators
{
	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Jun 29, 2011
	 */
	import com.horidream.core.MovieClipDecorator;
	import com.horidream.interfaces.IProgressBar;
	
	import flash.display.MovieClip;
	
	public class MovieProgressBar extends MovieClipDecorator implements IProgressBar
	{
		public var frameNumber:int;
		public function MovieProgressBar(decoratedMovieClip:MovieClip)
		{
			frameNumber = decoratedMovieClip.totalFrames;
			super(decoratedMovieClip);
		}
		

		public function showProgress(percent:int):void
		{
			decoratedMovieClip.gotoAndStop(int(frameNumber/100*percent));
		}


	}
}