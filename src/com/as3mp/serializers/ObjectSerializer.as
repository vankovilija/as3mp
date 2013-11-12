/**
 * ObjectSerializer
 * @author Ilija Vankov
 */
package com.as3mp.serializers {

import com.as3mp.protocol.ISerializable;
import com.as3mp.protocol.ISerializer;
import com.as3mp.utils.ClassHierarchy;

import flash.utils.describeType;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;
import flash.utils.getQualifiedSuperclassName;

public class ObjectSerializer implements ISerializer{
    private var _messageType:Class;
    private var _messageTypeName:String;
    private var _optionalFields:Vector.<Object>;
    private var _requiredFields:Vector.<Object>;
    private var _fields:Vector.<Object>;
    private var _fieldsSerializers:Object;

    static private var _serializersMap:Object = {};
    private static var _classHierarchy:ClassHierarchy = new ClassHierarchy();
    private var _ignoreFields:Vector.<String>;

    static public function getForType(messageType:Class):ObjectSerializer
    {
        var cn:String = getQualifiedClassName(messageType);

        if(_serializersMap.hasOwnProperty(cn)) {
            return _serializersMap[cn];
        }

        _classHierarchy.addClass(messageType);

        var serializer:ObjectSerializer = new ObjectSerializer(messageType);
        _serializersMap[cn] = serializer;
        serializer.prepare();
        return serializer;
    }

    public function ObjectSerializer(messageType:Class) {

        _messageType = messageType;
        _messageTypeName = getQualifiedClassName(messageType);
        _optionalFields = new Vector.<Object>();
        _requiredFields = new Vector.<Object>();
        _fields = new Vector.<Object>();
        _fieldsSerializers = {};
        _ignoreFields = new Vector.<String>();

    }

    private function prepare():void
    {
        var _typeDescription:XML = describeType(_messageType).factory[0];
        var fieldType:Class;
        var fieldTypeName:String;

        for each (var node:XML in _typeDescription.*.
                (name() == 'variable' || name() == 'accessor')) {

            var fieldName:String = node.@name;

            var messageFieldName:String;
            messageFieldName = fieldName;

            var messageBinding:XML = node.metadata.(@name == 'MessageBinding')[0];

            var fieldWeight:Number = 1;

            if (messageBinding) {

                if (messageBinding.arg.(@value == "ignore").length() > 0) {
                    _ignoreFields.push(fieldName);
                    continue;
                }

                if (messageBinding.arg.(@key == "id").length() > 0) {
                    messageFieldName = messageBinding.arg.(@key == 'id')[0].@value;
                }

                if (messageBinding.arg.(@key == "propertyWeight").length() > 0) {
                    fieldWeight = Number(messageBinding.arg.(@key == 'propertyWeight')[0].@value);
                    if (isNaN(fieldWeight)) {
                        fieldWeight = 1;
                    }
                }
            }

            fieldTypeName = node.@type;
            fieldType = Class(getDefinitionByName(fieldTypeName));

            var fieldObject:Object = {fieldName: fieldName, messageFieldName: messageFieldName, fieldValue: fieldWeight, fieldType: fieldType, fieldDescription: describeType(fieldType)};

            if (messageBinding && messageBinding.arg.(@value == "required").length() > 0) {
                _requiredFields.push(fieldObject);
            } else {
                _optionalFields.push(fieldObject);
            }

            _fields.push(fieldObject);

            if (fieldTypeName.indexOf("::") != -1) {
                if (fieldTypeName.indexOf("vec::Vector.") != -1) {
                    _fieldsSerializers[fieldName] = VectorSerializer.getForType(fieldType, messageBinding);
                } else {
                    while(fieldTypeName != "Object"){
                        if(fieldTypeName == "Date" || fieldTypeName == "Boolean")
                            break;

                        fieldTypeName = getQualifiedSuperclassName(getDefinitionByName(fieldTypeName));
                    }

                    if(fieldTypeName == "Object")
                        _fieldsSerializers[fieldName] = ObjectSerializer.getForType(fieldType);
                }
            }

            if (fieldTypeName == "Boolean"){
                _fieldsSerializers[fieldName] = BooleanSerializer.getInstance();
            }else if(fieldTypeName == "Date"){
                var timestampFormat:String = "ms";
                var dateFormat:String = "";

                if(messageBinding){
                    if(messageBinding.arg.(@key == "dateFormat").length() > 0) {
                        dateFormat = String(messageBinding.arg.(@key == 'dateFormat')[0].@value);
                    }else if(messageBinding.arg.(@key == "timestamp").length() > 0) {
                        timestampFormat = String(messageBinding.arg.(@key == 'timestamp')[0].@value);
                    }
                }

                if(dateFormat != ""){
                    _fieldsSerializers[fieldName] = DateFormatSerializer.getByFormat(dateFormat);
                }else{
                    _fieldsSerializers[fieldName] = DateTimestampSerializer.getForTimestampFormat(timestampFormat);
                }
            }
        }
    }

    public function getSerializationScore(message:Object):int
    {
        if(_messageTypeName == "Object") return 0;

        var l:int = _requiredFields.length;

        while(--l > -1){
            if(!message.hasOwnProperty(_requiredFields[l].messageFieldName)){
                return -1;
            }
        }

        var score:int = 0;
        var fieldObject:Object;

        for(var key:String in message){
            if((fieldObject = findFieldObjectFormessageField(key))){
                if(_ignoreFields.indexOf(fieldObject.fieldName) != -1) continue;

                if(_fieldsSerializers.hasOwnProperty(fieldObject.fieldName)){
                    score += ISerializer(_fieldsSerializers[fieldObject.fieldName]).getSerializationScore(message[fieldObject.messageFieldName]);
                }else
                    score += fieldObject.fieldValue;
            }else{
                score --;
            }
        }

        l = _fields.length;

        while(--l > -1){
            if(!message.hasOwnProperty(_fields[l].messageFieldName))
                score -= _fields[l].fieldValue;
        }

        return score;
    }

    public function findFieldObjectFormessageField(field:String):Object
    {
        var l:int = _fields.length;

        while(--l > -1){
            if(_fields[l].messageFieldName == field) return _fields[l];
        }

        return null;
    }

    public function getSerializerWithPriority(message:Object):ISerializer
    {
        var chosenSerializer:ISerializer = this;
        var chosenScore:int = this.getSerializationScore(message);
        var tempScore:int;

        var serializer:ISerializer;

        _classHierarchy.forAllChildren(_messageType, function(c:Class):void{
            serializer = _serializersMap[getQualifiedClassName(c)];

            if(!serializer)
                return;

            if((tempScore = serializer.getSerializationScore(message)) > chosenScore){
                chosenScore = tempScore;
                chosenSerializer = serializer;
            }
        });

        return chosenSerializer;
    }

    public function deSerializeMessageWithPriority(message:Object):*
    {
        var chosenSerializer:ISerializer = getSerializerWithPriority(message);

        return chosenSerializer.deSerializeMessage(message);
    }

    public function deSerializeMessage(message:Object, returnObject:* = null):*
    {
        if(!returnObject){
            returnObject = new _messageType();
        }else if(!(returnObject is _messageType)){
            throw new Error("Returned object by deSerializeMessage must be of message type.")
        }

        if(_messageTypeName == "Object"){
            for(var key:String in message){
                returnObject[key] = message[key];
            }

            return returnObject;
        }

        var l:int = _requiredFields.length;


        while(--l > -1){
            if(!message.hasOwnProperty(_requiredFields[l].messageFieldName)){
                throw new Error("Required field '" + _requiredFields[l].messageFieldName + "' missing in message.");
            }
        }

        l = _fields.length;
        var field:String;
        var messageField:String;
        var fieldObject:Object;

        while(--l > -1){
            fieldObject = _fields[l];

            field = fieldObject.fieldName;

            if(_ignoreFields.indexOf(field) != -1) continue;

            messageField = fieldObject.messageFieldName;

            if(!message.hasOwnProperty(messageField)) continue;

            if(_fieldsSerializers.hasOwnProperty(field)){
                if(_fieldsSerializers[field] is ObjectSerializer)
                    returnObject[field] = ObjectSerializer(_fieldsSerializers[field]).deSerializeMessageWithPriority(message[messageField]);
                else {
                    returnObject[field] = ISerializer(_fieldsSerializers[field]).deSerializeMessage(message[messageField]);
                }
            }else
                returnObject[field] = message[messageField];
        }

        return returnObject;
    }

    public function serializeWithPriority(object:*):Object
    {
        if(getQualifiedClassName(object) == "Object") return object;

        if(object is ISerializable) return ISerializable(object).serialize();

        var chosenSerializer:ObjectSerializer = this;
        var serializer:ObjectSerializer;

        _classHierarchy.forAllChildren(_messageType, function(c:Class):Boolean {
            serializer = _serializersMap[getQualifiedClassName(c)];

            if(!serializer)
                return true;

            if(object is serializer._messageType){
                chosenSerializer = serializer;
                return false;
            }
            return true;
        });

        if(chosenSerializer == this || !(chosenSerializer is ObjectSerializer))
            return chosenSerializer.serialize(object);
        else
            return chosenSerializer.serializeWithPriority(object);
    }

    public function serialize(object:*):Object
    {
        var returnObject:Object = {};

        var l:int = _fields.length;
        var field:String;
        var messageField:String;
        var fieldValue:*;
        var fieldObject:Object;

        while(--l > -1){
            fieldObject = _fields[l];

            field = fieldObject.fieldName;

            if(_ignoreFields.indexOf(field) != -1) continue;

            messageField = fieldObject.messageFieldName;
            fieldValue = object[field];

            if(fieldValue != undefined && fieldValue != null && (!(fieldValue is Number) || !isNaN(fieldValue)))
                if(_fieldsSerializers.hasOwnProperty(field)) {
                    if(_fieldsSerializers[field] is ObjectSerializer)
                        returnObject[messageField] = ObjectSerializer(_fieldsSerializers[field]).serializeWithPriority(fieldValue);
                    else
                        returnObject[messageField] = ISerializer(_fieldsSerializers[field]).serialize(fieldValue);
                }else
                    returnObject[messageField] = fieldValue;
        }

        return returnObject;
    }
}
}
