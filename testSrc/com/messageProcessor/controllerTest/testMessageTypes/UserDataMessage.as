/**
 * UserDataMessage
 * @author Ilija Vankov
 */
package com.messageProcessor.controllerTest.testMessageTypes {
import com.messageProcessor.SerializableData;
import com.messageProcessor.SerializableDate;

public class UserDataMessage extends SerializableData {
    public var facebook_id:Number;
    public var name:String;

    [MessageBinding(dateFormat="YYYY-MM-dd")]
    public var dob:Date;
}
}
