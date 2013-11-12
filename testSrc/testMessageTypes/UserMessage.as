/**
 * UserMessage
 * @author Ilija Vankov
 */
package testMessageTypes {

public class UserMessage extends BaseMessage {
    public var user:UserDataMessage;
    public var friends:Vector.<FriendDataMessage>;
    public var inventoryItems:Vector.<BaseInventoryItemMessage>;
}
}
