package com.horidream.display
{
	import com.greensock.TweenMax;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;
	import com.horidream.interfaces.IProgressBar;
	import com.horidream.util.QuickSetter;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	
	import mx.states.AddChild;

	/**
	 * Copyright 2010. All rights reserved. 
	 *
	 * @author 	Horidream
	 * @since 	Aug 31, 2010 1:57:17 PM
	 */
	public class ShowManager
	{
		public static const SWF_NAME:String 	= "attachSWF@Hori";
		public static const IMG_NAME:String 	= "attachImage@Hori";
		
		public static const STRETCH:int 		= 0;
		public static const INSIDE:int 			= 1;
		public static const OUTSIDE:int 		= 2;
		public static const WIDTH_ONLY:int		= 3;
		public static const HEIGHT_ONLY:int 	= 4;
		public static const NONE:int 			= 5;
		
		public static const ScaleMode:Array = ["stretch","proportionalInside","proportionalOutside","widthOnly","heightOnly","none"];
		public static var defaultShowInVars:Object = {alpha:0};
		public static var defaultShowOutVars:Object = {alpha:0};
		public static function showIn(target:DisplayObject,container:DisplayObjectContainer = null,duration:Number = 1,startVars:Object = null,endVars:Object = null):void
		{
			startVars = startVars || defaultShowInVars;
			if(!endVars){
				endVars = {};
			}
			for (var tag:String in startVars)
			{
				if(target.hasOwnProperty(tag))
				endVars[tag] = endVars[tag] || target[tag];
			}
			if(container && (target.parent != container)){
				
				container.addChild(target);
			}
			QuickSetter.set(target,endVars);
			TweenMax.killTweensOf(target);
			TweenMax.from(target,duration,startVars);
		}

		public static function showOut(target:DisplayObject,duration:Number = 1,endVars:Object = null):void
		{
			var vars:Object = endVars || defaultShowOutVars;
			var intVars:Object = new Object;
			for each(var tag:String in endVars)
			{
				if(target.hasOwnProperty(tag))
				{
					intVars[tag] = target[tag];
				}
			}
			vars['onComplete'] = afterShowOut;
			vars['onCompleteParams'] = [target,intVars];
			TweenMax.killTweensOf(target);
			TweenMax.to(target,duration,vars);
		}
		private static function afterShowOut(target:DisplayObject,vars:Object):void
		{
			QuickSetter.removeSelf(target);
			QuickSetter.set(target,vars);
		}
		public static function attachImage(target:DisplayObjectContainer,url:String,scaleType:int = 2,boaderThickness:Number = 0,rec:Rectangle = null,progressBar:IProgressBar = null,showBorder:Boolean = false):Sprite
		{
			QuickSetter.removeSelf(target.getChildByName("attachImage@Hori"));	
			rec = rec || target.getBounds(target);
			if(boaderThickness>0)
			{
				rec.x = rec.x + boaderThickness;
				rec.y = rec.y + boaderThickness;
				rec.width = rec.width - boaderThickness*2;
				rec.height = rec.height - boaderThickness*2;
				
			}
			
			
			var progress:DisplayObject;
			var imageLoader:ImageLoader;
			if(progressBar){
				progress = progressBar as DisplayObject;
				
			}
			
			
			if(progress){
				imageLoader = new ImageLoader(url,{width:rec.width,height:rec.height,x:rec.x,y:rec.y,container:target,scaleMode:ScaleMode[scaleType],crop:scaleType == 5?false:true,onProgress:onProgressHandler,onComplete:onCompleteHander});
				target.addChild(progress);
				QuickSetter.autoAlign(progress,target,5,null,rec);
			}else{
				imageLoader = new ImageLoader(url,{width:rec.width,height:rec.height,x:rec.x,y:rec.y,container:target,scaleMode:ScaleMode[scaleType],crop:scaleType == 5?false:true,onComplete:onCompleteHander});
			}
			imageLoader.load();
			if(showBorder)
				imageLoader.content.filters = [new GlowFilter(0,1,2,2,2,1,true)];
			
			LoaderMax.prioritize(url);
			imageLoader.content.name = "attachImage@Hori";
			return imageLoader.content as Sprite;
			
			function onProgressHandler(e:LoaderEvent):void
			{
				IProgressBar(progress).showProgress(int(imageLoader.progress*100));
			}
			function onCompleteHander(e:LoaderEvent):void
			{
				if(progress)
					ShowManager.showOut(progress);
				EventDispatcher(imageLoader.content).dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		public static function attachSWF(target:DisplayObjectContainer,url:String,scaleType:int = 2,boaderThickness:Number = 0,rec:Rectangle = null,progressBar:IProgressBar = null,showBorder:Boolean = false):Sprite
		{
			QuickSetter.removeSelf(target.getChildByName("attachSWF@Hori"));	
			rec = rec || target.getBounds(target);
			if(boaderThickness>0)
			{
				rec.x = rec.x + boaderThickness;
				rec.y = rec.y + boaderThickness;
				rec.width = rec.width - boaderThickness*2;
				rec.height = rec.height - boaderThickness*2;
				
			}
			
			
			var progress:DisplayObject;
			var swfLoader:SWFLoader;
			if(progressBar){
				progress = progressBar as DisplayObject;
				
			}
			
			
			if(progress){
				swfLoader = new SWFLoader(url,{width:rec.width,height:rec.height,x:rec.x,y:rec.y,container:target,scaleMode:ScaleMode[scaleType],crop:true,onProgress:onProgressHandler,onComplete:onCompleteHander});
				target.addChild(progress);
				QuickSetter.autoAlign(progress,target,5,null,rec);
			}else{
				swfLoader = new SWFLoader(url,{width:rec.width,height:rec.height,x:rec.x,y:rec.y,container:target,scaleMode:ScaleMode[scaleType],crop:true});
			}
			swfLoader.load();
			if(showBorder)
				swfLoader.content.filters = [new GlowFilter(0,1,2,2,2,1,true)];
			
			LoaderMax.prioritize(url);
			swfLoader.content.name = "attachSWF@Hori";
			return swfLoader.content as Sprite;
			
			function onProgressHandler(e:LoaderEvent):void
			{
				IProgressBar(progress).showProgress(int(swfLoader.progress*100));
			}
			function onCompleteHander(e:LoaderEvent):void
			{
				ShowManager.showOut(progress);
			}
		}
	}
}
