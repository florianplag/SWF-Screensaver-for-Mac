/*//////////////////////////////////////////////////////////////////////////////////////////////////////////

  FIVe3D v2.1  -  2008-04-28
  Flash Interactive Vector-based 3D
  Mathieu Badimon  |  five3d.mathieu-badimon.com  |  www.mathieu-badimon.com  |  contact@mathieu-badimon.com

/*//////////////////////////////////////////////////////////////////////////////////////////////////////////

package five3D.display {

	import flash.display.Graphics;
	import five3D.geom.Matrix3D;
	import five3D.geom.Point3D;

	public final class Graphics3D {

		private var __motif:Array;
		private var __render:Boolean = false;

		public function Graphics3D() {
			__motif = [];
		}

		public function beginFill(color:uint, alpha:Number = 1.0):void {
			__motif.push(['B', [color, alpha]]);
			askRendering();
		}

		public function clear():void {
			__motif = [];
			askRendering();
		}

		public function curveTo(controlx:Number, controly:Number, anchorx:Number, anchory:Number):void {
			__motif.push(['C', [controlx, controly, anchorx, anchory]]);
			askRendering();
		}

		public function curveToSpace(controlx:Number, controly:Number, controlz:Number, anchorx:Number, anchory:Number, anchorz:Number):void {
			__motif.push(['C', [controlx, controly, controlz, anchorx, anchory, anchorz]]);
			askRendering();
		}

		public function drawCircle(x:Number, y:Number, radius:Number):void {
			var A:Number = radius*(Math.SQRT2-1);
			var B:Number = radius/Math.SQRT2;
			__motif.push(['M', [x, y-radius]], ['C', [x+A, y-radius, x+B, y-B]], ['C', [x+radius, y-A, x+radius, y]], ['C', [x+radius, y+A, x+B, y+B]], ['C', [x+A, y+radius, x, y+radius]], ['C', [x-A, y+radius, x-B, y+B]], ['C', [x-radius, y+A, x-radius, y]], ['C', [x-radius, y-A, x-B, y-B]], ['C', [x-A, y-radius, x, y-radius]]);
			askRendering();
		}

		public function drawEllipse(x:Number, y:Number, width:Number, height:Number):void {
			var x2:Number = x+width/2;
			var y2:Number = y+height/2;
			var radiuswidth:Number = width/2;
			var radiusheight:Number = height/2;
			var Aw:Number = radiuswidth*(Math.SQRT2-1);
			var Bw:Number = radiuswidth/Math.SQRT2;
			var Ah:Number = radiusheight*(Math.SQRT2-1);
			var Bh:Number = radiusheight/Math.SQRT2;
			__motif.push(['M', [x2, y2-radiusheight]], ['C', [x2+Aw, y2-radiusheight, x2+Bw, y2-Bh]], ['C', [x2+radiuswidth, y2-Ah, x2+radiuswidth, y2]], ['C', [x2+radiuswidth, y2+Ah, x2+Bw, y2+Bh]], ['C', [x2+Aw, y2+radiusheight, x2, y2+radiusheight]], ['C', [x2-Aw, y2+radiusheight, x2-Bw, y2+Bh]], ['C', [x2-radiuswidth, y2+Ah, x2-radiuswidth, y2]], ['C', [x2-radiuswidth, y2-Ah, x2-Bw, y2-Bh]], ['C', [x2-Aw, y2-radiusheight, x2, y2-radiusheight]]);
			askRendering();
		}

		public function drawRect(x:Number, y:Number, width:Number, height:Number):void {
			__motif.push(['M', [x, y]], ['L', [x+width, y]], ['L', [x+width, y+height]], ['L', [x, y+height]], ['L', [x, y]]);
			askRendering();
		}

		public function drawRoundRect(x:Number, y:Number, width:Number, height:Number, ellipsewidth:Number, ellipseheight:Number):void {
			var x2:Number = x+width;
			var y2:Number = y+height;
			var radiuswidth:Number = Math.min(ellipsewidth/2, width/2);
			var radiusheight:Number = Math.min(ellipseheight/2, height/2);
			var Aw:Number = radiuswidth*(Math.SQRT2-1);
			var Bw:Number = radiuswidth/Math.SQRT2;
			var Ah:Number = radiusheight*(Math.SQRT2-1);
			var Bh:Number = radiusheight/Math.SQRT2;
			__motif.push(['M', [x+radiuswidth, y]], ['L', [x2-radiuswidth, y]], ['C', [x2-radiuswidth+Aw, y, x2-radiuswidth+Bw, y+radiusheight-Bh]], ['C', [x2, y+radiusheight-Ah, x2, y+radiusheight]], ['L', [x2, y2-radiusheight]], ['C', [x2, y2-radiusheight+Ah, x2-radiuswidth+Bw, y2-radiusheight+Bh]], ['C', [x2-radiuswidth+Aw, y2, x2-radiuswidth, y2]], ['L', [x+radiuswidth, y2]], ['C', [x+radiuswidth-Aw, y2, x+radiuswidth-Bw, y2-radiusheight+Bh]], ['C', [x, y2-radiusheight+Ah, x, y2-radiusheight]], ['L', [x, y+radiusheight]], ['C', [x, y+radiusheight-Ah, x+radiuswidth-Bw, y+radiusheight-Bh]], ['C', [x+radiuswidth-Aw, y, x+radiuswidth, y]]);
			askRendering();
		}

		public function endFill():void {
			__motif.push(['E']);
			askRendering();
		}

		public function lineStyle(thickness:Number, color:uint = 0, alpha:Number = 1.0, pixelhinting:Boolean = false, scalemode:String = "normal", caps:String = null, joints:String = null, miterlimit:Number = 3):void {
			__motif.push(['S', [thickness, color, alpha, pixelhinting, scalemode, caps, joints, miterlimit]]);
			askRendering();
		}

		public function lineTo(x:Number, y:Number):void {
			__motif.push(['L', [x, y]]);
			askRendering();
		}

		public function lineToSpace(x:Number, y:Number, z:Number):void {
			__motif.push(['L', [x, y, z]]);
			askRendering();
		}

		public function moveTo(x:Number, y:Number):void {
			__motif.push(['M', [x, y]]);
			askRendering();
		}

		public function moveToSpace(x:Number, y:Number, z:Number):void {
			__motif.push(['M', [x, y, z]]);
			askRendering();
		}

		public function addMotif(motif:Array):void {
			__motif = __motif.concat(motif);
			askRendering();
		}

		internal function askRendering():void {
			__render = true;
		}

		internal function render(graphics:Graphics, matrix:Matrix3D, viewdistance:Number):void {
			if (__render) {
				draw(graphics, matrix, viewdistance);
				__render = false;
			}
		}

		private function draw(graphics:Graphics, matrix:Matrix3D, viewdistance:Number):void {
			graphics.clear();
			for (var i:int = 0; i < __motif.length; i++) {
				switch (__motif[i][0]) {
					case "B":
						graphics.beginFill(__motif[i][1][0], __motif[i][1][1]);
						break;
					case "S":
						graphics.lineStyle(__motif[i][1][0], __motif[i][1][1], __motif[i][1][2], __motif[i][1][3], __motif[i][1][4], __motif[i][1][5], __motif[i][1][6], __motif[i][1][7]);
						break;
					case "M":
						var pointm:Point3D = (__motif[i][1].length == 2) ? new Point3D(__motif[i][1][0], __motif[i][1][1]): new Point3D(__motif[i][1][0], __motif[i][1][1], __motif[i][1][2]);
						pointm = matrix.transformPoint(pointm);
						pointm.project(pointm.getPerspective(viewdistance));
						graphics.moveTo(pointm.x, pointm.y);
						break;
					case "L":
						var pointl:Point3D = (__motif[i][1].length == 2) ? new Point3D(__motif[i][1][0], __motif[i][1][1]): new Point3D(__motif[i][1][0], __motif[i][1][1], __motif[i][1][2]);
						pointl = matrix.transformPoint(pointl);
						pointl.project(pointl.getPerspective(viewdistance));
						graphics.lineTo(pointl.x, pointl.y);
						break;
					case "C":
						var pointc1:Point3D, pointc2:Point3D;
						if (__motif[i][1].length == 4) {
							pointc1 = new Point3D(__motif[i][1][0], __motif[i][1][1]);
							pointc2 = new Point3D(__motif[i][1][2], __motif[i][1][3]);
						}
						else {
							pointc1 = new Point3D(__motif[i][1][0], __motif[i][1][1], __motif[i][1][2]);
							pointc2 = new Point3D(__motif[i][1][3], __motif[i][1][4], __motif[i][1][5]);
						}
						pointc1 = matrix.transformPoint(pointc1);
						pointc2 = matrix.transformPoint(pointc2);
						pointc1.project(pointc1.getPerspective(viewdistance));
						pointc2.project(pointc2.getPerspective(viewdistance));
						graphics.curveTo(pointc1.x, pointc1.y, pointc2.x, pointc2.y);
						break;
					case "E":
						graphics.endFill();
						break;
				}
			}
		}

		static public function clone(motif:Array):Array {
			var motif2:Array = [];
			for (var i:int = 0; i < motif.length; i++) {
				switch (motif[i][0]) {
					case "B":
						motif2.push(['B', [motif[i][1][0], motif[i][1][1]]]);
						break;
					case "S":
						motif2.push(['S', [motif[i][1][0], motif[i][1][1], motif[i][1][2], motif[i][1][3], motif[i][1][4], motif[i][1][5], motif[i][1][6], motif[i][1][7]]]);
						break;
					case "M":
						motif2.push(['M', (motif[i][1].length == 2) ? [motif[i][1][0], motif[i][1][1]]: [motif[i][1][0], motif[i][1][1], motif[i][1][2]]]);
						break;
					case "L":
						motif2.push(['L', (motif[i][1].length == 2) ? [motif[i][1][0], motif[i][1][1]]: [motif[i][1][0], motif[i][1][1], motif[i][1][2]]]);
						break;
					case "C":
						motif2.push(['C', (motif[i][1].length == 4) ? [motif[i][1][0], motif[i][1][1], motif[i][1][2], motif[i][1][3]]: [motif[i][1][0], motif[i][1][1], motif[i][1][2], motif[i][1][3], motif[i][1][4], motif[i][1][5]]]);
						break;
					case "E":
						motif2.push(['E']);
						break;
				}
			}
			return motif2;
		}

	}

}