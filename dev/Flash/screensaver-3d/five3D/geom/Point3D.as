/*//////////////////////////////////////////////////////////////////////////////////////////////////////////

  FIVe3D v2.1  -  2008-04-28
  Flash Interactive Vector-based 3D
  Mathieu Badimon  |  five3d.mathieu-badimon.com  |  www.mathieu-badimon.com  |  contact@mathieu-badimon.com

/*//////////////////////////////////////////////////////////////////////////////////////////////////////////

package five3D.geom {

	import flash.geom.Point;

	public class Point3D {

		public var x:Number;
		public var y:Number;
		public var z:Number;

		public function Point3D(x:Number = 0, y:Number = 0, z:Number = 0) {
			this.x = x;
			this.y = y;
			this.z = z;
		}

		public function get length():Number {
			return Math.sqrt(x*x+y*y+z*z);
		}

		public function clone():Point3D {
			return new Point3D(x, y, z);
		}

		public function normalize(thickness:Number):void {
			var l:Number = length;
			if (l) scale(thickness/l);
			else z = thickness;
		}

		private function scale(s:Number):void {
			x *= s;
			y *= s;
			z *= s;
		}

		public function subtract(v:Point3D):Point3D {
			return new Point3D(x-v.x, y-v.y, z-v.z);
		}

		public function toString():String {
			return "(x="+x+", y="+y+", z="+z+")";
		}

		public function dot(v:Point3D):Number {
			return x*v.x+y*v.y+z*v.z;
		}

		public function getPerspective(viewdistance:Number):Number {
			return viewdistance/(z+viewdistance);
		}

		public function project(perspective:Number):void {
			x *= perspective;
			y *= perspective;
			z = 0;
		}

	}

}