/**
 * TestFriendDataInjectedMessageProcessor
 * @author Ilija Vankov
 */
package testProcessors {
import org.flexunit.asserts.assertEquals;

import testMessageTypes.FriendDataMessage;

public class TestFriendDataInjectedMessageProcessor extends TestFriendDataMessageProcessor {

    [Inject]
    public var testStringInjection:String;

    public function TestFriendDataInjectedMessageProcessor() {
        super();
    }

    [MessageHandler(checkField="cmd", checkValue="UPDATE_USER_DATA", messageRoot="friends")]
    override public function processUserData(message:FriendDataMessage):void {
        super.processUserData(message);

        assertEquals(testStringInjection, "Testing injection");
    }
}
}
