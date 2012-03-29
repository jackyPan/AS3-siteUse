package com.horidream.util
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.net.LocalConnection;
	import flash.text.TextField;
	
	/**
	 * Copyright 2010. All rights reserved. 
	 *
	 * @author 	Horidream
	 * @since 	Jun 30, 2010 5:47:04 PM
	 */
	public class HoriDebug
	{
		public static var logText:TextField;
		public static var paused:Boolean = false;
		private static var lastUpdataInPlace:Boolean;
		
		/**
		 * 
		 * @param msg
		 * @param updateInPlace
		 * @param w
		 * @param h
		 * @return 
		 * 
		 */
		public static function log(obj:Object,updateInPlace:Boolean = false,w:uint = 550,h:uint = 400):TextField {
			logText = logText || QuickSetter.set(new TextField(),{text:"<<Start Debug>>",width:w,height:h,selectable:true,wordWrap:true});
			if(paused){
				return logText;
			}
			var tempScrollV:int = logText.scrollV;
			if(updateInPlace){
				if(logText.text.substr(-1,1) == "\r"){
					logText.text = logText.text.substr(0,logText.text.lastIndexOf('\r',logText.text.length-2));
				}
				logText.appendText('\n' + obj.toString() +'\n');
			}else{
				logText.appendText((logText.text.substr(-1,1) == '\r'?'':'\n') + obj.toString());
			}
			if(updateInPlace && lastUpdataInPlace){
				logText.scrollV = tempScrollV;
			}else{
				logText.scrollV = logText.maxScrollV;
			}
			lastUpdataInPlace = updateInPlace;
			return logText;
		}
		public static function traceObject(o:Object,prefix:String = "obj"):void{
			if(o is XML || o is XMLList){
				log(o);
				trace(o);
				return;
			}
			var flag:Boolean = true;
			for(var i:String in o){
				traceObject(o[i],(prefix+"['"+i+"']"));
				flag = false;
			}
			if(flag){
				trace(prefix + "->"+o);
				log(prefix + "->"+o);
			}
		}
		public static function traceDisplayObjectContainer(container:DisplayObjectContainer,prefix:String = "container"):void{
			var num:int = container.numChildren;
			for (var i:int = 0; i < num; i++)
			{
				var child:DisplayObject = container.getChildAt(0);
				if(child is DisplayObjectContainer){
					
					traceDisplayObjectContainer(child as DisplayObjectContainer,"("+prefix+".getChildAt("+i+") as DisplayObjectContainer)");
					
				}else{
					log(prefix+".getChildAt("+i+") "+"->"+child);
				}
			}
		}
		
		public static function forceCG():void
		{
			try{
				new LocalConnection().connect("forceGCHori");
			}catch(e:Error)
			{
				try{
					new LocalConnection().connect("forceGCHori");
				}catch(e1:Error)
				{
					
				}
			}
		}
	}
}