package com.horidream.vo
{
	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Nov 1, 2011
	 */
	public class FunctionCacheVO
	{

		public function get func():Function
		{
			return _func;
		}

		public function get args():Array
		{
			return _args;
		}

		private var _func:Function;
		private var _args:Array;
		public function FunctionCacheVO(func:Function,args:Array = null)
		{
			this._func = func;
			this._args = args;
		}
		public function execute():void
		{
			if(_args && _args.length>0)
			{
				this._func.apply(null,_args);
			}else{
				this._func.call();
			}
		}
		

		public function toString():String
		{
			return "FunctionCacheVO{_func:" + _func + ", _args:[" + _args + "]}";
		}


	}
}