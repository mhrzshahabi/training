<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>

    // ------------------------------------------- Menu -------------------------------------------
    StudentMenu_student = isc.Menu.create({
        data: [
            {
                title: "<spring:message code="refresh"/>",
                icon: "<spring:url value="refresh.png"/>",
                click: function () {
                    refreshStudentLG_student();
                }
            },
            {
                title: "<spring:message code="add"/>",
                icon: "<spring:url value="create.png"/>",
                click: function () {
                    addStudent_student();
                }
            },
            {
                title: "<spring:message code="remove"/>",
                icon: "<spring:url value="remove.png"/>",
                click: function () {
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
                ID: "totalsLabel_student"
            }),
        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------
    ClassStudentsDS_student = isc.TrDS.create({
        fields: [
            {name: "id", hidden: true},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "companyName", title: "<spring:message code="company.name"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: classUrl + "student"
    });

    OtherStudentsDS_student = isc.TrDS.create({
        fields: [
            {name: "id", hidden: true},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "companyName", title: "<spring:message code="company.name"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: classUrl + "otherStudent"
    });

    ClassStudentsLG_student = isc.TrLG.create({
        dataSource: ClassStudentsDS_student,
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
                totalsLabel_student.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            } else {
                totalsLabel_student.setContents("&nbsp;");
            }
        },
    });

    // ------------------------------------------- DynamicForm & Window -------------------------------------------

    ClassStudentWin_student = isc.Window.create({
        width: 800,
        items: [
            isc.TrHLayoutButtons.create({
            members: [
                isc.TrSaveBtn.create({
                    click: function () {
                        saveCompetence_competence();
                    }
                }),
                isc.TrCancelBtn.create({
                    click: function () {
                        CompetenceWin_competence.close();
                    }
                }),
            ],
        }),]
    });

    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrVLayout.create({
        members: [ClassStudentsLG_student],
    });

    // ------------------------------------------- Functions -------------------------------------------
    function refreshStudentLG_student() {
        StudentLG_student.filterByEditor();
    }

    function addStudent_student() {
        classRecord = ListGrid_Class_JspClass.getSelectedRecord();
        console.log(classRecord);

        if (classRecord == null || classRecord.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            return;
        }
        ClassStudentWin_student.setTitle("<spring:message code="add.student.to.class"/> \'" + classRecord.titleClass + "\'");
        ClassStudentWin_student.show();

        // } else {
        //     ListGrid_All_Students_JspClass.invalidateCache();
        //     ListGrid_Current_Students_JspClass.invalidateCache();
        //     DynamicForm_ClassStudentHeaderGridHeader_JspClass.invalidateCache();
        //     DynamicForm_ClassStudentHeaderGridHeader_JspClass.setValue("course.titleFa", record.course.titleFa);
        //     DynamicForm_ClassStudentHeaderGridHeader_JspClass.setValue("group", record.group);
        //     DynamicForm_ClassStudentHeaderGridHeader_JspClass.setValue("id", record.id);
        //     ListGrid_All_Students_JspClass.fetchData({"classID": record.id});
        //     ListGrid_Current_Students_JspClass.fetchData({"classID": record.id});
        //     Window_AddStudents_JspClass.show();
        // }
    }

    function removeStudent_student() {
    }