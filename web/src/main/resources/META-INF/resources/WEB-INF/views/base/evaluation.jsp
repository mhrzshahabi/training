<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page import="com.nicico.copper.core.SecurityUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
// <script>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>
    var evalWait;
    var localQuestions;
    {
        var evaluation_method = "POST";
    }
    // <<-------------------------------------- Create - Window ------------------------------------
    {
        var RestDataSource_Year_Filter = isc.TrDS.create({
            fields: [
                {name: "year"}
            ],
            fetchDataURL: termUrl + "years",
            autoFetchData: true
        });

        var RestDataSource_Term_Filter = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true},
                {name: "code"},
                {name: "startDate"},
                {name: "endDate"}
            ]
        });

        var AudienceTypeDS = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true, hidden: true},
                {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
                {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
            ],
            cacheAllData: true,
            fetchDataURL: parameterUrl + "/iscList/EvaluatorType"
        });
        var EvaluationDS_PersonList = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true, hidden: true},
                {
                    name: "firstName",
                    title: "<spring:message code="firstName"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "lastName",
                    title: "<spring:message code="lastName"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "nationalCode",
                    title: "<spring:message code="national.code"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "companyName",
                    title: "<spring:message code="company.name"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "personnelNo",
                    title: "<spring:message code="personnel.no"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "personnelNo2",
                    title: "<spring:message code="personnel.no.6.digits"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "postTitle",
                    title: "<spring:message code="post"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "ccpArea",
                    title: "<spring:message code="reward.cost.center.area"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "ccpAssistant",
                    title: "<spring:message code="reward.cost.center.assistant"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "ccpAffairs",
                    title: "<spring:message code="reward.cost.center.affairs"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "ccpSection",
                    title: "<spring:message code="reward.cost.center.section"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "ccpUnit",
                    title: "<spring:message code="reward.cost.center.unit"/>",
                    filterOperator: "iContains"
                }
            ],
            fetchDataURL: personnelUrl + "/iscList"
        });

        var evaluation_Audience = null;
        var ealuation_numberOfStudents = null;
        var evaluation_Audience_Type = isc.DynamicForm.create({
            fields:[
                {
                    name: "audiencePost",
                    type: "SelectItem",
                    optionDataSource: AudienceTypeDS,
                    title: "نوع مخاطب : ",
                    pickListProperties: {
                        showFilterEditor: false
                    },
                    pickListFields: [
                        {name: "title"}
                    ],
                    valueField: "id",
                    displayField: "title"
                }
            ]
        });
        evaluation_Audience_Type.setValues(null);
        var EvaluationListGrid_PeronalLIst = isc.TrLG.create({
            dataSource: EvaluationDS_PersonList,
            selectionType: "single",
            fields: [
                {name: "id", hidden: true},
                {name: "firstName"},
                {name: "lastName"},
                {name: "nationalCode"},
                {name: "companyName"},
                {name: "personnelNo"},
                {name: "personnelNo2"},
                {name: "postTitle"},
                {name: "ccpArea"},
                {name: "ccpAssistant"},
                {name: "ccpAffairs"},
                {name: "ccpSection"},
                {name: "ccpUnit"}
            ],
            selectionAppearance: "checkbox"
        });
    }
    // ---------------------------------------- Create - Window ---------------------------------->>
    // <<-------------------------------------- Create - contextMenu ------------------------------------------
    var DynamicForm_Evalution_Term_Filter = isc.DynamicForm.create({
        width: "85%",
        height: "100%",
        numCols: 6,
        colWidths: ["1%", "6%", "1%", "20%","0%","60%"],
        fields: [
            {
                name: "yearFilter",
                title: "<spring:message code='year'/>",
                width: "100%",
                textAlign: "center",
                editorType: "ComboBoxItem",
                displayField: "year",
                valueField: "year",
                optionDataSource: RestDataSource_Year_Filter,
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
                optionDataSource: RestDataSource_Term_Filter,
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
                                        var item = DynamicForm_Evalution_Term_Filter.getField("termFilter"),
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
                                        var item = DynamicForm_Evalution_Term_Filter.getField("termFilter");
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
                        DynamicForm_Evalution_Term_Filter.getItem("termFilter").clearValue();
                        DynamicForm_Evalution_Term_Filter.getItem("termFilter").setValue(data.allRows[0].code);
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
                        RestDataSource_evaluation_class.fetchDataURL = evaluationUrl + "/class-spec-list";
                        ListGrid_evaluation_class.invalidateCache();
                        ListGrid_evaluation_class.fetchData(criteria);
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
                        RestDataSource_evaluation_class.fetchDataURL = evaluationUrl + "/class-spec-list";
                        ListGrid_evaluation_class.invalidateCache();
                        ListGrid_evaluation_class.fetchData(criteria);
                    }
                    if(value == "3"){
                        RestDataSource_evaluation_class.fetchDataURL = evaluationUrl + "/class-spec-list";
                        ListGrid_evaluation_class.invalidateCache();
                        ListGrid_evaluation_class.fetchData();
                    }
                },
            }
        ]
    });
    // ---------------------------------------- Create - contextMenu ---------------------------------------->>
    // <<-------------------------------------- Create - RestDataSource & ListGrid ----------------------------
    {

        var RestDataSource_evaluation_class = isc.TrDS.create({
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

        ListGrid_evaluation_class = isc.TrLG.create({
            width: "100%",
            height: "100%",
            <sec:authorize access="hasAuthority('Evaluation_R')">
            dataSource: RestDataSource_evaluation_class,
            </sec:authorize>
            // contextMenu: Menu_ListGrid_evaluation_class,
            canAddFormulaFields: false,
            autoFetchData: true,
            showFilterEditor: true,
            allowAdvancedCriteria: true,
            allowFilterExpressions: true,
            filterOnKeypress: true,
            // showRecordComponents: true,
            // showRecordComponentsByCell: true,
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
                // {name: "hasWarning", title: " ", type: "image", imageURLPrefix: "", imageURLSuffix: ".gif"},
                {name: "scoringMethod", hidden: true},
                // {name: "saveResults", title: " ", align: "center", canSort: false, canFilter: false,autoFithWidth: true},
                {name: "preCourseTest", hidden: true}
            ],

            // createRecordComponent: function (record, colNum) {
            //     var fieldName = this.getFieldName(colNum);
            //     if (fieldName == "saveResults") {
            //         var button = isc.IButton.create({
            //             layoutAlign: "center",
            //             title: "ثبت نتایج ارزیابی",
            //             width: "100%",
            //             click: function () {
            //                 register_evaluation_result(record);
            //             }
            //         });
            //         return button;
            //     } else {
            //         return null;
            //     }
            // },
            selectionUpdated: function () {
                let classRecord = ListGrid_evaluation_class.getSelectedRecord();
                loadSelectedTab_data(Detail_Tab_Evaluation.getSelectedTab());
                set_Evaluation_Tabset_status();
                RestDataSource_ClassStudent_registerScorePreTest.fetchDataURL = tclassStudentUrl + "/pre-test-score-iscList/" + classRecord.id;
                ListGrid_Class_Student_RegisterScorePreTest.invalidateCache();
                ListGrid_Class_Student_RegisterScorePreTest.fetchData();

            }
        });


        var RestDataSource_evaluation_student = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true, hidden: true},
                {name: "student.id", hidden: true},
                {
                    name: "student.firstName",
                    title: "<spring:message code="firstName"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "student.lastName",
                    title: "<spring:message code="lastName"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "student.nationalCode",
                    title: "<spring:message code="national.code"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true,
                },
                {
                    name: "applicantCompanyName",
                    title: "<spring:message code="company.applicant"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "presenceTypeId",
                    title: "<spring:message code="class.presence.type"/>",
                    filterOperator: "equals",
                    autoFitWidth: true
                },
                {
                    name: "student.companyName",
                    title: "<spring:message code="company.name"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "student.personnelNo",
                    title: "<spring:message code="personnel.no"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true,
                },
                {
                    name: "student.personnelNo2",
                    title: "<spring:message code="personnel.no.6.digits"/>",
                    filterOperator: "iContains",
                },
                {
                    name: "student.postTitle",
                    title: "<spring:message code="post"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "student.ccpArea",
                    title: "<spring:message code="reward.cost.center.area"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "evaluationStatusReaction",
                    title: "<spring:message code="evaluation.reaction.status"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "evaluationStatusLearning",
                    title: "<spring:message code="evaluation.learning.status"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "evaluationStatusBehavior",
                    title: "<spring:message code="evaluation.behavioral.status"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "evaluationStatusResults",
                    title: "<spring:message code="evaluation.results.status"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "evaluationAudienceTypeId",
                    title: "<spring:message code="evaluation.audience.type"/>",
                    type: "SelectItem",
                    optionDataSource: AudienceTypeDS,
                    pickListProperties: {
                        showFilterEditor: false
                    },
                    pickListFields: [
                        {name: "title"}
                    ],
                    filterOnKeypress: true,
                    filterFields: ["title"],
                    valueField: "id",
                    displayField: "title",
                    filterOperator: "iContains"
                }
            ],
        });


        var ListGrid_evaluation_student = isc.TrLG.create({
            width: "100%",
            height: "100%",
            dataSource: RestDataSource_evaluation_student,
            selectionType: "single",
            showRecordComponents: true,
            showRecordComponentsByCell: true,
            sortField: 5,
            sortDirection: "descending",
            fields: [
                {name: "student.firstName"},
                {name: "student.lastName"},
                {name: "student.nationalCode",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9]"
                    }
                },
                {name: "student.personnelNo",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9]"
                    }
                },
                {name: "student.personnelNo2",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9]"
                    }
                },
                {
                    name: "evaluationStatusReaction",
                    valueMap: {
                        "0": "صادر نشده",
                        "1": "صادر شده",
                        "2": "تکمیل شده و کامل",
                        "3": "تکمیل شده و ناقص"
                    },
                    filterEditorProperties:{
                        pickListProperties: {
                            showFilterEditor: false
                        }
                    },
                    filterOnKeypress:true
                },
                {
                    name: "evaluationStatusLearning",
                    valueMap: {
                        "0": "صادر نشده",
                        "1": "صادر شده",
                        "2": "تکمیل شده و کامل",
                        "3": "تکمیل شده و ناقص"
                    },
                    hidden: true,
                    filterEditorProperties:{
                        pickListProperties: {
                            showFilterEditor: false
                        }
                    },
                    filterOnKeypress:true
                },
                {
                    name: "evaluationStatusBehavior",
                    valueMap: {
                        "0": "صادر نشده",
                        "1": "صادر شده",
                        "2": "تکمیل شده و کامل",
                        "3": "تکمیل شده و ناقص"
                    },
                    hidden: true,
                    filterEditorProperties:{
                        pickListProperties: {
                            showFilterEditor: false
                        }
                    },
                    filterOnKeypress:true
                },
                {
                    name: "evaluationStatusResults",
                    valueMap: {
                        "0": "صادر نشده",
                        "1": "صادر شده",
                        "2": "تکمیل شده و کامل",
                        "3": "تکمیل شده و ناقص"
                    },
                    hidden: true,
                    filterEditorProperties:{
                        pickListProperties: {
                            showFilterEditor: false
                        }
                    },
                    filterOnKeypress:true
                },
                {name: "evaluationAudienceTypeId",title: "<spring:message code="evaluation.audience.type"/>",
                    hidden: true
                },
                {name: "sendForm", title: " ", align: "center", canSort: false, canFilter: false, autoFithWidth: true},
                {
                    name: "saveResults",
                    title: " ",
                    align: "center",
                    canSort: false,
                    canFilter: false,
                    autoFithWidth: true
                }
            ],
            getCellCSSText: function (record, rowNum, colNum) {
                if ((!ListGrid_evaluation_student.getFieldByName("evaluationStatusReaction").hidden && record.evaluationStatusReaction === 1)
                    || (!ListGrid_evaluation_student.getFieldByName("evaluationStatusLearning").hidden && record.evaluationStatusLearning === 1)
                    || (!ListGrid_evaluation_student.getFieldByName("evaluationStatusBehavior").hidden && record.evaluationStatusBehavior === 1)
                    || (!ListGrid_evaluation_student.getFieldByName("evaluationStatusResults").hidden && record.evaluationStatusResults === 1))
                    return "background-color : #d8e4bc";

                if ((!ListGrid_evaluation_student.getFieldByName("evaluationStatusReaction").hidden && (record.evaluationStatusReaction === 3 || record.evaluationStatusReaction === 2))
                    || (!ListGrid_evaluation_student.getFieldByName("evaluationStatusLearning").hidden && (record.evaluationStatusLearning === 3 || record.evaluationStatusLearning === 2))
                    || (!ListGrid_evaluation_student.getFieldByName("evaluationStatusBehavior").hidden && (record.evaluationStatusBehavior === 3 || record.evaluationStatusBehavior === 2))
                    || (!ListGrid_evaluation_student.getFieldByName("evaluationStatusResults").hidden && (record.evaluationStatusResults === 3 || record.evaluationStatusResults === 2)))
                    return "background-color : #b7dee8";
            },
            createRecordComponent: function (record, colNum) {
                var fieldName = this.getFieldName(colNum);
                if (fieldName == "saveResults") {
                    var button = isc.IButton.create({
                        layoutAlign: "center",
                        title: "ثبت نتیجه ارزیابی",
                        width: "120",
                        baseStyle: "registerFile",
                        click: function () {
                            if (Detail_Tab_Evaluation.getSelectedTab().id == "TabPane_Reaction") {
                                if (record.evaluationStatusReaction == "0")
                                    createDialog("info", "فرمی صادر نشده است");
                                else
                                    register_evaluation_result_reaction_student(record);
                            } else if (Detail_Tab_Evaluation.getSelectedTab().id == "TabPane_Behavior") {
                                register_evaluation_result_behavioral_student(record);
                            }
                        }
                    });
                    return button;
                } else if (fieldName == "sendForm") {
                    var button = isc.IButton.create({
                        layoutAlign: "center",
                        baseStyle: "sendFile",
                        title: "صدور فرم",
                        width: "120",
                        click: function () {
                            set_print_Status("single", record);
                        }
                    });
                    return button;
                } else {
                    return null;
                }
            },
        });


    }
// ---------------------------------------- Create - RestDataSource & ListGrid -------------------------->>
// <<-------------------------------------- Create - ToolStripButton --------------------------------------
{
    //*****class toolStrip*****
    var ToolStripButton_Refresh = isc.ToolStripButtonRefresh.create({
        title: "<spring:message code="refresh"/>",
        click: function () {
            ListGrid_evaluation_class.invalidateCache();
        }
    });


    var ToolStrip_operational = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            <sec:authorize access="hasAuthority('Evaluation_R')">
                DynamicForm_Evalution_Term_Filter,
                isc.ToolStrip.create({
                    width: "5%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh
                    ]
                })
                </sec:authorize>
            ]
        });

        var ToolStripButton_FormIssuanceForAll = isc.ToolStripButton.create({
            title: "<spring:message code="students.form.issuance.Behavioral"/>",
            baseStyle: "sendFile",
            click: function () {
                set_print_Status("all");
            }
        });
        var ToolStripButton_FormIssuance_Teacher = isc.ToolStripButton.create({
            title: "صدور فرم ارزیابی مدرس از کلاس",
            baseStyle: "sendFile",
            click: function () {
                setReactionStatus(1,10);
                print_Teacher_FormIssuance();
            }
        });

        var ToolStripButton_FormIssuance_Training = isc.ToolStripButton.create({
            title: "صدور فرم ارزیابی مسئول آموزش از استاد",
            baseStyle: "sendFile",
            align: "center",
            click: function () {
                setReactionStatus(10,1);
                print_Training_FormIssuance();
            }
        });

        var ToolStripButton_RefreshIssuance = isc.ToolStripButtonRefresh.create({
            title: "<spring:message code="refresh"/>",
            click: function () {
                ListGrid_evaluation_student.invalidateCache();
            }
        });

        var ToolStripButton_RegisterForm_Teacher = isc.ToolStripButton.create({
            title: "ثبت نتایج ارزیابی مدرس از کلاس",
            baseStyle: "registerFile",
            click: function () {
                isc.RPCManager.sendRequest(TrDSRequest(classUrl + "getTeacherReactionStatus/" + ListGrid_evaluation_class.getSelectedRecord().id , "GET", null, function (resp) {
                    if(resp.httpResponseText == "1")
                        register_evaluation_result_reaction(0);
                    else
                        createDialog('info', "برای مدرس فرمی صادر نشده است.");
                }));
            }
        });
        var ToolStripButton_RegisterForm_Training = isc.ToolStripButton.create({
            title: "ثبت نتایج ارزیابی مسئول آموزش از استاد",
            baseStyle: "registerFile",
            align: "center",
            click: function () {
                isc.RPCManager.sendRequest(TrDSRequest(classUrl + "getTrainingReactionStatus/" + ListGrid_evaluation_class.getSelectedRecord().id , "GET", null, function (resp) {
                    if(resp.httpResponseText == "1")
                        register_evaluation_result_reaction(1);
                    else
                        createDialog('info', "برای مسئول آموزش فرمی صادر نشده است.");
                }));
            }
        });

        var ToolStrip_evaluation = isc.ToolStrip.create({
            width: "100%",
            membersMargin: 10,
            members: [
                <sec:authorize access="hasAuthority('Evaluation_PrintPreTest')">
                                isc.VLayout.create({
                                    membersMargin: 5,
                                    layoutAlign: "center",
                                    defaultLayoutAlign: "center",
                                    members: [
                                        ToolStripButton_FormIssuance_Teacher,
                                        ToolStripButton_RegisterForm_Teacher
                                    ]
                                }),
                                isc.VLayout.create({
                                    membersMargin: 5,
                                    layoutAlign: "center",
                                    defaultLayoutAlign: "center",
                                    members: [
                                        ToolStripButton_FormIssuance_Training,
                                        ToolStripButton_RegisterForm_Training
                                    ]
                                }),
                                isc.VLayout.create({
                                    members: [
                                        ToolStripButton_FormIssuanceForAll,
                                        isc.LayoutSpacer.create({height: "22"})
                                    ]
                                }),
                                isc.ToolStrip.create({
                                    width: "100%",
                                    align: "left",
                                    border: '0px',
                                    members: [
                                        ToolStripButton_RefreshIssuance
                                    ]
                                })
                </sec:authorize>

            ]
        });
    }
    // ---------------------------------------- Create - ToolStripButton ------------------------------------>>
    // <<-------------------------------------- Create - TabSet & Tab -----------------------------------------
    {
        //*****evaluation HLayout & VLayout*****
        var HLayout_Actions_evaluation = isc.HLayout.create({
            width: "100%",
            height: "1%",
            members: [ToolStrip_evaluation]
        });

        var DynamicForm_ReturnDate = isc.DynamicForm.create({
            width: "150px",
            height: "10px",
            padding: 0,
            fields: [
                <sec:authorize access="hasAuthority('Evaluation_PrintPreTest')">
                {
                    name: "evaluationReturnDate",
                    title: "<spring:message code='return.date'/>",
                    ID: "evaluation_ReturnDate",
                    width: "150px",
                    hint: "----/--/--",
                    keyPressFilter: "[0-9/]",
                    showHintInField: true,
                    icons: [{
                        src: "<spring:url value="calendar.png"/>",
                        click: function (form) {
                            closeCalendarWindow();
                            displayDatePicker('evaluation_ReturnDate', this, 'ymd', '/');
                        }
                    }],
                    textAlign: "center",
                    click: function (form) {

                    },
                    changed: function (form, item, value) {

                        evaluation_check_date();
                    }
                }
                </sec:authorize>
            ]
        });

        var Hlayout_Grid_evaluation = isc.HLayout.create({
            width: "100%",
            height: "100%",
            members: [ListGrid_evaluation_student]
        });
        var HLayout_returnData_evaluation = isc.HLayout.create({
            width: "100%",
            members: [
                DynamicForm_ReturnDate,
                isc.LayoutSpacer.create({width: "80%"}),
                isc.RibbonGroup.create({
                ID: "fileGroup",
                title: "راهنمای رنگ بندی لیست",
                numRows: 1,
                colWidths: [ 40, "*" ],
                height: "10px",
                titleAlign: "center",
                titleStyle : "gridHint",
                controls: [
                    isc.IconButton.create(isc.addProperties({
                        title: "صادر نشده",
                        baseStyle: "gridHint",
                        backgroundColor: '#fffff'
                    })),
                    isc.IconButton.create(isc.addProperties({
                        title: "صادر شده",
                        baseStyle: "gridHint",
                        backgroundColor: '#d8e4bc'
                    })),
                    isc.IconButton.create(isc.addProperties({
                        title: "تکمیل شده",
                        baseStyle: "gridHint",
                        backgroundColor: '#b7dee8'
                    }))
                ],
                autoDraw: false
            })]
        });


        var VLayout_Body_evaluation = isc.VLayout.create({
            width: "100%",
            height: "100%",
            members: [HLayout_returnData_evaluation, HLayout_Actions_evaluation, Hlayout_Grid_evaluation]
        });

        var Detail_Tab_Evaluation = isc.TabSet.create({
            ID: "tabSetEvaluation",
            tabBarPosition: "top",
            enabled: false,
            tabs: [
                <sec:authorize access="hasAuthority('Evaluation_Reaction')">
                {
                    id: "TabPane_Reaction",
                    title: "<spring:message code="evaluation.reaction"/>",
                    pane: VLayout_Body_evaluation
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
                    pane: VLayout_Body_evaluation
                },
                </sec:authorize>

                <sec:authorize access="hasAuthority('Evaluation_Results')">
                {
                    id: "TabPane_Results",
                    title: "<spring:message code="evaluation.results"/>",
                    pane: VLayout_Body_evaluation
                }
                </sec:authorize>
            ],
            tabSelected: function (tabNum, tabPane, ID, tab, name) {
                if (isc.Page.isLoaded())
                    loadSelectedTab_data(tab);
            }

        });
    }
    // ---------------------------------------- Create - TabSet & Tab --------------------------------------->>
    // <<-------------------------------------- Create - HLayout & VLayout ------------------------------------
    {
        //*****class HLayout & VLayout*****
        var HLayout_Actions_operational = isc.HLayout.create({
            width: "100%",
            height: "1%",
            members: [ToolStrip_operational]
        });

        var Hlayout_Grid_operational = isc.HLayout.create({
            width: "100%",
            height: "50%",
            showResizeBar: true,
            members: [ListGrid_evaluation_class]
        });

        var Hlayout_Tab_Evaluation = isc.HLayout.create({
            width: "100%",
            height: "45%",
            members: [
                Detail_Tab_Evaluation
            ]
        });

        var VLayout_Body_operational = isc.VLayout.create({
            width: "100%",
            height: "100%",
            members: [HLayout_Actions_operational, Hlayout_Grid_operational, Hlayout_Tab_Evaluation]
        });


    }
    // ---------------------------------------- Create - HLayout & VLayout ---------------------------------->>
    // <<----------------------------------------------- Functions --------------------------------------------
    {
        //*****check date is valid*****
        function evaluation_check_date() {

            DynamicForm_ReturnDate.clearFieldErrors("evaluationReturnDate", true);

            if (DynamicForm_ReturnDate.getValue("evaluationReturnDate") !== undefined && !checkDate(DynamicForm_ReturnDate.getValue("evaluationReturnDate"))) {
                DynamicForm_ReturnDate.addFieldErrors("evaluationReturnDate", "<spring:message code='msg.correct.date'/>", true);
            } else if (DynamicForm_ReturnDate.getValue("evaluationReturnDate") < ListGrid_evaluation_class.getSelectedRecord().startDate) {
                DynamicForm_ReturnDate.addFieldErrors("evaluationReturnDate", "<spring:message code='return.date.before.class.start.date'/>", true);
            } else {
                DynamicForm_ReturnDate.clearFieldErrors("evaluationReturnDate", true);
            }
        }

        //*****show action result function*****
        var MyOkDialog_Operational;

        //*****close dialog*****
        function close_MyOkDialog_Operational() {
            setTimeout(function () {
                MyOkDialog_Operational.close();
            }, 3000);
        }
        function print_Student_Behavioral_Form_Inssuance(record){
            var Buttons_List_HLayout = isc.HLayout.create({
                width: "100%",
                height: "30px",
                autoDraw: false,
                padding: "5px",
                align: "center",
                membersMargin: 5,
                members: [
                    isc.IButton.create({
                        title: "صدور و چاپ",
                        click: function () {
                            if (EvaluationListGrid_PeronalLIst.getSelectedRecord() !== null && (evaluation_Audience_Type.getValue("audiencePost") !== null && evaluation_Audience_Type.getValue("audiencePost") !== undefined)) {
                                evaluation_Audience = EvaluationListGrid_PeronalLIst.getSelectedRecord().firstName + " " + EvaluationListGrid_PeronalLIst.getSelectedRecord().lastName;
                                print_Student_FormIssuance("pdf", ealuation_numberOfStudents,record);
                                create_Student_BehavioralForm(ealuation_numberOfStudents,record,EvaluationListGrid_PeronalLIst.getSelectedRecord(),evaluation_Audience_Type.getValue("audiencePost"));
                                EvaluationWin_PersonList.close();
                            } else if(evaluation_Audience_Type.getValue("audiencePost") === null || evaluation_Audience_Type.getValue("audiencePost") === undefined){
                                createDialog('info', "<spring:message code="select.audience.post.ask"/>", "<spring:message code="global.message"/>");
                            } else {
                                isc.Dialog.create({
                                    message: "<spring:message code="select.audience.ask"/>",
                                    icon: "[SKIN]ask.png",
                                    title: "<spring:message code="global.message"/>",
                                    buttons: [isc.IButtonSave.create({title: "<spring:message code="ok"/>"})],
                                    buttonClick: function (button, index) {
                                        this.close();
                                    }
                                });
                            }
                        }
                    }),
                    isc.IButton.create({
                        title: "ارسال از طریق پیامک",
                        click: function () {
                        }
                    }),
                    isc.IButton.create({
                        title: "<spring:message code="logout"/>",
                        click: function () {
                            evaluation_Audience = null;
                            evaluation_Audience_Type.setValues(null);
                            EvaluationWin_PersonList.close();
                        }
                    })
                ]
            });

            var evaluation_personnel_List_VLayout = isc.VLayout.create({
                width: "100%",
                height: "100%",
                autoDraw: false,
                members: [
                    evaluation_Audience_Type,
                    EvaluationListGrid_PeronalLIst,
                    Buttons_List_HLayout
                ]
            });

            var EvaluationWin_PersonList = isc.Window.create({
                title: "<spring:message code="select.audience"/>",
                width: 600,
                height: 400,
                minWidth: 600,
                minHeight: 400,
                autoSize: false,
                visibility: "hidden",
                items: [
                    evaluation_personnel_List_VLayout
                ],
                close : function () {
                    evaluation_Audience_Type.setValues(null);
                    this.Super("close",arguments);
                }
            });
            EvaluationWin_PersonList.show();
            EvaluationListGrid_PeronalLIst.invalidateCache();
            EvaluationListGrid_PeronalLIst.fetchData();
        }

        function set_print_Status(numberOfStudents,record) {
            evaluation_check_date();

            if (DynamicForm_ReturnDate.hasErrors())
                return;

            if (Detail_Tab_Evaluation.getSelectedTab().id === "TabPane_Behavior") {
                ealuation_numberOfStudents = numberOfStudents;
                let selectedStudent = record;
                if (numberOfStudents === "all" || (numberOfStudents === "single" && selectedStudent !== null && selectedStudent !== undefined)) {
                    print_Student_Behavioral_Form_Inssuance(record);
                } else {
                    isc.Dialog.create({
                        message: "<spring:message code="msg.no.records.selected"/>",
                        icon: "[SKIN]ask.png",
                        title: "<spring:message code="global.message"/>",
                        buttons: [isc.IButtonSave.create({title: "<spring:message code="ok"/>"})],
                        buttonClick: function (button, index) {
                            this.close();
                        }
                    });
                }

            } else {
                print_Student_FormIssuance("pdf", numberOfStudents,record);
            }
        }

        function create_Student_BehavioralForm(numberOfStudents,record,evaluatorRecord,evaluatorType){
            if (ListGrid_evaluation_student.getTotalRows() > 0) {
                let selectedClass = ListGrid_evaluation_class.getSelectedRecord();
                let selectedStudent = record;
                let selectedTab = Detail_Tab_Evaluation.getSelectedTab();

                if (numberOfStudents === "single" && selectedStudent !== null && selectedStudent !== undefined) {

                    let studentId = selectedStudent.id;
                    let data = {};
                    data.questionnaireTypeId = 230;
                    data.evaluationLevelId = 156;
                    data.evaluatedId = studentId;
                    data.classId = selectedClass.id;
                    data.evaluatorId = evaluatorRecord.id;
                    data.evaluatorTypeId = evaluatorType;
                    data.evaluatedTypeId = null;
                    data.status = false;

                    isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl, "POST", JSON.stringify(data), function (resp) {
                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                            const msg = createDialog("info", "<spring:message code="global.form.request.successful"/>");
                            setTimeout(() => {
                                msg.close();
                        }, 3000);
                        }
                        else if(resp.httpResponseCode === 406){
                            createDialog("info", "فرم ارزیابی قبلا برای این فرد صادر شده است.");
                        }
                        else {
                            createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                        }
                    }));

                    evaluation_Audience = null;
                }
                else if (numberOfStudents === "all") {

                } else {
                    isc.Dialog.create({
                        message: "<spring:message code="msg.no.records.selected"/>",
                        icon: "[SKIN]ask.png",
                        title: "<spring:message code="global.message"/>",
                        buttons: [isc.IButtonSave.create({title: "<spring:message code="ok"/>"})],
                        buttonClick: function (button, index) {
                            this.close();
                        }
                    });
                }
            } else {
                isc.Dialog.create({
                    message: "<spring:message code="no.student.class"/>",
                    icon: "[SKIN]ask.png",
                    title: "<spring:message code="global.message"/>",
                    buttons: [isc.IButtonSave.create({title: "<spring:message code="ok"/>"})],
                    buttonClick: function (button, index) {
                        this.close();
                    }
                });
            }
        }
        //*****print student form issuance*****
        // roya
        function print_Student_FormIssuance(type, numberOfStudents,record, audienceName, audienceType) {
            if (ListGrid_evaluation_student.getTotalRows() > 0) {
                let selectedClass = ListGrid_evaluation_class.getSelectedRecord();
                let selectedStudent = record;
                let selectedTab = Detail_Tab_Evaluation.getSelectedTab();

                if (numberOfStudents === "all" || (numberOfStudents === "single" && selectedStudent !== null && selectedStudent !== undefined)) {

                    let studentId = (numberOfStudents === "single" ? selectedStudent.student.id : -1);
                    let returnDate = evaluation_ReturnDate._value !== undefined ? evaluation_ReturnDate._value.replaceAll("/", "-") : "noDate";
                    let evaluationType = (evaluation_Audience_Type.getValue("audiencePost") === null || evaluation_Audience_Type.getValue("audiencePost") === undefined ? "" : evaluation_Audience_Type.getField("audiencePost").getDisplayValue());
                    if(audienceType == null)
                        audienceType = evaluationType;
                    if(audienceName == null)
                        audienceName = evaluation_Audience;

                    var myObj = {
                        evaluationAudienceType: audienceType,
                        courseId: selectedClass.course.id,
                        studentId: studentId,
                        evaluationType: selectedTab.id,
                        evaluationReturnDate: returnDate,
                        evaluationAudience: audienceName
                    };

                    //*****print*****
                    var advancedCriteria_unit = ListGrid_evaluation_student.getCriteria();
                    var criteriaForm_operational = isc.DynamicForm.create({
                        method: "POST",
                        action: "<spring:url value="/evaluation/printWithCriteria/"/>" + type + "/" + selectedClass.id,
                        target: "_Blank",
                        canSubmit: true,
                        fields:
                            [
                                {name: "CriteriaStr", type: "hidden"},
                                {name: "myToken", type: "hidden"},
                                {name: "printData", type: "hidden"}
                            ],
                        show: function () {
                            this.Super("show", arguments);
                        }
                    });

                    criteriaForm_operational.setValue("CriteriaStr", JSON.stringify(advancedCriteria_unit));
                    criteriaForm_operational.setValue("myToken", "<%=accessToken%>");
                    criteriaForm_operational.setValue("printData", JSON.stringify(myObj));
                    criteriaForm_operational.show();
                    criteriaForm_operational.submit();
                    criteriaForm_operational.submit(set_evaluation_status(numberOfStudents,record));

                    evaluation_Audience = null;

                } else {
                    isc.Dialog.create({
                        message: "<spring:message code="msg.no.records.selected"/>",
                        icon: "[SKIN]ask.png",
                        title: "<spring:message code="global.message"/>",
                        buttons: [isc.IButtonSave.create({title: "<spring:message code="ok"/>"})],
                        buttonClick: function (button, index) {
                            this.close();
                        }
                    });
                }
            } else {
                isc.Dialog.create({
                    message: "<spring:message code="no.student.class"/>",
                    icon: "[SKIN]ask.png",
                    title: "<spring:message code="global.message"/>",
                    buttons: [isc.IButtonSave.create({title: "<spring:message code="ok"/>"})],
                    buttonClick: function (button, index) {
                        this.close();
                    }
                });
            }
        }

        //*****print student form issuance*****
        function print_Teacher_FormIssuance() {

            if (ListGrid_evaluation_student.getTotalRows() > 0) {
                let selectedClass = ListGrid_evaluation_class.getSelectedRecord();
                let selectedTab = Detail_Tab_Evaluation.getSelectedTab();
                let returnDate = evaluation_ReturnDate._value !== undefined ? evaluation_ReturnDate._value.replaceAll("/", "-") : "noDate";
                let evaluationType = (evaluation_Audience_Type.getValue("audiencePost") === null || evaluation_Audience_Type.getValue("audiencePost") === undefined ? "" : evaluation_Audience_Type.getField("audiencePost").getDisplayValue());

                    var myObj = {
                        classId: selectedClass.id,
                        evaluationType: selectedTab.id,
                        evaluationReturnDate: returnDate
                    };

                    var criteriaForm_operational = isc.DynamicForm.create({
                        method: "POST",
                        action: "<spring:url value="/evaluation/printTeacherReactionForm/"/>" + "pdf" + "/" + selectedClass.id,
                        target: "_Blank",
                        canSubmit: true,
                        fields:
                            [
                                {name: "CriteriaStr", type: "hidden"},
                                {name: "myToken", type: "hidden"},
                                {name: "printData", type: "hidden"}
                            ],
                        show: function () {
                            this.Super("show", arguments);
                        }
                    });

                    criteriaForm_operational.setValue("myToken", "<%=accessToken%>");
                    criteriaForm_operational.setValue("printData", JSON.stringify(myObj));
                    criteriaForm_operational.show();
                    criteriaForm_operational.submit();

            } else {
                isc.Dialog.create({
                    message: "<spring:message code="no.student.class"/>",
                    icon: "[SKIN]ask.png",
                    title: "<spring:message code="global.message"/>",
                    buttons: [isc.IButtonSave.create({title: "<spring:message code="ok"/>"})],
                    buttonClick: function (button, index) {
                        this.close();
                    }
                });
            }
        }

        function print_Training_FormIssuance() {

            if (ListGrid_evaluation_student.getTotalRows() > 0) {
                let selectedClass = ListGrid_evaluation_class.getSelectedRecord();
                let selectedTab = Detail_Tab_Evaluation.getSelectedTab();
                let returnDate = evaluation_ReturnDate._value !== undefined ? evaluation_ReturnDate._value.replaceAll("/", "-") : "noDate";
                let evaluationType = (evaluation_Audience_Type.getValue("audiencePost") === null || evaluation_Audience_Type.getValue("audiencePost") === undefined ? "" : evaluation_Audience_Type.getField("audiencePost").getDisplayValue());

                var myObj = {
                    classId: selectedClass.id,
                    evaluationType: selectedTab.id,
                    evaluationReturnDate: returnDate,
                    training: "<%= SecurityUtil.getFullName()%>"
                };

                var criteriaForm_operational = isc.DynamicForm.create({
                    method: "POST",
                    action: "<spring:url value="/evaluation/printTrainingReactionForm/"/>" + "pdf" + "/" + selectedClass.id,
                    target: "_Blank",
                    canSubmit: true,
                    fields:
                        [
                            {name: "CriteriaStr", type: "hidden"},
                            {name: "myToken", type: "hidden"},
                            {name: "printData", type: "hidden"}
                        ],
                    show: function () {
                        this.Super("show", arguments);
                    }
                });

                criteriaForm_operational.setValue("myToken", "<%=accessToken%>");
                criteriaForm_operational.setValue("printData", JSON.stringify(myObj));
                criteriaForm_operational.show();
                criteriaForm_operational.submit();

            } else {
                isc.Dialog.create({
                    message: "<spring:message code="no.student.class"/>",
                    icon: "[SKIN]ask.png",
                    title: "<spring:message code="global.message"/>",
                    buttons: [isc.IButtonSave.create({title: "<spring:message code="ok"/>"})],
                    buttonClick: function (button, index) {
                        this.close();
                    }
                });
            }
        }


        //*****set evaluation status*****
        function set_evaluation_status(numberOfStudents,record) {


            var listOfStudent = [];

            getStudentList(setStudentStatus);

            function getStudentList(callback) {

                if (numberOfStudents === "single") {

                    listOfStudent.push(record);
                    callback(listOfStudent);

                } else if (numberOfStudents === "all") {

                    ListGrid_evaluation_student.selectAllRecords();

                    ListGrid_evaluation_student.getSelectedRecords().forEach(function (selectedStudent) {
                        listOfStudent.push(selectedStudent);
                    });

                    ListGrid_evaluation_student.deselectAllRecords();
                    callback(listOfStudent);
                }
            }

            function setStudentStatus(listOfStudent) {

                listOfStudent.forEach(function (selectedStudent) {

                    let selectedTab = Detail_Tab_Evaluation.getSelectedTab();

                    let evaluationData = {};

                    switch (selectedTab.id) {
                        case "TabPane_Reaction": {

                            evaluationData = {
                                "evaluationAudienceType": null,
                                "idClassStudent": selectedStudent.id,
                                "reaction": 1,
                                "learning": selectedStudent.evaluationStatusLearning || 0,
                                "behavior": selectedStudent.evaluationStatusBehavior || 0,
                                "results": selectedStudent.evaluationStatusResults || 0
                            };

                            break;
                        }
                        case "TabPane_Learning": {
                            evaluationData = {
                                "evaluationAudienceType": null,
                                "idClassStudent": selectedStudent.id,
                                "reaction": selectedStudent.evaluationStatusReaction || 0,
                                "learning": 1,
                                "behavior": selectedStudent.evaluationStatusBehavior || 0,
                                "results": selectedStudent.evaluationStatusResults || 0
                            };

                            break;
                        }
                        case "TabPane_Behavior": {

                            evaluationData = {
                                "evaluationAudienceType": evaluation_Audience_Type.values.audiencePost,
                                "evaluationAudienceId": EvaluationListGrid_PeronalLIst.getSelectedRecord().id,
                                "idClassStudent": selectedStudent.id,
                                "reaction": selectedStudent.evaluationStatusReaction || 0,
                                "learning": selectedStudent.evaluationStatusLearning || 0,
                                "behavior": 1,
                                "results": selectedStudent.evaluationStatusResults || 0
                            };

                            break;
                        }
                        case "TabPane_Results": {

                            evaluationData = {
                                "evaluationAudienceType": null,
                                "idClassStudent": selectedStudent.id,
                                "reaction": selectedStudent.evaluationStatusReaction || 0,
                                "learning": selectedStudent.evaluationStatusLearning || 0,
                                "behavior": selectedStudent.evaluationStatusBehavior || 0,
                                "results": 1
                            };

                            break;
                        }
                    }
                    isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/setStudentFormIssuance/", "PUT", JSON.stringify(evaluationData), show_EvaluationActionResult));

                })
            }
        }
        function setReactionStatus(teacherReactionStatus,trainingReactionStatus){
            isc.RPCManager.sendRequest(TrDSRequest(classUrl + "setReactionStatus/" + teacherReactionStatus + "/"
                + trainingReactionStatus + "/" + ListGrid_evaluation_class.getSelectedRecord().id, "GET", null, null));
        }

        //*****callback for print student form issuance*****
        function show_EvaluationActionResult(resp) {
            var respCode = resp.httpResponseCode;
            if (respCode === 200 || respCode === 201) {

                let gridState;
                let selectedStudent = ListGrid_evaluation_student.getSelectedRecord();
                if (selectedStudent !== null)
                    gridState = "[{id:" + selectedStudent.id + "}]";

                ListGrid_evaluation_student.invalidateCache();

                if (selectedStudent !== null)
                    setTimeout(function () {

                        ListGrid_evaluation_student.setSelectedState(gridState);

                        ListGrid_evaluation_student.scrollToRow(ListGrid_evaluation_student.getRecordIndex(ListGrid_evaluation_student.getSelectedRecord()), 0);

                    }, 600);
            }
        }


        //*****Load student for tabs*****
        function loadSelectedTab_data(tab) {
            let classRecord = ListGrid_evaluation_class.getSelectedRecord();

            if (!(classRecord === undefined || classRecord === null)) {

                Detail_Tab_Evaluation.enable();

                switch (tab.id) {
                    case "TabPane_Reaction": {
                        ListGrid_evaluation_student.hideField("evaluationStatusLearning");
                        ListGrid_evaluation_student.hideField("evaluationStatusBehavior");
                        ListGrid_evaluation_student.hideField("evaluationStatusResults");
                        ListGrid_evaluation_student.showField("evaluationStatusReaction");

                        RestDataSource_evaluation_student.fetchDataURL = tclassStudentUrl + "/students-iscList/" + classRecord.id;
                        ListGrid_evaluation_student.invalidateCache();
                        ListGrid_evaluation_student.fetchData();

                        <%--ToolStripButton_FormIssuance.setTitle("<spring:message code="student.form.issuance.Reaction"/>");--%>
                        ToolStripButton_FormIssuanceForAll.setTitle("<spring:message code="students.form.issuance.Reaction"/>");
                        ToolStripButton_FormIssuance_Teacher.show();
                        ToolStripButton_FormIssuance_Training.show();
                        ToolStripButton_RegisterForm_Teacher.show();
                        ToolStripButton_RegisterForm_Training.show();
                        break;
                    }
                    case "TabPane_Learning": {
                        // ListGrid_evaluation_student.hideField("evaluationStatusReaction");
                        // ListGrid_evaluation_student.hideField("evaluationStatusBehavior");
                        // ListGrid_evaluation_student.hideField("evaluationStatusResults");
                        // ListGrid_evaluation_student.showField("evaluationStatusLearning");
                        //
                        // RestDataSource_evaluation_student.fetchDataURL = tclassStudentUrl + "/students-iscList/" + classRecord.id;
                        // ListGrid_evaluation_student.invalidateCache();
                        // ListGrid_evaluation_student.fetchData();

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

                        <%--ToolStripButton_FormIssuance.setTitle("<spring:message code="student.form.issuance.Behavioral"/>");--%>
                        ToolStripButton_FormIssuanceForAll.setTitle("<spring:message code="students.form.issuance.Behavioral"/>");
                        ToolStripButton_FormIssuance_Teacher.hide();
                        ToolStripButton_FormIssuance_Training.hide();
                        ToolStripButton_RegisterForm_Teacher.hide();
                        ToolStripButton_RegisterForm_Training.hide();
                        break;
                    }
                    case "TabPane_Results": {
                        // ListGrid_evaluation_student.hideField("evaluationStatusReaction");
                        // ListGrid_evaluation_student.hideField("evaluationStatusLearning");
                        // ListGrid_evaluation_student.hideField("evaluationStatusBehavior");
                        // ListGrid_evaluation_student.showField("evaluationStatusResults");
                        //
                        // RestDataSource_evaluation_student.fetchDataURL = tclassStudentUrl + "/students-iscList/" + classRecord.id;
                        // ListGrid_evaluation_student.invalidateCache();
                        // ListGrid_evaluation_student.fetchData();

                        break;
                    }
                }

            } else {
                Detail_Tab_Evaluation.disable();
            }
        }

        //*****set tabset status*****
        function set_Evaluation_Tabset_status() {

            let classRecord = ListGrid_evaluation_class.getSelectedRecord();
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
            // if(!classRecord.preCourseTest)
            //     Detail_Tab_Evaluation.disableTab(1);

            VLayout_Body_evaluation.enable();

        }

        function print_Question(questions) {

            var criteriaForm = isc.DynamicForm.create({
                method: "POST",
                action: "<spring:url value="/questionnaireReport/questionnaire/"/>" + "pdf",
                target: "_Blank",
                canSubmit: true,
                fields:
                    [
                        {name: "token", type: "hidden"},
                        {name: "questionnaire", type: "hidden"},
                        {name: "title", type: "hidden"}
                    ]

            });
            criteriaForm.setValue("token", "<%= accessToken %>");
            criteriaForm.setValue("questionnaire", JSON.stringify(questions));
            criteriaForm.setValue("title", JSON.stringify(DynamicForm_Questions_Title_JspEvaluation.getValues()));
            criteriaForm.show();
            criteriaForm.submitForm();
        }

        function load_term_by_year(value)
        {
            let criteria= '{"fieldName":"startDate","operator":"iStartsWith","value":"' + value + '"}';
            RestDataSource_Term_Filter.fetchDataURL = termUrl + "spec-list?operator=or&_constructor=AdvancedCriteria&criteria=" + criteria;
            DynamicForm_Evalution_Term_Filter.getItem("termFilter").fetchData();
        }
        ////******************************

        ////*****load classes by term*****
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
                RestDataSource_evaluation_class.fetchDataURL = evaluationUrl + "/class-spec-list";
               ListGrid_evaluation_class.implicitCriteria = criteria;
               ListGrid_evaluation_class.invalidateCache();
               ListGrid_evaluation_class.fetchData();
            }
            else
            {
                createDialog("info", "<spring:message code="msg.select.term.ask"/>", "<spring:message code="message"/>")
            }
        }

    }
    // ------------------------------------------------- Functions ------------------------------------------>>
    function register_evaluation_result(LGRecord){
        let studentIdJspEvaluation;
        let teacherIdJspEvaluation = LGRecord.teacherId;
        let evaluationLevelId;
        let saveMethod;
        let saveUrl = evaluationUrl;
        let valueMapAnswer = {209: "خیلی ضعیف", 208: "ضعیف", 207: "متوسط", 206: "خوب", 205: "عالی"};
        let RestData_EvaluationType_JspEvaluation = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true, hidden: true},
                {
                    name: "title",
                    title: "<spring:message code="title"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "code",
                    title: "<spring:message code="code"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "type",
                    title: "<spring:message code="type"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "value",
                    title: "<spring:message code="value"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "description",
                    title: "<spring:message code="description"/>",
                    filterOperator: "iContains"
                }
            ],
            fetchDataURL: parameterValueUrl + "/iscList/143"
        });
        let RestData_EvaluationLevel_JspEvaluation = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true, hidden: true},
                {
                    name: "title",
                    title: "<spring:message code="title"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "code",
                    title: "<spring:message code="code"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "type",
                    title: "<spring:message code="type"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "value",
                    title: "<spring:message code="value"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "description",
                    title: "<spring:message code="description"/>",
                    filterOperator: "iContains"
                }
            ],
            fetchDataURL: parameterValueUrl + "/iscList/163"
        });
        let RestData_Students_JspEvaluation = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true, hidden: true},
                {name: "student.id", hidden: true},
                {
                    name: "student.firstName",
                    title: "<spring:message code="firstName"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "student.lastName",
                    title: "<spring:message code="lastName"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "student.nationalCode",
                    title: "<spring:message code="national.code"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "applicantCompanyName",
                    title: "<spring:message code="company.applicant"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "presenceTypeId",
                    title: "<spring:message code="class.presence.type"/>",
                    filterOperator: "equals",
                    autoFitWidth: true
                },
                {
                    name: "student.companyName",
                    title: "<spring:message code="company.name"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "student.personnelNo",
                    title: "<spring:message code="personnel.no"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "student.personnelNo2",
                    title: "<spring:message code="personnel.no.6.digits"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "student.postTitle",
                    title: "<spring:message code="post"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "student.ccpArea",
                    title: "<spring:message code="reward.cost.center.area"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "student.ccpAssistant",
                    title: "<spring:message code="reward.cost.center.assistant"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "student.ccpAffairs",
                    title: "<spring:message code="reward.cost.center.affairs"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "student.ccpSection",
                    title: "<spring:message code="reward.cost.center.section"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "student.ccpUnit",
                    title: "<spring:message code="reward.cost.center.unit"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "evaluationAudienceId"
                }
            ],
            fetchDataURL: tclassStudentUrl + "/students-iscList/"
        });
        let RestData_StudentPresenceType_JspEvaluation = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true, hidden: true},
                {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
                {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
            ],
            fetchDataURL: parameterValueUrl + "/iscList/98"
        });
        let vm_JspEvaluation = isc.ValuesManager.create({});

        let DynamicForm_Questions_Title_JspEvaluation = isc.DynamicForm.create({
            ID: "DynamicForm_Questions_Title_JspEvaluation",
            validateOnChange: true,
            // height: "10%",
            numCols: 6,
            valuesManager: vm_JspEvaluation,
            // colWidths:["29%","68%"],
            width: "100%",
            borderRadius: "10px 10px 0px 0px",
            border: "2px solid black",
            titleAlign: "left",
            margin: 10,
            padding: 10,
            fields: [
                {name: "code", title: "<spring:message code="class.code"/>:", canEdit: false},
                {
                    name: "titleClass",
                    title: "<spring:message code='class.title'/>:",
                    canEdit: false
                },
                {
                    name: "startDate",
                    title: "<spring:message code='start.date'/>:",
                    canEdit: false
                },
                {name: "teacher", title: "<spring:message code='teacher'/>:", canEdit: false},
                {
                    name: "institute.titleFa",
                    title: "<spring:message code='institute'/>:",
                    canEdit: false
                },
                {name: "user", title: "<spring:message code='user'/>:", canEdit: false},
                {
                    name: "evaluationLevel",
                    title: "<spring:message code="evaluation.level"/>",
                    type: "SelectItem",
                    pickListProperties: {showFilterEditor: false},
                    optionDataSource: RestData_EvaluationLevel_JspEvaluation,
                    valueField: "code",
                    displayField: "title",
                    required: true,
                    changed: function (form, item, value) {
                        DynamicForm_Questions_Body_JspEvaluation.clearValues();
                        DynamicForm_Description_JspEvaluation.clearValues();
                        var criteria = '{"fieldName":"questionnaireType.code","operator":"equals","value":""}';
                        var criteriaEdit =
                            '{"fieldName":"classId","operator":"equals","value":' + LGRecord.id + '},' +
                            '{"fieldName":"questionnaireTypeId","operator":"equals","value":139},' +
                            '{"fieldName":"evaluatorId","operator":"equals","value":' + studentIdJspEvaluation + '},' +
                            '{"fieldName":"evaluatorTypeId","operator":"equals","value":188},';
                        DynamicForm_Questions_Body_JspEvaluation.setFields([]);
                        // requestEvaluationQuestions(criteria, 1);
                        switch (value) {
                            case "Behavioral":
                                form.getItem("evaluationType").clearValue();
                                form.getItem("evaluator").clearValue();
                                form.getItem("evaluated").clearValue();
                                DynamicForm_Description_JspEvaluation.clearValues();
                                RestData_Students_JspEvaluation.fetchDataURL = tclassStudentUrl + "/students-iscList/" + LGRecord.id;
                                Window_AddStudent_JspEvaluation.show();
                                form.getItem("evaluationType").setValue("OEFS");
                                form.getItem("evaluationType").disable();
                                break;
                            case "Results":
                                // criteriaEdit += '{"fieldName":"evaluationLevelId","operator":"equals","value":157}';
                                // evaluationLevelId = 157;
                                // requestEvaluationQuestions(criteria, criteriaEdit, 1);
                                form.getItem("evaluationType").clearValue();
                                form.getItem("evaluator").clearValue();
                                form.getItem("evaluated").clearValue();
                                form.getItem("evaluationType").disable();
                                DynamicForm_Description_JspEvaluation.clearValues();
                                DynamicForm_Description_JspEvaluation.hide();
                                break;
                            case "Reactive":
                                form.getItem("evaluationType").clearValue();
                                form.getItem("evaluator").clearValue();
                                form.getItem("evaluated").clearValue();
                                form.getItem("evaluationType").enable();
                                DynamicForm_Description_JspEvaluation.clearValues();
                                DynamicForm_Description_JspEvaluation.hide();
                                break;
                            case "Learning":
                                // evaluationLevelId = 155;
                                // criteriaEdit += '{"fieldName":"evaluationLevelId","operator":"equals","value":155}';
                                // requestEvaluationQuestions(criteria, criteriaEdit, 1);
                                form.getItem("evaluationType").clearValue();
                                form.getItem("evaluator").clearValue();
                                form.getItem("evaluated").clearValue();
                                form.getItem("evaluationType").disable();
                                DynamicForm_Description_JspEvaluation.clearValues();
                                DynamicForm_Description_JspEvaluation.hide();
                                break;
                            default:
                                break;
                        }
                    }
                },
                {
                    name: "evaluationType",
                    title: "<spring:message code="evaluation.type"/>",
                    type: "SelectItem",
                    optionDataSource: RestData_EvaluationType_JspEvaluation,
                    pickListProperties: {showFilterEditor: false},
                    valueField: "code",
                    required: true,
                    disabled: true,
                    displayField: "title",
                    endRow: true,
                    changed: function (form, item, value) {
                        DynamicForm_Questions_Body_JspEvaluation.clearValues();
                        DynamicForm_Description_JspEvaluation.clearValues();
                        form.clearErrors(true);
                        // form.clearValue("evaluationLevel");
                        // form.clearValue("evaluator");
                        // form.clearValue("evaluated");
                        var criteria = '{"fieldName":"questionnaireType.code","operator":"equals","value":""}';
                        DynamicForm_Questions_Body_JspEvaluation.setFields([]);
                        form.getItem("evaluationLevel").disable();
                        var criteriaEdit =
                            '{"fieldName":"classId","operator":"equals","value":' + LGRecord.id + '},';
                        // '{"fieldName":"questionnaireTypeId","operator":"equals","value":139},' +
                        // '{"fieldName":"evaluatorId","operator":"equals","value":'+studentIdJspEvaluation+'},' +
                        // '{"fieldName":"evaluatorTypeId","operator":"equals","value":188},';
                        switch (value) {
                            // requestEvaluationQuestions(criteria, criteriaEdit, 1);
                            case "SEFT":
                                DynamicForm_Description_JspEvaluation.show();
                                criteria = '{"fieldName":"questionnaireType.code","operator":"equals","value":"SEFT"}';
                                criteriaEdit +=
                                    '{"fieldName":"questionnaireTypeId","operator":"equals","value":141},' +
                                    '{"fieldName":"evaluatorId","operator":"equals","value":<%= SecurityUtil.getUserId()%>},' +
                                    '{"fieldName":"evaluatorTypeId","operator":"equals","value":189},' +
                                    '{"fieldName":"evaluatedId","operator":"equals","value":' + teacherIdJspEvaluation + '},' +
                                    '{"fieldName":"evaluatedTypeId","operator":"equals","value":187}';
                                form.setValue("evaluator", form.getValue("user"));
                                form.setValue("evaluated", form.getValue("teacher"));
                                form.getItem("evaluationLevel").setRequired(false);
                                // requestEvaluationQuestions(criteria, criteriaEdit, 1);
                                break;
                            case "SEFC":
                                DynamicForm_Description_JspEvaluation.show();
                                // criteria= '{"fieldName":"domain.code","operator":"equals","value":"SAT"}';
                                RestData_Students_JspEvaluation.fetchDataURL = tclassStudentUrl + "/students-iscList/" + LGRecord.id;
                                Window_AddStudent_JspEvaluation.show();
                                evaluationLevelId = 154;
                                return;
                            case "TEFC":
                                DynamicForm_Description_JspEvaluation.show();
                                criteria = '{"fieldName":"questionnaireType.code","operator":"equals","value":"TEFC"}';
                                criteriaEdit +=
                                    '{"fieldName":"questionnaireTypeId","operator":"equals","value":140},' +
                                    '{"fieldName":"evaluatorId","operator":"equals","value":' + teacherIdJspEvaluation + '},' +
                                    '{"fieldName":"evaluatorTypeId","operator":"equals","value":187}';
                                form.setValue("evaluator", form.getValue("teacher"));
                                form.setValue("evaluated", form.getValue("titleClass"));
                                form.getItem("evaluationLevel").setRequired(false);
                                break;
                            case "OEFS":
                                criteria = '{"fieldName":"questionnaireType.code","operator":"equals","value":"OEFS"}';
                                criteriaEdit +=
                                    '{"fieldName":"questionnaireTypeId","operator":"equals","value":230},' +
                                    '{"fieldName":"evaluatorId","operator":"equals","value":' + studentIdJspEvaluation + '},' +
                                    '{"fieldName":"evaluatorTypeId","operator":"equals","value":188}';
                                form.getItem("evaluationLevel").setValue("Behavioral");
                                criteriaEdit += '{"fieldName":"evaluationLevelId","operator":"equals","value":156}';
                                evaluationLevelId = 156;
                                requestEvaluationQuestions(criteria, criteriaEdit, 1);
                                break;
                        }
                        requestEvaluationQuestions(criteria, criteriaEdit);
                    }
                },
                {
                    name: "evaluator",
                    title: "<spring:message code="evaluator"/>",
                    required: true,
                    disabled: true
                },
                {
                    name: "evaluated",
                    title: "<spring:message code="evaluation.evaluated"/>",
                    required: true,
                    disabled: true
                }
            ]
        });
        let DynamicForm_Questions_Body_JspEvaluation = isc.DynamicForm.create({
            ID: "DynamicForm_Questions_Body_JspEvaluation",
            validateOnExit: true,
            valuesManager: vm_JspEvaluation,
            colWidths: ["45%", "50%"],
            cellBorder: 1,
            width: "100%",
            padding: 10,
            fields: []
        });

        let DynamicForm_Description_JspEvaluation = isc.DynamicForm.create({
            ID: "DynamicForm_Description_JspEvaluation",
            validateOnExit: true,
            valuesManager: vm_JspEvaluation,
            width: "100%",
            fields: [
                {
                    name: "description",
                    title: "<spring:message code='description'/>",
                    type: 'textArea'
                }
            ]
        });
        let Window_Questions_JspEvaluation = isc.Window.create({
            width: 1024,
            height: 768,
            keepInParentRect: true,
            title: "<spring:message code="record.evaluation.results"/>",
            items: [
                DynamicForm_Questions_Title_JspEvaluation,
                DynamicForm_Questions_Body_JspEvaluation,
                DynamicForm_Description_JspEvaluation,
                isc.TrHLayoutButtons.create({
                    members: [
                        IButton_Questions_Save,
                        <sec:authorize access="hasAuthority('Evaluation_P')">
                        <%--                        IButton_Questions_Print,--%>
                        </sec:authorize>

                        isc.IButtonCancel.create({
                            click: function () {
                                Window_Questions_JspEvaluation.close();
                            }
                        })]
                })
            ],
            minWidth: 1024
        });

        let IButton_Questions_Save = isc.IButtonSave.create({
            click: function () {
                if (!DynamicForm_Questions_Title_JspEvaluation.validate()) {
                    return;
                }
                let evaluationAnswerList = [];
                let data = {};
                let evaluationFull = true;
                let questions = DynamicForm_Questions_Body_JspEvaluation.getFields();
                for (let i = 0; i < questions.length; i++) {
                    if (DynamicForm_Questions_Body_JspEvaluation.getValue(questions[i].name) === undefined) {
                        evaluationFull = false;
                    }
                    let evaluationAnswer = {};
                    evaluationAnswer.answerID = DynamicForm_Questions_Body_JspEvaluation.getValue(questions[i].name);
                    evaluationAnswer.evaluationQuestionId = questions[i].name.substring(1);
                    evaluationAnswer.questionSourceId = questionSourceConvert(questions[i].name);
                    evaluationAnswerList.push(evaluationAnswer);
                }
                data.evaluationAnswerList = evaluationAnswerList;
                data.evaluationFull = evaluationFull;
                data.description = DynamicForm_Description_JspEvaluation.getField("description").getValue();
                switch (DynamicForm_Questions_Title_JspEvaluation.getValue("evaluationType")) {
                    case "SEFT":
                        data.evaluatorId = "<%= SecurityUtil.getUserId()%>";
                        data.evaluatedId = LGRecord.teacherId;
                        data.evaluatorTypeId = 189;
                        data.evaluatedTypeId = 187;
                        data.questionnaireTypeId = 141;
                        break;
                    case "TEFC":
                        data.evaluatorId = LGRecord.teacherId;
                        data.evaluatedId = null;
                        data.evaluatorTypeId = 187;
                        data.evaluatedTypeId = null;
                        data.questionnaireTypeId = 140;
                        break;
                    case "SEFC":
                        data.evaluatorId = studentIdJspEvaluation;
                        data.evaluatedId = null;
                        data.evaluatorTypeId = 188;
                        data.evaluatedTypeId = null;
                        data.evaluationLevelId = evaluationLevelId;
                        data.questionnaireTypeId = 139;
                        break;
                    case "OEFS":
                        data.questionnaireTypeId = 230;
                        data.evaluatorId = eeid;
                        data.evaluatedId = studentIdJspEvaluation;
                        // data.evaluatorTypeId = 188;
                        // data.evaluatedTypeId = null;
                        data.evaluationLevelId = evaluationLevelId;
                        break;
                }
                data.classId = LGRecord.id;
                isc.RPCManager.sendRequest(TrDSRequest(saveUrl, saveMethod, JSON.stringify(data), function (resp) {
                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                        Window_Questions_JspEvaluation.close();
                        ListGrid_evaluation_student.invalidateCache();
                        isc.RPCManager.sendRequest(TrDSRequest(evaluationAnalysisUrl + "/updateEvaluationAnalysis" + "/" +
                            LGRecord.id,
                            "GET", null, null));
                        const msg = createDialog("info", "<spring:message code="global.form.request.successful"/>");
                        setTimeout(() => {
                            msg.close();
                        }, 3000);
                    } else {
                        createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                    }
                }))
            }
        });
        let IButton_Questions_Print = isc.IButtonSave.create({
            title: "چاپ",
            click: function () {
                if (!DynamicForm_Questions_Title_JspEvaluation.validate()) {
                    return;
                }
                let fields = DynamicForm_Questions_Body_JspEvaluation.getFields();
                let questions = [];
                for (let i = 0; i < fields.length; i++) {
                    let record = {};
                    record.title = fields[i].title;
                    questions.push(record);
                }
                print_Question(questions)
            }
        });

        let Window_AddStudent_JspEvaluation = isc.Window.create({
            title: "<spring:message code="students.list"/>",
            width: "50%",
            height: "50%",
            keepInParentRect: true,
            autoSize: false,
            items: [
                isc.TrHLayout.create({
                    members: [
                        isc.TrLG.create({
                            ID: "ListGrid_Students_JspEvaluation",
                            dataSource: RestData_Students_JspEvaluation,
                            selectionType: "single",
                            filterOnKeypress: true,
                            autoFetchData: true,
                            fields: [
                                {
                                    name: "student.firstName",
                                    title: "<spring:message code="firstName"/>"
                                },
                                {name: "student.lastName", title: "<spring:message code="lastName"/>"},
                                {
                                    name: "student.nationalCode",
                                    title: "<spring:message code="national.code"/>",
                                    filterEditorProperties: {
                                        keyPressFilter: "[0-9]"
                                    }
                                },
                                {
                                    name: "student.personnelNo",
                                    filterEditorProperties: {
                                        keyPressFilter: "[0-9]"
                                    }
                                },
                                {
                                    name: "student.personnelNo2",
                                    filterEditorProperties: {
                                        keyPressFilter: "[0-9]"
                                    }
                                },
                                {name: "student.postTitle"},
                                {
                                    name: "presenceTypeId",
                                    type: "selectItem",
                                    valueField: "id",
                                    displayField: "title",
                                    optionDataSource: RestData_StudentPresenceType_JspEvaluation
                                },
                                {
                                    name: "evaluationAudienceId",
                                    hidden: true
                                }
                            ],
                            gridComponents: ["filterEditor", "header", "body"],
                            recordDoubleClick: function (viewer, record, recordNum, field, fieldNum, value, rawValue) {
                                studentIdJspEvaluation = record.id;
                                if (DynamicForm_Questions_Title_JspEvaluation.getItem("evaluationLevel").getValue() === "Behavioral") {
                                    DynamicForm_Questions_Title_JspEvaluation.setValue("evaluated", record.student.firstName + " " + record.student.lastName);
                                    if (record.evaluationAudienceId != undefined) {
                                        isc.RPCManager.sendRequest(TrDSRequest(personnelUrl + "/byId/" + record.evaluationAudienceId, "GET", null, function (resp) {
                                            DynamicForm_Questions_Title_JspEvaluation.setValue("evaluator",
                                                JSON.parse(resp.httpResponseText).firstName + " " + JSON.parse(resp.httpResponseText).lastName);
                                            eeid = JSON.parse(resp.httpResponseText).id;
                                        }));
                                    }
                                        let criteriaEdit = '';
                                        let criteria = '{"fieldName":"questionnaireType.code","operator":"equals","value":"OEFS"}';
                                         DynamicForm_Description_JspEvaluation.show();
                                        criteriaEdit += '{"fieldName":"evaluationLevelId","operator":"equals","value":156},'+
                                        '{"fieldName":"evaluatedId","operator":"equals","value":' + studentIdJspEvaluation + '}' ;
                                                                                evaluationLevelId = 156;
                                        requestEvaluationQuestions(criteria, criteriaEdit, 1);
                                }
                                else if (DynamicForm_Questions_Title_JspEvaluation.getItem("evaluationLevel").getValue() === "Reactive") {
                                    let criteriaEdit = '';
                                    DynamicForm_Questions_Title_JspEvaluation.setValue("evaluator", record.student.firstName + " " + record.student.lastName);
                                    let criteria = '{"fieldName":"questionnaireType.code","operator":"equals","value":"SEFC"}';
                                    criteriaEdit += '{"fieldName":"evaluationLevelId","operator":"equals","value":154},'+
                                        '{"fieldName":"evaluatorId","operator":"equals","value":' + studentIdJspEvaluation + '}' ;
                                    DynamicForm_Questions_Title_JspEvaluation.setValue("evaluated", DynamicForm_Questions_Title_JspEvaluation.getValue("titleClass"));
                                    DynamicForm_Questions_Title_JspEvaluation.getItem("evaluationLevel").setRequired(true);
                                    requestEvaluationQuestions(criteria, criteriaEdit, 1);
                                }
                                Window_AddStudent_JspEvaluation.close();
                            }
                        })
                    ]
                })]
        });

        DynamicForm_Questions_Title_JspEvaluation.clearValues();
        DynamicForm_Description_JspEvaluation.clearValues();
        DynamicForm_Description_JspEvaluation.hide();
        DynamicForm_Questions_Title_JspEvaluation.getItem("evaluationType").disable();

        DynamicForm_Questions_Title_JspEvaluation.editRecord(LGRecord);
        DynamicForm_Questions_Title_JspEvaluation.setValue("user", "<%= SecurityUtil.getFullName()%>");
        let itemList = [];
        let eeid;
        evalWait = createDialog("wait");
        Window_Questions_JspEvaluation.show();

        function requestEvaluationQuestions(criteria, criteriaEdit, type = 0) {
            isc.RPCManager.sendRequest(TrDSRequest(questionnaireUrl + "/iscList?operator=or&_constructor=AdvancedCriteria&criteria=" + criteria, "GET", null, function (resp) {
                if (JSON.parse(resp.data).response.data.length > 0) {
                    let criteria = '{"fieldName":"questionnaireId","operator":"equals","value":' + JSON.parse(resp.data).response.data[0].id + '}';
                    isc.RPCManager.sendRequest(TrDSRequest(questionnaireQuestionUrl + "/iscList?operator=or&_constructor=AdvancedCriteria&criteria=" + criteria, "GET", null, function (resp) {
                        localQuestions = JSON.parse(resp.data).response.data;
                        for (let i = 0; i < localQuestions.length; i++) {
                            let item = {};
                            switch (localQuestions[i].evaluationQuestion.domain.code) {
                                case "EQP":
                                    item.name = "Q" + localQuestions[i].id;
                                    item.title = "امکانات: " + localQuestions[i].evaluationQuestion.question;
                                    break;
                                case "CLASS":
                                    item.name = "Q" + localQuestions[i].id;
                                    item.title = "کلاس: " + localQuestions[i].evaluationQuestion.question;
                                    break;
                                case "SAT":
                                    item.name = "Q" + localQuestions[i].id;
                                    item.title = "مدرس: " + localQuestions[i].evaluationQuestion.question;
                                    break;
                                case "TRAINING":
                                    item.name = "Q" + localQuestions[i].id;
                                    item.title = "مدرس: " + localQuestions[i].evaluationQuestion.question;
                                    break;
                                case "Content":
                                    item.name = "Q" + localQuestions[i].id;
                                    item.title = "محتواي کلاس: " + localQuestions[i].evaluationQuestion.question;
                                    break;
                                default:
                                    item.name = "Q" + localQuestions[i].id;
                                    item.title = localQuestions[i].evaluationQuestion.question;
                            }

                            item.type = "radioGroup";
                            item.vertical = false;
                            // item.required = true;
                            item.fillHorizontalSpace = true;
                            item.valueMap = valueMapAnswer;
                            // item.colSpan = ,
                            item.icons = [
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
                                    }
                                }
                            ];
                            itemList.add(item);
                        }
                        ;
                        if (type !== 0) {
                            isc.RPCManager.sendRequest(TrDSRequest(courseUrl + "goal-mainObjective/" + LGRecord.course.id, "GET", null, function (resp) {
                                localQuestions = JSON.parse(resp.data);
                                for (let i = 0; i < localQuestions.length; i++) {
                                    let item = {};
                                    switch (localQuestions[i].type) {
                                        case "goal":
                                            item.name = "G" + localQuestions[i].id;
                                            item.title = "هدف: " + localQuestions[i].title;
                                            break;
                                        case "skill":
                                            item.name = "M" + localQuestions[i].id;
                                            item.title = "هدف اصلي: " + localQuestions[i].title;
                                            break;
                                        // default:
                                        //     return;
                                    }
                                    item.type = "radioGroup";
                                    item.vertical = false;
                                    // item.required = true;
                                    item.fillHorizontalSpace = true;
                                    item.valueMap = valueMapAnswer;
                                    // item.colSpan = ,
                                    item.icons = [
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
                                            }
                                        }
                                    ];
                                    itemList.add(item);
                                }
                                DynamicForm_Questions_Body_JspEvaluation.setItems(itemList);
                                requestEvaluationQuestionsEdit(criteriaEdit);
                            }));
                        } else {
                            DynamicForm_Questions_Body_JspEvaluation.setItems(itemList);
                            requestEvaluationQuestionsEdit(criteriaEdit);
                        }
                    }));
                } else {
                    if (type !== 0) {
                        isc.RPCManager.sendRequest(TrDSRequest(courseUrl + "goal-mainObjective/" + LGRecord.course.id, "GET", null, function (resp) {
                            localQuestions = JSON.parse(resp.data);
                            for (let i = 0; i < localQuestions.length; i++) {
                                let item = {};
                                switch (localQuestions[i].type) {
                                    case "goal":
                                        item.name = "G" + localQuestions[i].id;
                                        item.title = "هدف: " + (i + 1).toString() + "- " + localQuestions[i].title;
                                        break;
                                    case "skill":
                                        item.name = "M" + localQuestions[i].id;
                                        item.title = "هدف اصلي: " + (i + 1).toString() + "- " + localQuestions[i].title;
                                        break;
                                    // default:
                                    //     return;
                                }
                                item.type = "radioGroup";
                                item.vertical = false;
                                // item.required = true;
                                item.fillHorizontalSpace = true;
                                item.valueMap = valueMapAnswer;
                                // item.colSpan = ,
                                item.icons = [
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
                                        }
                                    }
                                ];
                                itemList.add(item);
                            }
                            DynamicForm_Questions_Body_JspEvaluation.setItems(itemList);
                            requestEvaluationQuestionsEdit(criteriaEdit);
                        }));
                    } else {
                        DynamicForm_Questions_Body_JspEvaluation.setItems(itemList);
                        requestEvaluationQuestionsEdit(criteriaEdit);
                    }
                }
                evalWait.close();
            }));

        }

        function requestEvaluationQuestionsEdit(criteria) {
            isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/spec-list?operator=and&_constructor=AdvancedCriteria&criteria=" + criteria, "GET", null, function (resp) {
                if (resp.httpResponseCode == 201 || resp.httpResponseCode == 200) {
                    let data = JSON.parse(resp.data).response.data;
                    let record = {};
                    if (!data.isEmpty()) {
                        let answer = data[0].evaluationAnswerList;
                        let description = data[0].description;
                        for (let i = 0; i < answer.length; i++) {
                            switch (answer[i].questionSourceId) {
                                case 199:
                                    record["Q" + answer[i].evaluationQuestionId] = answer[i].answerId;
                                    break;
                                case 200:
                                    record["M" + answer[i].evaluationQuestionId] = answer[i].answerId;
                                    break;
                                case 201:
                                    record["G" + answer[i].evaluationQuestionId] = answer[i].answerId;
                                    break;
                            }
                        }
                        DynamicForm_Questions_Body_JspEvaluation.setValues(record);
                        DynamicForm_Description_JspEvaluation.getField("description").setValue(description);
                        saveMethod = "PUT";
                        saveUrl = evaluationUrl + "/" + data[0].id;
                        return;
                    }
                    saveMethod = "POST";
                    saveUrl = evaluationUrl;
                }
            }))
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
    }
    function register_evaluation_result_reaction_student(StdRecord){
            let LGRecord = ListGrid_evaluation_class.getSelectedRecord();
            let studentIdJspEvaluation;
            let teacherIdJspEvaluation = LGRecord.teacherId;
            let evaluationLevelId;
            let saveMethod;
            let saveUrl = evaluationUrl;
            let valueMapAnswer = {209: "خیلی ضعیف", 208: "ضعیف", 207: "متوسط", 206: "خوب", 205: "عالی"};
            let RestData_EvaluationType_JspEvaluation = isc.TrDS.create({
                fields: [
                    {name: "id", primaryKey: true, hidden: true},
                    {
                        name: "title",
                        title: "<spring:message code="title"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "code",
                        title: "<spring:message code="code"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "type",
                        title: "<spring:message code="type"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "value",
                        title: "<spring:message code="value"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "description",
                        title: "<spring:message code="description"/>",
                        filterOperator: "iContains"
                    }
                ],
                fetchDataURL: parameterValueUrl + "/iscList/143"
            });
            let RestData_EvaluationLevel_JspEvaluation = isc.TrDS.create({
                fields: [
                    {name: "id", primaryKey: true, hidden: true},
                    {
                        name: "title",
                        title: "<spring:message code="title"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "code",
                        title: "<spring:message code="code"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "type",
                        title: "<spring:message code="type"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "value",
                        title: "<spring:message code="value"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "description",
                        title: "<spring:message code="description"/>",
                        filterOperator: "iContains"
                    }
                ],
                fetchDataURL: parameterValueUrl + "/iscList/163"
            });
            let RestData_Students_JspEvaluation = isc.TrDS.create({
                fields: [
                    {name: "id", primaryKey: true, hidden: true},
                    {name: "student.id", hidden: true},
                    {
                        name: "student.firstName",
                        title: "<spring:message code="firstName"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "student.lastName",
                        title: "<spring:message code="lastName"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "student.nationalCode",
                        title: "<spring:message code="national.code"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "applicantCompanyName",
                        title: "<spring:message code="company.applicant"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "presenceTypeId",
                        title: "<spring:message code="class.presence.type"/>",
                        filterOperator: "equals",
                        autoFitWidth: true
                    },
                    {
                        name: "student.companyName",
                        title: "<spring:message code="company.name"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "student.personnelNo",
                        title: "<spring:message code="personnel.no"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "student.personnelNo2",
                        title: "<spring:message code="personnel.no.6.digits"/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "student.postTitle",
                        title: "<spring:message code="post"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "student.ccpArea",
                        title: "<spring:message code="reward.cost.center.area"/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "student.ccpAssistant",
                        title: "<spring:message code="reward.cost.center.assistant"/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "student.ccpAffairs",
                        title: "<spring:message code="reward.cost.center.affairs"/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "student.ccpSection",
                        title: "<spring:message code="reward.cost.center.section"/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "student.ccpUnit",
                        title: "<spring:message code="reward.cost.center.unit"/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "evaluationAudienceId"
                    }
                ],
                fetchDataURL: tclassStudentUrl + "/students-iscList/"
            });
            let vm_JspEvaluation = isc.ValuesManager.create({});

            let DynamicForm_Questions_Title_JspEvaluation = isc.DynamicForm.create({
                ID: "DynamicForm_Questions_Title_JspEvaluation",
                validateOnChange: true,
                numCols: 6,
                valuesManager: vm_JspEvaluation,
                width: "100%",
                borderRadius: "10px 10px 0px 0px",
                border: "2px solid black",
                titleAlign: "left",
                margin: 10,
                padding: 10,
                fields: [
                    {name: "code", title: "<spring:message code="class.code"/>:", canEdit: false},
                    {
                        name: "titleClass",
                        title: "<spring:message code='class.title'/>:",
                        canEdit: false
                    },
                    {
                        name: "startDate",
                        title: "<spring:message code='start.date'/>:",
                        canEdit: false
                    },
                    {name: "teacher", title: "<spring:message code='teacher'/>:", canEdit: false},
                    {
                        name: "institute.titleFa",
                        title: "<spring:message code='institute'/>:",
                        canEdit: false
                    },
                    {name: "user", title: "<spring:message code='user'/>:", canEdit: false},
                    {
                        name: "evaluationLevel",
                        title: "<spring:message code="evaluation.level"/>",
                        type: "SelectItem",
                        pickListProperties: {showFilterEditor: false},
                        optionDataSource: RestData_EvaluationLevel_JspEvaluation,
                        valueField: "code",
                        displayField: "title",
                        disabled: true,
                        required: true,
                        changed: function (form, item, value) {
                        }
                    },
                    {
                        name: "evaluationType",
                        title: "<spring:message code="evaluation.type"/>",
                        type: "SelectItem",
                        optionDataSource: RestData_EvaluationType_JspEvaluation,
                        pickListProperties: {showFilterEditor: false},
                        valueField: "code",
                        required: true,
                        disabled: true,
                        displayField: "title",
                        endRow: true,
                        changed: function (form, item, value) {
                            DynamicForm_Questions_Body_JspEvaluation.clearValues();
                            DynamicForm_Description_JspEvaluation.clearValues();
                            form.clearErrors(true);
                            var criteria = '{"fieldName":"questionnaireType.code","operator":"equals","value":""}';
                            DynamicForm_Questions_Body_JspEvaluation.setFields([]);
                            form.getItem("evaluationLevel").disable();
                            var criteriaEdit =
                                '{"fieldName":"classId","operator":"equals","value":' + LGRecord.id + '},';
                            switch (value) {
                                case "SEFT":
                                    DynamicForm_Description_JspEvaluation.show();
                                    criteria = '{"fieldName":"questionnaireType.code","operator":"equals","value":"SEFT"}';
                                    criteriaEdit +=
                                        '{"fieldName":"questionnaireTypeId","operator":"equals","value":141},' +
                                        '{"fieldName":"evaluatorId","operator":"equals","value":<%= SecurityUtil.getUserId()%>},' +
                                        '{"fieldName":"evaluatorTypeId","operator":"equals","value":189},' +
                                        '{"fieldName":"evaluatedId","operator":"equals","value":' + teacherIdJspEvaluation + '},' +
                                        '{"fieldName":"evaluatedTypeId","operator":"equals","value":187}';
                                    form.setValue("evaluator", form.getValue("user"));
                                    form.setValue("evaluated", form.getValue("teacher"));
                                    form.getItem("evaluationLevel").setRequired(false);
                                    break;
                                case "SEFC":

                                    return;
                                case "TEFC":
                                    DynamicForm_Description_JspEvaluation.show();
                                    criteria = '{"fieldName":"questionnaireType.code","operator":"equals","value":"TEFC"}';
                                    criteriaEdit +=
                                        '{"fieldName":"questionnaireTypeId","operator":"equals","value":140},' +
                                        '{"fieldName":"evaluatorId","operator":"equals","value":' + teacherIdJspEvaluation + '},' +
                                        '{"fieldName":"evaluatorTypeId","operator":"equals","value":187}';
                                    form.setValue("evaluator", form.getValue("teacher"));
                                    form.setValue("evaluated", form.getValue("titleClass"));
                                    form.getItem("evaluationLevel").setRequired(false);
                                    break;
                                case "OEFS":
                                    criteria = '{"fieldName":"questionnaireType.code","operator":"equals","value":"OEFS"}';
                                    criteriaEdit +=
                                        '{"fieldName":"questionnaireTypeId","operator":"equals","value":230},' +
                                        '{"fieldName":"evaluatorId","operator":"equals","value":' + studentIdJspEvaluation + '},' +
                                        '{"fieldName":"evaluatorTypeId","operator":"equals","value":188}';
                                    form.getItem("evaluationLevel").setValue("Behavioral");
                                    criteriaEdit += '{"fieldName":"evaluationLevelId","operator":"equals","value":156}';
                                    evaluationLevelId = 156;
                                    requestEvaluationQuestions(criteria, criteriaEdit, 1);
                                    break;
                            }
                            requestEvaluationQuestions(criteria, criteriaEdit);
                        }
                    },
                    {
                        name: "evaluator",
                        title: "<spring:message code="evaluator"/>",
                        required: true,
                        disabled: true
                    },
                    {
                        name: "evaluated",
                        title: "<spring:message code="evaluation.evaluated"/>",
                        required: true,
                        disabled: true
                    }
                ]
            });
            let DynamicForm_Questions_Body_JspEvaluation = isc.DynamicForm.create({
                ID: "DynamicForm_Questions_Body_JspEvaluation",
                validateOnExit: true,
                valuesManager: vm_JspEvaluation,
                colWidths: ["45%", "50%"],
                cellBorder: 1,
                width: "100%",
                padding: 10,
                fields: []
            });

            let DynamicForm_Description_JspEvaluation = isc.DynamicForm.create({
                ID: "DynamicForm_Description_JspEvaluation",
                validateOnExit: true,
                valuesManager: vm_JspEvaluation,
                width: "100%",
                fields: [
                    {
                        name: "description",
                        title: "<spring:message code='description'/>",
                        type: 'textArea'
                    }
                ]
            });

            let IButton_Questions_Save = isc.IButtonSave.create({
                click: function () {
                    if (!DynamicForm_Questions_Title_JspEvaluation.validate()) {
                        return;
                    }
                    let evaluationAnswerList = [];
                    let data = {};
                    let evaluationFull = true;
                    let questions = DynamicForm_Questions_Body_JspEvaluation.getFields();
                    for (let i = 0; i < questions.length; i++) {
                        if (DynamicForm_Questions_Body_JspEvaluation.getValue(questions[i].name) === undefined) {
                            evaluationFull = false;
                        }
                        let evaluationAnswer = {};
                        evaluationAnswer.answerID = DynamicForm_Questions_Body_JspEvaluation.getValue(questions[i].name);
                        evaluationAnswer.evaluationQuestionId = questions[i].name.substring(1);
                        evaluationAnswer.questionSourceId = questionSourceConvert(questions[i].name);
                        evaluationAnswerList.push(evaluationAnswer);
                    }
                    data.evaluationAnswerList = evaluationAnswerList;
                    data.evaluationFull = evaluationFull;
                    data.description = DynamicForm_Description_JspEvaluation.getField("description").getValue();
                    switch (DynamicForm_Questions_Title_JspEvaluation.getValue("evaluationType")) {
                        case "SEFT":
                            data.evaluatorId = "<%= SecurityUtil.getUserId()%>";
                            data.evaluatedId = LGRecord.teacherId;
                            data.evaluatorTypeId = 189;
                            data.evaluatedTypeId = 187;
                            data.questionnaireTypeId = 141;
                            break;
                        case "TEFC":
                            data.evaluatorId = LGRecord.teacherId;
                            data.evaluatedId = null;
                            data.evaluatorTypeId = 187;
                            data.evaluatedTypeId = null;
                            data.questionnaireTypeId = 140;
                            break;
                        case "SEFC":
                            data.evaluatorId = studentIdJspEvaluation;
                            data.evaluatedId = null;
                            data.evaluatorTypeId = 188;
                            data.evaluatedTypeId = null;
                            data.evaluationLevelId = evaluationLevelId;
                            data.questionnaireTypeId = 139;
                            break;
                        case "OEFS":
                            data.questionnaireTypeId = 230;
                            data.evaluatorId = eeid;
                            data.evaluatedId = studentIdJspEvaluation;
                            data.evaluationLevelId = evaluationLevelId;
                            break;
                    }
                    data.classId = LGRecord.id;
                    isc.RPCManager.sendRequest(TrDSRequest(saveUrl, saveMethod, JSON.stringify(data), function (resp) {
                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                            Window_Questions_JspEvaluation.close();
                            ListGrid_evaluation_student.invalidateCache();
                            isc.RPCManager.sendRequest(TrDSRequest(evaluationAnalysisUrl + "/updateEvaluationAnalysis" + "/" +
                                LGRecord.id,
                                "GET", null, null));
                            const msg = createDialog("info", "<spring:message code="global.form.request.successful"/>");
                            setTimeout(() => {
                                msg.close();
                        }, 3000);
                        } else {
                            createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                        }
                    }))
                }
            });
            let Window_Questions_JspEvaluation = isc.Window.create({
                width: 1024,
                height: 768,
                keepInParentRect: true,
                title: "<spring:message code="record.evaluation.results"/>",
                items: [
                    DynamicForm_Questions_Title_JspEvaluation,
                    DynamicForm_Questions_Body_JspEvaluation,
                    DynamicForm_Description_JspEvaluation,
                    isc.TrHLayoutButtons.create({
                        members: [
                            IButton_Questions_Save,
                            isc.IButtonCancel.create({
                                click: function () {
                                    Window_Questions_JspEvaluation.close();
                                }
                            })]
                    })
                ],
                minWidth: 1024
            });
        let itemList = [];
        let eeid;
            DynamicForm_Questions_Title_JspEvaluation.clearValues();
            DynamicForm_Description_JspEvaluation.clearValues();
            DynamicForm_Description_JspEvaluation.hide();
        DynamicForm_Questions_Title_JspEvaluation.getItem("evaluationType").clearValue();
        DynamicForm_Questions_Title_JspEvaluation.getItem("evaluator").clearValue();
        DynamicForm_Questions_Title_JspEvaluation.getItem("evaluated").clearValue();
        DynamicForm_Description_JspEvaluation.clearValues();
        DynamicForm_Description_JspEvaluation.show();
        RestData_Students_JspEvaluation.fetchDataURL = tclassStudentUrl + "/students-iscList/" + LGRecord.id;
        evaluationLevelId = 154;
        DynamicForm_Questions_Title_JspEvaluation.getItem("evaluationType").disable();
        DynamicForm_Questions_Title_JspEvaluation.getItem("evaluationLevel").disable();
        studentIdJspEvaluation = StdRecord.id;
        let criteriaEdit = '';

        let criteria = '{"fieldName":"questionnaireType.code","operator":"equals","value":"SEFC"}';
        criteriaEdit += '{"fieldName":"evaluationLevelId","operator":"equals","value":154},'+
            '{"fieldName":"evaluatorId","operator":"equals","value":' + studentIdJspEvaluation + '}' ;

        evalWait = createDialog("wait");
        requestEvaluationQuestions(criteria, criteriaEdit, 1);
        Window_Questions_JspEvaluation.show();

        DynamicForm_Questions_Title_JspEvaluation.getItem("code").setValue(LGRecord.code);
        DynamicForm_Questions_Title_JspEvaluation.getItem("titleClass").setValue(LGRecord.titleClass);
        DynamicForm_Questions_Title_JspEvaluation.getItem("institute.titleFa").setValue(LGRecord.institute.titleFa);
        DynamicForm_Questions_Title_JspEvaluation.getItem("teacher").setValue(LGRecord.teacher);
        DynamicForm_Questions_Title_JspEvaluation.getItem("startDate").setValue(LGRecord.startDate);

        DynamicForm_Questions_Title_JspEvaluation.setValue("evaluated", DynamicForm_Questions_Title_JspEvaluation.getValue("titleClass"));
        DynamicForm_Questions_Title_JspEvaluation.getItem("evaluationType").setValue("SEFC");
        DynamicForm_Questions_Title_JspEvaluation.getItem("evaluationLevel").setValue("Reactive");
        DynamicForm_Questions_Title_JspEvaluation.setValue("evaluator", StdRecord.student.firstName + " " + StdRecord.student.lastName);
            DynamicForm_Questions_Title_JspEvaluation.setValue("user", "<%= SecurityUtil.getFullName()%>");

            function requestEvaluationQuestions(criteria, criteriaEdit, type = 0) {
                isc.RPCManager.sendRequest(TrDSRequest(questionnaireUrl + "/iscList?operator=or&_constructor=AdvancedCriteria&criteria=" + criteria, "GET", null, function (resp) {
                    if (JSON.parse(resp.data).response.data.length > 0) {
                        let criteria = '{"fieldName":"questionnaireId","operator":"equals","value":' + JSON.parse(resp.data).response.data[0].id + '}';
                        isc.RPCManager.sendRequest(TrDSRequest(questionnaireQuestionUrl + "/iscList?operator=or&_constructor=AdvancedCriteria&criteria=" + criteria, "GET", null, function (resp) {
                            localQuestions = JSON.parse(resp.data).response.data;
                            for (let i = 0; i < localQuestions.length; i++) {
                                let item = {};
                                switch (localQuestions[i].evaluationQuestion.domain.code) {
                                    case "EQP":
                                        item.name = "Q" + localQuestions[i].id;
                                        item.title = "امکانات: " + localQuestions[i].evaluationQuestion.question;
                                        break;
                                    case "CLASS":
                                        item.name = "Q" + localQuestions[i].id;
                                        item.title = "کلاس: " + localQuestions[i].evaluationQuestion.question;
                                        break;
                                    case "SAT":
                                        item.name = "Q" + localQuestions[i].id;
                                        item.title = "مدرس: " + localQuestions[i].evaluationQuestion.question;
                                        break;
                                    case "TRAINING":
                                        item.name = "Q" + localQuestions[i].id;
                                        item.title = "مدرس: " + localQuestions[i].evaluationQuestion.question;
                                        break;
                                    case "Content":
                                        item.name = "Q" + localQuestions[i].id;
                                        item.title = "محتواي کلاس: " + localQuestions[i].evaluationQuestion.question;
                                        break;
                                    default:
                                        item.name = "Q" + localQuestions[i].id;
                                        item.title = localQuestions[i].evaluationQuestion.question;
                                }

                                item.type = "radioGroup";
                                item.vertical = false;
                                item.fillHorizontalSpace = true;
                                item.valueMap = valueMapAnswer;
                                item.icons = [
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
                                        }
                                    }
                                ];
                                itemList.add(item);
                            }
                            ;
                            if (type !== 0) {
                                isc.RPCManager.sendRequest(TrDSRequest(courseUrl + "goal-mainObjective/" + LGRecord.course.id, "GET", null, function (resp) {
                                    localQuestions = JSON.parse(resp.data);
                                    for (let i = 0; i < localQuestions.length; i++) {
                                        let item = {};
                                        switch (localQuestions[i].type) {
                                            case "goal":
                                                item.name = "G" + localQuestions[i].id;
                                                item.title = "هدف: " + localQuestions[i].title;
                                                break;
                                            case "skill":
                                                item.name = "M" + localQuestions[i].id;
                                                item.title = "هدف اصلي: " + localQuestions[i].title;
                                                break;
                                        }
                                        item.type = "radioGroup";
                                        item.vertical = false;
                                        item.fillHorizontalSpace = true;
                                        item.valueMap = valueMapAnswer;
                                        item.icons = [
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
                                                }
                                            }
                                        ];
                                        itemList.add(item);
                                    }
                                    DynamicForm_Questions_Body_JspEvaluation.setItems(itemList);
                                    requestEvaluationQuestionsEdit(criteriaEdit);
                                }));
                            } else {
                                DynamicForm_Questions_Body_JspEvaluation.setItems(itemList);
                                requestEvaluationQuestionsEdit(criteriaEdit);
                            }
                        }));
                    } else {
                        if (type !== 0) {
                            isc.RPCManager.sendRequest(TrDSRequest(courseUrl + "goal-mainObjective/" + LGRecord.course.id, "GET", null, function (resp) {
                                localQuestions = JSON.parse(resp.data);
                                for (let i = 0; i < localQuestions.length; i++) {
                                    let item = {};
                                    switch (localQuestions[i].type) {
                                        case "goal":
                                            item.name = "G" + localQuestions[i].id;
                                            item.title = "هدف: " + (i + 1).toString() + "- " + localQuestions[i].title;
                                            break;
                                        case "skill":
                                            item.name = "M" + localQuestions[i].id;
                                            item.title = "هدف اصلي: " + (i + 1).toString() + "- " + localQuestions[i].title;
                                            break;
                                    }
                                    item.type = "radioGroup";
                                    item.vertical = false;
                                    item.fillHorizontalSpace = true;
                                    item.valueMap = valueMapAnswer;
                                    item.icons = [
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
                                            }
                                        }
                                    ];
                                    itemList.add(item);
                                }
                                DynamicForm_Questions_Body_JspEvaluation.setItems(itemList);
                                requestEvaluationQuestionsEdit(criteriaEdit);
                            }));
                        } else {
                            DynamicForm_Questions_Body_JspEvaluation.setItems(itemList);
                            requestEvaluationQuestionsEdit(criteriaEdit);
                        }
                    }
                    evalWait.close();
                }));
            }

            function requestEvaluationQuestionsEdit(criteria) {
                isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/spec-list?operator=and&_constructor=AdvancedCriteria&criteria=" + criteria, "GET", null, function (resp) {
                    if (resp.httpResponseCode == 201 || resp.httpResponseCode == 200) {
                        let data = JSON.parse(resp.data).response.data;
                        let record = {};
                        if (!data.isEmpty()) {
                            let answer = data[0].evaluationAnswerList;
                            let description = data[0].description;
                            for (let i = 0; i < answer.length; i++) {
                                switch (answer[i].questionSourceId) {
                                    case 199:
                                        record["Q" + answer[i].evaluationQuestionId] = answer[i].answerId;
                                        break;
                                    case 200:
                                        record["M" + answer[i].evaluationQuestionId] = answer[i].answerId;
                                        break;
                                    case 201:
                                        record["G" + answer[i].evaluationQuestionId] = answer[i].answerId;
                                        break;
                                }
                            }
                            DynamicForm_Questions_Body_JspEvaluation.setValues(record);
                            DynamicForm_Description_JspEvaluation.getField("description").setValue(description);
                            saveMethod = "PUT";
                            saveUrl = evaluationUrl + "/" + data[0].id;
                            return;
                        }
                        saveMethod = "POST";
                        saveUrl = evaluationUrl;
                    }
                }))
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
        }
    function register_evaluation_result_reaction(eType){
        let LGRecord = ListGrid_evaluation_class.getSelectedRecord();
        let teacherIdJspEvaluation = LGRecord.teacherId;
        let evaluationLevelId;
        let saveMethod;
        let saveUrl = evaluationUrl;
        let valueMapAnswer = {209: "خیلی ضعیف", 208: "ضعیف", 207: "متوسط", 206: "خوب", 205: "عالی"};
        let RestData_EvaluationType_JspEvaluation = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true, hidden: true},
                {
                    name: "title",
                    title: "<spring:message code="title"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "code",
                    title: "<spring:message code="code"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "type",
                    title: "<spring:message code="type"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "value",
                    title: "<spring:message code="value"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "description",
                    title: "<spring:message code="description"/>",
                    filterOperator: "iContains"
                }
            ],
            fetchDataURL: parameterValueUrl + "/iscList/143"
        });
        let RestData_EvaluationLevel_JspEvaluation = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true, hidden: true},
                {
                    name: "title",
                    title: "<spring:message code="title"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "code",
                    title: "<spring:message code="code"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "type",
                    title: "<spring:message code="type"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "value",
                    title: "<spring:message code="value"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "description",
                    title: "<spring:message code="description"/>",
                    filterOperator: "iContains"
                }
            ],
            fetchDataURL: parameterValueUrl + "/iscList/163"
        });


        let DynamicForm_Questions_Title_JspEvaluation = isc.DynamicForm.create({
            ID: "DynamicForm_Questions_Title_JspEvaluation",
            validateOnChange: true,
            numCols: 6,
            width: "100%",
            borderRadius: "10px 10px 0px 0px",
            border: "2px solid black",
            titleAlign: "left",
            margin: 10,
            padding: 10,
            fields: [
                {name: "code", title: "<spring:message code="class.code"/>:", canEdit: false},
                {
                    name: "titleClass",
                    title: "<spring:message code='class.title'/>:",
                    canEdit: false
                },
                {
                    name: "startDate",
                    title: "<spring:message code='start.date'/>:",
                    canEdit: false
                },
                {name: "teacher", title: "<spring:message code='teacher'/>:", canEdit: false},
                {
                    name: "institute.titleFa",
                    title: "<spring:message code='institute'/>:",
                    canEdit: false
                },
                {name: "user", title: "<spring:message code='user'/>:", canEdit: false},
                {
                    name: "evaluationLevel",
                    title: "<spring:message code="evaluation.level"/>",
                    type: "SelectItem",
                    pickListProperties: {showFilterEditor: false},
                    optionDataSource: RestData_EvaluationLevel_JspEvaluation,
                    valueField: "code",
                    displayField: "title",
                    disabled:true
                },
                {
                    name: "evaluationType",
                    title: "<spring:message code="evaluation.type"/>",
                    type: "SelectItem",
                    optionDataSource: RestData_EvaluationType_JspEvaluation,
                    pickListProperties: {showFilterEditor: false},
                    valueField: "code",
                    required: true,
                    disabled: true,
                    displayField: "title",
                    endRow: true
                },
                {
                    name: "evaluator",
                    title: "<spring:message code="evaluator"/>",
                    required: true,
                    disabled: true
                },
                {
                    name: "evaluated",
                    title: "<spring:message code="evaluation.evaluated"/>",
                    required: true,
                    disabled: true
                }
            ]
        });
        let DynamicForm_Questions_Body_JspEvaluation = isc.DynamicForm.create({
            ID: "DynamicForm_Questions_Body_JspEvaluation",
            validateOnExit: true,
            colWidths: ["45%", "50%"],
            cellBorder: 1,
            width: "100%",
            padding: 10,
            fields: []
        });

        let DynamicForm_Description_JspEvaluation = isc.DynamicForm.create({
            ID: "DynamicForm_Description_JspEvaluation",
            validateOnExit: true,
            width: "100%",
            fields: [
                {
                    name: "description",
                    title: "<spring:message code='description'/>",
                    type: 'textArea'
                }
            ]
        });

        let IButton_Questions_Save = isc.IButtonSave.create({
            click: function () {
                if (!DynamicForm_Questions_Title_JspEvaluation.validate()) {
                    return;
                }
                let evaluationAnswerList = [];
                let data = {};
                let evaluationFull = true;
                let questions = DynamicForm_Questions_Body_JspEvaluation.getFields();
                for (let i = 0; i < questions.length; i++) {
                    if (DynamicForm_Questions_Body_JspEvaluation.getValue(questions[i].name) === undefined) {
                        evaluationFull = false;
                    }
                    let evaluationAnswer = {};
                    evaluationAnswer.answerID = DynamicForm_Questions_Body_JspEvaluation.getValue(questions[i].name);
                    evaluationAnswer.evaluationQuestionId = questions[i].name.substring(1);
                    evaluationAnswer.questionSourceId = questionSourceConvert(questions[i].name);
                    evaluationAnswerList.push(evaluationAnswer);
                }
                data.evaluationAnswerList = evaluationAnswerList;
                data.evaluationFull = evaluationFull;
                data.description = DynamicForm_Description_JspEvaluation.getField("description").getValue();
                switch (DynamicForm_Questions_Title_JspEvaluation.getValue("evaluationType")) {
                    case "SEFT":
                        data.evaluatorId = "<%= SecurityUtil.getUserId()%>";
                        data.evaluatedId = LGRecord.teacherId;
                        data.evaluatorTypeId = 189;
                        data.evaluatedTypeId = 187;
                        data.questionnaireTypeId = 141;
                        break;
                    case "TEFC":
                        data.evaluatorId = LGRecord.teacherId;
                        data.evaluatedId = null;
                        data.evaluatorTypeId = 187;
                        data.evaluatedTypeId = null;
                        data.questionnaireTypeId = 140;
                        break;
                    case "SEFC":
                        data.evaluatorId = studentIdJspEvaluation;
                        data.evaluatedId = null;
                        data.evaluatorTypeId = 188;
                        data.evaluatedTypeId = null;
                        data.evaluationLevelId = evaluationLevelId;
                        data.questionnaireTypeId = 139;
                        break;
                }
                data.classId = LGRecord.id;
                isc.RPCManager.sendRequest(TrDSRequest(saveUrl, saveMethod, JSON.stringify(data), function (resp) {
                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                        Window_Questions_JspEvaluation.close();
                        ListGrid_evaluation_student.invalidateCache();
                        isc.RPCManager.sendRequest(TrDSRequest(evaluationAnalysisUrl + "/updateEvaluationAnalysis" + "/" +
                            LGRecord.id,
                            "GET", null, null));
                        const msg = createDialog("info", "<spring:message code="global.form.request.successful"/>");
                        setTimeout(() => {
                            msg.close();
                    }, 3000);
                    } else {
                        createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                    }
                }))
            }
        });

        let Window_Questions_JspEvaluation = isc.Window.create({
            width: 1024,
            height: 768,
            keepInParentRect: true,
            title: "<spring:message code="record.evaluation.results"/>",
            items: [
                DynamicForm_Questions_Title_JspEvaluation,
                DynamicForm_Questions_Body_JspEvaluation,
                DynamicForm_Description_JspEvaluation,
                isc.TrHLayoutButtons.create({
                    members: [
                        IButton_Questions_Save,
                        isc.IButtonCancel.create({
                            click: function () {
                                Window_Questions_JspEvaluation.close();
                            }
                        })]
                })
            ],
            minWidth: 1024
        });

        DynamicForm_Questions_Title_JspEvaluation.clearValues();
        DynamicForm_Description_JspEvaluation.clearValues();
        DynamicForm_Questions_Body_JspEvaluation.clearValues();
        DynamicForm_Questions_Body_JspEvaluation.setFields([]);
        let criteria = '{"fieldName":"questionnaireType.code","operator":"equals","value":""}';
        let criteriaEdit =
            '{"fieldName":"classId","operator":"equals","value":' + LGRecord.id + '},';

        switch (eType) {
            case 1:
                criteria = '{"fieldName":"questionnaireType.code","operator":"equals","value":"SEFT"}';
                criteriaEdit +=
                    '{"fieldName":"questionnaireTypeId","operator":"equals","value":141},' +
                    '{"fieldName":"evaluatorId","operator":"equals","value":<%= SecurityUtil.getUserId()%>},' +
                    '{"fieldName":"evaluatorTypeId","operator":"equals","value":189},' +
                    '{"fieldName":"evaluatedId","operator":"equals","value":' + teacherIdJspEvaluation + '},' +
                    '{"fieldName":"evaluatedTypeId","operator":"equals","value":187}';
                DynamicForm_Questions_Title_JspEvaluation.setValue("evaluator", "<%= SecurityUtil.getFullName()%>");
                DynamicForm_Questions_Title_JspEvaluation.setValue("evaluated", LGRecord.teacher);
                DynamicForm_Questions_Title_JspEvaluation.setValue("evaluationLevel", "Reactive");
                DynamicForm_Questions_Title_JspEvaluation.setValue("evaluationType", "SEFT");
                break;
            case 0:
                DynamicForm_Description_JspEvaluation.show();
                criteria = '{"fieldName":"questionnaireType.code","operator":"equals","value":"TEFC"}';
                criteriaEdit +=
                    '{"fieldName":"questionnaireTypeId","operator":"equals","value":140},' +
                    '{"fieldName":"evaluatorId","operator":"equals","value":' + teacherIdJspEvaluation + '},' +
                    '{"fieldName":"evaluatorTypeId","operator":"equals","value":187}';
                DynamicForm_Questions_Title_JspEvaluation.setValue("evaluator", LGRecord.teacher);
                DynamicForm_Questions_Title_JspEvaluation.setValue("evaluated", LGRecord.titleClass);
                DynamicForm_Questions_Title_JspEvaluation.setValue("evaluationLevel", "Reactive");
                DynamicForm_Questions_Title_JspEvaluation.setValue("evaluationType", "TEFC");
                break;
        }
        requestEvaluationQuestions(criteria, criteriaEdit);

        let itemList = [];
        let eeid;

        evalWait = createDialog("wait");
        Window_Questions_JspEvaluation.show();
        DynamicForm_Questions_Title_JspEvaluation.getItem("code").setValue(LGRecord.code);
        DynamicForm_Questions_Title_JspEvaluation.getItem("titleClass").setValue(LGRecord.titleClass);
        DynamicForm_Questions_Title_JspEvaluation.getItem("institute.titleFa").setValue(LGRecord.institute.titleFa);
        DynamicForm_Questions_Title_JspEvaluation.getItem("teacher").setValue(LGRecord.teacher);
        DynamicForm_Questions_Title_JspEvaluation.getItem("startDate").setValue(LGRecord.startDate);
        DynamicForm_Questions_Title_JspEvaluation.setValue("user", "<%= SecurityUtil.getFullName()%>");

        function requestEvaluationQuestions(criteria, criteriaEdit, type = 0) {
            isc.RPCManager.sendRequest(TrDSRequest(questionnaireUrl + "/iscList?operator=or&_constructor=AdvancedCriteria&criteria=" + criteria, "GET", null, function (resp) {
                if (JSON.parse(resp.data).response.data.length > 0) {
                    let criteria = '{"fieldName":"questionnaireId","operator":"equals","value":' + JSON.parse(resp.data).response.data[0].id + '}';
                    isc.RPCManager.sendRequest(TrDSRequest(questionnaireQuestionUrl + "/iscList?operator=or&_constructor=AdvancedCriteria&criteria=" + criteria, "GET", null, function (resp) {
                        localQuestions = JSON.parse(resp.data).response.data;
                        for (let i = 0; i < localQuestions.length; i++) {
                            let item = {};
                            switch (localQuestions[i].evaluationQuestion.domain.code) {
                                case "EQP":
                                    item.name = "Q" + localQuestions[i].id;
                                    item.title = "امکانات: " + localQuestions[i].evaluationQuestion.question;
                                    break;
                                case "CLASS":
                                    item.name = "Q" + localQuestions[i].id;
                                    item.title = "کلاس: " + localQuestions[i].evaluationQuestion.question;
                                    break;
                                case "SAT":
                                    item.name = "Q" + localQuestions[i].id;
                                    item.title = "مدرس: " + localQuestions[i].evaluationQuestion.question;
                                    break;
                                case "TRAINING":
                                    item.name = "Q" + localQuestions[i].id;
                                    item.title = "مدرس: " + localQuestions[i].evaluationQuestion.question;
                                    break;
                                case "Content":
                                    item.name = "Q" + localQuestions[i].id;
                                    item.title = "محتواي کلاس: " + localQuestions[i].evaluationQuestion.question;
                                    break;
                                default:
                                    item.name = "Q" + localQuestions[i].id;
                                    item.title = localQuestions[i].evaluationQuestion.question;
                            }

                            item.type = "radioGroup";
                            item.vertical = false;
                            // item.required = true;
                            item.fillHorizontalSpace = true;
                            item.valueMap = valueMapAnswer;
                            // item.colSpan = ,
                            item.icons = [
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
                                    }
                                }
                            ];
                            itemList.add(item);
                        }
                        ;
                        if (type !== 0) {
                            isc.RPCManager.sendRequest(TrDSRequest(courseUrl + "goal-mainObjective/" + LGRecord.course.id, "GET", null, function (resp) {
                                localQuestions = JSON.parse(resp.data);
                                for (let i = 0; i < localQuestions.length; i++) {
                                    let item = {};
                                    switch (localQuestions[i].type) {
                                        case "goal":
                                            item.name = "G" + localQuestions[i].id;
                                            item.title = "هدف: " + localQuestions[i].title;
                                            break;
                                        case "skill":
                                            item.name = "M" + localQuestions[i].id;
                                            item.title = "هدف اصلي: " + localQuestions[i].title;
                                            break;
                                        // default:
                                        //     return;
                                    }
                                    item.type = "radioGroup";
                                    item.vertical = false;
                                    // item.required = true;
                                    item.fillHorizontalSpace = true;
                                    item.valueMap = valueMapAnswer;
                                    // item.colSpan = ,
                                    item.icons = [
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
                                            }
                                        }
                                    ];
                                    itemList.add(item);
                                }
                                DynamicForm_Questions_Body_JspEvaluation.setItems(itemList);
                                requestEvaluationQuestionsEdit(criteriaEdit);
                            }));
                        } else {
                            DynamicForm_Questions_Body_JspEvaluation.setItems(itemList);
                            requestEvaluationQuestionsEdit(criteriaEdit);
                        }
                    }));
                } else {
                    if (type !== 0) {
                        isc.RPCManager.sendRequest(TrDSRequest(courseUrl + "goal-mainObjective/" + LGRecord.course.id, "GET", null, function (resp) {
                            localQuestions = JSON.parse(resp.data);
                            for (let i = 0; i < localQuestions.length; i++) {
                                let item = {};
                                switch (localQuestions[i].type) {
                                    case "goal":
                                        item.name = "G" + localQuestions[i].id;
                                        item.title = "هدف: " + (i + 1).toString() + "- " + localQuestions[i].title;
                                        break;
                                    case "skill":
                                        item.name = "M" + localQuestions[i].id;
                                        item.title = "هدف اصلي: " + (i + 1).toString() + "- " + localQuestions[i].title;
                                        break;
                                    // default:
                                    //     return;
                                }
                                item.type = "radioGroup";
                                item.vertical = false;
                                // item.required = true;
                                item.fillHorizontalSpace = true;
                                item.valueMap = valueMapAnswer;
                                // item.colSpan = ,
                                item.icons = [
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
                                        }
                                    }
                                ];
                                itemList.add(item);
                            }
                            DynamicForm_Questions_Body_JspEvaluation.setItems(itemList);
                            requestEvaluationQuestionsEdit(criteriaEdit);
                        }));
                    } else {
                        DynamicForm_Questions_Body_JspEvaluation.setItems(itemList);
                        requestEvaluationQuestionsEdit(criteriaEdit);
                    }
                }
                evalWait.close();
            }));

        }

        function requestEvaluationQuestionsEdit(criteria) {
            isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/spec-list?operator=and&_constructor=AdvancedCriteria&criteria=" + criteria, "GET", null, function (resp) {
                if (resp.httpResponseCode == 201 || resp.httpResponseCode == 200) {
                    let data = JSON.parse(resp.data).response.data;
                    let record = {};
                    if (!data.isEmpty()) {
                        let answer = data[0].evaluationAnswerList;
                        let description = data[0].description;
                        for (let i = 0; i < answer.length; i++) {
                            switch (answer[i].questionSourceId) {
                                case 199:
                                    record["Q" + answer[i].evaluationQuestionId] = answer[i].answerId;
                                    break;
                                case 200:
                                    record["M" + answer[i].evaluationQuestionId] = answer[i].answerId;
                                    break;
                                case 201:
                                    record["G" + answer[i].evaluationQuestionId] = answer[i].answerId;
                                    break;
                            }
                        }
                        DynamicForm_Questions_Body_JspEvaluation.setValues(record);
                        DynamicForm_Description_JspEvaluation.getField("description").setValue(description);
                        saveMethod = "PUT";
                        saveUrl = evaluationUrl + "/" + data[0].id;
                        return;
                    }
                    saveMethod = "POST";
                    saveUrl = evaluationUrl;
                }
            }))
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
}

    function register_evaluation_result_behavioral_student(StdRecord){
        let LGRecord = ListGrid_evaluation_class.getSelectedRecord();
        var RestDataSource_BehavioralRegisteration_JSPEvaluation = isc.TrDS.create({
            fields: [
                {name: "evaluatorTypeId"},
                {name: "evaluatorName"},
                {name: "status"},
                {name: "id"}
            ],
            fetchDataURL : evaluationUrl + "/getBehavioralForms/" + StdRecord.id + "/" + LGRecord.id
        });
        let Listgrid_BehavioralRegisteration_JSPEvaluation = isc.TrLG.create({
            width: "100%",
            height: "100%",
            dataSource: RestDataSource_BehavioralRegisteration_JSPEvaluation,
            sortField: 0,
            sortDirection: "Descending",
            showRecordComponents: true,
            showRecordComponentsByCell: true,
            fields: [
                {
                    //roya
                    name: "evaluatorTypeId",
                    title: "نوع مخاطب",
                    width: "45%",
                    type: "SelectItem",
                    optionDataSource: AudienceTypeDS,
                    filterEditorProperties:{
                        pickListProperties: {
                            showFilterEditor: false
                        }
                    },
                    canFilter: false,
                    valueField: "id",
                    displayField: "title"
                },
                {
                    name: "evaluatorName",
                    title: "نام مخاطب",
                    canFilter: false,
                    width: "45%"
                },
                {name: "status", hidden: true},
                {name: "id", hidden: true},
                {name: "editForm",title: " ", align: "center",canSort:false,canFilter:false, width: "10%"},
                {name: "removeForm",title: " ", align: "center",canSort:false,canFilter:false, width: "10%"},
                {name: "printForm",title: " ", align: "center",canSort:false,canFilter:false, width: "10%"}
            ],
            createRecordComponent: function (record, colNum) {
                var fieldName = this.getFieldName(colNum);
                if (fieldName == "editForm") {
                    let recordCanvas = isc.HLayout.create({
                        height: "100%",
                        width: "100%",
                        layoutMargin: 5,
                        membersMargin: 10,
                        align: "center"
                    });
                    let addIcon = isc.ImgButton.create({
                        showDown: false,
                        showRollOver: false,
                        layoutAlign: "center",
                        src: "[SKIN]/actions/edit.png",
                        prompt: "ویرایش فرم",
                        height: 16,
                        width: 16,
                        grid: this,
                        click: function () {
                        }
                    });
                    recordCanvas.addMember(addIcon);
                    return recordCanvas;
                }
                else if (fieldName == "removeForm") {
                    let recordCanvas = isc.HLayout.create({
                        height: "100%",
                        width: "100%",
                        layoutMargin: 5,
                        membersMargin: 10,
                        align: "center"
                    });
                    let addIcon = isc.ImgButton.create({
                        showDown: false,
                        showRollOver: false,
                        layoutAlign: "center",
                        src: "[SKIN]/actions/remove.png",
                        prompt: "حذف فرم",
                        height: 16,
                        width: 16,
                        grid: this,
                        click: function () {
                            isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/" + record.id , "DELETE", null, function (resp) {
                                Listgrid_BehavioralRegisteration_JSPEvaluation.invalidateCache();
                            }));
                        }
                    });
                    recordCanvas.addMember(addIcon);
                    return recordCanvas;
                }
                else if (fieldName == "printForm") {
                    let recordCanvas = isc.HLayout.create({
                        height: "100%",
                        width: "100%",
                        layoutMargin: 5,
                        membersMargin: 10,
                        align: "center"
                    });
                    let addIcon = isc.ImgButton.create({
                        showDown: false,
                        showRollOver: false,
                        layoutAlign: "center",
                        src: "[SKIN]/actions/print.png",
                        prompt: "چاپ فرم",
                        height: 16,
                        width: 16,
                        grid: this,
                        click: function () {
                            print_Student_FormIssuance("pdf","single",StdRecord,record.evaluatorName, record.evaluatorTypeId);
                            console.log(record.evaluatorTypeId)
                        }
                    });
                    recordCanvas.addMember(addIcon);
                    return recordCanvas;
                }else
                    return null;
            },
            cellHeight: 43,
            filterOperator: "iContains",
            filterOnKeypress: false,
            allowAdvancedCriteria: true,
            allowFilterExpressions: true,
            selectionType: "single",
            autoFetchData: true,
            filterUsingText: "<spring:message code='filterUsingText'/>",
            groupByText: "<spring:message code='groupByText'/>",
            freezeFieldText: "<spring:message code='freezeFieldText'/>"
        });
        let Window_BehavioralRegisteration_JSPEvaluation = isc.Window.create({
            placement: "fillScreen",
            title: "لیست فرم های صادر شده",
            canDragReposition: true,
            align: "center",
            autoDraw: true,
            border: "1px solid gray",
            items: [isc.TrVLayout.create({
                members: [
                    Listgrid_BehavioralRegisteration_JSPEvaluation
                ]
            })]
        });
        Window_BehavioralRegisteration_JSPEvaluation.show();
    }
