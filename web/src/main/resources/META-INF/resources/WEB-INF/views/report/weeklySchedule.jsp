<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>

// <script>

    let isCriteriaHoldingClassChanged_WS = false;
    
    //------------------------------------------------- REST DataSources------------------------------------------------

    let RestDataSource_Class_WS = isc.TrDS.create({
        ID: "classDS",
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleClass"},
            {name: "code"},
            {name: "course.titleFa"}
        ],
        fetchDataURL: classUrl + "info-tuple-list"
    });

    let RestDataSource_class_Holding_Class_Type_List = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>"},
            {name: "code", title: "<spring:message code="code"/>"}
        ],
        fetchDataURL: parameterValueUrl + "/listByCode/HoldingClassType"
    });

    let RestDataSource_Teaching_Method_Class_Holding_Type = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>"},
            {name: "code", title: "<spring:message code="code"/>"},
            {name: "parameterTitle", title: "<spring:message code="type"/>"}
        ],
        allowAdvancedCriteria: true,
    });

    let DynamicForm_WS = isc.DynamicForm.create({
        align: "right",
        titleAlign: "center",
        showInlineErrors: true,
        showErrorText: false,
        numCols: 4,
        colWidths: ["5%", "25%", "5%", "25%", "5%", "25%"],
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
                        Window_SelectClasses_WS.show();
                    }
                }],
                keyPressFilter: "[A-Z|0-9|;-]"
            },
            {
                name: "temp",
                title: "",
                canEdit: false
            },
            {
                name: "startDate1",
                ID: "startDate1_WS",
                title: "تاریخ شروع کلاس",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                showHintInField: true,
                required: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('startDate1_WS', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if (value == undefined || value == null) {
                        form.clearFieldErrors("startDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
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
                    } else {
                        startDate1Check_JspStaticalUnitReport = true;
                        startDateCheck_Order_JspStaticalUnitReport = true;
                        form.clearFieldErrors("startDate1", true);
                    }
                }
            },
            {
                name: "endDate1",
                ID: "endDate1_WS",
                title: "تاریخ پایان کلاس",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                showHintInField: true,
                required: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('endDate1_WS', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if (value == undefined || value == null) {
                        form.clearFieldErrors("endDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
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
                name: "holdingClassTypeId",
                title: "<spring:message code="course_eruntype"/>:",
                type: "SelectItem",
                multiple: true,
                optionDataSource: RestDataSource_class_Holding_Class_Type_List,
                displayField: "title",
                autoFetchData: true,
                valueField: "code",
                textAlign: "center",
                textMatchStyle: "substring",
                pickListFields: [
                    {name: "title", align: "center", autoFitWidth: true, autoFitWidthApproach: true},
                ],
                pickListProperties: {
                    sortField: 0,
                    showFilterEditor: false
                },
                changed: function (form, item, value) {
                    debugger

                    if (value === null) {
                        form.getItem("teachingMethodId").setOptionDataSource(null);
                        form.getItem("teachingMethodId").setValue(null);
                        form.getItem("teachingMethodId").disable()
                        return;
                    }

                    let codes = []

                    value.forEach(code => {
                        codes.push(code.concat('HoldingClassType'))
                    })

                    form.getItem("teachingMethodId").enable();
                    RestDataSource_Teaching_Method_Class_Holding_Type.fetchDataURL = parameterValueUrl + "/listByCode/v3?codes=" + codes
                    RestDataSource_Teaching_Method_Class_Holding_Type.fetchData();

                },
            },
            {
                name: "teachingMethodId",
                title: "<spring:message code='teaching.type'/>:",
                type: "SelectItem",
                multiple: true,
                disabled: true,
                optionDataSource: RestDataSource_Teaching_Method_Class_Holding_Type,
                displayField: "title",
                autoFetchData: false,
                valueField: "id",
                textAlign: "center",
                textMatchStyle: "substring",
                pickListFields: [
                    {name: "title", align: "center", autoFitWidth: false, autoFitWidthApproach: true},
                    {name: "parameterTitle", align: "center", autoFitWidth: false, autoFitWidthApproach: true}
                ],
                pickListProperties: {
                    sortField: 0,
                    showFilterEditor: false
                },
            },
        ]
    });

    let DynamicForm_SelectClassesWS = isc.DynamicForm.create({
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
                layoutStyle: "vertical",
                optionDataSource: RestDataSource_Class_WS
            }
        ]
    });

    //------------------------------------------------- Main Window ----------------------------------------------------

    let IButton_ConfirmClassesSelections_WS = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 300,
        click: function () {
            let criteriaDisplayValues = "";
            let selectorDisplayValues = DynamicForm_SelectClassesWS.getItem("class.code").getValue();
            if (DynamicForm_WS.getField("tclassCode").getValue() != undefined
                && DynamicForm_WS.getField("tclassCode").getValue() != "") {
                criteriaDisplayValues = DynamicForm_SelectClassesWS.getItem("class.code").getValue().join(",");
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

            DynamicForm_WS.getField("tclassCode").setValue(criteriaDisplayValues);
            Window_SelectClasses_WS.close();
        }
    });

    let Window_SelectClasses_WS = isc.Window.create({
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
                    DynamicForm_SelectClassesWS,
                    IButton_ConfirmClassesSelections_WS
                ]
            })
        ]
    });

    let ToolStripButton_Excel_WS = isc.ToolStripButtonExcel.create({

        click: function () {
            makeExcelOutput();
        }
    });

    let ToolStripButton_Refresh_WS = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_Result_WS.invalidateCache();
        }
    });

    let ToolStrip_Actions_WS = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_WS,
                        ToolStripButton_Excel_WS
                    ]
                })
            ]
    });

    let IButton_Report_WS = isc.IButtonSave.create({
        top: 260,
        title: "نمایش گزارش",
        width: 300,
        click: function () {
            ListGrid_Result_WS.invalidateCache();
            let dataValues = organSegmentFilter.getCriteria(DynamicForm_WS.getValuesAsAdvancedCriteria());
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
                    if (dataValues.criteria[i].fieldName === "startDate1") {
                        dataValues.criteria[i].fieldName = "classStartDate";
                        dataValues.criteria[i].operator = "greaterOrEqual";
                    }
                    if (dataValues.criteria[i].fieldName === "endDate1") {
                        dataValues.criteria[i].fieldName = "classEndDate";
                        dataValues.criteria[i].operator = "greaterOrEqual";
                    }
                }
            }
            ListGrid_Result_WS.fetchData(dataValues);
        }
    });

    let IButton_Clear_WS = isc.IButtonSave.create({
        top: 260,
        title: "پاک کردن",
        width: 300,
        click: function () {

            ListGrid_Result_WS.setData([]);
            DynamicForm_WS.clearValues();
            DynamicForm_WS.clearErrors();
            organSegmentFilter.clearValues();
            ListGrid_Result_WS.setFilterEditorCriteria(null);
        }
    });

    let HLayOut_Confirm_WS = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_Report_WS,
            IButton_Clear_WS
        ]
    });

    let ListGrid_Result_WS = isc.TrLG.create({
        filterOnKeypress: false,
        showFilterEditor: true,
        gridComponents: ["filterEditor", "header", "body"],
        // dataSource: RestDataSource_Result_WS,
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {
                name: "sessionDate",
                title: "<spring:message code="session.date"/>",
                filterOperator: "iContains"
            },
            {
                name: "sessionTime",
                title: "<spring:message code="session.time"/>",
                filterOperator: "iContains"
            },
            {
                name: "classTitle",
                title: "<spring:message code="class.title"/>",
                filterOperator: "iContains"
            },
            {
                name: "classCode",
                title: "<spring:message code="class.code"/>",
                filterOperator: "iContains"
            },
            {
                name: "teachingMethod",
                title: "<spring:message code="teaching.method"/>",
                filterOperator: "iContains"
            },
            {
                name: "fullName",
                title: "<spring:message code="teacher.name"/>",
                filterOperator: "iContains"
            },
            {
                name: "teacherType",
                title: "<spring:message code="teacher.type"/>",
                filterOperator: "iContains"
            },
            {
                name: "teacherMobile",
                title: "<spring:message code="teacher.mobile"/>",
                filterOperator: "iContains"
            },
        ]
    });

    let organSegmentFilter = init_OrganSegmentFilterDF(true, true, true, false, false, null, "complexTitle", "assistant", "affairs", "section", "unit");
    organSegmentFilter.getItem("department.mojtameCode").required = true

    let VLayout_Body_WS = isc.VLayout.create({
        align: "right",
        titleAlign: "center",
        padding: 0,
        width: "100%",
        height: "100%",
        members: [
            ToolStrip_Actions_WS,
            organSegmentFilter,
            DynamicForm_WS,
            HLayOut_Confirm_WS,
            ListGrid_Result_WS
        ]
    });

    //------------------------------------------------- Functions ------------------------------------------------------

    function makeExcelOutput() {
        if (ListGrid_Result_WS.getOriginalData().localData === undefined) {
            createDialog("info", "ابتدا نمایش گزارش را انتخاب کنید");
        } else {
            let url = evalAnswerUrl + "excel/evaluation-index-by-field";
            ExportToFile.downloadExcelRestUrl(null, ListGrid_Result_WS, url, 0, null, '', "<spring:message code="evaluation.index.by.field.report"/>", ListGrid_Result_WS.getCriteria(), null);
        }
    }


    // </script>