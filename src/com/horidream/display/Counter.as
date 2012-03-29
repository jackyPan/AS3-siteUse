package com.horidream.display
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	
	/**
	 * Copyright 2010. All rights reserved. 
	 *
	 * @author 	Horidream
	 * @since 	Jul 13, 2010 11:47:24 AM
	 */
	public class Counter extends MovieClip
	{
		private var textField:TextField;
		private var motionBlur:uint;
		private var sourceBmd:BitmapData;
		private var numberWidth:Number=43;
		private var numberHeight:Number=95;
		private var bmSpace:Number=46;
		private var numberBmdArr:Array=[];
		private var preSetStr:String = '0';
		private var bmSetArr:Array=[];
		private var len:uint;
		private var countSpace:int;
		private var o:Object;
		private var timer:Timer;
		private var tween:TweenMax;
		private var targetNum:int;
		private var originalSpace:int;
		public function Counter(textField:TextField,motionBlur:uint = 0)
		{
			this.textField = textField;
			this.motionBlur = motionBlur;
			this.x = textField.x;
			this.y = textField.y;
			len = textField.text.length;
			if(textField.parent){
				textField.parent.addChild(this);
				textField.parent.removeChild(textField);
			}
			setup();
		}
		private function setup():void {
			var t:TextField = new TextField();
			t.autoSize = TextFieldAutoSize.LEFT;
			t.selectable=false;
			t.text="0123456789";
			var format:TextFormat = textField.getTextFormat(0);
			originalSpace = format.letterSpacing as Number;
			format.letterSpacing = 20;
			t.setTextFormat(format);
//			if(textField.embedFonts)	t.embedFonts=textField.embedFonts;
			sourceBmd = new BitmapData(t.width,t.height,true,0x00FFFFFF);
			sourceBmd.draw(t,null,null,null,null,true);
			numberHeight = t.height;
			numberWidth = t.width/10;
			bmSpace = numberWidth-(20-originalSpace);
			for (var i:int = 0; i<10; i++) {
				var bmd:BitmapData=new BitmapData(numberWidth,numberHeight,true,0x00FFFFFF);
//				if(textField.embedFonts){
					bmd.copyPixels(sourceBmd,t.getCharBoundaries(i),new Point());
//				}else{
//					bmd.copyPixels(sourceBmd,new Rectangle(numberWidth*i,0,numberWidth,numberHeight),new Point());
//				}
				numberBmdArr.push(bmd);
			}
			for (i = 0; i<len; i++) {
				var bm:Bitmap = new Bitmap();
//				bm.smoothing = true;
				bm.x=i*bmSpace;
				this.addChild(bm);
				bmSetArr.push(bm);
			}
//			addChild(new Bitmap(numberBmdArr[2]));
		}
		public function show(num:int):void {
			var str:String=numToStr(num,len);
			for (var i:int = 0; i<len; i++) {
				bmSetArr[i].bitmapData=numberBmdArr[int(str.substr(i,1))];
			}
			preSetStr=str;
		}
		public function moveTo(num:int,time:Number = .1):void {
			
			var str:String=numToStr(num,len);
			var flag:Boolean = false;
			for (var i:int = 0; i<len; i++) {
				var bmd:BitmapData=bmSetArr[i].bitmapData.clone();
				o = {y:0};
				if (preSetStr.charAt(i)==str.charAt(i)) {
//					TweenMax.to(o,0,{y:numberHeight,ease:Linear.easeNone,onUpdate:updateBmd,onUpdateParams:[bmd,str,bmSetArr[i],o,i,false]});
					continue;
				}
				
				
				if(countSpace && (countSpace.toString()).length>(len-i-2)){
					
					TweenMax.to(o,time,{y:numberHeight,ease:Linear.easeNone,onUpdate:updateBmd,onUpdateParams:[bmd,str,bmSetArr[i],o,i]});
				}else{
					
					TweenMax.to(o,time,{y:numberHeight,ease:Linear.easeNone,onUpdate:updateBmd,onUpdateParams:[bmd,str,bmSetArr[i],o,i,false]});
				}
				
			}
			preSetStr=str;
		}
		public function autoCount(fromNum:int,toNum:int,timeLength:Number = 1):void{
			var delay:Number = 40;
			targetNum = toNum;
			countSpace = (toNum-fromNum)/(timeLength*1000/delay);
			show(fromNum);
			timer = new Timer(delay,timeLength*1000/delay);
			timer.addEventListener(TimerEvent.TIMER,count);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,onComplete);
			timer.start();
		}

		private function onComplete(event:TimerEvent):void
		{
			timer.removeEventListener(TimerEvent.TIMER,count);
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE,onComplete);
			TweenMax.delayedCall(.15,show,[targetNum]);
		}
		private function numToStr(num:int,len:int):String {
			var str:String=num.toString();
			while (str.length>len) {
				str=str.slice(1);
			}
			while (str.length<len) {
				str="0"+str;
			}
			return str;
		}
		private function updateBmd(_bmd:BitmapData,_str:String,bm:Bitmap,o:*,j:int,blur:Boolean = true):void {
			var index:int=bmSetArr.indexOf(bm);
			
			var tempBmd:BitmapData=_bmd.clone();
			tempBmd.lock();
			tempBmd.copyPixels(_bmd,new Rectangle(0,0,numberWidth,numberHeight-o.y),new Point(0,o.y));
			tempBmd.copyPixels(numberBmdArr[int(_str.substr(j,1))],new Rectangle(0,numberHeight-o.y,numberWidth,o.y),new Point(0,0));
			if(motionBlur!=0 && blur){
				tempBmd.applyFilter(tempBmd,tempBmd.rect,new Point(0,0),new BlurFilter(0,(index*motionBlur)));//o.y == numberHeight? 0:40
			}
			tempBmd.unlock();
			bm.bitmapData=tempBmd;
			bm.smoothing = false;
		}
		private function count(e:TimerEvent):void {
			moveTo(int(preSetStr)+countSpace);
			
		}
		
		
	}
}