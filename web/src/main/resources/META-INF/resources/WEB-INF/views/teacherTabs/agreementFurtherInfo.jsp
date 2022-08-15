<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
// <script>

    var methodAgreementFurtherInfo = "GET";
    var saveActionUrlAgreementFurtherInfoon;
    var waitAgreementFurtherInfo;
    var teacherIdAgreementFurtherInfo = null;
    var isCategoriesChanged_JspAgreementFurtherInfo = false;
    var startDateCheck_JSPAgreementFurtherInfo = true;
    var endDateCheck_JSPAgreementFurtherInfo = true;
    var dateCheck_Order_JSPAgreementFurtherInfo = true;
    let rialIdAgreement = null;
    const numFilter_agreement = "[0-9]";

    //--------------------------------------------------------------------------------------------------------------------//
    /*RestDataSource*/
    //--------------------------------------------------------------------------------------------------------------------//

    RestDataSource_JspAgreementFurtherInfo = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "salaryBase"},
            {name: "teachingExperience"},
            {name: "teacherRank", hidden: true},
            {name: "teacherRankTitle"}

        ]
    });

    RestDataSource_Teacher_Rank_AgreementFurtherInfo = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "title"}
        ],
        fetchDataURL: enumUrl + "teacherRank/spec-list",
    });


    //--------------------------------------------------------------------------------------------------------------------//
    /*window*/
    //--------------------------------------------------------------------------------------------------------------------//

    DynamicForm_JspAgreementFurtherInfo = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        titleAlign: "left",
        fields: [
            {name: "id", hidden: true},
            {
                name: "salaryBase",
                title: "<spring:message code='salaryBase'/>",
                textAlign: "center",
                required: true,
                filterOnKeypress: true,
                keyPressFilter: numFilter_agreement,
            },

            {
                name: "teachingExperience",
                title: "<spring:message code='teachingExperience'/>",
                textAlign: "center",
                required: true,
                keyPressFilter: numFilter_agreement,
            },

            {
                name: "teacherRank",
                title: "<spring:message code='teacherRank'/>",
                required: true,
                align: "center",
                textAlign: "center",
                filterOnKeypress: true,
                type: "selectItem",
                optionDataSource: RestDataSource_Teacher_Rank_AgreementFurtherInfo,
                valueField:"id",
                displayField:"title"


            }


        ]

    });

    IButton_Save_JspAgreementFurtherInfo = isc.TrSaveBtn.create({
        top: 260,
        click: function () {



            if (!DynamicForm_JspAgreementFurtherInfo.validate()) {
                return;
            }

            waitAgreementFurtherInfo = createDialog("wait");
            isc.RPCManager.sendRequest(TrDSRequest(saveActionUrlAgreementFurtherInfo,
                methodAgreementFurtherInfo,
                JSON.stringify(DynamicForm_JspAgreementFurtherInfo.getValues()),
                "callback: AgreementFurtherInfo_save_result(rpcResponse)"));
        }
    });

    IButton_Cancel_JspAgreementFurtherInfo = isc.TrCancelBtn.create({
        click: function () {
            DynamicForm_JspAgreementFurtherInfo.clearValues();
            Window_JspAgreementFurtherInfo.close();
        }
    });

    HLayout_SaveOrExit_JspAgreementFurtherInfo = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        members: [IButton_Save_JspAgreementFurtherInfo, IButton_Cancel_JspAgreementFurtherInfo]
    });

    Window_JspAgreementFurtherInfo = isc.Window.create({
        width: "500",
        align: "center",
        border: "1px solid gray",
        title: "<spring:message code='agreement.Further.Info'/>",
        items: [isc.TrVLayout.create({
            members: [DynamicForm_JspAgreementFurtherInfo, HLayout_SaveOrExit_JspAgreementFurtherInfo]
        })]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Grid*/
    //--------------------------------------------------------------------------------------------------------------------//

    Menu_JspAgreementFurtherInfo = isc.Menu.create({
        data: [{
            title: "<spring:message code='refresh'/>", click: function () {
                ListGrid_AgreementFurtherInfo_refresh();
            }
        }, {
            title: "<spring:message code='create'/>", click: function () {
                ListGrid_AgreementFurtherInfo_Add();
            }
        }, {
            title: "<spring:message code='edit'/>", click: function () {
                ListGrid_AgreementFurtherInfo_Edit();
            }
        }, {
            title: "<spring:message code='remove'/>", click: function () {
                ListGrid_AgreementFurtherInfo_Remove();
            }
        }
        ]
    });

    ListGrid_JspAgreementFurtherInfo = isc.TrLG.create({
        dataSource: RestDataSource_JspAgreementFurtherInfo,
        contextMenu: Menu_JspAgreementFurtherInfo,
        initialSort: [
            {property: "id", direction: "descanding"}
        ],
        fields: [
            {name: "id", hidden:true},

            {

                name: "salaryBase",
                title: "<spring:message code='salaryBase'/>",
                align: "center",
                filterOperator: "iContains",
                filterEditorProperties: {
                    keyPressFilter: "[0-9|:]"
                }
            },

            {
                name: "teachingExperience",
                title: "<spring:message code='teachingExperience'/>",
                align: "center",
                filterOperator: "iContains",
                filterEditorProperties: {
                    keyPressFilter: "[0-9|:]"
                }
            },
            {
                name: "teacherRankTitle",
                title: "<spring:message code='teacherRank'/>",
                required: true,
                align: "center",
                textAlign: "center",
                valueField:"id"

            }
        ],
        doubleClick: function () {
            ListGrid_AgreementFurtherInfo_Edit();
        },
        align: "center",
        filterOperator: "iContains",
        showFilterEditor: false,
        filterOnKeypress: true,
        sortField: 1,
        sortBy:"id",
        dataPageSize: 50,
        autoFetchData: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>"
    });

    ToolStripButton_Refresh_JspAgreementFurtherInfo = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_AgreementFurtherInfo_refresh();
        }
    });

    ToolStripButton_Edit_JspAgreementFurtherInfo = isc.ToolStripButtonEdit.create({
        click: function () {
            ListGrid_AgreementFurtherInfo_Edit();
        }
    });
    ToolStripButton_Add_JspAgreementFurtherInfo = isc.ToolStripButtonCreate.create({
        click: function () {
            ListGrid_AgreementFurtherInfo_Add();
        }
    });
    ToolStripButton_Remove_JspAgreementFurtherInfo = isc.ToolStripButtonRemove.create({
        click: function () {
            ListGrid_AgreementFurtherInfo_Remove();
        }
    });

    ToolStrip_Actions_JspAgreementFurtherInfo = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                ToolStripButton_Add_JspAgreementFurtherInfo,
                ToolStripButton_Edit_JspAgreementFurtherInfo,
                ToolStripButton_Remove_JspAgreementFurtherInfo,
                isc.ToolStripButtonExcel.create({
                    click: function () {

                        ExportToFile.downloadExcelRestUrl(null, ListGrid_JspAgreementFurtherInfo, agreementFurtherInfoUrl + "/iscList/" + teacherIdAgreementFurtherInfo, 0, null, '',"استاد - اطلاعات پايه - اطلاعات تکمیلی تفاهم نامه"  , ListGrid_JspAgreementFurtherInfo.getCriteria(), null);
                    }
                }),
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_JspAgreementFurtherInfo
                    ]
                })
            ]
    });

    VLayout_Body_JspAgreementFurtherInfo = isc.TrVLayout.create({
        members: [
            ToolStrip_Actions_JspAgreementFurtherInfo,
            ListGrid_JspAgreementFurtherInfo
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*functions*/
    //--------------------------------------------------------------------------------------------------------------------//

    function ListGrid_AgreementFurtherInfo_refresh() {
        ListGrid_JspAgreementFurtherInfo.invalidateCache();
        ListGrid_JspAgreementFurtherInfo.filterByEditor();
    }

    function ListGrid_AgreementFurtherInfo_Add() {
        methodAgreementFurtherInfo = "POST";
        saveActionUrlAgreementFurtherInfo = agreementFurtherInfoUrl + "/" + teacherIdAgreementFurtherInfo;
        DynamicForm_JspAgreementFurtherInfo.clearValues();
        Window_JspAgreementFurtherInfo.show();
    }

    function ListGrid_AgreementFurtherInfo_Edit() {
        let record = ListGrid_JspAgreementFurtherInfo.getSelectedRecord();

        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            methodAgreementFurtherInfo = "PUT";
            saveActionUrlAgreementFurtherInfo = agreementFurtherInfoUrl + "/" + record.id;
        
            DynamicForm_JspAgreementFurtherInfo.clearValues();

            DynamicForm_JspAgreementFurtherInfo.editRecord(record);
            Window_JspAgreementFurtherInfo.show();

        }
    }

    function ListGrid_AgreementFurtherInfo_Remove() {
        var record = ListGrid_JspAgreementFurtherInfo.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            var Dialog_Delete = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                "<spring:message code='verify.delete'/>");
            Dialog_Delete.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        waitAgreementFurtherInfo = createDialog("wait");
                        isc.RPCManager.sendRequest(TrDSRequest(agreementFurtherInfoUrl +
                            "/" +
                            teacherIdAgreementFurtherInfo +
                            "," +
                            ListGrid_JspAgreementFurtherInfo.getSelectedRecord().id,
                            "DELETE",
                            null,
                            "callback: AgreementFurtherInfo_remove_result(rpcResponse)"));
                    }
                }
            });
        }
    }

    function AgreementFurtherInfo_save_result(resp) {
        waitAgreementFurtherInfo.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>");
            ListGrid_AgreementFurtherInfo_refresh();
            Window_JspAgreementFurtherInfo.close();
            setTimeout(function () {
                OK.close();
            }, 3000);
        } else {
            if (resp.httpResponseCode === 405) {
                createDialog("info", "<spring:message code="teacher.experience.rank.title"/>",
                    "<spring:message code="message"/>");
            }

            else if (resp.httpResponseCode === 406 && resp.httpResponseText === "DuplicateRecord") {
                createDialog("info", "<spring:message code="msg.record.duplicate"/>");
            } else {
                createDialog("info", "<spring:message code="msg.operation.error"/>");
            }
        }
    }

    function AgreementFurtherInfo_remove_result(resp) {
        waitAgreementFurtherInfo.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            ListGrid_AgreementFurtherInfo_refresh();
            var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>");
            setTimeout(function () {
                OK.close();
            }, 3000);
        } else {
            var respText = resp.httpResponseText;
            if (resp.httpResponseCode === 406 && respText === "NotDeletable") {
                createDialog("info", "<spring:message code='msg.record.cannot.deleted'/>");
            } else {
                createDialog("info", "<spring:message code="msg.operation.error"/>");
            }
        }
    }

    function loadPage_AgreementFurtherInfo(id) {
        if (teacherIdAgreementFurtherInfo !== id) {
            teacherIdAgreementFurtherInfo = id;
            RestDataSource_JspAgreementFurtherInfo.fetchDataURL = agreementFurtherInfoUrl + "/iscList/" + teacherIdAgreementFurtherInfo;
            ListGrid_JspAgreementFurtherInfo.fetchData();
            ListGrid_AgreementFurtherInfo_refresh();
        }
    }

    function clear_AgreementFurtherInfo() {
        ListGrid_JspAgreementFurtherInfo.clear();
    }

    //</script>