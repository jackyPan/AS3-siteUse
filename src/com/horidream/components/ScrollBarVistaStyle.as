package com.horidream.components
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	/**
	 * Copyright 2010. All rights reserved. 
	 *
	 * @author 	Horidream
	 * @since 	Jun 28, 2010 4:55:05 PM
	 */
	public class ScrollBarVistaStyle extends MovieClip
	{
		
		private var upbt:MovieClip;
		private var downbt:MovieClip;
		private var track:MovieClip;
		private var dragger:MovieClip;
		
		private var _numPerPage:Number;
		//每次修正value的值
		private var _num:Number = 0;
		
		private const BUTTON_HEIGHT:Number = 17;
		private var _height:Number;
		private var _width:Number = 17;
		private var _value:Number;
		private var _minimum:Number;
		private var _maximum:Number;
		private var _tick:Number;
		private var timer:Timer;
		
		public function ScrollBarVistaStyle()
		{
			init();
			if(stage){
				active();
			}else{
				addEventListener(Event.ADDED_TO_STAGE,active);
			}
			
			
		}
		
		


		public function get numPerPage():Number
		{
			if(_numPerPage>(_maximum-_minimum)){
				return (_maximum-_minimum);
			}else{
				return _numPerPage;
			}
			return _numPerPage;
		}
		
		public function set numPerPage(value:Number):void
		{
			
			_numPerPage = value;
			refreshLayout();
		}
		
		private function init():void
		{
			this._height = 100;
			this._maximum = 100;
			this._minimum = 0;
			this._value = 0;
			this._tick = .1;
			this._numPerPage = 20;
			this.scrollRect = new Rectangle(1,0,15,100);
			upbt = new UpButton();
			downbt = new DownButton();
			track = new Track();
//			track.x = 3;
			dragger = new Dragger();
			dragger.height = 0;
			dragger.y = upbt.height;
			addChild(track);
			addChild(upbt);
			addChild(downbt);
			addChild(dragger);
			
			timer = new Timer(100);
			timer.addEventListener(TimerEvent.TIMER,onTimer);
			upbt.active = false;
			downbt.active = false;
		}
		private function active(e:Event = null):void{
			this.addEventListener(MouseEvent.ROLL_OVER,onRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT,onRollOut);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			track.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			refreshLayout();
		}
		
		private function onMouseOut(event:MouseEvent):void
		{
			timer.stop();
		}
		
		private function onRollOut(event:MouseEvent):void
		{
			upbt.active = false;
			downbt.active = false;
		}
		
		private function onRollOver(event:MouseEvent):void
		{
			upbt.active = true;
			downbt.active = true;
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			_value = (dragger.y-upbt.height)/(height-dragger.height-upbt.height-downbt.height)*(_maximum-_minimum)+_minimum;
			dragger.stopDrag();
			dragger.isDragging = false;
			timer.stop();
			try{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			}catch(e:Error){}
		}
		
		
		private function onMouseDown(event:MouseEvent):void
		{
			
			if(event.target == dragger){
				dragger.startDrag(false,new Rectangle(0,upbt.height,0,height-upbt.height-downbt.height-dragger.height));
				dragger.isDragging = true;
				stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			}else if(event.target == upbt){
				repeatDoValue(-numPerPage/10);
			}else if(event.target == downbt){
				repeatDoValue(+numPerPage/10);
			}else if(event.target == track){
				if(mouseY>dragger.y){
					repeatDoValue(numPerPage);
				}else{
					repeatDoValue(-numPerPage);
				}
			}
		}
		private function repeatDoValue(num:Number):void{
			timer.reset();
			timer.start();
			_num = num;
			value += num;
		}
		private function onTimer(event:TimerEvent):void
		{
			if(timer.currentCount == 1){
				return;
			}
			value += _num;
		}
		
		private function onMouseMove(event:MouseEvent):void
		{
			if(dragger.isDragging ){
				if((height-dragger.height-upbt.height-downbt.height) == 0){
					value = 0;
				}else{
					value = (dragger.y-upbt.height)/(height-dragger.height-upbt.height-downbt.height)*(_maximum-_minimum)+_minimum;
				}
			}
		}
		
		
		private function refreshLayout():void {
			upbt.y = 0;
			downbt.y = _height-17;
			track.height = this._height;
			dragger.height = numPerPage/(_maximum-_minimum)*(height-upbt.height-downbt.height);
			if(!dragger.isDragging){
				if((height-dragger.height-upbt.height-downbt.height) == 0){
					dragger.y = upbt.height;
				}else{
					dragger.y = (_value-_minimum)/(_maximum-_minimum)*(height-dragger.height-upbt.height-downbt.height)+upbt.height;
			
				}
			}
		}
		
		public override function get height():Number
		{
			return _height;
		}
		
		public override function set height(value:Number):void
		{
			_height = value;
			refreshLayout();
			this.scrollRect = new Rectangle(1,0,15,_height);
		}
		
		
		public function get value():Number
		{
//			return Math.round(_value/_tick)*_tick;
			return _value;
		}
		
		public function set value(v:Number):void
		{
			if(isNaN(v)){
				return;
			}
			if(_value != v){
				_value = Math.round(v/_tick)*_tick;
				if(_value<=_minimum){
					_value = _minimum;
				}else if(_value >= _maximum){
					_value = _maximum;
				}
				refreshLayout();
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		public function get minimum():Number
		{
			return _minimum;
		}
		
		public function set minimum(value:Number):void
		{
			_minimum = value;
			refreshLayout();
		}
		
		public function get maximum():Number
		{
			return _maximum;
		}
		
		public function set maximum(value:Number):void
		{
			_maximum = value;
			refreshLayout();
		}
		
		public function get tick():Number
		{
			return _tick;
		}
		
		public function set tick(value:Number):void
		{
			_tick = value;
		}

		public override function get width():Number
		{
			return 15;
		}

		public override function set width(value:Number):void
		{
			/**TRACEDISABLE:trace("无法为滚动条设置宽度，width参数不可写");*/
		}

		
	}
}
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;

class Dragger extends MovieClip{
	private var dragger:MovieClip;
	private var _dragging:Boolean = false;
	private var grip:MovieClip;
	private var bot:MovieClip;
	private var mid:MovieClip;
	private var top:MovieClip;
	private var minHeight:Number = 22;
	public function Dragger()
	{
		this.mouseChildren = false;
		dragger = new DraggerSprite();
		addChild(dragger);
		top = (dragger.top as MovieClip);
		mid = (dragger.mid as MovieClip);
		bot = (dragger.bot as MovieClip);
		grip = (dragger.grip as MovieClip);
		if(stage){
			active();
		}else{
			addEventListener(Event.ADDED_TO_STAGE,active);
		}
		
	}
	private function active(e:Event = null):void {
		this.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
		this.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
		
	}
	
	
	public function set isDragging(value:Boolean):void
	{
		_dragging = value;
		if(value){
			top.gotoAndStop("_down");
			mid.gotoAndStop("_down");
			bot.gotoAndStop("_down");
			grip.gotoAndStop("_down");
		}else{
			top.gotoAndStop("_up");
			mid.gotoAndStop("_up");
			bot.gotoAndStop("_up");
			grip.gotoAndStop("_up");
		}
		
	}
	public function get isDragging():Boolean{
		return _dragging;
	}
	
	private function onMouseOut(event:MouseEvent):void
	{
		if(!isDragging){
			top.gotoAndStop("_up");
			mid.gotoAndStop("_up");
			bot.gotoAndStop("_up");
			grip.gotoAndStop("_up");
		}
	}
	
	
	private function onMouseOver(event:MouseEvent):void
	{
		if(!isDragging){
			top.gotoAndStop("_over");
			mid.gotoAndStop("_over");
			bot.gotoAndStop("_over");
			grip.gotoAndStop("_over");
		}
	}
	
	
	public override function get height():Number
	{
		return top.height+mid.height+bot.height-2;
	}
	
	public override function set height(value:Number):void
	{
		var v:Number = value+2;
		if(value<minHeight){
			v = minHeight;
		}
		top.y = 0;
		mid.height = v-top.height-bot.height;
		grip.y = (v-grip.height)/2;
		bot.y = v-bot.height;
		
	}
	
}

class ScrollButton extends MovieClip{
	private var _active:Boolean;
	public var view:MovieClip;
	public function ScrollButton()
	{
		this.mouseChildren = false;
		addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
		addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
	}

		private function onMouseOut(event:MouseEvent):void
		{
			view.gotoAndStop("_up");
		}
	
	private function onMouseUp(event:MouseEvent):void
	{
		view.gotoAndStop("_over");
	}
	
	private function onMouseOver(event:MouseEvent):void
	{
		view.gotoAndStop("_over");
	}
	
	private function onMouseDown(event:MouseEvent):void
	{
		view.gotoAndStop("_down");
	}
	
	
	public function get active():Boolean
	{
		return _active;
	}
	
	public function set active(value:Boolean):void
	{
		_active = value;
		if(_active){
			view.gotoAndStop("_up");
		}else{
			view.gotoAndStop("_up");
		}
		
	}
}
class UpButton extends ScrollButton{
	public function UpButton(){
		this.view = new UpButtonMC();
		addChild(view);
	}
}
class DownButton extends ScrollButton{
	public function DownButton(){
		this.view = new DownButtonMC();
		addChild(view);
	}
}
