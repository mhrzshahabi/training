<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>

// <script>

    let isCriteriaCategoriesChanged_EIBAR = false;
    let initialLayoutStyle_EIBAR = "vertical";

    //------------------------------------------------- REST DataSources------------------------------------------------

    let RestDataSource_Class_EIBAR = isc.TrDS.create({
        ID: "classDS",
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleClass"},
            {name: "code"},
            {name: "course.titleFa"}
        ],
        fetchDataURL: classUrl + "info-tuple-list"
    });

    let RestDataSource_QuestionDomain_EIBAR = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true}
        ],
        fetchDataURL: parameterUrl + "/iscList/test"
    });

    let RestDataSource_Result_EIBAR = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "courseCode"},
            {name: "classCode"},
            {name: "teacherFirstName"},
            {name: "teacherLastName"},
            {name: "teacherNationalCode"},
            {name: "evaluationAffairs"},
            {name: "postTitle"},
            {name: "postCode"},
            {name: "personnelNo2"},
            {name: "studentAcceptanceStatus"},
            {name: "score"},
            {name: "evaluationId"},
            {name: "evaluationAverage"},
            {name: "evaluationField"}
        ],
        fetchDataURL: evalAnswerUrl + "evaluation-index-by-field"
    });
    //------------------------------------------------- Dynamic Form ---------------------------------------------------

    let DynamicForm_EIBAR = isc.DynamicForm.create({
        align: "right",
        titleAlign: "center",
        showInlineErrors: true,
        showErrorText: false,
        numCols: 4,
        colWidths: ["5%", "25%", "5%", "25%","5%","25%"],
        fields: [
            {
                name: "tclassCode",
                title: "کد کلاس",
                hint: "کد کلاس را انتخاب نمائيد",
                showHintInField: true,
                icons: [{
                    src: "[SKIN]/pickers/search_picker.png",
                    click: function () {
                        // DynamicForm_EIBAR.clearValues();
                        Window_SelectClasses_EIBAR.show();
                    }
                }],
                keyPressFilter: "[A-Z|0-9|;-]"
            },
            {
                name: "domainId",
                title: "<spring:message code='question.domain'/>",
                type: "SelectItem",
                multiple: true,
                required: false,
                textAlign: "center",
                optionDataSource: RestDataSource_QuestionDomain_EIBAR,
                valueField: "title",
                displayField: "title",
                pickListFields: [
                    {name: "title"},
                    {name: "code"}
                ]
            },
            {
                name: "startDate1",
                ID: "startDate1_EIBAR",
                title: "تاریخ شروع کلاس: از",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('startDate1_EIBAR', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("startDate2","تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد" ,true);
                        form.clearFieldErrors("startDate1", true);
                        startDateCheck_Order_JspStaticalUnitReport = true;
                        startDate1Check_JspStaticalUnitReport = true;
                        return;
                    }

                    var dateCheck;
                    var endDate = form.getValue("startDate2");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        startDate1Check_JspStaticalUnitReport = false;
                        startDateCheck_Order_JspStaticalUnitReport = true;
                        form.clearFieldErrors("startDate1", true);
                        form.addFieldErrors("startDate1", "<spring:message code='msg.correct.date'/>", true);
                    } else if (endDate < value) {
                        startDateCheck_Order_JspStaticalUnitReport = false;
                        startDate1Check_JspStaticalUnitReport = true;
                        form.clearFieldErrors("startDate1", true);
                        form.addFieldErrors("startDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    }
                    else {
                        startDate1Check_JspStaticalUnitReport = true;
                        startDateCheck_Order_JspStaticalUnitReport = true;
                        form.clearFieldErrors("startDate1", true);
                    }
                }
            },
            {
                name: "startDate2",
                ID: "startDate2_EIBAR",
                title: "تا",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('startDate2_EIBAR', this, 'ymd', '/', 'right');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("startDate1","تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد" ,true);
                        form.clearFieldErrors("startDate2", true);
                        startDateCheck_Order_JspStaticalUnitReport = true;
                        startDate2Check_JspStaticalUnitReport = true;
                        return;
                    }

                    var dateCheck;
                    dateCheck = checkDate(value);
                    var startDate = form.getValue("startDate1");
                    if (dateCheck === false) {
                        startDate2Check_JspStaticalUnitReport = false;
                        startDateCheck_Order_JspStaticalUnitReport = true;
                        form.clearFieldErrors("startDate2", true);
                        form.addFieldErrors("startDate2", "<spring:message code='msg.correct.date'/>", true);
                    } else if (startDate != undefined && value < startDate) {
                        form.clearFieldErrors("startDate2", true);
                        form.addFieldErrors("startDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        startDate2Check_JspStaticalUnitReport = true;
                        startDateCheck_Order_JspStaticalUnitReport = false;
                    } else {
                        form.clearFieldErrors("startDate2", true);
                        startDate2Check_JspStaticalUnitReport = true;
                        startDateCheck_Order_JspStaticalUnitReport = true;
                    }
                }
            },
            {
                name: "endDate1",
                ID: "endDate1_EIBAR",
                title: "تاریخ پایان کلاس: از",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('endDate1_EIBAR', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("endDate2","تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد" ,true);
                        form.clearFieldErrors("endDate1", true);
                        endDateCheck_Order_JspStaticalUnitReport = true;
                        endDate1Check_JspStaticalUnitReport = true;
                        return;
                    }

                    var dateCheck;
                    var endDate = form.getValue("endDate2");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        endDate1Check_JspStaticalUnitReport = false;
                        endDateCheck_Order_JspStaticalUnitReport = true;
                        form.clearFieldErrors("endDate1", true);
                        form.addFieldErrors("endDate1", "<spring:message code='msg.correct.date'/>", true);
                    } else if (endDate < value) {
                        endDateCheck_Order_JspStaticalUnitReport = false;
                        endDate1Check_JspStaticalUnitReport = true;
                        form.clearFieldErrors("endDate1", true);
                        form.addFieldErrors("endDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    } else {
                        endDate1Check_JspStaticalUnitReport = true;
                        endDateCheck_Order_JspStaticalUnitReport = true;
                        form.clearFieldErrors("endDate1", true);
                    }
                }
            },
            {
                name: "endDate2",
                ID: "endDate2_EIBAR",
                title: "تا",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('endDate2_EIBAR', this, 'ymd', '/', 'right');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("endDate1","تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد" ,true);
                        form.clearFieldErrors("endDate2", true);
                        endDateCheck_Order_JspStaticalUnitReport = true;
                        endDate2Check_JspStaticalUnitReport = true;
                        return;
                    }

                    var dateCheck;
                    dateCheck = checkDate(value);
                    var startDate = form.getValue("endDate1");
                    if (dateCheck === false) {
                        endDate2Check_JspStaticalUnitReport = false;
                        endDateCheck_Order_JspStaticalUnitReport = true;
                        form.clearFieldErrors("endDate2", true);
                        form.addFieldErrors("endDate2", "<spring:message code='msg.correct.date'/>", true);
                    } else if (startDate != undefined && value < startDate) {
                        form.clearFieldErrors("endDate2", true);
                        form.addFieldErrors("endDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        endDate2Check_JspStaticalUnitReport = true;
                        endDateCheck_Order_JspStaticalUnitReport = false;
                    } else {
                        form.clearFieldErrors("endDate2", true);
                        endDate2Check_JspStaticalUnitReport = true;
                        endDateCheck_Order_JspStaticalUnitReport = true;
                    }
                }
            }
        ]
    });

    let DynamicForm_SelectClassesEIBAR = isc.DynamicForm.create({
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
                layoutStyle: initialLayoutStyle_EIBAR,
                optionDataSource: RestDataSource_Class_EIBAR
            }
        ]
    });

    //------------------------------------------------- Main Window ----------------------------------------------------

    let IButton_ConfirmClassesSelections_EIBAR = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 300,
        click: function () {
            let criteriaDisplayValues = "";
            let selectorDisplayValues = DynamicForm_SelectClassesEIBAR.getItem("class.code").getValue();
            if (DynamicForm_EIBAR.getField("tclassCode").getValue() != undefined
                && DynamicForm_EIBAR.getField("tclassCode").getValue() != "") {
                criteriaDisplayValues = DynamicForm_SelectClassesEIBAR.getItem("class.code").getValue().join(",");
                let ALength = criteriaDisplayValues.length;
                let lastChar = criteriaDisplayValues.charAt(ALength - 1);
                if (lastChar != ",")
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

            criteriaDisplayValues = criteriaDisplayValues == ",undefined" ? "" : criteriaDisplayValues;

            DynamicForm_EIBAR.getField("tclassCode").setValue(criteriaDisplayValues);
            Window_SelectClasses_EIBAR.close();
        }
    });

    let Window_SelectClasses_EIBAR = isc.Window.create({
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
                    DynamicForm_SelectClassesEIBAR,
                    IButton_ConfirmClassesSelections_EIBAR
                ]
            })
        ]
    });
    let ToolStripButton_Excel_EIBAR = isc.ToolStripButtonExcel.create({

        click: function () {
            makeExcelOutput();
        }
    });
    let ToolStripButton_Refresh_EIBAR = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_Result_EIBAR.invalidateCache();
        }
    });

    let ToolStrip_Actions_EIBAR = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_EIBAR,
                        ToolStripButton_Excel_EIBAR
                    ]
                })
            ]
    });

    let IButton_Report_EIBAR = isc.IButtonSave.create({
        top: 260,
        title: "نمایش گزارش",
        width: 300,
        click: function () {
            ListGrid_Result_EIBAR.invalidateCache();
            let dataValues = organSegmentFilter.getCriteria(DynamicForm_EIBAR.getValuesAsAdvancedCriteria());
            if (dataValues !== undefined && dataValues !== null) {
                for (let i = 0; i < dataValues.criteria.length; i++) {
                    if (dataValues.criteria[i].fieldName === "complexTitle") {
                        dataValues.criteria[i].fieldName = "studentComplex"
                    }
                    if (dataValues.criteria[i].fieldName === "assistant") {
                        dataValues.criteria[i].fieldName = "studentAssistant"
                    }
                    if (dataValues.criteria[i].fieldName === "affairs") {
                        dataValues.criteria[i].fieldName = "studentAffairs"
                    }
                    if (dataValues.criteria[i].fieldName === "section") {
                        dataValues.criteria[i].fieldName = "studentSection"
                    }
                    if (dataValues.criteria[i].fieldName === "unit") {
                        dataValues.criteria[i].fieldName = "studentUnit"
                    }
                    if (dataValues.criteria[i].fieldName === "tclassCode") {
                        dataValues.criteria[i].fieldName = "classCode"
                    }
                    if (dataValues.criteria[i].fieldName === "domainId") {
                        dataValues.criteria[i].fieldName = "evaluationField"
                    }
                    if (dataValues.criteria[i].fieldName === "startDate1") {
                        dataValues.criteria[i].fieldName = "classStartDate";
                        dataValues.criteria[i].operator = "greaterOrEqual";
                    }
                    if (dataValues.criteria[i].fieldName === "startDate2") {
                        dataValues.criteria[i].fieldName = "classStartDate";
                        dataValues.criteria[i].operator = "lessOrEqual";
                    }
                    if (dataValues.criteria[i].fieldName === "endDate1") {
                        dataValues.criteria[i].fieldName = "classEndDate";
                        dataValues.criteria[i].operator = "greaterOrEqual";
                    }
                    if (dataValues.criteria[i].fieldName === "endDate2") {
                        dataValues.criteria[i].fieldName = "classEndDate";
                        dataValues.criteria[i].operator = "lessOrEqual";
                    }
                }
            }
            ListGrid_Result_EIBAR.fetchData(dataValues);
        }
    });

    let IButton_Clear_EIBAR = isc.IButtonSave.create({
        top: 260,
        title: "پاک کردن",
        width: 300,
        click: function () {

            ListGrid_Result_EIBAR.setData([]);
            DynamicForm_EIBAR.clearValues();
            DynamicForm_EIBAR.clearErrors();
            organSegmentFilter.clearValues();
            ListGrid_Result_EIBAR.setFilterEditorCriteria(null);
        }
    });

    let HLayOut_Confirm_EIBAR = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_Report_EIBAR,
            IButton_Clear_EIBAR
        ]
    });

    let ListGrid_Result_EIBAR = isc.TrLG.create({
        filterOnKeypress: false,
        showFilterEditor: true,
        gridComponents: ["filterEditor", "header", "body"],
        dataSource: RestDataSource_Result_EIBAR,
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {
                name: "courseCode",
                title: "<spring:message code="course.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {name: "classCode", title: "<spring:message code="class.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "classStartDate", title: "<spring:message code="class.start.date"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "classEnd", title: "<spring:message code="class.end.date"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "fullName", title: "<spring:message code="student.full.name"/>", filterOperator: "iContains", autoFitWidth: true},
            {
                name: "studentNationalCode",
                title: "<spring:message code="student.national.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {name: "studentComplex", title: "<spring:message code="student.complex"/>", filterOperator: "iContains", autoFitWidth: true},
            {
                name: "studentAssistant",
                title: "<spring:message code="student.assistant"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {name: "studentAffairs", title: "<spring:message code="student.affair"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentSection", title: "<spring:message code="student.section"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentUnit", title: "<spring:message code="student.unit"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "postTitle", title: "<spring:message code="post.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "postCode", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {
                name: "personnelNo2",
                title: "<spring:message code="personnel.no.6.digits"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "studentAcceptanceStatus",
                title: "<spring:message code="acceptanceState.state"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {name: "score", title: "<spring:message code="score"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "evaluationField", title: "<spring:message code="question.domain"/>", filterOperator: "iContains", autoFitWidth: true},
            {
                name: "evaluationAverage",
                title: "<spring:message code="average.student.evaluation.score"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "evaluationFieldAverage",
                title: "<spring:message code="evaluation.field.average"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            }
        ]
    });

    let organSegmentFilter = init_OrganSegmentFilterDF(true, true, true, false, false, null, "complexTitle","assistant","affairs", "section", "unit");

    let VLayout_Body_EIBAR = isc.VLayout.create({
        align: "right",
        titleAlign:"center",
        padding: 0,
        width: "100%",
        height: "100%",
        members: [
            ToolStrip_Actions_EIBAR,
            organSegmentFilter,
            DynamicForm_EIBAR,
            HLayOut_Confirm_EIBAR,
            ListGrid_Result_EIBAR
        ]
    });

    //------------------------------------------------- Functions ------------------------------------------------------

    function makeExcelOutput() {
        if (ListGrid_Result_EIBAR.getOriginalData().localData === undefined) {
            createDialog("info", "ابتدا نمایش گزارش را انتخاب کنید");
        } else {
            let url = evalAnswerUrl + "excel/evaluation-index-by-field";
            ExportToFile.downloadExcelRestUrl(null, ListGrid_Result_EIBAR, url, 0, null, '', "<spring:message code="evaluation.index.by.field.report"/>", ListGrid_Result_EIBAR.getCriteria(), null);
        }
    }


    // </script>