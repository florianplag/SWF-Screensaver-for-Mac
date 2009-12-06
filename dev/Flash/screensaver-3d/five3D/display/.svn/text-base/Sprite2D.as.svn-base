/*//////////////////////////////////////////////////////////////////////////////////////////////////////////

  FIVe3D v2.1  -  2008-04-28
  Flash Interactive Vector-based 3D
  Mathieu Badimon  |  five3d.mathieu-badimon.com  |  www.mathieu-badimon.com  |  contact@mathieu-badimon.com

/*//////////////////////////////////////////////////////////////////////////////////////////////////////////

package five3D.display {

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import five3D.display.Scene3D;
	import five3D.display.Sprite3D;
	import five3D.geom.Matrix3D;
	import five3D.geom.Point3D;

	public class Sprite2D extends Sprite {

		private var __visible:Boolean = true;
		private var __x:Number = 0;
		private var __y:Number = 0;
		private var __z:Number = 0;
		private var __scalex:Number = 1;
		private var __scaley:Number = 1;
		private var __matrix:Matrix3D;
		internal var __concatenatedmatrix:Matrix3D;
		private var __perspective:Number;
		private var __scaled:Boolean = true;
		private var __render:Boolean = true;
		private var __renderscaling:Boolean = true;
		private var __scaling:Boolean = false;

		public function Sprite2D() {
			__matrix = new Matrix3D();
		}

		override public function get visible():Boolean {
			return __visible;
		}

		override public function set visible(value:Boolean):void {
			__visible = value;
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
			if (__scaled) __renderscaling = true;
			else super.scaleX = __scalex;
		}

		override public function get scaleY():Number {
			return __scaley;
		}

		override public function set scaleY(value:Number):void {
			__scaley = value;
			if (__scaled) __renderscaling = true;
			else super.scaleY = __scaley;
		}

		public function get scaled():Boolean {
			return __scaled;
		}

		public function set scaled(value:Boolean):void {
			__scaled = value;
			if (__scaled) __renderscaling = true;
			else {
				__renderscaling = false;
				if (__scaling) removeScaling();
			}
		}

		internal function askRendering():void {
			__render = true;
			if (__scaled) __renderscaling = true;
		}

		internal function render(scene:Scene3D):void {
			if (!__visible && super.visible) super.visible = false;
			else if (__visible) {
				if (!super.visible) super.visible = true;
				if (__render) {
					getMatrices();
					setPlacement(scene.viewDistance);
					__render = false;
				}
				if (__renderscaling) {
					setScaling();
					__renderscaling = false;
				}
			}
		}

		private function getMatrices():void {
			__matrix.createBox(1, 1, 1, 0, 0, 0, __x, __y, __z);
			if (parent is Scene3D) {
				__concatenatedmatrix = __matrix.clone();
			}
			else {
				__concatenatedmatrix = Sprite3D(parent).__concatenatedmatrix.clone();
				__concatenatedmatrix.concat(__matrix);
			}
		}

		private function setPlacement(viewdistance:Number):void {
			var point:Point3D = __concatenatedmatrix.transformPoint(new Point3D());
			__perspective = point.getPerspective(viewdistance);
			point.project(__perspective);
			super.x = point.x;
			super.y = point.y;
		}

		private function setScaling():void {
			super.scaleX = __scalex*__perspective;
			super.scaleY = __scaley*__perspective;
			__scaling = true;
		}

		private function removeScaling():void {
			super.scaleX = __scalex;
			super.scaleY = __scaley;
			__scaling = false;
		}

		// Errors

		override public function get dropTarget():DisplayObject {
			throw new Error("The Sprite2D class does not implement this property or method.");
		}

		override public function startDrag(lockCenter:Boolean = false, bounds:Rectangle = null):void {
			throw new Error("The Sprite2D class does not implement this property or method.");
		}

		override public function stopDrag():void {
			throw new Error("The Sprite2D class does not implement this property or method.");
		}

	}

}