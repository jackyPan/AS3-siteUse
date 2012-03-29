package com.horidream.controller.musicplay
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLLoader;

	/**
	 * Copyright 2010. All rights reserved. 
	 *
	 * @author 	Horidream
	 * @since 	Jul 3, 2010 9:49:07 AM
	 */
	public class MiniMusicPlayer extends EventDispatcher implements IState
	{
		public static const PLAY_STATE:String = "play";
		public static const STOP_STATE:String = "stop";
		public static const LOAD_STATE:String = "load";
		private var playState:IState;
		private var stopState:IState;
		private var loadState:IState;
		private var state:IState;
		public var autoPlay:Boolean;
		private var _sound:Sound;
		public var soundChannel:SoundChannel;
		private var stateArr:Array;
		public function MiniMusicPlayer(autoPlay:Boolean = true)
		{
			playState = new PlayState(this);
			stopState = new StopState(this);
			loadState = new LoadState(this);
			stateArr = [playState,stopState,loadState];
			state = stopState;
			this.autoPlay = autoPlay;
		}
		



		public function get sound():Sound
		{
			return _sound;
		}

		public function set sound(value:Sound):void
		{
			if(_sound){
				if(_sound.hasEventListener(ProgressEvent.PROGRESS))	_sound.removeEventListener(ProgressEvent.PROGRESS,onProgress);
				if(_sound.hasEventListener(Event.COMPLETE))	_sound.removeEventListener(Event.COMPLETE,onComplete);
			}
			_sound = value;
			sound.addEventListener(ProgressEvent.PROGRESS,onProgress);
			sound.addEventListener(Event.COMPLETE,onComplete);
			
		}
		

		public function get name():String
		{
			return "player instance";
		}

		public function getStateName():String
		{
			return state.name;
		}

		public function setStateByName(stateName:String):void
		{
			for each(var item:* in stateArr){
				if(item.name == stateName){
					state = item;
					//_log(item.name);
					return;
				}
			}
		}

		public function load(url:String):void
		{
			state.load(url);
		}
		
		public function play():void
		{
			state.play();
		}
		
		public function stop():void
		{
			state.stop();
		}
		private function onComplete(event:Event):void
		{
			dispatchEvent(new Event(Event.COMPLETE));
			setStateByName(MiniMusicPlayer.STOP_STATE);
			if(autoPlay){
				play();
			}
		}
		
		private function onProgress(event:ProgressEvent):void
		{
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS));
		}
	}
}