/**
 * TestUserDataMessageProcessor
 * @author Ilija Vankov
 */
package com.messageProcessor.controllerTest.processors {
import com.messageProcessor.controllerTest.*;
import com.messageProcessor.*;
import com.messageProcessor.controllerTest.testMessageTypes.UserDataMessage;
import com.messageProcessor.serializers.DateFormatSerializer;

import org.flexunit.asserts.assertEquals;

public class TestUserDataMessageProcessor extends MessageProcessor {
    public function TestUserDataMessageProcessor() {
        super(UserDataMessage);
    }

    [MessageHandler(checkField="cmd",checkValue="UPDATE_USER_DATA", messageRoot="user")]
    public function processUserData(message:UserDataMessage):void
    {
        var ds:DateFormatSerializer = DateFormatSerializer.getByFormat("YYYY-MM-dd");
        assertEquals(sampleCommandProcessorMessage.user.facebook_id, message.facebook_id);
        assertEquals(sampleCommandProcessorMessage.user.name, message.name);
        assertEquals(sampleCommandProcessorMessage.user.dob, ds.serialize(message.dob));
    }
}
}
