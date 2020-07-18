<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page import="com.nicico.copper.core.SecurityUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
// <script>
    //----------------------------------------- Variables --------------------------------------------------------------
    //----------------------------------------- DataSources ------------------------------------------------------------
        var RestDataSource_Year_Filter_Evaluation = isc.TrDS.create({
            fields: [
                {name: "year"}
            ],
            fetchDataURL: termUrl + "years",
            autoFetchData: true
        });
        var RestDataSource_Term_Filter_Evaluation = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true},
                {name: "code"},
                {name: "startDate"},
                {name: "endDate"}
            ]
        });
        var RestDataSource_class_Evaluation = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true},
                {name: "titleClass"},
                {name: "startDate"},
                {name: "endDate"},
                {name: "code"},
                {name: "term.titleFa"},
                {name: "course.titleFa"},
                {name: "course.id"},
                {name: "course.code"},
                {name: "course.evaluation"},
                {name: "institute.titleFa"},
                {name: "studentCount",canFilter:false,canSort:false},
                {name: "numberOfStudentEvaluation"},
                {name: "classStatus"},
                {name: "trainingPlaceIds"},
                {name: "instituteId"},
                {name: "workflowEndingStatusCode"},
                {name: "workflowEndingStatus"},
                {name: "scoringMethod"},
                {name: "preCourseTest"}
            ],
            fetchDataURL: evaluationUrl + "/class-spec-list"
        });
    //----------------------------------------- DynamicForms -----------------------------------------------------------
        var DynamicForm_Term_Filter_Evaluation = isc.DynamicForm.create({
            width: "85%",
            height: "100%",
            numCols: 6,
            colWidths: ["1%", "6%", "1%", "20%", "0%", "60%"],
            fields: [
                {
                    name: "yearFilter",
                    title: "<spring:message code='year'/>",
                    width: "100%",
                    textAlign: "center",
                    editorType: "ComboBoxItem",
                    displayField: "year",
                    valueField: "year",
                    optionDataSource: RestDataSource_Year_Filter_Evaluation,
                    filterFields: ["year"],
                    sortField: ["year"],
                    sortDirection: "descending",
                    defaultToFirstOption: true,
                    useClientFiltering: true,
                    filterEditorProperties: {
                        keyPressFilter: "[0-9]"
                    },
                    pickListFields: [
                        {
                            name: "year",
                            title: "<spring:message code='year'/>",
                            filterOperator: "iContains",
                            filterEditorProperties: {
                                keyPressFilter: "[0-9]"
                            }
                        }
                    ],
                    changed: function (form, item, value) {
                        load_term_by_year(value);
                    },
                    dataArrived:function (startRow, endRow, data) {
                        if(data.allRows[0].year !== undefined)
                        {
                            load_term_by_year(data.allRows[0].year);
                        }
                    }
                },
                {
                    name: "termFilter",
                    title: "<spring:message code='term'/>",
                    width: "100%",
                    textAlign: "center",
                    type: "SelectItem",
                    multiple: true,
                    filterLocally: true,
                    displayField: "code",
                    valueField: "id",
                    optionDataSource: RestDataSource_Term_Filter_Evaluation,
                    filterFields: ["code"],
                    sortField: ["code"],
                    sortDirection: "descending",
                    defaultToFirstOption: true,
                    useClientFiltering: true,
                    filterEditorProperties: {
                        keyPressFilter: "[0-9]"
                    },
                    pickListFields: [
                        {
                            name: "code",
                            title: "<spring:message code='term.code'/>",
                            filterOperator: "iContains",
                            filterEditorProperties: {
                                keyPressFilter: "[0-9]"
                            }
                        },
                        {
                            name: "startDate",
                            title: "<spring:message code='start.date'/>",
                            filterOperator: "iContains",
                            filterEditorProperties: {
                                keyPressFilter: "[0-9/]"
                            }
                        },
                        {
                            name: "endDate",
                            title: "<spring:message code='end.date'/>",
                            filterOperator: "iContains",
                            filterEditorProperties: {
                                keyPressFilter: "[0-9/]"
                            }
                        }
                    ],
                    pickListProperties: {
                        gridComponents: [
                            isc.ToolStrip.create({
                                autoDraw: false,
                                height: 30,
                                width: "100%",
                                members: [
                                    isc.ToolStripButton.create({
                                        width: "50%",
                                        icon: "[SKIN]/actions/approve.png",
                                        title: "انتخاب همه",
                                        click: function () {
                                            var item = DynamicForm_Term_Filter_Evaluation.getField("termFilter"),
                                                fullData = item.pickList.data,
                                                cache = fullData.localData,
                                                values = [];

                                            for (var i = 0; i < cache.length; i++) {
                                                values[i] = cache[i].id;
                                            }
                                            item.setValue(values);
                                            item.pickList.hide();
                                            load_classes_by_term(values);
                                        }
                                    }),
                                    isc.ToolStripButton.create({
                                        width: "50%",
                                        icon: "[SKIN]/actions/close.png",
                                        title: "حذف همه",
                                        click: function () {
                                            var item = DynamicForm_Term_Filter_Evaluation.getField("termFilter");
                                            item.setValue([]);
                                            item.pickList.hide();
                                            load_classes_by_term([]);
                                        }
                                    })
                                ]
                            }),
                            "header", "body"
                        ]
                    },
                    changed: function (form, item, value) {
                        load_classes_by_term(value);
                    },
                    dataArrived:function (startRow, endRow, data) {
                        if(data.allRows[0].id !== undefined)
                        {
                            DynamicForm_Term_Filter_Evaluation.getItem("termFilter").clearValue();
                            DynamicForm_Term_Filter_Evaluation.getItem("termFilter").setValue(data.allRows[0].code);
                            load_classes_by_term(data.allRows[0].id);
                        }
                    }
                },
                {

                    name: "classAlarmSelect",
                    title: "",
                    type: "radioGroup",
                    defaultValue: "3",
                    valueMap: {
                        "1" : "لیست کلاسهایی که موعد ارزیابی واکنشی آنها امروز است",
                        "2" : "لیست کلاسهایی که موعد ارزیابی یادگیری آنها امروز است",
                        "3" : "لیست همه ی کلاسها"
                    },
                    vertical: false,
                    changed: function (form, item, value) {
                        if(value == "1"){
                            let criteria = {
                                _constructor:"AdvancedCriteria",
                                operator:"and",
                                criteria:[
                                    {fieldName:"endDate", operator:"equals", value: todayDate},
                                    {fieldName:"course.evaluation", operator:"equals", value: "1"}
                                ]
                            };
                            RestDataSource_class_Evaluation.fetchDataURL = evaluationUrl + "/class-spec-list";
                            ListGrid_class_Evaluation.invalidateCache();
                            ListGrid_class_Evaluation.fetchData(criteria);
                        }
                        if(value == "2"){
                            let criteria = {
                                _constructor:"AdvancedCriteria",
                                operator:"and",
                                criteria:[
                                    {fieldName:"startDate", operator:"equals", value: todayDate},
                                    {fieldName:"course.evaluation", operator:"equals", value: "2"}
                                ]
                            };
                            RestDataSource_class_Evaluation.fetchDataURL = evaluationUrl + "/class-spec-list";
                            ListGrid_class_Evaluation.invalidateCache();
                            ListGrid_class_Evaluation.fetchData(criteria);
                        }
                        if(value == "3"){
                            RestDataSource_class_Evaluation.fetchDataURL = evaluationUrl + "/class-spec-list";
                            ListGrid_class_Evaluation.invalidateCache();
                            ListGrid_class_Evaluation.fetchData();
                        }
                    },
                }
            ]
        });
    //----------------------------------------- ListGrids --------------------------------------------------------------
        var ListGrid_class_Evaluation = isc.TrLG.create({
            width: "100%",
            height: "100%",
            <sec:authorize access="hasAuthority('Evaluation_R')">
            dataSource: RestDataSource_class_Evaluation,
            </sec:authorize>
            canAddFormulaFields: false,
            autoFetchData: true,
            showFilterEditor: true,
            allowAdvancedCriteria: true,
            allowFilterExpressions: true,
            filterOnKeypress: false,
            initialSort: [
                {property: "startDate", direction: "descending", primarySort: true}
            ],
            fields: [
                {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
                {
                    name: "code",
                    title: "<spring:message code='class.code'/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "titleClass",
                    title: "titleClass",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true,
                    hidden: true
                },
                {
                    name: "course.code",
                    title: "<spring:message code='course.code'/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFithWidth: true
                },
                {
                    name: "course.titleFa",
                    title: "<spring:message code='course.title'/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true,
                    sortNormalizer: function (record) {
                        return record.course.titleFa;
                    }
                },
                {
                    name: "term.titleFa",
                    title: "term",
                    align: "center",
                    filterOperator: "iContains",
                    hidden: true
                },
                {
                    name: "startDate",
                    title: "<spring:message code='start.date'/>",
                    align: "center",
                    filterOperator: "iContains",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9/]"
                    },
                    autoFithWidth: true
                },
                {
                    name: "endDate",
                    title: "<spring:message code='end.date'/>",
                    align: "center",
                    filterOperator: "iContains",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9/]"
                    },
                    autoFithWidth: true
                },
                {
                    name: "studentCount",
                    title: "<spring:message code='student.count'/>",
                    filterOperator: "iContains",
                    autoFitWidth: true,
                    filterEditorProperties: {
                        keyPressFilter: "[0-9]"
                    }
                },
                {
                    name: "numberOfStudentEvaluation",
                    title: "<spring:message code='evaluated'/>",
                    filterOperator: "iContains",
                    autoFitWidth: true,
                    canFilter: false,
                    canSort: false
                },
                {
                    name: "institute.titleFa",
                    title: "<spring:message code='presenter'/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true,
                    hidden: true
                },
                {
                    name: "course.evaluation",
                    title: "<spring:message code='evaluation.type'/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true,
                    filterEditorProperties:{
                        pickListProperties: {
                            showFilterEditor: false
                        },
                        click:function () {
                            setTimeout(()=> {
                                $('.comboBoxItemPickerrtl').eq(4).remove();
                            $('.comboBoxItemPickerrtl').eq(5).remove();
                        },0);
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
                    name: "classStatus", title: "<spring:message code='class.status'/>", align: "center",
                    autoFithWidth: true,
                    filterEditorProperties:{
                        pickListProperties: {
                            showFilterEditor: false
                        },
                        click:function () {
                            setTimeout(()=> {
                                $('.comboBoxItemPickerrtl').eq(5).remove();
                            $('.comboBoxItemPickerrtl').eq(4).remove();
                        },0);
                        }
                    },
                    valueMap: {
                        "1": "برنامه ریزی",
                        "2": "در حال اجرا",
                        "3": "پایان یافته"
                    }
                },
                {name: "createdBy", hidden: true},
                {name: "createdDate", hidden: true},
                {
                    name: "workflowEndingStatusCode",
                    title: "workflowCode",
                    align: "center",
                    filterOperator: "iContains",
                    hidden: true
                },
                {
                    name: "workflowEndingStatus",
                    title: "<spring:message code="ending.class.status"/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFithWidth: true
                },
                {name: "scoringMethod", hidden: true},
                {name: "preCourseTest", hidden: true}
            ],
            selectionUpdated: function () {
                let classRecord = ListGrid_class_Evaluation.getSelectedRecord();
                loadSelectedTab_data(Detail_Tab_Evaluation.getSelectedTab());
                set_Evaluation_Tabset_status();
            }
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
                DynamicForm_Term_Filter_Evaluation,
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
                    id: "TabPane_Learning",
                    title: "یادگیری-ثبت نمرات پیش آزمون",
                    pane: isc.ViewLoader.create({autoDraw: true, viewURL: "registerScorePreTest/show-form"})
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
                }
                </sec:authorize>
            ],
            tabSelected: function (tabNum, tabPane, ID, tab, name) {
                if (isc.Page.isLoaded())
                    loadSelectedTab_data(tab);
            }

        });
        var HLayout_Actions_Evaluation = isc.HLayout.create({
            width: "100%",
            height: "1%",
            members: [ToolStrip_Evaluation]
        });
        var Hlayout_Grid_Evaluation = isc.HLayout.create({
            width: "100%",
            height: "50%",
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
        var VLayout_Body_Evaluation = isc.VLayout.create({
            width: "100%",
            height: "100%",
            members: [HLayout_Actions_Evaluation, Hlayout_Grid_Evaluation, Hlayout_Tab_Evaluation]
        });
    //----------------------------------------- Functions --------------------------------------------------------------
        function loadSelectedTab_data(tab) {
            let classRecord = ListGrid_class_Evaluation.getSelectedRecord();

            if (!(classRecord === undefined || classRecord === null)) {

                Detail_Tab_Evaluation.enable();

                switch (tab.id) {
                    case "TabPane_Reaction": {
                        RestDataSource_evaluation_student.fetchDataURL = tclassStudentUrl + "/students-iscList/" + classRecord.id;
                        ListGrid_evaluation_student.invalidateCache();
                        ListGrid_evaluation_student.fetchData();
                        DynamicForm_ReturnDate.clearValues();
                        ToolStripButton_FormIssuanceForAll.setTitle("<spring:message code="students.form.issuance.Reaction"/>");
                        classRecord_Revaluation = classRecord;
                        break;
                    }
                    case "TabPane_Learning": {
                        RestDataSource_ClassStudent_registerScorePreTest.fetchDataURL = tclassStudentUrl + "/pre-test-score-iscList/" + classRecord.id;
                        ListGrid_Class_Student_RegisterScorePreTest.invalidateCache();
                        ListGrid_Class_Student_RegisterScorePreTest.fetchData();
                        break;
                    }
                    case "TabPane_Behavior": {
                        ListGrid_evaluation_student.hideField("evaluationStatusReaction");
                        ListGrid_evaluation_student.hideField("evaluationStatusLearning");
                        ListGrid_evaluation_student.hideField("evaluationStatusResults");
                        ListGrid_evaluation_student.showField("evaluationStatusBehavior");

                        RestDataSource_evaluation_student.fetchDataURL = tclassStudentUrl + "/students-iscList/" + classRecord.id;
                        ListGrid_evaluation_student.invalidateCache();
                        ListGrid_evaluation_student.fetchData();

                        ToolStripButton_FormIssuanceForAll.setTitle("<spring:message code="students.form.issuance.Behavioral"/>");
                        break;
                    }
                    case "TabPane_Results": {
                        break;
                    }
                }

            } else {
                Detail_Tab_Evaluation.disable();
            }
        }
        function set_Evaluation_Tabset_status() {

            let classRecord = ListGrid_class_Evaluation.getSelectedRecord();
            let evaluationType = classRecord.course.evaluation;

            if (evaluationType === "1") {
                Detail_Tab_Evaluation.enableTab(0);
                Detail_Tab_Evaluation.disableTab(1);
                Detail_Tab_Evaluation.disableTab(2);
                Detail_Tab_Evaluation.disableTab(3);
            } else if (evaluationType === "2") {
                Detail_Tab_Evaluation.enableTab(0);
                Detail_Tab_Evaluation.enableTab(1);
                Detail_Tab_Evaluation.disableTab(2);
                Detail_Tab_Evaluation.disableTab(3);
            } else if (evaluationType === "3") {
                Detail_Tab_Evaluation.enableTab(0);
                Detail_Tab_Evaluation.enableTab(1);
                Detail_Tab_Evaluation.enableTab(2);
                Detail_Tab_Evaluation.disableTab(3);
            } else if (evaluationType === "4") {
                Detail_Tab_Evaluation.enableTab(0);
                Detail_Tab_Evaluation.enableTab(1);
                Detail_Tab_Evaluation.enableTab(2);
                Detail_Tab_Evaluation.enableTab(3);
            }

        }
        function load_term_by_year(value) {
            let criteria= '{"fieldName":"startDate","operator":"iStartsWith","value":"' + value + '"}';
            RestDataSource_Term_Filter_Evaluation.fetchDataURL = termUrl + "spec-list?operator=or&_constructor=AdvancedCriteria&criteria=" + criteria;
            DynamicForm_Term_Filter_Evaluation.getItem("termFilter").fetchData();
        }
        function load_classes_by_term(value) {
            if(value !== undefined) {
                let criteria = {
                    _constructor:"AdvancedCriteria",
                    operator:"or",
                    criteria:[
                        { fieldName:"term.id", operator:"inSet", value: value},
                        { fieldName:"classStatus", operator:"notEqual", value: "3"}
                    ]
                };
                RestDataSource_class_Evaluation.fetchDataURL = evaluationUrl + "/class-spec-list";
                ListGrid_class_Evaluation.implicitCriteria = criteria;
                ListGrid_class_Evaluation.invalidateCache();
                ListGrid_class_Evaluation.fetchData();
            }
            else
            {
                createDialog("info", "<spring:message code="msg.select.term.ask"/>", "<spring:message code="message"/>")
            }
        }

