package com.horidream.util
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.net.sendToURL;
	import flash.utils.getTimer;

	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	Horidream
	 * @since 	May 20, 2011 10:39:16 PM
	 */
	public class WebService
	{
		public static function call(url:String,callBack:Function,data:Object = null,isPost:Boolean = false,refresh:Boolean = false):URLLoader
		{
			var urlRequest:URLRequest;
			if(isPost){
				urlRequest = new URLRequest(url);
				var variable:URLVariables = new URLVariables();
				QuickSetter.set(variable,data);
				urlRequest.method = URLRequestMethod.POST;
				urlRequest.data = variable;
				
			}else{
				var str:String = "";
				if(data){
					for(var tag:String in data)
					{
						str += (tag+"="+data[tag]+"&")
					}
				}
				
				if(refresh){
					var randomSeed:int = (new Date()).getMilliseconds();
					str+= ("randomhori="+randomSeed+int(Math.random()*1000)+"&");
				}
				if(str.length>0){
					if(url.indexOf("?")>-1){
						url = (url+str);
					}else{
						url = (url+"?"+str);
					}
					url = url.substr(0,url.length-1);
				}
				urlRequest = new URLRequest(url);
				urlRequest.method = URLRequestMethod.GET;
			}
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE,onComplete);
			loader.load(urlRequest);
			function onComplete(e:Event):void
			{
				callBack.apply(null,[e.currentTarget.data]);
			}
			
			
			return loader;
		}
		public static function navi(url:String,window:String = null):void
		{
			navigateToURL(new URLRequest(url),window);
		}
		public static function send(url:String):void
		{
			sendToURL(new URLRequest(url));
		}
	}
}