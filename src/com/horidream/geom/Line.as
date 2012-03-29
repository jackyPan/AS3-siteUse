package com.horidream.geom
{
	import flash.geom.Point;

	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Jan 10, 2011
	 */
	public class Line
	{
		public var fromPoint:Point;
		public var toPoint:Point;
		
		
		
		public static function parse(x1:Number,y1:Number,x2:Number,y2:Number):Line{
			return new Line(new Point(x1,y1),new Point(x2,y2));
		}
		public function Line(fromPoint:Point,toPoint:Point)
		{
			this.fromPoint = fromPoint;
			this.toPoint = toPoint;
		}
		public function intersect(line:Line,includeExtensionCord:Boolean = false):Point
		{
			var x1:Number = fromPoint.x;
			var y1:Number = fromPoint.y;
			var x2:Number = toPoint.x;
			var y2:Number = toPoint.y;
			var x3:Number = line.fromPoint.x;
			var y3:Number = line.fromPoint.y;
			var x4:Number = line.toPoint.x;
			var y4:Number = line.toPoint.y;
			
			var x0:Number;
			var y0:Number;
			
			var d:Number = (y2-y1)*(x4-x3)-(y4-y3)*(x2-x1);
			if(d == 0){
				return null;
			}
			x0 = ((x2-x1)*(x4-x3)*(y3-y1)+(y2-y1)*(x4-x3)*x1-(y4-y3)*(x2-x1)*x3)/d ;
			y0 = ((y2-y1)*(y4-y3)*(x3-x1)+(x2-x1)*(y4-y3)*y1-(x4-x3)*(y2-y1)*y3)/(-d); 
			if(includeExtensionCord){
				return new Point(x0,y0);
			}else{
				if(((x0-x1)*(x0-x2) <=0) && ((x0-x3)*(x0-x4) <=0) && ((y0-y1)*(y0-y2) <=0) && ((y0-y3)*(y0-y4) <=0)){
					return  new Point(x0,y0);
				} else{
					return null;		
				}
			}
		}
		public function get length():Number{
			return Point.distance(fromPoint,toPoint);
		}
	}
}