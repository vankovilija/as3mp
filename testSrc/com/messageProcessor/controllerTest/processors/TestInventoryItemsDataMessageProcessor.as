/**
 * TestInventoryItemsDataMessageProcessor
 * @author Ilija Vankov
 */
package com.messageProcessor.controllerTest.processors {
import com.messageProcessor.controllerTest.*;
import com.messageProcessor.*;
import com.messageProcessor.controllerTest.testMessageTypes.BaseInventoryItemMessage;

import org.flexunit.asserts.assertEquals;

public class TestInventoryItemsDataMessageProcessor extends MessageProcessor {
    public function TestInventoryItemsDataMessageProcessor() {
        super(Vector.<BaseInventoryItemMessage>);
    }

    [MessageHandler(checkField="cmd",checkValue="UPDATE_USER_DATA", messageRoot="inventoryItems")]
    public function processUserData(message:Vector.<BaseInventoryItemMessage>):void
    {
        var l:int = message.length;

        while(--l > -1){
            assertEquals(message[l].itemID, sampleCommandProcessorMessage.inventoryItems[l].itemID);
            assertEquals(message[l].description, sampleCommandProcessorMessage.inventoryItems[l].description);
            assertEquals(message[l].name, sampleCommandProcessorMessage.inventoryItems[l].name);
        }
    }
}
}
