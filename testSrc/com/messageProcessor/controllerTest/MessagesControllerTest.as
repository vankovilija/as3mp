/**
 * MessagesControllerTest
 * @author Ilija Vankov
 */
package com.messageProcessor.controllerTest {
import com.messageProcessor.*;
import com.messageProcessor.controllerTest.processors.TestFriendDataMessageProcessor;
import com.messageProcessor.controllerTest.processors.TestInventoryItemsDataMessageProcessor;
import com.messageProcessor.controllerTest.processors.TestUserDataMessageProcessor;
import com.messageProcessor.controllerTest.processors.TestUserForcedMessageProcessor;
import com.messageProcessor.controllerTest.testMessageTypes.AppUserMessage;
import com.messageProcessor.controllerTest.testMessageTypes.AttackItemMessage;
import com.messageProcessor.controllerTest.testMessageTypes.DefenceItemMessage;
import com.messageProcessor.controllerTest.testMessageTypes.HealItemMessage;
import com.messageProcessor.controllerTest.testMessageTypes.RangeAttackItemMessage;
import com.messageProcessor.controllerTest.testMessageTypes.RangeHealItemMessage;

public class MessagesControllerTest {

    static private var _controller:MessagesController;

    public function MessagesControllerTest() {
    }

    [BeforeClass]
    static public function setUp():void {
        _controller = new MessagesController();
    }

    [Test( description="This tests registering data types", order=1 )]
    public function testRegisterDataType():void {
        _controller.registerDataType(AppUserMessage);
        _controller.registerDataType(AttackItemMessage);
        _controller.registerDataType(RangeAttackItemMessage);
        _controller.registerDataType(HealItemMessage);
        _controller.registerDataType(RangeHealItemMessage);
        _controller.registerDataType(DefenceItemMessage);
    }

    [Test( description="This tests adding of processors", order=2 )]
    public function testAddProcessor():void {
        _controller.addProcessor(TestUserForcedMessageProcessor);
        _controller.addProcessor(TestUserDataMessageProcessor);
        _controller.addProcessor(TestFriendDataMessageProcessor);
        _controller.addProcessor(TestInventoryItemsDataMessageProcessor);
    }

    [Test( description="This tests processing of actual ambiguous objects to native types", order=3 )]
    public function testProcessObject():void {
        _controller.processObject(sampleForcedProcessorMessage, TestUserForcedMessageProcessor);
        _controller.processObject(sampleCommandProcessorMessage);
    }

    [AfterClass]
    static public function tearDown():void {
        _controller = null;
    }
}
}
