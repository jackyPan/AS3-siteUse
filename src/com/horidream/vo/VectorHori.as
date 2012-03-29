package com.horidream.vo
{
	import flash.geom.Point;
	
	import org.osflash.signals.Signal;

	/**
	 * Copyright 2011. All rights reserved.
	 *
	 * @author 	horidream
	 * @since 	May 16, 2011
	 */
	public class VectorHori
	{
		private var _a:Point=new Point(0, 0);
		private var _b:Point=new Point(0, 0);
		private var _vx:Number=0;
		private var _vy:Number=0;
		public var updated:Signal = new Signal();

		

		public function VectorHori(startX:Number=0, startY:Number=0, endx:Number=NaN, endy:Number=NaN):void
		{
			if((isNaN(endx) || isNaN(endy)) && !(startX== 0 && startY == 0)){
				update(0, 0, startX, startY, startX, startY);
			}else{
				update(startX,startY,endx,endy);
			}
		}

		public function update(startX:Number=0, startY:Number=0, endx:Number=0, endy:Number=0, newVx:Number=0, newVy:Number=0):void
		{
			if (newVx == 0 && newVy == 0)
			{
				_a.x=startX
				_a.y=startY;
				_b.x=endx
				_b.y=endy;
				
				updated.dispatch();
			}
			else
			{
				_b.x = endx;
				_b.y = endy;
				_vx=newVx;
				_vy=newVy;
				updated.dispatch();
			}
		}

		//Start point
		public function get a():Point
		{
			return _a;

		}

		//End point
		public function get b():Point
		{
			return _b;
		}

		//vx
		public function get vx():Number
		{
			if (_vx == 0)
			{
				return _b.x - _a.x;
			}
			else
			{
				return _vx;
			}
		}

		//vy
		public function get vy():Number
		{
			if (_vy == 0)
			{
				return _b.y - _a.y;
			}
			else
			{
				return _vy;
			}
		}

		//angle (degrees)
		public function get angle():Number
		{
			var angle_Radians:Number=Math.atan2(vy, vx);
			var angle_Degrees:Number=angle_Radians * 180 / Math.PI;
			return angle_Degrees;
		}

		//magnitude (length)
		public function get m():Number
		{
			if (vx != 0 || vy != 0)
			{
				var magnitude:Number=Math.sqrt(vx * vx + vy * vy);
				return magnitude;
			}
			else
			{
				return 0.001;
			}
		}

		//Left normal VectorModel object
		public function get ln():VectorHori
		{

			var leftNormal:VectorHori=new VectorHori();

			if (_vx == 0 && _vy == 0)
			{
				leftNormal.update(a.x, a.y, (a.x + this.lx), (a.y + this.ly));
			}
			else
			{
				leftNormal.update(0, 0, vy,-vx,vy,-vx);
			}

			return leftNormal;
		}

		//Right normal VectorHori object
		public function get rn():VectorHori
		{

			var rightNormal:VectorHori=new VectorHori();

			if (_vx == 0 && _vy == 0)
			{
				rightNormal.update(a.x, a.y, (a.x + this.rx), (a.y + this.ry));
			}
			else
			{
				rightNormal.update(0, 0, -vy,vx,-vy,vx);
			}
			return rightNormal;
		}

		//Right hand normal x component
		public function get rx():Number
		{
			var rx:Number=-vy;
			return rx
		}

		//Right hand normal y component
		public function get ry():Number
		{
			var ry:Number=vx;
			return ry;
		}

		//Left hand normal x component
		public function get lx():Number
		{
			var lx:Number=vy;
			return lx
		}

		//Left hand normal y component
		public function get ly():Number
		{
			var ly:Number=-vx;
			return ly;
		}

		//Normalized vector
		//The code needs to make sure that
		//the length value isn't zero to avoid
		//returning NaN
		public function get dx():Number
		{
			if (m != 0)
			{
				var dx:Number=vx / m
				return dx;
			}
			else
			{
				return 0.001;
			}
		}

		public function get dy():Number
		{
			if (m != 0)
			{
				var dy:Number=vy / m
				return dy;
			}
			else
			{
				return 0.001;
			}
		}
		public function toString():String
		{
			return "VectorHori{start:" + a + ", end:" + b + ", vx:" + vx + ", vy:" + vy + "}";
		}
	}
}
