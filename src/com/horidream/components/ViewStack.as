package com.horidream.components
{
	/**
	 * Copyright 2011. All rights reserved. 
	 *
	 * @author 	horidream
	 * @since 	Feb 24, 2011
	 */
	import com.greensock.TweenMax;
	import com.horidream.display.decorators.ShowViewMovieClip;
	import com.horidream.interfaces.IShowView;
	import com.horidream.util.QuickSetter;
	import com.horidream.util.RecUtil;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	
	public class ViewStack extends Sprite
	{
		private var viewsArr:Array = [];
		private var currentViewIndex:int = -1;
		private var container:DisplayObjectContainer;
		private var CW:Number;
		private var CH:Number;
		public var autoFit:int;
		public var fitRatio:Number = .95;
		private var containerRec:Rectangle;
		private var viewRec:Rectangle;
		private var rec:Rectangle;
		public function ViewStack(container:DisplayObjectContainer = null, rec:Rectangle = null, autoFit:int = 5)
		{
			this.container = container || this;	
			this.autoFit = autoFit;
			this.rec = rec;
			if(!(container || rec)){
				return;
			}
			if(rec){
				CW = rec.width;
				CH = rec.height;
				this.container.scrollRect = rec;
			}else{
				CW = container.width;
				CH = container.height;
				var tempRec:Rectangle = this.container.getRect(this.container);
				tempRec.x = tempRec.y = 0;
				this.container.scrollRect = tempRec;
				
			}
		}
		public function get viewNum():int
		{
			return viewsArr.length;
		}
		public function showAt(index:int):void{
			if((index>-1) && (index<viewsArr.length) && (currentViewIndex!=index)){
				if(currentView){
					if(currentView is IShowView){
						(currentView as IShowView).showOut()
					}else{
						QuickSetter.removeSelf(currentView);
					}
				}
				containerRec = RecUtil.localToGlobal(container.getRect(container),container);
				currentViewIndex = index;
				render();
			}
		}

		public function render():void
		{
			
			var view:DisplayObject = viewsArr[currentViewIndex]
			container.addChild(view);
			viewRec = RecUtil.localToGlobal(view.getRect(view),view);
			TweenMax.killTweensOf(view);
			if(autoFit){
				if((viewRec.width>container.width) || (viewRec.height>containerRec.height)){
					var scale:Number = Math.min(containerRec.width/viewRec.width,containerRec.height/viewRec.height);
					scale *= fitRatio;
					var viewMatrix:Matrix = view.transform.matrix;
					viewMatrix.scale(scale,scale);
					view.transform.matrix = viewMatrix;
				}
				QuickSetter.autoAlign(view,container,autoFit,null,rec);
		
			}
			if(view is IShowView){
				(view as IShowView).showIn();
			}
		}


		public function get currentView():DisplayObject
		{
			if(currentViewIndex>-1){
				return viewsArr[currentViewIndex];
			}else{
				return null;
			}
		}
		public function add(view:DisplayObject):void{
			viewsArr.push(view);
			QuickSetter.removeSelf(view);
		}
		public function addWith(view:DisplayObject,params:Object):void
		{
			QuickSetter.set(view,params);
			add(view);
		}
		public function addRawMovie(view:MovieClip,params:Object = null,showInFromVars:Object = null,showOutToVars:Object = null,showInTime:Number = .5,showOutTime:Number = .3):void
		{
			if(params){
				QuickSetter.set(view,params);
			}
			var showView:ShowViewMovieClip = new ShowViewMovieClip(view,showInFromVars,showOutToVars,showInTime,showOutTime)
			add(showView);
		}
		public function remove(view:DisplayObject):void
		{
			var index:int = viewsArr.indexOf(view);
			removeAt(index);
		}

		public function removeAt(index:int):void
		{
			if(index>-1 && index<viewsArr.length){
				viewsArr.splice(index,1);
			}
			render();
		}
	}
}