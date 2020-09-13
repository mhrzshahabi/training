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
            {name: "educationLevel.titleFa"},
            {name: "educationMajor.titleFa"},
            {name: "educationOrientation.titleFa"},
            {name: "date"},
            {name: "duration"},
            {name: "academicGrade"},
            {name: "collageName"}
        ]
    });

    RestDataSource_EducationLevel_JspAcademicBK = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa", filterOperator: "iContains"}],
        fetchDataURL: educationLevelUrl + "spec-list-by-id"
    });

    RestDataSource_EducationMajor_JspAcademicBK = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa", filterOperator: "iContains"}],
        fetchDataURL: educationMajorUrl + "spec-list-by-id"
    });

    RestDataSource_EducationOrientation_JspAcademicBK = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa", filterOperator: "iContains"}],
        fetchDataURL: educationOrientationUrl + "iscList"
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
                name: "educationLevelId",
                title: "<spring:message code='education.level'/>",
                textAlign: "center",
                width: "*",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                required: true,
                optionDataSource: RestDataSource_EducationLevel_JspAcademicBK,
                autoFetchData: false,
                filterFields: ["titleFa","titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                pickListProperties: {
                    showFilterEditor: false,
                    autoFitWidthApproach: "both"
                },
                pickListFields: [
                    {
                        name: "titleFa",
                        width: "70%"
                    }
                ]
            },
            {
                name: "educationMajorId",
                title: "<spring:message code='education.major'/>",
                textAlign: "center",
                width: "*",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                required: true,
                optionDataSource: RestDataSource_EducationMajor_JspAcademicBK,
                autoFetchData: false,
                filterFields: ["titleFa","titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                pickListProperties: {
                    showFilterEditor: false,
                    autoFitWidthApproach: "both"
                },
                pickListFields: [
                    {
                        name: "titleFa",
                        width: "70%"
                    }
                ]
            },

            {
                name: "educationOrientationId",
                title: "<spring:message code='education.orientation'/>",
                textAlign: "center",
                width: "*",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                autoFetchData: false,
                filterFields: ["titleFa","titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: false,
                    autoFitWidthApproach: "both"
                },
                pickListFields: [
                    {
                        name: "titleFa",
                        width: "70%"
                    }
                ]
            },
            {
                name: "collageName",
                title: "<spring:message code='collage.name'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]"
            },
            {
                name: "academicGrade",
                title: "<spring:message code='academic.grade'/>",
                keyPressFilter: "[0-9.]",
                length: "10"
            },
            {
                name: "duration",
                title: "<spring:message code='duration'/>",
                type: "IntegerItem",
                keyPressFilter: "[0-9]",
                hint: "<spring:message code='work.years'/>",
                showHintInField: true,
                length: 3
            },
            {
                name: "date",
                ID: "academicBK_date_JspAcademicBK",
                title: "<spring:message code='graduation.date'/>",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('academicBK_date_JspAcademicBK', this, 'ymd', '/');
                    }
                }],
                validators: [
                    {
                    type: "custom",
                    errorMessage: "<spring:message code='msg.correct.date'/>",
                    condition: function (item, validator, value) {
                        if (value === undefined)
                            return DynamicForm_JspAcademicBK.getValue("date") === undefined;
                        return checkBirthDate(value);
                    }}
                ]
            }
        ],
        itemChanged: function (item, newValue) {
            if (item.name === "educationLevelId" || item.name === "educationMajorId") {
                var levelId =  DynamicForm_JspAcademicBK.getField("educationLevelId").getValue();
                var majorId =  DynamicForm_JspAcademicBK.getField("educationMajorId").getValue();
                if (newValue === undefined) {
                    DynamicForm_JspAcademicBK.clearValue("educationOrientationId");
                } else if (levelId !== undefined && majorId !== undefined) {
                    DynamicForm_JspAcademicBK.clearValue("educationOrientationId");
                    RestDataSource_EducationOrientation_JspAcademicBK.fetchDataURL = educationOrientationUrl +
                        "spec-list-by-levelId-and-majorId/" + levelId + ":" + majorId;
                    DynamicForm_JspAcademicBK.getField("educationOrientationId").optionDataSource =
                        RestDataSource_EducationOrientation_JspAcademicBK;
                    DynamicForm_JspAcademicBK.getField("educationOrientationId").fetchData();
                }
            }
        }
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
        close : function(){closeCalendarWindow(); Window_JspAcademicBK.hide()},
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
                name: "educationLevel.titleFa",
                title: "<spring:message code='education.level'/>"
            },
            {
                name: "educationMajor.titleFa",
                title: "<spring:message code='education.major'/>"
            },
            {
                name: "educationOrientation.titleFa",
                title: "<spring:message code='education.orientation'/>"
            },
            {name: "collageName", title: "<spring:message code='collage.name'/>"},
            {name: "academicGrade", title: "<spring:message code='academic.grade'/>"},
            {
                name: "duration",
                title: "<spring:message code='duration'/>",
                filterOperator: "equals",
                type: "integer"
            },
            {
                name: "date",
                title: "<spring:message code='graduation.date'/>"
            }
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
    ToolStripButton_Add_JspAcademicBK = isc.ToolStripButtonCreate.create({
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
                isc.ToolStripButtonExcel.create({
                    click: function () {
                        ExportToFile.downloadExcelRestUrl(null, ListGrid_JspAcademicBK, academicBKUrl + "/iscList/" + teacherIdAcademicBK, 0,null, '', "استاد - اطلاعات پايه - سوابق تحصيلی", ListGrid_JspAcademicBK.getCriteria(), null)
                    }
                }),
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_JspAcademicBK
                    ]
                }),
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
        DynamicForm_JspAcademicBK.getItem("educationOrientationId").setOptionDataSource(null);
        DynamicForm_JspAcademicBK.clearValue("educationOrientationId");
        Window_JspAcademicBK.show();
    }

    function ListGrid_AcademicBK_Edit() {
        var record = ListGrid_JspAcademicBK.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            var eduMajorValue = record.educationMajorId;
            var eduOrientationValue = record.educationOrientationId;
            var eduLevelValue = record.educationLevelId;
            if (eduOrientationValue === undefined) {
                DynamicForm_JspAcademicBK.clearValue("educationOrientationId");
            }
            if (eduMajorValue != undefined && eduLevelValue != undefined) {
                RestDataSource_EducationOrientation_JspAcademicBK.fetchDataURL = educationOrientationUrl +
                    "spec-list-by-levelId-and-majorId/" + eduLevelValue + ":" + eduMajorValue;
                DynamicForm_JspAcademicBK.getField("educationOrientationId").optionDataSource = RestDataSource_EducationOrientation_JspAcademicBK;
                DynamicForm_JspAcademicBK.getField("educationOrientationId").fetchData();
            }
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