<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
// <script>
    //----------------------------------------------------Variables-----------------------------------------------------
    var startDate1Check_JspControlReport = true;
    var startDate2Check_JspControlReport = true;
    var startDateCheck_Order_JspControlReport = true;
    var endDate1Check_JspControlReport = true;
    var endDate2Check_JspControlReport = true;
    var endDateCheck_Order_JspControlReport = true;
    let wait;
    let idClasses;

    $(document).ready(()=>{
        setTimeout(()=>{
            $("input[name='classCode']").attr("disabled","disabled");
        },0)}
    );

    let showPrintType = function(callback, prs) {
        let printTypeWindow = isc.MyYesNoDialog.create({
            title: "",
            message: "<spring:message code='report.type'/>",
            buttons: [
                isc.IButtonSave.create({title: "word",}),
                isc.IButtonSave.create({title: "pdf",})],
            buttonClick: function (button, index) {
                if (index === 0) {
                    callback("word",...prs);
                } else {
                    callback("pdf",...prs);
                }
                this.close();
                return;
            },
            closeClick: function () {
                this.close();
            }
        });
        printTypeWindow.show();
    }

    //----------------------------------------------------Rest DataSource-----------------------------------------------
    RestDataSource_JspControlReport = isc.TrDS.create({
        fields: [
            {name: "idClass",hidden:true},
            {name: "codeClass"},
            {name: "nameCourse"},
            {name: "yearClass"},
            {name: "termClass"},
            {name: "instituteClass"},
            {name: "categoryClass"},
            {name: "subCategoryClass"},
            {name: "startDateClass"},
            {name: "endDateClass"},
            {name: "statusClass"}
        ],
    });

    var RestDataSource_Category_JspControlReport = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: categoryUrl + "spec-list"
    });

    var RestDataSource_SubCategory_JspControlReport = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: subCategoryUrl + "iscList"
    });

    var RestDataSource_Course_JspControlReport = isc.TrDS.create({
        ID: "courseDS",
        fields: [
            {name: "id", type: "Integer", primaryKey: true},
            {name: "code"},
            {name: "titleFa"}
        ],
        fetchDataURL: courseUrl + "info-tuple-list"
    });

    var RestDataSource_Class_JspControlReport = isc.TrDS.create({
        ID: "classDS",
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleClass"},
            {name: "code"},
            {name: "course.titleFa"}
        ],
        fetchDataURL: classUrl + "info-tuple-list"
    });

    var RestDataSource_Term_JspControlReport = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "startDate"},
            {name: "endDate"}
        ]
    });

    var RestDataSource_Year_JspControlReport = isc.TrDS.create({
        fields: [
            {name: "year", primaryKey: true}
        ],
        fetchDataURL: termUrl + "yearList"
    });

    var RestDataSource_Institute_JspControlReport = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", title: "نام موسسه"},
            {name: "manager.firstNameFa", title: "نام مدیر"},
            {name: "manager.lastNameFa", title: "نام خانوادگی مدیر"}
        ],
        fetchDataURL: instituteUrl + "spec-list",
        allowAdvancedCriteria: true
    });
    //----------------------------------------------------ListGrid Result-----------------------------------------------
    var ListGrid_JspControlReport = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource : RestDataSource_JspControlReport,
        cellHeight: 43,
        sortField: 0,
        showFilterEditor: false,
        selectionType: "single",
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        fields: [
            {name: "idClass",hidden:true},
            {name: "codeClass",title:"کد کلاس"},
            {name: "nameCourse",title:"نام دوره"},
            {name: "yearClass",title:"سال"},
            {name: "termClass",title:"ترم"},
            {name: "instituteClass",title:"موسسه"},
            {name: "categoryClass",title:"گروه"},
            {name: "subCategoryClass",title:"زیر گروه"},
            {name: "startDateClass",title:"تاریخ شروع"},
            {name: "endDateClass",title:"تاریخ پایان"},
            {name: "saveTypeA", title: " ", align: "center", canSort: false, canFilter: false},
            {name: "saveTypeB", title: " ", align: "center", canSort: false, canFilter: false},
            {name: "saveTypeC", title: " ", align: "center", canSort: false, canFilter: false}
        ],
        createRecordComponent: function (record, colNum) {
            var fieldName = this.getFieldName(colNum);
            if (fieldName == "saveTypeA") {
                var button = isc.IButton.create({
                    layoutAlign: "center",
                    title: "گزارش حضور و غیاب",
                    click: function () {
                        isc.RPCManager.sendRequest(TrDSRequest(sessionServiceUrl + "sessions/" + record.idClass, "GET", null,(resp)=>{
                            if(resp.httpResponseCode == 200){
                            const sessions = JSON.parse(resp.data);

                            if (sessions==null || sessions.length==0)
                            {
                                isc.Dialog.create({
                                    message: "<spring:message code="no.sessions.was.for.class"/>",
                                    icon: "[SKIN]ask.png",
                                    title: "<spring:message code="message"/>",
                                    buttons: [isc.Button.create({title: "<spring:message code="ok"/>"})],
                                    buttonClick: function (button, index) {
                                        this.close();
                                    }
                                });

                                return;
                            }

                            let date = sessions[0].sessionDate;
                            let sessionList = [];
                            let i = 1;
                            let page = 0;
                            for(let s of sessions){
                                if(s.sessionDate == date){
                                    sessionList.push(s);
                                    continue;
                                }
                                else if(i<5){
                                    i++;
                                    date = s.sessionDate;
                                    sessionList.push(s);
                                    continue;
                                }
                                page++;
                                i=1;
                                showPrintType(printClearForm,[sessionList,page,record.idClass]);
                                date = s.sessionDate;
                                // sessionList.length = 0;
                                sessionList = [];
                                sessionList.push(s);
                            }
                            page++;
                            showPrintType(printClearForm,[sessionList,page,record.idClass]);
                        }//end if
                        }//end resp body function
                        ));
                    }//end click function
                });
                return button;
            }
            else if (fieldName == "saveTypeB") {
                var button = isc.IButton.create({
                    layoutAlign: "center",
                    title: "گزارش نمرات",
                    click: function () {
                        showPrintType(printClearScoreForm,[record.idClass]);
                    }//end click function
                });
                return button;
            }
            else if (fieldName == "saveTypeC") {
                var button = isc.IButton.create({
                    layoutAlign: "center",
                    title: "گزارش کنترل",
                    click: function () {
                        showPrintType(printControlScoreForm,[record.idClass]);
                    }//end click function
                });
                return button;
            }

            else {
                return null;
            }
        }
    });

    IButton_JspControlReport_AttendanceExcel = isc.IButtonSave.create({
        top: 260,
        title: "گزارش اکسل حضور و غیاب",
        width: 300,
        click: function () {
            let criteriaForm = isc.DynamicForm.create({
                fields:[
                    {name: "classId", type: "hidden"},
                    {name: "dataStatus", type: "hidden"}
                ],
                method: "POST",
                action: "<spring:url value="/controlForm/exportExcelAttendance"/>",
                target: "_Blank",
                canSubmit: true
            });
            criteriaForm.setValue("classId", idClasses);
            criteriaForm.setValue("dataStatus",DynamicForm_CriteriaForm_JspControlReport.getItem("dataStatus").getValue() )

            criteriaForm.show();
            criteriaForm.submitForm();
        }
    });


    IButton_JspControlReport_ScoreExcel = isc.IButtonSave.create({
        top: 260,
        title: "گزارش اکسل نمرات",
        width: 300,
        click: function () {
            let criteriaForm = isc.DynamicForm.create({
                fields:[
                    {name: "classId", type: "hidden"},
                    {name: "dataStatus", type: "hidden"}
                ],
                method: "POST",
                action: "<spring:url value="/controlForm/exportExcelScore"/>",
                target: "_Blank",
                canSubmit: true
            });
            criteriaForm.setValue("classId", idClasses);
            criteriaForm.setValue("dataStatus",DynamicForm_CriteriaForm_JspControlReport.getItem("dataStatus").getValue() )

            criteriaForm.show();
            criteriaForm.submitForm();
        }
    });

    IButton_JspControlReport_ControlExcel = isc.IButtonSave.create({
        top: 260,
        title: "گزارش اکسل کنترل",
        width: 300,
        click: function () {
            let criteriaForm = isc.DynamicForm.create({
                fields:[
                    {name: "classId", type: "hidden"},
                    {name: "dataStatus", type: "hidden"}
                ],
                method: "POST",
                action: "<spring:url value="/controlForm/exportExcelControl"/>",
                target: "_Blank",
                canSubmit: true
            });
            criteriaForm.setValue("classId", idClasses);
            criteriaForm.setValue("dataStatus",DynamicForm_CriteriaForm_JspControlReport.getItem("dataStatus").getValue() )

            criteriaForm.show();
            criteriaForm.submitForm();
        }
    });

    IButton_JspControlReport_FullExcel = isc.IButtonSave.create({
        top: 260,
        title: "گزارش اکسل کلي",
        width: 300,
        click: function () {
            let criteriaForm = isc.DynamicForm.create({
                fields:[
                    {name: "classId", type: "hidden"},
                    {name: "dataStatus", type: "hidden"}
                ],
                method: "POST",
                action: "<spring:url value="/controlForm/exportExcelAll"/>",
                target: "_Blank",
                canSubmit: true
            });
            criteriaForm.setValue("classId", idClasses);
            criteriaForm.setValue("dataStatus",DynamicForm_CriteriaForm_JspControlReport.getItem("dataStatus").getValue() )

            criteriaForm.show();
            criteriaForm.submitForm();
        }
    });

    var HLayOut_CriteriaForm_JspControlReport_Details = isc.TrHLayoutButtons.create({
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "100%",
        alignLayout: "center",
        members: [
            ListGrid_JspControlReport
        ]
    });

    var HLayOut_Confirm_JspControlReport_AttendanceExcel = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "70%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_JspControlReport_AttendanceExcel,IButton_JspControlReport_ScoreExcel,IButton_JspControlReport_ControlExcel,IButton_JspControlReport_FullExcel
        ]
    });

    var Window_JspControlReport = isc.Window.create({
        placement: "fillScreen",
        title: "گزارش کنترل",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        minWidth: 1024,
        items: [
            isc.TrVLayout.create({
                members: [
                    HLayOut_CriteriaForm_JspControlReport_Details,HLayOut_Confirm_JspControlReport_AttendanceExcel
                ]
            })
        ]
    });
    //----------------------------------------------------Criteria Form------------------------------------------------
    var DynamicForm_CriteriaForm_JspControlReport = isc.DynamicForm.create({
        align: "right",
        titleWidth: 0,
        titleAlign: "center",
        showInlineErrors: true,
        showErrorText: false,
        numCols: 6,
        colWidths: ["5%", "25%", "5%", "25%","5%","25%"],
        fields: [
            {
                name: "classCode",
                title: "کد کلاس",
                hint: "کد کلاس را انتخاب نمائيد",
                showHintInField: true,
                icons: [{
                    src: "[SKIN]/pickers/search_picker.png",
                    click: function () {
                        Window_SelectClasses_JspControlReport.show();
                    }}],
                keyPressFilter: "[A-Z|0-9|,-]"
            },
            {
                name: "classYear",
                title: "سال",
                type: "SelectItem",
                optionDataSource: RestDataSource_Year_JspControlReport,
                valueField: "year",
                displayField: "year",
                filterFields: ["year"],
                filterLocally: true,
                initialSort: [
                    {property: "year", direction: "descending", primarySort: true}
                ],
                icons:[
                    {
                        name: "clear",
                        src: "[SKIN]actions/remove.png",
                        width: 15,
                        height: 15,
                        inline: true,
                        prompt: "پاک کردن",
                        click : function (form, item, icon) {
                            item.clearValue();
                            item.focusInItem();
                            DynamicForm_CriteriaForm_JspControlReport.getField("termId").disable();
                            DynamicForm_CriteriaForm_JspControlReport.getField("termId").setValue(null);
                            DynamicForm_CriteriaForm_JspControlReport.getField("classYear").setValue(null);
                        }
                    }
                ],

                changed: function (form, item, value) {
                    if (value != null && value != undefined) {
                        RestDataSource_Term_JspControlReport.fetchDataURL = termUrl + "listByYear/" + value;
                        DynamicForm_CriteriaForm_JspControlReport.getField("termId").optionDataSource = RestDataSource_Term_JspControlReport;
                        DynamicForm_CriteriaForm_JspControlReport.getField("termId").fetchData();
                        DynamicForm_CriteriaForm_JspControlReport.getField("termId").enable();
                    } else {
                        form.getField("termId").disabled = true;
                        form.getField("termId").clearValue();
                    }
                }
            },
            {
                name: "termId",
                title: "ترم",
                type: "SelectItem",
                filterOperator: "equals",
                disabled: true,
                valueField: "id",
                displayField: "titleFa",
                filterLocally: true,
                icons:[
                    {
                        name: "clear",
                        src: "[SKIN]actions/remove.png",
                        width: 15,
                        height: 15,
                        inline: true,
                        prompt: "پاک کردن",
                        click : function (form, item, icon) {
                            item.clearValue();
                            item.focusInItem();
                            DynamicForm_CriteriaForm_JspControlReport.getField("termId").setValue(null);
                        }
                    }
                ],
            },
            {
                name: "instituteId",
                title: "برگزار کننده",
                editorType: "TrComboAutoRefresh",
                optionDataSource: RestDataSource_Institute_JspControlReport,
                displayField: "titleFa",
                filterOperator: "equals",
                valueField: "id",
                textAlign: "center",
                filterFields: ["titleFa", "titleFa"],
                showHintInField: true,
                hint: "موسسه",
                pickListWidth: 500,
                textMatchStyle: "substring",
                pickListFields: [
                    {name: "titleFa", filterOperator: "iContains"},
                    {name: "manager.firstNameFa", filterOperator: "iContains"},
                    {name: "manager.lastNameFa", filterOperator: "iContains"}
                ],
                pickListProperties: {
                    sortField: 0,
                    showFilterEditor: false
                }
            },
            {
                name: "courseCategory",
                title: "گروه",
                type: "SelectItem",
                textAlign: "center",
                optionDataSource: RestDataSource_Category_JspControlReport,
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                filterLocally: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains"
                },
                icons:[
                    {
                        name: "clear",
                        src: "[SKIN]actions/remove.png",
                        width: 15,
                        height: 15,
                        inline: true,
                        prompt: "پاک کردن",
                        click : function (form, item, icon) {
                            item.clearValue();
                            item.focusInItem();
                            DynamicForm_CriteriaForm_JspControlReport.getField("courseSubCategory").disable();
                            DynamicForm_CriteriaForm_JspControlReport.getField("courseCategory").setValue(null);
                            DynamicForm_CriteriaForm_JspControlReport.getField("courseSubCategory").setValue(null);
                        }
                    }
                ],
                changed: function () {
                    isCriteriaCategoriesChanged_JspControlReport = true;
                    var subCategoryField = DynamicForm_CriteriaForm_JspControlReport.getField("courseSubCategory");
                    if (this.getSelectedRecords() == null) {
                        subCategoryField.clearValue();
                        subCategoryField.disable();
                        return;
                    }
                    subCategoryField.enable();
                    if (subCategoryField.getValue() === undefined)
                        return;
                    var subCategories = subCategoryField.getSelectedRecords();
                    var categoryIds = this.getValue();
                    var SubCats = [];
                    for (var i = 0; i < subCategories.length; i++) {
                        if (categoryIds.contains(subCategories[i].categoryId))
                            SubCats.add(subCategories[i].id);
                    }
                    subCategoryField.setValue(SubCats);
                    subCategoryField.focus(this.form, subCategoryField);
                }
            },
            {
                name: "courseSubCategory",
                title: "زیر گروه",
                type: "SelectItem",
                textAlign: "center",
                autoFetchData: false,
                disabled: true,
                optionDataSource: RestDataSource_SubCategory_JspControlReport,
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                filterLocally: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains"
                },
                focus: function () {
                    if (isCriteriaCategoriesChanged_JspControlReport) {
                        isCriteriaCategoriesChanged_JspControlReport = false;
                        var ids = DynamicForm_CriteriaForm_JspControlReport.getField("courseCategory").getValue();
                        if (ids === []) {
                            RestDataSource_SubCategory_JspControlReport.implicitCriteria = null;
                        } else {
                            RestDataSource_SubCategory_JspControlReport.implicitCriteria = {
                                _constructor: "AdvancedCriteria",
                                operator: "and",
                                criteria: [{fieldName: "categoryId", operator: "inSet", value: ids}]
                            };
                        }
                        this.fetchData();
                    }
                },
                icons:[
                    {
                        name: "clear",
                        src: "[SKIN]actions/remove.png",
                        width: 15,
                        height: 15,
                        inline: true,
                        prompt: "پاک کردن",
                        click : function (form, item, icon) {
                            item.clearValue();
                            item.focusInItem();
                            DynamicForm_CriteriaForm_JspControlReport.getField("courseSubCategory").setValue(null);
                        }
                    }
                ],
            },
            {
                name: "startDate1",
                ID: "startDate1_JspControlReport",
                title: "تاریخ شروع کلاس: از",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('startDate1_JspControlReport', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("startDate2","تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد" ,true);
                        form.clearFieldErrors("startDate1", true);
                        startDateCheck_Order_JspControlReport = true;
                        startDate1Check_JspControlReport = true;
                        return;
                    }
                    var dateCheck;
                    var endDate = form.getValue("startDate2");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        startDate1Check_JspControlReport = false;
                        startDateCheck_Order_JspControlReport = true;
                        form.clearFieldErrors("startDate1", true);
                        form.addFieldErrors("startDate1", "<spring:message code='msg.correct.date'/>", true);
                    } else if (endDate < value) {
                        startDateCheck_Order_JspControlReport = false;
                        startDate1Check_JspControlReport = true;
                        form.clearFieldErrors("startDate1", true);
                        form.addFieldErrors("startDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    }
                    else {
                        startDate1Check_JspControlReport = true;
                        startDateCheck_Order_JspControlReport = true;
                        form.clearFieldErrors("startDate1", true);
                    }
                }
            },
            {
                name: "startDate2",
                ID: "startDate2_JspControlReport",
                title: "تا",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('startDate2_JspControlReport', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("startDate1","تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد" ,true);
                        form.clearFieldErrors("startDate2", true);
                        startDateCheck_Order_JspControlReport = true;
                        startDate2Check_JspControlReport = true;
                        return;
                    }
                    var dateCheck;
                    dateCheck = checkDate(value);
                    var startDate = form.getValue("startDate1");
                    if (dateCheck === false) {
                        startDate2Check_JspControlReport = false;
                        startDateCheck_Order_JspControlReport = true;
                        form.clearFieldErrors("startDate2", true);
                        form.addFieldErrors("startDate2", "<spring:message code='msg.correct.date'/>", true);
                    } else if (startDate != undefined && value < startDate) {
                        form.clearFieldErrors("startDate2", true);
                        form.addFieldErrors("startDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        startDate2Check_JspControlReport = true;
                        startDateCheck_Order_JspControlReport = false;
                    } else {
                        form.clearFieldErrors("startDate2", true);
                        startDate2Check_JspControlReport = true;
                        startDateCheck_Order_JspControlReport = true;
                    }
                }
            },
            {
                name: "temp1",
                title: "",
                canEdit: false
            },
            {
                name: "endDate1",
                ID: "endDate1_JspControlReport",
                title: "تاریخ پایان کلاس: از",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('endDate1_JspControlReport', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("endDate2","تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد" ,true);
                        form.clearFieldErrors("endDate1", true);
                        endDateCheck_Order_JspControlReport = true;
                        endDate1Check_JspControlReport = true;
                        return;
                    }
                    var dateCheck;
                    var endDate = form.getValue("endDate2");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        endDate1Check_JspControlReport = false;
                        endDateCheck_Order_JspControlReport = true;
                        form.clearFieldErrors("endDate1", true);
                        form.addFieldErrors("endDate1", "<spring:message code='msg.correct.date'/>", true);
                    } else if (endDate < value) {
                        endDateCheck_Order_JspControlReport = false;
                        endDate1Check_JspControlReport = true;
                        form.clearFieldErrors("endDate1", true);
                        form.addFieldErrors("endDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    } else {
                        endDate1Check_JspControlReport = true;
                        endDateCheck_Order_JspControlReport = true;
                        form.clearFieldErrors("endDate1", true);
                    }
                }
            },
            {
                name: "endDate2",
                ID: "endDate2_JspControlReport",
                title: "تا",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('endDate2_JspControlReport', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("endDate1","تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد" ,true);
                        form.clearFieldErrors("endDate2", true);
                        endDateCheck_Order_JspControlReport = true;
                        endDate2Check_JspControlReport = true;
                        return;
                    }
                    var dateCheck;
                    dateCheck = checkDate(value);
                    var startDate = form.getValue("endDate1");
                    if (dateCheck === false) {
                        endDate2Check_JspControlReport = false;
                        endDateCheck_Order_JspControlReport = true;
                        form.clearFieldErrors("endDate2", true);
                        form.addFieldErrors("endDate2", "<spring:message code='msg.correct.date'/>", true);
                    } else if (startDate != undefined && value < startDate) {
                        form.clearFieldErrors("endDate2", true);
                        form.addFieldErrors("endDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        endDate2Check_JspControlReport = true;
                        endDateCheck_Order_JspControlReport = false;
                    } else {
                        form.clearFieldErrors("endDate2", true);
                        endDate2Check_JspControlReport = true;
                        endDateCheck_Order_JspControlReport = true;
                    }
                }
            },
            {
                name: "temp2",
                title: "",
                canEdit: false
            },

            {
                name: "classStatus",
                title: "وضعیت کلاس",
                type: "SelectItem",
                required: true,
                multiple: true,
                valueMap: {
                    "1": "برنامه ريزی",
                    "2": "در حال اجرا",
                    "3": "پایان یافته",
                },
                pickListProperties: {
                    showFilterEditor: false
                },
                defaultValue:  ["1","2","3"]
            },
            {
                name: "dataStatus",
                title: "دیتا",
                type: "radioGroup",
                width: "*",
                valueMap: {"true": "<spring:message code='enabled'/>", "false": "<spring:message code='disabled'/>"},
                vertical: false,
                defaultValue: "true"
            }
        ]
    });

    var initialLayoutStyle = "vertical";
    var DynamicForm_SelectCourses_JspControlReport = isc.DynamicForm.create({
        align: "center",
        titleWidth: 0,
        titleAlign: "center",
        width: 500,
        height: 300,
        fields: [
            {
                name: "course.code",
                align: "center",
                title: "",
                editorType: "MultiComboBoxItem",
                multiple: true,
                defaultValue: null,
                changeOnKeypress: true,
                showHintInField: true,
                displayField: "code",
                comboBoxWidth: 500,
                valueField: "code",
                layoutStyle: initialLayoutStyle,
                optionDataSource: RestDataSource_Course_JspControlReport
            }
        ]
    });
    DynamicForm_SelectCourses_JspControlReport.getField("course.code").comboBox.setHint("دوره های مورد نظر را انتخاب کنید");
    DynamicForm_SelectCourses_JspControlReport.getField("course.code").comboBox.pickListFields =
        [{name: "titleFa", title: "نام دوره", width: "30%", filterOperator: "iContains"},
            {
                name: "code", title: "کد دوره", width: "30%", filterOperator: "iContains"
            }];
    DynamicForm_SelectCourses_JspControlReport.getField("course.code").comboBox.filterFields = ["titleFa", "code"];

    IButton_ConfirmCourseSelections_JspControlReport = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 300,
        click: function () {
            var criteriaDisplayValues = "";
            var selectorDisplayValues = DynamicForm_SelectCourses_JspControlReport.getItem("course.code").getValue();
            if (DynamicForm_CriteriaForm_JspControlReport.getField("courseCode").getValue() != undefined
                && DynamicForm_CriteriaForm_JspControlReport.getField("courseCode").getValue() != "") {
                criteriaDisplayValues = DynamicForm_CriteriaForm_JspControlReport.getField("courseCode").getValue();
                var ALength = criteriaDisplayValues.length;
                var lastChar = criteriaDisplayValues.charAt(ALength - 1);
                if (lastChar != ",")
                    criteriaDisplayValues += ",";
            }
            if (selectorDisplayValues != undefined) {
                for (var i = 0; i < selectorDisplayValues.size() - 1; i++) {
                    criteriaDisplayValues += selectorDisplayValues [i] + ",";
                }
                criteriaDisplayValues += selectorDisplayValues [selectorDisplayValues.size() - 1];
            }
            DynamicForm_CriteriaForm_JspControlReport.getField("courseCode").setValue(criteriaDisplayValues);
            Window_SelectCourses_JspControlReport.close();
        }
    });

    var Window_SelectCourses_JspControlReport = isc.Window.create({
        placement: "center",
        title: "انتخاب دوره ها",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "2px solid gray",
        width: 500,
        height: 300,
        items: [
            isc.TrVLayout.create({
                members: [
                    DynamicForm_SelectCourses_JspControlReport,
                    IButton_ConfirmCourseSelections_JspControlReport
                ]
            })
        ]
    });

    var DynamicForm_SelectClasses_JspControlReport = isc.DynamicForm.create({
        align: "center",
        titleWidth: 0,
        titleAlign: "center",
        width: 500,
        height: 300,
        fields: [
            {
                name: "class.code",
                align: "center",
                title: "",
                editorType: "MultiComboBoxItem",
                multiple: true,
                defaultValue: null,
                changeOnKeypress: true,
                showHintInField: true,
                displayField: "code",
                comboBoxWidth: 500,
                valueField: "code",
                layoutStyle: initialLayoutStyle,
                optionDataSource: RestDataSource_Class_JspControlReport
            }
        ]
    });

    DynamicForm_SelectClasses_JspControlReport.getField("class.code").comboBox.setHint("کلاسهای مورد نظر را انتخاب کنید");
    DynamicForm_SelectClasses_JspControlReport.getField("class.code").comboBox.pickListFields =
        [
            {name: "titleClass", title: "نام کلاس", width: "30%", filterOperator: "iContains"},
            {name: "code", title: "کد کلاس", width: "30%", filterOperator: "iContains"},
            {name: "course.titleFa", title: "نام دوره", width: "30%", filterOperator: "iContains"}];
    DynamicForm_SelectClasses_JspControlReport.getField("class.code").comboBox.filterFields = ["titleClass", "code", "course.titleFa"];

    IButton_ConfirmClassesSelections_JspControlReport = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 300,
        click: function () {
            let criteriaDisplayValues = "";
            let selectorDisplayValues = DynamicForm_SelectClasses_JspControlReport.getItem("class.code").getValue();
            if (DynamicForm_SelectClasses_JspControlReport.getField("class.code").getValue() != undefined && DynamicForm_SelectClasses_JspControlReport.getField("class.code").getValue() != "") {
                criteriaDisplayValues = DynamicForm_SelectClasses_JspControlReport.getField("class.code").getValue().join(",");
                let ALength = criteriaDisplayValues.length;
                let lastChar = criteriaDisplayValues.charAt(ALength - 1);
                if (lastChar != ";")
                    criteriaDisplayValues += ",";
            }
            if (selectorDisplayValues != undefined) {
                for (let i = 0; i < selectorDisplayValues.size() - 1; i++) {
                    criteriaDisplayValues += selectorDisplayValues [i] + ",";
                }
                criteriaDisplayValues += selectorDisplayValues [selectorDisplayValues.size() - 1];
            }

            if (typeof criteriaDisplayValues != "undefined") {
                let uniqueNames = [];

                $.each(criteriaDisplayValues.split(","), function (i, el) {
                    if ($.inArray(el, uniqueNames) === -1) uniqueNames.push(el);
                });
                criteriaDisplayValues = uniqueNames.join(",");
            }

            criteriaDisplayValues = criteriaDisplayValues == "undefined" ? "" : criteriaDisplayValues;

            DynamicForm_CriteriaForm_JspControlReport.getField("classCode").setValue(criteriaDisplayValues);
            Window_SelectClasses_JspControlReport.close();
        }
    });

    var Window_SelectClasses_JspControlReport = isc.Window.create({
        placement: "center",
        title: "انتخاب کلاس ها",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "2px solid gray",
        width: 500,
        height: 300,
        items: [
            isc.TrVLayout.create({
                members: [
                    DynamicForm_SelectClasses_JspControlReport,
                    IButton_ConfirmClassesSelections_JspControlReport
                ]
            })
        ]
    });

    IButton_JspControlReport = isc.IButtonSave.create({
        top: 260,
        title: "چاپ گزارش",
        width: 300,
        click: function () {
            if(Object.keys(DynamicForm_CriteriaForm_JspControlReport.getValuesAsCriteria()).length <= 2) {
                createDialog("info","فیلتری انتخاب نشده است.");
                return;
            }

            DynamicForm_CriteriaForm_JspControlReport.validate();
            if (DynamicForm_CriteriaForm_JspControlReport.hasErrors())
                return;
            if (!DynamicForm_CriteriaForm_JspControlReport.validate() ||
                startDateCheck_Order_JspControlReport == false ||
                startDate2Check_JspControlReport == false ||
                startDate1Check_JspControlReport == false ||
                endDateCheck_Order_JspControlReport == false ||
                endDate2Check_JspControlReport == false ||
                endDate1Check_JspControlReport == false) {

                if (startDateCheck_Order_JspControlReport == false) {
                    DynamicForm_CriteriaForm_JspControlReport.clearFieldErrors("startDate2", true);
                    DynamicForm_CriteriaForm_JspControlReport.addFieldErrors("startDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                }
                if (startDateCheck_Order_JspControlReport == false) {
                    DynamicForm_CriteriaForm_JspControlReport.clearFieldErrors("startDate1", true);
                    DynamicForm_CriteriaForm_JspControlReport.addFieldErrors("startDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                }
                if (startDate2Check_JspControlReport == false) {
                    DynamicForm_CriteriaForm_JspControlReport.clearFieldErrors("startDate2", true);
                    DynamicForm_CriteriaForm_JspControlReport.addFieldErrors("startDate2", "<spring:message code='msg.correct.date'/>", true);
                }
                if (startDate1Check_JspControlReport == false) {
                    DynamicForm_CriteriaForm_JspControlReport.clearFieldErrors("startDate1", true);
                    DynamicForm_CriteriaForm_JspControlReport.addFieldErrors("startDate1", "<spring:message code='msg.correct.date'/>", true);
                }

                if (endDateCheck_Order_JspControlReport == false) {
                    DynamicForm_CriteriaForm_JspControlReport.clearFieldErrors("endDate2", true);
                    DynamicForm_CriteriaForm_JspControlReport.addFieldErrors("endDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                }
                if (endDateCheck_Order_JspControlReport == false) {
                    DynamicForm_CriteriaForm_JspControlReport.clearFieldErrors("endDate1", true);
                    DynamicForm_CriteriaForm_JspControlReport.addFieldErrors("endDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                }
                if (endDate2Check_JspControlReport == false) {
                    DynamicForm_CriteriaForm_JspControlReport.clearFieldErrors("endDate2", true);
                    DynamicForm_CriteriaForm_JspControlReport.addFieldErrors("endDate2", "<spring:message code='msg.correct.date'/>", true);
                }
                if (endDate1Check_JspControlReport == false) {
                    DynamicForm_CriteriaForm_JspControlReport.clearFieldErrors("endDate1", true);
                    DynamicForm_CriteriaForm_JspControlReport.addFieldErrors("endDate1", "<spring:message code='msg.correct.date'/>", true);
                }
                return;
            }

            wait=createDialog("wait");
            isc.RPCManager.sendRequest(TrDSRequest(controlReportUrl+"/listClassIds" ,"POST", JSON.stringify(DynamicForm_CriteriaForm_JspControlReport.getValues()), "callback: fill_control_result(rpcResponse)"));
        }
    });

    //----------------------------------- functions --------------------------------------------------------------------
    let Window_CriteriaForm_JspControlReport = isc.Window.create({
        placement: "fillScreen",
        title: "",
        showCloseButton: false,
        showMaximizeButton: false,
        canDragReposition: false,
        showMinimizeButton: false,
        canDragResize: false,
        closeClick: false,
        minimize: false,
        items: [DynamicForm_CriteriaForm_JspControlReport]
    });

    function printClearForm(typ,list,page,id) {

        let f = [
            {
                name: "fullName",
                title: "<spring:message code='full.name'/>"
            },
            {
                name: "personnelNo",
                title: "<spring:message code='task.number'/>"
            },
            {
                name: "jobTitle",
                title: "<spring:message code='job'/>"
            },
            {
                name: "ccpAffairs",
                title: "<spring:message code='affairs'/>"
            },
            {
                name: "educationMajorTitle",
                title: "<spring:message code='education.degree'/>"
            },
        ];

        let criteriaForm = isc.DynamicForm.create({
            method: "POST",
            action: baseUrl.concat("/controlForm/clear-print/").concat(typ),
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "classId", type: "hidden"},
                    {name: "list", type: "hidden"},
                    {name: "page", type: "hidden"},
                    {name: "dataStatus", type: "hidden"},
                    {name: "fields", type: "hidden"}
                ]
        });
        criteriaForm.setValue("classId", id);
        criteriaForm.setValue("list", JSON.stringify(list));
        criteriaForm.setValue("page", page);
        criteriaForm.setValue("dataStatus",DynamicForm_CriteriaForm_JspControlReport.getItem("dataStatus").getValue());
        criteriaForm.setValue("fields", JSON.stringify(f));
        criteriaForm.show();
        criteriaForm.submitForm();
    }

    function printClearScoreForm(typ, id) {
        let f = [
            {
                name: "fullName",
                title: "<spring:message code='full.name'/>"
            },
            {
                name: "personnelNo",
                title: "<spring:message code='task.number'/>"
            },
            {
                name: "scoreA",
                title: "<spring:message code='score.number'/>"
            },
            {
                name: "scoreB",
                title: "<spring:message code='score.literal'/>"
            },
        ];
        let criteriaForm = isc.DynamicForm.create({
            method: "POST",
            action: baseUrl.concat("/controlForm/score-print/").concat(typ),
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "classId", type: "hidden"},
                    {name: "dataStatus", type: "hidden"},
                    {name: "fields", type: "hidden"}
                ]
        });
        criteriaForm.setValue("classId", id);
        criteriaForm.setValue("dataStatus",DynamicForm_CriteriaForm_JspControlReport.getItem("dataStatus").getValue());
        criteriaForm.setValue("fields", JSON.stringify(f));
        criteriaForm.show();
        criteriaForm.submitForm();
    }

    function printControlScoreForm(typ, id) {
        let f = [
            {
                name: "fullName",
                title: "<spring:message code='full.name'/>"
            },
            {
                name: "personnelNo",
                title: "<spring:message code='task.number'/>"
            },
            {
                name: "personnelNo2",
                title: "<spring:message code='task.number.old'/>"
            },
            {
                name: "ccpAffairs",
                title: "<spring:message code='affairs'/>"
            },
        ];

        let criteriaForm = isc.DynamicForm.create({
            method: "POST",
            action: baseUrl.concat("/controlForm/control-print/").concat(typ),
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "classId", type: "hidden"},
                    {name: "fields", type: "hidden"}
                ]
        });
        criteriaForm.setValue("classId", id);
        criteriaForm.setValue("fields", JSON.stringify(f));
        criteriaForm.show();
        criteriaForm.submitForm();
    }

    function fill_control_result(resp) {
        if (resp.httpResponseCode === 200) {
            wait.close();
            idClasses=JSON.parse(resp.data).response.data.map(x=>x.idClass);
            ListGrid_JspControlReport.setData(JSON.parse(resp.data).response.data);
            Window_JspControlReport.show();

            let buttons=[IButton_JspControlReport_AttendanceExcel, IButton_JspControlReport_ScoreExcel, IButton_JspControlReport_ControlExcel, IButton_JspControlReport_FullExcel];
            let disabled=true;

            if (ListGrid_JspControlReport.data.size() > 0){
                disabled=!disabled;
            }

            buttons.forEach(item => item.setDisabled(disabled));
        }
    }

    //----------------------------------- layOut -----------------------------------------------------------------------
    var HLayOut_CriteriaForm_JspControlReport = isc.TrHLayoutButtons.create({
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "100%",
        alignLayout: "center",
        members: [
            Window_CriteriaForm_JspControlReport
        ]
    });
    var HLayOut_Confirm_JspControlReport = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "70%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_JspControlReport
        ]
    });


    var VLayout_Body_JspControlReport = isc.TrVLayout.create({
        members: [
            HLayOut_CriteriaForm_JspControlReport,
            HLayOut_Confirm_JspControlReport
        ]
    });
    //----------------------------------------------------End-----------------------------------------------------------
    Window_JspControlReport.hide();