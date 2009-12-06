/*//////////////////////////////////////////////////////////////////////////////////////////////////////////

  FIVe3D v2.1  -  2008-04-28
  Flash Interactive Vector-based 3D
  Mathieu Badimon  |  five3d.mathieu-badimon.com  |  www.mathieu-badimon.com  |  contact@mathieu-badimon.com

/*//////////////////////////////////////////////////////////////////////////////////////////////////////////

package five3D.utils {

	import five3D.display.Graphics3D;

	public class Drawing {

		static public function polygon(graphics:Graphics3D, points:Array, color:uint, alpha:Number = 1.0):void {
			graphics.beginFill(color, alpha);
			tracePolygon(graphics, points);
			graphics.endFill();
		}

		static private function tracePolygon(graphics:Graphics3D, points:Array):void {
			var i:Number = points.length;
			graphics.moveTo(points[0].x, points[0].y);
			while (i--) graphics.lineTo(points[i].x, points[i].y);
		}

		static public function star(graphics:Graphics3D, nbtops:Number, radius1:Number, radius2:Number, angle:Number, color:uint, alpha:Number = 1.0):void {
			graphics.beginFill(color, alpha);
			traceStar(graphics, 0, 0, nbtops, radius1, radius2, angle);
			graphics.endFill();
		}

		static public function starPlace(graphics:Graphics3D, x:Number, y:Number, nbtops:Number, radius1:Number, radius2:Number, angle:Number, color:uint, alpha:Number = 1.0):void {
			graphics.beginFill(color, alpha);
			traceStar(graphics, x, y, nbtops, radius1, radius2, angle);
			graphics.endFill();
		}

		static private function traceStar(graphics:Graphics3D, x:Number, y:Number, nbtops:Number, radius1:Number, radius2:Number, angle:Number):void {
			nbtops *= 2;
			var anglestep:Number = Math.PI*2/nbtops;
			graphics.moveTo(x+Math.cos(angle)*radius2, y+Math.sin(angle)*radius2);
			while (nbtops--) {
				angle += anglestep;
				if (nbtops%2) graphics.lineTo(x+Math.cos(angle)*radius1, y+Math.sin(angle)*radius1);
				else graphics.lineTo(x+Math.cos(angle)*radius2, y+Math.sin(angle)*radius2);
			}
		}

		static public function gradientHorizontalPlain(graphics:Graphics3D, width:Number, height:Number, color:uint, alpha1:Number, alpha2:Number, nbsteps:Number):void {
			var widthstep:Number = width/nbsteps;
			var alphastep:Number = (alpha2-alpha1)/nbsteps;
			for (var i:Number = 0; i < nbsteps; i++) {
				graphics.beginFill(color, alpha1+i*alphastep);
				graphics.drawRect(i*widthstep, 0, widthstep, height);
				graphics.endFill();
			}
		}

		static public function gradientHorizontalPlainPlace(graphics:Graphics3D, x:Number, y:Number, width:Number, height:Number, color:uint, alpha1:Number, alpha2:Number, nbsteps:Number):void {
			var widthstep:Number = width/nbsteps;
			var alphastep:Number = (alpha2-alpha1)/nbsteps;
			for (var i:Number = 0; i < nbsteps; i++) {
				graphics.beginFill(color, alpha1+i*alphastep);
				graphics.drawRect(x+i*widthstep, y, widthstep, height);
				graphics.endFill();
			}
		}

	}

}