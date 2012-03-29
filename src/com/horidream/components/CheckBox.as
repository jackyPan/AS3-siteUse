package com.horidream.components
{
	import flash.display.*;
	import flash.events.*;
	
	import org.osflash.signals.*;
	
	public class CheckBox
	{
		public var changed:Signal;
		private var mc:MovieClip;
		private var _selected:Boolean = false;
		private var _initlized:Boolean = false;
		
		public function CheckBox(mc:MovieClip)
		{
			this.changed = new Signal();
			this.mc = mc;
			if (mc.stage)
			{
				this.onRegister();
			}
			else
			{
				mc.addEventListener(Event.ADDED_TO_STAGE, this.onRegister);
			}
			return;
		}// end function
		public function get view():MovieClip{
			return mc;
		}
		public function get selected() : Boolean
		{
			return this._selected;
		}// end function
		
		public function set selected(value:Boolean) : void
		{
			if (this._selected != value)
			{
				this._selected = value;
				if (this._selected)
				{
					this.mc.gotoAndStop(2);
				}
				else
				{
					this.mc.gotoAndStop(1);
				}
				this.changed.dispatch();
			}
			return;
		}// end function
		
		protected function init() : void
		{
			this.mc.gotoAndStop(selected?2:1);
			this.mc.buttonMode = true;
			return;
		}// end function
		
		protected function onRegister(event:Event = null) : void
		{
			this.mc.addEventListener(MouseEvent.CLICK, this.onClick);
			if (!this._initlized)
			{
				this.init();
				this._initlized = true;
			}
			if (event)
			{
				this.mc.removeEventListener(Event.ADDED_TO_STAGE, this.onRegister);
			}
			this.mc.addEventListener(Event.REMOVED_FROM_STAGE, this.onRemove);
			return;
		}// end function
		
		protected function onRemove(event:Event) : void
		{
			this.mc.removeEventListener(MouseEvent.CLICK, this.onClick);
			this.mc.addEventListener(Event.ADDED_TO_STAGE, this.onRegister);
			this.mc.removeEventListener(Event.REMOVED_FROM_STAGE, this.onRemove);
			return;
		}// end function
		
		private function onClick(event:MouseEvent) : void
		{
			this.selected = !this.selected;
			return;
		}// end function
		
	}
}
