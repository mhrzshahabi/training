<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    <spring:eval var="restApiUrl" expression="@environment.getProperty('nicico.rest-api.url')"/>

    var method = "POST";
    var url = "${restApiUrl}/api/tclass";

    var str1 = "";
    var str2 = "";
    var str3 = "";

    var startDateCheck = true;
    var endDateCheck = true;

    //--------------------------------------------------------------------------------------------------------------------//
    /*Rest Data Sources*/
    //--------------------------------------------------------------------------------------------------------------------//

    var RestDataSource_Class_JspClass = isc.RestDataSource.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "group"},
            {name: "startDate"},
            {name: "endDate"},
            {name: "code"},
            {name: "duration"},
            {name: "teacher.fullNameFa"},
            {name: "course.code"},
            {name: "course.titleFa"},
            {name: "version"}
        ], dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",
        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {
                "Authorization": "Bearer " + "${cookie['access_token'].getValue()}",
                "Access-Control-Allow-Origin": "${restApiUrl}"
            };
            return this.Super("transformRequest", arguments);
        },
        fetchDataURL: "${restApiUrl}/api/tclass/spec-list"
    });

    var RestDataSource_Teacher_JspClass = isc.RestDataSource.create({
        fields: [
            {name: "id"},
            {name: "fullNameFa"},
        ], dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",
        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {
                "Authorization": "Bearer " + "${cookie['access_token'].getValue()}",
                "Access-Control-Allow-Origin": "${restApiUrl}"
            };
            return this.Super("transformRequest", arguments);
        },
        fetchDataURL: "${restApiUrl}/api/teacher/spec-list"
    });

    var RestDataSource_Course_JspClass = isc.RestDataSource.create({
        fields: [
            {name: "id"},
            {name: "code"},
            {name: "titleFa"}
        ], dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",
        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {
                "Authorization": "Bearer " + "${cookie['access_token'].getValue()}",
                "Access-Control-Allow-Origin": "${restApiUrl}"
            };
            return this.Super("transformRequest", arguments);
        },
        fetchDataURL: "${restApiUrl}/api/course/spec-list"
    });

    var RestDataSource_Class_Student_JspClass = isc.RestDataSource.create({
        fields: [
            {name: "id"},
            {name: "fullNameFa"},
            {name: "studentID"}
        ],
        dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",
        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {
                "Authorization": "Bearer " + "${cookie['access_token'].getValue()}",
                "Access-Control-Allow-Origin": "${restApiUrl}"
            };
            return this.Super("transformRequest", arguments);
        },
        fetchDataURL: "${restApiUrl}/api/tclass/otherStudent"
    });

    var RestDataSource_Class_CurrentStudent_JspClass = isc.RestDataSource.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "fullNameFa"},
            {name: "studentID"}
        ],
        dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",
        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {
                "Authorization": "Bearer " + "${cookie['access_token'].getValue()}",
                "Access-Control-Allow-Origin": "${restApiUrl}"
            };
            return this.Super("transformRequest", arguments);
        },
        fetchDataURL: "${restApiUrl}/api/tclass/student"
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Menu*/
    //--------------------------------------------------------------------------------------------------------------------//

    var Menu_ListGrid_Class_JspClass = isc.Menu.create({
        width: 150,
        data: [{
            title: "<spring:message code='refresh'/>", icon: "pieces/16/refresh.png", click: function () {
                ListGrid_Class_refresh();
            }
        }, {
            title: "<spring:message code='create'/>", icon: "pieces/16/icon_add.png", click: function () {
                ListGrid_Class_add();
            }
        }, {
            title: "<spring:message code='edit'/>", icon: "pieces/16/icon_edit.png", click: function () {
                ListGrid_class_edit();
            }
        }, {
            title: "<spring:message code='remove'/>",
            icon: "pieces/16/icon_delete.png",
            click: function () {
                ListGrid_class_remove();
            }
        }, {isSeparator: true}, {
            title: "<spring:message code='print.pdf'/>", icon: "icon/pdf.png", click: function () {
                var advancedCriteria = ListGrid_Class_JspClass.getCriteria();
                var criteriaForm = isc.DynamicForm.create({
                    method: "POST",
                    action: "/tclass/printWithCriteria/pdf",
                    target: "_Blank",
                    canSubmit: true,
                    fields:
                        [
                            {name: "CriteriaStr", type: "hidden"}
                        ]
                });
                criteriaForm.setValue("CriteriaStr", JSON.stringify(advancedCriteria));
                criteriaForm.submitForm();
            }
        }, {
            title: "<spring:message code='print.excel'/>", icon: "icon/excel.png", click: function () {
                var advancedCriteria = ListGrid_Class_JspClass.getCriteria();
                var criteriaForm = isc.DynamicForm.create({
                    method: "POST",
                    action: "/tclass/printWithCriteria/excel",
                    target: "_Blank",
                    canSubmit: true,
                    fields:
                        [
                            {name: "CriteriaStr", type: "hidden"}
                        ]
                });
                criteriaForm.setValue("CriteriaStr", JSON.stringify(advancedCriteria));
                criteriaForm.submitForm();
            }
        }, {
            title: "<spring:message code='print.html'/>", icon: "icon/html.jpg", click: function () {
                var advancedCriteria = ListGrid_Class_JspClass.getCriteria();
                var criteriaForm = isc.DynamicForm.create({
                    method: "POST",
                    action: "/tclass/printWithCriteria/html",
                    target: "_Blank",
                    canSubmit: true,
                    fields:
                        [
                            {name: "CriteriaStr", type: "hidden"}
                        ]
                });
                criteriaForm.setValue("CriteriaStr", JSON.stringify(advancedCriteria));
                criteriaForm.submitForm();
            }
        },
            {isSeparator: true}, {
                title: "<spring:message code='students.list'/>", icon: "icon/classroom.png", click: function () {
                    Add_Student();
                }
            }
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Listgrid*/
    //--------------------------------------------------------------------------------------------------------------------//

    var ListGrid_Class_JspClass = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Class_JspClass,
        contextMenu: Menu_ListGrid_Class_JspClass,
        doubleClick: function () {
            ListGrid_class_edit();
        },
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "code", title: "<spring:message code='class.code'/>", align: "center", filterOperator: "equals"},
            {
                name: "course.code",
                title: "<spring:message code='course.code'/>",
                align: "center",
                filterOperator: "equals"
            },
            {
                name: "course.titleFa",
                title: "<spring:message code='course.title'/>",
                align: "center",
                filterOperator: "contains"
            },
            {name: "duration", title: "<spring:message code='duration'/>", align: "center", filterOperator: "equals"},
            {
                name: "startDate",
                title: "<spring:message code='start.date'/>",
                align: "center",
                filterOperator: "contains"
            },
            {name: "endDate", title: "<spring:message code='end.date'/>", align: "center", filterOperator: "contains"},
            {name: "group", title: "<spring:message code='group'/>", align: "center", filterOperator: "equals"},
            {
                name: "teacher.fullNameFa",
                title: "<spring:message code='trainer'/>",
                align: "center",
                filterOperator: "contains"
            },
            {name: "version", title: "version", canEdit: false, hidden: true}
        ],
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        sortFieldAscendingText: "<spring:message code='sort.ascending'/>",
        sortFieldDescendingText: "<spring:message code='sort.descending'/>",
        configureSortText: "<spring:message code='configureSortText'/>",
        autoFitAllText: "<spring:message code='autoFitAllText'/>",
        autoFitFieldText: "<spring:message code='autoFitFieldText'/>",
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>"
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*DynamicForm Add Or Edit*/
    //--------------------------------------------------------------------------------------------------------------------//

    var DynamicForm_Class_JspClass = isc.DynamicForm.create({
        width: "700",
        height: "190",
        align: "center",
        canSubmit: true,
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: false,
        errorOrientation: "right",
        titleAlign: "right",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        numCols: 4,
        margin: 50,
        padding: 5,
        fields: [
            {name: "id", hidden: true},
            {
                name: "code",
                title: "<spring:message code='class.code'/>",
                disabled: true,
            },
            {
                name: "duration",
                title: "<spring:message code='duration'/>",
                keyPressFilter: "[0-9]",
                length: "4",
                validators: [{
                    type: "isInteger", validateOnExit: true, stopOnError: true,
                    errorMessage: "<spring:message code='msg.number.type'/>"
                }]
            },
            {
                name: "courseId",
                title: "<spring:message code='course.code'/>",
                textAlign: "center",
                required: true,
                editorType: "ComboBoxItem",
                pickListWidth: 230,
                addUnknownValues: false,
                changeOnKeypress: false,
                displayField: "code",
                valueField: "id",
                optionDataSource: RestDataSource_Course_JspClass,
                autoFetchData: true,
                cachePickListResults: true,
                useClientFiltering: true,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true,
                },
                pickListFields: [
                    {
                        name: "code",
                        title: "<spring:message code='course.code'/>",
                        width: "70%",
                        filterOperator: "contains"
                    },
                    {
                        name: "titleFa",
                        title: "<spring:message code='course.title'/>",
                        width: "70%",
                        filterOperator: "contains"
                    }
                ],
                changed: function (form, item, value) {
                    (form.getItem("course.titleFa")).setValue(form.getItem("courseId").getSelectedRecord().titleFa);
                },
            },

            {
                name: "startDate",
                title: "<spring:message code='start.date'/>",
                ID: "startDate_jspClass",
                type: 'text', required: true,
                hint: "YYYY/MM/DD",
                keyPressFilter:"[0-9/]",
                showHintInField: true,
                focus: function () {
                    displayDatePicker('startDate_jspClass', this, 'ymd', '/');
                },
                icons: [{
                    src: "pieces/pcal.png",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('startDate_jspClass', this, 'ymd', '/');
                    }
                }],
                blur: function () {
                    var dateCheck = false;
                    dateCheck = checkDate(DynamicForm_Class_JspClass.getValue("startDate"));
                    startDateCheck = dateCheck;
                    if (dateCheck == false)
                        DynamicForm_Class_JspClass.addFieldErrors("startDate", "<spring:message code='msg.correct.date'/>", true);
                    if (dateCheck == true)
                       DynamicForm_Class_JspClass.clearFieldErrors("startDate", true);
                }
            },

            {
                name: "course.titleFa",
                title: "<spring:message code='course.title'/>",
                disabled: true
            },

            {
                name: "endDate",
                title: "<spring:message code='end.date'/>",
                ID: "endDate_jspClass",
                type: 'text', required: true,
                hint: "YYYY/MM/DD",
                keyPressFilter:"[0-9/]",
                showHintInField: true,
                focus: function () {
                    displayDatePicker('endDate_jspClass', this, 'ymd', '/');
                },
                icons: [{
                    src: "pieces/pcal.png",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('endDate_jspClass', this, 'ymd', '/');
                    }
                }],
                blur: function () {
                    var dateCheck = false;
                    dateCheck = checkDate(DynamicForm_Class_JspClass.getValue("endDate"));
                    var endDate = DynamicForm_Class_JspClass.getValue("endDate");
                    var startDate = DynamicForm_Class_JspClass.getValue("startDate");
                    if (dateCheck == false){
                            DynamicForm_Class_JspClass.clearFieldErrors("endDate", true);
                            DynamicForm_Class_JspClass.addFieldErrors("endDate", "<spring:message code='msg.correct.date'/>", true);
                            endDateCheck = false;
                        }
                    if (dateCheck == true){
                        if(startDate == undefined)
                            DynamicForm_Class_JspClass.clearFieldErrors("endDate", true);
                        if(startDate != undefined && startDate > endDate){
                            DynamicForm_Class_JspClass.clearFieldErrors("endDate", true);
                            DynamicForm_Class_JspClass.addFieldErrors("endDate", "<spring:message code='msg.date.order'/>", true);
                            endDateCheck = false;
                        }
                        if(startDate != undefined && startDate < endDate){
                            DynamicForm_Class_JspClass.clearFieldErrors("endDate", true);
                            endDateCheck = true;
                        }
                       }
                }

            },

            {
                name: "group",
                title: "<spring:message code='group'/>",
                required: true,
                keyPressFilter: "[0-9]",
                length: "4",
                validators: [{
                    type: "isInteger", validateOnExit: true, stopOnError: true,
                    errorMessage: "<spring:message code='msg.number.type'/>"
                }]
            },

            {
                name: "teacherId",
                title: "<spring:message code='trainer'/>",
                textAlign: "center",
                editorType: "ComboBoxItem",
                pickListWidth: 230,
                changeOnKeypress: true,
                displayField: "fullNameFa",
                valueField: "id",
                required: true,
                optionDataSource: RestDataSource_Teacher_JspClass,
                autoFetchData: true,
// addUnknownValues: false,
                cachePickListResults: true,
// useClientFiltering: false,
                filterFields: ["fullNameFa"],
                sortField: ["id"],
                textMatchStyle: "contains",
// generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true,
                },
                pickListFields: [
                    {name: "fullNameFa", width: "70%", filterOperator: "contains"}],
                changed: function (form, item, value) {
                },
            }
        ],
        itemChanged: function (item, newValue) {
            if (item.name == "courseId" || item.name == "startDate" || item.name == "group") {
                if(DynamicForm_Class_JspClass.getItem("courseId").getSelectedRecord() != undefined)
                        str1 = DynamicForm_Class_JspClass.getItem("courseId").getSelectedRecord().code;
                if(DynamicForm_Class_JspClass.getItem("startDate").getValue() != undefined)
                    str2 = DynamicForm_Class_JspClass.getItem("startDate").getValue().substring(0,4);
                if(DynamicForm_Class_JspClass.getItem("group").getValue() != undefined)
                    str3 = DynamicForm_Class_JspClass.getItem("group").getValue();
                var code_value = str1 + "-" + str2 + "-" + str3;
                DynamicForm_Class_JspClass.getItem("code").setValue(code_value);
            }
        }
    });

    var IButton_Class_Exit_JspClass = isc.IButton.create({
        top: 260,
        title: "<spring:message code='cancel'/>",
        icon: "pieces/16/icon_delete.png",
        align: "center",
        click: function () {
            Window_Class_JspClass.close();
        }
    });

    var IButton_Class_Save_JspClass = isc.IButton.create({
        top: 260,
        title: "<spring:message code='save'/>",
        icon: "pieces/16/save.png",
        align: "center",
        click: function () {

            if (startDateCheck == false || endDateCheck == false)
                return;
            DynamicForm_Class_JspClass.validate();
            if (DynamicForm_Class_JspClass.hasErrors()) {
                return;
            }

            var data = DynamicForm_Class_JspClass.getValues();

            isc.RPCManager.sendRequest({
                actionURL: url,
                httpMethod: method,
                httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                showPrompt: false,
                data: JSON.stringify(data),
                serverOutputAsString: false,
                callback: function (resp) {
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                        var responseID = JSON.parse(resp.data).id;
                        var gridState = "[{id:" + responseID + "}]";
                        var OK = isc.Dialog.create({
                            message: "<spring:message code='msg.operation.successful'/>",
                            icon: "[SKIN]say.png",
                            title: "<spring:message code='msg.command.done'/>"
                        });
                        setTimeout(function () {
                            OK.close();
                            ListGrid_Class_JspClass.setSelectedState(gridState);
                        }, 1000);
                        ListGrid_Class_refresh();
                        Window_Class_JspClass.close();
                    } else {
                        var ERROR = isc.Dialog.create({
                            message: ("<spring:message code='msg.operation.error'/>"),
                            icon: "[SKIN]stop.png",
                            title: "<spring:message code='message'/>"
                        });
                        setTimeout(function () {
                            ERROR.close();
                        }, 3000);
                    }

                }
            });
        }
    });

    var HLayOut_ClassSaveOrExit_JspClass = isc.HLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "700",
        height: "10",
        alignLayout: "center",
        align: "center",
        padding: 10,
        membersMargin: 10,
        members: [IButton_Class_Save_JspClass, IButton_Class_Exit_JspClass]
    });

    var Window_Class_JspClass = isc.Window.create({
        title: "<spring:message code='class'/>",
        width: 700,
        height: 200,
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: false,
        border: "1px solid gray",
        closeClick: function () {
            this.Super("closeClick", arguments);
        },
        items: [isc.VLayout.create({
            width: "100%",
            height: "100%",
            members: [DynamicForm_Class_JspClass, HLayOut_ClassSaveOrExit_JspClass]
        })]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Add Student Section*/
    //--------------------------------------------------------------------------------------------------------------------//

    var DynamicForm_ClassStudentHeaderGridHeader_JspClass = isc.DynamicForm.create({
        titleWidth: 400,
        width: 700,
        align: "right",
        fields: [
            {name: "id", type: "hidden", title: ""},
            {
                name: "course.titleFa",
                type: "staticText",
                title: "<spring:message code='course.title'/>",
                wrapTitle: false,
                width: 250
            },
            {
                name: "group",
                type: "staticText",
                title: "<spring:message code='group'/>",
                wrapTitle: false,
                width: 250
            }
        ]
    });

    var ListGrid_All_Students_JspClass = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        canAcceptDroppedRecords: true,
        canReorderRecords: true,
        dragTrackerMode: "none",
        dataSource: RestDataSource_Class_Student_JspClass,
        showRowNumbers: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        autoFetchData: false,
        border: "0px solid green",
        showConnectors: true,
        canDragRecordsOut: true,
        closedIconSuffix: "",
        openIconSuffix: "",
        selectedIconSuffix: "",
        dropIconSuffix: "",
        showOpenIcons: false,
        showDropIcons: false,
        selectionType: "multiple",
        canDragSelect: false,
        rowNumberFieldProperties: {
            autoFitWidthApproach: "both",
            canDragResize: true,
            autoFitWidth: false,
            headerTitle: "<spring:message code='row'/>",
            width: 50
        },
        fields: [
            {name: "id", hidden: true},
            {name: "fullNameFa", title: "<spring:message code='firstName'/>", align: "center"},
            {name: "studentID", title: "<spring:message code='student.ID'/>", align: "center"}
        ],
        recordDoubleClick: function (viewer, record, recordNum, field, fieldNum, value, rawValue) {
            var StudentRecord = record;
            var StudentID = StudentRecord.id;
            var ClassRecord = ListGrid_Class_JspClass.getSelectedRecord();
            var ClassID = ClassRecord.id;
            isc.RPCManager.sendRequest({
                httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                actionURL: "${restApiUrl}/api/tclass/addStudent/" + StudentID + "/" + ClassID,
                httpMethod: "POST",
                serverOutputAsString: false,
                callback: function (resp) {
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                        ListGrid_Current_Students_JspClass.invalidateCache();
                        ListGrid_All_Students_JspClass.invalidateCache();
                    } else {
                        isc.say("<spring:message code='error'/>");
                    }
                }
            });
        },
        dataPageSize: 50,
    });

    var ListGrid_Current_Students_JspClass = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        autoDraw: false,
        canDragRecordsOut: false,
        dragTrackerMode: "none",
        canAcceptDroppedRecords: true,
        canReorderRecords: true,
        alternateRecordStyles: true,
        alternateFieldStyles: false,
        dataSource: RestDataSource_Class_CurrentStudent_JspClass,
        canDragSelect: true,
        autoFetchData: false,
        showRowNumbers: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        rowNumberFieldProperties: {
            autoFitWidthApproach: "both",
            canDragResize: true,
            autoFitWidth: false,
            headerTitle: "<spring:message code='row'/>",
            width: 50
        },
        canEdit: true,
        editEvent: "click",
        editByCell: true,
        rowEndEditAction: "done",
        listEndEditAction: "next",
        fields: [
            {name: "id", hidden: true},
            {
                name: "fullNameFa", title: "<spring:message
        code='firstName'/>", align: "center", width: "25%", canEdit: false
            },
            {
                name: "studentID",
                title: "<spring:message code='student.ID'/>",
                align: "center",
                width: "25%",
                canEdit: false
            },
            {name: "iconDelete", title: "<spring:message code='remove'/>", width: "15%", align: "center"}
        ],

        recordDrop: function (dropRecords, targetRecord, index, sourceWidget) {
            var ClassRecord = ListGrid_Class_JspClass.getSelectedRecord();
            var ClassID = ClassRecord.id;
            var StudentID = new Array();
            for (i = 0; i < dropRecords.getLength(); i++) {
                StudentID.add(dropRecords[i].id);
            }
            var JSONObj = {"ids": StudentID};
            isc.RPCManager.sendRequest({
                httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                actionURL: "${restApiUrl}/api/tclass/addStudents/" + ClassID,
                httpMethod: "POST",
                data: JSON.stringify(JSONObj),
                serverOutputAsString: false,
                callback: function (resp) {
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                        ListGrid_Current_Students_JspClass.invalidateCache();
                        ListGrid_All_Students_JspClass.invalidateCache();
                    } else {
                        isc.say("<spring:message code='error'/>");
                    }
                }
            });
        },

        createRecordComponent: function (record, colNum) {
            var fieldName = this.getFieldName(colNum);

            if (fieldName == "iconDelete") {
                var recordCanvas = isc.HLayout.create({
                    height: 22,
                    width: "100%",
                    layoutMargin: 5,
                    membersMargin: 10,
                    align: "center"
                });

                var removeIcon = isc.ImgButton.create({
                    showDown: false,
                    showRollOver: false,
                    layoutAlign: "center",
                    src: "pieces/16/icon_delete.png",
                    prompt: "<spring:message code='remove'/>",
                    height: 16,
                    width: 16,
                    grid: this,
                    click: function () {
                        var ClassRecord = ListGrid_Class_JspClass.getSelectedRecord();
                        var ClassID = ClassRecord.id;
                        var StudentRecord = record;
                        var StudentID = StudentRecord.id;
                        isc.RPCManager.sendRequest({
                            httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            actionURL: "${restApiUrl}/api/tclass/removeStudent/" + StudentID + "/" + ClassID,
                            httpMethod: "DELETE",
                            serverOutputAsString: false,
                            callback: function (resp) {
                                if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                                    ListGrid_Current_Students_JspClass.invalidateCache();
                                    ListGrid_All_Students_JspClass.invalidateCache();
                                } else {
                                    isc.say("<spring:message code='error'/>");
                                }
                            }
                        });
                    }
                });
                recordCanvas.addMember(removeIcon);
                return recordCanvas;
            } else
                return null;
        },
        dataPageSize: 50
    });

    var SectionStack_All_Student_JspClass = isc.SectionStack.create({
        visibilityMode: "multiple",
        width: "50%",
        sections: [
            {
                title: "<spring:message code='unregistred.students'/>",
                expanded: true,
                canCollapse: false,
                align: "center",
                items: [
                    ListGrid_All_Students_JspClass
                ]
            }
        ]
    });

    var SectionStack_Current_Student_JspClass = isc.SectionStack.create({
        visibilityMode: "multiple",
        width: "50%",
        sections: [
            {
                title: "<spring:message code='registred.students'/>",
                expanded: true,
                canCollapse: false,
                align: "center",
                items: [
                    ListGrid_Current_Students_JspClass
                ]
            }
        ]
    });

    var HStack_ClassStudent_JspClass = isc.HStack.create({
        membersMargin: 10,
        height: 500,
        members: [
            SectionStack_All_Student_JspClass,
            SectionStack_Current_Student_JspClass
        ]
    });

    var HLayOut_ClassStudentGridHeader_JspClass = isc.HLayout.create({
        width: 700,
        height: 30,
        border: "0px solid yellow",
        layoutMargin: 5,
        align: "center",
        members: [
            DynamicForm_ClassStudentHeaderGridHeader_JspClass
        ]
    });

    var VLayOut_ClassStudent_JspClass = isc.VLayout.create({
        width: "100%",
        height: 400,
        autoDraw: false,
        border: "0px solid red", layoutMargin: 5,
        members: [
            HLayOut_ClassStudentGridHeader_JspClass,
            HStack_ClassStudent_JspClass
        ]
    });

    var Window_AddStudents_JspClass = isc.Window.create({
        title: "<spring:message code='students.list'/>",
        width: 900,
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: true,
        closeClick: function () {
            this.hide();
        },
        items: [
            VLayOut_ClassStudent_JspClass
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*ToolStrips and Layout*/
    //--------------------------------------------------------------------------------------------------------------------//

    var ToolStripButton_Refresh_JspClass = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/refresh.png",
        title: "<spring:message code='refresh'/>",
        click: function () {
            ListGrid_Class_refresh();
        }
    });

    var ToolStripButton_Edit_JspClass = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/edit.png",
        title: "<spring:message code='edit'/>",
        click: function () {
            ListGrid_class_edit();
        }
    });

    var ToolStripButton_Add_JspClass = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/add.png",
        title: "<spring:message code='create'/>",
        click: function () {
            ListGrid_Class_add();
        }
    });

    var ToolStripButton_Remove_JspClass = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/remove.png",
        title: "<spring:message code='remove'/>",
        click: function () {
            ListGrid_class_remove();
        }
    });

    var ToolStripButton_Print_JspClass = isc.ToolStripButton.create({
        icon: "[SKIN]/RichTextEditor/print.png",
        title: "<spring:message code='print'/>",
        click: function () {
            var advancedCriteria = ListGrid_Class_JspClass.getCriteria();
            var criteriaForm = isc.DynamicForm.create({
                method: "POST",
                action: "/tclass/printWithCriteria/pdf",
                target: "_Blank",
                canSubmit: true,
                fields:
                    [
                        {name: "CriteriaStr", type: "hidden"}
                    ]
            });
            criteriaForm.setValue("CriteriaStr", JSON.stringify(advancedCriteria));
            criteriaForm.submitForm();
        }
    });

    var ToolStripButton_Add_Student_JspClass = isc.ToolStripButton.create({
        icon: "icon/classroom.png",
        title: " <spring:message code='students.list'/>",
        click: function () {
            Add_Student();
        }
    });

    var ToolStrip_Actions_JspClass = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStripButton_Refresh_JspClass,
            ToolStripButton_Add_JspClass,
            ToolStripButton_Edit_JspClass,
            ToolStripButton_Remove_JspClass,
            ToolStripButton_Print_JspClass,
            ToolStripButton_Add_Student_JspClass]
    });

    var HLayout_Actions_Class_JspClass = isc.HLayout.create({
        width: "100%",
        members: [ToolStrip_Actions_JspClass]
    });

    var HLayout_Grid_Class_JspClass = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [ListGrid_Class_JspClass]
    });

    var VLayout_Body_Class_JspClass = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            HLayout_Actions_Class_JspClass
            , HLayout_Grid_Class_JspClass
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Functions*/
    //--------------------------------------------------------------------------------------------------------------------//

    function ListGrid_class_remove() {
        var record = ListGrid_Class_JspClass.getSelectedRecord();
        if (record == null) {
            isc.Dialog.create({
                message: "<spring:message code='msg.record.not.selected'/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code='message'/>",
                buttons: [isc.Button.create({title: "<spring:message code='ok'/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            var Dialog_Delete = isc.Dialog.create({
                message: "<spring:message code='msg.record.remove.ask'/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code='msg.remove.title'/>",
                buttons: [isc.Button.create({title: "<spring:message code='yes'/>"}), isc.Button.create({
                    title: "<spring:message code='no'/>"
                })],
                buttonClick: function (button, index) {
                    this.close();

                    if (index == 0) {
                        var wait = isc.Dialog.create({
                            message: "<spring:message code='msg.waiting'/>",
                            icon: "[SKIN]say.png",
                            title: "<spring:message code='message'/>"
                        });
                        isc.RPCManager.sendRequest({
                            actionURL: "${restApiUrl}/api/tclass/" + record.id,
                            httpMethod: "DELETE",
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                            showPrompt: true,
                            serverOutputAsString: false,
                            callback: function (resp) {
                                wait.close();
                                if (resp.httpResponseCode == 200) {
                                    ListGrid_Class_JspClass.invalidateCache();
                                    var OK = isc.Dialog.create({
                                        message: "<spring:message code='msg.record.remove.successful'/>",
                                        icon: "[SKIN]say.png",
                                        title: "<spring:message code='msg.command.done'/>"
                                    });
                                    setTimeout(function () {
                                        OK.close();
                                    }, 3000);
                                } else {
                                    var ERROR = isc.Dialog.create({
                                        message: "<spring:message code='msg.record.remove.failed'/>",
                                        icon: "[SKIN]stop.png",
                                        title: "<spring:message code='message'/>"
                                    });
                                    setTimeout(function () {
                                        ERROR.close();
                                    }, 3000);
                                }
                            }
                        });
                    }
                }
            });
        }
    }

    function ListGrid_class_edit() {
        var record = ListGrid_Class_JspClass.getSelectedRecord();
        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "<spring:message code='msg.record.not.selected'/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code='message'/>",
                buttons: [isc.Button.create({title: "<spring:message code='ok'/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            method = "PUT";
            url = "${restApiUrl}/api/tclass/" + record.id;
            DynamicForm_Class_JspClass.clearValues();
            DynamicForm_Class_JspClass.editRecord(record);
            (DynamicForm_Class_JspClass.getItem("course.titleFa")).setValue(DynamicForm_Class_JspClass.getItem("courseId").getSelectedRecord().titleFa);
            Window_Class_JspClass.show();
        }
    }

    function ListGrid_Class_refresh() {
        ListGrid_Class_JspClass.invalidateCache();
    }

    function ListGrid_Class_add() {
        method = "POST";
        url = "${restApiUrl}/api/tclass";
        DynamicForm_Class_JspClass.clearValues();
        Window_Class_JspClass.show();
    }

    function Add_Student() {

        var record = ListGrid_Class_JspClass.getSelectedRecord();
        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "<spring:message code='msg.record.not.selected'/>",
                icon: "<spring:url value='[SKIN]ask.png'/>",
                title: "<spring:message code='message'/>",
                buttons: [isc.Button.create({title: " <spring:message code='ok'/> "})],
                buttonClick: function () {
                    this.close();
                }
            });
        } else {
            ListGrid_All_Students_JspClass.invalidateCache();
            ListGrid_Current_Students_JspClass.invalidateCache();
            DynamicForm_ClassStudentHeaderGridHeader_JspClass.invalidateCache();

            DynamicForm_ClassStudentHeaderGridHeader_JspClass.setValue("course.titleFa", record.course.titleFa);
            DynamicForm_ClassStudentHeaderGridHeader_JspClass.setValue("group", record.group);
            DynamicForm_ClassStudentHeaderGridHeader_JspClass.setValue("id", record.id);
            ListGrid_All_Students_JspClass.fetchData({"classID": record.id});
            ListGrid_Current_Students_JspClass.fetchData({"classID": record.id});
            Window_AddStudents_JspClass.show();
        }

    }


