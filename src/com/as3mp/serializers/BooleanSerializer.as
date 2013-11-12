/**
 * BooleanSerializer
 * @author Ilija Vankov
 */
package com.as3mp.serializers {

import com.as3mp.protocol.ISerializer;


/**
 * Internal class to serialize boolean values inside a Object.
 */
public class BooleanSerializer implements ISerializer
{
    static private var _instance:BooleanSerializer;

    static public function getInstance():BooleanSerializer
    {
        if(!_instance)
            _instance = new BooleanSerializer();

        return _instance;
    }

    public function getSerializerWithPriority(message:Object):ISerializer
    {
        return this;
    }

    public function deSerializeMessage(message:Object, returnObject:* = null):*
    {
        if(message == "true"){
            return true;
        }else if (message == "false"){
            return false;
        }else{
            var checkNumber:Number = Number(message);
            if(isNaN(checkNumber))
                return Boolean(message);
            else
                return Boolean(checkNumber);
        }
    }

    public function getSerializationScore(message:Object):int{
        return 1;
    }

    public function serialize(object:*):Object
    {
        return (object)?"1":"0";
    }
}
}
