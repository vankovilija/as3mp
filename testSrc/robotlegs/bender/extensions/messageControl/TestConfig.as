/**
 * TestConfig
 * @author Ilija Vankov
 */
package robotlegs.bender.extensions.messageControl {
import robotlegs.bender.extensions.messageControl.api.IMessageControl;
import robotlegs.bender.framework.api.IConfig;
import robotlegs.bender.framework.api.IInjector;

import testMessageTypes.AppUserMessage;

import testProcessors.TestUserForcedInjectedMessageProcessor;

public class TestConfig implements IConfig {
    [Inject]
    public var messageControl:IMessageControl;

    [Inject]
    public var injector:IInjector;

    public function configure():void {
        messageControl.mapProcessor(TestUserForcedInjectedMessageProcessor);
        messageControl.registerDataType(AppUserMessage);
        var testString:String = "Testing injection";
        injector.map(String).toValue(testString);
    }
}
}
