package com.horidream.util
{
	import flash.external.ExternalInterface;

	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Aug 23, 2011
	 */
	public class JavaScriptUtil
	{
		public static function callMethod(methodNameInJavaScript:String,...args):Boolean
		{
			args.unshift(methodNameInJavaScript);
			var parameters:Array = args;
			
			if (ExternalInterface.available){
				ExternalInterface.call.apply(null,parameters);
				return true;
			}
			return false;
			
		}
		public static function addCallBack(methodNameInJavaScript:String,methodInAS:Function):Boolean
		{
			
			if (ExternalInterface.available){
				ExternalInterface.addCallback(methodNameInJavaScript,methodInAS);
				return true;
			}
			return false;
			
		}
	}
}