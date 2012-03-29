package com.horidream.controller.musicplay
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * Copyright 2010. All rights reserved. 
	 *
	 * @author 	Horidream
	 * @since 	Jul 3, 2010 9:50:06 AM
	 */
	public class StopState implements IState
	{
		private var player:MiniMusicPlayer;
		private var _name:String = MiniMusicPlayer.STOP_STATE;
		private var sound:Sound;
		public function StopState(player:MiniMusicPlayer)
		{
			this.player = player;
		}
		
		

		public function get name():String
		{
			return _name;
		}

		public function load(url:String):void
		{
			player.sound = sound = new Sound();
//			sound.addEventListener(ProgressEvent.PROGRESS,onProgress);
//			sound.addEventListener(Event.COMPLETE,onComplete);
			sound.load(new URLRequest(url));
			player.setStateByName(MiniMusicPlayer.LOAD_STATE);
		}
//		private function onComplete(event:Event):void
//		{
//			player.setStateByName(MiniMusicPlayer.STOP_STATE);
//			if(player.autoPlay){
//				player.play();
//			}
//		}
//		
//		private function onProgress(event:ProgressEvent):void
//		{
//			trace("loading"+Math.round(event.bytesLoaded/event.bytesTotal*100)+"%");
//		}


		
		public function play():void
		{
			if(player.sound){
				player.soundChannel= player.sound.play(0,999);
				player.setStateByName(MiniMusicPlayer.PLAY_STATE);
				
			}
		}
		
		public function stop():void
		{
		}
	}
}