package com.horidream.interfaces
{
	public interface IController
	{
				function get paused():Boolean;

		function set paused(value:Boolean):void;

		function bind(vars:Object):void;

		function release():void;

	}
}