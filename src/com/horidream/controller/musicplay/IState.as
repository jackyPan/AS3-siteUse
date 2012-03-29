package com.horidream.controller.musicplay
{
	public interface IState
	{
		function load(url:String):void;
		function get name():String;
			
		function play():void;
		function stop():void;
	}
}