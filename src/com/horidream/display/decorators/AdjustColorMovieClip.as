package com.horidream.display.decorators
{
	import com.horidream.core.MovieClipDecorator;
	
	import fl.motion.AdjustColor;
	
	import flash.display.MovieClip;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	
	/**
	 * Copyright 2010. All rights reserved. 
	 *
	 * @author Horidream
	 *
	 * Created Jun 1, 2010 
	 */
	public class AdjustColorMovieClip extends MovieClipDecorator
	{
		private var _contrast:Number;
		private var _hue:Number;
		private var _saturation:Number;
		private var _brightness:Number;
		private var adjustColor:AdjustColor;
		
		public function AdjustColorMovieClip(decoratedMovieClip:MovieClip)
		{
			super(decoratedMovieClip);
			if(decoratedMovieClip is AdjustColorMovieClip){
				var dm:AdjustColorMovieClip = decoratedMovieClip as AdjustColorMovieClip;
				_contrast = dm.contrast;
				_hue = dm.hue;
				_brightness = dm.brightness;
				_saturation = dm.saturation;
			}else{
				_contrast = 0;
				_hue = 0;
				_brightness = 0;
				_saturation = 0;
			}
			adjustColor = new AdjustColor();
		}
		
		
		public function get contrast():Number
		{
			return _contrast;
		}
		
		public function set contrast(value:Number):void
		{
			_contrast = value;
			setAdjustColor();
		}
		
		
		
		
		public function get hue():Number
		{
			return _hue;
		}
		
		public function set hue(value:Number):void
		{
			_hue = value;
			setAdjustColor();
		}
		
		public function get saturation():Number
		{
			return _saturation;
		}
		
		public function set saturation(value:Number):void
		{
			_saturation = value;
			setAdjustColor();
		}
		
		public function get brightness():Number
		{
			return _brightness;
		}
		
		public function set brightness(value:Number):void
		{
			_brightness = value;
			setAdjustColor();
		}
		private function setAdjustColor():void
		{
			adjustColor.contrast = _contrast;
			adjustColor.brightness = _brightness;
			adjustColor.hue = _hue;
			adjustColor.saturation = _saturation;
			this.filters = [new ColorMatrixFilter(adjustColor.CalculateFinalFlatArray())];
		}
		
	}
}