/**
 * ClassHierarchy
 * @author Ilija Vankov
 */
package com.messageProcessor.utils
{

import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;
import flash.utils.getQualifiedSuperclassName;


/**
 * A ClassHierarchy instance is used to build and iterate trough class children, and their parents.
 *<br><br>
 * <b>Usage:</b><br>
 *     <listing>
 *         var classHierarchy:ClassHierarchy = new ClassHierarchy();
 *
 *         classHierarchy.addClass(MyClassChild1);
 *         classHierarchy.addClass(MyClassChild2);
 *         classHierarchy.addClass(MyClassChild3);
 *         classHierarchy.addClass(MyClassChild4);
 *
 *         classHierarchy.forAllChildren(MyClass, function(c:Class):Boolean {
 *             if(c is MyClassChild3){
 *                  return false;
 *             }
 *             return true;
 *         });
 *     </listing>
 */
public class ClassHierarchy
{
    private var _classIndex:Object = {};

    /**
     * Adds a given class to the class hierarchy, also adds and connects all of the given classes parents, only call this while creating the class hierarchy.<br>
     *<b>Note:</b> this method does not add all of the children of a given class, you have to add class children manually.
     *
     * @param c:<b>Class</b> the class to add to the hierarchy.
     */
    public function addClass(c:Class):void
    {
        var cn:String = getQualifiedClassName(c);
        var childClass:String = cn;
        var childClassHolder:ClassHolder;
        var currentClass:String = getQualifiedSuperclassName(c);

        if(!_classIndex.hasOwnProperty(cn))
            _classIndex[cn] = new ClassHolder(c);

        while(currentClass){

            if(!_classIndex.hasOwnProperty(currentClass)){
                addClass(Class(getDefinitionByName(currentClass)));
            }

            childClassHolder = _classIndex[childClass];

            if(childClassHolder && !ClassHolder(_classIndex[currentClass]).hasChild(childClassHolder)){
                ClassHolder(_classIndex[currentClass]).addChild(childClassHolder);
            }else{
                break;
            }

            childClass = currentClass;
            currentClass = getQualifiedSuperclassName(getDefinitionByName(currentClass));
        }
    }


    /**
     * Method to get all the children of a given class that are added to the current class hierarchy instance.
     *
     * @param c:<b>Class</b> the parent class of all children returned
     * @return <b>Vector.&lt;Class&gt;</b> a list of classes that represent the children of the given parent class, or null if that parent class is not added to the class hierarchy instance.
     */
    public function getClassChildren(c:Class):Vector.<Class> {
        var classHolder:ClassHolder = _classIndex[getQualifiedClassName(c)];

        if(!classHolder) return null;

        var returnVector:Vector.<Class> = new Vector.<Class>();

        var l:int = classHolder.children.length;
        for(var i:int = 0; i < l; i++){
            returnVector.push(classHolder.children[l].c);
        }

        return returnVector;
    }

    /**
     * Executes the callback function for all children of the passed parent class c, this method is faster then looping trough all the children yourself.
     *
     * @param c:<b>Class</b> the parent class of all the children that the callback method will be called for.
     * @param callback:<b>Function</b> the function to be called for each child, the function should accept a class as its first parameter (the current child class that it is called for),.
     *        the callback function doesn't need to return anything, but if it returns a Boolean value of <b>false</b> the loop of all classes will stop (same as doing <b>break</b> inside a while loop).
     */
    public function forAllChildren(c:Class, callback:Function):void {
        var classHolder:ClassHolder = _classIndex[getQualifiedClassName(c)];

        if(!classHolder) return;

        classHolder.forAllChildren(callback);
    }
}
}
