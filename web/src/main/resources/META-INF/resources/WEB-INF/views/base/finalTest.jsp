<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="sprig" uri="http://java.sun.com/jsp/jstl/fmt" %>

//<script>

    let finalTestMethod_finalTest;
    let oLoadAttachments_finalTest;
    // ------------------------------------------- Menu -------------------------------------------
    FinalTestMenu_finalTest = isc.Menu.create({
        data: [
            {
                title: "<spring:message code="refresh"/>",
                icon: "<spring:url value="refresh.png"/>",
                click: function () {
                    refresh_finalTest();
                }
            },
            {
                title: "<spring:message code="create"/>",
                icon: "<spring:url value="create.png"/>",
                click: function () {
                    showNewForm_finalTest();
                }
            },
            {
                title: "<spring:message code="edit"/>",
                icon: "<spring:url value="edit.png"/>",
                click: function () {
                    showEditForm_finalTest();
                }
            },
            {
                title: "<spring:message code="remove"/>",
                icon: "<spring:url value="remove.png"/>",
                click: function () {
                    showRemoveForm_finalTest();
                }
            },
        ]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------

    FinalTestTS_finalTest = isc.ToolStrip.create({
        members: [
            isc.ToolStripButtonAdd.create({
                click: function () {
                    showNewForm_finalTest();
                }
            }),
            isc.ToolStripButtonEdit.create({
                click: function () {
                    showEditForm_finalTest();
                }
            }),
            isc.ToolStripButtonRemove.create({
                click: function () {
                    showRemoveForm_finalTest();
                }
            }),
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let implicitCriteria = JSON.parse(JSON.stringify(FinalTestDS_finalTest.implicitCriteria)) ;
                    let criteria = FinalTestLG_finalTest.getCriteria();

                    if(criteria.criteria){
                        for (let i = 0; i < criteria.criteria.length ; i++) {
                            implicitCriteria.criteria.push(criteria.criteria[i]);
                        }
                    }
                    console.log(implicitCriteria);
                     ExportToFile.downloadExcelRestUrl(null, FinalTestLG_finalTest,  testQuestionUrl + "/spec-list" , 0, null, '',"لیست آزمون های پایانی", implicitCriteria, null);
                }
             }),

            isc.LayoutSpacer.create({
                width: "*"
            }),
            isc.ToolStripButtonRefresh.create({
                click: function () {
                    refresh_finalTest();
                }
            }),
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
            {
                name: "tclass.teacher",
                title: "<spring:message code="teacher"/>",
                filterOperator: "iContains", autoFitWidth: true
            },
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
                name: "duration",
                title: "<spring:message code="test.question.duration"/>",
                filterOperator: "iContains", autoFitWidth: true
            },
            /*{
                name: "isPreTestQuestion",
                title: "<spring:message code="test.question.type"/>",
                filterOperator: "iContains", autoFitWidth: true
            },*/

        ],
        fetchDataURL: testQuestionUrl + "/spec-list",
        implicitCriteria: {
            _constructor: "AdvancedCriteria",
            operator: "and",
            criteria: [{fieldName: "isPreTestQuestion", operator: "equals", value: false}]
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
            {
                name: "evaluation",
            },
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
            {name: "titleClass"},
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
            {name: "scoringMethod"}
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
        dataSource: FinalTestDS_finalTest,
        fields: [
            {name: "tclass.code",},
            {name: "tclass.course.titleFa",},
            {name: "tclass.startDate",},
            {name: "tclass.endDate",},
            {name: "tclass.teacher",},
            {name: "date",},
            {name: "time",},
            {name: "duration",},
            //{name: "isPreTestQuestion",}
        ],
        autoFetchData: true,
        gridComponents: [FinalTestTS_finalTest, "filterEditor", "header", "body",],
        contextMenu: FinalTestMenu_finalTest,
        sortField: 1,
        filterOperator: "iContains",
        filterOnKeypress: false,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        selectionUpdated: function (record) {
           loadTab();

        },
        doubleClick: function () {
            showEditForm_finalTest();
        },
        filterEditorSubmit: function () {
            FinalTestLG_finalTest.invalidateCache();
        },
    });

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
                prompt: "<spring:message code="first.select.course"/>",
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
                title: "<spring:message code='test.question.date'/>",
                required: true,
                width: "*",
                defaultValue: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
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
                keyPressFilter: "[0-9:]",
                showHintInField: true,
                textAlign: "center",
                validateOnChange: true,
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
            },

        ]
    });

    let FinalTestWin_finalTest = isc.Window.create({
        width: 500,
        height: 230,
        //autoCenter: true,
        overflow: "hidden",
        showMaximizeButton: false,
        autoSize: false,
        canDragResize: false,
        items: [FinalTestDF_finalTest, isc.TrHLayoutButtons.create({
            members: [
                isc.TrSaveBtn.create({
                    click: function () {
                        saveFinalTest_finalTest();
                    }
                }),
                isc.TrCancelBtn.create({
                    click: function () {
                        FinalTestWin_finalTest.close();
                    }
                }),
            ],
        }),]
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
        ],
        tabSelected: function (tabNum, tabPane, ID, tab, name) {
            loadTab();
        }
    });


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
    function refresh_finalTest() {
        FinalTestLG_finalTest.invalidateCache();
        FinalTestLG_finalTest.fetchData();
        loadTab();
    }

    function showNewForm_finalTest() {
        finalTestMethod_finalTest = "POST";
        FinalTestDF_finalTest.clearValues();
        FinalTestWin_finalTest.setTitle("<spring:message code="create"/>&nbsp;" + "<spring:message code="exam"/>");

        FinalTestWin_finalTest.show();
    }

    function showEditForm_finalTest() {
        let record = FinalTestLG_finalTest.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.not.selected.record'/>");
        } else {
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

                FinalTestWin_finalTest.setTitle("<spring:message code="edit"/>&nbsp;" + "<spring:message code="evaluation.final.test"/>" + '&nbsp;\'' + record.tclass.course.titleFa + '\'');
                FinalTestDF_finalTest.editRecord(record);

                FinalTestWin_finalTest.show();
            } else {
                createDialog("warning", "<spring:message code="exception.server.connection"/>", "<spring:message code="error"/>");
            }
        }
    }

    function saveFinalTest_finalTest() {
        if (!FinalTestDF_finalTest.validate()) {
            return;
        }

        let finalTestSaveUrl = testQuestionUrl;

        let finalTestAction = '<spring:message code="created"/>';

        if (finalTestMethod_finalTest.localeCompare("PUT") == 0) {
            let record = FinalTestLG_finalTest.getSelectedRecord();
            finalTestSaveUrl += "/" + record.id;
            finalTestAction = '<spring:message code="edited"/>';
        }
        let data = FinalTestDF_finalTest.getValues();
        isc.RPCManager.sendRequest(
            TrDSRequest(finalTestSaveUrl, finalTestMethod_finalTest, JSON.stringify(data), "callback: rcpResponse(rpcResponse, '<spring:message code="exam"/>', '" + finalTestAction + "')")
        );
    };

    function showRemoveForm_finalTest() {
        let record = FinalTestLG_finalTest.getSelectedRecord();
        let entityType = '<spring:message code="evaluation.final.test"/>';
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
                                } else {
                                    createDialog("warning", "خطا در حذف سوال", "اخطار");
                                }
                            }
                        }))
                    }
                }
            })

        }
    };

    function rcpResponse(resp, entityType, action, entityName) {
        if (generalGetResp(resp)) {
            let respCode = resp.httpResponseCode;
            if (respCode == 200 || respCode == 201) {
                let name;
                if (entityName) {
                    name = entityName;
                } else {
                    name = JSON.parse(resp.data).tclass.course.titleFa;
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

    function loadTab() {
        if (FinalTestLG_finalTest.getSelectedRecord() === null) {
            TabSet_finalTest.disable();

            return;
        }

        classId_finalTest = FinalTestLG_finalTest.getSelectedRecord().id;
        RestDataSource_FinalTest.fetchDataURL = questionBankTestQuestionUrl +"/test/"+FinalTestLG_finalTest.getSelectedRecord().tclass.id+ "/spec-list";
        ListGrid_FinalTest.invalidateCache();
        ListGrid_FinalTest.fetchData();

        TabSet_finalTest.enable();
    }

    //</script>