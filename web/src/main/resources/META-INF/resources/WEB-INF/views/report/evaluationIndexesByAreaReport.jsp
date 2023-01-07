<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>

// <script>

    let reportCriteria_EIBAR;
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
        ID: "classDS",
        fields: [
            {name: "id", primaryKey: true},
            {name: "courseCode"},
            {name: "classCode"},
            {name: "name"},
            {name: "family"},
            {name: "nationalCode"},
            {name: "affair"},
            {name: "post"},
            {name: "postCode"},
            {name: "empNo"},
            {name: "studentAcceptanceStatus"},
            {name: "score"},
            {name: "evalId"},
            {name: "average"},
        ],
        fetchDataURL: classUrl + "info-tuple-list"
    });
    //------------------------------------------------- Dynamic Form ---------------------------------------------------

    let DynamicForm_EIBAR = isc.DynamicForm.create({
        align: "right",
        titleAlign: "center",
        showInlineErrors: true,
        showErrorText: false,
        numCols: 4,
        colWidths: ["10%", "40%", "10%", "40%"],
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
                valueField: "id",
                displayField: "title",
                pickListFields: [
                    {name: "title"},
                    {name: "code"}
                ]
            },
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
            let selectorDisplayValues = DynamicForm_EIBAR.getItem("class.code").getValue();
            if (DynamicForm_SelectClassesEIBAR.getField("tclassCode").getValue() != undefined
                && DynamicForm_SelectClassesEIBAR.getField("tclassCode").getValue() != "") {
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

            DynamicForm_SelectClassesEIBAR.getField("tclassCode").setValue(criteriaDisplayValues);
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

            reportCriteria_EIBAR = null;
            let form = DynamicForm_EIBAR;

            if (form.getValue("endDate") == null || form.getValue("startDate") == null) {
                createDialog("info", "بازه خاتمه کلاس مشخص نشده است");
                return;
            }

            if (form.getValue("endDate") < form.getValue("startDate")) {
                createDialog("info", "تاریخ پایان نمی تواند کوچکتر از تاریخ شروع باشد");
                return;
            }

            data_values = DynamicForm_EIBAR.getValuesAsAdvancedCriteria();

            for (let i = 0; i < data_values.criteria.size(); i++) {

                if (data_values.criteria[i].fieldName === "courseCategory") {
                    data_values.criteria[i].fieldName = "categoryTitleFa";
                    data_values.criteria[i].operator = "inSet";
                } else if (data_values.criteria[i].fieldName === "courseSubCategory") {
                    data_values.criteria[i].fieldName = "subCategoryId";
                    data_values.criteria[i].operator = "inSet";
                } else if (data_values.criteria[i].fieldName === "startDate") {
                    data_values.criteria[i].fieldName = "classEndDate";
                    data_values.criteria[i].operator = "greaterOrEqual";
                } else if (data_values.criteria[i].fieldName === "endDate") {
                    data_values.criteria[i].fieldName = "classEndDate";
                    data_values.criteria[i].operator = "lessOrEqual";
                }
            }

            reportCriteria_EIBAR = data_values;
            ListGrid_Result_EIBAR.invalidateCache();
            ListGrid_Result_EIBAR.fetchData(reportCriteria_EIBAR);
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
            {name: "courseCode"},
            {name: "classCode"},
            {name: "name"},
            {name: "family"},
            {name: "nationalCode"},
            {name: "affair"},
            {name: "post"},
            {name: "postCode"},
            {name: "empNo"},
            {name: "studentAcceptanceStatus"},
            {name: "score"},
            {name: "id"},
            {name: "average"},
        ]
    });

    let VLayout_Body_EIBAR = isc.VLayout.create({
        border: "2px solid blue",
        padding: 20,
        width: "100%",
        height: "100%",
        members: [
            ToolStrip_Actions_EIBAR,
            DynamicForm_EIBAR,
            HLayOut_Confirm_EIBAR,
            ListGrid_Result_EIBAR
        ]
    });

    //------------------------------------------------- Functions ------------------------------------------------------

    function makeExcelOutput() {
        if (ListGrid_Result_EIBAR.getOriginalData().localData === undefined)
            createDialog("info", "ابتدا چاپ گزارش را انتخاب کنید");
        else
            ExportToFile.downloadExcelRestUrl(null, ListGrid_Result_EIBAR, viewCoursesEvaluationReportUrl + "/iscList", 0, null, '', "گزارش ارزیابی دوره ها", reportCriteria_EIBAR, null);
    }


    // </script>