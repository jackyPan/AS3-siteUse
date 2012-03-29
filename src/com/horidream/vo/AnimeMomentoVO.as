package com.horidream.vo
{
	import com.adobe.serialization.json;
	
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.utils.ByteArray;

	/**
	 * Copyright 2012 All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Jan 4, 2012
	 */
	public class AnimeMomentoVO
	{
		private var matrix:Matrix;
		private var matrix3D:Matrix3D;
		private var color:ColorTransform;
		public var nxt:AnimeMomentoVO;
		public var m:Array;
		public var m3:Array;
		public var c:Array;
		public function AnimeMomentoVO(mc:DisplayObject = null)
		{
			if(mc)
			{
				this.matrix = mc.transform.matrix;
				this.matrix3D = mc.transform.matrix3D;
				this.color = mc.transform.colorTransform;
				if(this.matrix)
				{
					this.m = [matrix.a,matrix.b,matrix.c,matrix.d,matrix.tx,matrix.ty];
				}
				if(this.matrix3D)
				{
					this.m3 = this.matrix3D.rawData.join(",").split(",");
				}
				this.c = [color.redMultiplier,color.greenMultiplier,color.blueMultiplier,color.alphaMultiplier,
					color.redOffset,color.greenOffset,color.blueOffset,color.alphaOffset];
			}
		}
		public function reviseAnime(mc:DisplayObject):void
		{
			if(m && m.length == 6)
			{
				mc.transform.matrix = new Matrix(m[0],m[1],m[2],m[3],m[4],m[5]);
			}
			if(m3 && m3.length == 16)
			{
				mc.transform.matrix3D = new Matrix3D(Vector.<Number>(m3));
			}
			mc.transform.colorTransform = new ColorTransform(c[0],c[1],c[2],c[3],c[4],c[5],c[6],c[7]);
		}
		
		public static function parse(obj:Object):AnimeMomentoVO
		{
			var vo:AnimeMomentoVO = new AnimeMomentoVO();
			vo.m = obj.m;
			vo.m3 = obj.m3;
			vo.c = obj.c;
			
			if(obj.nxt)
			{
				vo.nxt = parse(obj.nxt);
			}
			return vo;
		}
		public function encode():String
		{
			
			return JSON.encode(this);
		}
		

		public function toString():String
		{
			return "AnimeMomentoVO{next:" + nxt + ", m:[" + m + "], m3:[" + m3 + "], c:[" + c + "]}";
		}
		



		
	}
}