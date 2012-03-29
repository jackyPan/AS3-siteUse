/*
Copyright (c) 2009 Ralph Hauwert

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/
package com.horidream.util
{
	import flash.geom.Vector3D;
	
	public class QuaternionUtil
	{
		
		public static function multiplyQuats(q1:Vector3D, q2:Vector3D, out:Vector3D):void
		{
			out.x = q1.w*q2.x+q1.x*q2.w+q1.y*q2.z-q1.z*q2.y;
			out.y = q1.w*q2.y+q1.y*q2.w+q1.z*q2.x-q1.x*q2.z;
			out.z = q1.w*q2.z+q1.z*q2.w+q1.x*q2.y-q1.y*q2.x;
			out.w = q1.w*q2.w-q1.x*q2.x-q1.y*q2.y-q1.z*q2.z;
		}

	}
}