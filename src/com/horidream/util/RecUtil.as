package com.horidream.util
{
	import com.horidream.geom.Line;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * Copyright 2010. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Dec 30, 2010
	 */
	public class RecUtil
	{
		private static var _bd:BitmapData;
		private static var _rect:Rectangle = new Rectangle(0,0,2800,2800);
		private static var _matrix:Matrix = new Matrix();
		
		/**
		 * 将矩形投射到global 
		 * @param rec						操作数矩形
		 * @param targetCoordinateSpace		矩形所在的坐标系
		 * @return 							投射到global坐标系后的矩形
		 * 
		 */
		public static function localToGlobal(rec:Rectangle,targetCoordinateSpace:DisplayObject):Rectangle
		{
			var tl:Point = rec.topLeft;
			var br:Point = rec.bottomRight;
			tl = targetCoordinateSpace.localToGlobal(tl);
			br = targetCoordinateSpace.localToGlobal(br);
			return new Rectangle(tl.x,tl.y,br.x-tl.x,br.y-tl.y);
		}
		/**
		 * 将矩形由global坐标系投射至指定坐标系 
		 * @param rec						操作数矩形
		 * @param targetCoordinateSpace		指定的投射坐标系
		 * @return 							由global投射至指定坐标系（targetCoordinateSpace）的矩形
		 * 
		 */
		public static function globalToLocal(rec:Rectangle,targetCoordinateSpace:DisplayObject):Rectangle
		{
			var tl:Point = rec.topLeft;
			var br:Point = rec.bottomRight;
			tl = targetCoordinateSpace.globalToLocal(tl);
			br = targetCoordinateSpace.globalToLocal(br);
			return new Rectangle(tl.x,tl.y,br.x-tl.x,br.y-tl.y);
		}
		
		public static function swapCoordinateSpace(rec:Rectangle,fromCoordinateSpace:DisplayObject,toCoordinateSpace:DisplayObject):Rectangle
		{
			var tl:Point = rec.topLeft;
			var br:Point = rec.bottomRight;
			tl = PointUtil.changeCoordinate(fromCoordinateSpace,toCoordinateSpace,tl);
			br = PointUtil.changeCoordinate(fromCoordinateSpace,toCoordinateSpace,br);
			return new Rectangle(tl.x,tl.y,br.x-tl.x,br.y-tl.y);
		}
		
		
		/**
		 * 返回一个矩形与一条线段的交点组成的数组 
		 * @param rec						矩形
		 * @param line						线段
		 * @param includeExtensionCord		是否包括线段的延长线
		 * @return 							与矩形的左，上，右，下四条边相交交点的数组，如无交点时为null
		 * 
		 */
		public static function intersect(rec:Rectangle,line:Line,includeExtensionCord:Boolean = false):Array{
			var topLeft:Point = rec.topLeft;
			var topRight:Point = new Point(rec.x+rec.width,rec.y);
			var bottomLeft:Point = new Point(rec.x,rec.y+rec.height);
			var bottomRight:Point = rec.bottomRight;
			var lineLeft:Line = new Line(topLeft,bottomLeft);
			var lineTop:Line = new Line(topLeft,topRight);
			var lineRight:Line = new Line(topRight,bottomRight);
			var lineBottom:Line = new Line(bottomLeft,bottomRight);
			
			var leftIntersection:Point = line.intersect(lineLeft,includeExtensionCord);
			var topIntersection:Point = line.intersect(lineTop,includeExtensionCord);
			var rightIntersection:Point = line.intersect(lineRight,includeExtensionCord);
			var bottomIntersection:Point = line.intersect(lineBottom,includeExtensionCord);
			
			return [leftIntersection,topIntersection,rightIntersection,bottomIntersection];
			
		}
		public static function getCenter(rec:Rectangle):Point{
			return new Point((rec.x+rec.width)*.5,(rec.y+rec.height)*.5);
		}
		public static function getStageRec(stage:Stage):Rectangle{
			return new Rectangle(0,0,stage.stageWidth,stage.stageHeight);
		}
		
		public static function getVisibleBounds(target:DisplayObject, targetCoordinateSpace:DisplayObject = null):Rectangle {
			targetCoordinateSpace = targetCoordinateSpace || target;
			if (!_bd) {
				_bd = new BitmapData(2800, 2800, true, 0x00FFFFFF);
			}
			var msk:DisplayObject = target.mask;
			target.mask = null;
			_bd.fillRect(_rect, 0x00FFFFFF);
			_matrix.tx = _matrix.ty = 0;
			var offset:Rectangle = target.getBounds(targetCoordinateSpace);
			var m:Matrix = (targetCoordinateSpace == target) ? _matrix : target.transform.matrix;
			m.tx -= offset.x;
			m.ty -= offset.y;
			try{
				_bd.draw(target, m, null, "normal", _rect, false);
			}catch(e:Error)
			{
				return targetCoordinateSpace.getRect(target);
			}
			var bounds:Rectangle = _bd.getColorBoundsRect(0xFF000000, 0x00000000, false);
			bounds.x += offset.x;
			bounds.y += offset.y;
			target.mask = msk;
			return bounds;
		}
		public static function getSolidBounds(target:DisplayObject, targetCoordinateSpace:DisplayObject = null):Rectangle {
			targetCoordinateSpace = targetCoordinateSpace || target;
			if (!_bd) {
				_bd = new BitmapData(2800, 2800, true, 0x00FFFFFF);
			}
			var msk:DisplayObject = target.mask;
			target.mask = null;
			_bd.fillRect(_rect, 0x00FFFFFF);
			_matrix.tx = _matrix.ty = 0;
			var offset:Rectangle = target.getBounds(targetCoordinateSpace);
			var m:Matrix = (targetCoordinateSpace == target) ? _matrix : target.transform.matrix;
			m.tx -= offset.x;
			m.ty -= offset.y;
			try{
				_bd.draw(target, m, null, "normal", _rect, false);
			}catch(e:Error)
			{
				return targetCoordinateSpace.getRect(target);
			}
			var bounds:Rectangle = _bd.getColorBoundsRect(0xFF000000, 0xFF000000,true);
			bounds.x += offset.x;
			bounds.y += offset.y;
			target.mask = msk;
			return bounds;
		}
	}
}