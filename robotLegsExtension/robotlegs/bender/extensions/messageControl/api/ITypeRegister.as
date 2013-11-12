/**
 * ITypeRegister
 * @author Ilija Vankov
 */
package robotlegs.bender.extensions.messageControl.api {
public interface ITypeRegister {
    function registerDataType(type:Class):ITypeRegister;
}
}
