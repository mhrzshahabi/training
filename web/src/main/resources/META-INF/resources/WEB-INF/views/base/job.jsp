<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>

    // ------------------------------------------- Menu -------------------------------------------
    JobMenu_job = isc.Menu.create({
        data: [
            {
                title: "<spring:message code="refresh"/>",
                icon: "<spring:url value="refresh.png"/>",
                click: function () {
                    refreshJobLG_job();
                }
            },
        ]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------
    JobTS_job = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            <%--isc.ToolStripButtonPrint.create({--%>
            <%--    menu: isc.Menu.create({--%>
            <%--        data: [--%>
            <%--            {--%>
            <%--                title: "<spring:message code="format.pdf"/>", icon: "<spring:url value="pdf.png"/>", click: function () {--%>
            <%--                    printJobLG_job("pdf");--%>
            <%--                }--%>
            <%--            },--%>
            <%--            {--%>
            <%--                title: "<spring:message code="format.excel"/>", icon: "<spring:url value="excel.png"/>", click: function () {--%>
            <%--                    printJobLG_job("excel");--%>
            <%--                }--%>
            <%--            },--%>
            <%--            {--%>
            <%--                title: "<spring:message code="format.html"/>", icon: "<spring:url value="html.png"/>", click: function () {--%>
            <%--                    printJobLG_job("html");--%>
            <%--                }--%>
            <%--            },--%>
            <%--        ]--%>
            <%--    })--%>
            <%--}),--%>


            isc.ToolStripButton.create({
                top: 260,
                align: "center",
                title: "<spring:message code='job.person.assign'/>",
                click: function () {
                    if (!(JobLG_job.getSelectedRecord() == undefined || JobLG_job.getSelectedRecord() == null)) {
                        setListGrid_PersonnelJob(JobLG_job.getSelectedRecord().code);
                        Window_ListGrid_Personnel_Job.show();
                    }else{
                        createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                    }

                }
            }),


            isc.LayoutSpacer.create({
                width: "*"
            }),
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    isc.Label.create({
                        ID: "totalsLabel_job"
                    }),
                    isc.ToolStripButtonRefresh.create({
                        click: function () {
                            refreshJobLG_job();
                        }
                    }),
                ]
            })
        ]
    })
    ;

    // ------------------------------------------- TabSet -------------------------------------------

    let JobTabs_job = isc.TabSet.create({
        tabs: [
            {
                title: "<spring:message code="job.group.plural.list"/>",
                pane: isc.TrVLayout.create({
                    members: []
                }),
            },
            {
                title: "<spring:message code="post.plural.list"/>",
                pane: isc.TrVLayout.create({
                    members: []
                }),
            },
            {
                title: "<spring:message code="need.assessment.plural.list"/>",
                pane: isc.TrVLayout.create({
                    members: []
                }),
            },
            {
                title: "<spring:message code="competence.plural.list"/>",
                pane: isc.TrVLayout.create({
                    members: []
                }),
            },
            {
                title: "<spring:message code="skill.plural.list"/>",
                pane: isc.TrVLayout.create({
                    members: []
                }),
            },
            {
                title: "<spring:message code="course.plural.list"/>",
                pane: isc.TrVLayout.create({
                    members: []
                }),
            },
            {
                title: "<spring:message code="class.plural.list"/>",
                pane: isc.TrVLayout.create({
                    members: []
                }),
            },
            <%--{--%>
            <%--    title: "<spring:message code="all.persons"/>",--%>
            <%--    pane: isc.TrVLayout.create({--%>
            <%--        members: []--%>
            <%--    }),--%>
            <%--},--%>
        ]
    });


    // ------------------------------------------- DataSource & ListGrid -------------------------------------------
    JobDS_job = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="job.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: jobUrl + "/iscList"
    });


    JobLG_job = isc.TrLG.create({
        dataSource: JobDS_job,
        fields: [
            {name: "code",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "titleFa",},
        ],
        autoFetchData: true,
        gridComponents: [JobTS_job, "filterEditor", "header", "body"],
        contextMenu: JobMenu_job,
        showResizeBar: true,
        dataChanged: function () {
            this.Super("dataChanged", arguments);
            let totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown()) {
                totalsLabel_job.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            } else {
                totalsLabel_job.setContents("&nbsp;");
            }
        },
    });


    var PersonnelDS_personnel_Job_JSP = isc.TrDS.create({
        fields: [
            {name: "id", hidden: true},
            {
                name: "firstName",
                title: "<spring:message code="firstName"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "lastName",
                title: "<spring:message code="lastName"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "nationalCode",
                title: "<spring:message code="national.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "personnelNo",
                title: "<spring:message code="personnel.no"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "personnelNo2",
                title: "<spring:message code="personnel.no.6.digits"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "workPlace",
                title: "<spring:message code="work.place"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                width: "*"
            },
            {
                name: "employmentStatus",
                title: "<spring:message code="employment.status"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                // detail: true
            },
            {
                name: "complexTitle",
                title: "<spring:message code="complex"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                // detail: true
            },
            {
                name: "workPlaceTitle",
                title: "<spring:message code="work.place"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                // detail: true
            },
            {
                name: "workTurnTitle",
                title: "<spring:message code="work.turn"/>",
                filterOperator: "iContains",
                // detail: true,
                autoFitWidth: true
            },
            {
                name: "postTitle",
                title: "<spring:message code="post.title"/>",
                filterOperator: "iContains",
                // detail: true,
                autoFitWidth: true
            },
            {
                name: "postCode",
                title: "<spring:message code="post.code"/>",
                filterOperator: "iContains",
                // detail: true,
                autoFitWidth: true
            },
            {
                name: "workYears",
                title: "<spring:message code="work.years"/>",
                filterOperator: "iContains",
                // detail: true,
                autoFitWidth: true
            },
            {
                name: "educationLevelTitle",
                title: "<spring:message code="education.degree"/>",
                filterOperator: "iContains",
                // detail: true,
                autoFitWidth: true
            },
            {
                name: "educationMajorTitle",
                title: "<spring:message code="education.major"/>",
                filterOperator: "iContains",
                // detail: true,
                autoFitWidth: true
            },
            {
                name: "jobTitle",
                title: "<spring:message code="job.title"/>",
                filterOperator: "iContains",
                // detail: true,
                autoFitWidth: true
            },
        ],
        canAddFormulaFields: false,
        filterOnKeypress: true,
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        // filterOnKeypress: false,
        sortFieldAscendingText: "<spring:message code='sort.ascending'/>",
        sortFieldDescendingText: "<spring:message code='sort.descending'/>",
        configureSortText: "<spring:message code='configureSortText'/>",
        autoFitAllText: "<spring:message code='autoFitAllText'/>",
        autoFitFieldText: "<spring:message code='autoFitFieldText'/>",
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>",
    });

    var ListGrid_Personnel_Job_JSP = isc.TrLG.create({
        width: "90%",
        height: "90%",
        autoDraw: false,
        border: "2px solid black",
        layoutMargin: 5,
        autoFetchData: false,
        dataSource: PersonnelDS_personnel_Job_JSP,
        fields: [

            {name: "firstName"},
            {name: "lastName"},
            {name: "nationalCode"},
            {name: "personnelNo"},
            {name: "personnelNo2"},
            {name: "jobTitle"},
            {name: "employmentStatus"},
            // {name: "complexTitle"},
            {name: "workPlaceTitle"},
            {name: "workTurnTitle"},
            {name: "postTitle"},
            {name: "postCode"},
            {name: "educationLevelTitle"},
            {name: "educationMajorTitle"},
            {name: "workYears"}
        ]
    });

    function setListGrid_PersonnelJob(jobNo) {
        PersonnelDS_personnel_Job_JSP.fetchDataURL = personnelUrl + "/byJobNo/" + jobNo;
        ListGrid_Personnel_Job_JSP.invalidateCache();
        ListGrid_Personnel_Job_JSP.fetchData();
    };


    var ListGrid_Personnel_Job_HLayout = isc.HLayout.create({
        width: "100%",
        height: "90%",
        autoDraw: false,
        border: "0px solid red",
        align: "center",
        valign: "center",
        layoutMargin: 5,
        membersMargin: 7,
        members: [
            ListGrid_Personnel_Job_JSP
        ]
    });


    var ListGrid_Personnel_Job_closeButton_HLayout = isc.HLayout.create({
        width: "100%",
        height: "6%",
        autoDraw: false,
        align: "center",
        members: [
            isc.IButton.create({
                title: "<spring:message code='close'/>",
                icon: "[SKIN]/actions/cancel.png",
                width: "70",
                align: "center",
                click: function () {
                    try {
                        Window_ListGrid_Personnel_Job.close();

                    } catch (e) {
                    }
                }
            })
        ]
    });


    var Window_ListGrid_Personnel_Job = isc.Window.create({
        title: "<spring:message code='personal'/>",
        width: 950,
        height: 600,
        autoSize: false,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        valign: "center",
        autoDraw: false,
        dismissOnEscape: true,
        layoutMargin: 5,
        membersMargin: 7,
        items: [
            ListGrid_Personnel_Job_HLayout,
            ListGrid_Personnel_Job_closeButton_HLayout

        ]
    });


    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrVLayout.create({
        members: [
            JobLG_job,
            // isc.HLayout.create({members: [JobTabs_job]})
        ],
        // members: [JobLG_job],
    });



    // ------------------------------------------- Functions -------------------------------------------
    function refreshJobLG_job() {
        JobLG_job.filterByEditor();
        JobLG_job.invalidateCache();
    }

<%--    function printJobLG_job(type) {--%>
<%--        isc.RPCManager.sendRequest(TrDSRequest(jobUrl + "/print/pdf", "POST", null, "callback:test(rpcResponse)"));--%>

<%--// isc.RPCManager.sendRequest(TrDSRequest("<spring:url value="educationOrientation/printWithCriteria/"/>" + "pdf", "POST", null, "callback:show_TermActionResult(rpcResponse)"));--%>


<%--// isc.RPCManager.sendRequest(TrDSRequest(termUrl + "checkForConflict/" + strsData + "/" + streData, "GET", null, "callback:conflictReq(rpcResponse)"));--%>

<%--// isc.RPCManager.sendRequest(TrDSRequest("<spring:url value="educationOrientation/printWithCriteria/"/>" + "pdf", "POST", null, "test"));--%>

<%--// trPrintWithCriteria("<spring:url value="educationOrientation/printWithCriteria/"/>" + "pdf", JobLG_job.getCriteria());--%>
<%--// trPrintWithCriteria(,--%>
<%--// JobLG_job.getCriteria());--%>
<%--// isc.RPCManager.sendRequest(TrDSRequest(jobUrl + "/print/" + type, "GET", JSON.stringify({"CriteriaStr": JobLG_job.getCriteria()}), "test"));--%>
<%--    }--%>

    function test(resp) {
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

