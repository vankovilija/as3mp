/**
 * SerializableDate
 * @author Ilija Vankov
 */
package com.as3mp {

import com.as3mp.protocol.ISerializable;
import com.as3mp.protocol.ISerializer;
import com.as3mp.serializers.DateFormatSerializer;
import com.as3mp.serializers.DateTimestampSerializer;

/**
 * Helper class for dates that allows you to easily serialize/deserialize dates
 * with a given format, if the useTimestamp property of the constructor is set
 * to true, then the serialize / deserialize of this function will work with a
 * timestamp value, the format in this case is one of the following:
 * mis - microseconds
 * ms - miliseconds
 * s - seconds
 * m - minutes
 *
 * otherwise the format will be a date format with the following options:
 * YY - short year
 * YYYY - long year
 * YYYYY - 0 leading year
 * M - short month
 * MM - long month
 * d - short date
 * dd - long date
 * h - short hour
 * hh - long hour
 * m - short minutes
 * mm - long minutes
 * s - short seconds
 * ss - long seconds
 *
 * for example:
 * YYYY-MM-dd hh:mm:ss
 */

public class SerializableDate extends Date implements ISerializable{
    private var _serializer:ISerializer;

    public function SerializableDate(format:String, useTimestamp:Boolean = false):void
    {
        if(useTimestamp)
            _serializer = DateTimestampSerializer.getForTimestampFormat(format);
        else
            _serializer = DateFormatSerializer.getByFormat(format);
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
