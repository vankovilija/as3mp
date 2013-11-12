ActionScript 3.0 Message Processor
=====

ActionScript 3.0 Message Processor allows you to process messages into native ActionScript types that you can define, you can use metadata tags to define how each property will be parsed, use fields or properties for the custom message types.
This library is not concerned with JSON or other parsing, once you have the string data parsed to a ActionScript generic object this library makes sure that the object is parsed to its propper ActionScript type, and passed to a propper processor.

Example of use:
      ...
      var controller:MessageController = new MessageController();
      
      controller.addProcessor(UserMessageProcessor);
      ... //add more processors
      
      controller.processObject(serverMessage);
      ...

UserMessageProcessor.as:


      public class UserMessageProcessor extends MessageProcessor {
          public var friends:Vector.&lt;FacebookUser&gt;;

          public function UserMessageProcessor() {
              super(UserDataMessage);
          }

          [MessageHandler(checkValue="UPDATE_USER_DATA", checkField="cmd", messageRoot="user")]
          public function processFriendData(message:UserDataMessage):void {
              //process the message as any native AS3 type with full intellisense
          }
      }
