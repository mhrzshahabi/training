Number.prototype.padZero= function(len) {
    let str= String(this), zero= '0';
    len= len || 2;

    while(str.length < len)
        str= zero + str;

    return str;
};

const isDateReal=(input) => {
    if (input)
        return input.split('').map( function(e,i){ if(e === '/') return i;} ).filter(Boolean).length ==2 ? true : false;
};

const reformat = (input) => {
    if (isDateReal(input))
    {
        let sections=input.split('/');

        //year is valid?
        if (sections[0].length!=4)
            return;

        if (input.split('').length==8 || input.split('').length==9 ) {
            if (sections[1]==undefined || sections[2]==undefined) //webkit
                return;

            if (sections[1]=='' || sections[2]=='') //none webkit
                return;

            //violate day or month check
            if (parseInt(sections[1])>12 || parseInt(sections[1])==0)
                sections[1]="1";

            if (parseInt(sections[2])>31 || parseInt(sections[2])==0)
                sections[2]="1";

            sections[1] = Number(sections[1]).padZero();
            sections[2] = Number(sections[2]).padZero();

            return sections[0] + "/" + sections[1] + "/" + sections[2];
        }//end if
    }//end if
};

const arrangeDate = date => {
    if (!date)
        return;

    if (!date.includes(":")) {
        if (date.length == 1) {
            if (parseInt(date) == 0)
                return "01:00";
            else
                return "0" + date + ":00";
        }

        else if (date.length == 2) {
            if (date=="00"){
                return "01:00";
            } else if (parseInt(date) >= 24) {
                return "01:00";
            } else {
                return date + ":00";
            }
        }

        else if (date.length == 3) {
            if (date=="000"){
                return "01:00";
            }

            let hour=date.substring(0,1);
            let minute= date.substring(1,3);

            if (parseInt(hour)==0)
                hour="1";

            if (parseInt(minute) >= 60) {
                return "0"+hour+":59";
            } else {
                return "0"+hour+":"+minute;
            }
        }

        else if (date.length == 4) {
            if (date=="0000"){
                return "01:00";
            }

            let hour=date.substring(0,2);
            let minute= date.substring(2,4);

            if (hour=="00")
                hour="01";

            if (parseInt(hour)>=24)
                hour="23";

            if (parseInt(minute) >= 60) {
                return hour+":59";
            } else {
                return hour+":"+minute;
            }
        }

        else
            return "01:00";
    }//end :

    else {
        let sections = date.split(":");

        if (sections != null) {
            let hour = sections[0];
            let minute = sections[1];

            //arrange hour
            if (hour.length == 1) {

                if (hour==0){
                    hour="1";
                }

                hour = "0" + hour;
            } else {
                if (hour=="00")
                    hour="01";

                if (parseInt(hour) >= 23) {
                    hour="23";
                }
            }

            //arrange minute
            if (minute.length==0) {
                return hour + ":00";
            }

            else if (minute.length == 1) {
                minute = "0" + minute;
            } else {
                if (parseInt(minute) >= 60) {
                    minute = 59;
                }
            }

            return hour +":"+minute;
        }

        return date;
    }//end else
}//end arrangeDate