function getFormulaMessage( message, font_size, font_color,font_type){

    if(font_type=="B" || font_type=="b" || font_type=="I" || font_type=="i" || font_type=="U" || font_type=="u" )
        return "<"+font_type+ "><font size=" + font_size +" color='" +font_color +"'>" +message+"</font>"+"</"+font_type+">"
    else
        return"<font size=" + font_size +" color='" +font_color +"'>" +message+"</font>"
}



function simpleDialog(title,message,timeout,dialogType){


    var di=isc.Dialog.create({
        message:message,
        icon: "[SKIN]"+dialogType+".png",
        title:title,
        buttons: [isc.IButtonSave.create({title: "تائید"})],
        buttonClick: function (button, index) {
            di.close();
        }

    });
    if(timeout>0){
        setTimeout(function () {
            di.close();
        }, timeout);


    }

}



function yesNoDialog(title,message,timeout,dialogType,retIndex){
    var retIndex=6;
    var ynd=isc.Dialog.create({
        message:message,
        icon: "[SKIN]"+dialogType+".png",
        title:title,
        buttons: [isc.IButtonSave.create({title: "بله"}),isc.IButtonCancel.create({title: "خیر"})],
        buttonClick: function (button, index) {
            retIndex = index;
            ynd.close();
        },
    });
    if(timeout>0){
        setTimeout(function () {
            ynd.close();
        }, timeout);
    };
}
function courseCounterCode(n) {


    var m=parseInt(n)+1;
    if(m<10 && m>0) {
        return "000" +m;
    }

    if(m<100) {
        return "00" +m;
    }

    if(m<1000) {
        return "0" +m;
    }

    if(m<10000) {
        return m;
    }
    return "error";



}

