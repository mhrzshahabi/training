<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>

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
            {name: "autoId", primaryKey: true, hidden: true},
            {name: "id", hidden: true},
            {name: "personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains"},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains"},
            {name: "fatherName", title: "<spring:message code="father.name"/>", filterOperator: "iContains"},
            {name: "birthCertificateNo", title: "<spring:message code="birth.certificate.no"/>", filterOperator: "iContains"},
            {name: "birthDate", title: "<spring:message code="birth.date"/>", filterOperator: "iContains"},
            {name: "age", title: "<spring:message code="age"/>", filterOperator: "iContains"},
            {name: "birthPlace", title: "<spring:message code="birth.place"/>", filterOperator: "iContains"},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains"},
            {name: "employmentDate", title: "<spring:message code="employment.date"/>", filterOperator: "iContains"},
            {name: "postTitle", title: "<spring:message code="post"/>", filterOperator: "iContains"},
            {name: "postCode", title: "<spring:message code="post.code"/>", filterOperator: "iContains"},
            {name: "postAssignmentDate", title: "<spring:message code="post.assignment.date"/>", filterOperator: "iContains"},
            {name: "active", title: "<spring:message code="active.status"/>"},
            {name: "deleted", title: "<spring:message code="deleted.status"/>"},
            {name: "complexTitle", title: "<spring:message code="complex"/>", filterOperator: "iContains"},
            {name: "operationalUnitTitle", title: "<spring:message code="operational.unit"/>", filterOperator: "iContains"},
            {name: "employmentTypeTitle", title: "<spring:message code="employment.type"/>", filterOperator: "iContains"},
            {name: "maritalStatusTitle", title: "<spring:message code="marital.status"/>", filterOperator: "iContains"},
            {name: "workPlaceTitle", title: "<spring:message code="work.place"/>", filterOperator: "iContains"},
            {name: "workTurnTitle", title: "<spring:message code="work.turn"/>", filterOperator: "iContains"},
            {name: "educationLevelTitle", title: "<spring:message code="education.level"/>", filterOperator: "iContains"},
            {name: "jobNo", title: "<spring:message code="job.code"/>", filterOperator: "iContains"},
            {name: "jobTitle", title: "<spring:message code="job.title"/>", filterOperator: "iContains"},
            {name: "employmentStatusTitle", title: "<spring:message code="employment.status"/>", filterOperator: "iContains"},
            {name: "companyName", title: "<spring:message code="company.name"/>", filterOperator: "iContains"},
            {name: "contractNo", title: "<spring:message code="contract.no"/>", filterOperator: "iContains"},
            {name: "educationFieldTitle", title: "<spring:message code="education.major"/>", filterOperator: "iContains"},
            {name: "genderTitle", title: "<spring:message code="gender"/>", filterOperator: "iContains"},
            {name: "militaryStatusTitle", title: "<spring:message code="military"/>", filterOperator: "iContains"},
            {name: "educationLicenseTypeTitle", title: "<spring:message code="education.license.type"/>", filterOperator: "iContains"},
            {name: "jobEducationLevelTitle", title: "<spring:message code="jobEducationLevelTitle"/>", filterOperator: "iContains"},
            {name: "departmentTitle", title: "<spring:message code="departmentTitle"/>", filterOperator: "iContains"},
            {name: "departmentCode", title: "<spring:message code="departmentCode"/>", filterOperator: "iContains"},
            {name: "contractDescription", title: "<spring:message code="departmentCode"/>", filterOperator: "iContains"},
            {name: "departmentCode", title: "<spring:message code="departmentCode"/>", filterOperator: "iContains"},
            {name: "workYears", title: "<spring:message code="departmentCode"/>", filterOperator: "iContains"},
            {name: "workMonths", title: "<spring:message code="departmentCode"/>", filterOperator: "iContains"},
            {name: "workDays", title: "<spring:message code="departmentCode"/>", filterOperator: "iContains"},
            {name: "empNo", title: "<spring:message code="departmentCode"/>", filterOperator: "iContains"},
            {name: "insuranceCode", title: "<spring:message code="departmentCode"/>", filterOperator: "iContains"},
            {name: "postGradeTitle", title: "<spring:message code="departmentCode"/>", filterOperator: "iContains"},
            {name: "postGradeCode", title: "<spring:message code="departmentCode"/>", filterOperator: "iContains"},
            {name: "ccpCode", title: "<spring:message code="departmentCode"/>", filterOperator: "iContains"},
            {name: "ccpArea", title: "<spring:message code="departmentCode"/>", filterOperator: "iContains"},
            {name: "ccpAssistant", title: "<spring:message code="departmentCode"/>", filterOperator: "iContains"},
            {name: "ccpAffairs", title: "<spring:message code="departmentCode"/>", filterOperator: "iContains"},
            {name: "ccpSection", title: "<spring:message code="departmentCode"/>", filterOperator: "iContains"},
            {name: "ccpUnit", title: "<spring:message code="departmentCode"/>", filterOperator: "iContains"},
            {name: "ccpTitle", title: "<spring:message code="departmentCode"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: personnelUrl + "iscList"
    });

    PersonnelLG_personnel = isc.TrLG.create({
        dataSource: PersonnelDS_personnel,
        fields: [
            {name: "code",},
            {name: "titleFa",},
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
        members: [PersonnelLG_personnel, isc.HLayout.create({members: [PersonnelTabs_personnel]})],
    });

    // ------------------------------------------- Functions -------------------------------------------
    function refreshPersonnelLG_personnel() {
        PersonnelLG_personnel.filterByEditor();
    }

    function printPersonnelLG_personnel(type) {
        isc.RPCManager.sendRequest(TrDSRequest(personnelUrl + "print/pdf", "POST", null, "callback:test(rpcResponse)"));

        // isc.RPCManager.sendRequest(TrDSRequest("<spring:url value="education/orientation/printWithCriteria/"/>" + "pdf", "POST", null, "callback:show_TermActionResult(rpcResponse)"));


        // isc.RPCManager.sendRequest(TrDSRequest(termUrl + "checkForConflict/" + strsData + "/" + streData, "GET", null, "callback:conflictReq(rpcResponse)"));

        // isc.RPCManager.sendRequest(TrDSRequest("<spring:url value="education/orientation/printWithCriteria/"/>" + "pdf", "POST", null, "test"));

        // trPrintWithCriteria("<spring:url value="education/orientation/printWithCriteria/"/>" + "pdf", PersonnelLG_personnel.getCriteria());
        // trPrintWithCriteria(,
        //     PersonnelLG_personnel.getCriteria());
        // isc.RPCManager.sendRequest(TrDSRequest(personnelUrl + "print/" + type, "GET", JSON.stringify({"CriteriaStr": PersonnelLG_personnel.getCriteria()}), "test"));
    }

    function test(resp) {
        alert('hi');
    }

    <%--function trPrintWithCriteria(url, advancedCriteria) {--%>
    <%--    let trCriteriaForm = isc.DynamicForm.create({--%>
    <%--        method: "POST",--%>
    <%--        action: url,--%>
    <%--        target: "_Blank",--%>
    <%--        canSubmit: true,--%>
    <%--        fields:--%>
    <%--            [--%>
    <%--                {name: "CriteriaStr", type: "hidden"},--%>
    <%--                {name: "token", type: "hidden"}--%>
    <%--            ]--%>
    <%--    });--%>
    <%--    trCriteriaForm.setValue("CriteriaStr", JSON.stringify(advancedCriteria));--%>
    <%--    trCriteriaForm.setValue("token", "<%=accessToken%>");--%>
    <%--    trCriteriaForm.show();--%>
    <%--    trCriteriaForm.submitForm();--%>
    <%--}--%>
