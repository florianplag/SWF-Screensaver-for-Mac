/*//////////////////////////////////////////////////////////////////////////////////////////////////////////

  FIVe3D v2.1  -  2008-04-28
  Flash Interactive Vector-based 3D
  Mathieu Badimon  |  five3d.mathieu-badimon.com  |  www.mathieu-badimon.com  |  contact@mathieu-badimon.com
  
  Class inspired by Thomas Pfeiffer and Ruben Swieringa's work based on Andre Michelle's experimantations.

/*//////////////////////////////////////////////////////////////////////////////////////////////////////////

package five3D.display {

	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import fl.motion.Color;
	import five3D.display.Scene3D;
	import five3D.display.Sprite3D;
	import five3D.geom.Matrix3D;
	import five3D.geom.Point3D;

	public class Bitmap3D extends Shape {

		private var __visible:Boolean = true;
		private var __x:Number = 0;
		private var __y:Number = 0;
		private var __z:Number = 0;
		private var __scalex:Number = 1;
		private var __scaley:Number = 1;
		private var __scalez:Number = 1;
		private var __rotationx:Number = 0;
		private var __rotationy:Number = 0;
		private var __rotationz:Number = 0;
		private var __matrix:Matrix3D;
		internal var __concatenatedmatrix:Matrix3D;
		private var __normal:Point3D;
		private var __bitmapdata:BitmapData;
		private var __smoothing:Boolean;
		private var __subdivisionshorizontal:int;
		private var __subdivisionsvertical:int;
		private var __singlesided:Boolean = false;
		private var __flatshaded:Boolean = false;
		private var __render:Boolean = true;
		private var __renderculling:Boolean = false;
		private var __culling:Boolean = false;
		private var __rendertessellation:Boolean = true;
		private var __points:Array;
		private var __triangles:Array;
		private var __renderprojection:Boolean = true;
		private var __width:int;
		private var __height:int;
		private var __matrices:Array;
		private var __renderbitmap:Boolean = true;
		private var __drawing:Boolean = false;
		private var __rendershading:Boolean = false;
		private var __flatshading:Boolean = false;

		public function Bitmap3D(bitmapdata:BitmapData = null, smoothing:Boolean = true, subdivisionshorizontal:int = 3, subdivisionsvertical:int = 3) {
			__matrix = new Matrix3D();
			__bitmapdata = bitmapdata;
			__smoothing = smoothing;
			__subdivisionshorizontal = subdivisionshorizontal;
			__subdivisionsvertical = subdivisionsvertical;
		}

		override public function get visible():Boolean {
			return __visible;
		}

		override public function set visible(value:Boolean):void {
			__visible = value;
		}

		override public function get mouseX():Number {
			var scene:Scene3D = getScene();
			if (scene == null) throw new Error("Cannot access this property without having the class connected to the Scene3D class through the display list hierarchy.");
			else {
				if (__concatenatedmatrix == null) throw new Error("Cannot access this property before the class has been rendered once.");
				else return __concatenatedmatrix.getInverseCoordinates(scene.mouseX, scene.mouseY, scene.viewDistance).x;
			}
		}

		override public function get mouseY():Number {
			var scene:Scene3D = getScene();
			if (scene == null) throw new Error("Cannot access this property without having the class connected to the Scene3D class through the display list hierarchy.");
			else {
				if (__concatenatedmatrix == null) throw new Error("Cannot access this property before the class has been rendered once.");
				else return __concatenatedmatrix.getInverseCoordinates(scene.mouseX, scene.mouseY, scene.viewDistance).y;
			}
		}

		public function get mouseXY():Point {
			var scene:Scene3D = getScene();
			if (scene == null) throw new Error("Cannot access this property without having the class connected to the Scene3D class through the display list hierarchy.");
			else {
				if (__concatenatedmatrix == null) throw new Error("Cannot access this property before the class has been rendered once.");
				else return __concatenatedmatrix.getInverseCoordinates(scene.mouseX, scene.mouseY, scene.viewDistance);
			}
		}

		private function getScene():Scene3D {
			for (var i:DisplayObjectContainer = DisplayObjectContainer(this); i; i = i.parent) if (i is Scene3D) return Scene3D(i);
			return null;
		}

		override public function get x():Number {
			return __x;
		}

		override public function set x(value:Number):void {
			__x = value;
			askRendering();
		}

		override public function get y():Number {
			return __y;
		}

		override public function set y(value:Number):void {
			__y = value;
			askRendering();
		}

		public function get z():Number {
			return __z;
		}

		public function set z(value:Number):void {
			__z = value;
			askRendering();
		}

		override public function get scaleX():Number {
			return __scalex;
		}

		override public function set scaleX(value:Number):void {
			__scalex = value;
			askRendering();
		}

		override public function get scaleY():Number {
			return __scaley;
		}

		override public function set scaleY(value:Number):void {
			__scaley = value;
			askRendering();
		}

		public function get scaleZ():Number {
			return __scalez;
		}

		public function set scaleZ(value:Number):void {
			__scalez = value;
			askRendering();
		}

		public function get rotationX():Number {
			return __rotationx;
		}

		public function set rotationX(value:Number):void {
			__rotationx = formatRotation(value);
			askRendering();
		}

		public function get rotationY():Number {
			return __rotationy;
		}

		public function set rotationY(value:Number):void {
			__rotationy = formatRotation(value);
			askRendering();
		}

		public function get rotationZ():Number {
			return __rotationz;
		}

		public function set rotationZ(value:Number):void {
			__rotationz = formatRotation(value);
			askRendering();
		}

		static private function formatRotation(angle:Number):Number {
			var angle2:Number = angle%360;
			if (angle2 < -180) return angle2+360;
			if (angle2 > 180) return angle2-360;
			return angle2;
		}

		public function get bitmapData():BitmapData {
			return __bitmapdata;
		}

		public function set bitmapData(value:BitmapData):void {
			__bitmapdata = value;
			if (__bitmapdata == null) {
				if (__drawing) removeBitmap();
			}
			else {
				if (__bitmapdata.width != __width || __bitmapdata.height != __height) {
					__rendertessellation = true;
					__renderprojection = true;
				}
			}
			__renderbitmap = true;
		}

		public function get smoothing():Boolean {
			return __smoothing;
		}

		public function set smoothing(value:Boolean):void {
			__smoothing = value;
			__renderbitmap = true;
		}

		public function get subdivisionsHorizontal():int {
			return __subdivisionshorizontal;
		}

		public function set subdivisionsHorizontal(value:int):void {
			__subdivisionshorizontal = value;
			__rendertessellation = true;
			__renderprojection = true;
			__renderbitmap = true;
		}

		public function get subdivisionsVertical():int {
			return __subdivisionsvertical;
		}

		public function set subdivisionsVertical(value:int):void {
			__subdivisionsvertical = value;
			__rendertessellation = true;
			__renderprojection = true;
			__renderbitmap = true;
		}

		public function get singleSided():Boolean {
			return __singlesided;
		}

		public function set singleSided(value:Boolean):void {
			__singlesided = value;
			if (__singlesided) __renderculling = true;
			else {
				__renderculling = false;
				__culling = false;
			}
		}

		public function get flatShaded():Boolean {
			return __flatshaded;
		}

		public function set flatShaded(value:Boolean):void {
			__flatshaded = value;
			if (__flatshaded) __rendershading = true;
			else {
				__rendershading = false;
				if (__flatshading) removeFlatShading();
			}
		}

		internal function askRendering():void {
			__render = true;
			if (__singlesided) __renderculling = true;
			__renderprojection = true;
			__renderbitmap = true;
			if (__flatshaded) __rendershading = true;
		}

		internal function askRenderingShading():void {
			if (__flatshaded) __rendershading = true;
		}

		internal function render(scene:Scene3D):void {
			if (!__visible && super.visible) super.visible = false;
			else if (__visible) {
				if (__render) {
					getMatrices();
					__render = false;
				}
				if (__renderculling) {
					getCulling(scene.viewDistance);
					__renderculling = false;
				}
				if (__culling) {
					if (super.visible) super.visible = false;
				}
				else {
					if (!super.visible) super.visible = true;
					if (__bitmapdata != null) {
						if (__rendertessellation) {
							getTessellation();
							__rendertessellation = false;
						}
						if (__renderprojection) {
							getProjection(scene.viewDistance);
							__renderprojection = false;
						}
						if (__renderbitmap) {
							drawBitmap();
							__renderbitmap = false;
						}
						if (__rendershading) {
							setFlatShading(scene);
							__rendershading = false;
						}
					}
				}
			}
		}

		private function getMatrices():void {
			__matrix.createBox(__scalex, __scaley, __scalez, degreesToRadians(__rotationx), degreesToRadians(__rotationy), degreesToRadians(__rotationz), __x, __y, __z);
			if (parent is Scene3D) {
				__concatenatedmatrix = __matrix.clone();
			}
			else {
				__concatenatedmatrix = Sprite3D(parent).__concatenatedmatrix.clone();
				__concatenatedmatrix.concat(__matrix);
			}
			__normal = null;
		}

		static private function degreesToRadians(angle:Number):Number {
			return angle*Math.PI/180;
		}

		private function getCulling(viewdistance:Number):void {
			var point1:Point3D = __concatenatedmatrix.transformPoint(new Point3D(0, 0, 0));
			var point2:Point3D = __concatenatedmatrix.transformPoint(new Point3D(0, 0, 1));
			__normal = point2.subtract(point1);
			var camera:Point3D = new Point3D(point1.x, point1.y, point1.z+viewdistance);
			__culling = __normal.dot(camera) < 0;
		}

		private function getTessellation():void {
			__width = __bitmapdata.width;
			__height = __bitmapdata.height;
			getTessellationPoints();
			getTessellationTriangles();
		}

		private function getTessellationPoints():void {
			__points = [];
			var stephorizontal:Number = __width/__subdivisionshorizontal;
			var stepvertical:Number = __height/__subdivisionsvertical;
			var x:Number, y:Number;
			for (var j:int = 0 ; j < __subdivisionsvertical+1; j++) {
				for (var i:int = 0; i < __subdivisionshorizontal+1; i++) {
					x = i*stephorizontal;
					y = j*stepvertical;
					__points.push({x:x, y:y, xp:x, yp:y});
				}
			}
		}

		private function getTessellationTriangles():void {
			__triangles = [];
			for (var j:int = 0; j < __subdivisionsvertical; j++) {
				for (var i:int = 0; i < __subdivisionshorizontal; i++) {
					__triangles.push([__points[i+j*(__subdivisionshorizontal+1)], __points[i+j*(__subdivisionshorizontal+1)+1], __points[i+(j+1)*(__subdivisionshorizontal+1)]]);
					__triangles.push([__points[i+(j+1)*(__subdivisionshorizontal+1)+1], __points[i+(j+1)*(__subdivisionshorizontal+1)], __points[i+j*(__subdivisionshorizontal+1)+1]]);
				}
			}
		}

		private function getProjection(viewdistance:Number):void {
			projectPoints(viewdistance);
			getProjectionMatrices();
		}

		private function projectPoints(viewdistance:Number):void {
			var l:int = __points.length;
			var point:Object, pointp:Point3D;
			while (--l > -1) {
				point = __points[l];
				pointp = __concatenatedmatrix.transformPoint(new Point3D(point.x, point.y));
				pointp.project(pointp.getPerspective(viewdistance));
				point.xp = pointp.x;
				point.yp = pointp.y;
			}
		}

		private function getProjectionMatrices():void {
			__matrices = [];
			var l:int = __triangles.length;
			var triangle:Array, point1:Object, point2:Object, point3:Object;
			var x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number, xp1:Number, yp1:Number, xp2:Number, yp2:Number, xp3:Number, yp3:Number;
			var matrix = new Matrix();
			var matrixp = new Matrix();
			while (--l > -1) {
				triangle = __triangles[l];
				point1 = triangle[0];
				point2 = triangle[1];
				point3 = triangle[2];
				x1 = point1.x;
				y1 = point1.y;
				x2 = point2.x;
				y2 = point2.y;
				x3 = point3.x;
				y3 = point3.y;
				xp1 = point1.xp;
				yp1 = point1.yp;
				xp2 = point2.xp;
				yp2 = point2.yp;
				xp3 = point3.xp;
				yp3 = point3.yp;
				matrix.a = x2-x1;
				matrix.b = y2-y1;
				matrix.c = x3-x1;
				matrix.d = y3-y1;
				matrix.tx = x1;
				matrix.ty = y1;
				matrixp.a = xp2-xp1;
				matrixp.b = yp2-yp1;
				matrixp.c = xp3-xp1;
				matrixp.d = yp3-yp1;
				matrixp.tx = xp1;
				matrixp.ty = yp1;
				matrix.invert();
				matrix.concat(matrixp);
				__matrices.unshift(matrix.clone());
			}
		}

		private function drawBitmap():void {
			var l:int = __triangles.length;
			var triangle:Array, point1:Object, point2:Object, point3:Object;
			var xp1:Number, yp1:Number, xp2:Number, yp2:Number, xp3:Number, yp3:Number;
			super.graphics.clear();
			while (--l > -1) {
				triangle = __triangles[l];
				point1 = triangle[0];
				point2 = triangle[1];
				point3 = triangle[2];
				xp1 = point1.xp;
				yp1 = point1.yp;
				xp2 = point2.xp;
				yp2 = point2.yp;
				xp3 = point3.xp;
				yp3 = point3.yp;
				super.graphics.beginBitmapFill(__bitmapdata, __matrices[l], false, __smoothing);
				super.graphics.moveTo(xp1, yp1);
				super.graphics.lineTo(xp2, yp2);
				super.graphics.lineTo(xp3, yp3);
				super.graphics.lineTo(xp1, yp1);
				super.graphics.endFill();
			}
			__drawing = true;
		}

		private function removeBitmap():void {
			super.graphics.clear();
			__drawing = false;
		}

		private function setFlatShading(scene:Scene3D):void {
			if (__normal == null) {
				var point1:Point3D = __concatenatedmatrix.transformPoint(new Point3D(0, 0, 0));
				var point2:Point3D = __concatenatedmatrix.transformPoint(new Point3D(0, 0, 1));
				__normal = point2.subtract(point1);
			}
			var dot:Number = __normal.dot(scene.ambientLightVectorNormalized);
			var brightness:Number = Math.asin(dot)/(Math.PI/2)*scene.ambientLightIntensity;
			var color:Color = new Color();
			color.brightness = brightness;
			color.alphaMultiplier = alpha;
			transform.colorTransform = color;
			__flatshading = true;
		}

		private function removeFlatShading():void {
			transform.colorTransform = new ColorTransform();
			__flatshading = false;
		}

		// Errors

		override public function get height():Number {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}

		override public function set height(value:Number):void {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}

		override public function get rotation():Number {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}

		override public function set rotation(value:Number):void {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}

		override public function get scale9Grid():Rectangle {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}

		override public function set scale9Grid(value:Rectangle):void {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}

		override public function get scrollRect():Rectangle {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}

		override public function set scrollRect(value:Rectangle):void {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}

		override public function get width():Number {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}

		override public function set width(value:Number):void {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}

		override public function globalToLocal(point:Point):Point {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}

		override public function localToGlobal(point:Point):Point {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}

		override public function get graphics():Graphics {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}

	}

}