/**
 * MessageProcessor
 * @author Ilija Vankov
 */
package com.messageProcessor {

import com.messageProcessor.protocol.ISerializer;
import com.messageProcessor.serializers.ObjectSerializer;
import com.messageProcessor.serializers.ObjectSerializer;

import flash.utils.describeType;
import flash.utils.getQualifiedClassName;


/**
 * Base class for message testProcessors, extend from this class every time you need a message processor,
 * this class should not be instantiated or used on its own, it should be always used from within the
 * message controller.
 * <b>Usage:</b><br>
 *     <listing>
 *         package com.messageProcessors {
 *               import com.messageProcessor.MessageProcessor;
 *               import com.FacebookUser;
 *               import com.FriendDataMessage;
 *
 *
 *               public class UpdateFriendDataMessageProcessor extends MessageProcessor {
 *                   public var friends:Vector.&lt;FacebookUser&gt;;
 *
 *                   public function UpdateFriendDataMessageProcessor() {
 *                       super(FriendDataMessage);
 *                   }
 *
 *                   [MessageHandler(checkValue="UPDATE_FRIEND_DATA", checkField="cmd", messageRoot="data.friendData")]
 *                   public function processFriendData(message:FriendDataMessage):void {
 *                       var l:int = message.appFriends.length;
 *
 *                       var friendData:FacebookUser;
 *                       for(var i:int = 0; i < l; i++) {
 *                           friendData = message.appFriends[i];
 *
 *                           //process friend data
 *
 *                           friends.push(friendData);
 *                       }
 *                   }
 *               }
 *           }
 *     </listing>
 */
public class MessageProcessor {
    private var _messageClass:*;
    private var _processFunction:Function;
    private var _checkField:String;
    private var _checkFieldValue:String;
    private var _messageRoot:Array;
    private var _messageSerializer:ISerializer;
    private var _messageHandler:XML;

    /**
     * The message processor constructor is used to setup the message processor, you can't properly
     * use the message processor without first calling the constructor.
     *
     * @param messageClass:<b>Class</b> the type of the message that is going to be processed by this processor in the MessageHandler function.
     */
    public function MessageProcessor(messageClass:*) {
        _messageClass = messageClass;
        var typeDescription:XML = describeType(this);
        for each (var node:XML in typeDescription.*.(name() == 'method')) {
            _messageHandler = node.metadata.(@name == 'MessageHandler')[0];
            if (_messageHandler) {
                var cn:String = getQualifiedClassName(_messageClass);
                var messageParameters:XMLList = node.parameter.(@type == cn);
                if(messageParameters.length() == 0 || messageParameters.length() > 1 || messageParameters[0].@index != 1){
                    throw new Error("The message handler must accept the message class as its first parameter!");
                }

                if (_messageHandler.arg.(@key == "checkValue").length() > 0) {
                    _checkFieldValue = _messageHandler.arg.(@key == 'checkValue')[0].@value;
                } else {
                    _checkFieldValue = "";
                }

                if (_messageHandler.arg.(@key == "checkField").length() > 0) {
                    _checkField = _messageHandler.arg.(@key == 'checkField')[0].@value;
                } else {
                    _checkField = "";
                }

                if (_messageHandler.arg.(@key == "messageRoot").length() > 0) {
                    _messageRoot = String(_messageHandler.arg.(@key == 'messageRoot')[0].@value).split(".");
                } else {
                    _messageRoot = [];
                }

                _processFunction = this[node.@name];
                break;
            }
        }

        if(!Boolean(_processFunction)){
            throw new Error("Message processors must have a process function, make sure you added the MessageHandler metadata tag to your process function!");
        }
    }

    final internal function processMessageINTERNAL(message:*):void
    {
        if(!(message is _messageClass)){
            if(_messageSerializer is ObjectSerializer)
                message = ObjectSerializer(_messageSerializer).deSerializeMessageWithPriority(message);
            else
                message = _messageSerializer.deSerializeMessage(message);

            if(!(message is _messageClass))
                throw new Error("Message not of popper type for processor");
        }

        _processFunction.apply(null, [message]);
    }

    final internal function get messageClassINTERNAL():Class {
        return _messageClass;
    }

    final internal function get checkField():String
    {
        return _checkField;
    }

    final internal function get checkFieldValue():String {
        return _checkFieldValue;
    }

    final internal function get messageRoot():Array
    {
        return _messageRoot;
    }

    final internal function setMessageSerializer(value:ISerializer):void {
        _messageSerializer = value;
    }

    final internal function get messageHandlerMetadata():XML {
        return _messageHandler;
    }

    final internal function get messageSerializer():ISerializer {
        return _messageSerializer;
    }
}
}
