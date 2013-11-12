/**
 * IMessageControl
 * @author Ilija Vankov
 */
package robotlegs.bender.extensions.messageControl.api {
public interface IMessageControl extends ITypeRegister{
    function mapProcessor(processorClass:Class):ITypeRegister;
    function processMessage(message:Object, forceProcessor:* = null):IMessageControl
}
}
