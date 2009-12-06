/*//////////////////////////////////////////////////////////////////////////////////////////////////////////

  FIVe3D v2.1  -  2008-04-28
  Flash Interactive Vector-based 3D
  Mathieu Badimon  |  five3d.mathieu-badimon.com  |  www.mathieu-badimon.com  |  contact@mathieu-badimon.com

/*//////////////////////////////////////////////////////////////////////////////////////////////////////////

package five3D.utils {

	public class ObjectUtilities {

		static public function initializeProperties(object:Object, properties:Object):void {
			for (var i:String in properties) object[i] = properties[i];
		}

	}

}