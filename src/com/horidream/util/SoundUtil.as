package com.horidream.util
{
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;

	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Nov 25, 2011
	 */
	public class SoundUtil
	{
		private static const STRETCH_FACTOR_LIST:Vector.<Number> = Vector.<Number>([257, 129, 65, 33, 17, 9, 5, 3, 2, 1]);
		private static const SPECTRUM_LENGTH_LIST:Vector.<Number> = Vector.<Number>([1, 2, 4, 8, 16, 32, 64, 128, 256, 256]);
		
		
		/**
		 * 返回当前播放的一组混音值 
		 * @param div	返回混音值Vector的组数，0为1组
		 * @param type	取值种类，0为取左右声道较强的混音值，1为左声道，2为右声道
		 * @return 		一个代表当前混音值的Vector对象
		 * 
		 */
		public static function analyzeSound(div:int=0,type:int = 0):Vector.<Number> 
		{
			var i:uint, len:uint, size:uint, position:uint, l:Number, r:Number, 
			stretchFactor:uint, bytes:ByteArray, vector:Vector.<Number>;
			
			if (div > 9) div = 9;
			stretchFactor = STRETCH_FACTOR_LIST[div];
			len = SPECTRUM_LENGTH_LIST[div];
			size = 1024/len;
			
			bytes = new ByteArray();
			SoundMixer.computeSpectrum(bytes, true, stretchFactor);
			
			vector = new Vector.<Number>(len, true);
			switch(type)
			{
				case 0:
					for (i=0; i<len; i++) {
						position = i*size;
						bytes.position = position;
						l = bytes.readFloat();
						bytes.position = position + 1024;
						r = bytes.readFloat();
						vector[i] = (l > r) ? l : r;
					}
					break;
				case 1:
					for (i=0; i<len; i++) {
						position = i*size;
						bytes.position = position;
						vector[i] = bytes.readFloat();
					}
					break;
				case 2:
					for (i=0; i<len; i++) {
						position = i*size;
						bytes.position = position + 1024;
						vector[i] = bytes.readFloat();
					}
					break;
			}
			
			return vector;
		}
	}
}