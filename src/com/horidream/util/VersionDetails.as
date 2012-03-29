package com.horidream.util
{
	import flash.system.Capabilities;

	/**
	 * Copyright 2010. All rights reserved. 
	 *
	 * @author 	Horidream
	 * @since 	Sep 11, 2010 1:47:56 AM
	 */
	public class VersionDetails
	{
		
		public static function get version():String{
			return Capabilities.version.split(" ")[1] as String;
		}
		public static function get major():int{
			return int(version.split(",")[0]);
		}
		public static function get minor():int{
			return int(version.split(",")[1]);
		}
		public static function get update():int{
			return int(version.split(",")[2]);
		}
		public static function get build():int{
			return int(version.split(",")[3]);
		}
	}
}