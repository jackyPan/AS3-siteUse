package com.horidream.effects
{
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.horidream.display.HoriText;
	import com.horidream.util.Cast;
	import com.horidream.util.QuickSetter;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	/**
	 * Copyright 2010. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Dec 22, 2010
	 */
	public class TextTween extends EventDispatcher
	{
		public static var sampleString:String;
		private var textField:TextField;
		private var textString:String;
		private var vars:Object;
		private var textCanvasArr:Array = [];
		private var textArr:Array = [];
		private var currentCount:int = -1;
		private var canvas:Sprite;
		private var _finished:Boolean = false;
		private var _timeScale:Number = 1;
		
		private var timeline:TimelineMax = new TimelineMax({paused:true,onComplete:onCompleteHandler});
		
		
		
		
		public function TextTween(textField:TextField,time:Number = .2,vars:Object = null,offset:Number = .1,changeWord:Boolean = true)
		{
			this.textField = textField;
			this.textString = textField.text;
			sampleString = sampleString || textString;
			canvas = new Sprite();
			canvas.mouseChildren = canvas.mouseEnabled = false;
			canvas.blendMode = "layer";
			var defaultVar:Object = {visible:false};
			this.vars = vars || defaultVar;
			for(var i:int = 0;i<textField.length;i++){
				//使用try是防止在Flash IDE下使用了auto kern选项而造成空对象错误
				try{
					var textCanvas:Sprite = new Sprite();
					textCanvas.mouseChildren = textCanvas.mouseEnabled = false;
					var text:TextField = HoriText.getTextFieldAt(textField,i);
					textCanvas.addChild(text);
					var rec:Rectangle = text.getCharBoundaries(0);
					textCanvas.x = text.x + rec.width/2;
					textCanvas.y = text.y + rec.height/2;
					text.x = -rec.width/2
					text.y = -rec.height/2;
					textArr[i] = text;
					textCanvasArr[i] = textCanvas;
					canvas.addChild(textCanvas);
					var tempVars:Object = new Object();
					for(var key:String in this.vars){
						tempVars[key] = this.vars[key];
					}
					if(changeWord){
						tempVars.onUpdate = onChangWord;
						tempVars.onComplete = onChangeWordComplete;
						tempVars.onUpdateParams = [i];
						tempVars.onCompleteParams = [i];
					}
					timeline.insert(TweenMax.from(textCanvasArr[i],time,tempVars),offset*i);
				}catch(e:Error){}
			}
		
			QuickSetter.swapDisplayObject(canvas,textField);
		}
		
		public function get viewport():Sprite
		{
			return canvas;
		}
		public function get timeScale():Number
		{
			return _timeScale;
		}

		public function set timeScale(value:Number):void
		{
			_timeScale = value;
			timeline.timeScale = _timeScale;
		}

		public static function show(textField:TextField,time:Number = .2,vars:* = null,offset:Number = .1,changeWord:Boolean = true):TextTween
		{
			var tt:TextTween = new TextTween(textField,time,vars,offset,changeWord);
			tt.play();
			return tt;
		}
		public function get finished():Boolean{
			
			return _finished;
		}
		public function get reversed():Boolean{
			
			return timeline.reversed;
		}
		public function get paused():Boolean{
			
			return timeline.paused;
		}
		public function play():void
		{
//			if(!canvas.parent){
//				QuickSetter.swapDisplayObject(canvas,textField);
//			}
			timeline.play();
		}
		public function gotoAndPlay(timeOrLabel:*):void
		{
			timeline.gotoAndPlay(timeOrLabel);
		}
		public function gotoAndStop(timeOrLabel:*):void
		{
			timeline.gotoAndStop(timeOrLabel);
		}
		public function pause():void
		{
//			if(!canvas.parent){
//				QuickSetter.swapDisplayObject(canvas,textField);
//			}
			timeline.pause();
		}
		public function resume():void
		{
//			if(!canvas.parent){
//				QuickSetter.swapDisplayObject(canvas,textField);
//			}
			timeline.resume();
		}
		public function reverse():void
		{
//			if(!canvas.parent){
//				QuickSetter.swapDisplayObject(canvas,textField);
//			}
			_finished = false;
			timeline.reverse();
		}
		private function onCompleteHandler():void
		{
//			QuickSetter.swapDisplayObject(canvas,textField);
			_finished = true;
			dispatchEvent(new Event(Event.COMPLETE));
			
		}
		private function onChangWord(index:int):void
		{
			textArr[index].text = TextTween.sampleString.charAt(Math.random()*TextTween.sampleString.length);
		}
		private function onChangeWordComplete(index:int):void
		{
			textArr[index].text = textString.charAt(index);
		}
	}
}