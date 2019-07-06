function getFormulaMessage( message, font_size, font_color,font_type){

    if(font_type=="B" || font_type=="b" || font_type=="I" || font_type=="i" || font_type=="U" || font_type=="u" )
        return "<"+font_type+ "><font size=" + font_size +" color='" +font_color +"'>" +message+"</font>"+"</"+font_type+">"
    else
        return"<font size=" + font_size +" color='" +font_color +"'>" +message+"</font>"
}



function simpleMessage(title,message){


var x= isc.Dialog.create({
    message:message,
    icon: "[SKIN]ask.png",
    title:title,
    buttons: [isc.Button.create({title: "تائید"})],
    buttonClick: function (button, index) {
        this.close();
    }
});

}