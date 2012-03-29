package com.horidream.controller.musicplay
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;

	/**
	 * Copyright 2010. All rights reserved. 
	 *
	 * @author 	Horidream
	 * @since 	Jul 3, 2010 9:49:48 AM
	 */
	public class LoadState implements IState
	{
		private var player:MiniMusicPlayer;
		private var _name:String = MiniMusicPlayer.LOAD_STATE;
		private var sound:Sound;
		public function LoadState(player:MiniMusicPlayer)
		{
			this.player = player;
		}
		
		

		public function get name():String
		{
			return _name;
		}

		public function load(url:String):void
		{
			if(player.sound){
				player.sound.close();
				if(player.sound.url){
					var len:int = player.sound.url.length;
					var currentFileName:String = (player.sound.url.substring(len - url.length));
					if(url == currentFileName){
						/**TRACEDISABLE:trace("已经载入");*/
						return;
					}
				}
			}
			
//			if(player.soundChannel) player.soundChannel.stop();
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
		}
		
		public function stop():void
		{
		}
	}
}