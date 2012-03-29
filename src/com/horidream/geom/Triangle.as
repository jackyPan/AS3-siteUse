package com.horidream.geom
{
	import flash.geom.Point;

	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Jun 1, 2011
	 */
	public class Triangle
	{
		public static const radianToAngle:Number = 180 / Math.PI;
		
		private var _p1:Point;
		private var _p2:Point;
		private var _p3:Point;
		
		private var _l1:Number;
		private var _l2:Number;
		private var _l3:Number;
		
		private var _radian1:Number;
		private var _radian2:Number;
		private var _radian3:Number;
		
		private var _angle1:Number;
		private var _angle2:Number;
		private var _angle3:Number;
		
		public static function parse(x1:Number,y1:Number,x2:Number,y2:Number,x3:Number,y3:Number):Triangle
		{
			return new Triangle(new Point(x1,y1),new Point(x2,y2),new Point(x3,y3));
		}
		
		public function Triangle(p1:Point,p2:Point,p3:Point) 
		{
			this._p1 = p1;
			this._p2 = p2;
			this._p3 = p3;
			update();
		}
		public function get l1():Number
		{
			return _l1;
		}
		public function get l2():Number
		{
			return _l2;
		}
		public function get l3():Number
		{
			return _l3;
		}
		public function get angle1():Number
		{
			return _angle1;
		}
		public function get angle2():Number
		{
			return _angle2;
		}
		public function get angle3():Number
		{
			return _angle3;
		}
		
		public function get p3():Point { return _p3; }
		
		public function set p3(value:Point):void 
		{
			_p3 = value;
			update();
		}
		
		public function get p2():Point { return _p2; }
		
		public function set p2(value:Point):void 
		{
			_p2 = value;
			update();
		}
		
		public function get p1():Point { return _p1; }
		
		public function set p1(value:Point):void 
		{
			_p1 = value;
			update();
		}
		
		public function get radian1():Number
		{
			return _radian1;
		}
		public function get radian2():Number
		{
			return _radian2;
		}
		public function get radian3():Number
		{
			return _radian3;
		}
		
		private function update():void
		{
			_l1 = Point.distance(p2, p3);
			_l2 = Point.distance(p1, p3);
			_l3 = Point.distance(p2, p1);
			_radian1 = Math.acos((_l2 * _l2 + _l3 * _l3 - _l1 * _l1) / (2 * _l2 * _l3));
			_radian2 = Math.acos((_l1 * _l1 + _l3 * _l3 - _l2 * _l2) / (2 * _l1 * _l3));
			_radian3 = Math.acos((_l2 * _l2 + _l1 * _l1 - _l3 * _l3) / (2 * _l2 * _l1));
			_angle1 = _radian1*radianToAngle;
			_angle2 = _radian2*radianToAngle;
			_angle3 = _radian3*radianToAngle;
		}
	}
}