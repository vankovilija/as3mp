/**
 * BaseInventoryItemMessage
 * @author Ilija Vankov
 */
package com.messageProcessor.controllerTest.testMessageTypes {
import com.messageProcessor.SerializableData;

public class BaseInventoryItemMessage extends SerializableData {
    public var itemID:Number;
    public var name:String;
    public var description:String;
}
}
