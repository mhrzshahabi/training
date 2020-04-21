var mapEn2Fa={
    "q": "ض", "w": "ص", "e": "ث", "r": "ق",
    "t": "ف", "y": "غ", "u": "ع", "i": "ه",
    "o": "خ", "p": "ح", "[": "}", "{": "ج",
    "]": "{", "}": "چ", "|": "‍‍|", "`": "‍‍‍‍`",
    "~": "‍÷", "a": "ش", "s": "س", "d": "ی",
    "f": "ب", "g": "ل", "h": "ا", "j": "ت",
    "k": "ن", "l": "م", ";": "ک", ":": ":",
    "'": "گ", "\"": "\"", "z": "ظ", "x": "ط",
    "c": "ز", "C": "ژ", "v": "ر", "b": "ذ",
    "n": "د", "m": "پ", ",": "و", "<": ">",
    ".": ".", ">": "<", "/": "/", "?": "؟",
    "@": "٬", "#": "٫", "^": "×", "&": "،",
    "0":"۰", "1":"۱", "2":"۲", "3":"۳",
    "4":"۴", "5":"۵", "6":"۶", "7":"۷",
    "8":"۸", "9":"۹"
};

var mapFa2En={
    "ض": "q", "ص": "w", "ث": "e", "ق": "r",
    "ف": "t", "ت": "j", "۰": "0",
    "غ": "y", "ن": "k", "۱": "1",
    "ع": "u", "م": "l", "۲": "‍‍2",
    "ه": "‍i", "ک": ";", "۳": "3",
    "خ": "o", "گ": "'", "۴": "4",
    "ح": "p", "پ": "\\", "۵": "5",
    "ج": "[", "ظ": "z", "۶": "6",
    "چ": "]", "ط": "x", "۷": "7",
    "ش": "a", "ز": "c", "۸": "8",
    "س": "s", "ر": "v", "۹": "9",
    "ی": "d", "ذ": "b",
    "ب":"f", "د":"n",
    "ل":"g", "ئ":"m",
    "ا":"h", "و":","
};

/*function getKeyByValue(object, value) {
    return Object.keys(object).find(key => object[key] === value);
}*/

function convertEn2Fa(_1,_2,_3) {
    let len=_3.length;
    let tmpStr="";

    for (let i=0;i<len;i++){
        if(mapEn2Fa[_3.charAt(i)]!=undefined)
            tmpStr+=mapEn2Fa[_3.charAt(i)];
        else
            tmpStr+=_3.charAt(i);
    }

    _2.setValue(tmpStr);
}

function convertFa2En(_1,_2,_3) {
    let len=_3.length;
    let tmpStr="";

    for (let i=0;i<len;i++){
        if(mapFa2En[_3.charAt(i)]!=undefined)
            tmpStr+=mapFa2En[_3.charAt(i)];
        else
            tmpStr+=_3.charAt(i);
    }

    _2.setValue(tmpStr);
}