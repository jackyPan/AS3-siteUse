package com.horidream.util
{
	/**
	 * Copyright 2010. All rights reserved. 
	 *
	 * @author 	Horidream
	 * @since 	Sep 29, 2010 10:12:59 AM
	 */
	public class ArrayUtil
	{
		/**
		 * 将一个数组中的各元素按照另一数组范围进行保留 
		 * @param tarArray		待检查的数组
		 * @param items			作为检查标准的数组
		 * @return 				tarArr中是否有元素被剔除
		 * 
		 */
		public static function retainItems(tarArray:Array, items:Array):Boolean {
			var removed:Boolean = false;
			var l:uint          = tarArray.length;
			
			while (l--) {
				if (items.indexOf(tarArray[l]) == -1) {
					tarArray.splice(l, 1);
					removed = true;
				}
			}
			
			return removed;
		}
		/**
		 * 验证两个数组是否是包含关系 
		 * @param arrayA	被验证的数组A
		 * @param arrayB	被验证的数组B
		 * @return 			若A包含B，则返回true，否则返回false
		 * 
		 */
		public static function contain(arrayA:Array, arrayB:Array):Boolean{
			var l:uint          = arrayB.length;
			while (l--) {
				if (arrayA.indexOf(arrayB[l]) == -1) {
					return false
				}
			}
			return true;
		}
		/**
		 * 将一个数组中出现在另一数组中的元素剔除 
		 * @param tarArray	待操作数组
		 * @param items		作为对照基准的数组
		 * @return 			tarArr中是否有元素被剔除
		 * 
		 */
		public static function cullItems(tarArray:Array, items:Array):Boolean {
			var removed:Boolean = false;
			var l:uint          = tarArray.length;
			
			while (l--) {
				if (items.indexOf(tarArray[l]) != -1) {
					tarArray.splice(l, 1);
					removed = true;
				}
			}
			
			return removed;
		}
		/**
		 * 将一个二维数组旋转90度 
		 * @param tarArr		操作对象二维数组
		 * @param clockWise		是否顺时针旋转，默认为是
		 * @return 				旋转后的二维数组
		 * 
		 */
		public static function rotate(tarArr:Array,clockWise:Boolean = true):Array{
			try{
				var r:Array = new Array(tarArr[0].length).map(function():*{return [];});
				for (var j:int = 0; j<tarArr.length; ++j)
				{
					for (var i:int = 0; i < r.length; ++i)
					{
						if (clockWise)
						{
							r[i][tarArr.length - 1 - j] = tarArr[j][i];
						}
						else
						{
							r[r.length - 1 - i][j] = tarArr[j][i];
						}
					}
				}
			}catch(e:Error){
				throw new Error("操作对象不是二维数组，无法转换");
			}
			return r;
		}
		
		/**
		 * 产生一个元素在fromNumber和toNumber之间，不重复的数组
		 * @param fromNumber	元素区间起始
		 * @param toNumber		元素区间结束
		 * @return 				返回数组
		 * 
		 */
		public static function getRandomArray(fromNumber:int,toNumber:int):Array {
			var min:int = Math.min(fromNumber,toNumber);
			var max:int = Math.max(fromNumber,toNumber);
			var n:int = max-min;
			
			
			var ary:Array = [];
			while (n--) ary.push(Math.random());
			ary = ary.sort(Array.NUMERIC | Array.RETURNINDEXEDARRAY);
			if(min == 0){
				return ary;
			}else{
				return ary.map(function(e:Number,i:int,a:Array):Number{return e+min});
			}
		}
		
		public static function singletonMerge(arrayA:Array, arrayB:Array):Array
		{
			var arr:Array = arrayA.slice();
			for(var i:int = 0;i<arrayB.length;i++)
			{
				if(arr.indexOf(arrayB[i])==-1)
				{
					arr.push(arrayB[i]);
				}
			}
			return arr;
		}
		

	}
}