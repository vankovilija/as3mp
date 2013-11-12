/**
 * TestUserDataMessageProcessor
 * @author Ilija Vankov
 */
package testProcessors {
import com.messageProcessor.controllerTest.*;
import com.messageProcessor.*;
import testMessageTypes.UserDataMessage;
import com.messageProcessor.serializers.DateFormatSerializer;

import org.flexunit.asserts.assertEquals;

import sampleData.sampleCommandProcessorMessage;

public class TestUserDataMessageProcessor extends MessageProcessor {
    public function TestUserDataMessageProcessor() {
        super(UserDataMessage);
    }

    [MessageHandler(checkField="user.type",checkValue="UserData", messageRoot="user")]
    public function processUserData(message:UserDataMessage):void
    {
        var ds:DateFormatSerializer = DateFormatSerializer.getByFormat("YYYY-MM-dd");
        assertEquals(sampleCommandProcessorMessage.user.facebook_id, message.facebook_id);
        assertEquals(sampleCommandProcessorMessage.user.name, message.name);
        assertEquals(sampleCommandProcessorMessage.user.dob, ds.serialize(message.dob));
    }
}
}
