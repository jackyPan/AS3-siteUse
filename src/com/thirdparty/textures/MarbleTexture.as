/*
Flash ActionScript 3 class by Dan Gries
www.flashandmath.com
dan@flashandmath.com

please see flashandmath.com for terms of use.
*/

package com.thirdparty.textures
{
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.Point;
	import flash.geom.ColorTransform;
	import flash.filters.ConvolutionFilter;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.filters.GlowFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.display.BitmapDataChannel;
	import flash.geom.Matrix;

	public class MarbleTexture extends Sprite {
		
		private var textureBitmapData:BitmapData;
		private var sourceBitmapData:BitmapData;
		private var displayBitmapData:BitmapData;
		private var displayBitmap:Bitmap;
		private var displayWidth:Number;
		private var displayHeight:Number;
		private var inGlow:GlowFilter;
		
		public var sourceSprite:Sprite;
		public var roundingAmount:Number;
		public var roundingSize:Number;
		public var boundsRect:Rectangle;
		public var brightenFactor:Number;
		public var whiteColor:uint;
		public var offsetColor:uint;
		public var perlinBaseX:Number;
		public var perlinBaseY:Number;
		
		public function MarbleTexture(inputSprite:Sprite) {
			
			sourceSprite = inputSprite;
			
			roundingAmount = 0.4;
			roundingSize = 6;
			
			perlinBaseX = 50;
			perlinBaseY = 50;
			
			brightenFactor = 1.7;
			whiteColor = 0xFAB5AB;
			offsetColor = 0x30221F;
			
			makeSourceBitmap();
		
			//So that this will be an interactive sprite of the same shape as the input sprite, we will add the
			//input Sprite as a child of the textured sprite created here, and then set the hit area of
			//this sprite to be the input sprite. But we will make this child invisible (alpha = 0) to ensure
			//that only the texture will be visible.			
			this.addChild(sourceSprite);
			sourceSprite.alpha = 0;
			this.hitArea = sourceSprite;
						
			textureBitmapData = new BitmapData(displayWidth,displayHeight,false,0);
			displayBitmapData = new BitmapData(displayWidth,displayHeight,true,0);
			displayBitmap = new Bitmap(displayBitmapData);
			displayBitmap.x = boundsRect.x;
			displayBitmap.y = boundsRect.y;
			this.addChild(displayBitmap);			
		}
			
		public function generate():void {
			makeTexture();
			mapTextureToDisplay();
			setFilter();
		}
		
		private function makeTexture():void {
			var perlinData:BitmapData = new BitmapData(textureBitmapData.width, textureBitmapData.height, false, 0);
			perlinData.perlinNoise(perlinBaseX, perlinBaseY, 4, Math.random()*0xFFFFFF, true, true, 7, false);
			
			
			var noiseData:BitmapData = new BitmapData(textureBitmapData.width, textureBitmapData.height, false);
			noiseData.noise(Math.random()*0xFFFFFF,0,255,7,true);
			
			textureBitmapData.copyPixels(perlinData,perlinData.rect, new Point());
			
			perlinData.colorTransform(perlinData.rect, new ColorTransform(1.5,1.5,1.5));
		
			
			var dmf:DisplacementMapFilter = new DisplacementMapFilter(perlinData, new Point(), BitmapDataChannel.BLUE, BitmapDataChannel.RED, 5*perlinBaseX, 5*perlinBaseY, "wrap")
			textureBitmapData.applyFilter(textureBitmapData, textureBitmapData.rect, new Point(), dmf);
			
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
			
			textureBitmapData.applyFilter(textureBitmapData, textureBitmapData.rect, new Point(), cmf);
							
		}
		
		private function mapTextureToDisplay():void {
			displayBitmapData.draw(textureBitmapData);
			//manual masking done by copying the alpha of the source sprite to the display bitmap:
			displayBitmapData.copyChannel(sourceBitmapData, sourceBitmapData.rect, new Point(), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
		}
		
		private function makeSourceBitmap():void {
			//We need to know the bounds for the graphics of the sprite, so we can create a bitmap overlay that is of the right size and position.
			boundsRect = sourceSprite.getBounds(sourceSprite);
			displayWidth = boundsRect.width;
			displayHeight = boundsRect.height;
						
			//we first draw the source sprite to a bitmap. This will be used to set the alpha of the pixels in the texture.
			sourceBitmapData = new BitmapData(displayWidth, displayHeight, true, 0x00000000);
			sourceBitmapData.draw(sourceSprite,new Matrix(1,0,0,1,-boundsRect.x,-boundsRect.y),null,null,null,true);
		}
		
		private function setFilter():void {
			if (roundingAmount != 0) {
				inGlow = new GlowFilter(0x000000,roundingAmount,roundingSize,roundingSize,2,3,true,false);
				displayBitmap.filters = [inGlow];
			}
			else {
				displayBitmap.filters = [];
			}
		}
		
	}
	
}
