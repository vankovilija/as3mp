/**
 * TestUserForcedMessageProcessor
 * @author Ilija Vankov
 */
package testProcessors {
import com.messageProcessor.controllerTest.*;
import com.messageProcessor.*;
import testMessageTypes.AppUserMessage;
import testMessageTypes.AttackItemMessage;
import testMessageTypes.DefenceItemMessage;
import testMessageTypes.HealItemMessage;
import testMessageTypes.RangeAttackItemMessage;
import testMessageTypes.RangeHealItemMessage;
import testMessageTypes.UserMessage;
import com.messageProcessor.serializers.DateFormatSerializer;
import sampleData.sampleForcedProcessorMessage;

import org.flexunit.asserts.assertEquals;

public class TestUserForcedMessageProcessor extends MessageProcessor {
    public function TestUserForcedMessageProcessor() {
        super(UserMessage);
    }

    [MessageHandler]
    public function processUserData(message:UserMessage):void
    {
        var ds:DateFormatSerializer = DateFormatSerializer.getByFormat("YYYY-MM-dd");
        assertEquals(sampleForcedProcessorMessage.status_code, message.status_code);
        assertEquals(sampleForcedProcessorMessage.message_id, message.message_id);
        assertEquals(sampleForcedProcessorMessage.user.facebook_id, message.user.facebook_id);
        assertEquals(sampleForcedProcessorMessage.user.name, message.user.name);
        assertEquals(sampleForcedProcessorMessage.user.dob, ds.serialize(message.user.dob));

        var l:int = message.friends.length;
        while(--l > -1){
            assertEquals(sampleForcedProcessorMessage.friends[l].facebook_id, message.friends[l].facebook_id);
            assertEquals(sampleForcedProcessorMessage.friends[l].name, message.friends[l].name);
            assertEquals(sampleForcedProcessorMessage.friends[l].isAppUser, message.friends[l].isAppUser);
            assertEquals(sampleForcedProcessorMessage.friends[l].dob, ds.serialize(message.friends[l].dob));
            if(message.friends[l].isAppUser){
                assertEquals(sampleForcedProcessorMessage.friends[l].score, AppUserMessage(message.friends[l]).score);
            }
        }

        l = message.inventoryItems.length;
        while(--l > -1){
            assertEquals(sampleForcedProcessorMessage.inventoryItems[l].itemID, message.inventoryItems[l].itemID);
            assertEquals(sampleForcedProcessorMessage.inventoryItems[l].name, message.inventoryItems[l].name);
            assertEquals(sampleForcedProcessorMessage.inventoryItems[l].description, message.inventoryItems[l].description);
            if(message.inventoryItems[l] is AttackItemMessage){
                assertEquals(sampleForcedProcessorMessage.inventoryItems[l].attackPower, AttackItemMessage(message.inventoryItems[l]).attackPower);
                assertEquals(sampleForcedProcessorMessage.inventoryItems[l].type, AttackItemMessage(message.inventoryItems[l]).type);
            }else if(message.inventoryItems[l] is HealItemMessage){
                assertEquals(sampleForcedProcessorMessage.inventoryItems[l].healAmount, HealItemMessage(message.inventoryItems[l]).healAmount);
            }else if(message.inventoryItems[l] is DefenceItemMessage){
                assertEquals(sampleForcedProcessorMessage.inventoryItems[l].defenceAmount, DefenceItemMessage(message.inventoryItems[l]).defenceAmount);
                assertEquals(sampleForcedProcessorMessage.inventoryItems[l].type, DefenceItemMessage(message.inventoryItems[l]).type);
            }else if(message.inventoryItems[l] is RangeAttackItemMessage){
                assertEquals(sampleForcedProcessorMessage.inventoryItems[l].attackPower, RangeAttackItemMessage(message.inventoryItems[l]).attackPower);
                assertEquals(sampleForcedProcessorMessage.inventoryItems[l].type, RangeAttackItemMessage(message.inventoryItems[l]).type);
                assertEquals(sampleForcedProcessorMessage.inventoryItems[l].range, RangeAttackItemMessage(message.inventoryItems[l]).range);
            }else if(message.inventoryItems[l] is RangeHealItemMessage){
                assertEquals(sampleForcedProcessorMessage.inventoryItems[l].healAmount, RangeHealItemMessage(message.inventoryItems[l]).healAmount);
                assertEquals(sampleForcedProcessorMessage.inventoryItems[l].range, RangeHealItemMessage(message.inventoryItems[l]).range);
            }
        }
    }
}
}
