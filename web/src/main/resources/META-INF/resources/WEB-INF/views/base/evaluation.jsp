<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@include file="../messenger/MLanding.jsp" %>
<jsp:include page="teacher.jsp" />

// <script>
    //----------------------------------------- DataSources ------------------------------------------------------------

    let evalTypeCriteria = [];
    let evalDateCriteria = [];
    let departmentCriteria = [];

     eval_Flag_Tab_ClassChanges= null;
     eval_Flag_Tab_HistoryOfRemoved = null;
     eval_Flag_Tab_HistoryAdded   = null;

    var RestDataSource_class_Evaluation = isc.TrDS.create({
        fields: [
            {name: "id"},
            {name: "termId"},
            {name: "instituteId"},
            {name: "teacherId"},
            {name: "teacherFullName"},
            {name: "teacherLastName"},
            {name: "tclassStudentsCount"},
            {name: "studentOnlineEvalExecutionStatus"},
            {name: "tclassCode"},
            {name: "tclassStartDate"},
            {name: "tclassEndDate"},
            {name: "tclassYear"},
            {name: "courseCode"},
            {name: "courseCategory"},
            {name: "courseSubCategory"},
            {name: "courseTitleFa"},
            {name: "evaluation"},
            {name: "tclassDuration"},
            {name: "tclassOrganizerId"},
            {name: "tclassStatus"},
            {name: "tclassReason"},
            {name: "tclassEndingStatus"},
            {name: "tclassPlanner"},
            {name: "termTitleFa"},
            {name: "instituteTitleFa"},
            {name: "classScoringMethod"},
            {name: "classPreCourseTest"},
            {name: "courseId"},
            {name: "teacherEvalStatus"},
            {name: "trainingEvalStatus"},
            {name: "tclassSupervisor"},
            {name: "tclassTeachingType"},
            {name: "classTeacherOnlineEvalStatus"},
            {name: "teachingMethodTitle"}
        ],
        fetchDataURL: viewClassDetailUrl + "/iscList",

        implicitCriteria: {
            _constructor: "AdvancedCriteria",
            operator: "and",
            criteria: [
                {fieldName: "tclassStudentsCount", operator: "notEqual", value: 0},
                {fieldName: "evaluation", operator: "notNull"},
                {fieldName: "tclassStatus", operator: "notEqual", value: "1"},

            ]
        },
    });

    //----------------------------------------- DynamicForms -----------------------------------------------------------
    var DynamicForm_AlarmSelection = isc.DynamicForm.create({
        width: "85%",
        height: "100%",
        fields: [
            {

                name: "classAlarmSelect",
                title: "",
                type: "radioGroup",
                defaultValue: "5",
                valueMap: {
                    "1": "لیست کلاسهایی که موعد ارزیابی واکنشی آنها امروز است",
                    "2": "لیست کلاسهایی که موعد ارزیابی یادگیری آنها امروز است",
                    "3": "لیست کلاسهایی که موعد ارزیابی رفتاری آنها امروز است",
                    "4": "لیست کلاسهایی که موعد ارزیابی آنها امروز است",
                    "5": "لیست همه ی کلاسها"
                },
                vertical: false,
                changed: function (form, item, value) {
                    if (value === "1") {
                        evalDateCriteria = createCriteria("tclassEndDate", "equals", todayDate);
                        evalTypeCriteria = createCriteria("evaluation", "equals", "1");
                        let mainCriteria = createMainCriteria();

                        RestDataSource_class_Evaluation.fetchDataURL = viewClassDetailUrl + "/iscList";
                        ListGrid_class_Evaluation.invalidateCache();
                        ListGrid_class_Evaluation.fetchData(mainCriteria);
                    }
                    if (value === "2") {
                        evalDateCriteria = createCriteria("tclassEndDate", "equals", todayDate);
                        evalTypeCriteria = createCriteria("evaluation", "equals", "2");
                        let mainCriteria = createMainCriteria();
                        // let criteria = {
                        //     _constructor: "AdvancedCriteria",
                        //     operator: "and",
                        //     criteria: [
                        //         {fieldName: "tclassStartDate", operator: "equals", value: todayDate},
                        //         {fieldName: "evaluation", operator: "notEqual", value: "1"}
                        //     ]
                        // };
                        RestDataSource_class_Evaluation.fetchDataURL = viewClassDetailUrl + "/iscList";
                        ListGrid_class_Evaluation.invalidateCache();
                        ListGrid_class_Evaluation.fetchData(mainCriteria);
                    }
                    if (value === "3") {
                        evalDateCriteria = createCriteria("behavioralDueDate", "equals", Date.create(new Date().setHours(4,30,0,0)).toUTCString());
                        evalTypeCriteria = createCriteria("evaluation", "equals", "3");
                        let mainCriteria = createMainCriteria();
                        // let criteria = {
                        //     _constructor: "AdvancedCriteria",
                        //     operator: "and",
                        //     criteria: [
                        //         {
                        //             fieldName: "behavioralDueDate",
                        //             operator: "equals",
                        //             value: Date.create(today).toUTCString()
                        //         },
                        //         {fieldName: "evaluation", operator: "equals", value: "3"}
                        //     ]
                        // };
                        RestDataSource_class_Evaluation.fetchDataURL = viewClassDetailUrl + "/iscList";
                        ListGrid_class_Evaluation.invalidateCache();
                        ListGrid_class_Evaluation.fetchData(mainCriteria);
                    }
                    if (value === "4") {
                        evalDateCriteria = createCriteria("tclassEndDate", "equals", todayDate);
                        evalTypeCriteria = [];
                        let mainCriteria = createMainCriteria();
                        RestDataSource_class_Evaluation.fetchDataURL = viewClassDetailUrl + "/iscList";
                        ListGrid_class_Evaluation.invalidateCache();
                        ListGrid_class_Evaluation.fetchData(mainCriteria);
                    }
                    if (value === "5") {
                        evalDateCriteria = [];
                        evalTypeCriteria = [];
                        RestDataSource_class_Evaluation.fetchDataURL = viewClassDetailUrl + "/iscList";
                        let mainCriteria = createMainCriteria();
                        ListGrid_class_Evaluation.invalidateCache();
                        ListGrid_class_Evaluation.fetchData(mainCriteria);
                    }
                },
            }
        ]
    });

    var editMobileForm = isc.DynamicForm.create({
        height: "200",
        numCols: 4,
        colWidths: [5, 5, 5, 205],
        showInlineErrors: true,
        showErrorText: true,
        showErrorStyle: false,
        errorOrientation: "bottom",
        fields: [
            {
                type:"hidden",name:"parentId"
            },
            {
                type: "staticText",
                title: "<spring:message code='student.edit.mobile.default.for.sms'/>",
            },
            {
                type: "SpacerItem",
                colSpan: 2
            },
            {
                name: "mobile_c",
                title: "",
                type: "checkbox",
                width: "2",
                changed: function (form, item, value) {
                    if (value) {
                        editMobileForm.getItem('mobile2_c').setValue(null);
                        editMobileForm.getItem('mdmsMobile_c').setValue(null);
                        editMobileForm.getItem('hrMobile_c').setValue(null);
                        editMobileForm.getValues().mobileForSMS = 1;
                        if (!editMobileForm.getValue("mobile"))
                            createDialog("warning", "<spring:message code='student.edit.mobile.is.empty.warn'/>", "اخطار");

                    }
                }
            },
            {
                name: "mobile",
                title: "",
                type: "text",
                length: 11,
                keyPressFilter: "[0-9]",
                wrapHintText: false
            },
            {
                name: "mobile2_c",
                title: "",
                type: "checkbox",
                width: "2",
                changed: function (form, item, value) {
                    if (value) {
                        editMobileForm.getItem('mobile_c').setValue(null);
                        editMobileForm.getItem('mdmsMobile_c').setValue(null);
                        editMobileForm.getItem('hrMobile_c').setValue(null);
                        editMobileForm.getValues().mobileForSMS = 2;
                        if (!editMobileForm.getValue("mobile2"))
                            createDialog("warning", "<spring:message code='student.edit.mobile.is.empty.warn'/>", "اخطار");

                    }
                }
            },
            {
                name: "mobile2",
                title: "",
                type: "text",
                length: 11,
                keyPressFilter: "[0-9]",
                wrapHintText: false
            },
            {
                name: "hrMobile_c",
                title: "",
                type: "checkbox",
                width: "2",
                changed: function (form, item, value) {
                    if (value) {
                        editMobileForm.getItem('mobile2_c').setValue(null);
                        editMobileForm.getItem('mdmsMobile_c').setValue(null);
                        editMobileForm.getItem('mobile_c').setValue(null);
                        editMobileForm.getValues().mobileForSMS = 3;
                        if (!editMobileForm.getValue("hrMobile"))
                            createDialog("warning", "<spring:message code='student.edit.mobile.is.empty.warn'/>", "اخطار");

                    }
                }
            },
            {
                name: "hrMobile",
                title: "",
                type: "text",
                disabled: true,
            },
            {
                name: "mdmsMobile_c",
                title: "",
                type: "checkbox",
                width: "2",
                changed: function (form, item, value) {
                    if (value) {
                        editMobileForm.getItem('mobile2_c').setValue(null);
                        editMobileForm.getItem('mobile_c').setValue(null);
                        editMobileForm.getItem('hrMobile_c').setValue(null);
                        editMobileForm.getValues().mobileForSMS = 4;
                        if (!editMobileForm.getValue("mdmsMobile"))
                            createDialog("warning", "<spring:message code='student.edit.mobile.is.empty.warn'/>", "اخطار");

                    }
                }
            },
            {
                name: "mdmsMobile",
                title: "",
                type: "text",
                disabled: true,
            },

        ]
    });

    function mobileValidation(mobileNum) {

        let isValid = true;

        if (mobileNum === null || mobileNum === undefined)
            isValid = true;

        else {

            if((mobileNum.length !== 10 && mobileNum.length !== 11) || !(/^-?\d+$/.test(mobileNum)))
                isValid = false;

            if(mobileNum.length === 10 && !mobileNum.startsWith("9"))
                isValid = false;

            if(mobileNum.length === 11 && !mobileNum.startsWith("09"))
                isValid = false;
        }

        return isValid;
    }

    var Window_EditMobile = isc.Window.create({
        width: "300",
        align: "center",
        border: "1px solid gray",
        title: "<spring:message code='student.edit.mobile'/>",
        closeClick: function () {
            this.Super("closeClick", arguments);
        },
        keyPress: function () {
            if (isc.EventHandler.getKey() === "Enter") {

            }
        },
        items: [isc.TrVLayout.create({
            members: [editMobileForm, isc.TrHLayoutButtons.create({
                layoutMargin: 5,
                showEdges: false,
                edgeImage: "",
                padding: 10,
                members: [isc.IButtonSave.create({
                    top: 260,
                    click: function () {
                        if(!mobileValidation(editMobileForm.getValue("mobile")) || !mobileValidation(editMobileForm.getValue("mobile2"))) {
                            createDialog("info", "<spring:message code="msg.invalid.mobile.number"/>");
                            return;
                        }
                        var data = editMobileForm.getValues();
                        delete data.emobileForSMS;
                        delete data.emobileForCN;
                        wait.show();
                        isc.RPCManager.sendRequest(TrDSRequest(rootUrl.concat("/contactInfo/").concat(data.id), "PUT", JSON.stringify(data), (r) => {
                            if (r.httpResponseCode == 406) {
                                let str = r.httpResponseText;
                                let msg = str.substring(str.lastIndexOf("[") + 1, str.lastIndexOf("]"));
                                createDialog("warning", msg);
                                editMobileForm.clearValues();
                                editMobileForm.clearErrors();
                                Window_EditMobile.close();
                                wait.close();
                                return;
                            }
                            let m = "";
                            switch (data.mobileForSMS) {
                                case 4: {m = data.mdmsMobile};break;
                                case 3: {m = data.hrMobile};break;
                                case 2: {m = data.mobile2};break;
                                default :{m = data.mobile};
                            }
                            editMobileForm.callBack(data, m);
                            editMobileForm.clearValues();
                            editMobileForm.clearErrors();
                            Window_EditMobile.close();
                            wait.close();
                        }));
                    }
                }), isc.IButtonCancel.create({
                    prompt: "",
                    orientation: "vertical",
                    click: function () {
                        editMobileForm.clearErrors();
                        editMobileForm.clearValues();
                        Window_EditMobile.close();
                    }
                })]
            })]
        })]
    });

    //----------------------------------------- ListGrids --------------------------------------------------------------

    let Menu_class_Evaluation = isc.Menu.create({
        data:
            [
                //کامنت شده چون بعد از اضافه شدن صدور برای حاضرین این قسمت معنا ندارد و در هیستوری اس ام اس چک میشه
                // {
                //     title: "تاریخچه ارسال ارزیابی فراگیران به سیستم آنلاین",
                //     click: function () {
                //         showStudentEvalToOnlineStatus();
                //     }
                // },  {isSeparator: true},
                {
                    title: "تاریخچه ارسال ارزیابی مدرس به سیستم آنلاین",
                    click: function () {
                        showTeacherEvalToOnlineStatus();
                    }
                },
                {isSeparator: true},
                {
                    title: "<spring:message code='class.history'/>",
                    click: function () {

                        let record = JSON.parse(JSON.stringify(ListGrid_class_Evaluation.getSelectedRecord()));
                        if (record == null || record.id == null) {
                            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                        } else {
                            eval_Flag_Tab_ClassChanges = 1;

                            if (mainTabSet.getTab("تغییرات کلاس") != null)
                                mainTabSet.removeTab("تغییرات کلاس")
                            createTab(this.title, "<spring:url value="web/classHistoryReport"/>");
                        }

                    }
                }, {isSeparator: true},
                {
                    title: "<spring:message code='class.student.history'/>",
                    click: function () {

                        let record = JSON.parse(JSON.stringify(ListGrid_class_Evaluation.getSelectedRecord()));
                        if (record == null || record.id == null) {
                            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                        } else {
                            eval_Flag_Tab_HistoryOfRemoved = 1;

                            if (mainTabSet.getTab("تاریخچه حذف فراگیران کلاس") != null)
                                mainTabSet.removeTab("تاریخچه حذف فراگیران کلاس")
                            createTab(this.title, "<spring:url value="web/classStudentHistoryRemoveReport"/>");
                        }

                    }
                }, {isSeparator: true},
                {
                    title: "تاریخچه افزودن فراگیران کلاس",
                    click: function () {

                        let record = JSON.parse(JSON.stringify(ListGrid_class_Evaluation.getSelectedRecord()));
                        if (record == null || record.id == null) {
                            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                        } else {
                            eval_Flag_Tab_HistoryAdded = 1;

                            if (mainTabSet.getTab("تاریخچه افزودن فراگیران کلاس") != null)
                                mainTabSet.removeTab("تاریخچه افزودن فراگیران کلاس")
                            createTab(this.title, "<spring:url value="web/classStudentHistoryAddReport"/>");
                        }

                    }
                },
                {
                    title: "تاریخچه ارسال sms",
                    click: function () {
                        showSmsHistory();
                    }
                }
            ]
    });

    var ListGrid_class_Evaluation = isc.TrLG.create({
        width: "100%",
        height: "100%",
        <sec:authorize access="hasAuthority('Evaluation_R')">
        dataSource: RestDataSource_class_Evaluation,
        </sec:authorize>
        <sec:authorize access="hasAuthority('Evaluation_History')">
        contextMenu: Menu_class_Evaluation,
        </sec:authorize>
        canAddFormulaFields: false,
        autoFetchData: false,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        initialSort: [
            {property: "tclassStartDate", direction: "descending", primarySort: true}
        ],
        fields: [
            {name: "iconField", title: " ", width: 10},
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {
                name: "tclassCode",
                title: "<spring:message code='class.code'/>",
                align: "center",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "courseCode",
                title: "<spring:message code='course.code'/>",
                align: "center",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "courseTitleFa",
                title: "<spring:message code='course.title'/>",
                align: "center",
                filterOperator: "iContains",
                autoFitWidth: true,
            },
            {
                name: "termTitleFa",
                title: "term",
                align: "center",
                filterOperator: "iContains",
                hidden: true
            },
            {
                name: "tclassStartDate",
                title: "<spring:message code='start.date'/>",
                align: "center",
                filterOperator: "iContains",
                filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                },
                autoFithWidth: true
            },
            {
                name: "tclassEndDate",
                title: "<spring:message code='end.date'/>",
                align: "center",
                filterOperator: "iContains",
                filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                },
                autoFithWidth: true
            },
            {
                name: "tclassStudentsCount",
                title: "<spring:message code='student.count'/>",
                filterOperator: "equals",
                autoFitWidth: true,
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {
                name: "teacherLastName",
                title: "<spring:message code='teacher'/>",
                canFilter: true,
                filterOperator: "iContains",
                formatCellValue: function (value, record, field) {
                    return record.teacherFullName;
                }
            },
            {
                name: "instituteTitleFa",
                title: "<spring:message code='presenter'/>",
                align: "center",
                filterOperator: "iContains",
                autoFitWidth: true,
                hidden: true
            },
            {
                name: "evaluation",
                title: "<spring:message code='evaluation.type'/>",
                align: "center",
                filterOperator: "iContains",
                autoFitWidth: true,
                filterEditorProperties: {
                    pickListProperties: {
                        showFilterEditor: false
                    },
                    click: function () {
                        setTimeout(() => {
                            $('.comboBoxItemPickerrtl').eq(4).remove();
                            $('.comboBoxItemPickerrtl').eq(5).remove();
                        }, 0);
                    }
                },
                valueMap: {
                    "1": "واکنشی",
                    "2": "یادگیری",
                    "3": "رفتاری",
                    "4": "نتایج"
                },
            },
            {
                name: "tclassReason", title: "<spring:message code='training.request'/>", align: "center",
                filterEditorProperties: {
                    pickListProperties: {
                        showFilterEditor: false
                    },
                },
                valueMap: {
                    "1": "نیازسنجی",
                    "2": "درخواست واحد",
                    "3": "نیاز موردی",
                },
                filterOnKeypress: true
            },
            {
                name: "tclassStatus", title: "<spring:message code='class.status'/>", align: "center",
                autoFithWidth: true,
                filterEditorProperties: {
                    pickListProperties: {
                        showFilterEditor: false
                    },
                    click: function () {
                        setTimeout(() => {
                            $('.comboBoxItemPickerrtl').eq(5).remove();
                            $('.comboBoxItemPickerrtl').eq(4).remove();
                        }, 0);
                    }
                },
                valueMap: {
                    // "1": "برنامه ریزی",
                    "2": "در حال اجرا",
                    "3": "پایان یافته",
                    "4": "لغو شده",
                    "5": "اختتام"
                }
            },
            {
                name: "tclassEndingStatus",
                title: "<spring:message code="ending.class.status"/>",
                align: "center",
                filterOperator: "iContains",
                autoFithWidth: true
            },
            {
                name: "teachingMethodTitle",
                title: "روش آموزش",
                filterOperator: "iContains",
                autoFithWidth: true
            },
            {name: "classScoringMethod", hidden: true},
            {name: "classPreCourseTest", hidden: true},
            {name: "courseId", hidden: true},
            {name: "teacherId", hidden: true},
            {name: "x", hidden: true},
            {name: "trainingEvalStatus", hidden: true},
            {name: "studentOnlineEvalExecutionStatus", hidden: true},
            {name: "tclassSupervisor", hidden: true},
            {name: "classStudentOnlineEvalStatus", title: "classStudentOnlineEvalStatus", hidden: true},
            {name: "classTeacherOnlineEvalStatus", title: "classTeacherOnlineEvalStatus", hidden: true},
        ],
        getCellCSSText: function (record, rowNum, colNum) {
            let style;
            if (this.isSelected(record)) {
                style =  "background-color:" + "#fe9d2a;";
            } else if (record.workflowEndingStatusCode === 2) {
                style =  "background-color:" + "#bef5b8;";
            } else {
                if (record.classStatus === "1")
                    style =  "background-color:" + "#ffffff;";
                else if (record.classStatus === "2")
                    style =  "background-color:" + "#fff9c4;";
                else if (record.classStatus === "3")
                    style =  "background-color:" + "#cdedf5;";
                else if (record.classStatus === "4")
                    style =  "color:" + "#d6d6d7;";
            }
            if (this.getFieldName(colNum) == "teacherLastName") {
                style +=  "color: #0066cc;text-decoration: underline !important;cursor: pointer !important;}"
            }
            return style;
        },
        cellClick: function (record, rowNum, colNum) {

            if (this.getFieldName(colNum) == "teacherLastName") {
                ListGrid_teacher_edit(record.teacherId,"evaluation")
            }
        },
        selectionUpdated: function () {
            loadSelectedTab_data(Detail_Tab_Evaluation.getSelectedTab());
            set_Evaluation_Tabset_status();
        },
        createRecordComponent: function (record, colNum) {
            var fieldName = this.getFieldName(colNum);
            if (fieldName == "iconField") {

                if ((!ListGrid_class_Evaluation.getFieldByName("evaluation").hidden && record.evaluation))
                    return labelList(record.evaluation);
            } else {
                return null;
            }
        },
        //     getCellCSSText: function (record, rowNum, colNum) {
        //     if ((!ListGrid_class_Evaluation.getFieldByName("evaluation").hidden && record.evaluation === "1"))
        //         return "background-color : #c9fecf";
        //
        //     if ((!ListGrid_class_Evaluation.getFieldByName("evaluation").hidden && record.evaluation === "2"))
        //         return "background-color : #d3f4fe";
        //
        //     if ((!ListGrid_class_Evaluation.getFieldByName("evaluation").hidden && record.evaluation === "3"))
        //         return "background-color : #fedee9";
        //
        //     if ((!ListGrid_class_Evaluation.getFieldByName("evaluation").hidden && record.evaluation === "4"))
        //         return "background-color : #fefad1";
        // },
    });

    //----------------------------------------- ToolStrips -------------------------------------------------------------
    var ToolStripButton_Refresh_Evaluation = isc.ToolStripButtonRefresh.create({
        title: "<spring:message code="refresh"/>",
        click: function () {
            ListGrid_class_Evaluation.invalidateCache();
        }
    });

    var ToolStrip_Evaluation = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            <sec:authorize access="hasAuthority('Evaluation_R')">
            DynamicForm_AlarmSelection,
            isc.ToolStrip.create({
                width: "5%",
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_Refresh_Evaluation
                ]
            })
            </sec:authorize>
        ]
    });

    //----------------------------------------- LayOut -----------------------------------------------------------------
    var Detail_Tab_Evaluation = isc.TabSet.create({
        ID: "tabSetEvaluation",
        tabBarPosition: "top",
        enabled: false,
        tabs: [
            {
                id: "TabPane_during_execution",
                title: "حین اجرا",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "evaluation/during-execution-evaluation-form"})
            }
            ,
            <sec:authorize access="hasAuthority('Evaluation_Reaction')">
            {
                id: "TabPane_Reaction",
                title: "<spring:message code="evaluation.reaction"/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "evaluation/reaction-evaluation-form"})
            }
            ,
            </sec:authorize>

            <sec:authorize access="hasAuthority('Evaluation_Learning')">
            {
                id: "TabPane_Learning_PreTest",
                title: "یادگیری",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "pre-test/show-form"})
            },
            </sec:authorize>

            <sec:authorize access="hasAuthority('Evaluation_Behavior')">
            {
                id: "TabPane_Behavior",
                title: "<spring:message code="evaluation.behavioral"/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "evaluation/behavioral-evaluation-form"})
            },
            </sec:authorize>

            <sec:authorize access="hasAuthority('Evaluation_Results')">
            {
                id: "TabPane_Results",
                title: "<spring:message code="evaluation.results"/>",
                pane: null
            },
            </sec:authorize>

            <sec:authorize access="hasAuthority('Evaluation_Goals')">
            {
                id: "TabPane_EditGoalQuestions",
                title: "ویرایش سوالات ارزیابی مربوط به اهداف",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "evaluation/edit-goal-questions-form"})
            },
            </sec:authorize>

            <sec:authorize access="hasAuthority('Evaluation_Scores')">
            {
                id: "TabPane_Class_Scores",
                title: "<spring:message code="register.scores"/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "evaluation/class-scores-form"})
            }
            </sec:authorize>
        ],
        tabSelected: function (tabNum, tabPane, ID, tab, name) {
            if (isc.Page.isLoaded()) {
                loadSelectedTab_data(tab);
            }

        }

    });

    var HLayout_Actions_Evaluation = isc.HLayout.create({
        width: "100%",
        height: "1%",
        members: [ToolStrip_Evaluation]
    });

    var Hlayout_Grid_Evaluation = isc.HLayout.create({
        width: "100%",
        height: "30%",
        showResizeBar: true,
        members: [ListGrid_class_Evaluation]
    });

    var Hlayout_Tab_Evaluation = isc.HLayout.create({
        width: "100%",
        height: "45%",
        members: [
            Detail_Tab_Evaluation
        ]
    });
    let departmentFilter_form =   isc.DynamicForm.create({
        padding: 0,
        fields: [
            {
                name: "departmentFilter",
                type: "SelectItem",
                multiple: true,
                title: "<spring:message code='complex'/>",
                width: "300",
                height: 25,
                optionDataSource: isc.TrDS.create({
                    fields: [{name: "id"}, {name: "code"}, {name: "title"}, {name: "enabled"}],
                    cacheAllData: true,
                    fetchDataURL: departmentUrl + "/organ-segment-iscList/mojtame"
                }),
                autoFetchData: true,
                displayField: "title",
                valueField: "id",
                textAlign: "center",
                pickListFields: [
                    {
                        name: "title",
                        title: "<spring:message code="title"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    }
                ],
                changed: function (form, item, value) {
                    load_classList_by_department(value);
                },
                dataArrived: function (startRow, endRow, data) {
                    let list = [];
                    let listId = [];

                    for (let i = 0; i < data.allRows.size(); i++) {
                        list.push(data.allRows[i].title);
                        listId.push(data.allRows[i].id);
                    }
                        departmentFilter_form.getField("departmentFilter").setValue(listId);
                        load_classList_by_department(listId);

                }
                // icons: [
                //     {
                //         name: "clear",
                //         src: "[SKIN]actions/remove.png",
                //         width: 15,
                //         height: 15,
                //         inline: true,
                //         prompt: "پاک کردن",
                //         click: function (form, item) {
                //             item.clearValue();
                //             item.focusInItem();
                //             departmentCriteria = [];
                //             let mainCriteria = createMainCriteria();
                //             ListGrid_class_Evaluation.invalidateCache();
                //             ListGrid_class_Evaluation.fetchData(mainCriteria);
                //         }
                //     }
                // ],
            }]
    })

    var VLayout_Body_Evaluation = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            HLayout_Actions_Evaluation,
            isc.HLayout.create({
                width: "75%",
                height: "1%",
                members: [
                    labelGuide(ListGrid_class_Evaluation.getFieldByName("evaluation").valueMap),
                    <sec:authorize access="hasAuthority('Evaluation_R')">
                    departmentFilter_form
                    </sec:authorize>
                ]
            }),
            Hlayout_Grid_Evaluation,
            Hlayout_Tab_Evaluation
        ]
    });

    //----------------------------------------- Functions --------------------------------------------------------------
    function loadSelectedTab_data(tab) {
        let classRecord = ListGrid_class_Evaluation.getSelectedRecord();

        if (!(classRecord === undefined || classRecord === null)) {

            Detail_Tab_Evaluation.enable();

            switch (tab.id) {
                case "TabPane_during_execution": {
                    RestDataSource_student_DE.implicitCriteria = null;
                    RestDataSource_student_DE.fetchDataURL = tclassStudentUrl + "/students-iscList/" + classRecord.id;
                    ListGrid_student_DE.invalidateCache();
                    ListGrid_student_DE.fetchData();
                    DynamicForm_ReturnDate_DE.clearValues();
                    classRecord_DE = classRecord;
                    if (classRecord.studentOnlineEvalExecutionStatus === true ) {
                        ToolStripButton_OnlineFormIssuanceForAll_DE.setDisabled(true);

                    } else   {

                        ToolStripButton_OnlineFormIssuanceForAll_DE.setDisabled(false);

                    }

                    // ToolStrip_SendForms_DE.redraw();

                    break;
                }
                case "TabPane_Reaction": {
                    RestDataSource_student_RE.implicitCriteria = null;
                    RestDataSource_student_RE.fetchDataURL = tclassStudentUrl + "/students-iscList/" + classRecord.id;
                    ListGrid_student_RE.invalidateCache();
                    ListGrid_student_RE.fetchData();
                    DynamicForm_ReturnDate_RE.clearValues();
                    classRecord_RE = classRecord;

                    if (classRecord.trainingEvalStatus === 0 ||
                        classRecord.trainingEvalStatus === undefined ||
                        classRecord.trainingEvalStatus === null) {
                        ToolStrip_SendForms_RE.getField("sendButtonTraining").hideIcon("ok");
                        ToolStrip_SendForms_RE.getField("registerButtonTraining").hideIcon("ok");
                        // ToolStrip_SendForms_RE.getField("ToolStripButton_OnlineFormIssuanceForAll_RE").setDisabled(true);
                        // ToolStrip_SendForms_RE.getField("ToolStripButton_OnlineFormIssuanceResultForAll_RE").setDisabled(true);
                        ToolStripButton_OnlineFormIssuanceForAll_RE.setDisabled(true);
                        ToolStrip_SendForms_RE.getField("registerButtonTraining").hideIcon("ok");
                    } else if (classRecord.trainingEvalStatus === 1) {
                        ToolStrip_SendForms_RE.getField("sendButtonTraining").hideIcon("ok");
                        ToolStrip_SendForms_RE.getField("registerButtonTraining").hideIcon("ok");

                        // ToolStrip_SendForms_RE.getField("ToolStripButton_OnlineFormIssuanceForAll_RE").setDisabled(false);
                        // ToolStrip_SendForms_RE.getField("ToolStripButton_OnlineFormIssuanceResultForAll_RE").setDisabled(false);
                    } else {
                        ToolStrip_SendForms_RE.getField("sendButtonTraining").hideIcon("ok");
                        ToolStrip_SendForms_RE.getField("registerButtonTraining").hideIcon("ok");

                        // ToolStrip_SendForms_RE.getField("ToolStripButton_OnlineFormIssuanceForAll_RE").setDisabled(false);
                        // ToolStrip_SendForms_RE.getField("ToolStripButton_OnlineFormIssuanceResultForAll_RE").setDisabled(false);
                    }

                    if (classRecord.classStudentOnlineEvalStatus) {
                        ToolStripButton_OnlineFormIssuanceForAll_RE.setDisabled(true);
                        ToolStripButton_OnlineFormIssuanceResultForAll_RE.setDisabled(false);
                    } else {
                        ToolStripButton_OnlineFormIssuanceForAll_RE.setDisabled(false);
                        ToolStripButton_OnlineFormIssuanceResultForAll_RE.setDisabled(true);
                    }

                    if (classRecord.teacherEvalStatus === 0 ||
                        classRecord.teacherEvalStatus === undefined ||
                        classRecord.teacherEvalStatus === null) {

                        <sec:authorize access="hasAuthority('Evaluation_Reaction_Actions')">
                        ToolStrip_SendForms_RE.getField("sendButtonTeacher").hideIcon("ok");
                        ToolStrip_SendForms_RE.getField("sendToEls_teacher").setDisabled(true);
                        </sec:authorize>
                        ToolStrip_SendForms_RE.getField("showResultsEls_teacher").setDisabled(true);

                        ToolStrip_SendForms_RE.getField("registerButtonTeacher").hideIcon("ok");
                    } else if (classRecord.teacherEvalStatus === 1) {
                        <sec:authorize access="hasAuthority('Evaluation_Reaction_Actions')">
                        ToolStrip_SendForms_RE.getField("sendButtonTeacher").showIcon("ok");
                        </sec:authorize>
                        if (classRecord.classTeacherOnlineEvalStatus) {
                            <sec:authorize access="hasAuthority('Evaluation_Reaction_Actions')">
                            ToolStrip_SendForms_RE.getField("sendToEls_teacher").setDisabled(true);
                            </sec:authorize>
                            ToolStrip_SendForms_RE.getField("showResultsEls_teacher").setDisabled(false);
                        } else {
                            <sec:authorize access="hasAuthority('Evaluation_Reaction_Actions')">
                            ToolStrip_SendForms_RE.getField("sendToEls_teacher").setDisabled(false);
                            </sec:authorize>
                            ToolStrip_SendForms_RE.getField("showResultsEls_teacher").setDisabled(true);

                        }

                        ToolStrip_SendForms_RE.getField("registerButtonTeacher").hideIcon("ok");
                    } else {
                        <sec:authorize access="hasAuthority('Evaluation_Reaction_Actions')">
                        ToolStrip_SendForms_RE.getField("sendButtonTeacher").showIcon("ok");
                        </sec:authorize>
                        if (classRecord.classTeacherOnlineEvalStatus) {
                            <sec:authorize access="hasAuthority('Evaluation_Reaction_Actions')">
                            ToolStrip_SendForms_RE.getField("sendToEls_teacher").setDisabled(true);
                            </sec:authorize>
                            ToolStrip_SendForms_RE.getField("showResultsEls_teacher").setDisabled(false);
                        } else {
                            <sec:authorize access="hasAuthority('Evaluation_Reaction_Actions')">
                            ToolStrip_SendForms_RE.getField("sendToEls_teacher").setDisabled(false);
                            </sec:authorize>
                            ToolStrip_SendForms_RE.getField("showResultsEls_teacher").setDisabled(true);
                        }

                        ToolStrip_SendForms_RE.getField("registerButtonTeacher").showIcon("ok");
                    }
                    ToolStrip_SendForms_RE.redraw();

                    break;
                }
                case "TabPane_Learning_PreTest": {
                    classId_preTest = classRecord.id;
                    scoringMethod_preTest = classRecord.classScoringMethod;
                    RestDataSource_PreTest.fetchDataURL = questionBankTestQuestionUrl + "/preTest/" + classRecord.id + "/spec-list";
                    ListGrid_PreTest.invalidateCache();
                    ListGrid_PreTest.fetchData();
                    break;
                }
                case "TabPane_Behavior": {
                    RestDataSource_student_BE.fetchDataURL = tclassStudentUrl + "/students-iscList/" + classRecord.id;
                    ListGrid_student_BE.invalidateCache();
                    ListGrid_student_BE.fetchData();
                    DynamicForm_ReturnDate_BE.clearValues();
                    classRecord_BE = classRecord;
                    break;
                }
                case "TabPane_EditGoalQuestions" : {
                    RestDataSource_Golas_JspEGQ.fetchDataURL = evaluationUrl + "/getClassGoalsQuestions/" + classRecord.id;
                    RestDataSource_Golas_JspEGQ.fetchData();
                    ListGrid_Goal_JspEGQ.invalidateCache();
                    classRecord_JspEGQ = classRecord;
                    break;
                }
                case "TabPane_Class_Scores": {
                    if (typeof loadPage_Scores_Eval !== "undefined") {
                        loadPage_Scores_Eval();
                    }
                    break;
                }
                case "TabPane_Results": {
                    createDialog("info", "این تب فعلا مورد استفاده قرار نگرفته است");
                    break;
                }
            }

        } else {
            Detail_Tab_Evaluation.disable();
        }
    }

    function set_Evaluation_Tabset_status() {
        let classRecord = ListGrid_class_Evaluation.getSelectedRecord();
        let evaluationType = classRecord.evaluation;

        if (evaluationType === "1") {
            Detail_Tab_Evaluation.enableTab(0);
            Detail_Tab_Evaluation.enableTab(1);
            Detail_Tab_Evaluation.disableTab(2);
            Detail_Tab_Evaluation.disableTab(3);
            Detail_Tab_Evaluation.disableTab(4);
        } else if (evaluationType === "2") {
            Detail_Tab_Evaluation.enableTab(0);
            Detail_Tab_Evaluation.enableTab(1);
            Detail_Tab_Evaluation.enableTab(2);
            Detail_Tab_Evaluation.disableTab(3);
            Detail_Tab_Evaluation.disableTab(4);
        } else if (evaluationType === "3") {
            Detail_Tab_Evaluation.enableTab(0);
            Detail_Tab_Evaluation.enableTab(1);
            Detail_Tab_Evaluation.enableTab(2);
            Detail_Tab_Evaluation.enableTab(3);
            Detail_Tab_Evaluation.disableTab(4);
        } else if (evaluationType === "4") {
            Detail_Tab_Evaluation.enableTab(0);
            Detail_Tab_Evaluation.enableTab(1);
            Detail_Tab_Evaluation.enableTab(2);
            Detail_Tab_Evaluation.enableTab(3);
            Detail_Tab_Evaluation.enableTab(4);
        }
    }

    function questionSourceConvert(s) {
        switch (s.charAt(0)) {
            case "G":
                return 201;
            case "M":
                return 200;
            case "Q":
                return 199;
        }
    }

    function printStudentList(listGrid_) {
        var classRecord = ListGrid_class_Evaluation.getSelectedRecord();
        var titr = "فراگیران دوره " + classRecord.courseTitleFa +
            " دارای کد دوره: " + classRecord.courseCode +
            " و کد کلاس: " + classRecord.tclassCode +
            "\n" +
            " تاریخ شروع: " + classRecord.tclassStartDate.split("/").reverse().join("/") +
            " و تاریخ پایان: " + classRecord.tclassEndDate.split("/").reverse().join("/");

        let params = {};
        params.titr = titr;
        let localData = listGrid_.data.localData.toArray();
        let data = [];
        for (let i = 0; i < localData.length; i++) {
            let obj = {};
            obj.personnelNo = localData[i].student.personnelNo2;
            obj.nationalCode = localData[i].student.nationalCode;
            obj.firstName = localData[i].student.firstName.trim();
            obj.lastName = localData[i].student.lastName.trim();
            obj.fatherName = localData[i].student.fatherName;
            obj.mobile = localData[i].student.mobile;
            obj.ccpArea = localData[i].student.ccpArea;
            obj.ccpAssistant = localData[i].student.ccpAssistant;
            obj.ccpAffairs = localData[i].student.ccpAffairs;
            data.push(obj);
        }
        data = data.sort(new Intl.Collator("fa").compare);
        printToJasper(data, params, "ClassStudents.jasper");
    }

    ////*****load classes by department*****
    function load_classList_by_department(value) {
            if (value !== undefined) {
                let criteria = {
                    _constructor: "AdvancedCriteria",
                    operator: "and",
                    criteria: [
                        {
                            fieldName: "complexId", operator: "inSet", value: value
                        }
                    ]
                };

                if (ListGrid_class_Evaluation.implicitCriteria) {
                    let termCriteria = ListGrid_class_Evaluation.implicitCriteria.criteria.filter(c => c.fieldName != "complexId");
                    if (termCriteria.size() > 0) {
                        criteria.criteria.push(termCriteria[0]);
                    }
                }
                RestDataSource_class_Evaluation.fetchDataURL = viewClassDetailUrl + "/iscList";
                departmentCriteria = criteria;
                let mainCriteria = createMainCriteria();
                ListGrid_class_Evaluation.invalidateCache();
                ListGrid_class_Evaluation.fetchData(mainCriteria);
            } else {
                createDialog("info", "<spring:message code="msg.select.term.ask"/>", "<spring:message code="message"/>")
            }
    }
    //creating criteria in detail
    function createCriteria(fieldName, operator, value) {
        let criteriaObject = {};
        criteriaObject.fieldName = fieldName;
        criteriaObject.operator = operator;
        criteriaObject.value = value;
        return criteriaObject;
    }

    //for creating the main criteria to load the evalutions grid
    function createMainCriteria() {
        let mainCriteria = {};
        mainCriteria._constructor = "AdvancedCriteria";
        mainCriteria.operator = "and";
        mainCriteria.criteria = [];
        mainCriteria.criteria.add(evalDateCriteria);
        mainCriteria.criteria.add(evalTypeCriteria);
        mainCriteria.criteria.add(departmentCriteria);
        return mainCriteria;
    }

    function showStudentEvalToOnlineStatus() {

        let record = ListGrid_class_Evaluation.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code="msg.not.selected.record"/>");
        } else {
            let RestDataSource_Student_Eval_History = isc.TrDS.create({
                fields: [
                    {name: "code"},
                    {name: "titleClass"},
                    {name: "teacherOnlineEvalStatus"},
                    {name: "studentOnlineEvalStatus"},
                    {name: "createdBy"},
                    {name: "modifiedBy"},
                    {name: "modifiedDate"}
                ],
                fetchDataURL: classEvalAuditUrl + record.id + "/student"
            });
            let ListGrid_Student_Eval_History = isc.TrLG.create({
                width: "100%",
                height: "100%",
                dataSource: RestDataSource_Student_Eval_History,
                selectionType: "single",
                autoFetchData: true,
                initialSort: [
                    {property: "modifiedDate", direction: "descending"}
                ],
                fields: [
                    {
                        name: "code",
                        title: "<spring:message code='class.code'/>",
                        align: "center",
                        width: "10%",
                        canFilter: false
                    },
                    {
                        name: "titleClass",
                        title: "<spring:message code='class.title'/>",
                        align: "center",
                        width: "10%",
                        canFilter: false
                    },
                    {
                        name: "studentOnlineEvalStatus",
                        title: "وضعیت ارسال ارزیابی فراگیران",
                        align: "center",
                        width: "10%",
                        canFilter: false,
                        valueMap: {
                            true: "ارسال شده",
                            false: "حذف شده"
                        }
                    },
                    // {
                    //     name: "createdBy",
                    //     title: "ایجاد کننده",
                    //     align: "center",
                    //     width: "10%",
                    //     filterOperator: "equals"
                    // },
                    {
                        name: "modifiedBy",
                        title: "ویرایش کننده",
                        align: "center",
                        width: "10%",
                        formatCellValue: function (value) {
                            if (value === "anonymousUser")
                                return "آموزش آنلاین";
                            else
                                return value;
                        },
                        filterOperator: "iContains"
                    },
                    {
                        name: "modifiedDate",
                        title: "تاریخ ویرایش",
                        align: "center",
                        width: "10%",
                        canFilter: false
                    }
                ]
            });
            let Window_Student_Eval_History = isc.Window.create({
                title: "تاریخچه ارسال ارزیابی فراگیران به سیستم آنلاین",
                autoSize: false,
                width: "60%",
                height: "60%",
                canDragReposition: true,
                canDragResize: true,
                autoDraw: false,
                autoCenter: true,
                isModal: false,
                items: [
                    ListGrid_Student_Eval_History
                ]
            });
            Window_Student_Eval_History.show();
        }
    }
    function showSmsHistory() {

        let record = ListGrid_class_Evaluation.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code="msg.not.selected.record"/>");
        } else {
            let RestDataSource_Sms_History = isc.TrDS.create({
                fields: [
                    {name: "id",primaryKey: true, hidden: true},
                    {name: "createdBy"},
                    {name: "createdDate"},
                    {name: "trackingNumber"},
                    {name: "userType"},
                    {name: "smsType"},
                    {name: "nationalCode"},
                    {name: "lastName"},
                    {name: "name"},
                    {name: "objectMobile"}
                ],
                fetchDataURL: smsService+"sms-history/" + record.id
            });
            let ListGrid_Sms_History = isc.TrLG.create({
                width: "100%",
                height: "100%",
                showRecordComponents: true,
                showRecordComponentsByCell: true,
                dataSource: RestDataSource_Sms_History,
                selectionType: "single",
                autoFetchData: true,
                initialSort: [
                    {property: "modifiedDate", direction: "descending"}
                ],
                fields: [
                    {
                        name: "id",
                        hidden: true,
                         align: "center",
                         canFilter: false
                    },{
                        name: "trackingNumber",
                        title: "trackingNumber",
                        align: "center",
                        width: "10%",
                        hidden:true,
                        canFilter: false
                    },
                    {
                        name: "name",
                        title: "نام",
                        align: "center",
                        width: "10%",
                        canFilter: false
                    }, {
                        name: "lastName",
                        title: "نام خانوادگی",
                        align: "center",
                        width: "10%",
                        canFilter: false
                    }, {
                        name: "nationalCode",
                        title: "کد ملی",
                        align: "center",
                        width: "10%",
                        canFilter: false
                    }, {
                        name: "smsType",
                        title: "نوع اس ام اس",
                        align: "center",
                        width: "10%",
                        canFilter: false
                    }, {
                        name: "userType",
                        title: "نوع کاربر",
                        align: "center",
                        width: "10%",
                        canFilter: false
                    },
                    {
                        name: "objectMobile",
                        title: "موبایل",
                        align: "center",
                        width: "10%",
                        canFilter: false
                    },
                    {
                        name: "createdBy",
                        title: "ایجاد کننده",
                        align: "center",
                        width: "10%",
                        filterOperator: "equals"
                    },
                    {
                        name: "createdDate",
                        title: "تاریخ ویرایش",
                        align: "center",
                        width: "10%",
                        canFilter: false
                    },
                    {
                        name: "requestTracker",
                        title: "جزییات پیام",
                        align: "center",
                        width: "10%",
                        canFilter: false
                    }
                ], createRecordComponent: function (record, colNum) {

                    let fieldName = this.getFieldName(colNum);
                    if (fieldName === "requestTracker") {
                        return isc.IButton.create({
                            layoutAlign: "center",
                            // disabled: !record.onlineFinalExamStatus,
                            title: "جزییات پیام",
                            margin: 3,
                            click: function () {
                                wait.show();
                                showSmsDetail(record.id);
                            }
                        });
                    } else {
                        return null;
                    }

                }
            });
            let Window_Sms_History = isc.Window.create({
                title: "تاریخچه ارسال sms",
                autoSize: false,
                placement: "fillScreen",
                // width: "60%",
                // height: "60%",
                canDragReposition: true,
                canDragResize: true,
                autoDraw: false,
                autoCenter: true,
                isModal: false,
                items: [
                    ListGrid_Sms_History
                ]
            });
            Window_Sms_History.show();
        }
    }

    function showTeacherEvalToOnlineStatus() {

        let record = ListGrid_class_Evaluation.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code="msg.not.selected.record"/>");
        } else {
            let RestDataSource_Teacher_Eval_History = isc.TrDS.create({
                fields: [
                    {name: "code"},
                    {name: "titleClass"},
                    {name: "teacherOnlineEvalStatus"},
                    {name: "studentOnlineEvalStatus"},
                    {name: "createdBy"},
                    {name: "modifiedBy"},
                    {name: "modifiedDate"}
                ],
                fetchDataURL: classEvalAuditUrl + record.id + "/teacher"
            });
            let ListGrid_Teacher_Eval_History = isc.TrLG.create({
                width: "100%",
                height: "100%",
                dataSource: RestDataSource_Teacher_Eval_History,
                selectionType: "single",
                autoFetchData: true,
                initialSort: [
                    {property: "modifiedDate", direction: "descending"}
                ],
                fields: [
                    {
                        name: "code",
                        title: "<spring:message code='class.code'/>",
                        align: "center",
                        width: "10%",
                        canFilter: false
                    },
                    {
                        name: "titleClass",
                        title: "<spring:message code='class.title'/>",
                        align: "center",
                        width: "10%",
                        canFilter: false
                    },
                    {
                        name: "teacherOnlineEvalStatus",
                        title: "وضعیت ارسال ارزیابی مدرس",
                        align: "center",
                        width: "10%",
                        canFilter: false,
                        valueMap: {
                            true: "ارسال شده",
                            false: "حذف شده"
                        }
                    },
                    // {
                    //     name: "createdBy",
                    //     title: "ایجاد کننده",
                    //     align: "center",
                    //     width: "10%",
                    //     filterOperator: "iContains"
                    // },
                    {
                        name: "modifiedBy",
                        title: "ویرایش کننده",
                        align: "center",
                        width: "10%",
                        formatCellValue: function (value) {
                            if (value === "anonymousUser")
                                return "آموزش آنلاین";
                            else
                                return value;
                        },
                        filterOperator: "iContains"
                    },
                    {
                        name: "modifiedDate",
                        title: "تاریخ ویرایش",
                        align: "center",
                        width: "10%",
                        canFilter: false
                    }
                ]
            });
            let Window_Teacher_Eval_History = isc.Window.create({
                title: "نمایش تاریخچه ارزیابی مدرس به سیستم آنلاین",
                autoSize: false,
                width: "60%",
                height: "60%",
                canDragReposition: true,
                canDragResize: true,
                autoDraw: false,
                autoCenter: true,
                isModal: false,
                items: [
                    ListGrid_Teacher_Eval_History
                ]
            });
            Window_Teacher_Eval_History.show();
        }
    }
    function showSmsDetail(requestId) {

        isc.RPCManager.sendRequest(TrDSRequest(smsService+"sms-detail/" + requestId , "GET", null, function (resp) {
            if(resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                wait.close();
                 createDialog("info", resp.httpResponseText, "جزییات");

            } else {
                wait.close();
                createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
            }
        }));
    }
    // </script>
