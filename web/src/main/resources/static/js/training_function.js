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

function defineWindowsEditNeedsAssessment(grid) {
    const Window_NeedsAssessment_Edit = isc.Window.create({
        ID: "Window_NeedsAssessment_Edit",
        title: "ویرایش نیازسنجی",
        minWidth: 1024,
        visibility : "hidden",
        headerControls: ["headerLabel", "closeButton"],
        canDragReposition: false,
        items: [isc.ViewLoader.create({autoDraw: true, viewURL: "web/edit-needs-assessment/"})],
        // items: [isc.ViewLoader.create({autoDraw: true, viewURL: "web/diff-needs-assessment/"})],
        placement: "fillScreen",
        showUs(record, objectType) {
            loadEditNeedsAssessment(record, objectType);
            // loadDiffNeedsAssessment(record, objectType);
            isChanged = false;
            this.Super("show", arguments);
        },
        close(){
            if(isChanged){
                const dialog = isc.Dialog.create({
                    ID: "dialog",
                    icon:  'info.png',
                    title: "پیغام",
                    message: "تغییراتی در پنجره ویرایش نیازسنجی ثبت شده است لطفا یکی از گزینه های زیر را با توجه به تغییرات اعمال شده انتخاب کنید.",
                    buttons : [
                        isc.Button.create({ title:"ارسال به گردش کار"}),
                        isc.Button.create({ title:"لغو تغییرات"}),
                        isc.Button.create({ title:"خروج از نیازسنجی"}),
                    ],
                    buttonClick : function (button, index) {
                        dialog.close();
                        switch(index){
                            case 0:

                                break;
                            case 1:
                                CancelChange_JspENA.click();
                                break;
                            case 2:
                                Window_NeedsAssessment_Edit.Super("close", arguments);
                                grid.invalidateCache();
                                break;
                        }
                    }
                });
            }
            else {
                Window_NeedsAssessment_Edit.Super("close", arguments);
                grid.invalidateCache();
            }
        },
    });
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

function showWindowDiffNeedsAssessment(objectId, objectType) {
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
        if(Window_NeedsAssessment_Diff !== undefined) {
            Window_NeedsAssessment_Diff.showUs(objectId, objectType);
            if(typeof Window_NeedsAssessment_Edit !== "undefined"){
                Window_NeedsAssessment_Edit.close();
            }
            clearInterval(interval);
        }
    },50)
}

function showDetailViewer(title, field, record) {
    let Window_DetailViewer_Main = isc.Window.create({
        ID: "Window_DetailViewer_Main",
        title: title,
        // placement: "fillScreen",
        visibility : "hidden",
        headerControls: ["headerLabel", "closeButton"],
        // canDragReposition: false,
        // minWidth: 1024,
        items: [isc.DetailViewer.create({
            fields: field,
            data: record,
            autoFetchData: true,
            // width: 700
        })],
    });
    Window_DetailViewer_Main.show();
}

function showOrganizationalChart() {
    recordChartId = null;
    let Window_OrganizationalChart = isc.Window.create({
        ID: "Window_OrganizationalChart",
        title: "درخت نیازسنجی",
        placement: "fillScreen",
        headerControls: ["headerLabel", "closeButton"],
        canDragReposition: false,
        visibility : "hidden",
        minWidth: 1024,
        items: [isc.ViewLoader.create({autoDraw: true, viewURL: "web/organizationalChart/"})],
    });
    Window_OrganizationalChart.show();
    let interval = setInterval(()=>{
        if(searchTree !== undefined && organizationalTree !== undefined) {
            searchTree.addProperties({
                rowDoubleClick(record){
                    Window_OrganizationalChart.close();
                    recordChartId = record.id;
                }
            })
            organizationalTree.addProperties({
                rowDoubleClick(record){
                    Window_OrganizationalChart.close();
                    recordChartId = record.id;
                }
            })
            clearInterval(interval);
        }
    },50)
}

