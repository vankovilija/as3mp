/**
 * BaseInventoryItemMessage
 * @author Ilija Vankov
 */
package testMessageTypes {
import com.messageProcessor.SerializableData;

public class BaseInventoryItemMessage extends SerializableData {
    public var itemID:Number;
    public var name:String;
    public var description:String;
}
}
