<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page import="com.nicico.copper.core.SecurityUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>
var dummy;
// <script>
    var localQuestions;
    // <<========== Global - Variables ==========
    {
        var evaluation_method = "POST";
    }
    // ============ Global - Variables ========>>

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

        EvaluationDS_PersonList = isc.TrDS.create({
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
            fetchDataURL: personnelUrl + "/iscList",
        });

        evaluation_Audience_Type = isc.FormLayout.create({
            items:[{
                name:"audiencePost", type:"radioGroup", title:"نوع مخاطب : ",
                valueMap:["نماینده آموزش","همکار","مافوق"], defaultValue:null,
                vertical:false,
            }],
        });

        EvaluationListGrid_PeronalLIst = isc.TrLG.create({
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

        var evaluation_Audience = null;
        var ealuation_numberOfStudents = null;
        evaluation_Audience_Type.setValues(null);
        var Buttons_List_HLayout = isc.HLayout.create({
            width: "100%",
            height: "30px",
            autoDraw: false,
            padding: "5px",
            align: "center",
            membersMargin: 5,
            members: [
                isc.IButton.create({
                    title: "<spring:message code="select" />",
                    click: function () {
                        if (EvaluationListGrid_PeronalLIst.getSelectedRecord() !== null && (evaluation_Audience_Type.values.audiencePost !== null && evaluation_Audience_Type.values.audiencePost !== undefined)) {
                            evaluation_Audience = EvaluationListGrid_PeronalLIst.getSelectedRecord().firstName + " " + EvaluationListGrid_PeronalLIst.getSelectedRecord().lastName;
                            print_Student_FormIssuance("pdf", ealuation_numberOfStudents);
                            EvaluationWin_PersonList.close();
                        } else if(evaluation_Audience_Type.values.audiencePost === null || evaluation_Audience_Type.values.audiencePost === undefined){
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

        EvaluationWin_PersonList = isc.Window.create({
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
    }
    // ---------------------------------------- Create - Window ---------------------------------->>

    // <<-------------------------------------- Create - contextMenu ------------------------------------------
    {
        var Menu_ListGrid_evaluation_class = isc.Menu.create({
            data: [
                <sec:authorize access="hasAuthority('Evaluation_C')">
                {
                    title: "<spring:message code="record.evaluation.results"/>",
                    click: function () {
                        register_evaluation_result(ListGrid_evaluation_class.getSelectedRecord());
                    }
                },
                </sec:authorize>

                <sec:authorize access="hasAuthority('Evaluation_R')">
                {
                    title: "<spring:message code="refresh"/>",
                    click: function () {
                        ListGrid_evaluation_class.invalidateCache();
                    }
                }
                </sec:authorize>
            ]
        })
    }

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

        var PersonnelInfomationDS_evaluation_class = isc.TrDS.create({
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
                    name: "mobile",
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
                    name: "fullName",
                    hidden:true
                }
            ],
            fetchDataURL: personnelUrl + "/iscList"
        });

        var PersonnelInClassDS_evaluation_class = isc.TrDS.create({
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
                    name: "student.mobile",
                    title: "<spring:message code="mobile"/>",
                    filterOperator: "iContains",
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
                    name: "fullName",
                    hidden:true
                }

            ],
            //fetchDataURL: personnelUrl + "/iscList"
        });

        var TeacherInClassDS_evaluation_class = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true, hidden: true},
                {name: "personality.id"},
                {name: "teacherCode"},
                {name: "personnelCode"},
                {name: "personality.firstNameFa"},
                {name: "personality.lastNameFa"},
                {name: "personality.contactInfo.mobile"},
                {name: "personality.fullName"},
                {name: "fullName"},
            ],
            fetchDataURL: teacherUrl + "spec-list-grid",
            //implicitCriteria:{operator:"and", _constructor:"AdvancedCriteria",criteria:{"fieldName":"tclass.id","operator":"equals","value":ListGrid_evaluation_class.getSelectedRecord().id}}
        });

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

        var ListGrid_evaluation_class = isc.TrLG.create({
            width: "100%",
            height: "100%",
            <sec:authorize access="hasAuthority('Evaluation_R')">
            dataSource: RestDataSource_evaluation_class,
            </sec:authorize>
            contextMenu: Menu_ListGrid_evaluation_class,
            canAddFormulaFields: false,
            autoFetchData: true,
            showFilterEditor: true,
            allowAdvancedCriteria: true,
            allowFilterExpressions: true,
            filterOnKeypress: true,
            showRecordComponents: true,
            showRecordComponentsByCell: true,
            //sortField: 0,
            initialSort: [
// {property: "createdBy", direction: "ascending"},
//                 {property: "hasWarning", direction: "descending", primarySort: true},
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
                    }
                },
                {
                    name: "endDate",
                    title: "<spring:message code='end.date'/>",
                    align: "center",
                    filterOperator: "iContains",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9/]"
                    }
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
                    }
                },
                {
                    name: "classStatus", title: "<spring:message code='class.status'/>", align: "center",
                    filterEditorProperties:{
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
                    filterOperator: "iContains"
                },
                {name: "hasWarning", title: " ", width: 40, type: "image", imageURLPrefix: "", imageURLSuffix: ".gif"},
                {name: "scoringMethod", hidden: true},
                {name: "saveResults", title: " ", align: "center", canSort: false, canFilter: false},
                {name: "preCourseTest", hidden: true}
            ],

            createRecordComponent: function (record, colNum) {
                var fieldName = this.getFieldName(colNum);
                if (fieldName == "saveResults") {
                    var button = isc.IButton.create({
                        layoutAlign: "center",
                        title: "ثبت نتایج ارزیابی",
                        click: function () {
                            register_evaluation_result(record);
                        }
                    });
                    return button;
                } else {
                    return null;
                }
            },
            selectionUpdated: function () {
                var classRecord = ListGrid_evaluation_class.getSelectedRecord();
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
                    name: "evaluationAudienceType",
                    title: "<spring:message code="evaluation.audience.type"/>",
                    filterOperator: "iContains"
                }
            ],
        });


        var ListGrid_evaluation_student = isc.TrLG.create({
            width: "100%",
            height: "100%",
            dataSource: RestDataSource_evaluation_student,
            selectionType: "single",
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
                {name: "student.postTitle"},
                {name: "student.ccpArea"},
                {
                    name: "evaluationStatusReaction",
                    valueMap: {
                        "0": "صادر نشده",
                        "1": "صادر شده",
                        "2": "تکمیل شده"
                    },
                    filterEditorProperties:{
                        pickListProperties: {
                            showFilterEditor: false
                        },
                    },
                    filterOnKeypress:true,
                },
                {
                    name: "evaluationStatusLearning",
                    valueMap: {
                        "0": "صادر نشده",
                        "1": "صادر شده",
                        "2": "تکمیل شده"
                    },
                    hidden: true,
                    filterEditorProperties:{
                        pickListProperties: {
                            showFilterEditor: false
                        },
                    },
                    filterOnKeypress:true,
                },
                {
                    name: "evaluationStatusBehavior",
                    valueMap: {
                        "0": "صادر نشده",
                        "1": "صادر شده",
                        "2": "تکمیل شده"
                    },
                    hidden: true,
                    filterEditorProperties:{
                        pickListProperties: {
                            showFilterEditor: false
                        },
                    },
                    filterOnKeypress:true,
                },
                {
                    name: "evaluationStatusResults",
                    valueMap: {
                        "0": "صادر نشده",
                        "1": "صادر شده",
                        "2": "تکمیل شده"
                    },
                    hidden: true,
                    filterEditorProperties:{
                        pickListProperties: {
                            showFilterEditor: false
                        },
                    },
                    filterOnKeypress:true,
                },
                {name: "evaluationAudienceType",},
            ],
            getCellCSSText: function (record, rowNum, colNum) {
                if ((!ListGrid_evaluation_student.getFieldByName("evaluationStatusReaction").hidden && record.evaluationStatusReaction === 1)
                    || (!ListGrid_evaluation_student.getFieldByName("evaluationStatusLearning").hidden && record.evaluationStatusLearning === 1)
                    || (!ListGrid_evaluation_student.getFieldByName("evaluationStatusBehavior").hidden && record.evaluationStatusBehavior === 1)
                    || (!ListGrid_evaluation_student.getFieldByName("evaluationStatusResults").hidden && record.evaluationStatusResults === 1))
                    return "background-color : #d8e4bc";

                if ((!ListGrid_evaluation_student.getFieldByName("evaluationStatusReaction").hidden && record.evaluationStatusReaction === 2)
                    || (!ListGrid_evaluation_student.getFieldByName("evaluationStatusLearning").hidden && record.evaluationStatusLearning === 2)
                    || (!ListGrid_evaluation_student.getFieldByName("evaluationStatusBehavior").hidden && record.evaluationStatusBehavior === 2)
                    || (!ListGrid_evaluation_student.getFieldByName("evaluationStatusResults").hidden && record.evaluationStatusResults === 2))
                    return "background-color : #b7dee8";

            }
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
                        ToolStripButton_Refresh,
                    ]
                })
                </sec:authorize>

            ]
        });

        //*****evaluation toolStrip*****
        var ToolStripButton_FormIssuance = isc.ToolStripButton.create({
            title: "<spring:message code="student.form.issuance"/>",
            click: function () {
                set_print_Status("single");
            }
        });

        var ToolStripButton_FormIssuanceForAll = isc.ToolStripButton.create({
            title: "<spring:message code="students.form.issuance"/>",
            click: function () {
                set_print_Status("all");
            }
        });


        var ToolStripButton_SendMessageWithMobile = isc.ToolStripButton.create({
            title: "ارسال پیامک",
            click: function () {
                DynamicForm_SendMessage_jspEvaluation.getItem("message").setValue("");
                DynamicForm_selectPersonnel_jspEvaluation.getItem("personnelInClass").setValue([]);
                DynamicForm_selectPersonnel_jspEvaluation.getItem("teacherInClass").setValue([]);
                DynamicForm_selectPersonnel_jspEvaluation.getItem("topPersonnelInClass").setValue([]);
                DynamicForm_selectPersonnel_jspEvaluation.getItem("coWorkerInClass").setValue([]);

                PersonnelInClassDS_evaluation_class.fetchDataURL = tclassStudentUrl + "/students-iscList/" + ListGrid_evaluation_class.getSelectedRecord().id;
                DynamicForm_selectPersonnel_jspEvaluation.getItem("personnelInClass").comboBox.invalidateDisplayValueCache();
                DynamicForm_selectPersonnel_jspEvaluation.getItem("personnelInClass").comboBox.fetchData();

                TeacherInClassDS_evaluation_class.implicitCriteria={operator:"and", _constructor:"AdvancedCriteria",criteria:[{"fieldName":"tclasse.id","operator":"equals","value":ListGrid_evaluation_class.getSelectedRecord().id}]};
                DynamicForm_selectPersonnel_jspEvaluation.getItem("teacherInClass").comboBox.invalidateDisplayValueCache();
                DynamicForm_selectPersonnel_jspEvaluation.getItem("teacherInClass").comboBox.fetchData();

                Window_Evaluation_SendMessage.show();
            }
        });

        var ToolStripButton_RefreshIssuance = isc.ToolStripButtonRefresh.create({
            title: "<spring:message code="refresh"/>",
            click: function () {
                ListGrid_evaluation_student.invalidateCache();
            }
        });


        var ToolStrip_evaluation = isc.ToolStrip.create({
            width: "100%",
            membersMargin: 5,
            members: [

                <sec:authorize access="hasAuthority('Evaluation_PrintPreTest')">
                ToolStripButton_FormIssuance,
                ToolStripButton_FormIssuanceForAll,
                </sec:authorize>
                ToolStripButton_SendMessageWithMobile,

                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_RefreshIssuance
                    ]
                })
            ]
        });
    }
    // ---------------------------------------- Create - ToolStripButton ------------------------------------>>

    // <<-------------------------------------- Create - DynamicForm & Window ---------------------------------
    {
//*****create fields*****
        var DynamicForm_OperationalUnit = isc.DynamicForm.create({
            fields:
                [
                    {
                        name: "unitCode",
                        title: "<spring:message code="unitCode"/>",
                        type: "text",
                        required: true,
                        length: 10
                    },
                    {
                        name: "operationalUnit",
                        title: "<spring:message code="unitName"/>",
                        type: "text",
                        required: true,
                        length: 100
                    }
                ]
        });

//*****create buttons*****
        var create_Buttons = isc.MyHLayoutButtons.create({
            members:
                [
                    isc.IButtonSave.create
                    ({
                        title: "<spring:message code="save"/> ",
                        click: function () {
                            if (evaluation_method === "POST") {
                                save_OperationalUnit();
                            } else {
                                edit_OperationalUnit();
                            }
                        }
                    }),
                    isc.IButtonCancel.create
                    ({
                        title: "<spring:message code="cancel"/>",
                        click: function () {
                            Window_OperationalUnit.close();
                        }
                    })

                ]
        });

//*****create insert/update window*****
        var Window_OperationalUnit = isc.Window.create({
            title: "<spring:message code="operational.unit"/> ",
            width: "40%",
            minWidth: 500,
            visibility: "hidden",
            items:
                [
                    DynamicForm_OperationalUnit, create_Buttons
                ]
        });


        var DynamicForm_SendMessage_jspEvaluation = isc.DynamicForm.create({
            align: "right",
            titleWidth: 0,
            titleAlign: "center",
            /*showInlineErrors: true,
            showErrorText: false,*/
            //overflow:"none",
            height: "*",
            width:"100%",
            numCols: 2,
            colWidths: ["6%", "94%"],
            fields: [
                {
                    name: "message",
                    title: "متن پیام",
                    type: "TextAreaItem",
                    colSpan: 3,
                    rowSpan: 4,
                    height: "*",
                    width: "100%",
                    length: 300,
                }
            ]
        })

        var DynamicForm_selectPersonnel_jspEvaluation = isc.DynamicForm.create({
            align: "center",
            titleWidth: 0,
            titleAlign: "center",
            //height: 400,
            height: "*",
            width:920,
            top:0,
            left:0,
            padding:0,
            margin:0,
            //overflow:"scroll",
            numCols: 8,
            colWidths: ["5%", "20%","5%", "20%","5%", "20%","5%", "20%"],
            fields: [
                {
                    padding:10,
                    vAlign: "top",
                    titleVAlign: "top",
                    name: "personnelInClass",
                    align: "right",
                    title: "فراگیران",
                    editorType: "MultiComboBoxItem",
                    multiple: true,
                    defaultValue: null,
                    changeOnKeypress: true,
                    showHintInField: true,
                    displayField: "fullName",
                    comboBoxWidth: 700,
                    valueField: "id",
                    layoutStyle: "vertical",
                    optionDataSource: PersonnelInClassDS_evaluation_class,
                    comboBoxProperties: {
                        pickListWidth: 700,
                        pickListFields: [
                            {name: "id", primaryKey: true, hidden: true},
                            {
                                name: "student.firstName",
                                title: "<spring:message code="firstName"/>",
                                filterOperator: "iContains",
                                //autoFitWidth: true
                            },
                            {
                                name: "student.lastName",
                                title: "<spring:message code="lastName"/>",
                                filterOperator: "iContains",
                                //autoFitWidth: true
                            },
                            {
                                name: "student.nationalCode",
                                title: "<spring:message code="national.code"/>",
                                filterOperator: "iContains",
                                //autoFitWidth: true
                            },
                            {
                                name: "student.mobile",
                                title: "<spring:message code="mobile"/>",
                                filterOperator: "iContains",
                                //width: "*"
                            },
                            {
                                name: "student.companyName",
                                title: "<spring:message code="company.name"/>",
                                filterOperator: "iContains",
                                //autoFitWidth: true
                            },
                            {
                                name: "student.personnelNo",
                                title: "<spring:message code="personnel.no"/>",
                                filterOperator: "iContains",
                                //autoFitWidth: true
                            },
                            {
                                name: "student.personnelNo2",
                                title: "<spring:message code="personnel.no.6.digits"/>",
                                filterOperator: "iContains",
                                //autoFitWidth: true
                            }
                        ],
                        filterFields:["student.firstName", "student.lastName", "student.nationalCode", "student.mobile", "student.companyName", "student.personnelNo", "student.personnelNo2"],
                        changed:function (form, item,value) {
                            var values = DynamicForm_selectPersonnel_jspEvaluation.getItem("personnelInClass").getValue();
                            var valueMaps = item.getValueMap();

                            if(typeof(item.getPickListRecordForValue(item.getValue())?.student?.mobile)!="undefined") {


                                if (typeof (values) == "undefined") {
                                    values = [];
                                }
                                values.push(item.getValue())

                                DynamicForm_selectPersonnel_jspEvaluation.getItem("personnelInClass").setValueMap(valueMaps);
                                DynamicForm_selectPersonnel_jspEvaluation.getItem("personnelInClass").setValue(values);

                            }else{
                                createDialog("info", "براي فرد مورد نظر شماره موبايل وارد نشده است.");
                            }

                            item.setValue();
                        }

                    }
                },
                {
                    vAlign: "top",
                    titleVAlign: "top",
                    name: "teacherInClass",
                    align: "right",
                    title: "اساتید",
                    editorType: "MultiComboBoxItem",
                    multiple: true,
                    defaultValue: null,
                    changeOnKeypress: true,
                    showHintInField: true,
                    displayField: "fullName",
                    displayValueFromRecord: false,
                    comboBoxWidth: 700,
                    valueField: "id",
                    layoutStyle: "vertical",
                    optionDataSource: TeacherInClassDS_evaluation_class,
                    comboBoxProperties: {
                        pickListWidth: 600,
                        pickListFields: [
                            {name: "id", primaryKey: true, hidden: true},
                            {
                                name: "personality.firstNameFa",
                                title: "<spring:message code="firstName"/>",
                                filterOperator: "iContains",
                                //autoFitWidth: true
                            },
                            {
                                name: "personality.lastNameFa",
                                title: "<spring:message code="lastName"/>",
                                filterOperator: "iContains",
                                //autoFitWidth: true
                            },
                            {
                                name: "personality.nationalCode",
                                title: "<spring:message code="national.code"/>",
                                filterOperator: "iContains",
                                //autoFitWidth: true
                            },
                            {
                                name: "personality.contactInfo.mobile",
                                title: "<spring:message code="mobile"/>",
                                filterOperator: "iContains",
                                //width:"*"
                            },
                            {
                                name: "teacherCode",
                                title: "<spring:message code="teacher.code"/>",
                                filterOperator: "iContains",
                                //autoFitWidth: true
                            },
                            {
                                name: "personnelNo",
                                title: "<spring:message code="personnel.no"/>",
                                filterOperator: "iContains",
                                //autoFitWidth: true
                            }
                        ],
                        filterFields:["personality.firstNameFa", "personality.lastNameFa", "personality.nationalCode", "personality.contactInfo.mobile", "personnelNo", "personnelNo", "tclass.id"],
                        changed:function (form, item,value) {
                            if(typeof(item.getPickListRecordForValue(item.getValue()).personality?.contactInfo?.mobile)!="undefined") {

                                var values = DynamicForm_selectPersonnel_jspEvaluation.getItem("teacherInClass").getValue();
                                var valueMaps = item.getValueMap();

                                if (typeof (values) == "undefined" || values==null) {
                                    values = [];
                                }

                                values.push(item.getValue());

                                DynamicForm_selectPersonnel_jspEvaluation.getItem("teacherInClass").setValueMap(valueMaps);
                                DynamicForm_selectPersonnel_jspEvaluation.getItem("teacherInClass").setValue(values);

                            }else{
                                createDialog("info", "براي فرد مورد نظر شماره موبايل وارد نشده است.");
                            }

                            item.setValue();
                        }
                    },
                },
                {
                    vAlign: "top",
                    titleVAlign: "top",
                    name: "topPersonnelInClass",
                    align: "right",
                    title: "بالا دست فراگیران",
                    editorType: "MultiComboBoxItem",
                    multiple: true,
                    defaultValue: null,
                    changeOnKeypress: true,
                    showHintInField: true,
                    displayField: "fullName",
                    comboBoxWidth: 700,
                    valueField: "id",
                    layoutStyle: "vertical",
                    optionDataSource: PersonnelInfomationDS_evaluation_class,
                    comboBoxProperties: {
                        pickListWidth: 700,
                        pickListFields: [
                            {name: "id", primaryKey: true, hidden: true},
                            {
                                name: "firstName",
                                title: "<spring:message code="firstName"/>",
                                filterOperator: "iContains",
                                //autoFitWidth: true
                            },
                            {
                                name: "lastName",
                                title: "<spring:message code="lastName"/>",
                                filterOperator: "iContains",
                                //autoFitWidth: true
                            },
                            {
                                name: "nationalCode",
                                title: "<spring:message code="national.code"/>",
                                filterOperator: "iContains",
                                //autoFitWidth: true
                            },
                            {
                                name: "mobile",
                                title: "<spring:message code="mobile"/>",
                                filterOperator: "iContains",
                                //autoFitWidth: true
                            },
                            {
                                name: "companyName",
                                title: "<spring:message code="company.name"/>",
                                filterOperator: "iContains",
                                //autoFitWidth: true
                            },
                            {
                                name: "personnelNo",
                                title: "<spring:message code="personnel.no"/>",
                                filterOperator: "iContains",
                                //autoFitWidth: true
                            },
                            {
                                name: "personnelNo2",
                                title: "<spring:message code="personnel.no.6.digits"/>",
                                filterOperator: "iContains"
                            }
                        ],
                        filterFields:["firstName", "lastName", "nationalCode", "mobile", "companyName", "personnelNo", "personnelNo2"],
                        changed:function (form, item,value) {

                            if(typeof(item.getPickListRecordForValue(item.getValue()).mobile)!="undefined") {

                                var values = DynamicForm_selectPersonnel_jspEvaluation.getItem("topPersonnelInClass").getValue();
                                var valueMaps = item.getValueMap();

                                if (typeof (values) == "undefined") {
                                    values = [];
                                }

                                values.push(item.getValue());

                                DynamicForm_selectPersonnel_jspEvaluation.getItem("topPersonnelInClass").setValueMap(valueMaps);
                                DynamicForm_selectPersonnel_jspEvaluation.getItem("topPersonnelInClass").setValue(values);

                            }else{
                                createDialog("info", "براي فرد مورد نظر شماره موبايل وارد نشده است.");
                            }

                            item.setValue();
                        }
                    },
                },
                {
                    vAlign: "top",
                    titleVAlign: "top",
                    name: "coWorkerInClass",
                    align: "right",
                    title: "همکاران فراگیران",
                    editorType: "MultiComboBoxItem",
                    multiple: true,
                    defaultValue: null,
                    changeOnKeypress: true,
                    showHintInField: true,
                    displayField: "fullName",
                    comboBoxWidth: 700,
                    valueField: "id",
                    layoutStyle: "vertical",
                    optionDataSource: PersonnelInfomationDS_evaluation_class,
                    comboBoxProperties: {
                        pickListWidth: 700,
                        pickListFields: [
                            {name: "id", primaryKey: true, hidden: true},
                            {
                                name: "firstName",
                                title: "<spring:message code="firstName"/>",
                                filterOperator: "iContains",
                                //autoFitWidth: true
                            },
                            {
                                name: "lastName",
                                title: "<spring:message code="lastName"/>",
                                filterOperator: "iContains",
                                //autoFitWidth: true
                            },
                            {
                                name: "nationalCode",
                                title: "<spring:message code="national.code"/>",
                                filterOperator: "iContains",
                                //autoFitWidth: true
                            },
                            {
                                name: "mobile",
                                title: "<spring:message code="mobile"/>",
                                filterOperator: "iContains",
                                //autoFitWidth: true
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
                                //autoFitWidth: true
                            },
                            {
                                name: "personnelNo2",
                                title: "<spring:message code="personnel.no.6.digits"/>",
                                filterOperator: "iContains"
                            }
                        ],
                        filterFields:["firstName", "lastName", "nationalCode", "mobile", "companyName", "personnelNo", "personnelNo2"],
                        changed:function (form, item,value) {

                            if(typeof(item.getPickListRecordForValue(item.getValue()).mobile)!="undefined") {

                                var values = DynamicForm_selectPersonnel_jspEvaluation.getItem("coWorkerInClass").getValue();
                                var valueMaps = item.getValueMap();

                                if (typeof (values) == "undefined") {
                                    values = [];
                                }
                                values.push(item.getValue())

                                DynamicForm_selectPersonnel_jspEvaluation.getItem("coWorkerInClass").setValueMap(valueMaps);
                                DynamicForm_selectPersonnel_jspEvaluation.getItem("coWorkerInClass").setValue(values);

                            }else{
                                createDialog("info", "براي فرد مورد نظر شماره موبايل وارد نشده است.");
                            }

                            item.setValue();
                        }
                    },
                }
            ]
        })

        Window_Evaluation_SendMessage = isc.Window.create({
            width: 1000,
            height: 700,
            autoSize: false,
            title: 'ارسال پیامک',
            items: [isc.VLayout.create({
                width: "100%",
                height: "88%",
                autoDraw: false,
                align: "center",
                members: [
                    DynamicForm_selectPersonnel_jspEvaluation,
                    DynamicForm_SendMessage_jspEvaluation
                ]
            }),
                isc.TrHLayoutButtons.create({
                    members: [
                        isc.IButtonSave.create({
                            title:"ارسال پیامک",
                            top: 260,
                            align: "center",
                            icon: "[SKIN]/actions/save.png",
                            click: function () {
                                let message = DynamicForm_SendMessage_jspEvaluation.getItem("message").getValue();

                                if(typeof(message)=='undefined' || message==null){
                                    message = '';
                                }

                                let personnelNos=[];
                                let values=DynamicForm_selectPersonnel_jspEvaluation.getField("personnelInClass")?.getValue();
                                let size=values?.length;

                                for (var i = 0; i < size; i++) {
                                    personnelNos.push({type:'personnelInClass',id:values[i]})
                                }

                                values=DynamicForm_selectPersonnel_jspEvaluation.getField("teacherInClass")?.getValue();
                                size=values?.length;

                                for (var i = 0; i < size; i++) {
                                    personnelNos.push({type:'teacherInClass',id:values[i]})
                                }

                                values=DynamicForm_selectPersonnel_jspEvaluation.getField("topPersonnelInClass")?.getValue();
                                size=values?.length;

                                for (var i = 0; i < size; i++) {
                                    personnelNos.push({type:'topPersonnelInClass',id:values[i]})
                                }

                                values=DynamicForm_selectPersonnel_jspEvaluation.getField("coWorkerInClass")?.getValue();
                                size=values?.length;

                                for (var i = 0; i < size; i++) {
                                    personnelNos.push({type:'coWorkerInClass',id:values[i]})
                                }


                                if(message == '' || personnelNos.length==0){
                                    createDialog("info", "<spring:message code="msg.field.is.required"/>", "<spring:message code="error"/>");
                                    return '';
                                }


                                let data = {
                                    personnelNo:personnelNos,
                                    message:DynamicForm_SendMessage_jspEvaluation.getItem("message").getValue(),
                                };


                                isc.RPCManager.sendRequest(TrDSRequest(sendMessageUrl + "/sendSMS", "POST", JSON.stringify(data),function(resp){
                                    if (resp.httpResponseCode != 200){
                                        createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                                        return;
                                    }else{
                                        Window_Evaluation_SendMessage.close();
                                        createDialog("info", "<spring:message code="msg.successfully.done"/>", "<spring:message code="global.message"/>");
                                        return;
                                    }
                                }))
                            }
                        }), isc.IButtonCancel.create({
                            top: 260,
                            title: "<spring:message code='cancel'/>",
                            align: "center",
                            icon: "[SKIN]/actions/cancel.png",
                            click: function () {
                                Window_Evaluation_SendMessage.close();
                            }
                        })
                    ]
                })
            ]
        });
    }
    // ---------------------------------------- Create - DynamicForm $ Window ------------------------------->>

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

        var VLayout_Body_evaluation = isc.VLayout.create({
            width: "100%",
            height: "100%",
            members: [DynamicForm_ReturnDate, HLayout_Actions_evaluation, Hlayout_Grid_evaluation]
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
            height: "49%",
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

        function set_print_Status(numberOfStudents) {

            evaluation_check_date();

            if (DynamicForm_ReturnDate.hasErrors())
                return;

            if (Detail_Tab_Evaluation.getSelectedTab().id === "TabPane_Behavior") {
                ealuation_numberOfStudents = numberOfStudents;
                let selectedStudent = ListGrid_evaluation_student.getSelectedRecord();
                if (numberOfStudents === "all" || (numberOfStudents === "single" && selectedStudent !== null && selectedStudent !== undefined)) {
                    EvaluationWin_PersonList.show();
                    EvaluationListGrid_PeronalLIst.invalidateCache();
                    EvaluationListGrid_PeronalLIst.fetchData();
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
                print_Student_FormIssuance("pdf", numberOfStudents);
            }
        }

        //*****print student form issuance*****
        function print_Student_FormIssuance(type, numberOfStudents) {

            if (ListGrid_evaluation_student.getTotalRows() > 0) {
                let selectedClass = ListGrid_evaluation_class.getSelectedRecord();
                let selectedStudent = ListGrid_evaluation_student.getSelectedRecord();
                let selectedTab = Detail_Tab_Evaluation.getSelectedTab();


                if (numberOfStudents === "all" || (numberOfStudents === "single" && selectedStudent !== null && selectedStudent !== undefined)) {

                    let studentId = (numberOfStudents === "single" ? selectedStudent.student.id : -1);
                    let returnDate = evaluation_ReturnDate._value !== undefined ? evaluation_ReturnDate._value.replaceAll("/", "-") : "noDate";
                    let evaluationType = (evaluation_Audience_Type.values.audiencePost === null || evaluation_Audience_Type.values.audiencePost === undefined ? "" : evaluation_Audience_Type.values.audiencePost);

                    var myObj = {
                        evaluationAudienceType: evaluationType,
                        courseId: selectedClass.course.id,
                        studentId: studentId,
                        evaluationType: selectedTab.id,
                        evaluationReturnDate: returnDate,
                        evaluationAudience: evaluation_Audience
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
                    criteriaForm_operational.submit(set_evaluation_status(numberOfStudents));

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

        //*****set evaluation status*****
        function set_evaluation_status(numberOfStudents) {


            var listOfStudent = [];

            getStudentList(setStudentStatus);

            function getStudentList(callback) {

                if (numberOfStudents === "single") {

                    listOfStudent.push(ListGrid_evaluation_student.getSelectedRecord());
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

                        ToolStripButton_FormIssuance.setTitle("<spring:message code="student.form.issuance.Reaction"/>");
                        ToolStripButton_FormIssuanceForAll.setTitle("<spring:message code="students.form.issuance.Reaction"/>");
                        break;
                    }
                    case "TabPane_Learning": {
                        ListGrid_evaluation_student.hideField("evaluationStatusReaction");
                        ListGrid_evaluation_student.hideField("evaluationStatusBehavior");
                        ListGrid_evaluation_student.hideField("evaluationStatusResults");
                        ListGrid_evaluation_student.showField("evaluationStatusLearning");

                        RestDataSource_evaluation_student.fetchDataURL = tclassStudentUrl + "/students-iscList/" + classRecord.id;
                        ListGrid_evaluation_student.invalidateCache();
                        ListGrid_evaluation_student.fetchData();

                        ToolStripButton_FormIssuance.setTitle("<spring:message code="student.form.issuance"/>");
                        ToolStripButton_FormIssuanceForAll.setTitle("<spring:message code="students.form.issuance"/>");
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

                        ToolStripButton_FormIssuance.setTitle("<spring:message code="student.form.issuance"/>");
                        ToolStripButton_FormIssuanceForAll.setTitle("<spring:message code="students.form.issuance"/>");
                        break;
                    }
                    case "TabPane_Results": {
                        ListGrid_evaluation_student.hideField("evaluationStatusReaction");
                        ListGrid_evaluation_student.hideField("evaluationStatusLearning");
                        ListGrid_evaluation_student.hideField("evaluationStatusBehavior");
                        ListGrid_evaluation_student.showField("evaluationStatusResults");

                        RestDataSource_evaluation_student.fetchDataURL = tclassStudentUrl + "/students-iscList/" + classRecord.id;
                        ListGrid_evaluation_student.invalidateCache();
                        ListGrid_evaluation_student.fetchData();

                        ToolStripButton_FormIssuance.setTitle("<spring:message code="student.form.issuance"/>");
                        ToolStripButton_FormIssuanceForAll.setTitle("<spring:message code="students.form.issuance"/>");
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
                if(!classRecord.preCourseTest)
                    Detail_Tab_Evaluation.disableTab(1);
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
        var studentIdJspEvaluation;
        var teacherIdJspEvaluation = LGRecord.teacherId;
        var evaluationLevelId;
        var saveMethod;
        var saveUrl = evaluationUrl;
        var valueMapAnswer = {209: "خیلی ضعیف", 208: "ضعیف", 207: "متوسط", 206: "خوب", 205: "عالی"};
        var RestData_EvaluationType_JspEvaluation = isc.TrDS.create({
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
                },
            ],
            fetchDataURL: parameterValueUrl + "/iscList/143",
        });
        var RestData_EvaluationLevel_JspEvaluation = isc.TrDS.create({
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
                },
            ],
            fetchDataURL: parameterValueUrl + "/iscList/163",
        });
        var RestData_Students_JspEvaluation = isc.TrDS.create({
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
            ],
            fetchDataURL: tclassStudentUrl + "/students-iscList/"
        });
        var RestData_StudentPresenceType_JspEvaluation = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true, hidden: true},
                {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
                {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
            ],
            fetchDataURL: parameterValueUrl + "/iscList/98"
        });
        var vm_JspEvaluation = isc.ValuesManager.create({});

        var DynamicForm_Questions_Title_JspEvaluation = isc.DynamicForm.create({
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
                    name: "evaluationType",
                    title: "<spring:message code="evaluation.type"/>",
                    type: "SelectItem",
                    optionDataSource: RestData_EvaluationType_JspEvaluation,
                    valueField: "code",
                    required: true,
                    displayField: "title",
                    changed: function (form, item, value) {
                        DynamicForm_Questions_Body_JspEvaluation.clearValues();
                        DynamicForm_Description_JspEvaluation.clearValues();
                        form.clearErrors(true);
                        form.clearValue("evaluationLevel");
                        form.clearValue("evaluator");
                        form.clearValue("evaluated");
                        var criteria = '{"fieldName":"questionnaireType.code","operator":"equals","value":""}';
                        DynamicForm_Questions_Body_JspEvaluation.setFields([]);
                        form.getItem("evaluationLevel").disable();
                        var criteriaEdit =
                            '{"fieldName":"classId","operator":"equals","value":' + LGRecord.id + '},';
                        // '{"fieldName":"questionnaireTypeId","operator":"equals","value":139},' +
                        // '{"fieldName":"evaluatorId","operator":"equals","value":'+studentIdJspEvaluation+'},' +
                        // '{"fieldName":"evaluatorTypeId","operator":"equals","value":188},';
                        switch (value) {
                            case "SEFT":
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
                                // criteria= '{"fieldName":"domain.code","operator":"equals","value":"SAT"}';
                                form.setValue("evaluated", form.getValue("titleClass"));
                                RestData_Students_JspEvaluation.fetchDataURL = tclassStudentUrl + "/students-iscList/" + LGRecord.id;
                                form.getItem("evaluationLevel").setRequired(true);
                                Window_AddStudent_JspEvaluation.show();
                                return;
                            case "TEFC":
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
                                form.getItem("evaluationLevel").setRequired(false);
                                break;
                        }
                        requestEvaluationQuestions(criteria, criteriaEdit)
                    }
                },
                {
                    name: "evaluationLevel",
                    title: "<spring:message code="evaluation.level"/>",
                    type: "SelectItem",
                    optionDataSource: RestData_EvaluationLevel_JspEvaluation,
                    valueField: "code",
                    displayField: "title",
                    disabled: true,
                    endRow: true,
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
                                criteriaEdit += '{"fieldName":"evaluationLevelId","operator":"equals","value":156}';
                                evaluationLevelId = 156;
                                requestEvaluationQuestions(criteria, criteriaEdit, 1);
                                break;
                            case "Results":
                                criteriaEdit += '{"fieldName":"evaluationLevelId","operator":"equals","value":157}';
                                evaluationLevelId = 157;
                                requestEvaluationQuestions(criteria, criteriaEdit, 1);
                                break;
                            case "Reactive":
                                evaluationLevelId = 154;
                                criteria = '{"fieldName":"questionnaireType.code","operator":"equals","value":"SEFC"}';
                                criteriaEdit += '{"fieldName":"evaluationLevelId","operator":"equals","value":154}';
                                requestEvaluationQuestions(criteria, criteriaEdit, 1);
                                break;
                            case "Learning":
                                evaluationLevelId = 155;
                                criteriaEdit += '{"fieldName":"evaluationLevelId","operator":"equals","value":155}';
                                requestEvaluationQuestions(criteria, criteriaEdit, 1);
                                break;
                            default:
                                break;
                        }
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
        var DynamicForm_Questions_Body_JspEvaluation = isc.DynamicForm.create({
            ID: "DynamicForm_Questions_Body_JspEvaluation",
            validateOnExit: true,
            valuesManager: vm_JspEvaluation,
            colWidths: ["45%", "50%"],
            cellBorder: 1,
            width: "100%",
            padding: 10,
            fields: []
        });

        var DynamicForm_Description_JspEvaluation = isc.DynamicForm.create({
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


        var IButton_Questions_Save = isc.IButtonSave.create({
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
                        break;
                }
                data.classId = LGRecord.id;
                isc.RPCManager.sendRequest(TrDSRequest(saveUrl, saveMethod, JSON.stringify(data), function (resp) {
                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                        isc.RPCManager.sendRequest(TrDSRequest(evaluationAnalysisUrl + "/updateEvaluationAnalysis" + "/" +
                            LGRecord.id,
                            "GET", null, null));
                        const msg = createDialog("info", "<spring:message code="global.form.request.successful"/>");
                        setTimeout(() => {
                            msg.close();
                        }, 3000);
                        Window_Questions_JspEvaluation.close();
                    } else {
                        createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                    }
                }))
            }
        });
        var IButton_Questions_Print = isc.IButtonSave.create({
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
        var Window_Questions_JspEvaluation = isc.Window.create({
            // placement: "fillScreen",
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
                        IButton_Questions_Print,
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
        var Window_AddStudent_JspEvaluation = isc.Window.create({
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
                                {name: "student.postTitle"},
                                {
                                    name: "presenceTypeId",
                                    type: "selectItem",
                                    valueField: "id",
                                    displayField: "title",
                                    optionDataSource: RestData_StudentPresenceType_JspEvaluation,
                                }
                            ],
                            gridComponents: ["filterEditor", "header", "body"],
                            recordDoubleClick: function (viewer, record, recordNum, field, fieldNum, value, rawValue) {
                                DynamicForm_Questions_Title_JspEvaluation.setValue("evaluator", record.student.firstName + " " + record.student.lastName);
                                studentIdJspEvaluation = record.id;
                                Window_AddStudent_JspEvaluation.close();
                                DynamicForm_Questions_Title_JspEvaluation.getItem("evaluationLevel").enable();
                            }
                        })
                    ]
                })]
        });
        DynamicForm_Questions_Title_JspEvaluation.editRecord(LGRecord);
        DynamicForm_Questions_Title_JspEvaluation.setValue("user", "<%= SecurityUtil.getFullName()%>");
        let itemList = [];
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

    // </script>