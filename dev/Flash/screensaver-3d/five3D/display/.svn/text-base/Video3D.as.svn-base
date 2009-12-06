/*//////////////////////////////////////////////////////////////////////////////////////////////////////////

  FIVe3D v2.1  -  2008-04-28
  Flash Interactive Vector-based 3D
  Mathieu Badimon  |  five3d.mathieu-badimon.com  |  www.mathieu-badimon.com  |  contact@mathieu-badimon.com

/*//////////////////////////////////////////////////////////////////////////////////////////////////////////

package five3D.display {

	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.NetStream;
	import five3D.display.Bitmap3D;

	public class Video3D extends Bitmap3D {

		private var __video:Video;

		public function Video3D(width:int = 320, height:int = 240) {
			__video = new Video(width, height);
		}

		public function get deblocking():int {
			return __video.deblocking;
		}

		public function set deblocking(value:int):void {
			__video.deblocking = value;
		}

		public function get videoWidth():int {
			return __video.videoWidth;
		}

		public function get videoHeight():int {
			return __video.videoHeight;
		}

		public function attachCamera(camera:Camera):void {
			__video.attachCamera(camera);
		}

		public function attachNetStream(netstream:NetStream):void {
			__video.attachNetStream(netstream);
		}

		public function clear():void {
			super.bitmapData = null;
		}

		public function activate():void {
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

		private function enterFrameHandler(event:Event):void {
			var bitmapdata:BitmapData = new BitmapData(__video.width, __video.height, false);
			bitmapdata.draw(__video);
			super.bitmapData = bitmapdata;
		}

		public function desactivate():void {
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

		// Errors

		override public function get bitmapData():BitmapData {
			throw new Error("The Video3D class does not implement this property or method.");
		}

		override public function set bitmapData(value:BitmapData):void {
			throw new Error("The Video3D class does not implement this property or method.");
		}

	}

}