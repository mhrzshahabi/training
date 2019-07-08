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
        buttons: [isc.Button.create({title: "تائید"})],
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



function errorDialog(title,message,timeout){


    var di=isc.Dialog.create({
        message:message,
        icon: "[SKIN]stop.png",
        title:title,
        buttons: [isc.Button.create({title: "تائید"})],
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


