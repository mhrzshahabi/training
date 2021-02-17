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
        headerControls: ["headerLabel", "minimizeButton", "closeButton"],
        canDragReposition: false,
        items: [isc.ViewLoader.create({autoDraw: true, viewURL: "web/edit-needs-assessment/"})],
        // items: [isc.ViewLoader.create({autoDraw: true, viewURL: "web/diff-needs-assessment/"})],
        placement: "fillScreen",
        showUs(record, objectType) {
            loadEditNeedsAssessment(record, objectType);
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
                                        sendNeedsAssessmentToWorkflow();
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

function showWindowDiffNeedsAssessment(objectId, objectType, unchangeable = false) {
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
            loadDiffNeedsAssessment(id, type);
            this.Super("show", arguments);
        },
    });
    let interval = setInterval(()=>{
        if(Window_NeedsAssessment_Diff != null) {
            clearInterval(interval);
            Window_NeedsAssessment_Diff.showUs(objectId, objectType);
            if(unchangeable) {
                DynamicForm_JspEditNeedsAssessment.disable();
                CompetenceTS_diffNeedsAssessment.disable();
                ListGridTop_Knowledge_JspDiffNeedsAssessment.disable();
                ListGridTop_Ability_JspDiffNeedsAssessment.disable();
                ListGridTop_Attitude_JspDiffNeedsAssessment.disable();
            }
            else{
                DynamicForm_JspEditNeedsAssessment.enable();
                CompetenceTS_diffNeedsAssessment.enable();
                ListGridTop_Knowledge_JspDiffNeedsAssessment.enable();
                ListGridTop_Ability_JspDiffNeedsAssessment.enable();
                ListGridTop_Attitude_JspDiffNeedsAssessment.enable();
            }
            if(typeof Window_NeedsAssessment_Edit !== "undefined"){
                Window_NeedsAssessment_Edit.close(0);
            }
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
