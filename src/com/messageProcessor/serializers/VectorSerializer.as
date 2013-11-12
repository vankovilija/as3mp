/**
 * VectorSerializer
 * @author Ilija Vankov
 */
package com.messageProcessor.serializers {

import com.messageProcessor.protocol.ISerializer;

import flash.utils.getDefinitionByName;

import flash.utils.getQualifiedClassName;

public class VectorSerializer implements ISerializer{
    private var _vectorClass:Class;
    private var _vectorTypeName:String;
    private var _serializer:ISerializer;
    private var _binding:XML;

    static private var _serializersMap:Object = {};

    static public function getForType(vectorClass:Class, binding:XML):VectorSerializer
    {
        var cn:String = getQualifiedClassName(vectorClass);

        if(_serializersMap.hasOwnProperty(cn))
            return _serializersMap[cn];

        var serializer:VectorSerializer = new VectorSerializer(vectorClass, binding);
        _serializersMap[cn] = serializer;
        serializer.prepare();
        return serializer;
    }

    public function VectorSerializer(vectorClass:Class, binding:XML) {
        _vectorClass = vectorClass;
        _vectorTypeName = getVectorTypeName(getQualifiedClassName(vectorClass));
        _binding = binding;
    }

    private function prepare():void
    {
        var vectorType:Class;
        if(_vectorTypeName.indexOf("::") != -1){
            vectorType = Class(getDefinitionByName(_vectorTypeName));

            if(_vectorTypeName.indexOf("vec::Vector.") != -1){
                _serializer = VectorSerializer.getForType(vectorType, _binding);
            }else{
                _serializer = ObjectSerializer.getForType(vectorType);
            }
        }

        if(_vectorTypeName == "Boolean"){
            _serializer = BooleanSerializer.getInstance();
        }else if(_vectorTypeName == "Date"){
            var timestampFormat:String = "ms";
            var dateFormat:String = "";

            if(_binding){
                if(_binding.arg.(@key == "dateFormat").length() > 0) {
                    dateFormat = String(_binding.arg.(@key == 'dateFormat')[0].@value);
                }else if(_binding.arg.(@key == "timestamp").length() > 0) {
                    timestampFormat = String(_binding.arg.(@key == 'timestamp')[0].@value);
                }
            }

            if(dateFormat != ""){
                _serializer = DateFormatSerializer.getByFormat(dateFormat);
            }else{
                _serializer = DateTimestampSerializer.getForTimestampFormat(timestampFormat);
            }
        }
    }

    public function deSerializeMessage(message:Object, returnObject:* = null):*
    {
        if(getQualifiedClassName(message) != "Array")
            throw new Error("Vector serializer can only serialize arrays to vectors");

        var v:* = new _vectorClass();
        var l:int = message.length;

        var i:int = -1;

        while(++i < l){
            if(_serializer){
                if(_serializer is ObjectSerializer)
                    v.push(ObjectSerializer(_serializer).deSerializeMessageWithPriority(message[i]));
                else
                    v.push(_serializer.deSerializeMessage(message[i]));
            }else
                v.push(message[i]);
        }

        return v;
    }

    public function serialize(object:*):Object
    {
        var returnArray:Array = [];

        var l:int = object.length;

        var i:int = -1;

        while(++i < l) {
            if(_serializer){
                if(_serializer is ObjectSerializer)
                    returnArray.push(ObjectSerializer(_serializer).serializeWithPriority(object[i]));
                else
                    returnArray.push(_serializer.serialize(object[i]));
            }else
                returnArray.push(object[i]);
        }

        return returnArray;
    }

    public function getSerializerWithPriority(message:Object):ISerializer
    {
        return this;
    }

    public function getSerializationScore(message:Object):int
    {
        if(getQualifiedClassName(message) != "Array")
            throw new Error("Vector serializer can only serialize arrays to vectors");

        var l:int = message.length;

        var score:int;

        while(--l > -1){
            if(_serializer)
                score += _serializer.getSerializerWithPriority(message[l]).getSerializationScore(message[l]);
            else
                score++;
        }

        return score;
    }

    private function getVectorTypeName(vectorClassName:String):String
    {
        var vectorTypeNameArray:Array = vectorClassName.split("<");
        vectorTypeNameArray.shift();
        var vectorTypeName:String = vectorTypeNameArray.join("<");
        vectorTypeNameArray = vectorTypeName.split(">");
        vectorTypeNameArray.pop();
        vectorTypeName = vectorTypeNameArray.join(">");
        return vectorTypeName;
    }
}
}
