<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    var methodAcademicBK = "GET";
    var saveActionUrlAcademicBK;
    var waitAcademicBK;
    var teacherIdAcademicBK = null;

    //--------------------------------------------------------------------------------------------------------------------//
    /*RestDataSource*/
    //--------------------------------------------------------------------------------------------------------------------//

    RestDataSource_JspAcademicBK = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "educationLevelId"},
            {name: "educationMajorId"},
            {name: "educationOrientationId"},
            {name: "persianDate"},
            {name: "duration"},
            {name: "academicGrade"},
            {name: "collageName"}
        ]
    });

    RestDataSource_EducationLevel_JspAcademicBK = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa", filterOperator: "iContains"}],
        fetchDataURL: educationUrl + "level/iscList"
    });

    RestDataSource_EducationMajor_JspAcademicBK = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa", filterOperator: "iContains"}],
        fetchDataURL: educationUrl + "major/iscList"
    });

    RestDataSource_EducationOrientation_JspAcademicBK = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa", filterOperator: "iContains"}],
        fetchDataURL: educationUrl + "orientation/iscList"
    });
    //--------------------------------------------------------------------------------------------------------------------//
    /*window*/
    //--------------------------------------------------------------------------------------------------------------------//

    DynamicForm_JspAcademicBK = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        titleAlign: "left",
        fields: [
            {name: "id", hidden: true},
            {
                name: "academicGrade",
                title: "<spring:message code='academic.grade'/>",
            },
            {
                name: "collageName",
                title: "<spring:message code='collage.name'/>",
            },
            {
                name: "educationLevelId",
                title: "<spring:message code='education.level'/>",
                type: "selectItem",
                textAlign: "center",
                optionDataSource: RestDataSource_EducationLevel_JspAcademicBK,
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                required: true,
                multiple: false,
                filterLocally: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains",
                },
            },
            {
                name: "educationMajorId",
                title: "<spring:message code='education.major'/>",
                type: "selectItem",
                textAlign: "center",
                required: true,
                optionDataSource: RestDataSource_EducationMajor_JspAcademicBK,
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                multiple: false,
                filterLocally: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains",
                },
            },
            {
                name: "educationOrientationId",
                title: "<spring:message code='education.orientation'/>",
                type: "selectItem",
                textAlign: "center",
                optionDataSource: RestDataSource_EducationOrientation_JspAcademicBK,
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                multiple: false,
                filterLocally: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains",
                },
            },
            {
                name: "duration",
                title: "<spring:message code='duration'/>",
                type: "IntegerItem",
                keyPressFilter: "[0-9]",
                hint: "<spring:message code='hour'/>",
                showHintInField: true,
                length: 5
            },
            {
                name: "persianDate",
                ID: "academicBK_date_JspAcademicBK",
                title: "<spring:message code='graduation.date'/>",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('academicBK_date_JspAcademicBK', this, 'ymd', '/');
                    }
                }],
                validators: [{
                    type: "custom",
                    errorMessage: "<spring:message code='msg.correct.date'/>",
                    condition: function (item, validator, value) {
                        if (value === undefined)
                            return DynamicForm_JspAcademicBK.getValue("persianDate") === undefined;
                        return checkBirthDate(value);
                    }
                }]
            }
        ]
    });

    IButton_Save_JspAcademicBK = isc.TrSaveBtn.create({
        top: 260,
        click: function () {
            DynamicForm_JspAcademicBK.validate();
            if (!DynamicForm_JspAcademicBK.valuesHaveChanged() || !DynamicForm_JspAcademicBK.validate())
                return;
            waitAcademicBK = createDialog("wait");
            isc.RPCManager.sendRequest(TrDSRequest(saveActionUrlAcademicBK,
                methodAcademicBK,
                JSON.stringify(DynamicForm_JspAcademicBK.getValues()),
                "callback: AcademicBK_save_result(rpcResponse)"));
        }
    });

    IButton_Cancel_JspAcademicBK = isc.TrCancelBtn.create({
        click: function () {
            DynamicForm_JspAcademicBK.clearValues();
            Window_JspAcademicBK.close();
        }
    });

    HLayout_SaveOrExit_JspAcademicBK = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        members: [IButton_Save_JspAcademicBK, IButton_Cancel_JspAcademicBK]
    });

    Window_JspAcademicBK = isc.Window.create({
        width: "500",
        align: "center",
        border: "1px solid gray",
        title: "<spring:message code='academicBK'/>",
        items: [isc.TrVLayout.create({
            members: [DynamicForm_JspAcademicBK, HLayout_SaveOrExit_JspAcademicBK]
        })]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Grid*/
    //--------------------------------------------------------------------------------------------------------------------//

    Menu_JspAcademicBK = isc.Menu.create({
        data: [{
            title: "<spring:message code='refresh'/>", click: function () {
                ListGrid_AcademicBK_refresh();
            }
        }, {
            title: "<spring:message code='create'/>", click: function () {
                ListGrid_AcademicBK_Add();
            }
        }, {
            title: "<spring:message code='edit'/>", click: function () {
                ListGrid_AcademicBK_Edit();
            }
        }, {
            title: "<spring:message code='remove'/>", click: function () {
                ListGrid_AcademicBK_Remove();
            }
        }
        ]
    });


    ListGrid_JspAcademicBK = isc.TrLG.create({
        dataSource: RestDataSource_JspAcademicBK,
        contextMenu: Menu_JspAcademicBK,
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: false,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>",
        align: "center",
        fields: [
            {
                name: "educationLevelId",
                title: "<spring:message code='education.level'/>",
                type: "IntegerItem",
                filterOnKeypress: true,
                editorType: "SelectItem",
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_EducationLevel_JspAcademicBK
            },
            {
                name: "educationMajorId",
                title: "<spring:message code='education.major'/>",
                type: "IntegerItem",
                filterOnKeypress: true,
                editorType: "SelectItem",
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_EducationMajor_JspAcademicBK
            },
            {
                name: "educationOrientationId",
                title: "<spring:message code='education.orientation'/>",
                type: "IntegerItem",
                filterOnKeypress: true,
                editorType: "SelectItem",
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_EducationOrientation_JspAcademicBK
            }
          ,
            {
                name: "duration",
                title: "<spring:message code='duration'/>"
            },
            {
                name: "persianDate",
                title: "<spring:message code='graduation.date'/>",
                canFilter: false,
                canSort: false
            },
            {name: "academicGrade", title: "<spring:message code='academic.grade'/>"},
            {name: "collageName", title: "<spring:message code='collage.name'/>"}
        ],
        rowDoubleClick: function () {
            ListGrid_AcademicBK_Edit();
        }
    });

    ToolStripButton_Refresh_JspAcademicBK = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_AcademicBK_refresh();
        }
    });

    ToolStripButton_Edit_JspAcademicBK = isc.ToolStripButtonEdit.create({
        click: function () {
            ListGrid_AcademicBK_Edit();
        }
    });
    ToolStripButton_Add_JspAcademicBK = isc.ToolStripButtonAdd.create({
        click: function () {
            ListGrid_AcademicBK_Add();
        }
    });
    ToolStripButton_Remove_JspAcademicBK = isc.ToolStripButtonRemove.create({
        click: function () {
            ListGrid_AcademicBK_Remove();
        }
    });

    ToolStrip_Actions_JspAcademicBK = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                ToolStripButton_Add_JspAcademicBK,
                ToolStripButton_Edit_JspAcademicBK,
                ToolStripButton_Remove_JspAcademicBK,
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_JspAcademicBK
                    ]
                })
            ]
    });

    VLayout_Body_JspAcademicBK = isc.TrVLayout.create({
        members: [
            ToolStrip_Actions_JspAcademicBK,
            ListGrid_JspAcademicBK
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*functions*/
    //--------------------------------------------------------------------------------------------------------------------//

    function ListGrid_AcademicBK_refresh() {
        ListGrid_JspAcademicBK.invalidateCache();
        ListGrid_JspAcademicBK.filterByEditor();
    }

    function ListGrid_AcademicBK_Add() {
        methodAcademicBK = "POST";
        saveActionUrlAcademicBK = academicBKUrl + "/" + teacherIdAcademicBK;
        DynamicForm_JspAcademicBK.clearValues();
        Window_JspAcademicBK.show();
    }

    function ListGrid_AcademicBK_Edit() {
        var record = ListGrid_JspAcademicBK.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            methodAcademicBK = "PUT";
            saveActionUrlAcademicBK = academicBKUrl + "/" + record.id;
            DynamicForm_JspAcademicBK.clearValues();
            DynamicForm_JspAcademicBK.editRecord(record);
            Window_JspAcademicBK.show();
        }
    }

    function ListGrid_AcademicBK_Remove() {
        var record = ListGrid_JspAcademicBK.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            var Dialog_Delete = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                "<spring:message code='verify.delete'/>");
            Dialog_Delete.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        waitAcademicBK = createDialog("wait");
                        isc.RPCManager.sendRequest(TrDSRequest(academicBKUrl +
                            "/" +
                            teacherIdAcademicBK +
                            "," +
                            ListGrid_JspAcademicBK.getSelectedRecord().id,
                            "DELETE",
                            null,
                            "callback: AcademicBK_remove_result(rpcResponse)"));
                    }
                }
            });
        }
    }

    function AcademicBK_save_result(resp) {
        waitAcademicBK.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",
                "<spring:message code="msg.command.done"/>");
            ListGrid_AcademicBK_refresh();
            Window_JspAcademicBK.close();
            setTimeout(function () {
                OK.close();
            }, 3000);
        } else {
            if (resp.httpResponseCode === 406 && resp.httpResponseText === "DuplicateRecord") {
                createDialog("info", "<spring:message code="msg.record.duplicate"/>",
                    "<spring:message code="message"/>");
            } else {
                createDialog("info", "<spring:message code="msg.operation.error"/>",
                    "<spring:message code="message"/>");
            }
        }
    }

    function AcademicBK_remove_result(resp) {
        waitAcademicBK.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            ListGrid_AcademicBK_refresh();
            var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",
                "<spring:message code="msg.command.done"/>");
            setTimeout(function () {
                OK.close();
            }, 3000);
        } else {
            var respText = resp.httpResponseText;
            if (resp.httpResponseCode === 406 && respText === "NotDeletable") {
                createDialog("info", "<spring:message code='msg.record.cannot.deleted'/>");
            } else {
                createDialog("info", "<spring:message code="msg.operation.error"/>");
            }
        }
    }

    function loadPage_AcademicBK(id) {
        if (teacherIdAcademicBK !== id) {
            teacherIdAcademicBK = id;
            RestDataSource_JspAcademicBK.fetchDataURL = academicBKUrl + "/iscList/" + teacherIdAcademicBK;
            ListGrid_JspAcademicBK.fetchData();
            ListGrid_AcademicBK_refresh();
        }
    }

    function clear_AcademicBK() {
        ListGrid_JspAcademicBK.clear();
    }

    //</script>