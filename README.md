ActionScript 3.0 Message Processor
=====

ActionScript 3.0 Message Processor allows you to process messages into native ActionScript types that you can define, you can use metadata tags to define how each property will be parsed, use fields or properties for the custom message types.
This library is not concerned with JSON or other parsing, once you have the string data parsed to a ActionScript generic object this library makes sure that the object is parsed to its propper ActionScript type, and passed to a propper processor.

Additionally as3mp will parse to the most logical registered child class when assigning a value to a base type (parent) type with multiple children.

Example of use:

      ...
      var controller:MessageController = new MessageController();
      
      controller.addProcessor(UserMessageProcessor);
      ... //add more testProcessors
      
      controller.processObject(serverMessage);
      ...

UserMessageProcessor.as:


      public class UserMessageProcessor extends MessageProcessor {
          public function UserMessageProcessor() {
              super(UserDataMessage);
          }

          [MessageHandler(checkValue="UPDATE_USER_DATA", checkField="cmd", messageRoot="user")]
          public function processFriendData(message:UserDataMessage):void {
              //process the message as any native AS3 type with full intellisense
          }
      }
      
UserDataMessage.as:
   
      
      public class UserDataMessage extends SerializableData {
          public var facebook_id:Number;
          public var name:String;
      
          [MessageBinding(dateFormat="YYYY-MM-dd")]
          public var dob:Date;
      }

You don't have to extend messages from SerializableData, but doing so makes them easier to Serialize, both faster for the automatic serialization, and easier for manual serialization as they get the .serialize and .deSerialize methods, as well as an additional clone method, to easily clone the message.


Don't forget to add the KnownMetaData.dtd for intellij idea setup, add it from Settings -> Schemas and DTDs, in the URI field type: "urn:Flex:Meta" and browse to the file.
