/*//////////////////////////////////////////////////////////////////////////////////////////////////////////

  FIVe3D v2.1  -  2008-04-28
  Flash Interactive Vector-based 3D
  Mathieu Badimon  |  five3d.mathieu-badimon.com  |  www.mathieu-badimon.com  |  contact@mathieu-badimon.com

/*//////////////////////////////////////////////////////////////////////////////////////////////////////////

package five3D.display {

	import flash.geom.ColorTransform;
	import five3D.display.Graphics3D;
	import five3D.display.Shape3D;
	import five3D.display.Sprite3D;

	public class DynamicText3D extends Sprite3D {

		private var __text:String = "";
		private var __typography:Object;
		private var __size:Number = 10;
		private var __color:uint = 0x000000;
		private var __letterspacing:Number = 0;
		private var __textwidth:Number = 0;

		public function DynamicText3D(typography:Object) {
			__typography = typography;
			if (!__typography.__initialized) __typography.initialize();
		}

		public function get text():String {
			return __text;
		}

		public function set text(value:String):void {
			createGlyphs(value);
			__text = value;
			removeAdditionalGlyphs();
			placeGlyphs();
		}

		private function createGlyphs(text:String):void {
			for (var i:int = 0; i < text.length; i++) if (text.charAt(i) != __text.charAt(i)) createGlyph(i, text.charAt(i));
		}

		private function createGlyph(number:Number, glyph:String):void {
			var shape:Shape3D = new Shape3D();
			shape.graphics3D.addMotif([['B', [__color, 1]]].concat(Graphics3D.clone(__typography.__motifs[glyph])).concat([['E']]));
			shape.scaleX = shape.scaleY = __size/100;
			addChildAt(shape, number);
		}

		private function removeAdditionalGlyphs():void {
			for (var i:int = numChildren-1; i >= __text.length; i--) removeChildAt(i);
		}

		private function placeGlyphs():void {
			var offset:Number = 0;
			for (var i:int = 0; i < numChildren; i++) {
				var shape:Shape3D = Shape3D(getChildAt(i));
				if (shape.x != offset) shape.x = offset;
				if (i == numChildren-1) __textwidth = offset+__typography.__widths[__text.charAt(i)];
				else offset += (__typography.__widths[__text.charAt(i)]+__letterspacing)*__size/100;
			}
		}

		public function get typography():Object {
			return __typography;
		}

		public function set typography(value:Object):void {
			__typography = value;
			if (!__typography.__initialized) __typography.initialize();
			reinitText(__text);
		}

		private function reinitText(text:String):void {
			__text = "";
			this.text = text;
		}

		public function get size():Number {
			return __size;
		}

		public function set size(value:Number):void {
			__size = value;
			resizeGlyphs();
			placeGlyphs();
		}

		private function resizeGlyphs():void {
			for (var i:int = 0; i < numChildren; i++) {
				var shape:Shape3D = Shape3D(getChildAt(i));
				shape.scaleX = shape.scaleY = __size/100;
			}
		}

		public function get color():uint {
			return __color;
		}

		public function set color(value:uint):void {
			__color = value;
			colorateGlyphs();
		}

		private function colorateGlyphs():void {
			var colortransform:ColorTransform = new ColorTransform();
			colortransform.color = __color;
			for (var i:int = 0; i < numChildren; i++) {
				var shape:Shape3D = Shape3D(getChildAt(i));
				shape.transform.colorTransform = colortransform;
			}
		}

		public function get letterSpacing():Number {
			return __letterspacing;
		}

		public function set letterSpacing(value:Number):void {
			__letterspacing = value;
			placeGlyphs();
		}

		public function get textWidth():Number {
			return __textwidth;
		}

		// Errors

		override public function get graphics3D():Graphics3D {
			throw new Error("The DynamicText3D class does not implement this property or method.");
		}

	}

}