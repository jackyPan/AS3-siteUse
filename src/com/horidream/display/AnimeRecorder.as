package com.horidream.display
{
	import com.adobe.serialization.json.JSON;
	import com.horidream.vo.AnimeMomentoVO;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.ByteArray;
	

	/**
	 * Copyright 2012 All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Jan 4, 2012
	 */
	public class AnimeRecorder
	{
		private var RecordMomentoVO:AnimeMomentoVO;
		private var currentMomento:AnimeMomentoVO;
		private var target:DisplayObject;
		
		public function AnimeRecorder(target:DisplayObject)
		{
			this.target = target;
			RecordMomentoVO = currentMomento = new AnimeMomentoVO(target);
			
		}
		public function start(timeLine:MovieClip):void
		{
			timeLine.addEventListener(Event.ENTER_FRAME,loop);
		}
		private function loop(e:Event):void
		{
			currentMomento.nxt = new AnimeMomentoVO(target);
			currentMomento = currentMomento.nxt;
			
		}
		public function stop(timeLine:MovieClip):void
		{
			timeLine.removeEventListener(Event.ENTER_FRAME,loop);
			var clipboard:Clipboard = Clipboard.generalClipboard;
			clipboard.setData(ClipboardFormats.TEXT_FORMAT,RecordMomentoVO.encode());
		}
		
	}
}