/**
 * UserDataMessage
 * @author Ilija Vankov
 */
package testMessageTypes {
import com.as3mp.SerializableData;
import com.as3mp.SerializableDate;

public class UserDataMessage extends SerializableData {
    public var facebook_id:Number;
    public var name:String;

    [MessageBinding(dateFormat="YYYY-MM-dd")]
    public var dob:Date;
}
}
