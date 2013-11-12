/**
 * DateTimestampSerializer
 * @author Ilija Vankov
 */
package com.as3mp.serializers {

import com.as3mp.protocol.ISerializer;


/**
 * Internal class to serialize date values from a timestamp.
 */
public class DateTimestampSerializer implements ISerializer
{
    static private const MICROSECONDS:String = "mis";
    static private const MILISECONDS:String = "ms";
    static private const SECONDS:String = "s";
    static private const MINUTES:String = "m";

    static private var availableFormats:Array = [MICROSECONDS, MILISECONDS, SECONDS, MINUTES];

    static public function isFormatTimestampFormat(format:String):Boolean
    {
        return availableFormats.indexOf(format) != -1;
    }

    private var _conversionToMSFunction:Function;
    private var _conversionFromMSFunction:Function;

    static private var _dateTimestampDict:Object = {};
    private var _format:String;

    static public function getForTimestampFormat(timestampFormat:String):DateTimestampSerializer
    {
        if(_dateTimestampDict.hasOwnProperty(timestampFormat)){
            return _dateTimestampDict[timestampFormat];
        }

        _dateTimestampDict[timestampFormat] = new DateTimestampSerializer(timestampFormat);

        return _dateTimestampDict[timestampFormat];
    }

    public function DateTimestampSerializer(timestampFormat:String) {
        if(availableFormats.indexOf(timestampFormat) == -1)
            throw new Error("Unsupported timestamp format!");
        _format = timestampFormat;
        switch (timestampFormat){
            case MICROSECONDS:
                _conversionToMSFunction = convertCutZeroes;
                _conversionFromMSFunction = convertAddZeroes;
                break;
            case SECONDS:
                _conversionToMSFunction = convertAddZeroes;
                _conversionToMSFunction = convertCutZeroes;
                break;
            case MINUTES:
                _conversionToMSFunction = convertFromM;
                _conversionToMSFunction = convertToM;
                break;
            case MILISECONDS:
            default:
                _conversionToMSFunction = convertMS;
                _conversionFromMSFunction = convertMS;
                break;
        }
    }

    private function convertMS(time:Number):Number
    {
        return time;
    }

    private function convertCutZeroes(time:Number):Number
    {
        return int(time * .001);
    }

    private function convertAddZeroes(time:Number):Number
    {
        return time * 1000;
    }

    private function convertFromM(time:Number):Number
    {
        return time * 60000;
    }

    private function convertToM(time:Number):Number
    {
        return int(time / 60000);
    }

    public function getSerializerWithPriority(message:Object):ISerializer
    {
        return this;
    }

    public function deSerializeMessage(message:Object, returnObject:* = null):*
    {
        if(isNaN(Number(message))) {
            throw new Error("Timestamp represented dates can only be numbers!");
        }

        if(!returnObject)
            returnObject = new Date();
        if(!(returnObject is Date))
            throw new Error("Return object must be date!");

        var timestamp:int = _conversionToMSFunction(message);
        returnObject.setTime(timestamp);

        return returnObject;
    }

    public function getSerializationScore(message:Object):int{
        if(isNaN(Number(message))) return -1;

        return 1;
    }

    public function serialize(object:*):Object
    {
        if(!(object is Date))
            throw new Error("Can only serialize dates");

        var timestamp:int = _conversionFromMSFunction((object as Date).time);

        return timestamp;
    }

    public function get format():String {
        return _format;
    }
}
}
