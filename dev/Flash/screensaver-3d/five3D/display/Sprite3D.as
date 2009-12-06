/*//////////////////////////////////////////////////////////////////////////////////////////////////////////

  FIVe3D v2.1  -  2008-04-28
  Flash Interactive Vector-based 3D
  Mathieu Badimon  |  five3d.mathieu-badimon.com  |  www.mathieu-badimon.com  |  contact@mathieu-badimon.com

/*//////////////////////////////////////////////////////////////////////////////////////////////////////////

package five3D.display {

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import fl.motion.Color;
	import five3D.display.Bitmap3D;
	import five3D.display.Graphics3D;
	import five3D.display.Scene3D;
	import five3D.display.Shape3D;
	import five3D.display.Sprite2D;
	import five3D.geom.Matrix3D;
	import five3D.geom.Point3D;

	public class Sprite3D extends Sprite {

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
		private var __graphics:Graphics3D;
		private var __singlesided:Boolean = false;
		private var __flatshaded:Boolean = false;
		private var __childrensorted:Boolean = false;
		private var __render:Boolean = true;
		private var __renderculling:Boolean = false;
		private var __culling:Boolean = false;
		private var __rendershading:Boolean = false;
		private var __flatshading:Boolean = false;

		public function Sprite3D() {
			__matrix = new Matrix3D();
			__graphics = new Graphics3D();
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

		public function get graphics3D():Graphics3D {
			return __graphics;
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

		public function get childrenSorted():Boolean {
			return __childrensorted;
		}

		public function set childrenSorted(value:Boolean):void {
			__childrensorted = value;
		}

		internal function askRendering():void {
			__render = true;
			__graphics.askRendering();
			if (__singlesided) __renderculling = true;
			if (__flatshaded) __rendershading = true;
			for (var i:int = 0; i < numChildren; i++) getChildAtCasted(i).askRendering();
		}

		internal function askRenderingShading():void {
			if (__flatshaded) __rendershading = true;
			for (var i:int = 0; i < numChildren; i++) getChildAtCasted(i).askRenderingShading();
		}

		private function getChildAtCasted(index:int):* {
			if (getChildAt(index) is Sprite3D) return Sprite3D(getChildAt(index));
			if (getChildAt(index) is Shape3D) return Shape3D(getChildAt(index));
			if (getChildAt(index) is Bitmap3D) return Bitmap3D(getChildAt(index));
			if (getChildAt(index) is Sprite2D) return Sprite2D(getChildAt(index));
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
					__graphics.render(super.graphics, __concatenatedmatrix, scene.viewDistance);
					if (__rendershading) {
						setFlatShading(scene);
						__rendershading = false;
					}
					for (var i:int = 0; i < numChildren; i++) getChildAtCasted(i).render(scene);
					if (__childrensorted) sortChildren();
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

		private function sortChildren():void {
			var sort:Array = [];
			var child:*;
			for (var i:int = 0; i < numChildren; i++) {
				child = getChildAtCasted(i);
				if (child.visible) sort.push({child:child, z:child.__concatenatedmatrix.tz});
			}
			sort.sortOn("z", Array.DESCENDING | Array.NUMERIC);
			for (i = 0; i < sort.length; i++) setChildIndex(sort[i].child, i);
		}

		// Errors

		override public function get height():Number {
			throw new Error("The Sprite3D class does not implement this property or method.");
		}

		override public function set height(value:Number):void {
			throw new Error("The Sprite3D class does not implement this property or method.");
		}

		override public function get rotation():Number {
			throw new Error("The Sprite3D class does not implement this property or method.");
		}

		override public function set rotation(value:Number):void {
			throw new Error("The Sprite3D class does not implement this property or method.");
		}

		override public function get scale9Grid():Rectangle {
			throw new Error("The Sprite3D class does not implement this property or method.");
		}

		override public function set scale9Grid(value:Rectangle):void {
			throw new Error("The Sprite3D class does not implement this property or method.");
		}

		override public function get scrollRect():Rectangle {
			throw new Error("The Sprite3D class does not implement this property or method.");
		}

		override public function set scrollRect(value:Rectangle):void {
			throw new Error("The Sprite3D class does not implement this property or method.");
		}

		override public function get width():Number {
			throw new Error("The Sprite3D class does not implement this property or method.");
		}

		override public function set width(value:Number):void {
			throw new Error("The Sprite3D class does not implement this property or method.");
		}

		override public function globalToLocal(point:Point):Point {
			throw new Error("The Sprite3D class does not implement this property or method.");
		}

		override public function localToGlobal(point:Point):Point {
			throw new Error("The Sprite3D class does not implement this property or method.");
		}

		override public function get dropTarget():DisplayObject {
			throw new Error("The Sprite3D class does not implement this property or method.");
		}

		override public function get graphics():Graphics {
			throw new Error("The Sprite3D class does not implement this property or method (use \"graphics3D\" instead).");
		}

		override public function startDrag(lockCenter:Boolean = false, bounds:Rectangle = null):void {
			throw new Error("The Sprite3D class does not implement this property or method.");
		}

		override public function stopDrag():void {
			throw new Error("The Sprite3D class does not implement this property or method.");
		}

	}

}