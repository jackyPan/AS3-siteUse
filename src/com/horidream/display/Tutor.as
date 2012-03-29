package com.horidream.display
{
	import com.horidream.util.QuickSetter;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * Copyright 2012. All rights reserved. 
	 *
	 * @author 	Horidream
	 * @since 	Jan 2, 2012 8:41:31 PM
	 */
	public class Tutor
	{
		private var teacher:MovieClip;
		private var teacherName:String;
		private var teachTag:String
		private var apprentice:DisplayObject;
		public function Tutor(teacher:MovieClip,teacherName:String,teachTag:String = "transform.matrix")
		{
			this.teacher = teacher;
			this.teacherName = teacherName;
			this.teachTag = teachTag;
			
		}
		public function play(apprentice:DisplayObject,frame:Object):void
		{
			this.apprentice = apprentice;
			Hori.enterFrame.add(loop);
			teacher.addEventListener(Event.COMPLETE,onComplete);
			teacher.gotoAndPlay(frame);
		}

		private function onComplete(e:Event):void
		{
			loop();
			Hori.enterFrame.remove(loop);
		}
		
		private function loop():void
		{
			QuickSetter.cloneProperty(apprentice,teacher[teacherName],teachTag);
		}
	}
}