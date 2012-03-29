package com.horidream.vo
{
	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Oct 31, 2011
	 */
	public class ProgressVO
	{
		private var _progress:int;
		private var _completed:Boolean;
		public function ProgressVO(progress:int,completed:Boolean)
		{
			this._progress = progress;
			this._completed = completed;
		}


		public function get progress():int
		{
			return _progress;
		}

		public function get completed():Boolean
		{
			return _completed;
		}


		public function toString():String
		{
			return "ProgressVO{_progress:" + _progress + ", _completed:" + _completed + "}";
		}


	}
}