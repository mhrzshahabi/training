<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@include file="../messenger/MLanding.jsp" %>
// <script>
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
                {name: "id"},
                {name: "termId"},
                {name: "instituteId"},
                {name: "teacherId"},
                {name: "tclassStudentsCount"},
                {name: "tclassCode"},
                {name: "tclassStartDate"},
                {name: "tclassEndDate"},
                {name: "tclassYear"},
                {name: "courseCode"},
                {name: "courseCategory"},
                {name: "courseSubCategory"},
                {name: "courseTitleFa"},
                {name: "courseEvaluationType"},
                {name: "tclassDuration"},
                {name: "tclassOrganizerId"},
                {name: "tclassStatus"},
                {name: "tclassEndingStatus"},
                {name: "tclassPlanner"},
                {name: "termTitleFa"},
                {name: "instituteTitleFa"},
                {name: "classScoringMethod"},
                {name: "classPreCourseTest"},
                {name: "courseId"},
                {name: "teacherEvalStatus"},
                {name: "trainingEvalStatus"},
                {name: "tclassSupervisor"}
            ],
            fetchDataURL: viewClassDetailUrl + "/iscList"
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
                                    {fieldName:"tclassEndDate", operator:"equals", value: todayDate},
                                    {fieldName:"courseEvaluationType", operator:"equals", value: "1"}
                                ]
                            };
                            RestDataSource_class_Evaluation.fetchDataURL = viewClassDetailUrl + "/iscList";
                            ListGrid_class_Evaluation.invalidateCache();
                            ListGrid_class_Evaluation.fetchData(criteria);
                        }
                        if(value == "2"){
                            let criteria = {
                                _constructor:"AdvancedCriteria",
                                operator:"and",
                                criteria:[
                                    {fieldName:"tclassStartDate", operator:"equals", value: todayDate},
                                    {fieldName:"courseEvaluationType", operator:"equals", value: "2"}
                                ]
                            };
                            RestDataSource_class_Evaluation.fetchDataURL = viewClassDetailUrl + "/iscList";
                            ListGrid_class_Evaluation.invalidateCache();
                            ListGrid_class_Evaluation.fetchData(criteria);
                        }
                        if(value == "3"){
                            RestDataSource_class_Evaluation.fetchDataURL = viewClassDetailUrl + "/iscList";
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
            dataSource: RestDataSource_class_Evaluation,
            canAddFormulaFields: false,
            autoFetchData: true,
            showFilterEditor: true,
            allowAdvancedCriteria: true,
            allowFilterExpressions: true,
            filterOnKeypress: false,
            initialSort: [
                {property: "tclassStartDate", direction: "descending", primarySort: true}
            ],
            fields: [
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
                    autoFithWidth: true
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
                    name: "instituteTitleFa",
                    title: "<spring:message code='presenter'/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true,
                    hidden: true
                },
                {
                    name: "courseEvaluationType",
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
                    name: "tclassStatus", title: "<spring:message code='class.status'/>", align: "center",
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
                {
                    name: "tclassEndingStatus",
                    title: "<spring:message code="ending.class.status"/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFithWidth: true
                },
                {name: "classScoringMethod", hidden: true},
                {name: "classPreCourseTest", hidden: true},
                {name: "courseId", hidden: true},
                {name: "teacherId", hidden: true},
                {name: "teacherEvalStatus", hidden: true},
                {name: "trainingEvalStatus", hidden: true},
                {name: "tclassSupervisor", hidden: true}
            ],
            selectionUpdated: function () {
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
                    id: "TabPane_Learning_PreTest",
                    title: "یادگیری",
                    pane: isc.ViewLoader.create({autoDraw: true, viewURL: "pre-test/show-form"})
                },
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
                        RestDataSource_student_RE.implicitCriteria=null;
                        RestDataSource_student_RE.fetchDataURL = tclassStudentUrl + "/students-iscList/" + classRecord.id;
                        ListGrid_student_RE.invalidateCache();
                        ListGrid_student_RE.fetchData();
                        DynamicForm_ReturnDate_RE.clearValues();
                        classRecord_RE = classRecord;
                        if (classRecord.trainingEvalStatus == 0 ||
                                classRecord.trainingEvalStatus == undefined ||
                                    classRecord.trainingEvalStatus == null) {
                            ToolStrip_SendForms_RE.getField("sendButtonTraining").disableIcon("ok");
                            ToolStrip_SendForms_RE.getField("registerButtonTraining").disableIcon("ok");
                        }
                        else if(classRecord.trainingEvalStatus == 1){
                            ToolStrip_SendForms_RE.getField("sendButtonTraining").enableIcon("ok");
                            ToolStrip_SendForms_RE.getField("registerButtonTraining").disableIcon("ok");
                        }
                        else{
                            ToolStrip_SendForms_RE.getField("sendButtonTraining").enableIcon("ok");
                            ToolStrip_SendForms_RE.getField("registerButtonTraining").enableIcon("ok");
                        }

                        if (classRecord.teacherEvalStatus == 0 ||
                            classRecord.teacherEvalStatus == undefined ||
                            classRecord.teacherEvalStatus == null) {
                            ToolStrip_SendForms_RE.getField("sendButtonTeacher").disableIcon("ok");
                            ToolStrip_SendForms_RE.getField("registerButtonTeacher").disableIcon("ok");
                        }
                        else if(classRecord.teacherEvalStatus == 1){
                            ToolStrip_SendForms_RE.getField("sendButtonTeacher").enableIcon("ok");
                            ToolStrip_SendForms_RE.getField("registerButtonTeacher").disableIcon("ok");
                        }
                        else{
                            ToolStrip_SendForms_RE.getField("sendButtonTeacher").enableIcon("ok");
                            ToolStrip_SendForms_RE.getField("registerButtonTeacher").enableIcon("ok");
                        }
                        ToolStrip_SendForms_RE.redraw();

                        break;
                    }
                    case "TabPane_Learning": {
                        RestDataSource_ClassStudent_registerScorePreTest.fetchDataURL = tclassStudentUrl + "/pre-test-score-iscList/" + classRecord.id;
                        ListGrid_Class_Student_RegisterScorePreTest.invalidateCache();
                        ListGrid_Class_Student_RegisterScorePreTest.fetchData();
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
            let evaluationType = classRecord.courseEvaluationType;

            if (evaluationType === "1") {
                Detail_Tab_Evaluation.enableTab(0);
                Detail_Tab_Evaluation.disableTab(1);
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

            Detail_Tab_Evaluation.disableTab(2);
            Detail_Tab_Evaluation.disableTab(4);
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
                    operator:"and",
                    criteria:[
                        { fieldName:"termId", operator:"inSet", value: value},
                        { fieldName:"tclassStatus", operator:"notEqual", value: "3"}
                    ]
                };
                RestDataSource_class_Evaluation.fetchDataURL = viewClassDetailUrl + "/iscList";
                ListGrid_class_Evaluation.implicitCriteria = criteria;
                ListGrid_class_Evaluation.invalidateCache();
                ListGrid_class_Evaluation.fetchData();
            }
            else
            {
                createDialog("info", "<spring:message code="msg.select.term.ask"/>", "<spring:message code="message"/>")
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


