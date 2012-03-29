package com.horidream.display.decorators
{
	import com.horidream.core.MovieClipDecorator;
	
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * Copyright 2010. All rights reserved. 
	 *
	 * @author 	Horidream
	 * @since 	Jun 8, 2010 12:12:41 PM
	 */
	public class PivotMovieClip extends MovieClipDecorator
	{
		private var _pivot:Point = new Point();
		private var _matrix:Matrix;
		public function PivotMovieClip(decoratedMovieClip:MovieClip,pivot:Point = null)
		{
			super(decoratedMovieClip);
			if(pivot != null){
				_pivot = pivot;
			}
		}
			

		public function get pivot():Point
		{
			return _pivot;
		}

		public function set pivot(value:Point):void
		{
			_pivot = value;
		}
		

		public override function get rotation():Number
		{
			return decoratedMovieClip.rotation;
		}

		public override function set rotation(value:Number):void
		{
			_matrix = decoratedMovieClip.transform.matrix;
			_matrix.translate(-_pivot.x,-_pivot.y);
			_matrix.rotate((value-decoratedMovieClip.rotation)/180*Math.PI);
			_matrix.translate(_pivot.x,_pivot.y);
			decoratedMovieClip.transform.matrix = _matrix
		}
		

		public override function get scaleX():Number
		{
			return decoratedMovieClip.scaleX;
		}

		public override function set scaleX(value:Number):void
		{
			_matrix = decoratedMovieClip.transform.matrix;
			_matrix.translate(-_pivot.x,-_pivot.y);
			_matrix.scale(value/scaleX,1);
			_matrix.translate(_pivot.x,_pivot.y);
			decoratedMovieClip.transform.matrix = _matrix
		}

		public override function get scaleY():Number
		{
			return decoratedMovieClip.scaleY;
		}

		public override function set scaleY(value:Number):void
		{
			_matrix = decoratedMovieClip.transform.matrix;
			_matrix.translate(-_pivot.x,-_pivot.y);
			_matrix.scale(1,value/scaleY);
			_matrix.translate(_pivot.x,_pivot.y);
			decoratedMovieClip.transform.matrix = _matrix
		}
		public function set scale(value:Number):void{
			_matrix = decoratedMovieClip.transform.matrix;
			_matrix.translate(-_pivot.x,-_pivot.y);
			_matrix.scale(value/scaleX,value/scaleY);
			_matrix.translate(_pivot.x,_pivot.y);
			decoratedMovieClip.transform.matrix = _matrix
		}
		
		


	}
}