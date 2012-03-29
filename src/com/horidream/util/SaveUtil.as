package com.horidream.util
{
	import flash.net.SharedObject;

	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Aug 3, 2011
	 */
	public class SaveUtil
	{
		public static function save(key:String,data:Object,url:String = null):Boolean
		{
			var isSuccess:Boolean = true;
			try{
				var so:SharedObject = SharedObject.getLocal(key,url);
				so.data.hori = data;
				so.flush();
				
			}catch(e:Error)
			{
				isSuccess = false;
				trace(e);
			}
			return isSuccess;
		}
		public static function load(key:String,url:String = null):Object
		{
			var o:Object = null;
			try{
				var so:SharedObject = SharedObject.getLocal(key,url);
				o =  so.data.hori;
			}catch(e:Error)
			{
				o = null;
			}
			return o;
		}
		
		public static function clear(key:String,url:String = null):void
		{
			try{
				var so:SharedObject = SharedObject.getLocal(key,url);
				so.clear();
			}catch(e:Error)
			{
			}
		}
		
	}
}