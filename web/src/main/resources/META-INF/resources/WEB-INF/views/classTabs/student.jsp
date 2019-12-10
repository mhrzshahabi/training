<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// script

    // ------------------------------------------- Menu -------------------------------------------
    StudentMenu_student = isc.Menu.create({
        data: [
            {
                title: "<spring:message code="refresh"/>", icon: "<spring:url value="refresh.png"/>", click: function () {
                    refreshStudentsLG_student();
                }
            },
            {
                title: "<spring:message code="add"/>", icon: "<spring:url value="create.png"/>", click: function () {
                    addStudent_student();
                }
            },
            {
                title: "<spring:message code="remove"/>", icon: "<spring:url value="remove.png"/>", click: function () {
                    removeStudent_student();
                }
            },
        ]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------
    StudentTS_student = isc.ToolStrip.create({
        members: [
            isc.TrRefreshBtn.create({
                click: function () {
                    refreshStudentsLG_student();
                }
            }),
            isc.TrAddBtn.create({
                click: function () {
                    addStudent_student();
                }
            }),
            isc.TrRemoveBtn.create({
                click: function () {
                    removeStudent_student();
                }
            }),
            <%--isc.TrPrintBtn.create({--%>
            <%--    menu: isc.Menu.create({--%>
            <%--        data: [--%>
            <%--            {--%>
            <%--                title: "<spring:message code="format.pdf"/>", icon: "<spring:url value="pdf.png"/>", click: function () {--%>
            <%--                    printStudentsLG_student("pdf");--%>
            <%--                }--%>
            <%--            },--%>
            <%--            {--%>
            <%--                title: "<spring:message code="format.excel"/>", icon: "<spring:url value="excel.png"/>", click: function () {--%>
            <%--                    printStudentsLG_student("excel");--%>
            <%--                }--%>
            <%--            },--%>
            <%--            {--%>
            <%--                title: "<spring:message code="format.html"/>", icon: "<spring:url value="html.png"/>", click: function () {--%>
            <%--                    printStudentsLG_student("html");--%>
            <%--                }--%>
            <%--            },--%>
            <%--        ]--%>
            <%--    })--%>
            <%--}),--%>
            isc.LayoutSpacer.create({width: "*"}),
            isc.Label.create({ID: "StudentsCount_student"}),
        ]
    });

    PersonnelsTS_student = isc.ToolStrip.create({
        members: [
            isc.LayoutSpacer.create({width: "*"}),
            isc.Label.create({ID: "PersonnelsCount_student"}),
        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------
    StudentsDS_student = isc.TrDS.create({
        fields: [
            {name: "id", hidden: true},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "companyName", title: "<spring:message code="company.name"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains"},

            {name: "postTitle", title: "<spring:message code="post"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpArea", title: "<spring:message code="reward.cost.center.area"/>", filterOperator: "iContains"},
            {name: "ccpAssistant", title: "<spring:message code="reward.cost.center.assistant"/>", filterOperator: "iContains"},
            {name: "ccpAffairs", title: "<spring:message code="reward.cost.center.affairs"/>", filterOperator: "iContains"},
            {name: "ccpSection", title: "<spring:message code="reward.cost.center.section"/>", filterOperator: "iContains"},
            {name: "ccpUnit", title: "<spring:message code="reward.cost.center.unit"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: classUrl + "student"
    });

    StudentsLG_student = isc.TrLG.create({
        dataSource: StudentsDS_student,
        fields: [
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
            {name: "ccpUnit"},
        ],
        gridComponents: [StudentTS_student, "filterEditor", "header", "body"],
        contextMenu: StudentMenu_student,
        dataChanged: function () {
            this.Super("dataChanged", arguments);
            totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown()) {
                StudentsCount_student.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            } else {
                StudentsCount_student.setContents("&nbsp;");
            }
        },
    });

    SelectedPersonnelsLG_student = isc.TrLG.create({
        ID: "SelectedPersonnelsLG_student",
        fields: [
            {name: "id", hidden: true},
            {name: "remove", tile: "<spring:message code="remove"/>", isRemoveField: true},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "companyName", title: "<spring:message code="company.name"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains"},
            {name: "postTitle", title: "<spring:message code="post"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpArea", title: "<spring:message code="reward.cost.center.area"/>", filterOperator: "iContains"},
            {name: "ccpAssistant", title: "<spring:message code="reward.cost.center.assistant"/>", filterOperator: "iContains"},
            {name: "ccpAffairs", title: "<spring:message code="reward.cost.center.affairs"/>", filterOperator: "iContains"},
            {name: "ccpSection", title: "<spring:message code="reward.cost.center.section"/>", filterOperator: "iContains"},
            {name: "ccpUnit", title: "<spring:message code="reward.cost.center.unit"/>", filterOperator: "iContains"},

        ],
        gridComponents: ["filterEditor", "header", "body"],
        canRemoveRecords: true,
    });

    PersonnelDS_student = isc.TrDS.create({
        fields: [
            {name: "id", hidden: true},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "companyName", title: "<spring:message code="company.name"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains",},
            {name: "postTitle", title: "<spring:message code="post"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpArea", title: "<spring:message code="reward.cost.center.area"/>", filterOperator: "iContains"},
            {name: "ccpAssistant", title: "<spring:message code="reward.cost.center.assistant"/>", filterOperator: "iContains"},
            {name: "ccpAffairs", title: "<spring:message code="reward.cost.center.affairs"/>", filterOperator: "iContains"},
            {name: "ccpSection", title: "<spring:message code="reward.cost.center.section"/>", filterOperator: "iContains"},
            {name: "ccpUnit", title: "<spring:message code="reward.cost.center.unit"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: personnelUrl + "iscList",
    });

    PersonnelsLG_student = isc.TrLG.create({
        dataSource: PersonnelDS_student,
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
            {name: "ccpUnit"},
        ],
        gridComponents: [PersonnelsTS_student, "filterEditor", "header", "body"],
        dataChanged: function () {
            this.Super("dataChanged", arguments);
            totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown()) {
                PersonnelsCount_student.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            } else {
                PersonnelsCount_student.setContents("&nbsp;");
            }
        },
        selectionAppearance: "checkbox",
        selectionUpdated: function () {
            SelectedPersonnelsLG_student.setData(this.getSelection().concat(SelectedPersonnelsLG_student.data).reduce(function (accumulator, current) {
                if (checkIfAlreadyExist(current)) {
                    return accumulator
                } else {
                    return accumulator.concat([current]);
                }

                function checkIfAlreadyExist(currentVal) {
                    return accumulator.some(function (item) {
                        return (item.nationalCode === currentVal.nationalCode);
                    });
                }
            }, []));
        }
    });

    // ------------------------------------------- DynamicForm & Window -------------------------------------------

    ClassStudentWin_student = isc.Window.create({
        width: 1024,
        height: 600,
        minWidth: 1024,
        minHeight: 600,
        autoSize: false,
        items: [
            isc.TrVLayout.create({
                members: [
                    isc.SectionStack.create({
                        sections: [{
                            title: "<spring:message code="all.persons"/>", expanded: true, canCollapse: false, align: "center", items: [PersonnelsLG_student]
                        }]
                    }),
                    isc.SectionStack.create({
                        sections: [{
                            title: "<spring:message code="selected.persons"/>", expanded: true, canCollapse: false, align: "center",
                            items: [
                                SelectedPersonnelsLG_student,
                                isc.TrHLayoutButtons.create({
                                    members: [
                                        isc.TrSaveBtn.create({
                                            click: function () {
                                                var classId = ListGrid_Class_JspClass.getSelectedRecord().id;
                                                var personnelsIds = SelectedPersonnelsLG_student.data.map(r = > r.personnelNo
                                            )
                                                ;

                                                var data = {"classId": classId, "personnelsIds": personnelsIds};
                                                if (personnelsIds.getLength() > 0)
                                                    isc.RPCManager.sendRequest(TrDSRequest(classUrl + "addStudents/" + classId, "POST", JSON.stringify({"ids": personnelsIds}), "callback: class_add_students_result(rpcResponse)"));
                                            }
                                        }), isc.TrCancelBtn.create({
                                            click: function () {
                                                ClassStudentWin_student.close();
                                            }
                                        }),
                                    ],
                                }),
                            ]
                        }
                        ]
                    }),
                ],
            })
        ]
    });

    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrVLayout.create({
        members: [StudentsLG_student],
    });

    // ------------------------------------------- Functions -------------------------------------------
    function refreshStudentsLG_student() {
        StudentsLG_student.filterByEditor();
    }

    function addStudent_student() {
        classRecord = ListGrid_Class_JspClass.getSelectedRecord();
        if (classRecord == null || classRecord.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            return;
        }
        ClassStudentWin_student.setTitle("<spring:message code="add.student.to.class"/> \'" + classRecord.titleClass + "\'");
        PersonnelsLG_student.invalidateCache();
        PersonnelsLG_student.fetchData();
        SelectedPersonnelsLG_student.setData([]);
        ClassStudentWin_student.show();
    }

    function class_add_students_result(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            var classId = ListGrid_Class_JspClass.getSelectedRecord().id;
            ClassStudentWin_student.close();
            StudentsLG_student.invalidateCache();
            StudentsLG_student.fetchData({"classID": classId});
            var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",
                "<spring:message code="msg.command.done"/>");
            setTimeout(function () {
                OK.close();
            }, 3000);
        } else {
            var OK = createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>",
                "<spring:message code="error"/>");
            setTimeout(function () {
                OK.close();
            }, 3000);
        }
    }

    function removeStudent_student() {

        var classId = ListGrid_Class_JspClass.getSelectedRecord().id;
        var studentRecord = StudentsLG_student.getSelectedRecord();
        if (studentRecord == null || studentRecord.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            isc.RPCManager.sendRequest(TrDSRequest(classUrl + "removeStudent/" + studentRecord.id + "/" + classId, "DELETE", null, "callback: class_remove_student_result(rpcResponse)"));
        }
    }

    function class_remove_student_result(resp) {
        var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",
            "<spring:message code="msg.command.done"/>");
        setTimeout(function () {
            OK.close();
        }, 3000);
        StudentsLG_student.invalidateCache();
        StudentsLG_student.fetchData({"classID": classId});
    }

    function loadPage_student() {
        classRecord = ListGrid_Class_JspClass.getSelectedRecord();
        if (!(classRecord == undefined || classRecord == null)) {
            StudentsLG_student.fetchData({"classID": classRecord.id});
        }
    }