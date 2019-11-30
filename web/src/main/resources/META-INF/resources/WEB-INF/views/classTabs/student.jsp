<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>

    // ------------------------------------------- Menu -------------------------------------------
    StudentMenu_student = isc.Menu.create({
        data: [
            {
                title: "<spring:message code="refresh"/>", icon: "<spring:url value="refresh.png"/>", click: function () {
                    refreshStudentLG_student();
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
                    refreshStudentLG_student();
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
            isc.TrPrintBtn.create({
                menu: isc.Menu.create({
                    data: [
                        {
                            title: "<spring:message code="format.pdf"/>", icon: "<spring:url value="pdf.png"/>", click: function () {
                                printStudentLG_student("pdf");
                            }
                        },
                        {
                            title: "<spring:message code="format.excel"/>", icon: "<spring:url value="excel.png"/>", click: function () {
                                printStudentLG_student("excel");
                            }
                        },
                        {
                            title: "<spring:message code="format.html"/>", icon: "<spring:url value="html.png"/>", click: function () {
                                printStudentLG_student("html");
                            }
                        },
                    ]
                })
            }),
            isc.LayoutSpacer.create({
                width: "*"
            }),
            isc.Label.create({
                ID: "StudentsCount_student"
            }),
        ]
    });

    OtherStudentsTS_student = isc.ToolStrip.create({
        members: [
            isc.LayoutSpacer.create({
                width: "*"
            }),
            isc.Label.create({
                ID: "OtherStudentsCount_student"
            }),
        ]
    });

    SelectedStudentsTS_student = isc.ToolStrip.create({
        members: [
            isc.LayoutSpacer.create({
                width: "*"
            }),
            isc.Label.create({
                ID: "SelectedStudentsCount_student"
            }),
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

    SelectedStudentsLG_student = isc.TrLG.create({
        ID: "SelectedStudentsLG_student",
        fields: [
            {name: "id", hidden: true},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "companyName", title: "<spring:message code="company.name"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true, primaryKey: true,},
            {name: "personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains"},
        ],
        gridComponents: [SelectedStudentsTS_student, "filterEditor", "header", "body"],
        dataArrived: function (startRow, endRow) {
            console.log('dataArrived');
        },
        dataChanged: function () {
            console.log('dataChanged');
            this.Super("dataChanged", arguments);
            totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown()) {
                SelectedStudentsCount_student.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            } else {
                SelectedStudentsCount_student.setContents("&nbsp;");
            }
        },
        selectionAppearance: "checkbox",
    });

    OtherStudentsDS_student = isc.TrDS.create({
        fields: [
            {name: "id", hidden: true},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "companyName", title: "<spring:message code="company.name"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true, primaryKey: true,},
            {name: "personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains",},
        ],
        fetchDataURL: personnelUrl + "iscList",
    });

    OtherStudentsLG_student = isc.TrLG.create({
        dataSource: OtherStudentsDS_student,
        fields: [
            {name: "id", hidden: true},
            {name: "firstName"},
            {name: "lastName"},
            {name: "nationalCode"},
            {name: "companyName"},
            {name: "personnelNo"},
            {name: "personnelNo2"},
        ],
        gridComponents: [OtherStudentsTS_student, "filterEditor", "header", "body"],
        dataChanged: function () {
            this.Super("dataChanged", arguments);
            totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown()) {
                OtherStudentsCount_student.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            } else {
                OtherStudentsCount_student.setContents("&nbsp;");
            }
        },
        selectionAppearance: "checkbox",
        selectionUpdated: function () {
            SelectedStudentsLG_student.setData(this.getSelection().concat(SelectedStudentsLG_student.data).reduce(function(index, obj) {
                if (!index[obj.id]) {
                    index[obj.id] = obj;
                } else {
                    for (prop in obj) {
                        index[obj.id][prop] = obj[prop];
                    }
                }
                return index;
            }, []).filter(function(res, obj) {
                return obj;
            }));
        }
    });

    function jsonConcat(list1, list2) {
        var hash = Object.create(null);
        a1.concat(a2).forEach(function(obj) {
            hash[obj.id] = Object.assign(hash[obj.id] || {}, obj);
        });
        var a3 = Object.keys(hash).map(function(key) {
            return hash[key];
        });
    }

    // ------------------------------------------- DynamicForm & Window -------------------------------------------

    ClassStudentWin_student = isc.Window.create({
        width: 1024,
        height: 600,
        minWidth: 1024,
        minHeight: 600,
        items: [
            isc.TrHLayout.create({
                members: [
                    isc.SectionStack.create({
                        sections: [
                            {
                                title: "<spring:message code="all.persons"/>",
                                expanded: true,
                                canCollapse: false,
                                align: "center",
                                items: [
                                    OtherStudentsLG_student
                                ]
                            }
                        ]
                    }),
                    isc.SectionStack.create({
                        sections: [
                            {
                                title: "<spring:message code="selected.persons"/>",
                                expanded: true,
                                canCollapse: false,
                                align: "center",
                                items: [
                                    SelectedStudentsLG_student
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
    function refreshStudentLG_student() {
        StudentLG_student.filterByEditor();
    }

    function addStudent_student() {
        classRecord = ListGrid_Class_JspClass.getSelectedRecord();
        if (classRecord == null || classRecord.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            return;
        }
        ClassStudentWin_student.setTitle("<spring:message code="add.student.to.class"/> \'" + classRecord.titleClass + "\'");
        OtherStudentsLG_student.fetchData();
        ClassStudentWin_student.show();
    }

    function removeStudent_student() {
    }

    function loadPage_student() {
        classRecord = ListGrid_Class_JspClass.getSelectedRecord();
        if (!(classRecord == undefined || classRecord == null)) {
            StudentsLG_student.fetchData({"classID": classRecord.id});
        }
    }