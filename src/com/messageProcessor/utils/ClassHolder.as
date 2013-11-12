/**
 * ClassHolder
 * @author Ilija Vankov
 */
package com.messageProcessor.utils
{

import flash.utils.getQualifiedClassName;


/**
 * Internal class for holding the class hierarchy children and class object
 */
internal class ClassHolder
{
    private var _c:Class;
    private var _className:String;
    private var _children:Vector.<ClassHolder>;
    private var _childClassIndex:Object;

    public function ClassHolder(c:Class)
    {
        _children = new Vector.<ClassHolder>();
        _childClassIndex = {};
        _c = c;
        _className = getQualifiedClassName(c);
    }

    public function addChild(child:ClassHolder):void
    {
        if(hasChild(child)) return;

        _children.push(child);
        _childClassIndex[child.className] = child;
    }

    public function hasChild(child:ClassHolder):Boolean
    {
        return _children.indexOf(child) != -1;
    }

    public function forAllChildren(callback:Function):Boolean
    {
        var l:int = _children.length;

        for(var i:int = 0; i < l; i++){
            if(callback.apply(null, [_children[i].c]) === false) return false;
            if(_children[i].forAllChildren(callback) === false) return false;
        }

        return true;
    }

    public function get children():Vector.<ClassHolder>
    {
        return _children;
    }

    public function get c():Class
    {
        return _c;
    }

    public function get className():String
    {
        return _className;
    }
}
}
