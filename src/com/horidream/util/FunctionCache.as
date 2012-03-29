package com.horidream.util
{
	import com.horidream.vo.FunctionCacheVO;
	
	import flash.utils.Dictionary;

	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Nov 1, 2011
	 */
	public class FunctionCache
	{
		private static var map:Dictionary = new Dictionary();
		public static function addCacheManually(relatedObject:Object,func:Function,args:Array = null):void
		{
			if(!map[relatedObject])
			{
				map[relatedObject] = [];
			}
			var vo:FunctionCacheVO = new FunctionCacheVO(func,args);
			map[relatedObject].push(vo);
		}
		public static function addCache(relatedObject:Object,...args):void
		{
			if(!map[relatedObject])
			{
				map[relatedObject] = [];
			}
			var vo:FunctionCacheVO;
			if(args[0] is Function){
				var cachedFunc:Function = args.shift();
				vo = new FunctionCacheVO(cachedFunc,args);
			}else{
			 	vo = new FunctionCacheVO(args[0].callee,args[0]);
			}
			
			map[relatedObject].push(vo);
		}
		public static function hasCachedFunction(relatedObject:Object):Boolean
		{
			if(map[relatedObject])
			{
				return true;
			}
			return false;
		}
		public static function execute(relatedObject:Object):void
		{
			var funcArr:Array = map[relatedObject];
			while(funcArr.length>0)
			{
				FunctionCacheVO(funcArr.shift()).execute();
			}
			delete map[relatedObject];
			
		}
	}
}