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
    StudentDS_student = isc.TrDS.create({
        fields: [
            {name: "id", hidden: true},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "companyName", title: "<spring:message code="company.name"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "employmentStatus", title: "<spring:message code="employment.status"/>", filterOperator: "iContains", autoFitWidth: true, detail: true},
            {name: "complexTitle", title: "<spring:message code="complex"/>", filterOperator: "iContains", autoFitWidth: true, detail: true},
            {name: "workPlaceTitle", title: "<spring:message code="work.place"/>", filterOperator: "iContains", autoFitWidth: true, detail: true},
            {name: "workTurnTitle", title: "<spring:message code="work.turn"/>", filterOperator: "iContains", detail: true},
            {name: "id", hidden: true},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentNo", title: "<spring:message code="student.no"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentNo2", title: "<spring:message code="student.no.6.digits"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "companyName", title: "<spring:message code="company.name"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "employmentStatus", title: "<spring:message code="employment.status"/>", filterOperator: "iContains", autoFitWidth: true, detail: true},
            {name: "complexTitle", title: "<spring:message code="complex"/>", filterOperator: "iContains", autoFitWidth: true, detail: true},
            {name: "workPlaceTitle", title: "<spring:message code="work.place"/>", filterOperator: "iContains", autoFitWidth: true, detail: true},
            {name: "workTurnTitle", title: "<spring:message code="work.turn"/>", filterOperator: "iContains", detail: true},
        ],
        fetchDataURL: studentUrl + "iscList"
    });

    StudentLG_student = isc.TrLG.create({
        dataSource: StudentDS_student,
        fields: [
            {name: "firstName"},
            {name: "lastName"},
            {name: "nationalCode"},
            {name: "studentNo"},
            {name: "studentNo2"},
            {name: "companyName"},
            {name: "employmentStatus"},
            {name: "complexTitle"},
            {name: "workPlaceTitle"},
            {name: "workTurnTitle"},
        ],
        autoFetchData: true,
        gridComponents: [StudentTS_student, "filterEditor", "header", "body"],
        contextMenu: StudentMenu_student,
        dataChanged: function () {
            this.Super("dataChanged", arguments);
            let totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown()) {
                totalsLabel_student.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            } else {
                totalsLabel_student.setContents("&nbsp;");
            }
        },
        selectionAppearance: "checkbox",
        canExpandRecords: true,
        expansionMode: "details",
        showDetailFields: true
    });

    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrVLayout.create({
        members: [StudentLG_student],
    });

    // ------------------------------------------- Functions -------------------------------------------
    function refreshStudentLG_student() {
        StudentLG_student.filterByEditor();
    }