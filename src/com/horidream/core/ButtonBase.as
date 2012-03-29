package com.horidream.core
{
	import art.horidream.sound.ClickMt;
	
	import com.horidream.events.EventBus;
	import com.horidream.util.QuickSetter;
	import com.horidream.util.RecUtil;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	public class ButtonBase extends MovieClip
	{
		protected var _pause:Boolean = false;
		protected var _selected:Boolean = false;
		public static var clickSound:Sound = new ClickMt;
		public static var mouseOverSound:Sound;
		public var clickSound:Sound;
		public var mouseOverSound:Sound;
		protected static var soundChannel:SoundChannel;
		public var view:MovieClip;
		public function ButtonBase(view:MovieClip)
		{
			this.view = view;
			if(view.parent && view.parent != this){
				var index:int = view.parent.getChildIndex(view);
				view.parent.addChildAt(this,index);
			}
			addChild(view);
			QuickSetter.disableMouse(view);
			init();
		}

		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
			if(_selected){
				this.pause = true;
				onMouseDown(null);
			}else{
				this.pause = false;
				onMouseOut(null);
				
			}
		}
		public function get pause():Boolean
		{
			return _pause;
		}

		public function set pause(value:Boolean):void
		{
			if(_pause == value){
				return;
			}
			_pause = value;
			if(_pause){
				this.buttonMode = false;
				destroy();
			}else{
				this.buttonMode = true;
				if(RecUtil.getVisibleBounds(view).contains(view.mouseX,view.mouseY))
				{
					onMouseOver(new MouseEvent(MouseEvent.ROLL_OVER));
				}
				addInteractive();
			}
		}

		protected function init(e:Event = null):void {
			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemovedFromStage);
			this.buttonMode = true;			
			addInteractive();
		}
		
		protected function addInteractive():void
		{
			
			EventBus.map(this,MouseEvent.ROLL_OUT,onMouseOut);
			EventBus.map(this,MouseEvent.ROLL_OVER,onMouseOver);
			EventBus.map(this,MouseEvent.MOUSE_DOWN,onMouseDown);
			EventBus.map(this,MouseEvent.MOUSE_UP,onMouseUp);
			

		}
		protected function destroy():void{
			onMouseOut(null);
			EventBus.unmap(this);
		}
		protected function onMouseOut(event:MouseEvent):void
		{
		}
		protected function onMouseOver(event:MouseEvent):void
		{
			if(event)
			{
				if(mouseOverSound){
					soundChannel = mouseOverSound.play();
				}
				else if(ButtonBase.mouseOverSound)
				{
					soundChannel = ButtonBase.mouseOverSound.play();
				}
			}
			
		}
		protected function onMouseDown(event:MouseEvent):void
		{
			if(event)
			{
				if(clickSound){
					soundChannel = clickSound.play();
				}
				else if(ButtonBase.clickSound)
				{
					soundChannel = ButtonBase.clickSound.play();
				}
			}
		}
		protected function onMouseUp(event:MouseEvent):void
		{
			setViewStatus();
		}

		private function setViewStatus():void
		{
			if(selected)
			{
				return;
			}
			if(view.getRect(view).contains(view.mouseX,view.mouseY))
			{
				onMouseOver(null);
			}else{
				onMouseOut(null);
			}
		}


		private function onRemovedFromStage(event:Event):void
		{
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE,onRemovedFromStage);
			destroy();
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemovedFromStage);
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			if(!pause){
				setViewStatus();
				addInteractive();
			}
		}
		
	}
}