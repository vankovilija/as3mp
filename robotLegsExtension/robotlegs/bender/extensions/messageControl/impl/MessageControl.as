/**
 * MessageControl
 * @author Ilija Vankov
 */
package robotlegs.bender.extensions.messageControl.impl {
import com.messageProcessor.MessageProcessor;
import com.messageProcessor.MessagesController;

import robotlegs.bender.extensions.messageControl.api.IMessageControl;
import robotlegs.bender.extensions.messageControl.api.ITypeRegister;
import robotlegs.bender.framework.api.IInjector;

public class MessageControl implements IMessageControl{

    private var _messagesController:MessagesController;
    private var _processors:Vector.<MessageProcessor>;

    [Inject]
    public var injector:IInjector;

    public function MessageControl() {
        _messagesController = new MessagesController();
        _processors = new Vector.<MessageProcessor>();
    }

    [PostConstruct]
    public function configure():void
    {
        var l:int = _processors.length;

        while(--l > -1){
            injector.injectInto(_processors[l]);
        }
    }

    public function mapProcessor(processorClass:Class):ITypeRegister {
        _messagesController.addProcessor(processorClass);
        _processors.push(_messagesController.getProcessorInstance(processorClass));
        return this;
    }

    public function registerDataType(type:Class):ITypeRegister {
        _messagesController.registerDataType(type);
        return this;
    }

    public function processMessage(message:Object, forceProcessor:* = null):IMessageControl {
        _messagesController.processMessage(message, forceProcessor);
        return this;
    }
}
}
