/**
 * ISerializer
 * @author Ilija Vankov
 */
package com.messageProcessor.protocol {
public interface ISerializer {
    function deSerializeMessage(message:Object, returnObject:* = null):*;
    function serialize(object:*):Object;
    function getSerializationScore(message:Object):int;
    function getSerializerWithPriority(message:Object):ISerializer;
}
}
