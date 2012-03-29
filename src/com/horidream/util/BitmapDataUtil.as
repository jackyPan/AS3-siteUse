package com.horidream.util
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	

	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	May 26, 2011
	 */
	public class BitmapDataUtil
	{
		public static const WOOD:String = "wood";
		public static const MARBLE:String = "marble";
		public static function getPattern(type:*,rec:Rectangle,id:uint = 0):BitmapData
		{
			if(type is Number)
			{
				return new BitmapData(rec.width,rec.height,true,uint(type)<=0xFFFFFF?uint(type)+0xFF000000:uint(type));
			}
			else if(type is String)
			{
				var patterArr:Array = String(type).split(/ |,|-/);
				
				switch(patterArr[0])
				{
					case WOOD:
					{
						return genWoodPattern(rec,patterArr[1]||id);
						break;
					}
					case MARBLE:
					{
						return genMarblePattern(rec,patterArr[1]||id);
						break;
					}
						
					default:
					{
						return genWoodPattern(rec,patterArr[1]||id);
						break;
					}
				}
			}
			return null;
		}
		public static function isEmpty(bmd:BitmapData):Boolean
		{
			var rect:Rectangle = bmd.getColorBoundsRect(0xFF000000, 0x00000000,false);
			if((!rect) || (rect.width == 0) || (rect.height == 0))
			{
				return true;
			}
			return false;
		}
		public static function flipBitmapData(bitmapData:BitmapData,isHorizontal:Boolean = true):BitmapData
		{
			var bmd:BitmapData = bitmapData.clone();
			bmd.fillRect(bmd.rect,0x00FFFFFF);
			var m:Matrix;
			if(isHorizontal){
				m = new Matrix(-1,0,0,1,bmd.width,0);
			}else{
				m = new Matrix(1,0,0,-1,0,bmd.height);
			}
			bmd.draw(bitmapData,m);
			return bmd;
		}
		public static function merge(fillPattern:BitmapData,alphaChannel:BitmapData):BitmapData
		{
			var bmd:BitmapData = new BitmapData(alphaChannel.width,alphaChannel.height,true);
			var zero:Point = new Point();
			bmd.copyPixels(fillPattern,bmd.rect,zero,alphaChannel,zero);
			return bmd;
			
		}
		public static function mergeAnything(fillPattern:*,alphaChannel:*):BitmapData
		{
			return merge(Cast.bitmapData(fillPattern),Cast.bitmapData(alphaChannel));
		}
		
		private static function genWoodPattern(rec:Rectangle,id:uint = 0):BitmapData
		{
			var bmd:BitmapData = new BitmapData(rec.width,rec.height,true,0x00FFFFFF);
			var scale:Number = 2;
			
			var perlinBaseX:int = 50;
			var perlinBaseY:int = 600;
			var displayWidth:Number = rec.width;
			var displayHeight:Number = rec.height;
			
			var woodPatternData:BitmapData  = new BitmapData(scale*displayWidth, scale*displayHeight, true, 0x00000000);
			var perlinData:BitmapData = new BitmapData(scale*displayWidth, scale*displayHeight, false, 0x000000);
			var displayData:BitmapData = new BitmapData(displayWidth, displayHeight, true, 0x00000000);
			var colorList:Vector.<uint>;
			switch(id)
			{
				case 1:
					colorList = new <uint>[0xd78e41,0xd8994a, 0xe5a656, 0xcc7d38];
					break;
				case 2:
					colorList = new <uint>[0x7a2102, 0x872707, 0x932f03, 0xa83d18, 0x6a1901, 0x560e01];
					break;
				case 3:
					colorList = new <uint>[0xc8a17a, 0xd1af8c, 0xbd9068, 0xad7a53, 0x9c6741, 0x885230];
					break;
				default:
					colorList = new <uint>[0xd78e41,0xd8994a, 0xcc7d38, 0xb86a2c, 0xae531c];
					break;
			}
			
			
			
			var origin:Point = new Point(0,0);
			var blur:BlurFilter = new BlurFilter(2,2);
			
			var numBands:int = 80;
			var r:uint;
			var g:uint;
			var b:uint;
			var i:int;
			var index:int;
			var color:uint;
			var rInitArray:Array = new Array();
			var gInitArray:Array = new Array();
			var bInitArray:Array = new Array();
			var rArray:Array = new Array();
			var gArray:Array = new Array();
			var bArray:Array = new Array();
			
			//we have to reset the color choice list:
			var colorChoices:Vector.<uint> = new Vector.<uint>();
			var len:int = colorList.length
			for (i = 0; i < len; i++) {
				var thisColor:uint = colorList[i];
				colorChoices.push(thisColor);
			}
			
			//in the loop below, we are choosing colors randomly from our color list, but in such a way as 
			//to avoid the same color being selected twice in sequence. This is accomplished by always removing the 
			//last chosen color from the color list before making the next choice.
			var choiceIndex:int;
			var lastChoice:uint = colorChoices.splice(0,1)[0];
			
			for (i = 0; i <= numBands; i++) {
				choiceIndex = Math.floor(Math.random()*colorChoices.length)
				color = colorChoices[choiceIndex];
				
				r = color & 0xFF0000;
				g = color & 0xFF00;
				b = color & 0xFF;
				
				rInitArray.push(r);
				gInitArray.push(g);
				bInitArray.push(b);
				
				//remove this chosen color:
				colorChoices.splice(choiceIndex,1);
				//put last choice back in:
				colorChoices.push(lastChoice);
				//set last choice to one chosen in this loop:
				lastChoice = color;
			}
			
			for (i = 0; i <= 255; i++) {
				index = int(i/255*(numBands-1));
				rArray.push(rInitArray[index]);
				gArray.push(gInitArray[index]);
				bArray.push(bInitArray[index]);
			}
			
			
			perlinData.perlinNoise(perlinBaseX, perlinBaseY, 4, Math.random()*0xFFFFFF, false, true, 7, true);
			perlinData.applyFilter(perlinData, perlinData.rect, new Point(), new BlurFilter(6,6));
			
			woodPatternData.paletteMap(perlinData, perlinData.rect, origin, rArray, gArray, bArray);
			bmd.draw(woodPatternData, new Matrix(1/scale, 0, 0, 1/scale), null, null, null, true);
			return bmd;
		}
		private static function genMarblePattern(rec:Rectangle,id:uint = 0):BitmapData
		{
			var bmd:BitmapData = new BitmapData(rec.width,rec.height,true,0x00FFFFFF);
			var perlinBaseX:int = 50;
			var perlinBaseY:int = 50;
			var brightenFactor:Number = 1.7;
			var whiteColor:uint = 0xFAB5AB;
			var offsetColor:uint = 0x30221F;
			switch(id)
			{
				case 1:
				{
					brightenFactor = 1.2;
					whiteColor = 0xFFFFFF;
					offsetColor = 0x101A38;
					break;
				}
				case 2:
				{
					brightenFactor = 1.9;
					whiteColor = 0xFFFFFF;
					offsetColor = 0x000008;
					break;
				}
					
				default:
				{
					break;
				}
			}
			
			var perlinData:BitmapData = new BitmapData(bmd.width, bmd.height, false, 0);
			perlinData.perlinNoise(perlinBaseX, perlinBaseY, 4, Math.random()*0xFFFFFF, true, true, 7, false);
			
			
			var noiseData:BitmapData = new BitmapData(bmd.width, bmd.height, false);
			noiseData.noise(Math.random()*0xFFFFFF,0,255,7,true);
			
			bmd.copyPixels(perlinData,perlinData.rect, new Point());
			
			perlinData.colorTransform(perlinData.rect, new ColorTransform(1.5,1.5,1.5));
			
			
			var dmf:DisplacementMapFilter = new DisplacementMapFilter(perlinData, new Point(), BitmapDataChannel.BLUE, BitmapDataChannel.RED, 5*perlinBaseX, 5*perlinBaseY, "wrap")
			bmd.applyFilter(bmd, bmd.rect, new Point(), dmf);
			
			var multR:Number = (whiteColor >> 16)/255*brightenFactor;
			var multG:Number = ((whiteColor >> 8) & 0xFF)/255*brightenFactor;
			var multB:Number = (whiteColor & 0xFF)/255*brightenFactor;
			var offsetR:Number = offsetColor >> 16;
			var offsetG:Number = (offsetColor >> 8) & 0xFF;
			var offsetB:Number = offsetColor & 0xFF;
			var cmf:ColorMatrixFilter = new ColorMatrixFilter([multR,0,0,0,offsetR,
				multG,0,0,0,offsetG,
				multB,0,0,0,offsetB,
				0,0,0,1,0]);
			
			bmd.applyFilter(bmd, bmd.rect, new Point(), cmf);
			
			return bmd;
		}
	}
}