<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// script

    // ------------------------------------------- Menu -------------------------------------------
    PersonnelMenu_personnel = isc.Menu.create({
        data: [
            {
                title: "<spring:message code="refresh"/>",
                icon: "<spring:url value="refresh.png"/>",
                click: function () {
                    refreshPersonnelLG_personnel();
                }
            },
        ]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------
    PersonnelTS_personnel = isc.ToolStrip.create({
        members: [
            isc.TrRefreshBtn.create({
                click: function () {
                    refreshPersonnelLG_personnel();
                }
            }),
            isc.TrPrintBtn.create({
                menu: isc.Menu.create({
                    data: [
                        {
                            title: "<spring:message code="format.pdf"/>", icon: "<spring:url value="pdf.png"/>", click: function () {
                                printPersonnelLG_personnel("pdf");
                            }
                        },
                        {
                            title: "<spring:message code="format.excel"/>", icon: "<spring:url value="excel.png"/>", click: function () {
                                printPersonnelLG_personnel("excel");
                            }
                        },
                        {
                            title: "<spring:message code="format.html"/>", icon: "<spring:url value="html.png"/>", click: function () {
                                printPersonnelLG_personnel("html");
                            }
                        },
                    ]
                })
            }),
            isc.LayoutSpacer.create({
                width: "*"
            }),
            isc.Label.create({
                ID: "totalsLabel_personnel"
            }),
        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------
    PersonnelDS_personnel = isc.TrDS.create({
        fields: [
            {name: "id", hidden: true},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "companyName", title: "<spring:message code="company.name"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "employmentStatus", title: "<spring:message code="employment.status"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "complexTitle", title: "<spring:message code="complex"/>", filterOperator: "iContains"},
            {name: "workPlaceTitle", title: "<spring:message code="work.place"/>", filterOperator: "iContains"},
            {name: "workTurnTitle", title: "<spring:message code="work.turn"/>", filterOperator: "iContains"},

            <%--{name: "birthCertificateNo", title: "<spring:message code="birth.certificate.no"/>", filterOperator: "iContains", autoFitWidth: true},--%>
            <%--{name: "fatherName", title: "<spring:message code="father.name"/>", filterOperator: "iContains", autoFitWidth: true},--%>
            <%--{name: "postTitle", title: "<spring:message code="post"/>", filterOperator: "iContains", autoFitWidth: true},--%>
            <%--{name: "postGradeTitle", title: "<spring:message code="post.grade"/>", filterOperator: "iContains"},--%>
            // {name: "birthDate", title: "<spring:message code="birth.date"/>", filterOperator: "iContains"},
            // {name: "age", title: "<spring:message code="age"/>", filterOperator: "iContains"},
            // {name: "birthPlace", title: "<spring:message code="birth.place"/>", filterOperator: "iContains"},
            // {name: "active", title: "<spring:message code="active.status"/>"},
            // {name: "deleted", title: "<spring:message code="deleted.status"/>"},
            // {name: "employmentDate", title: "<spring:message code="employment.date"/>", filterOperator: "iContains"},
            // {name: "postCode", title: "<spring:message code="post.code"/>", filterOperator: "iContains"},
            // {name: "postAssignmentDate", title: "<spring:message code="post.assignment.date"/>", filterOperator: "iContains"},
            // {name: "operationalUnitTitle", title: "<spring:message code="operational.unit"/>", filterOperator: "iContains"},
            // {name: "employmentTypeTitle", title: "<spring:message code="employment.type"/>", filterOperator: "iContains", autoFitWidth: true},
            // {name: "maritalStatusTitle", title: "<spring:message code="marital.status"/>", filterOperator: "iContains"},
            // {name: "educationLevelTitle", title: "<spring:message code="education.level"/>", filterOperator: "iContains"},
            // {name: "jobNo", title: "<spring:message code="job.code"/>", filterOperator: "iContains"},
            // {name: "jobTitle", title: "<spring:message code="job.title"/>", filterOperator: "iContains"},            //
            // {name: "contractNo", title: "<spring:message code="contract.no"/>", filterOperator: "iContains"},
            // {name: "educationFieldTitle", title: "<spring:message code="education.major"/>", filterOperator: "iContains"},
            // {name: "genderTitle", title: "<spring:message code="gender"/>", filterOperator: "iContains"},
            // {name: "militaryStatusTitle", title: "<spring:message code="military"/>", filterOperator: "iContains"},
            // {name: "educationLicenseTypeTitle", title: "<spring:message code="education.license.type"/>", filterOperator: "iContains"},
            // {name: "departmentTitle", title: "<spring:message code="department"/>", filterOperator: "iContains"},
            // {name: "departmentCode", title: "<spring:message code="department.code"/>", filterOperator: "iContains"},
            // {name: "contractDescription", title: "<spring:message code="contract.description"/>", filterOperator: "iContains"},
            // {name: "workYears", title: "<spring:message code="work.years"/>", filterOperator: "iContains"},
            // {name: "workMonths", title: "<spring:message code="work.months"/>", filterOperator: "iContains"},
            // {name: "workDays", title: "<spring:message code="work.days"/>", filterOperator: "iContains"},
            // {name: "insuranceCode", title: "<spring:message code="insurance.code"/>", filterOperator: "iContains"},
            // {name: "postGradeCode", title: "<spring:message code="post.grade.code"/>", filterOperator: "iContains", hidden: true},
            // {name: "ccpCode", title: "<spring:message code="reward.cost.center.code"/>", filterOperator: "iContains"},
            // {name: "ccpArea", title: "<spring:message code="reward.cost.center.area"/>", filterOperator: "iContains"},
            // {name: "ccpAssistant", title: "<spring:message code="reward.cost.center.assistant"/>", filterOperator: "iContains"},
            // {name: "ccpAffairs", title: "<spring:message code="reward.cost.center.affairs"/>", filterOperator: "iContains"},
            // {name: "ccpSection", title: "<spring:message code="reward.cost.center.section"/>", filterOperator: "iContains"},
            // {name: "ccpUnit", title: "<spring:message code="reward.cost.center.unit"/>", filterOperator: "iContains"},
            // {name: "ccpTitle", title: "<spring:message code="reward.cost.center.title"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: personnelUrl + "/iscList"
    });

    PersonnelLG_personnel = isc.TrLG.create({
        dataSource: PersonnelDS_personnel,
        fields: [
            {name: "firstName"},
            {name: "lastName"},
            {name: "nationalCode"},
            {name: "personnelNo"},
            {name: "personnelNo2"},
            {name: "companyName"},
            {name: "employmentStatus"},
            {name: "complexTitle"},
            {name: "workPlaceTitle"},
            {name: "workTurnTitle"},
        ],
        autoFetchData: true,
        gridComponents: [PersonnelTS_personnel, "filterEditor", "header", "body"],
        contextMenu: PersonnelMenu_personnel,
        dataChanged: function () {
            this.Super("dataChanged", arguments);
            let totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown()) {
                totalsLabel_personnel.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            } else {
                totalsLabel_personnel.setContents("&nbsp;");
            }
        },
    });

    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrVLayout.create({
        members: [PersonnelLG_personnel],
    });

    // ------------------------------------------- Functions -------------------------------------------
    function refreshPersonnelLG_personnel() {
        PersonnelLG_personnel.filterByEditor();
    }