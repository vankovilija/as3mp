/**
 * SerializableData
 * @author Ilija Vankov
 */
package com.as3mp {

import com.as3mp.protocol.ISerializable;
import com.as3mp.protocol.ISerializer;
import com.as3mp.serializers.ObjectSerializer;

/**
 * JSON message objects should extend from SerializableData but they don't have to,
 * if you want to define an alternative ID when the data is serialized or when the
 * data is parsed for the server data, you need to use the MessageBinding metadata tag
 * like so: [MessageBinding(id="ID_IN_JSON", required)]
 */

public class SerializableData extends Object implements ISerializable{
    private var _serializer:ISerializer;

    public function SerializableData():void
    {
        _serializer = ObjectSerializer.getForType(Class(Object(this).constructor));
    }

    public function serialize():Object
    {
        return _serializer.serialize(this);
    }

    public function deSerializeMessage(message:Object):void
    {
        _serializer.deSerializeMessage(message, this);
    }

    public function clone():*
    {
        return _serializer.deSerializeMessage(serialize());
    }
}
}
