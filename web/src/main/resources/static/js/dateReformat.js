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