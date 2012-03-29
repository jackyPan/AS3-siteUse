package com.horidream.display
{
	import com.adobe.serialization.json.JSON;
	import com.horidream.vo.AnimeMomentoVO;
	
	import flash.display.DisplayObject;

	/**
	 * Copyright 2012 All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Jan 4, 2012
	 */
	public class AnimePlayer
	{
		private var playMomento:AnimeMomentoVO;
		private var currentMomento:AnimeMomentoVO;
		private var target:DisplayObject;
		public function AnimePlayer(rawData:String)
		{
			playMomento = AnimeMomentoVO.parse(JSON.decode(rawData));
		}
		public function play(target:DisplayObject):void
		{
			this.target = target;
			currentMomento = playMomento;
			Hori.enterFrame.add(loopPlay);
		}
		private function loopPlay():void
		{
			if(currentMomento)
			{
				currentMomento.reviseAnime(target);
				currentMomento = currentMomento.nxt;
			}else{
				Hori.enterFrame.remove(loopPlay);
			}
			
		}
	}
}