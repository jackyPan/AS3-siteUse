package com.horidream.effects
{
	import com.horidream.display.BitmapDataScroll;
	import com.horidream.util.QuickSetter;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;

	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	Horidream
	 * @since 	May 11, 2011 9:02:02 PM
	 */
	public class FireHori extends Sprite {
		
		private static const ZERO_POINT:Point = new Point();
		
		private var _fireColor:BitmapData;
		private var _currentFireColor:int;
		
		private var _canvas:Sprite;
		private var _grey:BitmapData;
//		private var _spread:ConvolutionFilter;
		private var _cooling:BitmapData;
		private var _noise:BitmapData;
		private var _color:ColorMatrixFilter;
		private var _offset:Array;
		private var _fire:BitmapData;
		private var _palette:Array;
		private var _zeroArray:Array;
		private var fireStrength:int;
		private var bmdScroll:BitmapDataScroll;
		
//		[Embed(source="../../../../../assets/fire-color.png")]
//		private var FireColor:Class;
		private var whiteColorTransform:ColorTransform;
		private var _paused:Boolean = false;
		private var fadeColorTransform:ColorTransform;
		private var blurFilter:BlurFilter;
		private var offset:Point = new Point();
		public function FireHori(doj:DisplayObject,w:int,h:int,fireStrength:int = 1,hideDoj:Boolean = true,offsetX:Number = 0,offsetY:Number = 0) {
//			this._fireColor = new FireColor().bitmapData;
			
			//QuickSetter.disableMouse(this);
			this._canvas = new Sprite();
			this._canvas.graphics.beginFill(0x0, 0);
			this._canvas.graphics.drawRect(0, 0, w, h);
			this._canvas.graphics.endFill();
			this._canvas.addChild(doj);
			offset.x = offsetX;
			offset.y = offsetY;
			this._grey = new BitmapData(w, h, false, 0x0);
//			this._spread = new ConvolutionFilter(3, 3, [0, 1, 0,  1, 1, 1,  0, 1, 0], 5);
			this._cooling = new BitmapData(w/2, h/2, false, 0x0);
			this._noise = _cooling.clone();
			this._noise.perlinNoise(100, 100, 4, 982374, true, false, 0, true);
			bmdScroll = new BitmapDataScroll(_noise);
			this._offset = [new Point(), new Point()];
			this._fire = new BitmapData(w, h, false, 0x0);
			var bm:Bitmap = new Bitmap(this._fire);
			bm.blendMode = "add";
			this.addChild(bm);
			QuickSetter.set(bm,{x:offsetX,y:offsetY});
			
			this._createCooling(1/2);
			this._createPalette(this._currentFireColor = 0);
			this.fireStrength = fireStrength;
			
			if(!hideDoj){
				addChild(_canvas);
			}
			Hori.enterFrame.add(render);
//			addChild(new Stats);
			whiteColorTransform = new ColorTransform(1,1,1,1,255,255,255);
			fadeColorTransform = new ColorTransform(1/2,1/2,1/2);
			blurFilter = new BlurFilter(fireStrength*2,fireStrength+1);
		}
		
		
		
		private function _createCooling(a:Number):void {
			this._color = new ColorMatrixFilter([
				a, 0, 0, 0, 0,
				0, a, 0, 0, 0,
				0, 0, a, 0, 0,
				0, 0, 0, 1, 0
			]);
		}
		
		private function _createPalette(idx:int):void {
//			this._palette = [];
//			this._zeroArray = [];
//			for (var i:int = 0; i < 256; i++) {
//				this._palette.push(this._fireColor.getPixel(i, idx * 32));
//				this._zeroArray.push(0);
//			}
			this._palette = [0,65536,131072,131328,262656,262400,328192,393984,459520,590592,590592,656384,722176,787712,853248,984320,1050112,1115904,1181440,1247232,1378304,1443840,1575168,1640704,1771776,1772288,1903360,1968896,2100224,2231296,2297088,2362624,2493952,2625024,2690816,2822144,2887680,3019008,3084544,3215872,3346944,3478272,3544064,3609600,3806464,3937792,4003072,4134656,4200192,4331520,4462592,4593920,4659712,4790784,4922112,5118976,5184512,5315840,5446912,5512704,5644032,5775104,5906432,6037760,6169088,6234624,6431488,6497280,6694144,6759680,6891008,7087616,7153408,7350016,7415808,7546880,7743744,7875072,7940864,8072192,8203520,8334592,8400384,8597248,8728576,8859648,8925440,9122304,9253376,9384704,9516032,9581824,9713152,9844224,9975552,10106880,10303744,10369280,10500608,10631680,10763264,10894592,11025664,11156736,11222784,11354112,11485184,11616512,11747584,11878912,12010496,12076032,12207360,12338688,12404224,12535552,12732416,12798208,12863744,13060864,13191936,13192192,13323520,13454848,13520384,13717504,13783040,13848832,13979904,14111232,14177024,14308352,14439680,14505216,14571008,14702336,14768128,14899456,14899712,15096320,15096832,15227904,15293696,15425024,15490816,15556352,15622144,15753472,15819264,15885056,15950592,16081920,16082176,16213248,16279040,16279552,16410624,16476416,16476416,16542208,16608256,16673792,16739328,16739840,16740352,16740864,16741632,16742144,16742656,16743168,16743936,16744448,16745216,16745728,16746496,16747264,16747520,16748288,16749056,16749568,16750336,16751104,16751872,16752640,16753152,16753920,16754688,16755456,16755968,16756736,16757248,16758016,16758784,16759552,16760064,16761088,16761856,16762368,16763136,16763904,16764672,16765440,16765952,16766976,16767744,16768256,16768768,16769536,16770048,16770816,16771584,16772096,16772352,16773120,16773632,16774144,16774656,16775168,16775424,16776192,16776448,16776704,16776961,16776966,16776971,16776977,16776984,16776991,16776998,16777005,16777015,16777023,16777032,16777040,16777050,16777060,16777070,16777080,16777090,16777099,16777109,16777118,16777128,16777137,16777147,16777155,16777164,16777172,16777180,16777187,16777194,16777201,16777205,16777211,16777215,16777215];
			this._zeroArray = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
//			trace(this._zeroArray);
		}
		
		public function render(n:int = 0):void {
			if(_paused){
				return;
			}
			this._grey.draw(this._canvas,new Matrix(1,0,0,1,-offset.x,-offset.y),whiteColorTransform);
//			this._grey.applyFilter(this._grey, this._grey.rect, ZERO_POINT, this._spread);
			bmdScroll.x += 1;
			bmdScroll.y += 1;
			this._cooling = bmdScroll.bitmapData;
//			this._cooling.applyFilter(this._cooling, this._cooling.rect, ZERO_POINT, this._color);
//			this._grey.draw(this._cooling, new Matrix(2,0,0,2), null, BlendMode.SUBTRACT);
			this._grey.draw(this._cooling, new Matrix(2,0,0,2), fadeColorTransform, BlendMode.SUBTRACT);
			this._grey.scroll(0, -fireStrength);
			this._grey.applyFilter(this._grey, this._grey.rect, ZERO_POINT, blurFilter);
			this._fire.paletteMap(this._grey, this._grey.rect, ZERO_POINT, this._palette, this._zeroArray, this._zeroArray, this._zeroArray);
		}


		public function get paused():Boolean
		{
			return _paused;
		}

		public function set paused(value:Boolean):void
		{
			_paused = value;
			if(_paused){
				Hori.enterFrame.remove(render);
			}else{
				Hori.enterFrame.add(render);
			}
		}

	}
}