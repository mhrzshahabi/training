<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="sprig" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>
    <%
        final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
    %>
    let finalTestMethod_finalTest;
    let oLoadAttachments_finalTest;
    let totalScore = 0;
    let totalTime = 0;
    let sourceExamId = 0;
    let firstHour = "";
    let diffHour = "";
    let diffMin = "";
    let examDuration = "";
    let secondHour = "";
    let firstMin = "";
    let secondMin = "";
    let isCopyForm = false;
    let allResultScores;
    var scoreLabel = isc.Label.create({
        contents: "مجموع بارم وارد شده : ",
        border: "0px solid black",
        align: "center",
        width: "100%",
        height: "100%"
    });
    var classScoreLabel = isc.Label.create({
        contents: "مجموع نمرات کلاسی و عملی  وارد شده : ",
        border: "0px solid black",
        align: "center",
        width: "100%",
        height: "100%"
    });
    var timeLabel = isc.Label.create({
        contents: "مجموع زمان وارد شده : ",
        border: "0px solid black",
        align: "center",
        width: "100%",
        height: "100%"
    });
    let DynamicForm_Filter_exam =isc.DynamicForm.create({
            height: "100%",
            fields: [
                {
                name: "filter_exam",
                title: "",
                type: "radioGroup",
                valueMap: {
                    "1": "لیست آزمون هايی که زمان آنها امروز است",
                    "2": "لیست همه ی آزمون ها"
                },
                vertical: false,
                changed: function (form, item, value) {
                         switch (value) {
            case "1":
                {
                          let criteria = {
                            _constructor: "AdvancedCriteria",
                            operator: "and",
                            criteria: [
                                {fieldName: "date", operator: "equals", value: todayDate}
                            ]
                        };
                        FinalTestDS_finalTest.fetchDataURL = testQuestionUrl + "/spec-list";
                        FinalTestLG_finalTest.invalidateCache();
                        FinalTestLG_finalTest.fetchData(criteria);
                    break;
            }
            case "2":
        FinalTestLG_finalTest.invalidateCache();
        FinalTestLG_finalTest.fetchData();
        loadTab(TabSet_finalTest.getSelectedTab().ID);
                 break;
        }
                }
            }
        ]
    });

// ------------------------------------------- Menu -------------------------------------------
    FinalTestMenu_finalTest = isc.Menu.create({
        data: [
            <sec:authorize access="hasAuthority('FinalTest_R')">
            {
                title: "<spring:message code="refresh"/>",
                click: function () {
                    refresh_finalTest();
                }
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('FinalTest_C')">
            {
                title: "<spring:message code="create"/>",
                click: function () {
                    examTypeDF.clearValues();
                    selectExamTypeWindow.show();
                    // showNewForm_finalTest();
                }
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('FinalTest_U')">
            {
                title: "<spring:message code="edit"/>",
                click: function () {
                    showEditForm_finalTest();
                }
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('FinalTest_D')">
            {
                title: "<spring:message code="remove"/>",
                click: function () {
                    showRemoveForm_finalTest();
                }
            },
            </sec:authorize>
        ]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------
    FinalTestTS_finalTest = isc.ToolStrip.create({
        members: [
            <sec:authorize access="hasAuthority('FinalTest_C')">
            isc.ToolStripButtonAdd.create({
                click: function () {
                    selectExamTypeWindow.show();
                }
            }),
            </sec:authorize>
            <sec:authorize access="hasAuthority('FinalTest_U')">
            isc.ToolStripButtonEdit.create({
                click: function () {
                    showEditForm_finalTest();
                }
            }),
            </sec:authorize>
            <sec:authorize access="hasAuthority('FinalTest_D')">
            isc.ToolStripButtonRemove.create({
                click: function () {
                    showRemoveForm_finalTest();
                }
            }),
            </sec:authorize>
            <sec:authorize access="hasAuthority('FinalTest_C')">
            isc.ToolStripButton.create({
                title: "<spring:message code='copy.of.test'/>",
                click: function () {
                    showCopyForm_finalTest();
                }
            }),
            </sec:authorize>
            <sec:authorize access="hasAuthority('FinalTest_P')">
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let implicitCriteria = JSON.parse(JSON.stringify(FinalTestDS_finalTest.implicitCriteria)) ;
                    let criteria = FinalTestLG_finalTest.getCriteria();

                    if(criteria.criteria){
                        for (let i = 0; i < criteria.criteria.length ; i++) {
                            implicitCriteria.criteria.push(criteria.criteria[i]);
                        }
                    }
                     ExportToFile.downloadExcelRestUrl(null, FinalTestLG_finalTest,  testQuestionUrl + "/spec-list" , 0, null, '',"لیست آزمون های پایانی", implicitCriteria, null);
                }
             }),
            </sec:authorize>

            isc.LayoutSpacer.create({
                width: "*"
            }),
                  DynamicForm_Filter_exam,
            <sec:authorize access="hasAuthority('FinalTest_R')">
            isc.ToolStripButtonRefresh.create({
                click: function () {
                    refresh_finalTest();
                }
            }),
            </sec:authorize>
        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------
    FinalTestDS_finalTest = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {
                name: "tclass.code",
                title: "<spring:message code="class.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "tclass.course.titleFa",
                title: "<spring:message code="course"/>",
                filterOperator: "iContains"
            },
            {
                name: "tclass.startDate",
                title: "<spring:message code="start.date"/>",
                filterOperator: "iContains", autoFitWidth: true
            },
            {
                name: "tclass.endDate",
                title: "<spring:message code="end.date"/>",
                filterOperator: "iContains", autoFitWidth: true
            },
            <%--{--%>
            <%--    name: "tclass.teacher",--%>
            <%--    title: "<spring:message code="teacher"/>",--%>
            <%--    filterOperator: "iContains", autoFitWidth: true--%>
            <%--},--%>
            {
                name: "date",
                title: "<spring:message code="test.question.date"/>",
                filterOperator: "iContains", autoFitWidth: true
            },
            {
                name: "time",
                title: "<spring:message code="test.question.time"/>",
                filterOperator: "iContains", autoFitWidth: true
            },
            {
                name: "endDate",
                title: "<spring:message code="test.question.end.date"/>",
                filterOperator: "iContains", autoFitWidth: true
            },
            {
                name: "endTime",
                title: "<spring:message code="test.question.end.time"/>",
                filterOperator: "iContains", autoFitWidth: true
            },
            {
                name: "duration",
                title: "<spring:message code="test.question.duration"/>",
                filterOperator: "equals", autoFitWidth: true
            },
            { name: "onlineFinalExamStatus",
                title: "<spring:message code="test.question.status"/>",
                 autoFitWidth: true
            },
            { name: "onlineExamDeadLineStatus", hidden: true},
            { name: "classScore", title: "نمره کلاسی"},
            { name: "testQuestionType", title: "نوع آزمون", autoFitWidth: true},
            { name: "practicalScore",title: "نمره عملی"}
        ],
        fetchDataURL: testQuestionUrl + "/spec-list",
        implicitCriteria: {
            _constructor: "AdvancedCriteria",
            operator: "and",
            criteria: [{fieldName: "testQuestionType", operator: "inSet", value: ["FinalTest", "PreTest"]}]
        },
    });

    CourseDS_finalTest = isc.TrDS.create({
        fields: [
            {name: "id", type: "Integer", primaryKey: true},
            {name: "code"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "categoryId"},
            {name: "subCategory.titleFa"},
            {name: "erunType.titleFa"},
            {name: "elevelType.titleFa"},
            {name: "etheoType.titleFa"},
            {name: "theoryDuration"},
            {name: "etechnicalType.titleFa"},
            {name: "minTeacherDegree"},
            {name: "minTeacherExpYears"},
            {name: "minTeacherEvalScore"},
            // {name: "know   ledge"},
            // {name: "skill"},
            // {name: "attitude"},
            {name: "needText"},
            {name: "description"},
            {name: "workflowStatus"},
            {name: "workflowStatusCode"},
            {name: "hasGoal"},
            {name: "hasSkill"},
            {name: "evaluation"},
            {
                name: "behavioralLevel",
            }
            // {name: "version"},
        ],
        fetchDataURL: courseUrl + "spec-list",
    });


    ClassDS_finalTest = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "group"},
            {name: "c"},
            {name: "startDate"},
            {name: "endDate"},
            {name: "studentCount", canFilter: false, canSort: false},
            {name: "code"},
            {name: "term.titleFa"},
            {name: "course.titleFa"},
            {name: "course.id"},
            {name: "teacherId"},
            {
                name: "teacher",
            },
            {
                name: "teacher.personality.lastNameFa",
            },
            {name: "reason"},
            {name: "classStatus"},
            {name: "topology"},
            {name: "trainingPlaceIds"},
            {name: "instituteId"},
            {name: "workflowEndingStatusCode"},
            {name: "workflowEndingStatus"},
            {name: "preCourseTest", type: "boolean"},
            {name: "course.code"},
            {name: "course.theoryDuration"},
            {name: "scoringMethod"},
            {name: "evaluation"}
        ],
        fetchDataURL: classUrl + "spec-list"
    });

    TeacherDS_finalTest = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "personality.id"},
            {name: "teacherCode"},
            {name: "personnelCode"},
            {name: "personality.firstNameFa"},
            {name: "personality.lastNameFa"},
            {name: "personality.educationLevel.titleFa"},
            {name: "personality.educationMajor.titleFa"},
            {name: "personality.contactInfo.mobile"},
            {name: "categories"/*, filterOperator: "inSet"*/},
            {name: "subCategories"/*, filterOperator: "inSet"*/},
            {name: "personality.contactInfo.homeAddress.id"},
            {name: "personality.contactInfo.workAddress.id"},
            {name: "personality.accountInfo.id"},
            {name: "personality.educationLevelId"}
        ],
        fetchDataURL: teacherUrl + "spec-list"
    });


    FinalTestLG_finalTest = isc.TrLG.create({
        <sec:authorize access="hasAuthority('FinalTest_R')">
        dataSource: FinalTestDS_finalTest,
        </sec:authorize>
        fields: [
            {name: "tclass.code", sortNormalizer: function (record) {return record.tclass.code; } },
            {name: "tclass.course.titleFa", sortNormalizer: function (record) {return record.tclass.course.titleFa; } },
            {name: "tclass.startDate", sortNormalizer: function (record) {return record.tclass.startDate; } },
            {name: "tclass.endDate", sortNormalizer: function (record) {return record.tclass.endDate; } },
            // {name: "tclass.teacher", sortNormalizer: function (record) {return record.tclass.teacher; } },
            {name: "date"},
            {name: "time"},
            {name: "endDate"},
            {name: "endTime"},
            {name: "duration"},
            {name: "practicalScore"},
            {name: "classScore"},
            {
                name: "testQuestionType",
                valueMap: {
                    "PreTest": "پیش آزمون",
                    "FinalTest": "آزمون پایانی",
                    "Preparation": "آزمون آمادگی"
                }
            },
            { name: "onlineFinalExamStatus",canFilter: false, valueMap: {"false": "ارسال نشده", "true": "ارسال شده"}},
            { name: "sendBtn",canFilter: false, title: "بارم بندی ", width: "145"},
            { name: "showBtn",canFilter: false, title: "نتایج ", width: "130"},
            { name: "checkDate",canFilter: false, title: "اطلاعات کاربران", width: "145"},
            { name: "onlineExamDeadLineStatus",canFilter: false , hidden: true},
        ],
        autoFetchData: true,
        gridComponents: [FinalTestTS_finalTest, "filterEditor", "header", "body",],
        contextMenu: FinalTestMenu_finalTest,
        sortField: 1,
        filterOperator: "iContains",
        filterOnKeypress: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        selectionUpdated: function (record) {
            disableResendFinalTestTab();
            loadTab(TabSet_finalTest.getSelectedTab().ID);
            if (TabSet_finalTest.getSelectedTab() === undefined || TabSet_finalTest.getSelectedTab() === null){
                refreshSelectedTab_class_final(0);
            } else {
                refreshSelectedTab_class_final(TabSet_finalTest.getSelectedTab());
                if (TabSet_finalTest.getSelectedTab().ID === 'resendFinalTest'){
                    if (record.onlineFinalExamStatus === false){
                        resendFinalExam_DynamicForm.getItem("time").setDisabled(true);
                        resendFinalExam_DynamicForm.getItem("startDate").setDisabled(true);
                        resendFinalExam_DynamicForm.getItem("duration").setDisabled(true);
                        <sec:authorize access="hasAuthority('FinalTest_Send')">
                        resendFinalExam_DynamicForm.getItem("sendBtn").setDisabled(true);
                        </sec:authorize>
                    } else {
                        resendFinalExam_DynamicForm.getItem("time").setDisabled(false);
                        resendFinalExam_DynamicForm.getItem("startDate").setDisabled(false);
                        resendFinalExam_DynamicForm.getItem("duration").setDisabled(false);
                        <sec:authorize access="hasAuthority('FinalTest_Send')">
                        resendFinalExam_DynamicForm.getItem("sendBtn").setDisabled(false);
                        </sec:authorize>
                    }
                }
            }

        },
        <sec:authorize access="hasAuthority('FinalTest_U')">
        doubleClick: function () {
            showEditForm_finalTest();
        },
        </sec:authorize>
        filterEditorSubmit: function () {
            FinalTestLG_finalTest.invalidateCache();
        },
         createRecordComponent: function (record, colNum) {
                    var fieldName = this.getFieldName(colNum);
                    if(fieldName === "sendBtn") {
                        <sec:authorize access="hasAuthority('FinalTest_Send')">
                        let button = isc.IButton.create({
                            layoutAlign: "center",
                            disabled: record.onlineFinalExamStatus,
                            title: "بارم بندی و ارسال آزمون",
                            width: "145",
                            margin: 3,
                            click: function () {
                                let classScore=(record.classScore !==undefined && record.classScore !==null)?strToNumber(record.classScore):0;
                                let practicalScore=(record.practicalScore !==undefined && record.practicalScore !==null)?strToNumber(record.practicalScore):0;
                                let sum = (+classScore) + (+practicalScore);
                                classScoreLabel.setContents("مجموع نمرات کلاسی و عملی  وارد شده : "+sum)

                                loadExamForScores(record);
                                // loadExamQuestions(record)
                            }
                        });
                        return button;
                        </sec:authorize>
                    } if(fieldName === "showBtn") {
                        <sec:authorize access="hasAuthority('FinalTest_Result')">
                        let button = isc.IButton.create({
                            layoutAlign: "center",
                            disabled: !record.onlineFinalExamStatus,
                            title: "نمایش نتایج ",
                            width: "130",
                            margin: 3,

                            click: function () {
                                sourceExamId=record.id
                                loadExamResult(record)
                            }
                        });
                        return button;
                        </sec:authorize>
                    } if(fieldName === "checkDate") {
                        <sec:authorize access="hasAuthority('FinalTest_R')">
                        let button = isc.IButton.create({
                            layoutAlign: "center",
                            title: "فراگیران با اطلاعات ناقص",
                            width: "145",
                            margin: 3,
                            click: function () {
                                showInvalidUsers(record)
                            }
                        });
                        return button;
                        </sec:authorize>
                    } else {
                        return null;
                    }
                },
    });
    var RestDataSource_Result_FinalTest = isc.TrDS.create({
        fields: [
            {name: "surname", title: 'نام'},
            {name: "lastName", title: 'نام خانوادگی'},
            {name: "answers",title: 'asdasd', hidden: true },
            {name: "answers", hidden: true },
        ]
    });
    var RestDataSource_Questions_finalTest = isc.TrDS.create({
        fields: [
             {name: "id",hidden:true },
             {name: "question", title: 'سوال'},
                {name: "type", title: 'نوع پاسخ' },
                { name: "options", title: "گزینه ها"},
                { name: "proposedPointValue", title: "<spring:message code="question.bank.proposed.point.value"/>"},
                { name: "score", title: "بارم",canEdit:true, filterOnKeypress: true,keyPressFilter: "[0-9.]",editEvent: "click",
                },
            { name: "time", title: "زمان(دقیقه)",canEdit:true, filterOnKeypress: true,keyPressFilter: "[0-9.]",editEvent: "click",
            }

        ]
    });


    function loadExamResult(recordList) {

        let ListGrid_Result_finalTest = isc.TrLG.create({
            width: "100%",
            height: 700,
            canHover: true,
            dataSource: RestDataSource_Result_FinalTest,
            filterOperator: "iContains",
            filterOnKeypress: false,
            allowAdvancedCriteria: true,
            allowFilterExpressions: true,
            showRecordComponents: true,
            showRecordComponentsByCell: true,
            fields: [
                {name: "cellNumber", title: 'موبایل',align: "center", width: "2%",  hidden: true},
                {name: "surname", title: 'نام',align: "center", width: "10%"},
                {name: "lastName", title: 'نام خانوادگی' ,align: "center", width: "15%"},
                {name: "practicalScore", title: 'نمره عملی' ,align: "center", width: "8%",
                    change: function(form, item, value, oldValue) {
                        setPracticalScoreValue(value, form)
                    },canEdit:true, filterOnKeypress: true,keyPressFilter: "[0-9.]",editEvent: "click"
                },
                {name: "classScore", title: 'نمره کلاسی' ,align: "center", width: "8%",
                    change: function(form, item, value, oldValue) {
                        setClassScoreValue(value, form)
                    },canEdit:true, filterOnKeypress: true,keyPressFilter: "[0-9.]",editEvent: "click"
                },
                {name: "score", title: 'نمره کسب شده دانشجو' ,align: "center", width: "15%"},
                {name: "testResult", title: 'نمره تستی' ,align: "center", width: "10%"},
                {name: "descriptiveResult", title: 'نمره تشریحی' ,align: "center", width: "10%",
 change: function(form, item, value, oldValue) {
                   setDescriptiveResultValue(value, form)
                    },canEdit:true, filterOnKeypress: true,keyPressFilter: "[0-9.]",editEvent: "click",
},
                {name: "finalResult", title: 'نمره نهایی(با ارفاق)' ,align: "center", width: "15%",
 change: function(form, item, value, oldValue) {
                   setFinalResultValue(value, form)
                    },canEdit:true, filterOnKeypress: true,keyPressFilter: "[0-9.]",editEvent: "click",
},
                {name: "resultStatus", title: 'وضعیت فراگیر' ,align: "center", width: "10%"},
                { name: "iconField", title: "نتایج", width: "10%",align:"center"},
                { name: "iconField2", title: "چاپ گزارش", width: "10%",align:"center"},

            ],
            createRecordComponent: function (record, colNum) {
                var fieldName = this.getFieldName(colNum);
                if (fieldName == "iconField") {
                    let button = isc.IButton.create({
                        layoutAlign: "center",
                        title: "پاسخ ها",
                        width: "120",
                        click: function () {
                            if  (record.resultStatus ==="بدون پاسخ") {
                                  createDialog("warning", "دانشجو مورد نظر به سوالی پاسخ نداده است", "اخطار"); }
                            else
                            ListGrid_show_results(record.answers);
                        }
                    });
                    return button;
                }
                else if(fieldName == "iconField2") {
                    let button2 = isc.IButton.create({
                        layoutAlign: "center",
                        title: "چاپ گزارش",
                        width: "120",
                        click: function () {
                               if  (record.resultStatus ==="بدون پاسخ") {
                                  createDialog("warning", "دانشجو مورد نظر به سوالی پاسخ نداده است", "اخطار"); }
                            else
                            printEls("pdf",recordList.id,record.nationalCode,"ElsExam.jasper",record.surname,record.lastName);
                        }
                    });
                    return button2;
                }
                else {
                    return null;
                }
            }
        });
            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest("/training/anonymous/els/examResult/" + recordList.id, "GET", null, function (resp) {
                if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                    let results = JSON.parse(resp.data).data;
                    var OK = isc.Dialog.create({
                        message: "<spring:message code="msg.operation.successful"/>",
                        icon: "[SKIN]say.png",
                        title: "<spring:message code='message'/>"
                    });
                    setTimeout(function () {
                        OK.close();
                    }, 1500);
                    allResultScores=results
                    ListGrid_Result_finalTest.setData(results);
                    hideFields(ListGrid_Result_finalTest,JSON.parse(resp.data).examType,recordList)
                    let Window_result_Finaltest = isc.Window.create({
                        width: "90%",
                        height: 768,
                        keepInParentRect: true,
                        title: "مشاهده نتایج آزمون",
                        items: [
                            isc.VLayout.create({
                                width: "100%",
                                height: "100%",
                                defaultLayoutAlign: "center",
                                align: "center",
                                members: [
                                    isc.HLayout.create({
                                        width: "100%",
                                        height: "90%",
                                        members: [ListGrid_Result_finalTest]
                                    }),
                                    isc.HLayout.create({
                                        width: "100%",
                                        height: "90%",
                                        align: "center",
                                        membersMargin: 10,
                                        members: [
                                            isc.IButtonCancel.create({
                                                click: function () {
                                                Window_result_Finaltest.close();
                                                }
                                            }),
                                            isc.IButtonSave.create({
                    title: "<spring:message code="sendScoreToOnlineExam"/>", width: 300,
                    click: function () {
                      sendFinalScoreToOnlineExam(Window_result_Finaltest);
                    }
                })
                                            ,
                                            isc.IButtonSave.create({
                    title: "<spring:message code="sendScoreToTrainingExam"/>", width: 300,
                    click: function () {

                        if (ListGrid_Result_finalTest.getData().length > 0){
                            for (let i = 0; i < ListGrid_Result_finalTest.getData().length; i++) {
                              let listData=ListGrid_Result_finalTest.getData().get(i);
                            let testResult=    ((listData.testResult === undefined || listData.testResult === null || listData.testResult === "-") ? "0" : listData.testResult);
                            let descriptiveResult=    ((listData.descriptiveResult === undefined || listData.descriptiveResult === null || listData.descriptiveResult === "-") ? "0" : listData.descriptiveResult);
                            let practicalScore=    ((listData.practicalScore === undefined || listData.practicalScore === null || listData.practicalScore === "-") ? "0" : listData.practicalScore);
                            let classScore=    ((listData.classScore === undefined || listData.classScore === null || listData.classScore === "-") ? "0" : listData.classScore);

                            let finalScore=parseFloat(testResult)+parseFloat(descriptiveResult)+parseFloat(practicalScore)+parseFloat(classScore);

                                ListGrid_Result_finalTest.setEditValue(i, ListGrid_Result_finalTest.getField("finalResult").masterIndex, finalScore);
                                allResultScores[i].finalResult = finalScore;
                            }
                        }





                    }
                })
                                        ]
                                    })]
                            })
                        ],
                        minWidth: 1024
                    })

                    Window_result_Finaltest.show();
                } else {
                    var ERROR = isc.Dialog.create({
                        message: "<spring:message code='exception.un-managed'/>",
                        icon: "[SKIN]stop.png",
                        title: "<spring:message code='message'/>"
                    });
                    setTimeout(function () {
                        ERROR.close();
                    }, 3000);
                }
                wait.close();
            }))
    }
    var questionData;
    function setScoreValue(value, form) {
        let index = questionData.findIndex(f => f.id === form.values.id)
        questionData[index].score = value;
         totalScore=0;
          form.grid.data.forEach(
    q=>{ if (q.score!== null && q.score !== undefined)
{
totalScore=totalScore+q.score
}
    }
)

scoreLabel.setContents("مجموع بارم وارد شده : "+totalScore)

        }
    function setTimeValue(value, form) {
        let index = questionData.findIndex(f => f.id === form.values.id)
        questionData[index].time = value;
        totalTime=0;
        form.grid.data.forEach(
            q=>{ if (q.time!== null && q.time !== undefined)
            {
                totalTime=totalTime+q.time
            }
            }
        )

        timeLabel.setContents("مجموع زمان وارد شده : "+totalTime)

    }
    function setDescriptiveResultValue(value, form) {

         let index = allResultScores.findIndex(f => f.nationalCode === form.values.nationalCode)
            allResultScores[index].descriptiveResult = value;

        }
    function setClassScoreValue(value, form) {

        let index = allResultScores.findIndex(f => f.nationalCode === form.values.nationalCode)
        allResultScores[index].classScore = value;

    }
    function setPracticalScoreValue(value, form) {

        let index = allResultScores.findIndex(f => f.nationalCode === form.values.nationalCode)
        allResultScores[index].practicalScore = value;

    }
    function setFinalResultValue(value, form) {
   let index = allResultScores.findIndex(f => f.nationalCode === form.values.nationalCode)
            allResultScores[index].finalResult = value;
        }
    function loadExamForScores(record) {

        var ListGrid_Questions_finalTest = isc.ListGrid.create({
            width: "100%",
            height: 600,

            dataSource: RestDataSource_Questions_finalTest,
            showRecordComponents: true,
            showRecordComponentsByCell: true,
            initialSort: [
                {property: "id", direction: "ascending", primarySort: true}
            ],
            fields: [
                 {name: "id",hidden:true},
                {name: "question", title: 'سوال',  width: "20%"},
                {name: "type", title: 'نوع پاسخ' , width: "10%"},
                { name: "options", title: "گزینه ها", width: "20%",align:"center"},
                { name: "proposedPointValue",type: "float", title: "<spring:message code="question.bank.proposed.point.value"/>", width: "10%",align:"center"},
                { name: "score",type: "float", title: "بارم", width: "10%", align:"center", change: function(form, item, value, oldValue) {
                   setScoreValue(value, form)
                    },canEdit:true, filterOnKeypress: true,keyPressFilter: "[0-9.]",editEvent: "click",
                },
                { name: "time",type: "long", title: "زمان(دقیقه)", width: "10%", align:"center", change: function(form, item, value, oldValue) {
                        setTimeValue(value, form)
                    },canEdit:true, filterOnKeypress: true,keyPressFilter: "[0-9.]",editEvent: "click" ,
                }
            ]
        });

            wait.show();
        let testQuestionType = record.testQuestionType;
        isc.RPCManager.sendRequest(TrDSRequest(questionBankTestQuestionUrl + "/" + testQuestionType + "/" + record.tclass.id + "/spec-list", "GET", null, function (resp) {
                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                            let result = JSON.parse(resp.httpResponseText).response.data;
                              wait.close();
                              wait.show();
                              var examData = {
                                  examItem : record,
                                  questions: result
                                };
                            let questionTypeParam;
                            if (testQuestionType === "PreTest") {
                                questionTypeParam = "preExamQuestions"
                            } else if (testQuestionType === "FinalTest") {
                                questionTypeParam = "examQuestions"
                            }
                            isc.RPCManager.sendRequest(TrDSRequest("/training/anonymous/els/" + questionTypeParam, "POST", JSON.stringify(examData), function (resp) {
                                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                    let results = JSON.parse(resp.data).data;
                    var OK = isc.Dialog.create({
                        message: "<spring:message code="msg.operation.successful"/>",
                        icon: "[SKIN]say.png",
                        title: "<spring:message code='message'/>"
                    });
                    setTimeout(function () {
                        OK.close();
                    }, 1500);
                  questionData = results;
                  ListGrid_Questions_finalTest.setData(results);

                    let Window_result_Finaltest = isc.Window.create({
                        width: 1024,
                        height: 668,
                        keepInParentRect: true,
                        title: "ارسال آزمون به آزمون آنلاین",
                        items: [
                            isc.VLayout.create({
                                width: "100%",
                                height: "100%",
                                defaultLayoutAlign: "center",
                                align: "center",
                                members: [
                                       isc.Label.create({

              contents: "<br/> <span style='color: #000000; font-weight: bold; font-size: large'>برای ارسال آزمون به سیستم آزمون آنلاین لطفا بارم هر سوال را در مقابل آن بنویسید و در نهایت دکمه ارسال آزمون را بزنید</span> <br/>",

                 align: "center",
                padding: 5,
                ID: "totalsLabel_competence"
            }),
                                    isc.VLayout.create({
                                        width: "100%",
                                        height: "70%",
                                        members: [ListGrid_Questions_finalTest,classScoreLabel,scoreLabel,timeLabel]
                                    }),

                                    isc.HLayout.create({
                                        width: "100%",
                                        height: "90%",
                                        align: "center",
                                        membersMargin: 10,
                                        members: [
                                            isc.IButtonSave.create({
                                                layoutAlign: "center",
                                                title: "ارسال به آزمون آنلاین",
                                                width: "140",
                                                click: async function () {
                                                    questionData.map(item => {
                                                        if(!item.score)
                                                            item.score = '0';
                                                        return item;
                                                        });
                                                    let isValid = await hasEvaluation(record.tclass.id);
                                                    if (!isValid) {
                                                        createDialog("info", '<spring:message code="class.has.no.evaluation"/>', "<spring:message code="error"/>");
                                                        return;
                                                    }
                                                    isc.RPCManager.sendRequest(TrDSRequest("/training/anonymous/els/getClassStudent/"+record.tclass.id, "GET",null, function (resp) {
                                                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {

                                                            let result = JSON.parse(resp.httpResponseText);
                                                            let inValidStudents = [];
                                                            for (let i = 0; i < result.length; i++) {

                                                                let studentData = result[i];
                                                                if (!NCodeAndMobileValidation(studentData.nationalCode, studentData.cellNumber,studentData.gender)) {
                                                                    inValidStudents.add({
                                                                        firstName: studentData.surname,
                                                                        lastName: studentData.lastName
                                                                     });
                                                                }
                                                            }
                                                            if (inValidStudents.length) {
                                                                let DynamicForm_InValid_Students = isc.DynamicForm.create({
                                                                                    width: 600,
                                                                                    height: 100,
                                                                                    padding: 6,
                                                                                    titleAlign: "right",
                                                                                    fields: [
                                                                                        {
                                                                                            name: "text",
                                                                                            width: "100%",
                                                                                            colSpan: 2,
                                                                                            value: "<spring:message code='msg.check.student.mobile.ncode'/>"+" "+"<spring:message code='msg.check.student.mobile.ncode.message'/>",
                                                                                            showTitle: false,
                                                                                            editorType: 'staticText'
                                                                                        },
                                                                                        {
                                                                                            type: "RowSpacerItem"
                                                                                        },
                                                                                        {
                                                                                            name: "invalidNames",
                                                                                            width: "100%",
                                                                                            colSpan: 2,
                                                                                            title: "<spring:message code="title"/>",
                                                                                            showTitle: false,
                                                                                            editorType: 'textArea',
                                                                                            canEdit: false
                                                                                        }
                                                                                    ]
                                                                                });
                                                                let names = "";
                                                                for (var j = 0; j < inValidStudents.length; j++) {
                                                                    names = names.concat(inValidStudents[j].firstName + " " + inValidStudents[j].lastName  + "\n");
                                                                 }
                                                                DynamicForm_InValid_Students.setValue("invalidNames", names);

                                                                let Window_InValid_Students = isc.Window.create({
                                                                                    width: 600,
                                                                                    height: 150,
                                                                                    numCols: 2,
                                                                                    title: "<spring:message code='invalid.students.window'/>",
                                                                                    items: [
                                                                                        DynamicForm_InValid_Students,
                                                                                        isc.MyHLayoutButtons.create({
                                                                                        members: [
                                                                                            isc.IButtonSave.create({
                                                                                            title: "<spring:message code="continue"/>",
                                                                                            click: function () {
                                                                                             loadExamQuestions(record,questionData,Window_result_Finaltest, ListGrid_Questions_finalTest.data)
                                                                                                Window_InValid_Students.close();
                                                                                            }}),
                                                                                            isc.IButtonCancel.create({
                                                                                            title: "<spring:message code="cancel"/>",
                                                                                            click: function () {
                                                                                                Window_InValid_Students.close();
                                                                                            }
                                                                                        })],
                                                                                    })]
                                                                                });
                                                                Window_InValid_Students.show();
                                                            } else {
                                                                loadExamQuestions(record,questionData,Window_result_Finaltest, ListGrid_Questions_finalTest.data)
                                                            }
                                                        }
                                                    }));
                                                }
                                            }),
                                            isc.IButtonCancel.create({
                                                layoutAlign: "center",
                                                click: function () {
                                                Window_result_Finaltest.close();
                                                }
                                            })
                                        ]
                                    })]
                            })
                        ],
                        minWidth: 1024
                    });

                                        if (testQuestionType === "PreTest") {
                                            ListGrid_Questions_finalTest.getField("time").hidden = true
                                            timeLabel.setVisibility(false);
                                        } else if (testQuestionType === "FinalTest") {
                                            timeLabel.setVisibility(true);
                                            totalScore = 0;
                                            scoreLabel.setContents("مجموع بارم وارد شده :")
                                            totalTime = 0;
                                            timeLabel.setContents("مجموع زمان وارد شده :")
                                        }

                                        Window_result_Finaltest.show();
                } else {
                   let errorResponseMessage = resp.httpResponseText;
                    var ERROR = isc.Dialog.create({
                        message: errorResponseMessage,
                        icon: "[SKIN]stop.png",
                        title: "<spring:message code='message'/>"
                    });
                    setTimeout(function () {
                        ERROR.close();
                    }, 8000);
                }
                wait.close();

                             }))

                        } else {
                            wait.close();
                            createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                        }
                    }))
    }
    function printFullClearForm(id) {
          wait.show();
            isc.RPCManager.sendRequest(TrDSRequest("/training/anonymous/els/getExamReport/" +id, "GET", null, function (resp) {
                <%--if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {--%>
                <%--    wait.close();--%>
                <%--} else {--%>
                <%--    var ERROR = isc.Dialog.create({--%>
                <%--        message: "<spring:message code='exception.un-managed'/>",--%>
                <%--        icon: "[SKIN]stop.png",--%>
                <%--        title: "<spring:message code='message'/>"--%>
                <%--    });--%>
                <%--    setTimeout(function () {--%>
                <%--        ERROR.close();--%>
                <%--    }, 8000);--%>
                <%--}--%>
                wait.close();
    }));

    }
    function printPdf(type,id,national,fileName,name,last ) {
          wait.show();
            isc.RPCManager.sendRequest(TrDSRequest("/training/anonymous/els/printPdf/" +id+"/"+national+"/"+name+"/"+last+"/"+"exam", "POST", null, function (resp) {
                <%--if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {--%>
                <%--    wait.close();--%>
                <%--} else {--%>
                <%--    var ERROR = isc.Dialog.create({--%>
                <%--        message: "<spring:message code='exception.un-managed'/>",--%>
                <%--        icon: "[SKIN]stop.png",--%>
                <%--        title: "<spring:message code='message'/>"--%>
                <%--    });--%>
                <%--    setTimeout(function () {--%>
                <%--        ERROR.close();--%>
                <%--    }, 8000);--%>
                <%--}--%>
                wait.close();
    }));



        <%--     var criteriaForm = isc.DynamicForm.create({--%>
        <%--    method: "POST",--%>
        <%--    action: "<spring:url value="training/anonymous/els/printPdf/"/>" + type,--%>
        <%--    target: "_Blank",--%>
        <%--    canSubmit: true,--%>
        <%--    fields:--%>
        <%--        [--%>
        <%--            {name: "id", id: "hidden"},--%>
        <%--            {name: "national", type: "hidden"},--%>
        <%--            {name: "fileName", type: "hidden"},--%>
        <%--            {name: "fullName", type: "hidden"}--%>
        <%--        ]--%>
        <%--});--%>
        <%--criteriaForm.setValue("id", id);--%>
        <%--criteriaForm.setValue("national", national);--%>
        <%--criteriaForm.fileName("fileName", fileName);--%>
        <%--criteriaForm.setValue("fullName", name +" "+last);--%>
        <%--criteriaForm.show();--%>
        <%--criteriaForm.submitForm();--%>

    }
    function ListGrid_show_results(answers) {

        let dynamicForm_Answers_List = isc.DynamicForm.create({
                padding: 6,
                numCols: 1,
                values: {},
                styleName: "answers-form",
                height:768,
                fields: []
                });
        for(var i=0 ; i<answers.length; i++) {
                let text_FormItem = { title:"Pasted value",cellStyle: 'text-exam-form-item',disabled:false, titleOrientation: "top", name:"textArea", width:"100%",height:100, editorType: "TextAreaItem", value: ''};
                // let text_FormItem = { title:"Pasted value",disabled:false,canEdit: false, titleOrientation: "top", name:"textArea", width:"100%",height:100, editorType: "TextAreaItem", value: ''};
                let radio_FormItem =  { name: "startMode", cellStyle: 'radio-exam-form-item', disabled:true,titleOrientation: "top", title: "Initially show ColorPicker as",
                        width: "100%",
                        type: "radioGroup",
                        valueMap: {}
                    };

                let correctAnswer="<span class=\"correctAnswer\"></span>";
                if (answers[i].examinerAnswer!==null && answers[i].examinerAnswer!==undefined)
                  correctAnswer = "<div class=\"correctAnswer\" ><span>"+customSplit(answers[i].examinerAnswer, 150)+"</span></div>";
                else
                correctAnswer = "<span class=\"correctAnswer\">جوابی برای این سوال توسط استاد ثبت نشده</span>";

                      let mark="<span class=\"mark\"></span>";
                if (answers[i].mark!==null && answers[i].mark!==undefined)
                  mark = "<div class=\"mark\" ><span>"+" ( "+answers[i].mark +" نمره ) "+"</span></div>";
                else
                mark = "<span class=\"mark\">( بارم ثبت نشده )</span>";


            let files="<span class=\"files\"></span>";
            let answerFiles="<span class=\"files\"></span>";
            let option1Files="<span class=\"files\"></span>";
            let option2Files="<span class=\"files\"></span>";
            let option3Files="<span class=\"files\"></span>";
            let option4Files="<span class=\"files\"></span>";
            let token="<%=accessToken%>";


            if (answers[i].answerFiles!==null && answers[i].answerFiles!==undefined)
            {
                 let answerFilesData=" ";

                for(let key in answers[i].answerFiles)
                {
                    answerFilesData+=" "
                    answerFilesData+="<a href=\""+downloadFiles+answers[i].answerFiles[key] + "/"+ key + "/"+ token + "/\" target=\"_blank\"> فایل جواب - </a>"
                }
                answerFiles=answerFilesData;
            }
            if (answers[i].files!==null && answers[i].files!==undefined)
            {
                let filesData=" ";

                for(let key in answers[i].files)
                {
                    filesData+=" "
                    filesData+="<a href=\""+downloadFiles+answers[i].files[key] + "/"+ key + "/"+ token + "/\" target=\"_blank\"> فایل سوال - </a>"
                }
                files=filesData;
            }

            // show option1
            if (answers[i].option1Files!==null && answers[i].option1Files!==undefined)
            {
                let option1FilesData=" ";

                for(let key in answers[i].option1Files)
                {
                    option1FilesData+=" "
                    option1FilesData+="<a href=\""+downloadFiles+answers[i].option1Files[key] + "/"+ key + "/"+ token + "/\" target=\"_blank\"> فایل گزینه اول - </a>"
                }
                option1Files=option1FilesData;
            }

            ///            // show option2


            if (answers[i].option2Files!==null && answers[i].option2Files!==undefined)
            {
                let option2FilesData=" ";

                for(let key in answers[i].option2Files)
                {
                    option2FilesData+=" "
                    option2FilesData+="<a href=\""+downloadFiles+answers[i].option2Files[key] + "/"+ key + "/"+ token + "/\" target=\"_blank\"> فایل گزینه دوم - </a>"
                }
                option2Files=option2FilesData;
            }

            ///            // show option3


            if (answers[i].option3Files!==null && answers[i].option3Files!==undefined)
            {
                let option3FilesData=" ";

                for(let key in answers[i].option3Files)
                {
                    option3FilesData+=" "
                    option3FilesData+="<a href=\""+downloadFiles+answers[i].option3Files[key] + "/"+ key + "/"+ token + "/\" target=\"_blank\"> فایل گزینه سوم - </a>"
                }
                option3Files=option3FilesData;
            }

            ///            // show option4


            if (answers[i].option4Files!==null && answers[i].option4Files!==undefined)
            {
                let option4FilesData=" ";

                for(let key in answers[i].option4Files)
                {
                    option4FilesData+=" "
                    option4FilesData+="<a href=\""+downloadFiles+answers[i].option4Files[key] + "/"+ key + "/"+ token + "/\" target=\"_blank\"> فایل گزینه چهارم - </a>"
                }
                option4Files=option4FilesData;
            }



            text_FormItem.title = (i+1)+"-"+ customSplit(answers[i].question, 150)  +"   "+mark+" "+files+ "\n"+answerFiles+ "\n"
            +" جواب استاد :"+ "\n"+ "  "+correctAnswer+ "\n";

                text_FormItem.value = answers[i].answer;
                text_FormItem.name = answers[i].answer;

                if(answers[i].type === "چند گزینه ای") {
                    radio_FormItem.title = (i+1)+"-"+customSplit(answers[i].question, 150)+"   "+mark+" "+files+ "\n"+answerFiles+ "\n"+option1Files+ "\n"+option2Files+ "\n"+option3Files+ "\n"+option4Files+ "\n"+ " جواب استاد :"+  "\n"+ "  "+correctAnswer;
                    radio_FormItem.name = i+"";
                    if(answers[i].options.length > 0) {
                        for(let j = 0; j< answers[i].options.length; j++){
                            let key = answers[i].options[j].title;
                            let value = answers[i].options[j].title;
                            radio_FormItem.valueMap[key] = value;
                        }
                    }

                    dynamicForm_Answers_List.addField(radio_FormItem)
                    if(radio_FormItem.valueMap.hasOwnProperty(answers[i].answer)) {
                         dynamicForm_Answers_List.getField(i).setValue(answers[i].answer);
                    }
               } else {
                    dynamicForm_Answers_List.addField(text_FormItem)
                      }
            }
        let Window_result_Answer_FinalTest = isc.Window.create({
            width: 1024,
            height: 768,
            keepInParentRect: true,
            title: "مشاهده پاسخ ها",
            autoSize: false,
            isModal: true,
            autoDraw: true,
            overflow: "auto",
            items: [
             isc.VLayout.create({
                    width: "100%",
                    height: "100%",
                    defaultLayoutAlign: "center",
                    align: "center",
                    members: [
                        isc.HLayout.create({
                            width: "100%",
                            height: "100%",
                            overflow: "auto",
                            styleName: "hLayout-scrollable",
                            autoDraw: false,
                            members: [
                                dynamicForm_Answers_List
                            ]
                        }),
                        isc.IButtonCancel.create({
                            click: function () {
                                Window_result_Answer_FinalTest.close();
                            }
                        })
                    ]
                })
            ]
        });
            Window_result_Answer_FinalTest.show();
    }
    function checkExamScore(examData) {
        let classScore=(examData.examItem.classScore !==undefined && examData.examItem.classScore !==null)?strToNumber(examData.examItem.classScore):0;
        let practicalScore=(examData.examItem.practicalScore !==undefined && examData.examItem.practicalScore !==null)?strToNumber(examData.examItem.practicalScore):0;
        let sum = (+classScore) + (+practicalScore);

        if (examData.examItem.tclass.scoringMethod === "3" || examData.examItem.tclass.scoringMethod === "2") {

            let totalScore = 0;
            for(var i = 0; i < examData.questionData.length; i++) {

                let score = examData.questionData[i].score;
                if (Number(score)!==0)
                totalScore = totalScore + Number(score);
                else
                       return false;

            }
            if (examData.examItem.tclass.scoringMethod === "3") {
                return  totalScore === 20-(sum);
            } else {
                return totalScore === 100-(sum);
            }
        } else {
            return false;
        }
    }
    function checkExamDuration(examData, questionsList) {
        let duration=examData.examItem.duration;
        let totalTime = 0;
        for (let i = 0; i < questionsList.length; i++) {
            if (questionsList[i].time !== undefined) {
                let time = questionsList[i].time;
                totalTime = totalTime + Number(time);
            }
        }

        if (totalTime !== 0) {
            for (let i = 0; i < questionsList.length; i++) {
                if ((questionsList[i].time === undefined || questionsList[i].time === 0 ) && totalTime!==0) {
                    return false;
                }
            }
        }

        if (totalTime === 0 )
            return true;
        else if (Number(duration) === totalTime) {
            return true;
        } else
            return false;
    }
    function checkExamValidation (examData, questionsList) {

        let validationData = {
            isValid: true,
            message: ""
        };

        if(!examData.questions || examData.questions.length === 0) {

            validationData.isValid = false;
            validationData.message = validationData.message.concat("آزمون سوال ندارد!");
        } else if (!examData.examItem.tclass.teacherId) {

            validationData.isValid = false;
            validationData.message = validationData.message.concat("<spring:message code='msg.check.class.teacher'/>");
        } else if (!checkExamScore(examData)) {

            validationData.isValid = false;
            validationData.message = validationData.message.concat("بارم بندی آزمون صحیح نمی باشد");
        }else if(!checkExamDuration(examData, questionsList)){
            validationData.isValid = false;
            validationData.message = validationData.message.concat("زمان بندی آزمون صحیح نمی باشد");
        }
        return validationData;
    }
    function loadExamQuestions(record,questionData,dialog, questionsList) {

            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(questionBankTestQuestionUrl +"/test/"+record.tclass.id+ "/spec-list-final-test", "GET",null, function (resp) {
                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                    let result = JSON.parse(resp.httpResponseText);
                    var examData = {
                    examItem : record,
                    questions: result,
                    absentUsers: [],
                    deleteAbsentUsers: false,
                    questionData: questionData
                    };
                    let validationData = checkExamValidation(examData, questionsList);


                    if (validationData.isValid) {
                        isc.RPCManager.sendRequest(TrDSRequest( attendanceUrl + "/studentAbsentSessionsInClass?classId="+record.tclass.id, "GET", null, res => {

                            if (res.httpResponseCode === 200) {

                                let result = JSON.parse(res.httpResponseText);

                                for (let i = 0; i < result.size(); i++) {
                                    let item = {};
                                    item.surname = result[i].surname;
                                    item.lastName = result[i].lastName;
                                    item.nationalCode = result[i].nationalCode;
                                    item.cellNumber = result[i].cellNumber;
                                    item.gender = result[i].gender;


                                    examData.absentUsers.add(item);
                                }
                                 if (result.size()>0)
                                {

                                    let DynamicForm_InValid_Students = isc.DynamicForm.create({
                                        width: 600,
                                        height: 100,
                                        padding: 6,
                                        titleAlign: "right",
                                        fields: [
                                            {
                                                name: "text",
                                                width: "100%",
                                                colSpan: 2,
                                                value: "<spring:message code='absent.students.description'/>",
                                                showTitle: false,
                                                editorType: 'staticText'
                                            },
                                            {
                                                type: "RowSpacerItem"
                                            },
                                            {
                                                name: "invalidNames",
                                                width: "100%",
                                                colSpan: 2,
                                                title: "<spring:message code="title"/>",
                                                showTitle: false,
                                                editorType: 'textArea',
                                                canEdit: false
                                            }
                                        ]
                                    });

                                    let names = "";
                                    for (var j = 0; j < result.length; j++) {

                                        names = names.concat(result[j].surname + " " + result[j].lastName  + "\n");
                                    }
                                    DynamicForm_InValid_Students.setValue("invalidNames", names);

                                    let Window_InValid_Students = isc.Window.create({
                                        width: 600,
                                        height: 150,
                                        numCols: 2,
                                        title: "<spring:message code='absent.students.window'/>",
                                        items: [
                                            DynamicForm_InValid_Students,
                                            isc.MyHLayoutButtons.create({
                                                members: [
                                                    isc.IButtonSave.create({
                                                        title: "<spring:message code="yes"/>",
                                                        click: function () {
                                                            examData.deleteAbsentUsers=false;
                                                            Window_InValid_Students.close();
                                                            callApiForSendExam(examData,dialog);
                                                        }
                                                    }),
                                                    isc.IButtonCancel.create({
                                                        title: "<spring:message code="no"/>",
                                                        click: function () {
                                                            examData.deleteAbsentUsers=true;
                                                            Window_InValid_Students.close();
                                                            callApiForSendExam(examData,dialog);
                                                        }
                                                    })
                                                ],
                                            })]
                                    });
                                    Window_InValid_Students.show();
                                }
                            }
                            else
                            {
                               callApiForSendExam(examData,dialog);
                            }
                        }));



                    } else {
                        wait.close();
                        createDialog("info", validationData.message, "<spring:message code="error"/>");
                    }
                } else {
                    wait.close();
                    if (resp.httpResponseCode === 405)
                        createDialog("info", "<spring:message code="msg.check.class.multi.choice.question"/>", "<spring:message code="error"/>");
                    else if (resp.httpResponseCode === 404)
                        createDialog("info", "<spring:message code="msg.check.class.teacher.info"/>", "<spring:message code="error"/>");
                    else
                        createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                }
            }));
    }
    // ------------------------------------------- DynamicForm & Window -------------------------------------------
    let FinalTestDF_finalTest = isc.DynamicForm.create({
        ID: "FinalTestDF_finalTest",
        //width: 780,
        overflow: "hidden",
        //autoSize: false,
        fields: [
            {name: "id", hidden: true},
            {
                name: "tclassId",
                title: "<spring:message code="class"/>",
                required: true,
                <%--prompt: "<spring:message code="first.select.course"/>",--%>
                textAlign: "center",
                autoFetchData: false,
                width: "*",
                displayField: "code",
                valueField: "id",
                optionDataSource: ClassDS_finalTest,
                sortField: ["id"],
                filterFields: ["id"],
                //type: "ComboBoxItem",
                pickListFields: [
                    {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
                    {
                        name: "code",
                        title: "<spring:message code='class.code'/>",
                        align: "center",
                        filterOperator: "iContains",
                        autoFitWidth: true
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
                        autoFitWidth: true
                    },
                    {
                        name: "endDate",
                        title: "<spring:message code='end.date'/>",
                        align: "center",
                        filterOperator: "iContains",
                        filterEditorProperties: {
                            keyPressFilter: "[0-9/]"
                        },
                        autoFitWidth: true
                    },
                    {
                        name: "teacher",
                        title: "<spring:message code='teacher'/>",
                        displayField: "teacher.personality.lastNameFa",
                        displayValueFromRecord: false,
                        type: "TextItem",
                        sortNormalizer(record) {
                            return record.teacher.personality.lastNameFa;
                        },

                        align: "center",
                        filterOperator: "iContains",
                        autoFitWidth: true,
                        // sortNormalizer(record) {
                        //     return record.teacher.personality.lastNameFa;
                        // }
                    },
                    {
                        name: "classStatus", title: "<spring:message code='class.status'/>", align: "center",
                        valueMap: {
                            "1": "برنامه ریزی",
                            "2": "در حال اجرا",
                            "3": "پایان یافته",
                        },
                        filterEditorProperties: {
                            pickListProperties: {
                                showFilterEditor: false
                            },
                        },
                        filterOnKeypress: true,
                        autoFitWidth: true,
                    },
                ],
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListWidth: 800,
                icons: [
                    {
                        name: "clear",
                        src: "[SKIN]actions/remove.png",
                        width: 15,
                        height: 15,
                        inline: true,
                        prompt: "پاک کردن",
                        click: function (form, item, icon) {
                            item.clearValue();
                            item.focusInItem();

                        }
                    }
                ],
                endRow: true,
                startRow: false,

                changed: function (form, item, value) {
                    //DynamicForm_course_GroupTab.getItem("code").setValue(courseCode());
                }
            },
            {
                name: "date",
                ID: "date_FinalTest",
                title: "<spring:message code='test.question.start.date'/>",
                required: true,
                width: "*",
                defaultValue: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function ()
                    {
                        closeCalendarWindow();
                        displayDatePicker('date_FinalTest', this, 'ymd', '/');
                    }
                }],
                changed: function (form, item, value) {
                    if (value == null || value === "" || checkDate(value))
                        item.clearErrors();
                    else
                        item.setErrors("<spring:message code='msg.correct.date'/>");
                }
            },
            {
                name: "time",
                title: "<spring:message code="test.question.time"/>",
                required: true,
                requiredMessage: "<spring:message code="msg.field.is.required"/>",
                hint: "--:--",
                defaultValue: "08:00",
                keyPressFilter: "[0-9:]",
                showHintInField: true,
                textAlign: "center",
                validateOnChange: true,
                validators: [{
                    type: "isString",
                    validateOnExit: true,
                    type: "lengthRange",
                    min: 5,
                    max: 5,
                    stopOnError: true,
                    errorMessage: "زمان مجاز بصورت 08:30 است"
                },
                {
                    type: "regexp",
                    expression: "^(([0-1][0-9]|2[0-3]):([0-5][0-9]))$",
                    validateOnChange: true,
                    errorMessage: "ساعت 23-0 و دقیقه 59-0"
                }
                ],
                length:5,
                editorExit:function(){
                    DynamicForm_Session.setValue("time",arrangeDate(DynamicForm_Session.getValue("time")));
                    let val=DynamicForm_Session.getValue("time");
                    if(val===null || val==='' || typeof (val) === 'undefined'|| !val.match(/^(([0-1][0-9]|2[0-3]):([0-5][0-9]))$/)){
                        DynamicForm_Session.addFieldErrors("time", "<spring:message code="session.hour.invalid"/>", true);
                    }else{
                        DynamicForm_Session.clearFieldErrors("time", true);
                    }
                }
            },
            {
                name: "endDate",
                ID: "end_date_FinalTest",
                title: "<spring:message code='test.question.end.date'/>",
                required: true,
                width: "*",
                defaultValue: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('end_date_FinalTest', this, 'ymd', '/');
                    }
                }],
                changed: function (form, item, value) {
                    if (value == null || value === "" || checkDate(value))
                        item.clearErrors();
                    else
                        item.setErrors("<spring:message code='msg.correct.date'/>");
                }
            },
            {
                name: "endTime",
                title: "<spring:message code="test.question.end.time"/>",
                required: true,
                requiredMessage: "<spring:message code="msg.field.is.required"/>",
                hint: "--:--",
                defaultValue: "09:00",
                keyPressFilter: "[0-9:]",
                showHintInField: true,
                textAlign: "center",
                validateOnChange: true,
                validators: [{
                    type: "isString",
                    validateOnExit: true,
                    type: "lengthRange",
                    min: 5,
                    max: 5,
                    stopOnError: true,
                    errorMessage: "زمان مجاز بصورت 08:30 است"
                },
                    {
                        type: "regexp",
                        expression: "^(([0-1][0-9]|2[0-3]):([0-5][0-9]))$",
                        validateOnChange: true,
                        errorMessage: "ساعت 23-0 و دقیقه 59-0"
                    }
                ],
                length:5,
                editorExit:function(){
                    DynamicForm_Session.setValue("time",arrangeDate(DynamicForm_Session.getValue("time")));
                    let val=DynamicForm_Session.getValue("time");
                    if(val===null || val==='' || typeof (val) === 'undefined'|| !val.match(/^(([0-1][0-9]|2[0-3]):([0-5][0-9]))$/)){
                        DynamicForm_Session.addFieldErrors("time", "<spring:message code="session.hour.invalid"/>", true);
                    }else{
                        DynamicForm_Session.clearFieldErrors("time", true);
                    }
                }
            },
            {
                name: "duration",
                title: "<spring:message code='test.question.duration'/>",
                required: true,
                type: "IntegerItem",
                keyPressFilter: "[0-9]",
                hint: "<spring:message code='test.question.duration.hint'/>",
                showHintInField: true,
                length: 3
            }
            , {
                name: "practicalScore",
                title: "نمره عملی",
                // hidden: true,
                 keyPressFilter: "[0-9.]",
                length: 5
            },
            {
                name: "classScore",
                title: "نمره کلاسی",
                // hidden: true,
                 keyPressFilter: "[0-9.]",
                length: 5
            },


        ]
    });

    let preTestDF = isc.DynamicForm.create({
        overflow: "hidden",
        fields: [
            {name: "id", hidden: true},
            {
                name: "tclassId",
                title: "<spring:message code="class"/>",
                required: true,
                textAlign: "center",
                autoFetchData: false,
                width: "*",
                displayField: "code",
                valueField: "id",
                optionDataSource: ClassDS_finalTest,
                sortField: ["id"],
                filterFields: ["id"],
                pickListFields: [
                    {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
                    {
                        name: "code",
                        title: "<spring:message code='class.code'/>",
                        align: "center",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "course.titleFa",
                        title: "<spring:message code='course.title'/>",
                        align: "center",
                        filterOperator: "iContains",
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
                        autoFitWidth: true
                    },
                    {
                        name: "endDate",
                        title: "<spring:message code='end.date'/>",
                        align: "center",
                        filterOperator: "iContains",
                        filterEditorProperties: {
                            keyPressFilter: "[0-9/]"
                        },
                        autoFitWidth: true
                    },
                    {
                        name: "teacher",
                        title: "<spring:message code='teacher'/>",
                        displayField: "teacher.personality.lastNameFa",
                        displayValueFromRecord: false,
                        type: "TextItem",
                        sortNormalizer(record) {
                            return record.teacher.personality.lastNameFa;
                        },

                        align: "center",
                        filterOperator: "iContains",
                        autoFitWidth: true,
                        // sortNormalizer(record) {
                        //     return record.teacher.personality.lastNameFa;
                        // }
                    },
                    {
                        name: "classStatus", title: "<spring:message code='class.status'/>", align: "center",
                        valueMap: {
                            "1": "برنامه ریزی",
                            "2": "در حال اجرا",
                            "3": "پایان یافته",
                        },
                        filterEditorProperties: {
                            pickListProperties: {
                                showFilterEditor: false
                            },
                        },
                        filterOnKeypress: true,
                        autoFitWidth: true,
                    },
                    {
                        name: "evaluation",
                        title: "evaluation",
                        align: "center",
                        autoFitWidth: true,
                        hidden: true
                    },
                ],
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListWidth: 800,
                icons: [
                    {
                        name: "clear",
                        src: "[SKIN]actions/remove.png",
                        width: 15,
                        height: 15,
                        inline: true,
                        prompt: "پاک کردن",
                        click: function (form, item, icon) {
                            item.clearValue();
                            item.focusInItem();

                        }
                    }
                ],
                endRow: true,
                startRow: false,
                click(form, item) {
                    let criteria = {
                        _constructor: "AdvancedCriteria",
                        operator: "and",
                        criteria: [
                            {fieldName: "evaluation", operator: "inSet", value: ["2", "3", "4"]}]
                    };
                    item.pickListCriteria = criteria;
                    item.fetchData();
                }
            }
        ]
    });

    let examTypeDF = isc.DynamicForm.create({
        titleAlign: "right",
        fields: [
            {
                name: "examType",
                title: "<spring:message code="test.question.type"/>",
                type: "SelectItem",
                operator: "inSet",
                required: true,
                multiple: false,
                valueMap: {
                    "1": "<spring:message code="evaluation.final.test"/>",
                    "2": "<spring:message code="class.preCourseTest"/>"
                },
                pickListProperties: {
                    showFilterEditor: false
                },
                defaultValue: ["1"]
            }
        ]
    });

    let HLayout_Select_Exam_Type_buttons = isc.TrHLayoutButtons.create({
        alignLayout: "bottom",
        height: "5%",
        membersMargin: 10,
        members: [
            isc.IButtonSave.create({
                title: "<spring:message code="verify"/>",
                click: function () {
                    showCreateExamConfirmationDialog();
                }
            }),
            isc.IButtonCancel.create({
                click: function () {
                    examTypeDF.clearValues();
                    selectExamTypeWindow.close();
                }
            })
        ]
    })

    let FinalTestWin_finalTest = isc.Window.create({
        width: 500,
        height: 400,
        //autoCenter: true,
        overflow: "hidden",
        showMaximizeButton: false,
        autoSize: false,
        canDragResize: false,
        items: [FinalTestDF_finalTest, isc.TrHLayoutButtons.create({
            members: [
                isc.TrSaveBtn.create({
                    click: function () {
                        checkExamDate()
                    }
                }),
                isc.TrCancelBtn.create({
                    click: function () {
                        FinalTestWin_finalTest.close();
                    }
                })
            ]
        })]
    });

    let preTestWindow = isc.Window.create({
        title: "<spring:message code="select.pre.test.question.type"/>",
        width: "20%",
        height: "15%",
        //autoCenter: true,
        overflow: "hidden",
        showMaximizeButton: false,
        autoSize: false,
        canDragResize: false,
        items: [
            preTestDF,
            isc.TrHLayoutButtons.create({
                members: [
                    isc.TrSaveBtn.create({
                        click: function () {
                            if (!preTestDF.validate()) {
                                return;
                            }

                            let classId = preTestDF.getField("tclassId").getValue();
                            createPreTest(classId);
                        }
                    }),
                    isc.TrCancelBtn.create({
                        click: function () {
                            preTestWindow.close();
                        }
                    })
                ]
            })]
    });

    let selectExamTypeWindow = isc.Window.create({
        title: "<spring:message code="select.test.question.type"/>",
        width: "20%",
        height: "20%",
        align: "center",
        autoSize: false,
        showMaximizeButton: false,
        dismissOnEscape: true,
        items: [examTypeDF, HLayout_Select_Exam_Type_buttons]
    });

    // ------------------------------------------- TabSet -------------------------------------------
    var TabSet_finalTest = isc.TabSet.create({
        enabled: false,
        tabBarPosition: "top",
        tabs: [
            {
                ID: "finalTestQuestionBank",
                name: "finalTestQuestionBank",
                title: "<spring:message code="questions"/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "evaluation-final-test/questions/show-form"})
            },
            {
                ID: "resendFinalTest",
                name: "resendFinalTest",
                title: "<spring:message code="resend.final.test"/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "evaluation-final-test/resend-final-exam-form"})
            },
            {
                ID: "monitoringFinalTest",
                name: "monitoringFinalTest",
                title: "<spring:message code="monitoring.final.test"/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "evaluation-final-test/monitoring-final-exam-form"})
            }
        ],
        tabSelected: function (tabNum, tabPane, ID, tab, name) {
            if (isc.Page.isLoaded())
                refreshSelectedTab_class_final(tab);
                if (TabSet_finalTest.getSelectedTab().ID === 'resendFinalTest'){
                    if (FinalTestLG_finalTest.getSelectedRecord().onlineFinalExamStatus === false){
                        resendFinalExam_DynamicForm.getItem("time").setDisabled(true);
                        resendFinalExam_DynamicForm.getItem("startDate").setDisabled(true);
                        resendFinalExam_DynamicForm.getItem("duration").setDisabled(true);
                        <sec:authorize access="hasAuthority('FinalTest_Send')">
                        resendFinalExam_DynamicForm.getItem("sendBtn").setDisabled(true);
                        </sec:authorize>
                    } else {
                        resendFinalExam_DynamicForm.getItem("time").setDisabled(false);
                        resendFinalExam_DynamicForm.getItem("startDate").setDisabled(false);
                        resendFinalExam_DynamicForm.getItem("duration").setDisabled(false);
                        <sec:authorize access="hasAuthority('FinalTest_Send')">
                        resendFinalExam_DynamicForm.getItem("sendBtn").setDisabled(false);
                        </sec:authorize>
                    }
                }
        }
    });

        function refreshSelectedTab_class_final(tab) {
        let classRecord = FinalTestLG_finalTest.getSelectedRecord();
        if (!(classRecord == undefined || classRecord == null)) {
            switch (tab.ID) {
                case "resendFinalTest": {
                    if (typeof loadPage_student_resend !== "undefined")
                        loadPage_student_resend();
                    break;
                }
                case "finalTestQuestionBank": {
                        loadTab(tab.ID);
                    break;
                }
                case "monitoringFinalTest": {
                    loadPageMonitoring();
                    break;
                }
            }
        }
    }

    // ------------------------------------------- Page UI -------------------------------------------
    let HLayout_Tab_Class = isc.HLayout.create({
        minWidth: "100%",
        width: "100%",
        height: "39%",
        members: [TabSet_finalTest]
    });

    isc.TrVLayout.create({
        members: [FinalTestTS_finalTest, FinalTestLG_finalTest, HLayout_Tab_Class],
    });

    // ------------------------------------------- Functions -------------------------------------------
    function showInvalidUsers (record) {


isc.RPCManager.sendRequest(TrDSRequest("/training/anonymous/els/getClassStudent/"+record.tclass.id, "GET",null, function (resp) {
    loadTab(TabSet_finalTest.getSelectedTab().ID);

    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {

let result = JSON.parse(resp.httpResponseText);

let inValidStudents = [];

                for (let i = 0; i < result.length; i++) {

                    let studentData = result[i];

        if (!NCodeAndMobileValidation(studentData.nationalCode, studentData.cellNumber,studentData.gender)) {

                        inValidStudents.add({
                            firstName: studentData.surname,
                            lastName: studentData.lastName
                        });
                    }
                }

                if (inValidStudents.length) {

                    let DynamicForm_InValid_Students = isc.DynamicForm.create({
                        width: 600,
                        height: 100,
                        padding: 6,
                        titleAlign: "right",
                        fields: [
                            {
                                name: "text",
                                width: "100%",
                                colSpan: 2,
                                value: "<spring:message code='msg.check.student.mobile.ncode'/>"+" "+"<spring:message code='msg.check.student.mobile.ncode.message'/>",
                                showTitle: false,
                                editorType: 'staticText'
                            },
                            {
                                type: "RowSpacerItem"
                            },
                            {
                                name: "invalidNames",
                                width: "100%",
                                colSpan: 2,
                                title: "<spring:message code="title"/>",
                                showTitle: false,
                                editorType: 'textArea',
                                canEdit: false
                            }
                        ]
                    });

                    let names = "";
                    for (var j = 0; j < inValidStudents.length; j++) {

                        names = names.concat(inValidStudents[j].firstName + " " + inValidStudents[j].lastName  + "\n");
                    }
                    DynamicForm_InValid_Students.setValue("invalidNames", names);

                    let Window_InValid_Students = isc.Window.create({
                        width: 600,
                        height: 150,
                        numCols: 2,
                        title: "<spring:message code='invalid.students.window'/>",
                        items: [
                            DynamicForm_InValid_Students,
                            isc.MyHLayoutButtons.create({
                            members: [
                                isc.IButtonCancel.create({
                                title: "<spring:message code="cancel"/>",
                                click: function () {
                                    Window_InValid_Students.close();
                                }
                            })],
                        })]
                    });
                    Window_InValid_Students.show();
                } else {
                    createDialog("info", "در این کلاس فراگیر با اطلاعات ناقص وجود ندارد"); }
                    } }));
                    }
    function refresh_finalTest() {
        DynamicForm_Filter_exam.getField('filter_exam').setValue(null)
        FinalTestLG_finalTest.invalidateCache();
        FinalTestLG_finalTest.fetchData();
        loadTab(TabSet_finalTest.getSelectedTab().ID);
    }

    function showNewForm_finalTest() {
        finalTestMethod_finalTest = "POST";
        FinalTestDF_finalTest.clearValues();
        FinalTestWin_finalTest.setTitle("<spring:message code="create"/>&nbsp;" + "<spring:message code="exam"/>");
        isCopyForm = false;
        FinalTestWin_finalTest.show();
    }

    function showEditForm_finalTest() {
        let record = FinalTestLG_finalTest.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("warning", "<spring:message code='msg.not.selected.record'/>", "<spring:message code="warning"/>");
        // } else  if (record.onlineFinalExamStatus && record.onlineExamDeadLineStatus){
        } else  if (record.onlineFinalExamStatus){
            createDialog("warning", "<spring:message code='msg.can.not.edit.selected.record'/>", "<spring:message code="warning"/>");
        }
        else{
            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(testQuestionUrl + "/" + record.id, "GET", null, result_EditFinalTest));

        }
    }

    function result_EditFinalTest(resp) {

        wait.close();
        if (generalGetResp(resp)) {
            if (resp.httpResponseCode == 200) {
                let record = JSON.parse(resp.data);

                finalTestMethod_finalTest = "PUT";

                FinalTestDF_finalTest.clearValues();

                FinalTestWin_finalTest.setTitle("<spring:message code="edit"/>&nbsp;" + "<spring:message code="exam"/>" + '&nbsp;\'' + record.tclass.course.titleFa + '\'');
                FinalTestDF_finalTest.editRecord(record);
                isCopyForm = false;
                FinalTestWin_finalTest.show();
            } else {
                createDialog("warning", "<spring:message code="exception.server.connection"/>", "<spring:message code="error"/>");
            }
        }
    }

    function saveFinalTest_finalTest() {

        if(validExamTime(FinalTestDF_finalTest))
        {
            if (!FinalTestDF_finalTest.validate()) {
                return;
            }
            let finalTestSaveUrl = testQuestionUrl;
            let finalTestAction = '<spring:message code="created"/>';

            if (finalTestMethod_finalTest.localeCompare("PUT") === 0) {
                let record = FinalTestLG_finalTest.getSelectedRecord();
                finalTestSaveUrl += "/" + record.id;
                finalTestAction = '<spring:message code="edited"/>';
            }
            let data = FinalTestDF_finalTest.getValues();
            if (finalTestMethod_finalTest.localeCompare("POST") === 0) {
                wait.show()
                data.testQuestionType = "FinalTest";
                isc.RPCManager.sendRequest(TrDSRequest(isValidForExam+data.tclassId, "GET",null, function (resp) {
                    let respText = JSON.parse(resp.httpResponseText);
                    if (respText.status === 200) {
                        isc.RPCManager.sendRequest(TrDSRequest(finalTestSaveUrl, finalTestMethod_finalTest,
                            JSON.stringify(data), "callback: rcpResponse(rpcResponse, '<spring:message code="exam"/>', '" + finalTestAction + "')"));
                    } else {
                        wait.close()
                        createDialog("warning", "روش نمره دهی این کلاس بدون آزمون ( بدون نمره , ارزشی ,  و یا عملی ) می باشد و قابلیت ایجاد آزمون آنلاین وجود ندارد", "اخطار");
                    }
                }));
            } else {
                wait.show()
                let data = FinalTestDF_finalTest.getValues();
                isc.RPCManager.sendRequest(TrDSRequest(finalTestSaveUrl, finalTestMethod_finalTest,
                    JSON.stringify(data), "callback: rcpResponse(rpcResponse, '<spring:message code="exam"/>', '" + finalTestAction + "')"));
            }
        }



    }
    async function checkExamDate() {
        let data = FinalTestDF_finalTest.getValues();
if (data.tclassId !== undefined && data.tclassId !== null){
    wait.show()
    let    scoringClassDto= {}
    scoringClassDto.classId=data.tclassId
    scoringClassDto.classScore=(data.classScore !== undefined && data.classScore !== null) ? data.classScore : null
    scoringClassDto.practicalScore=(data.practicalScore !== undefined && data.practicalScore !== null) ? data.practicalScore : null
    isc.RPCManager.sendRequest(TrDSRequest(getClassScoring, "POST", JSON.stringify(scoringClassDto), function (resp) {
        let respText = JSON.parse(resp.httpResponseText);
        if (respText.status === 200) {
            wait.close()
                if (!isCopyForm)
                    saveFinalTest_finalTest();
                else
                    saveCopyTest_finalTest();


        } else {
            wait.close()
            createDialog("info", "جمع نمرات عملی و کلاسی با جمع نمرات کلاس هم خوانی ندارد");
        }
    }));

}else {
    createDialog("info", "ابتدا کلاس را انتخاب کنید");

}
    }

    function showRemoveForm_finalTest() {
        let record = FinalTestLG_finalTest.getSelectedRecord();
        let entityType = '<spring:message code="exam"/>';
        if (checkRecordAsSelected(record, true, entityType)) {

            let dialog = createDialog('ask', "<spring:message code="msg.record.remove.ask"/>");
            dialog.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index == 0) {
                        isc.RPCManager.sendRequest(TrDSRequest(testQuestionUrl + "/" + record.id, "DELETE", null, (resp) => {
                            wait.close();
                            if (generalGetResp(resp)) {
                                if (resp.httpResponseCode == 200) {
                                    let dialog = createDialog("info", "<spring:message code="msg.successfully.done"/>");
                                    Timer.setTimeout(function () {
                                        dialog.close();
                                    }, dialogShowTime);
                                    refresh_finalTest();
                                } else  if (resp.httpResponseCode == 406){
                                    createDialog("warning", "خطا در حذف سوال", "اخطار");
                                }else  if (resp.httpResponseCode == 404){
                                    createDialog("warning", "آزمون در آزمون آنلاین ثبت شده است و امکان حذف وجود ندارد", "اخطار");
                                }
                            }
                        }))
                    }
                }
            })

        }
    };

    function showCopyForm_finalTest() {

        let record = FinalTestLG_finalTest.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("warning", "<spring:message code='msg.not.selected.record'/>", "<spring:message code="warning"/>");
        } else {
            finalTestMethod_finalTest = "POST";
            FinalTestDF_finalTest.clearValues();
            FinalTestWin_finalTest.setTitle("<spring:message code="copy"/>&nbsp;" + "<spring:message code="exam"/>");
            isCopyForm = true;
            FinalTestWin_finalTest.show();
        }
    }

    function saveCopyTest_finalTest() {
        // if(validExamTime(FinalTestDF_finalTest))
        // {
            if (!FinalTestDF_finalTest.validate())
                return;

            let data = FinalTestDF_finalTest.getValues();
            let recordId = FinalTestLG_finalTest.getSelectedRecord().id;
        wait.show()
            isc.RPCManager.sendRequest(TrDSRequest(isValidForExam + data.tclassId, "GET",null, function (resp) {

                let respText = JSON.parse(resp.httpResponseText);
                if (respText.status === 200) {
                    wait.show();
                    isc.RPCManager.sendRequest(TrDSRequest(testQuestionUrl + "/create-copy/" + recordId, finalTestMethod_finalTest, JSON.stringify(data), function (resp) {
                        wait.close();
                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                            let result = JSON.parse(resp.httpResponseText);
                            showOkDialog("آزمون برای (" + result.tclass.course.titleFa + ") کپی شد");
                            refresh_finalTest();
                            FinalTestWin_finalTest.close();
                        } else if (resp.httpResponseCode === 204) {
                            showOkDialog("<spring:message code="exception.duplicate.information"/>");
                        } else {
                            showOkDialog("<spring:message code="exception.data-validation"/>");
                        }
                    }));
                } else {
                    wait.close()
                    createDialog("warning", "روش نمره دهی این کلاس بدون آزمون ( بدون نمره , ارزشی ,  و یا عملی ) می باشد و قابلیت ایجاد آزمون آنلاین وجود ندارد", "اخطار");
                }
            }));
        // }


    }

    function rcpResponse(resp, entityType, action, entityName) {
        wait.close()
        if (generalGetResp(resp)) {
            let respCode = resp.httpResponseCode;
            if (respCode == 200 || respCode == 201) {
                let name;
                if (entityName) {
                    name = entityName;
                } else {
                    name = JSON.parse(resp.data).tclass.titleClass;
                }
                let msg = entityType + '&nbsp;\'<b>' + name + '</b>\'&nbsp;' + action + '.';
                showOkDialog(msg);
                refresh_finalTest();
                FinalTestWin_finalTest.close()
            } else if(respCode == 204) {
                showOkDialog("<spring:message code="exception.duplicate.information"/>");
            }else{
                showOkDialog("<spring:message code="exception.data-validation"/>");
            }

        }
    };

    // To check the 'record' argument is a valid selected record of list grid
    function checkRecordAsSelected(record, flagShowDialog, dialogMsg) {
        if (record ? (record.constructor === Array ? ((record.length > 0) ? true : false) : true) : false) {
            return true;
        }
        if (flagShowDialog) {
            dialogMsg = dialogMsg ? dialogMsg : "<spring:message code="msg.no.records.selected"/>";
            showOkDialog(dialogMsg, 'notify');
        }
        return false;
    };

    // To show an ok dialog
    function showOkDialog(msg, iconName) {
        // createDialog('info', 'info');
        // createDialog('ask', 'ask');
        // createDialog('confirm', 'confirm');
        iconName = iconName ? iconName : 'say';
        // let dialog = isc.TrOkDialog.create({message: msg, icon: "[SKIN]" + iconName + ".png", autoDraw: true});
        let dialog = isc.MyOkDialog.create({message: msg, autoDraw: true});
        Timer.setTimeout(function () {
            dialog.close();
        }, 3000);
    };

    function checkHaveQuestion(res) {
            if(res.data.length == 0) {
            ToolStrip_Actions_FinalTest.members[2].setDisabled(true);
            ToolStrip_Actions_FinalTest.members[3].setDisabled(true);
            }else{
            ToolStrip_Actions_FinalTest.members[2].setDisabled(false);
            ToolStrip_Actions_FinalTest.members[3].setDisabled(false);
            }
        }
    function checkAllowToAddQuestion(record) {
        if(record !== null) {
                if (record.onlineFinalExamStatus === true){
                    <sec:authorize access="hasAuthority('FinalTest_Questions_C')">
                    ToolStrip_Actions_FinalTest.members[0].setDisabled(true);
                    ToolStrip_Actions_FinalTest.members[1].setDisabled(true);
                    </sec:authorize>
                }else {
                    <sec:authorize access="hasAuthority('FinalTest_Questions_C')">
                    ToolStrip_Actions_FinalTest.members[0].setDisabled(false);
                    ToolStrip_Actions_FinalTest.members[1].setDisabled(false);
                    </sec:authorize>
                }
            }


    }



    function loadTab(id) {
        if (FinalTestLG_finalTest.getSelectedRecord() === null) {
            TabSet_finalTest.disable();
            return;
        }
        else {
                      TabSet_finalTest.enable();

}


        switch (id) {
                case "resendFinalTest": {
                    if (typeof loadPage_student_resend !== "undefined")
                        loadPage_student_resend();
                    break;
                }
                case "finalTestQuestionBank": {
                        classId_finalTest = FinalTestLG_finalTest.getSelectedRecord().id;
                        let testQuestionType = FinalTestLG_finalTest.getSelectedRecord().testQuestionType;
                        RestDataSource_FinalTest.fetchDataURL = questionBankTestQuestionUrl + "/" + testQuestionType + "/" + FinalTestLG_finalTest.getSelectedRecord().tclass.id + "/spec-list";
                        ListGrid_FinalTest.invalidateCache();
                        ListGrid_FinalTest.fetchData(null,(res) => {
                        checkHaveQuestion(res);
            });
                    TabSet_finalTest.enable();
                    checkAllowToAddQuestion(FinalTestLG_finalTest.getSelectedRecord());
                    break;
                }
        }
    }

    function sendFinalScoreToOnlineExam(form) {
               wait.show();
            isc.RPCManager.sendRequest(TrDSRequest("/training/anonymous/els/final/test/" +sourceExamId, "POST", JSON.stringify(allResultScores), function (resp) {
                              let respText = JSON.parse(resp.httpResponseText);
                if (respText.status === 200 || respText.status === 201) {
                    form.close();
                    createDialog("info", "ثبت نمرات انجام شد");

                } else {
                                  createDialog("warning", respText.message, "اخطار");

                }
                wait.close();

    }));
}
    function hideFields(form,examType,recordData) {
            switch (examType) {
            case "چند گزینه ای":
                              form.getField("descriptiveResult").hidden = true;
                              form.getField("testResult").hidden = false;

                break;
            case "تشریحی":
                              form.getField("descriptiveResult").hidden = false;
                              form.getField("testResult").hidden = true;
                 break;
            case "تستی-تشریحی":
                              form.getField("descriptiveResult").hidden = false;
                              form.getField("testResult").hidden = false;
                 break;

            default:
                              form.getField("descriptiveResult").hidden = false;
                              form.getField("testResult").hidden = false;

        }
        if (recordData.classScore===undefined || recordData.classScore===null){
            form.getField("classScore").hidden = true;
        }else {
            form.getField("classScore").hidden = false;
        }

        if (recordData.practicalScore===undefined || recordData.practicalScore===null){
            form.getField("practicalScore").hidden = true;
        }else {
            form.getField("practicalScore").hidden = false;
        }

    }
    function validExamTime(form) {
        if (form.getValue("endDate") < form.getValue("date")) {
            createDialog("info", "تاریخ پایان نمی تواند کوچکتر از تاریخ شروع باشد");
            return false;
        }
        if ((form.getValue("endDate") === form.getValue("date")) && (form.getValue("endTime") <= form.getValue("time") ))
        {
            createDialog("info", "ساعت شروع و پایان آزمون معتبر نیستند");
            return false;
        }

        if ((form.getValue("endDate") === form.getValue("date")) &&
            checkDuration(form.getValue("time"),form.getValue("endTime"),form.getValue("duration")))
        {
            createDialog("info", "مدت زمان آزمون کمتر از بازه آزمون می باشد");
            return false;
        }

        return true;
    }

    function NCodeAndMobileValidation(nationalCode, mobileNum,gender) {

        let isValid = true;
        if (nationalCode===undefined || nationalCode===null || mobileNum===undefined || mobileNum===null) {
            isValid = false;
        }
        else {
            if (nationalCode.length !== 10 || !(/^-?\d+$/.test(nationalCode)))
                isValid = false;
            if((mobileNum.length !== 10 && mobileNum.length !== 11) || !(/^-?\d+$/.test(mobileNum)))
                isValid = false;
            if(mobileNum.length === 10 && !mobileNum.startsWith("9"))
                isValid = false;
            if(mobileNum.length === 11 && !mobileNum.startsWith("09"))
                isValid = false;
        }
        return isValid;
    }
    function checkDuration(startTime, endTime,duration) {

        firstHour = parseInt(startTime.split(":")[0]);
        firstMin = parseInt(startTime.split(":")[1]);
        secondHour = parseInt(endTime.split(":")[0]);
        secondMin = parseInt(endTime.split(":")[1]);
        examDuration = duration;
        diffHour=secondHour-firstHour
        diffMin=secondMin-firstMin

        if (diffMin<0)
        {
            diffHour-=1;
            diffMin=60+diffMin;
            if (duration>diffMin+(diffHour*60))
            {
                return true;
            }
        }
        else
        {
            if (duration>diffMin+(diffHour*60))
            {
                return true;
            }
        }
        return false;

    }

    async function hasEvaluation(classId) {
        let criteria = {fieldName: "id", operator: "equals", value: classId};
        let resp = await
            fetch(viewClassDetailUrl + "/iscList?operator=and&_constructor=AdvancedCriteria&criteria=" + JSON.stringify(criteria),
                {headers: {"Authorization": "Bearer <%= (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN) %>"}});
        if (!resp.ok)
            return false;
        const resData = await resp.json();
        if (!resp || !resData.response || !resData.response.data)
            return false;
        const record = resData.response.data[0]
        if (record == null || record.length == 0)
            return false;
        if (!record.classStudentOnlineEvalStatus)
            return false;
        if (!record.classTeacherOnlineEvalStatus)
            return false;
        return true;
        }

    function customSplit(str, maxLength){
    if(str.length <= maxLength)
        return str;
    var reg = new RegExp(".{1," + maxLength + "}","g");
    var parts = str.match(reg);
    return parts.join('\n');
}
    function callApiForSendExam(data,dialog){
           isc.RPCManager.sendRequest(TrDSRequest("/training/anonymous/els/examToEls/test", "POST", JSON.stringify(data), function (resp) {
               if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                   refresh_finalTest();

                   var OK = isc.Dialog.create({
                       message: "<spring:message code="msg.operation.successful"/>",
                       icon: "[SKIN]say.png",
                       title: "<spring:message code='message'/>"
                   });
                   setTimeout(function () {
                       dialog.close();
                       OK.close();
                   }, 2000);
               } else {

                   if (resp.httpResponseCode === 406)
                       createDialog("info","<spring:message code="msg.check.teacher.mobile.ncode"/>"+" "+"<spring:message code="msg.check.teacher.mobile.ncode.message"/>", "<spring:message code="error"/>");
                   else if (resp.httpResponseCode === 404)
                       createDialog("info", "دوره فراگیر ندارد");
                   else if (resp.httpResponseCode === 500)
                       createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                   else
                       createDialog("info",JSON.parse(resp.httpResponseText).message, "<spring:message code="error"/>");
               }
               wait.close();
           }));
}
    function strToNumber(value) {
        // Convert strings to numbers
        if (typeof value === 'string' && !isNaN(Number(value) - parseFloat(value))) {
            return Number(value);
        }
        if (typeof value !== 'number') {
            throw new Error(`${value} is not a number`);
        }
        return value;
    }

    function showCreateExamConfirmationDialog() {
        let examTypeTitle;
        let examTypeValue = examTypeDF.getField("examType").getValue()[0];

        if (examTypeValue === "1")
            examTypeTitle = "<spring:message code="evaluation.final.test"/>"
        else if (examTypeValue === "2")
            examTypeTitle = "<spring:message code="class.preCourseTest"/>"

        let dialog_Accept = createDialog(
            "ask",
            "شما یک ".concat("<b>").concat(examTypeTitle).concat("</b>").concat(" ایجاد می کنید. آیا مطمئن هستید؟"),
            "اخطار"
        );
        dialog_Accept.addProperties({
            buttonClick: function (button, index) {
                examTypeDF.clearValues();
                this.close();
                selectExamTypeWindow.close();
                if (index === 0) {
                    if (examTypeValue === "1") {
                        // final test
                        showNewForm_finalTest();
                    } else if (examTypeValue === "2") {
                        // pre test
                        preTestWindow.show();
                    }
                }
            }
        });
    }

    function createPreTest(classId) {
        let url = testQuestionUrl + "/pre-test/" + classId
        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(url, "POST", null, function (resp) {
            wait.close();
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                createDialog("info", "<spring:message code="global.form.request.successful"/>", "<spring:message code="global.form.new"/>");
            } else {
                createDialog("info", "<spring:message code="exception.duplicate.information"/>", "<spring:message code="error"/>");
            }
        }));
        preTestDF.clearValues();
        preTestWindow.close();
    }

    function disableResendFinalTestTab() {
        let testQuestionType = FinalTestLG_finalTest.getSelectedRecord().testQuestionType;

        if (testQuestionType === "PreTest") {
            TabSet_finalTest.disableTab(TabSet_finalTest.getTab("resendFinalTest"));
            TabSet_finalTest.disableTab(TabSet_finalTest.getTab("monitoringFinalTest"));
        } else {
            TabSet_finalTest.enableTab(TabSet_finalTest.getTab("resendFinalTest"));
            TabSet_finalTest.enableTab(TabSet_finalTest.getTab("monitoringFinalTest"));
        }
    }

    //</script>
