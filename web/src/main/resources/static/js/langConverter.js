var mapEn2Fa={
    "1":"۱", "2":"۲", "3":"۳", "4":"۴", "5":"۵", "6":"۶", "7":"۷", "8":"۸", "9":"۹","0":"۰", "-":"-", "=":"=",
    "@": "٬", "#": "٫", "^": "×", "&": "،", "*":"*", "~": "‍÷","`": "‍‍‍‍`", "_":"_","+":"+",
    "q": "ض", "w": "ص", "e": "ث", "r": "ق","t": "ف", "y": "غ", "u": "ع", "i": "ه", "o": "خ", "p": "ح", "[": "ج","]": "چ",
    "Q": "ض", "W": "ص", "E": "ث", "R": "ق","T": "ف", "Y": "غ", "U": "ع", "I":"}", "O":"{", "P": "ح", "{": "[", "}": "]",
    "a": "ش", "s": "س", "d": "ی", "f": "ب", "g": "ل", "h": "ا", "j": "ت", "k": "ن", "l": "م", ";": "ک", "'": "گ","|": "‍‍|",
    "A": "ش", "S": "س", "D": "ی", "F": "ب", "G": "ل", "H": "ا", "J": "ت", "K": "ن", "L": "م", ":": ":", "\"": "\"", "\\":"\\",
    "z": "ظ", "x": "ط", "c": "ز", "v": "ر", "b": "ذ", "n": "د", "m": "پ", ",": "و", ".": ".", "/": "/",
    "Z": "ظ", "X": "ط", "C": "ژ", "V": "ر", "B": "ذ", "N": "د", "M": "پ", "<": ">", ">": "<", "?": "؟",
};

var mapFa2En={
    "۰": "0", "۱": "1", "۲": "‍‍2", "۳": "3", "۴": "4", "۵": "5", "۶": "6", "۷": "7", "۸": "8", "۹": "9",

    "ض": "q", "ص": "w", "ث": "e", "ق": "r", "ف": "t","غ": "y","ع": "u","ه": "‍i","خ": "o","ح": "p","ج": "[","چ": "]",
    "[":"{", "]":"}",
    "ش": "a","س": "s","ی": "d","ب":"f","ل":"g","ا":"h","ت": "j","ن": "k","م": "l","ک": ";","گ": "'","پ": "\\",

    "ظ": "z","ط": "x","ز": "c","ر": "v","ذ": "b","د":"n","ئ":"m","و":","

};

/*function getKeyByValue(object, value) {
    return Object.keys(object).find(key => object[key] === value);
}*/

function convertEn2Fa(_1,_2,_3,blackList) {
    let len = 0;
    len=_3.length - 1;

    let tmpStr=_3.substring(0,len);

    if(mapEn2Fa[_3.charAt(len)]!= undefined && !blackList.includes(mapEn2Fa[_3.charAt(len)]) && !blackList.includes(mapEn2Fa[_3.charAt(len)]) != undefined) {
        tmpStr += mapEn2Fa[_3.charAt(len)];
        // _2.setHint("برای تجربه بهتر لطفا زبان کیبورد خود را به فارسی تغییر دهید!");
    }
    else if(mapFa2En[_3.charAt(len)]!= undefined && !blackList.includes(_3.charAt(len)) && !blackList.includes(_3.charAt(len)) != undefined) {
        tmpStr += _3.charAt(len);
        _2.setHint("");
    }else{}
        // _2.setHint("لطفا زبان کیبورد خود را به فارسی تغییر دهید!");
    _2.setValue(tmpStr);
}

function convertFa2En(_1,_2,_3,blackList) {
    let len = 0;
    len=_3.length - 1;

    let tmpStr=_3.substring(0,len);

    if(mapFa2En[_3.charAt(len)]!=undefined && !blackList.includes(mapFa2En[_3.charAt(len)]) && !blackList.includes(mapFa2En[_3.charAt(len)]) != undefined) {
        tmpStr += mapFa2En[_3.charAt(len)];
        // _2.setHint("برای تجربه بهتر لطفا زبان کیبورد خود را به انگلیسی تغییر دهید!");
    }
    else if(mapEn2Fa[_3.charAt(len)]!=undefined && !blackList.includes(_3.charAt(len)) && !blackList.includes(_3.charAt(len)) != undefined) {
        tmpStr += _3.charAt(len);
        // _2.setHint("");
    }else{}
        // _2.setHint("لطفا زبان کیبورد خود را به انگلیسی تغییر دهید!");
    _2.setValue(tmpStr);
}