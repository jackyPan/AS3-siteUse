package com.horidream.util
{
	import flash.display.DisplayObject;
	import flash.geom.Point;

	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Jun 29, 2011
	 */
	public class PointUtil
	{
		public static function changeCoordinate(originalCoordinate:DisplayObject,targetCoordinate:DisplayObject,p:Point):Point
		{
			return targetCoordinate.globalToLocal(originalCoordinate.localToGlobal(p));
		}
	}
}