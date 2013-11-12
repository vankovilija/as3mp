/**
 * ObjectUtil
 * @author Ilija Vankov
 */
package com.as3mp.utils
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class ObjectUtil 
	{
		/**
		 * Get the class of an object
		 * @param	obj Object to get the class
		 * @return	class of the object or null if the object is null
		 */
		public static function getClass(obj:Object):Class
		{
			if (!obj) return null;
			
			return Class(getDefinitionByName(getQualifiedClassName(obj)));
		}
		
		/**
		 * Copy an object
		 * @param	obj Object to copy
		 * @param	into (optional) Object to copy into. If null, a new object is created
		 * @return copy of the object
		 */
		public static function copy (obj:Object):Object
		{
			var into:Object = {};
			
			if (obj != null)
			{
				for (var prop:* in obj) into[prop] = obj[prop];
			}
			
			return into;
		}
		
		/**
		 * Compare two objects
		 * @param	obj1
		 * @param	obj2
		 * @return true if objects are equal, false otherwise
		 */
		public static function compareObjects(obj1:Object, obj2:Object):Boolean
		{
			for (var prop:String in obj1) {
				
				if (obj1[prop] != obj2[prop]) return false;
			}
			
			return true;
		}
		
		/**
		 * Destroy an object as delete all its properties
		 * If property is an object the function is called again with this property as a parameter
		 * @param	obj Object to destroy
		 */
		public static function destroy (obj:Object):void
		{
			if (obj != null)
			{
				for (var prop:* in obj)
				{
					if (getClass(obj[prop]) == Object)
					{
						destroy(obj[prop]);
					} else {
						obj[prop] = null;
						delete obj[prop];
					}
				}
			}
		}
		
		/**
		 * Merge 2 objects
		 */
		public static function merge( obj0:Object, obj1:Object ):Object
		{
			var obj:Object = ObjectUtil.copy(obj1);
			for( var p:String in obj0 )
			{
				obj[ p ] = ( obj1[ p ] != null ) ? obj1[ p ] : obj0[ p ];
			}
			return obj;
		}
		
		/**
		 * Check if a object is empty
		 */
		static public function checkIfEmpty(obj:Object):Boolean
		{
			var isEmpty:Boolean = !Boolean(obj);
			for (var n:String in obj) { isEmpty = false; break; }
			if(obj.hasOwnProperty('length')) 
				isEmpty = obj.length <= 0;
			
			return isEmpty;
		}
	}
}
