/*//////////////////////////////////////////////////////////////////////////////////////////////////////////

  FIVe3D v2.1  -  2008-04-28
  Flash Interactive Vector-based 3D
  Mathieu Badimon  |  five3d.mathieu-badimon.com  |  www.mathieu-badimon.com  |  contact@mathieu-badimon.com

/*//////////////////////////////////////////////////////////////////////////////////////////////////////////

package five3D.display {

	import flash.display.Sprite;
	import flash.events.Event;
	import five3D.display.Bitmap3D;
	import five3D.display.Shape3D;
	import five3D.display.Sprite2D;
	import five3D.display.Sprite3D;
	import five3D.display.Video3D;
	import five3D.geom.Point3D;

	public class Scene3D extends Sprite {

		private var __viewdistance:Number = 1000;
		private var __ambientlightvector:Point3D;
		private var __ambientlightvectornormalized:Point3D;
		private var __ambientlightintensity:Number = .5;

		public function Scene3D() {
			__ambientlightvector = new Point3D(1, 1, 1);
			__ambientlightvectornormalized = new Point3D(.5773502691896258, .5773502691896258, .5773502691896258);
			initializeRendering();
		}

		private function initializeRendering():void {
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

		private function enterFrameHandler(event:Event):void {
			render();
		}

		public function render():void {
			for (var i:int = 0; i < numChildren; i++) getChildAtCasted(i).render(this);
		}

		public function get viewDistance():Number {
			return __viewdistance;
		}

		public function set viewDistance(value:Number):void {
			__viewdistance = value;
			askRendering();
		}

		public function get ambientLightVector():Point3D {
			return __ambientlightvector;
		}

		public function set ambientLightVector(value:Point3D):void {
			__ambientlightvector = value;
			__ambientlightvectornormalized = __ambientlightvector.clone();
			__ambientlightvectornormalized.normalize(1);
			askRenderingShading();
		}

		public function get ambientLightVectorNormalized():Point3D {
			return __ambientlightvectornormalized;
		}

		public function get ambientLightIntensity():Number {
			return __ambientlightintensity;
		}

		public function set ambientLightIntensity(value:Number):void {
			__ambientlightintensity = value;
			askRenderingShading();
		}

		private function askRendering():void {
			for (var i:int = 0; i < numChildren; i++) getChildAtCasted(i).askRendering();
		}

		private function askRenderingShading():void {
			for (var i:int = 0; i < numChildren; i++) getChildAtCasted(i).askRenderingShading();
		}

		private function getChildAtCasted(index:int):* {
			if (getChildAt(index) is Sprite3D) return Sprite3D(getChildAt(index));
			if (getChildAt(index) is Shape3D) return Shape3D(getChildAt(index));
			if (getChildAt(index) is Bitmap3D) return Bitmap3D(getChildAt(index));
			if (getChildAt(index) is Sprite2D) return Sprite2D(getChildAt(index));
		}

	}

}