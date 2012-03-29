package com.horidream.util
{
	import flash.geom.Point;

	/**
	 * Copyright 2010. All rights reserved. 
	 *
	 * @author 	Horidream
	 * @since 	Oct 27, 2010 4:42:11 PM
	 */
	public class HoriMath
	{
		/**
		 * 将数value投射到以start和end之差为周期，以start和end为起终点的区间内 
		 * @param value		被操作的数字
		 * @param start		起点
		 * @param end		终点
		 * @return 			投射后的数字
		 * 
		 */		
		public static function getValidPeriodValue(value:Number,start:Number = -180,end:Number = 180):Number{
			var minValue:Number;
			var maxValue:Number;
			if(start<end){
				minValue = start;
				maxValue = end;
			}else if(start>end){
				minValue = end;
				maxValue = start;
			}else{
				return value;
			}
			var average:Number = (minValue+maxValue)/2;
			var halfPeriod:Number = average - minValue;
			var period:Number = 2*halfPeriod;
			
			var temp:Number = value;
			temp -= average;
			temp += halfPeriod;
			temp -= Math.floor(temp/period)*period;
			temp -= halfPeriod;
			temp += average;
			return temp;
		}
		/**
		 * 对参数value进行合理化操作，使其介于start和end之间，当小于下限时，返回下限；大于上限时，返回上限
		 * @param value		被操作的数字
		 * @param start		上下限之一，注意上下限不分大小
		 * @param end		上下限之二，注意上下限不分大小
		 * @return 			计算后返回的数字
		 * 
		 */
		public static function bound(value:Number,start:Number,end:Number):Number
		{
			var minValue:Number;
			var maxValue:Number;
			if(start<end){
				minValue = start;
				maxValue = end;
			}else if(start>end){
				minValue = end;
				maxValue = start;
			}else{
				return value;
			}
			if(value<=minValue){
				return minValue;
			}else if(value>=maxValue){
				return maxValue;
			}else{
				return value;
			}
		}
		/**
		 * 返回参数为n的febonacci数 
		 * @param n		参数n
		 * @return 		返回的febonacci数
		 * 
		 */
		public static function fibonacci(n:int):Number{
			var sqrt5:Number = Math.sqrt(5);
			return 1/sqrt5*((Math.pow((1+sqrt5)/2,n))-(Math.pow((1-sqrt5)/2,n)));
		}
		
		public static function distance(x1:Number,y1:Number,x2:Number = 0,y2:Number = 0):Number
		{
			return Math.sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2));
		}
		/**
		 * 产生一个伪随机数 
		 * @param Seed	用户输入的数值，该值有一个唯一对应的随机值
		 * @return 		产生的伪随机数
		 * 
		 */
		public static function random(Seed:Number=NaN):Number
		{
			if(isNaN(Seed))
				return Math.random();
			else
			{
				//Make sure the seed value is OK
				if(Seed == 0)
					Seed = Number.MIN_VALUE;
				if(Seed >= 1)
				{
					if((Seed%1) == 0)
						Seed /= Math.PI;
					Seed %= 1;
				}
				else if(Seed < 0)
					Seed = (Seed % 1) + 1;
				
				//Then do an LCG thing and return a predictable random number
				return ((69621 * int(Seed * 0x7FFFFFFF)) % 0x7FFFFFFF) / 0x7FFFFFFF;
			}
		}
		public static function rotateAround(px:Number,py:Number,pivotX:Number,pivotY:Number,angle:Number):Point
		{
			var resultPoint:Point;
			var radius:Number = -angle/180*Math.PI;
			var sin:Number = Math.sin(radius);
			var cos:Number = Math.cos(radius);
			resultPoint = new Point(cos*(px-pivotX)+sin*(py-pivotY)+pivotX,-sin*(px-pivotX)+cos*(py-pivotY)+pivotY);
			return resultPoint;
		}
		
		public static function interpolate(values:Array,ratios:Array,f:Number):Number
		{
			if(values.length != ratios.length)
			{
				throw new Error("values' length should be same with ratios' length");
			}
			var len:int = ratios.length;
			var lastRatio:Number = ratios[len-1];
			
			if(f<=ratios[0]/lastRatio){
				return values[0];
			}
			if(f>=1)
			{
				return values[values.length-1];
			}
			var i:int = 0;
			while(f>=ratios[i]/lastRatio)
			{
				i++;
			}
 			return values[i-1]+(values[i]-values[i-1])*(f-ratios[i-1]/lastRatio)/(ratios[i]-ratios[i-1])*lastRatio;
		}
		public static function jumpPeriod(value:Number,period:Number,step:int = 1,offset:Number = 0):Number
		{
			offset = offset % period;
			
			var index:int = Math.floor((value-offset)/period);
			index+=step;
			return offset+index*period;
		}
			
	}
}