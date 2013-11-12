/**
 * ISerializable
 * @author Ilija Vankov
 */
package com.as3mp.protocol {
public interface ISerializable {
    function serialize():Object;
    function deSerializeMessage(message:Object):void;
    function clone():*;
}
}
