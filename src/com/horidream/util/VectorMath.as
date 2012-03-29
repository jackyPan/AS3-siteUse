package com.horidream.util
{
	import com.horidream.vo.VectorHori;

	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	May 17, 2011
	 */
	public class VectorMath
	{
		public static function dotProduct(v1:VectorHori, v2:VectorHori):Number
		{
			return v1.vx * v2.vx + v1.vy * v2.vy;
		}
	}
}