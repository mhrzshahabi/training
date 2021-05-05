<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
// <script>

    let method_PCTQ = "GET";
    let saveActionUrl_PCTQ;
    let wait_PCTQ;
    let classId_PCTQ = null;
    let questions_PCTQ = [];
    let oldQuestionsNum_PCTQ = 0;

    //--------------------------------------------------------------------------------------------------------------------//
    /*Class Window*/
    //--------------------------------------------------------------------------------------------------------------------//

    Menu_Class_PCTQ = isc.Menu.create({
        data: [{
            title: "<spring:message code="refresh"/>", click: function () {
                refreshLG(ClassLG_PCTQ);
            }
        }]
    });

    ClassDS_PCTQ = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "course.titleFa"},
            {name: "teacher"},
            {name: "startDate"},
            {name: "endDate"},
            {name: "group"}
        ],
        fetchDataURL: classUrl + "tuple-list"
    });

    ClassLG_PCTQ = isc.TrLG.create({
        dataSource: ClassDS_PCTQ,
        contextMenu: Menu_Class_PCTQ,
        selectionType: "single",
        fields: [
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
                name: "teacher",
                title: "<spring:message code='teacher'/>",
                align: "center",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "startDate",
                title: "<spring:message code='start.date'/>",
                align: "center",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "endDate",
                title: "<spring:message code='end.date'/>",
                align: "center",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "group",
                title: "<spring:message code='group'/>",
                align: "center",
                filterOperator: "equals",
                autoFitWidth: true
            },
        ],
        rowDoubleClick: function () {IButton_Class_Ok_PCTQ.click()}
    });

    IButton_Class_Ok_PCTQ = isc.IButtonSave.create({
        title: "<spring:message code="select"/>",
        click: function () {
            if (ClassLG_PCTQ.getSelectedRecord() == null) {
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                return;
            }
            addQuestions_preCourseTestQuestions(ClassLG_PCTQ.getSelectedRecord().id);
            Window_Class_PCTQ.close();
        }
    });

    HLayout_Class_Ok_PCTQ = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        members: [IButton_Class_Ok_PCTQ]
    });

    ToolStripButton_Class_Refresh_PCTQ = isc.ToolStripButtonRefresh.create({
        click: function () {
            refreshLG(ClassLG_PCTQ);
        }
    });

    ToolStrip_Class_Actions_PCTQ = isc.ToolStrip.create({
        width: "100%",
        align: "left",
        border: '0px',
        members: [
            ToolStripButton_Class_Refresh_PCTQ
        ]
    });

    Window_Class_PCTQ = isc.Window.create({
        placement: "fillScreen",
        minWidth: 1024,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        title: "<spring:message code='class'/>",
        items: [isc.TrVLayout.create({
            members: [
                ToolStrip_Class_Actions_PCTQ,
                ClassLG_PCTQ,
                HLayout_Class_Ok_PCTQ
            ]
        })]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Questions Grid*/
    //--------------------------------------------------------------------------------------------------------------------//

    IButton_Save_PCTQ = isc.IButtonSave.create({
        click: function () {
            if (questionsLG_PCTQ.hasErrors() || classId_PCTQ == null)
                return;
            wait_PCTQ = createDialog("wait");
            for (let i = 1; i < questionsLG_PCTQ.data.length; i++) {
                for (let j = 0; j < i; j++) {
                    if (questionsLG_PCTQ.data[i].question === questionsLG_PCTQ.data[j].question) {
                        questionsLG_PCTQ.data.removeAt(i--);
                        break;
                    }
                }
            }
            isc.RPCManager.sendRequest(TrDSRequest(classUrl + "preCourse-test-questions/" + classId_PCTQ, "PUT", JSON.stringify(questionsLG_PCTQ.data.map(r => r.question)), questionsLG_Save_Result_PCTQ));
        }
    });

    IButton_Cancel_PCTQ = isc.IButtonCancel.create({
        click: function () {
            loadPage_preCourseTestQuestions(classId_PCTQ);
        }
    });
    <sec:authorize access="hasAnyAuthority('TclassPreCourseTestQuestionsTab_ShowOption','TclassPreCourseTestQuestionsTab_classStatus')">
    HLayout_SaveOrExit_PCTQ = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        members: [

            IButton_Save_PCTQ, IButton_Cancel_PCTQ

        ]
    });
    </sec:authorize>

    Menu_ReadOnly_PCTQ = isc.Menu.create({
        data: [{
            title: "<spring:message code='refresh'/>", click: function () {
                loadPage_preCourseTestQuestions(classId_PCTQ);
            }
        }]
    });


    Menu_PCTQ = isc.Menu.create({
        data: [{
            title: "<spring:message code='refresh'/>", click: function () {
                loadPage_preCourseTestQuestions(classId_PCTQ);
            }
        }, {
            title: "<spring:message code='create'/>", click: function () {
                questionsLG_PCTQ.startEditingNew();
            }
        }, {
            title: "<spring:message code='edit'/>", click: function () {
                questionsLG_Edit_PCTQ();
            }
        }, {
            title: "<spring:message code='remove'/>", click: function () {
                questionsLG_Remove_PCTQ();
            }
        }, {
            title: "<spring:message code='copy.of.class'/>", click: function () {
                Show_Class_List_PCTQ();
            }
        }
        ]
    });

    questionsLG_PCTQ = isc.TrLG.create({
        align: "center",
        canReorderRecords: true,
        autoFitMaxRecords: 4,
        autoFitData: "vertical",
        canEdit: true,
        modalEditing: true,
        canRemoveRecords: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        validateOnExit: true,
        validateByCell: true,
        canSort: false,
        showFilterEditor: false,
        sortField: 0,
        fields: [
            {
                name: "order",
                hidden: true,
            },
            {
                name: "question",
                title: "<spring:message code='question'/>",
                type: "TextAreaItem",
                validators: [
                    {
                        type: "lengthRange",
                        max: 4000,
                        errorMessage: "<spring:message code="class.preCourseTestQuestion.length.limit"/>"
                    },
                    <%--{type: "required", errorMessage: "<spring:message code="msg.field.is.required"/>"}--%>
                ]
            }
        ],
        rowDoubleClick: function () {
            questionsLG_Edit_PCTQ();
        },
        removeRecordClick: function (rowNum) {
            let Dialog_Delete = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                "<spring:message code='verify.delete'/>");
            Dialog_Delete.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0)
                        questionsLG_PCTQ.data.removeAt(rowNum);
                }
            });
        },
        editorExit: function (editCompletionEvent, record, newValue, rowNum, colNum) {
            if (record == null) {
                setTimeout(function () {
                    for (let i = questionsLG_PCTQ.data.length - 1; i > -1; i--) {
                        if (questionsLG_PCTQ.data[i].question == null)
                            questionsLG_PCTQ.data.removeAt(i);
                    }
                }, 1);
                return;
            }
            if (newValue == null) {
                questionsLG_PCTQ.data.removeAt(rowNum);
            }
        }
    });

    ToolStripButton_Refresh_PCTQ = isc.ToolStripButtonRefresh.create({
        click: function () {
            loadPage_preCourseTestQuestions(classId_PCTQ);
        }
    });

    ToolStripButton_Edit_PCTQ = isc.ToolStripButtonEdit.create({
        click: function () {
            questionsLG_Edit_PCTQ();
        }
    });
    ToolStripButton_Add_PCTQ = isc.ToolStripButtonCreate.create({
        click: function () {
            questionsLG_PCTQ.startEditingNew();
        }
    });
    ToolStripButton_Remove_PCTQ = isc.ToolStripButtonRemove.create({
        click: function () {
            questionsLG_Remove_PCTQ();
        }
    });
    ToolStripButton_ShowClass_PCTQ = isc.ToolStripButton.create({
        title: "<spring:message code="copy.of.class"/>",
        click: function () {
            Show_Class_List_PCTQ();
        }
    });

    ToolStrip_Actions_PCTQ = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                <sec:authorize access="hasAnyAuthority('TclassPreCourseTestQuestionsTab_ShowOption','TclassPreCourseTestQuestionsTab_classStatus')">
                ToolStripButton_Add_PCTQ,
                ToolStripButton_Edit_PCTQ,
                ToolStripButton_Remove_PCTQ,
                ToolStripButton_ShowClass_PCTQ,
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_PCTQ
                    ]
                })
                </sec:authorize>
            ]
    });


    VLayout_Body_PCTQ = isc.TrVLayout.create({
        members: [ToolStrip_Actions_PCTQ, questionsLG_PCTQ, HLayout_SaveOrExit_PCTQ ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*functions*/
    //--------------------------------------------------------------------------------------------------------------------//

    function Show_Class_List_PCTQ() {
        let selectedClass = ListGrid_Class_JspClass.getSelectedRecord();
        let criteria = {
            _constructor: "AdvancedCriteria",
            operator: "and",
            criteria: [
                {fieldName: "course.code", operator: "equals", value: selectedClass.course.code},
                {fieldName: "preCourseTestQuestions", operator: "notNull"},
                {fieldName: "id", operator: "notEqual", value: selectedClass.id}
            ]
        };
        ClassLG_PCTQ.implicitCriteria = criteria;
        ClassLG_PCTQ.fetchData(criteria);
        Window_Class_PCTQ.show();
    }

    function questionsLG_Edit_PCTQ() {
        let record = questionsLG_PCTQ.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            return;
        }
        questionsLG_PCTQ.startEditing(questionsLG_PCTQ.getRowNum(record));
    }

    function questionsLG_Remove_PCTQ() {
        let records = questionsLG_PCTQ.getSelectedRecords();
        if (records.isEmpty()) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            return;
        }
        let Dialog_Delete = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
            "<spring:message code='verify.delete'/>");
        Dialog_Delete.addProperties({
            buttonClick: function (button, index) {
                this.close();
                if (index === 0) {
                    questionsLG_PCTQ.data.removeAll(records);
                }
            }
        });
    }

    function questionsLG_Save_Result_PCTQ(resp) {
        wait_PCTQ.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            let OK = createDialog("info", "<spring:message code="msg.operation.successful"/>");
            setTimeout(function () {
                OK.close();
            }, 3000);
        } else {
            loadPage_preCourseTestQuestions(classId_PCTQ);
            createDialog("info", "<spring:message code="msg.operation.error"/>");
        }
    }

    function setQuestionsLGData_PCTQ(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            let questions = (JSON.parse(resp.data));
            if (oldQuestionsNum_PCTQ === 0)
                questions_PCTQ = [];
            for (let i = 0; i < questions.length; i++) {
                questions_PCTQ.add({
                    "order": i + oldQuestionsNum_PCTQ,
                    "question": questions[i]
                })
            }
            questionsLG_PCTQ.setData(questions_PCTQ);
        } else {

        }
    }

    function loadPage_preCourseTestQuestions(id, readOnly) {
        // if (readOnly) {
        //     ToolStripButton_Edit_PCTQ.hide();
        //     ToolStripButton_Add_PCTQ.hide();
        //     ToolStripButton_Remove_PCTQ.hide();
        //     ToolStripButton_ShowClass_PCTQ.hide();
        //     questionsLG_PCTQ.contextMenu = Menu_ReadOnly_PCTQ;
        // } else {
        //     ToolStripButton_Edit_PCTQ.show();
        //     ToolStripButton_Add_PCTQ.show();
        //     ToolStripButton_Remove_PCTQ.show();
        //     ToolStripButton_ShowClass_PCTQ.show();
        //     questionsLG_PCTQ.contextMenu = Menu_PCTQ;
        // }
        var  classRecord = ListGrid_Class_JspClass.getSelectedRecord();
        if (id != null) {
            classId_PCTQ = id;
            oldQuestionsNum_PCTQ = 0;
            isc.RPCManager.sendRequest(TrDSRequest(classUrl + "preCourse-test-questions/" + classId_PCTQ, "GET", null, setQuestionsLGData_PCTQ));
        } else {
            classId_PCTQ = null;
            questionsLG_PCTQ.setData([]);
        }

        if(classRecord.classStatus === "3")
        {
            <sec:authorize access="hasAnyAuthority('TclassPreCourseTestQuestionsTab_classStatus','TclassPreCourseTestQuestionsTab_ShowOption')">
            ToolStrip_Actions_PCTQ.setVisibility(false)
            HLayout_SaveOrExit_PCTQ.setVisibility(false)
            questionsLG_PCTQ.contextMenu = null;
            </sec:authorize>
        }
        else
        {
            <sec:authorize access="hasAnyAuthority('TclassPreCourseTestQuestionsTab_classStatus','TclassPreCourseTestQuestionsTab_ShowOption')">
            ToolStrip_Actions_PCTQ.setVisibility(true)
            HLayout_SaveOrExit_PCTQ.setVisibility(true)
            questionsLG_PCTQ.contextMenu = Menu_PCTQ;
            </sec:authorize>
        }
        if (classRecord.classStatus === "3")
        {
            <sec:authorize access="hasAuthority('TclassPreCourseTestQuestionsTab_classStatus')">
            ToolStrip_Actions_PCTQ.setVisibility(true)
            HLayout_SaveOrExit_PCTQ.setVisibility(true)
            questionsLG_PCTQ.contextMenu = Menu_PCTQ;
            </sec:authorize>
        }
    }

    function addQuestions_preCourseTestQuestions(id) {
        if (id == null)
            return;
        oldQuestionsNum_PCTQ = questions_PCTQ.isEmpty() ? 0 : questions_PCTQ.length;
        isc.RPCManager.sendRequest(TrDSRequest(classUrl + "preCourse-test-questions/" + id, "GET", null, setQuestionsLGData_PCTQ));
    }

    function clear_preCourseTestQuestions() {
        questionsLG_PCTQ.clear();
    }

    //</script>