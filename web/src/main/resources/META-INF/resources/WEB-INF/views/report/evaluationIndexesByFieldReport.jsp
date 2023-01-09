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
        colWidths: ["5%", "45%", "5%", "45%"],
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
            let dataValues = DynamicForm_EIBAR.getValuesAsAdvancedCriteria();
            if (dataValues !== undefined && dataValues !== null) {
                for (let i = 0; i < dataValues.criteria.length; i++) {
                    if (dataValues.criteria[i].fieldName == "tclassCode") {
                        dataValues.criteria[i].fieldName = "classCode"
                    }
                    if (dataValues.criteria[i].fieldName == "domainId") {
                        dataValues.criteria[i].fieldName = "evaluationField"
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
            {name: "courseCode", title: "<spring:message code="course.code"/>", filterOperator: "iContains"},
            {name: "classCode", title: "<spring:message code="class.code"/>", filterOperator: "iContains"},
            {name: "teacherFirstName", title: "<spring:message code="teacher.name"/>", filterOperator: "iContains"},
            {name: "teacherLastName", title: "<spring:message code="teacher.last.name"/>", filterOperator: "iContains"},
            {
                name: "teacherNationalCode",
                title: "<spring:message code="teacher.national"/>",
                filterOperator: "iContains"
            },
            {name: "evaluationAffairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains"},
            {name: "postTitle", title: "<spring:message code="post.title"/>", filterOperator: "iContains"},
            {name: "postCode", title: "<spring:message code="post.code"/>", filterOperator: "iContains"},
            {
                name: "personnelNo2",
                title: "<spring:message code="personnel.no.6.digits"/>",
                filterOperator: "iContains"
            },
            {
                name: "studentAcceptanceStatus",
                title: "<spring:message code="acceptanceState.state"/>",
                filterOperator: "iContains"
            },
            {name: "score", title: "<spring:message code="score"/>", filterOperator: "iContains"},
            {
                name: "evaluationId",
                title: "<spring:message code="evaluation"/>",
                filterOperator: "iContains",
                hidden: true
            },
            {
                name: "evaluationAverage",
                title: "<spring:message code="average.student.evaluation.score"/>",
                filterOperator: "iContains"
            },
            {name: "evaluationField", title: "<spring:message code="question.domain"/>", filterOperator: "iContains"}
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
        if (ListGrid_Result_EIBAR.getOriginalData().localData === undefined) {
            createDialog("info", "ابتدا نمایش گزارش را انتخاب کنید");
        } else {
            let url = evalAnswerUrl + "excel/evaluation-index-by-field";
            ExportToFile.downloadExcelRestUrl(null, ListGrid_Result_EIBAR, url, 0, null, '', "<spring:message code="evaluation.index.by.field.report"/>", ListGrid_Result_EIBAR.getCriteria(), null);
        }
    }


    // </script>