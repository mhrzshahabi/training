<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="Spring" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>


// <script>

    let methodInOrganizationCompetence = "POST";
    let urlInOrganizationCompetence;
    let wait_organizationCompetence;
    let OrganizationalNeedAssessment_Id = null;




    let RestDataSource_OrganizationalNeedAssessment_Jsp = isc.TrDS.create({
        fields: [
            {name: "id", title: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "عنوان تیم", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code='code'/>", filterOperator: "iContains"},
            {name: "description", title: "<spring:message code='description'/>", filterOperator: "iContains"},
            {name: "competenceCount", title: "تعداد شایستگی", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "lastModifiedDateNA", title: "<spring:message code="update.date"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "modifiedByNA", title: "<spring:message code="updated.by"/>", align: "center", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
        ],
        implicitCriteria: {
            _constructor:"AdvancedCriteria",
            operator:"or",
            criteria: [{fieldName: "code", operator: "equals", value: "organizationCompetence"}]
        },
        // transformRequest: function (dsRequest) {
        //     transformCriteriaForLastModifiedDateNA(dsRequest);
        //     return this.Super("transformRequest", arguments);
        // },
        fetchDataURL: groupOfPersonnelUrl + "iscList",
        transformResponse: function (dsResponse, dsRequest, data) {
            let records = dsResponse.data;
            if (records.length===0){
                ToolStripButton_Add_OrganizationalNeedAssessment_Jsp.setDisabled(false);
            }else {
                ToolStripButton_Add_OrganizationalNeedAssessment_Jsp.setDisabled(true);
            }
            return this.Super("transformResponse", arguments);
        }

    });


<%--    ////////////////////////////////////////////////////////////////////////////////////////////////////////--%>



    let ListGrid_OrganizationalNeedAssessment_Jsp = isc.TrLG.create({
        selectionType: "single",
        autoFetchData: true,
        <sec:authorize access="hasAuthority('PostGradeGroup_R')">
        dataSource: RestDataSource_OrganizationalNeedAssessment_Jsp,
        </sec:authorize>
        // contextMenu: Menu_ListGrid_Post_Grade_Group_Jsp,
        canMultiSort: true,
        initialSort: [
            // {property: "competenceCount", direction: "ascending"},
            {property: "id", direction: "descending"}
        ],
        // getCellCSSText: function (record) {
        //     return setColorForListGrid(record)
        // },

        doubleClick: function () {
            ListGrid_organizationCompetence_edit();
        }
    });

    defineWindowsEditNeedsAssessmentForGap(ListGrid_OrganizationalNeedAssessment_Jsp);


    let DynamicForm_OrganizationalNeedAssessment_Jsp = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        align: "center",
        canSubmit: true,
        showInlineErrors: true,
        showErrorText: false,
        titleAlign: "right",
        validateOnExit: true,
        numCols: 2,
        wrapTitle: false,
        colWidths: [140, "*"],
        margin: 10,
        padding: 5,
        fields: [
            {name: "id", hidden: true},
            {
                name: "titleFa",
                title: "<spring:message code='global.titleFa'/>",
                required: true,
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9 ]",
                validators: [TrValidators.NotEmpty, TrValidators.NotStartWithSpecialChar, TrValidators.NotStartWithNumber]
            },
            {
                name: "code",
                defaultValue: "organizationCompetence",
                disabled: true,
                title: "<spring:message code='code'/>"
            },
            {
                name: "description",
                title: "<spring:message code='description'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9 ]",
                validators: [TrValidators.NotEmpty, TrValidators.NotStartWithSpecialChar, TrValidators.NotStartWithNumber]
            }
        ]
    });


    let IButton_OrganizationalNeedAssessment_Exit_Jsp = isc.IButtonCancel.create({
        click: function () {
            Window_OrganizationalNeedAssessment_Jsp.close();
        }
    });

    let IButton_OrganizationalNeedAssessment_Save_Jsp = isc.IButtonSave.create({
        click: function () {
            DynamicForm_OrganizationalNeedAssessment_Jsp.validate();
            if (DynamicForm_OrganizationalNeedAssessment_Jsp.hasErrors()) {
                return;
            }
            let data = DynamicForm_OrganizationalNeedAssessment_Jsp.getValues();
            isc.RPCManager.sendRequest(TrDSRequest(urlInOrganizationCompetence, methodInOrganizationCompetence, JSON.stringify(data),
                "callback: OrganizationalNeedAssessment_save_result(rpcResponse)"));
        }
    });

    let HLayOut_OrganizationalNeedAssessment_Jsp = isc.TrHLayoutButtons.create({
        members: [IButton_OrganizationalNeedAssessment_Save_Jsp, IButton_OrganizationalNeedAssessment_Exit_Jsp]
    });

    let Window_OrganizationalNeedAssessment_Jsp = isc.Window.create({
        title: "شایستگی سازمانی",
        width: 700,
        align: "center",
        border: "1px solid gray",
        closeClick: function () {
            this.Super("closeClick", arguments);
        },
        items: [isc.TrVLayout.create({
            members: [DynamicForm_OrganizationalNeedAssessment_Jsp, HLayOut_OrganizationalNeedAssessment_Jsp]
        })]
    });



    ToolStripButton_EditNA_OrganizationalNeedAssessmentForGap = isc.ToolStripButton.create({
        title: "ویرایش نیازسنجی (گپ)",
        click: function () {
            if (ListGrid_OrganizationalNeedAssessment_Jsp.getSelectedRecord() == null){
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                return;
            }
            Window_NeedsAssessment_Edit_Gap.showUs(ListGrid_OrganizationalNeedAssessment_Jsp.getSelectedRecord(), "organizationCompetence",true);
        }
    });


   ToolStrip_NA_PGG_OrganizationalNeedAssessmentGap = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            <sec:authorize access="hasAuthority('NeedAssessment_U')">
            ToolStripButton_EditNA_OrganizationalNeedAssessmentForGap,
            </sec:authorize>
        ]
    });

    let ToolStripButton_Refresh_OrganizationalNeedAssessment_Jsp = isc.ToolStripButtonRefresh.create({
        click: function () {
            // ListGrid_GroupOfPersonnel_refresh();
        }
    });
    let ToolStripButton_Edit_OrganizationalNeedAssessment_Jsp = isc.ToolStripButtonEdit.create({
        click: function () {
            ListGrid_organizationCompetence_edit();
        }
    });
    let ToolStripButton_Add_OrganizationalNeedAssessment_Jsp = isc.ToolStripButtonCreate.create({
        click: function () {
            ListGrid_OrganizationalNeedAssessment_add();
        }
    });
    let ToolStripButton_Remove_OrganizationalNeedAssessment_Jsp = isc.ToolStripButtonRemove.create({
        click: function () {
            ListGrid_optionalGroupOfPersonnel_remove();
        }
    });


<%--    &lt;%&ndash;/////////////////////////////////////////////////////////////////////////////////////////////&ndash;%&gt;--%>

    let ToolStrip_Actions_OrganizationalNeedAssessment_Jsp = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            <sec:authorize access="hasAuthority('PostGradeGroup_C')">
            ToolStripButton_Add_OrganizationalNeedAssessment_Jsp,
            </sec:authorize>
            <sec:authorize access="hasAuthority('PostGradeGroup_U')">
            ToolStripButton_Edit_OrganizationalNeedAssessment_Jsp,
            </sec:authorize>
            <sec:authorize access="hasAuthority('PostGradeGroup_D')">
            ToolStripButton_Remove_OrganizationalNeedAssessment_Jsp,
            </sec:authorize>
<%--            <sec:authorize access="hasAuthority('PostGradeGroup_P')">--%>
<%--            ToolStrip_Post_Grade_Group_Export2EXcel,--%>
<%--            </sec:authorize>--%>
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    <sec:authorize access="hasAuthority('PostGradeGroup_R')">
                    ToolStripButton_Refresh_OrganizationalNeedAssessment_Jsp,
                    </sec:authorize>
                ]
            }),

        ]
    });

    let HLayout_Actions_OrganizationalNeedAssessment_Jsp = isc.VLayout.create({
        width: "100%",
        members: [ToolStrip_Actions_OrganizationalNeedAssessment_Jsp,
            ToolStrip_NA_PGG_OrganizationalNeedAssessmentGap
        ]
    });


<%--    &lt;%&ndash;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////&ndash;%&gt;--%>


    let HLayout_Grid_OrganizationalNeedAssessment_Jsp = isc.TrHLayout.create({
        showResizeBar:true,
        members: [ListGrid_OrganizationalNeedAssessment_Jsp]
    });

    let VLayout_Body_OrganizationalNeedAssessment_Jsp = isc.TrVLayout.create({
        members: [
            HLayout_Actions_OrganizationalNeedAssessment_Jsp,
            HLayout_Grid_OrganizationalNeedAssessment_Jsp
        ]

    });


<%--    ///////////////////////////////////////////////functions/////////////////////////////////////////////////////--%>


    function OrganizationalNeedAssessment_save_result(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            let OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",
                "<spring:message code="msg.command.done"/>");
            setTimeout(function () {
                OK.close();
            }, 2000);
            ListGrid_OrganizationalNeedAssessment_refresh();
            Window_OrganizationalNeedAssessment_Jsp.close();
        } else {
            let respText =  JSON.parse(resp.httpResponseText);
            createDialog("info", respText.message,
                "<spring:message code="message"/>");
        }
    }



    function ListGrid_organizationCompetence_edit() {
        let record = ListGrid_OrganizationalNeedAssessment_Jsp.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            DynamicForm_OrganizationalNeedAssessment_Jsp.clearValues();
            methodInOrganizationCompetence = "PUT";
            urlInOrganizationCompetence = groupOfPersonnelUrl + record.id;
            DynamicForm_OrganizationalNeedAssessment_Jsp.editRecord(record);
            Window_OrganizationalNeedAssessment_Jsp.show();
        }
    }

    function ListGrid_optionalGroupOfPersonnel_remove() {
        let record = ListGrid_OrganizationalNeedAssessment_Jsp.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            let Dialog_Post_Grade_Group_remove = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                "<spring:message code='global.warning'/>");
            Dialog_Post_Grade_Group_remove.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        wait_organizationCompetence = createDialog("wait");
                        isc.RPCManager.sendRequest(TrDSRequest(groupOfPersonnelUrl + record.id+"/organizationCompetence", "DELETE", null,
                            "callback: organizationCompetenceDel_result(rpcResponse)"));
                    }
                }
            });
        }
    }

    function organizationCompetenceDel_result(resp) {
        wait_organizationCompetence.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            ListGrid_OrganizationalNeedAssessment_Jsp.invalidateCache();
            let OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",
                "<spring:message code="msg.command.done"/>");
            // ListGrid_Personnel_for_Group_Jsp.setData([]);
            setTimeout(function () {
                OK.close();
            }, 2000);
        } else {
            let respText =  JSON.parse(resp.httpResponseText);
            createDialog("info", respText.message,
                "<spring:message code="message"/>");
        }
    }

    function ListGrid_OrganizationalNeedAssessment_refresh() {
        refreshLG(ListGrid_OrganizationalNeedAssessment_Jsp);
        ListGrid_OrganizationalNeedAssessment_Jsp.setData([]);
        OrganizationalNeedAssessment_Id = null;
    }

    function ListGrid_OrganizationalNeedAssessment_add() {
        methodInOrganizationCompetence = "POST";
        urlInOrganizationCompetence = groupOfPersonnelUrl;
        DynamicForm_OrganizationalNeedAssessment_Jsp.clearValues();
        Window_OrganizationalNeedAssessment_Jsp.show();
    }




    ////////////////////////////////////////////////////////////////////////////////////////////////////

    // </script>