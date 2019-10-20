<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    var classMethod = "POST";
    var classWait;

    var str1 = "";
    var str2 = "";
    var str3 = "";

    var startDateCheck = true;
    var endDateCheck = true;

    //--------------------------------------------------------------------------------------------------------------------//
    /*Rest Data Sources*/
    //--------------------------------------------------------------------------------------------------------------------//

    var RestDataSource_Class_JspClass = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "group"},
            {name: "startDate"},
            {name: "endDate"},
            {name: "code"},
            {name: "duration"},
            {name: "teacher.personality.lastNameFa"},
            {name: "course.code"},
            {name: "course.titleFa"}
        ],
        fetchDataURL: classUrl + "spec-list"
    });

    var RestDataSource_Teacher_JspClass = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "personality"}
        ],
        fetchDataURL: teacherUrl + "fullName-list?_startRow=0&_endRow=55"
    });

    var RestDataSource_Course_JspClass = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "titleFa"},
            {name: "theoryDuration"}
        ],
        fetchDataURL: courseUrl + "spec-list?_startRow=0&_endRow=55"
    });

    var RestDataSource_Class_Student_JspClass = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "personality.lastNameFa"},
            {name: "studentID"}
        ],
        fetchDataURL: classUrl + "otherStudent"
    });

    var RestDataSource_Class_CurrentStudent_JspClass = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "personality.lastNameFa"},
            {name: "studentID"}
        ],
        fetchDataURL: classUrl + "student"
    });

    var RestDataSource_Term_JspClass = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "startDate"},
            {name: "endDate"}
        ],
        fetchDataURL: termUrl + "spec-list?_startRow=0&_endRow=55"
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Menu*/
    //--------------------------------------------------------------------------------------------------------------------//

    var Menu_ListGrid_Class_JspClass = isc.Menu.create({
        // width: 150,
        data: [{
            title: "<spring:message code='refresh'/>", icon: "<spring:url value="refresh.png"/>", click: function () {
                ListGrid_Class_refresh();
            }
        }, {
            title: "<spring:message code='create'/>", icon: "<spring:url value="create.png"/>", click: function () {
                ListGrid_Class_add();
            }
        }, {
            title: "<spring:message code='edit'/>", icon: "<spring:url value="edit.png"/>", click: function () {
                ListGrid_class_edit();
            }
        }, {
            title: "<spring:message code='remove'/>", icon: "<spring:url value="remove.png"/>",
            click: function () {
                ListGrid_class_remove();
            }
        }, {isSeparator: true}, {
            title: "<spring:message code='print.pdf'/>", icon: "<spring:url value="pdf.png"/>", click: function () {
                ListGrid_class_print("pdf");
            }
        }, {
            title: "<spring:message code='print.excel'/>", icon: "<spring:url value="excel.png"/>", click: function () {
                ListGrid_class_print("excel");
            }
        }, {
            title: "<spring:message code='print.html'/>", icon: "<spring:url value="html.png"/>", click: function () {
                ListGrid_class_print("html");
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
    /*ListGrid*/
    //--------------------------------------------------------------------------------------------------------------------//

    var ListGrid_Class_JspClass = isc.TrLG.create({
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
                filterOperator: "equals",
                sortNormalizer: function (record) {
                    return record.course.code;
                }
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
            {name: "duration", title: "<spring:message code='duration'/>", align: "center", filterOperator: "equals"},
            {
                name: "startDate",
                title: "<spring:message code='start.date'/>",
                align: "center",
                filterOperator: "iContains"
            },
            {name: "endDate", title: "<spring:message code='end.date'/>", align: "center", filterOperator: "contains"},
            {name: "group", title: "<spring:message code='group'/>", align: "center", filterOperator: "equals"},
            {
                name: "teacher.personality.lastNameFa",
                title: "<spring:message code='trainer'/>",
                align: "center",
                filterOperator: "iContains",
                sortNormalizer: function (record) {
                    return record.teacher.personality.lastNameFa;
                }
            }
        ],
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
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
        numCols: 4,
        padding: 10,
        align: "center",
      /*  margin: 50,

        canTabToIcons: false,*/
        fields: [
            {name: "id", hidden: true},
            {
                name: "course.titleFa",
                title: "<spring:message code='course.title'/>",
                disabled: true
            },
            {
                name: "code",
                title: "<spring:message code='class.code'/>",
                disabled: true
            },
            {
                name: "courseId",
                title: "<spring:message code='course.code'/>",
                textAlign: "center",
                required: true,
                editorType: "ComboBoxItem",
                // pickListWidth: 230,
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
                pickListFields: [
                    {
                        name: "code",
                        title: "<spring:message code='course.code'/>",
                        width: "70%",
                        filterOperator: "iContains"
                    },
                    {
                        name: "titleFa",
                        title: "<spring:message code='course.title'/>",
                        width: "70%",
                        filterOperator: "iContains"
                    }
                ],
                changed: function (form) {
                    (form.getItem("course.titleFa")).setValue(form.getItem("courseId").getSelectedRecord().titleFa);
                    (form.getItem("duration")).setValue(form.getItem("courseId").getSelectedRecord().theoryDuration);
                }
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
                // pickListWidth: 230,
                // changeOnKeypress: true,
                displayField: "personality.lastNameFa",
                valueField: "id",
                required: true,
                optionDataSource: RestDataSource_Teacher_JspClass,
                autoFetchData: true,
                cachePickListResults: false,
                // filterFields: ["personality.lastNameFa"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                addUnknownValues: false,
                // pickListFields:
                //     [{name: "personality.lastNameFa", filterOperator: "iContains"}]
            },
            {
                name: "startDate",
                title: "<spring:message code='start.date'/>",
                ID: "startDate_jspClass",
                required: true,
                hint: "YYYY/MM/DD",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('startDate_jspClass', this, 'ymd', '/');
                    }
                }],
                changed: function () {
                    var dateCheck;
                    dateCheck = checkDate(DynamicForm_Class_JspClass.getValue("startDate"));
                    startDateCheck = dateCheck;
                    if (dateCheck === false)
                        DynamicForm_Class_JspClass.addFieldErrors("startDate", "<spring:message code='msg.correct.date'/>", true);
                    if (dateCheck === true)
                        DynamicForm_Class_JspClass.clearFieldErrors("startDate", true);
                }
            },
            {
                name: "endDate",
                title: "<spring:message code='end.date'/>",
                ID: "endDate_jspClass",
                type: 'text', required: true,
                hint: "YYYY/MM/DD",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('endDate_jspClass', this, 'ymd', '/');
                    }
                }],
                changed: function () {
                    var dateCheck;
                    dateCheck = checkDate(DynamicForm_Class_JspClass.getValue("endDate"));
                    var endDate = DynamicForm_Class_JspClass.getValue("endDate");
                    var startDate = DynamicForm_Class_JspClass.getValue("startDate");
                    if (dateCheck === false) {
                        DynamicForm_Class_JspClass.clearFieldErrors("endDate", true);
                        DynamicForm_Class_JspClass.addFieldErrors("endDate", "<spring:message code='msg.correct.date'/>", true);
                        endDateCheck = false;
                    }
                    if (dateCheck === true) {
                        if (startDate === undefined)
                            DynamicForm_Class_JspClass.clearFieldErrors("endDate", true);
                        if (startDate !== undefined && startDate > endDate) {
                            DynamicForm_Class_JspClass.clearFieldErrors("endDate", true);
                            DynamicForm_Class_JspClass.addFieldErrors("endDate", "<spring:message code='msg.date.order'/>", true);
                            endDateCheck = false;
                        }
                        if (startDate !== undefined && startDate < endDate) {
                            DynamicForm_Class_JspClass.clearFieldErrors("endDate", true);
                            endDateCheck = true;
                        }
                    }
                }
            },
            {
                name: "termId",
                title: "<spring:message code='term'/>",
                textAlign: "center",
                required: true,
                editorType: "ComboBoxItem",
                displayField: "code",
                valueField: "id",
                optionDataSource: RestDataSource_Term_JspClass,
                autoFetchData: true,
                cachePickListResults: true,
                useClientFiltering: true,
                filterFields: ["code"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                colSpan: 3,
                pickListFields: [
                    {
                        name: "code",
                        title: "<spring:message code='term.code'/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "startDate",
                        title: "<spring:message code='start.date'/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "endDate",
                        title: "<spring:message code='end.date'/>",
                        filterOperator: "iContains"
                    }
                ]
            }
        ],
        itemChanged: function (item) {
            if (item.name === "courseId" || item.name === "termId" || item.name === "group") {
                if (DynamicForm_Class_JspClass.getItem("courseId").getSelectedRecord() !== undefined)
                    str1 = DynamicForm_Class_JspClass.getItem("courseId").getSelectedRecord().code;
                if (DynamicForm_Class_JspClass.getItem("termId").getSelectedRecord() !== undefined)
                    str2 = DynamicForm_Class_JspClass.getItem("termId").getSelectedRecord().code;
                if (DynamicForm_Class_JspClass.getItem("group").getValue() !== undefined)
                    str3 = DynamicForm_Class_JspClass.getItem("group").getValue();
                var code_value = str1 + "/" + str2 + "/" + str3;
                DynamicForm_Class_JspClass.getItem("code").setValue(code_value);
            }
        }
    });

    var IButton_Class_Exit_JspClass = isc.TrCancelBtn.create({
        icon: "<spring:url value="remove.png"/>",
        align: "center",
        click: function () {
            Window_Class_JspClass.close();
        }
    });

    var IButton_Class_Save_JspClass = isc.TrSaveBtn.create({
        align: "center",
        click: function () {

            if (startDateCheck === false || endDateCheck === false)
                return;
            DynamicForm_Class_JspClass.validate();
            if (DynamicForm_Class_JspClass.hasErrors()) {
                return;
            }

            var data = DynamicForm_Class_JspClass.getValues();

            var classSaveUrl = classUrl;
            if (classMethod.localeCompare("PUT") === 0) {
                var classRecord = ListGrid_Class_JspClass.getSelectedRecord();
                classSaveUrl += classRecord.id;
            }

            isc.RPCManager.sendRequest(TrDSRequest(classSaveUrl, classMethod, JSON.stringify(data), "callback: class_action_result(rpcResponse)"));
        }
    });

    var HLayOut_ClassSaveOrExit_JspClass = isc.TrHLayoutButtons.create({
        members: [IButton_Class_Save_JspClass, IButton_Class_Exit_JspClass]
    });

    var Window_Class_JspClass = isc.Window.create({
        title: "<spring:message code='class'/>",
        width: 700,
        height: 200,
        align: "center",
        border: "1px solid gray",
        closeClick: function () {
            this.Super("closeClick", arguments);
        },
        items: [isc.TrVLayout.create({
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
            {name: "lastNameFa", title: "<spring:message code='firstName'/>", align: "center"},
            {name: "studentID", title: "<spring:message code='student.ID'/>", align: "center"}
        ],
        recordDoubleClick: function (viewer, record) {
            var StudentID = record.id;
            var ClassRecord = ListGrid_Class_JspClass.getSelectedRecord();
            var ClassID = ClassRecord.id;
            isc.RPCManager.sendRequest(TrDSRequest(classUrl + "addStudent/" + StudentID + "/" + ClassID, "POST", null, "callback: class_add_student_result(rpcResponse)"));
        },
        dataPageSize: 50
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
                name: "lastNameFa", title: "<spring:message
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

        recordDrop: function (dropRecords) {
            var ClassRecord = ListGrid_Class_JspClass.getSelectedRecord();
            var ClassID = ClassRecord.id;
            var StudentID = [];
            for (var i = 0; i < dropRecords.getLength(); i++) {
                StudentID.add(dropRecords[i].id);
            }
            var JSONObj = {"ids": StudentID};
            isc.RPCManager.sendRequest(TrDSRequest(classUrl + "addStudents/" + ClassID, "POST", JSON.stringify(JSONObj), "callback: class_add_students_result(rpcResponse)"));
        },

        createRecordComponent: function (record, colNum) {
            var fieldName = this.getFieldName(colNum);

            if (fieldName === "iconDelete") {
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
                        var StudentID = record.id;
                        isc.RPCManager.sendRequest(TrDSRequest(classUrl + "removeStudent/" + StudentID + "/" + ClassID, "DELETE", null, "callback: class_remove_student_result(rpcResponse)"));
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

    var ToolStripButton_Refresh_JspClass = isc.TrRefreshBtn.create({
        click: function () {
            ListGrid_Class_refresh();
        }
    });

    var ToolStripButton_Edit_JspClass = isc.TrEditBtn.create({
        click: function () {
            ListGrid_class_edit();
        }
    });

    var ToolStripButton_Add_JspClass = isc.TrCreateBtn.create({
        click: function () {
            ListGrid_Class_add();
        }
    });

    var ToolStripButton_Remove_JspClass = isc.TrRemoveBtn.create({
        click: function () {
            ListGrid_class_remove();
        }
    });

    var ToolStripButton_Print_JspClass = isc.ToolStripButton.create({
        icon: "[SKIN]/RichTextEditor/print.png",
        title: "<spring:message code='print'/>",
        click: function () {
            ListGrid_class_print("pdf");
        }
    });

    var ToolStripButton_Add_Student_JspClass = isc.ToolStripButton.create({
        // icon: "icon/classroom.png",
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

    var HLayout_Grid_Class_JspClass = isc.TrHLayout.create({
        members: [ListGrid_Class_JspClass]
    });

    var VLayout_Body_Class_JspClass = isc.TrVLayout.create({
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
            createDialog("info", "<spring:message code='msg.not.selected.record'/>");
        } else {
            var Dialog_Class_remove = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                "<spring:message code='global.warning'/>");
            Dialog_Class_remove.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        classWait = createDialog("wait");
                        isc.RPCManager.sendRequest(TrDSRequest(classUrl + record.id, "DELETE", null, "callback: class_delete_result(rpcResponse)"));
                    }
                }
            });
        }
    }

    function ListGrid_class_edit() {
        var record = ListGrid_Class_JspClass.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.not.selected.record'/>");
        } else {
            classMethod = "PUT";
            url = classUrl + record.id;
            DynamicForm_Class_JspClass.clearValues();
            DynamicForm_Class_JspClass.editRecord(record);
            // DynamicForm_Class_JspClass.getField("courseId").fetchData();
            // DynamicForm_Class_JspClass.getField("courseId").setValue(record.courseId);
            DynamicForm_Class_JspClass.getItem("course.titleFa").setValue(DynamicForm_Class_JspClass.getItem("courseId").getSelectedRecord().titleFa);
            Window_Class_JspClass.show();
        }
    }

    function ListGrid_Class_refresh() {
        ListGrid_Class_JspClass.invalidateCache();
        ListGrid_Class_JspClass.filterByEditor();
    }

    function ListGrid_Class_add() {
        classMethod = "POST";
        url = classUrl;
        DynamicForm_Class_JspClass.clearValues();
        Window_Class_JspClass.show();
    }

    function ListGrid_class_print(type) {
        var advancedCriteria = ListGrid_Class_JspClass.getCriteria();
        var criteriaForm = isc.DynamicForm.create({
            method: "POST",
            action: "<spring:url value="/tclass/printWithCriteria/"/>" + type,
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "CriteriaStr", type: "hidden"}
                ]
        });
        criteriaForm.setValue("CriteriaStr", JSON.stringify(advancedCriteria));
        criteriaForm.show();
        criteriaForm.submitForm();
    }

    function class_action_result(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            var responseID = JSON.parse(resp.data).id;
            var gridState = "[{id:" + responseID + "}]";
            var OK = createDialog("info", "<spring:message code='msg.operation.successful'/>",
                "<spring:message code="msg.command.done"/>");
            setTimeout(function () {
                OK.close();
                ListGrid_Class_JspClass.setSelectedState(gridState);
            }, 1000);
            ListGrid_Class_refresh();
            Window_Class_JspClass.close();
        } else {
            createDialog("info", "<spring:message code='error'/>");
        }
    }

    function class_delete_result(resp) {
        classWait.close();
        if (resp.httpResponseCode === 200) {
            ListGrid_Class_JspClass.invalidateCache();
            var OK = createDialog("info", "<spring:message code='msg.operation.successful'/>",
                "<spring:message code="msg.command.done"/>");
            setTimeout(function () {
                OK.close();
            }, 3000);
        } else {
            createDialog("info", "<spring:message code='error'/>");
        }
    }

    function class_remove_student_result(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            ListGrid_Current_Students_JspClass.invalidateCache();
            ListGrid_All_Students_JspClass.invalidateCache();
        } else {
            isc.say("<spring:message code='error'/>");
        }
    }

    function class_add_student_result(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            ListGrid_Current_Students_JspClass.invalidateCache();
            ListGrid_All_Students_JspClass.invalidateCache();
        } else {
            isc.say("<spring:message code='error'/>");
        }
    }

    function class_add_students_result(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            ListGrid_Current_Students_JspClass.invalidateCache();
            ListGrid_All_Students_JspClass.invalidateCache();
        } else {
            isc.say("<spring:message code='error'/>");
        }
    }

    function Add_Student() {
        var record = ListGrid_Class_JspClass.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.not.selected.record'/>");
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

    // </script>