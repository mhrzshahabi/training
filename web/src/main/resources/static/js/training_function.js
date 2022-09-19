function getFormulaMessage(message, font_size, font_color, font_type) {

    if (font_type == "B" || font_type == "b" || font_type == "I" || font_type == "i" || font_type == "U" || font_type == "u")
        return "<" + font_type + "><font size=" + font_size + " color='" + font_color + "'>" + message + "</font>" + "</" + font_type + ">"
    else
        return "<font size=" + font_size + " color='" + font_color + "'>" + message + "</font>"
}

function simpleDialog(title, message, timeout, dialogType) {
    let di = isc.Dialog.create({
        message: message,
        icon: "[SKIN]" + dialogType + ".png",
        title: title,
        buttons: [isc.IButtonSave.create({title: "تائید"})],
        buttonClick: function (button, index) {
            di.close();
        }

    });
    if (timeout > 0) {
        setTimeout(function () {
            di.close();
        }, timeout);
    }
}

function yesNoDialog(title, message, timeout, dialogType, retIndex = 6) {
    let ynd = isc.Dialog.create({
        message: message,
        icon: "[SKIN]" + dialogType + ".png",
        title: title,
        buttons: [isc.IButtonSave.create({title: "بله"}), isc.IButtonCancel.create({title: "خیر"})],
        buttonClick: function (button, index) {
            retIndex = index;
            ynd.close();
        },
    });
    if (timeout > 0) {
        setTimeout(function () {
            ynd.close();
        }, timeout);
    }
}

function courseCounterCode(n) {

    var m = parseInt(n) + 1;
    if (m < 10 && m > 0) {
        return "00" + m;
    }

    if (m < 100) {
        return "0" + m;
    }

    if (m < 1000) {
        return m;
    }

    return "error";

}

function defineWindowsEditNeedsAssessment(grid = null) {
    const Window_NeedsAssessment_Edit = isc.Window.create({
        ID: "Window_NeedsAssessment_Edit",
        title: "ویرایش نیازسنجی",
        minWidth: 1024,
        visibility : "hidden",
        headerControls: ["headerLabel", "minimizeButton", "maximizeButton", "closeButton"],
        canDragReposition: true,
        items: [isc.ViewLoader.create({autoDraw: true, viewURL: "web/edit-needs-assessment/"})],
        // items: [isc.ViewLoader.create({autoDraw: true, viewURL: "web/diff-needs-assessment/"})],
        placement: "fillScreen",
        showUs(record, objectType,isGap) {
            loadEditNeedsAssessment(record, objectType,"R&W",isGap);
            // loadDiffNeedsAssessment(record, objectType);
            hasChanged = false;
            this.Super("show", arguments);
        },
        close(x = 1){
            if(typeof(Window_AddCompetence) !== "undefined") {
                Window_AddCompetence.close();
            }
            if(x===1) {
                if (hasChanged) {
                    if(!canSendToWorkFlowNA){
                        createDialog("info", "لطفا برای ارسال به گردش کار از کارتابل خود اقدام نمایید.")
                        Window_NeedsAssessment_Edit.Super("close", arguments);
                        if(grid != null) {
                            grid.invalidateCache();
                        }
                    }else{
                        const dialog = isc.Dialog.create({
                            ID: "dialog",
                            icon: 'info.png',
                            title: "پیغام",
                            message: "تغییراتی در پنجره ویرایش نیازسنجی ثبت شده است لطفا یکی از گزینه های زیر را با توجه به تغییرات اعمال شده انتخاب کنید.",
                            buttons: [
                                isc.Button.create({ title:"ارسال به گردش کار"}),
                                isc.Button.create({title: "لغو تغییرات"}),
                                isc.Button.create({title: "خروج از نیازسنجی"}),
                            ],
                            buttonClick: function (button, index) {
                                dialog.close();
                                switch (index) {
                                    case 0:
                                        saveAndSendToWorkFlow()
                                        break;
                                    case 1:
                                        CancelChange_JspENA.click();
                                        break;
                                    case 2:
                                        Window_NeedsAssessment_Edit.Super("close", arguments);
                                        if(grid != null) {
                                            grid.invalidateCache();
                                        }
                                        break;
                                }
                            }
                        });
                    }
                } else {
                    Window_NeedsAssessment_Edit.Super("close", arguments);
                    if(grid != null) {
                        grid.invalidateCache();
                    }
                }
            }
            else{
                if(grid != null) {
                    grid.invalidateCache();
                }
                this.Super("close",arguments);
            }
        },
    });
}
function defineWindowsEditNeedsAssessmentForGap(grid = null) {
    const Window_NeedsAssessment_Edit_Gap = isc.Window.create({
        ID: "Window_NeedsAssessment_Edit_Gap",
        title: "ویرایش نیازسنجی",
        minWidth: 1024,
        visibility : "hidden",
        headerControls: ["headerLabel", "minimizeButton", "maximizeButton", "closeButton"],
        canDragReposition: true,
        items: [isc.ViewLoader.create({autoDraw: true, viewURL: "web/edit-needs-assessment-gap/"})],
        // items: [isc.ViewLoader.create({autoDraw: true, viewURL: "web/diff-needs-assessment/"})],
        placement: "fillScreen",
        showUs(record, objectType,isGap) {
            loadEditNeedsAssessmentGap(record, objectType,"R&W",isGap);
            // loadDiffNeedsAssessment(record, objectType);
            // hasChanged = false;
            this.Super("show", arguments);
        },
        // close(x = 1){
        //     if(typeof(Window_AddCompetence) !== "undefined") {
        //         Window_AddCompetence.close();
        //     }
        //     if(x===1) {
        //         if (hasChanged) {
        //             if(!canSendToWorkFlowNA){
        //                 createDialog("info", "لطفا برای ارسال به گردش کار از کارتابل خود اقدام نمایید.")
        //                 Window_NeedsAssessment_Edit_Gap.Super("close", arguments);
        //                 if(grid != null) {
        //                     grid.invalidateCache();
        //                 }
        //             }else{
        //                 const dialog = isc.Dialog.create({
        //                     ID: "dialog",
        //                     icon: 'info.png',
        //                     title: "پیغام",
        //                     message: "تغییراتی در پنجره ویرایش نیازسنجی ثبت شده است لطفا یکی از گزینه های زیر را با توجه به تغییرات اعمال شده انتخاب کنید.",
        //                     buttons: [
        //                         isc.Button.create({ title:"ارسال به گردش کار"}),
        //                         isc.Button.create({title: "لغو تغییرات"}),
        //                         isc.Button.create({title: "خروج از نیازسنجی"}),
        //                     ],
        //                     buttonClick: function (button, index) {
        //                         dialog.close();
        //                         switch (index) {
        //                             case 0:
        //                                 saveAndSendToWorkFlow()
        //                                 break;
        //                             case 1:
        //                                 CancelChange_JspENA.click();
        //                                 break;
        //                             case 2:
        //                                 Window_NeedsAssessment_Edit_Gap.Super("close", arguments);
        //                                 if(grid != null) {
        //                                     grid.invalidateCache();
        //                                 }
        //                                 break;
        //                         }
        //                     }
        //                 });
        //             }
        //         } else {
        //             Window_NeedsAssessment_Edit_Gap.Super("close", arguments);
        //             if(grid != null) {
        //                 grid.invalidateCache();
        //             }
        //         }
        //     }
        //     else{
        //         if(grid != null) {
        //             grid.invalidateCache();
        //         }
        //         this.Super("close",arguments);
        //     }
        // },
    });
}

function defineWindow_NeedsAssessment_all_competence_gap(grid = null) {
    const Window_NeedsAssessment_all_competence_gap = isc.Window.create({
        ID: "Window_NeedsAssessment_all_competence_gap",
        title: "نمای کلی  نیازسنجی بر اساس گپ شایستگی",
        minWidth: 1024,
        visibility : "hidden",
        headerControls: ["headerLabel", "minimizeButton", "maximizeButton", "closeButton"],
        canDragReposition: true,
        items: [isc.ViewLoader.create({autoDraw: true, viewURL: "web/needs-assessment-all-competence-gap/"})],
        placement: "fillScreen",
        showUs(record, objectType,isGap) {
            loadEditNeedsAssessmentAllCompeteceGap(record, objectType);
            hasChanged = false;
            this.Super("show", arguments);
        },

    });
}

function setColorForListGrid(record) {
    if (record.competenceCount === 0)
        return "color:red";
    if (record.lastModifiedDateNA !== "آپ دیت نشده")
        return "color:green";
}

function defineWindowTreeNeedsAssessment() {
    let Window_NeedsAssessment_Tree = isc.Window.create({
        ID: "Window_NeedsAssessment_Tree",
        title: "درخت نیازسنجی",
        placement: "fillScreen",
        headerControls: ["headerLabel", "closeButton"],
        canDragReposition: false,
        visibility : "hidden",
        minWidth: 1024,
        items: [isc.ViewLoader.create({autoDraw: true, viewURL: "web/tree-needs-assessment/"})],
        showUs(record, objectType) {
            loadNeedsAssessmentTree(record, objectType);
            this.Super("show", arguments);
        },
    });
}

function showWindowDiffNeedsAssessment(objectId, objectType, objectDescription = null, unchangeable = false) {
    wait.show();
    let Window_NeedsAssessment_Diff = isc.Window.create({
        ID: "Window_NeedsAssessment_Diff",
        title: "اختلاف نیازسنجی",
        placement: "fillScreen",
        visibility : "hidden",
        headerControls: ["headerLabel", "closeButton"],
        canDragReposition: false,
        minWidth: 1024,
        items: [isc.ViewLoader.create({autoDraw: true, viewURL: "web/diff-needs-assessment/"})],
        showUs(id, type) {
            loadDiffNeedsAssessment(id, type,objectDescription,"read");
            this.Super("show", arguments);
        },
    });
    let interval = setInterval(()=>{
        if(Window_NeedsAssessment_Diff != null) {
            clearInterval(interval);
            Window_NeedsAssessment_Diff.showUs(objectId, objectType);
        }
    wait.close();
    },1000)
    }

function showDetailViewer(title, field, record) {
    let Window_DetailViewer_Main = isc.Window.create({
        ID: "Window_DetailViewer_Main",
        title: title,
        // placement: "fillScreen",
        visibility : "hidden",
        // autoCenter: false,
        // isModal: false,
        headerControls: ["headerLabel", "closeButton"],
        // canDragReposition: false,
        // minWidth: 1024,
        items: [isc.DetailViewer.create({
            fields: field,
            minWidth: 150,
            data: record,
            // autoFetchData: true,
            // width: 700
        })],
    });
    Window_DetailViewer_Main.show();
}

function showOrganizationalChart(func, x = "show") {
    let Window_OrganizationalChart = isc.Window.create({
        ID: "Window_OrganizationalChart",
        title: "درخت نیازسنجی",
        placement: "fillScreen",
        headerControls: ["headerLabel", "closeButton"],
        canDragReposition: false,
        visibility : "hidden",
        minWidth: 1024,
        items: [isc.ViewLoader.create({autoDraw: true, viewURL: "web/organizationalChart/"})],
        close() {
            func();
            VLayout_chosen_Departments.hide();
            this.Super("close", arguments)
        }
    });
    Window_OrganizationalChart.show();

    const interval = setInterval(()=>{
        if(VLayout_chosen_Departments !== undefined) {
            if(x !== "show") {
                VLayout_chosen_Departments.hide();
            }
            else {
                VLayout_chosen_Departments.show();
            }
            clearInterval(interval);
        }
    },100)
}

var peopleTypeMap ={
    "Personal" : "شرکتی",
    "ContractorPersonal" : "پیمان کار",
    // "Company" : "شرکتی",
    // "OrgCostCenter" : "پیمان کار"
};
var priorityList = {
    "Post": "پست انفرادی",
    "PostGroup": "گروه پستی",
    "Job": "شغل",
    "JobGroup": "گروه شغلی",
    "PostGrade": "رده پستی",
    "PostGradeGroup": "گروه رده پستی",
    "TrainingPost": "پست"
};
function checkSelectedRecord(lg) {
    if(lg == null || lg.getSelectedRecord() == null){
        createDialog("info", "رکوردی انتخاب نشده است!");
        return false;
    }
    else{
        return true;
    }
};



"use strict";var delimiter=" و ",zero="صفر",negative="منفی ",letters=[["","یک","دو","سه","چهار","پنج","شش","هفت","هشت","نه"],["ده","یازده","دوازده","سیزده","چهارده","پانزده","شانزده","هفده","هجده","نوزده","بیست"],["","","بیست","سی","چهل","پنجاه","شصت","هفتاد","هشتاد","نود"],["","یکصد","دویست","سیصد","چهارصد","پانصد","ششصد","هفتصد","هشتصد","نهصد"],[""," هزار"," میلیون"," میلیارد"," بیلیون"," بیلیارد"," تریلیون"," تریلیارد"," کوآدریلیون"," کادریلیارد"," کوینتیلیون"," کوانتینیارد"," سکستیلیون"," سکستیلیارد"," سپتیلیون"," سپتیلیارد"," اکتیلیون"," اکتیلیارد"," نانیلیون"," نانیلیارد"," دسیلیون"," دسیلیارد"]],decimalSuffixes=["","","","","","","","","","","",""],prepareNumber=function(e){var r=e;"number"==typeof r&&(r=r.toString());var t=r.length%3;return 1===t?r="00".concat(r):2===t&&(r="0".concat(r)),r.replace(/\d{3}(?=\d)/g,"$&*").split("*")},threeNumbersToLetter=function(e){if(0===parseInt(e,0))return"";var r=parseInt(e,0);if(r<10)return letters[0][r];if(r<=20)return letters[1][r-10];if(r<100){var t=r%10,n=(r-t)/10;return t>0?letters[2][n]+delimiter+letters[0][t]:letters[2][n]}var i=r%10,s=(r-r%100)/100,u=(r-(100*s+i))/10,a=[letters[3][s]],l=10*u+i;return l>0&&(l<10?a.push(letters[0][l]):l<=20?a.push(letters[1][l-10]):(a.push(letters[2][u]),i>0&&a.push(letters[0][i]))),a.join(delimiter)},convertDecimalPart=function(e){return""===(e=e.replace(/0*$/,""))?"":(e.length>11&&(e=e.substr(0,11))," پوینت "+Num2persian(e)+" "+decimalSuffixes[e.length])},Num2persian=function(e){e=e.toString().replace(/[^0-9.-]/g,"");var r=!1,t=parseFloat(e);if(isNaN(t))return zero;if(0===t)return zero;t<0&&(r=!0,e=e.replace(/-/g,""));var n="",i=e,s=e.indexOf(".");if(s>-1&&(i=e.substring(0,s),n=e.substring(s+1,e.length)),i.length>66)return"خارج از محدوده";for(var u=prepareNumber(i),a=[],l=u.length,o=0;o<l;o+=1){var p=letters[4][l-(o+1)],c=threeNumbersToLetter(u[o]);""!==c&&a.push(c+p)}return n.length>0&&(n=convertDecimalPart(n)),(r?negative:"")+a.join(delimiter)+n};String.prototype.toPersianLetter=function(){return Num2persian(this)},Number.prototype.toPersianLetter=function(){return Num2persian(parseFloat(this).toString())};
