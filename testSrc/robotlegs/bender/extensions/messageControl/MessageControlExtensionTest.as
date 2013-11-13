/**
 * MessageControlExtensionTest
 * @author Ilija Vankov
 */
package robotlegs.bender.extensions.messageControl {
import flexunit.framework.Assert;

import org.flexunit.async.Async;

import robotlegs.bender.extensions.messageControl.api.IMessageControl;
import robotlegs.bender.framework.api.LifecycleEvent;
import robotlegs.bender.framework.impl.Context;

import sampleData.sampleCommandProcessorMessage;

import sampleData.sampleForcedProcessorMessage;

import testProcessors.TestFriendDataInjectedMessageProcessor;

import testProcessors.TestUserForcedInjectedMessageProcessor;

public class MessageControlExtensionTest {

    private var _context:Context;

    public function MessageControlExtensionTest() {
    }

    [Before]
    public function setUp():void {
        _context = new Context();
        _context.install(MessageControlExtension);
        _context.configure(TestConfig);
    }

    [Test(async)]
    public function testMessageControlExtension():void {
        var asyncHandler:Function = Async.asyncHandler( this, startTest, 1000, null, handleTimeout );

        _context.addEventListener(LifecycleEvent.POST_INITIALIZE, asyncHandler);

        _context.initialize();
    }

    private function handleTimeout( passThroughData:Object ):void {
        Assert.fail("Timeout reached, the robotlegs context was not initialized on time!");
    }

    private function startTest(event:LifecycleEvent = null, passThroughData:Object = null ):void {
        var mc:IMessageControl = IMessageControl(_context.injector.getInstance(IMessageControl));
        mc.processMessage(sampleForcedProcessorMessage, TestUserForcedInjectedMessageProcessor);
        mc.mapProcessor(TestFriendDataInjectedMessageProcessor);
        mc.processMessage(sampleCommandProcessorMessage);
    }

    [After]
    public function tearDown():void {

    }
}
}
