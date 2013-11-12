/**
 * MessagesController
 * @author Ilija Vankov
 */
package com.as3mp {

import com.as3mp.serializers.BooleanSerializer;
import com.as3mp.serializers.DateFormatSerializer;
import com.as3mp.serializers.DateTimestampSerializer;
import com.as3mp.serializers.ObjectSerializer;
import com.as3mp.serializers.VectorSerializer;
import com.as3mp.utils.ObjectUtil;

import flash.utils.getQualifiedClassName;

public class MessagesController {

    protected var _processors:Vector.<MessageProcessor>;
    private var _processorsMap:Object;
    private var _processorClassMap:Object;
    private var _serializersMap:Object;
    private var _checkFields:Array;
    private var _root:Array;

    public function MessagesController(checkField:String = "", root:String = "") {
        _checkFields = [{root: checkField.split("."), field: checkField}];

        if(!root || root == "")
            _root = [];
        else
            _root = root.split(".");

        _processors = new Vector.<MessageProcessor>();
        _processorsMap = {};
        _processorClassMap = {};
        _serializersMap = {};
        _processorsMap[_checkFields] = {};
    }

    public function addProcessor(processorClass:Class):void
    {
        var cn:String = getQualifiedClassName(processorClass);

        if(_processorClassMap.hasOwnProperty(cn))
            return;

        var processor:MessageProcessor;

        processor = new processorClass();

        _processorClassMap[cn] = processor;
        _processors.push(processor);

        if(processor.checkField && processor.checkField != "" &&
           (!processor.checkFieldValue || processor.checkFieldValue == ""))
            throw new Error("Processor must have a check value to reference against check field!");

        var messageType:Class = processor.messageClassINTERNAL;

        cn = getQualifiedClassName(messageType);
        if(cn == "Boolean")
            processor.setMessageSerializer( BooleanSerializer.getInstance() );
        else if(cn == "Date"){
            var timestampFormat:String = "ms";
            var dateFormat:String = "";

            if(processor.messageHandlerMetadata){
                if(processor.messageHandlerMetadata.arg.(@key == "dateFormat").length() > 0) {
                    dateFormat = String(processor.messageHandlerMetadata.arg.(@key == 'dateFormat')[0].@value);
                }else if(processor.messageHandlerMetadata.arg.(@key == "timestamp").length() > 0) {
                    timestampFormat = String(processor.messageHandlerMetadata.arg.(@key == 'timestamp')[0].@value);
                }
            }

            if(dateFormat != ""){
                processor.setMessageSerializer(DateFormatSerializer.getByFormat(dateFormat));
            }else{
                processor.setMessageSerializer(DateTimestampSerializer.getForTimestampFormat(timestampFormat));
            }
        }
        else if(cn.indexOf("vec::Vector.") != -1)
            processor.setMessageSerializer( VectorSerializer.getForType(messageType, processor.messageHandlerMetadata) );
        else
            processor.setMessageSerializer( ObjectSerializer.getForType(messageType) );

        if(!processor.checkField || processor.checkField == ""){
            if(!_processorsMap[_checkFields[0]].hasOwnProperty(processor.checkFieldValue))
                _processorsMap[_checkFields[0]][processor.checkFieldValue] = new Vector.<MessageProcessor>();

            _processorsMap[_checkFields[0]][processor.checkFieldValue].push(processor);
        }else{
            if(!_processorsMap.hasOwnProperty(processor.checkField)){
                _processorsMap[processor.checkField] = {};
                _checkFields.push({root: processor.checkField.split("."), field: processor.checkField});
            }

            if(!_processorsMap[processor.checkField].hasOwnProperty(processor.checkFieldValue))
                _processorsMap[processor.checkField][processor.checkFieldValue] = new Vector.<MessageProcessor>();

            _processorsMap[processor.checkField][processor.checkFieldValue].push(processor);
        }
    }

    public function getProcessorInstance(processorClass:Class):*
    {
        return _processorClassMap[getQualifiedClassName(processorClass)];
    }

    public function registerDataType(type:Class):void
    {
        ObjectSerializer.getForType(type);
    }

    public function processMessage(message:Object, forceProcessor:* = null):void
    {
        var processor:MessageProcessor;

        var rootObject:Object = findRoot(_root, message, message);

        if(forceProcessor){
            if(forceProcessor is MessageProcessor)
                processor = forceProcessor;
            else if(forceProcessor is Class){
                processor = _processorClassMap[getQualifiedClassName(forceProcessor)];
            }

            if(!rootObject){
                throw new Error("Root object doesn't exist in message! (" + _root.join(".") + ")");
            }

            if(processor){
                processor.processMessageINTERNAL(rootObject);
            }
        }else{
            var l1:int = _checkFields.length;
            var processObject:Object = ObjectUtil.copy(message);
            var checkMessage:Object;
            var newRoot:Object;
            var checkValue:String;
            var checkFieldRoot:Array;
            var checkField:String;
            var l:int;
            while(--l1 > -1){
                checkFieldRoot = this._checkFields[l1].root;
                checkField = this._checkFields[l1].field;
                checkMessage = processObject;
                var lCheck:int = checkFieldRoot.length - 1;
                var iCheck:int;
                var continueProcess:Boolean = true;
                for(iCheck = 0; iCheck < lCheck; iCheck++){
                    if(!checkMessage.hasOwnProperty(checkFieldRoot[iCheck])){
                        continueProcess = false;
                        break;
                    }
                    checkMessage = checkMessage[checkFieldRoot[iCheck]];
                }
                checkValue = checkMessage[checkFieldRoot[lCheck]];
                if(continueProcess && checkMessage.hasOwnProperty(checkFieldRoot[lCheck]) && _processorsMap[checkField].hasOwnProperty(checkValue)){
                    delete checkMessage[checkFieldRoot[lCheck]];

                    if(_processorsMap[checkField].hasOwnProperty(checkValue)){

                        l = _processorsMap[checkField][checkValue].length;
                        while(--l > -1){
                            processor = _processorsMap[checkField][checkValue][l];

                            newRoot = findRoot(processor.messageRoot, processObject, rootObject);

                            if(!newRoot){
                                throw new Error("Root object doesn't exist in message! (" + _root.join(".") + ")");
                            }
                            if(newRoot is Array && !(processor.messageSerializer is VectorSerializer)){
                                var resultsL:int = newRoot.length;
                                while(--resultsL > -1){
                                    processor.processMessageINTERNAL(newRoot[resultsL]);
                                }
                            }else {
                                processor.processMessageINTERNAL(newRoot);
                            }
                        }
                    }

                    processObject = ObjectUtil.copy(message)
                }
            }
        }
    }

    private function findRoot(processor:Array, message:Object, globalRoot:Object):Object
    {
        if(processor.length == 0){
            return globalRoot;
        }

        if(!processor[0] || processor[0] == ""){
            return message;
        }

        var rootObject:Object;
        var l:int = processor.length;

        var i:int = -1;

        rootObject = message;
        while(++i < l){
            if(rootObject == null){
                break;
            }

            rootObject = rootObject[processor[i]];
        }

        return rootObject;
    }
}
}
