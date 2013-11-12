/**
 * ISerializable
 * @author Ilija Vankov
 */
package com.messageProcessor.protocol {
public interface ISerializable {
    function serialize():Object;
    function deSerializeMessage(message:Object):void;
    function clone():*;
}
}
