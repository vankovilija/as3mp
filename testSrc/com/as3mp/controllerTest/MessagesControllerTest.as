/**
 * MessagesControllerTest
 * @author Ilija Vankov
 */
package com.as3mp.controllerTest {
import com.as3mp.*;
import testProcessors.TestFriendDataMessageProcessor;
import testProcessors.TestInventoryItemsDataMessageProcessor;
import testProcessors.TestUserDataMessageProcessor;
import testProcessors.TestUserForcedMessageProcessor;
import testMessageTypes.AppUserMessage;
import testMessageTypes.AttackItemMessage;
import testMessageTypes.DefenceItemMessage;
import testMessageTypes.HealItemMessage;
import testMessageTypes.RangeAttackItemMessage;
import testMessageTypes.RangeHealItemMessage;

import sampleData.sampleCommandProcessorMessage;
import sampleData.sampleForcedProcessorMessage;

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

    [Test( description="This tests adding of testProcessors", order=2 )]
    public function testAddProcessor():void {
        _controller.addProcessor(TestUserForcedMessageProcessor);
        _controller.addProcessor(TestUserDataMessageProcessor);
        _controller.addProcessor(TestFriendDataMessageProcessor);
        _controller.addProcessor(TestInventoryItemsDataMessageProcessor);
    }

    [Test( description="This tests processing of actual ambiguous objects to native types", order=3 )]
    public function testProcessObject():void {
        _controller.processMessage(sampleForcedProcessorMessage, TestUserForcedMessageProcessor);
        _controller.processMessage(sampleCommandProcessorMessage);
    }

    [AfterClass]
    static public function tearDown():void {
        _controller = null;
    }
}
}
