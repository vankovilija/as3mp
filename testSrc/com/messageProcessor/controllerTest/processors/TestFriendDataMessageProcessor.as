/**
 * TestFriendDataMessageProcessor
 * @author Ilija Vankov
 */
package com.messageProcessor.controllerTest.processors {
import com.messageProcessor.*;
import com.messageProcessor.controllerTest.testMessageTypes.AppUserMessage;
import com.messageProcessor.controllerTest.testMessageTypes.FriendDataMessage;
import org.flexunit.asserts.assertTrue;

public class TestFriendDataMessageProcessor extends MessageProcessor {
    public function TestFriendDataMessageProcessor() {
        super(FriendDataMessage);
    }

    [MessageHandler(checkField="cmd",checkValue="UPDATE_USER_DATA", messageRoot="friends")]
    public function processUserData(message:FriendDataMessage):void
    {
        if(message.isAppUser){
            assertTrue(message is AppUserMessage);
        }
    }
}
}
