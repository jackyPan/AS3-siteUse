package com.horidream.util
{
	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Apr 22, 2011
	 */
	public class StringUtil
	{
		/**
		 * 用于产生一个可以清除cache的url地址字符串 
		 * @param url	需要处理的url
		 * @return 		处理后的url
		 * 
		 */
		public static function noCache(url:String):String
		{
			if(url.indexOf("?horinocache=")>-1)
			{
				return url;
			}
			var d:Date = new Date();
			var nc:String = "horinocache=" + d.getTime();
			if (url.indexOf("?") > -1) return url + "&" + nc;
			return url + "?" + nc;
		}
		
		
		
		/**
		 * 清除字符串头尾部的空格 
		 * @param str		需要处理的字符串
		 * @param left		是否清除头部空格
		 * @param right		是否清除尾部空格
		 * @return 			处理后的字符串
		 * 
		 */
		public static function trim(str:String = "", left:Boolean = true, right:Boolean = true):String
		{
			if (left) str = str.replace(/^\s+/, "");
			if (right) str = str.replace(/\s+$/, "");
			
			return str;
		}
		
		
	}
}