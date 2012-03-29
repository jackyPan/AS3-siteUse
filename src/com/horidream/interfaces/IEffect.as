package com.horidream.interfaces
{
	import flash.display.DisplayObject;

	public interface IEffect
	{
		function start():void;
		function stop():void;
		function destroy():void;
		function get playing():Boolean;
		function set source(src:DisplayObject):void;
		function get source():DisplayObject;
	}
}