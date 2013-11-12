/**
 * TestUserForcedInjectedMessageProcessor
 * @author Ilija Vankov
 */
package testProcessors {
import org.flexunit.asserts.assertEquals;

import testMessageTypes.UserMessage;

public class TestUserForcedInjectedMessageProcessor extends TestUserForcedMessageProcessor {

    [Inject]
    public var testStringInjection:String;

    public function TestUserForcedInjectedMessageProcessor() {
        super();
    }

    [MessageHandler]
    override public function processUserData(message:UserMessage):void
    {
        super.processUserData(message);

        assertEquals(testStringInjection, "Testing injection");
    }
}
}
