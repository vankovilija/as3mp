/**
 * DateFormatSerializer
 * @author Ilija Vankov
 */
package com.messageProcessor.serializers {

import com.messageProcessor.protocol.ISerializer;


/**
 * Internal class to serialize date values from a string.
 */
public class DateFormatSerializer implements ISerializer
{
    static private const YEAR:String = 'Y';
    static private const MONTH:String = 'M';
    static private const DATE:String = 'd';
    static private const HOUR:String = 'h';
    static private const MINUTE:String = 'm';
    static private const SECOND:String = 's';

    private var formatRegExp:RegExp;
    private var matchTable:Array;
    private var validTypes:Array = [
        'Y','M','d',
        'h','m','s'];

    static private var _dateFormatDict:Object = {};

    static public function getByFormat(format:String):DateFormatSerializer
    {
        if(_dateFormatDict.hasOwnProperty(format))
            return _dateFormatDict[format];

        _dateFormatDict[format] = new DateFormatSerializer(format);

        return _dateFormatDict[format];
    }

    public function DateFormatSerializer(format:String) {
        matchTable = [format];
        var formatArray:Array = format.split("");
        var l:int = formatArray.length;
        var i:int;
        var tempCase:String;
        var currentPattern:String = "";
        var currentCase:String = "";
        var currentCaseCount:int = 0;
        var regExString:String = "";
        for(i = 0; i < l; i++){
            tempCase = formatArray[i];
            if(currentCase != "" && currentCase == tempCase){
                currentCaseCount++;
                regExString += "\\d";
                currentPattern += tempCase;
                if(i == l-1){
                    regExString += ")";
                    matchTable.push(currentPattern);
                }
                continue;
            }
            if(currentCaseCount > 0){
                regExString += ")";
                matchTable.push(currentPattern);
                currentCase = "";
                currentPattern = "";
                currentCaseCount = 0;
            }
            if(validTypes.indexOf(tempCase) != -1){
                currentCase = tempCase;
                regExString += "(\\d";
                currentPattern = tempCase;
            } else {
                regExString += tempCase;
            }
        }
        formatRegExp = new RegExp(regExString);
    }

    public function getSerializerWithPriority(message:Object):ISerializer
    {
        return this;
    }

    public function deSerializeMessage(message:Object, returnObject:* = null):*
    {
        if(!returnObject)
            returnObject = new Date();
        if(!(returnObject is Date))
            throw new Error("Return object must be date!");

        var str:String = String(message);

        var matches : Array = str.match(formatRegExp);

        var d : Date = returnObject;

        var year:int = 2000;
        var month:int = 1;
        var date:int = 1;
        var hours:int = 0;
        var mins:int = 0;
        var seconds:int = 0;

        var i:int;
        var l:int = matches.length;
        if(l > matchTable.length){
            l = matchTable.length;
        }
        var matchType:String;
        var matchLength:int;
        for(i = 1; i < l; i++){
            matchType = matchTable[i].slice(0,1);
            matchLength = matchTable[i].length;

            switch (matchType){
                case YEAR:
                    if(matchLength == 2){
                        year = Number('20' + matches[i]);
                    }else if(matchLength >= 4){
                        year = Number(matches[i]);
                    }
                    break;
                case MONTH:
                    month = Number(matches[i]);
                    break;
                case DATE:
                    date = Number(matches[i]);
                    break;
                case HOUR:
                    hours = Number(matches[i]);
                    break;
                case MINUTE:
                    mins = Number(matches[i]);
                    break;
                case SECOND:
                    seconds = Number(matches[i]);
                    break;
                default:

            }
        }

        d.setUTCFullYear(year, month - 1, date);
        d.setUTCHours(hours, mins, seconds, 0);

        return returnObject;
    }

    public function getSerializationScore(message:Object):int{
        if(!(message is String)) return -1;

        if(!formatRegExp.test(String(message))) return -1;

        return 1;
    }

    public function serialize(object:*):Object
    {
        if(!(object is Date))
            throw new Error("Can only serialize dates");

        var d:Date = object;

        var dateString:String = matchTable[0];

        var year:int = d.getUTCFullYear();
        var month:int = (d.getUTCMonth() + 1);
        var date:int = d.getUTCDate();
        var hours:int = d.getUTCHours();
        var mins:int = d.getUTCMinutes();
        var seconds:int = d.getUTCSeconds();

        var i:int;
        var l:int = matchTable.length;
        var matchType:String;
        var matchCount:int;
        for(i = 1; i < l; i++){
            matchType = matchTable[i].slice(0,1);
            matchCount = matchTable[i].length;
            var workString:String;
            switch (matchType){
                case YEAR:
                    workString = String(year);
                    if(matchCount == 2){
                        workString = workString.slice(2);
                    }else if(matchCount == 5){
                        workString = "0" + workString;
                    }
                    break;
                case MONTH:
                    workString = String(month);
                    if(matchCount == 2 && workString.length < 2){
                        workString = "0" + workString;
                    }
                    break;
                case DATE:
                    workString = String(date);
                    if(matchCount == 2 && workString.length < 2){
                        workString = "0" + workString;
                    }
                    break;
                case HOUR:
                    workString = String(hours);
                    if(matchCount == 2 && workString.length < 2){
                        workString = "0" + workString;
                    }
                    break;
                case MINUTE:
                    workString = String(mins);
                    if(matchCount == 2 && workString.length < 2){
                        workString = "0" + workString;
                    }
                    break;
                case SECOND:
                    workString = String(seconds);
                    if(matchCount == 2 && workString.length < 2){
                        workString = "0" + workString;
                    }
                    break;
                default :
                    workString = "";
            }
            dateString = dateString.replace(matchTable[i], workString);
        }

        return dateString;
    }

    public function get format():String
    {
        return matchTable[0];
    }
}
}
