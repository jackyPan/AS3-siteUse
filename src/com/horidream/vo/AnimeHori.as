package com.horidream.vo
{
	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Jun 2, 2011
	 */
	public class AnimeHori
	{
		private var _name:String;
		private var _frames:Array;
		private var _isLoop:Boolean;
		private var _delay:Number;
		public function AnimeHori(name:String,frames:Array,isLoop:Boolean = true,frameRate:Number = 0)
		{
			this._name = name;
			this._frames = frames;
			this._isLoop = isLoop;
			this._delay = frameRate>0?1/frameRate:0;
		}


		public function get name():String
		{
			return _name;
		}

		public function get frames():Array
		{
			return _frames;
		}

		public function get isLoop():Boolean
		{
			return _isLoop;
		}

		public function get delay():Number
		{
			return _delay;
		}

	}
}