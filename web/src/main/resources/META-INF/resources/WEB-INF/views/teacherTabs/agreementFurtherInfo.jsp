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

    //--------------------------------------------------------------------------------------------------------------------//
    /*RestDataSource*/
    //--------------------------------------------------------------------------------------------------------------------//

    RestDataSource_JspAgreementFurtherInfo = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "salaryBase", filterOperator: "iContains"},
            {name: "teachingExperience", filterOperator: "iContains"},
            {name: "currency.title", title: "واحد", filterOperator: "iContains"},
            {name: "personnelStatus",
                valueMap: {
                    "1":  "<spring:message code='teacher'/>",
                    "2": "<spring:message code='associateProfessor'/>",
                    "3": "<spring:message code='assistantProfessor'/>",
                    "4": "<spring:message code='coach'/>",
                    "5": "<spring:message code='educator'/>"
                }}


        ]
    });

    RestDataSource_Currency_AgreementFurtherInfo = isc.TrDS.create({
        fields:
            [
                {name: "id", primaryKey: true, hidden: true},
                {name: "title", title: "<spring:message code="title"/>"},
                {name: "code", title: "<spring:message code="code"/>"}
            ],
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/currency"
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
                required: true
            },
            {
                name: "currencyId",
                title: "واحد",
                required: true,
                colSpan: 4,
                type: "selectItem",
                autoFetchData: false,
                optionDataSource: RestDataSource_Currency_AgreementFurtherInfo,
                displayField: "title",
                valueField: "id",
                pickListProperties: {
                    showFilterEditor: false
                },
                click: function (form, item) {
                    item.fetchData();
                },
                change: function (form, item, value) {
                    let salaryBase = form.getItem("salaryBase").getValue();
                    if (salaryBase != null) {
                        if (value === rialId) {
                            let salaryBaseT = salaryBase / 10;
                            form.getItem("salaryBase").show();

                        } else
                            form.getItem("salaryBase").hide();
                    }
                }
            },
            {
                name: "teachingExperience",
                title: "<spring:message code='teachingExperience'/>"
            },

            {
                name: "teacherRank",
                title: "<spring:message code='teacherRank'/>",
                align: "center",
                filterOnKeypress: true,
                filterEditorProperties:{
                    pickListProperties: {
                        showFilterEditor: false
                    }
                },
                filterOperator: "iContains",
                valueMap: {
                    "1":  "<spring:message code='teacher'/>",
                    "2": "<spring:message code='associateProfessor'/>",
                    "3": "<spring:message code='assistantProfessor'/>",
                    "4": "<spring:message code='coach'/>",
                    "5": "<spring:message code='educator'/>"
                }}


        ]

    });

    IButton_Save_JspAgreementFurtherInfo = isc.TrSaveBtn.create({
        top: 260,
        click: function () {
            DynamicForm_JspAgreementFurtherInfo.validate();
            if (!DynamicForm_JspAgreementFurtherInfo.valuesHaveChanged() ||
                !DynamicForm_JspAgreementFurtherInfo.validate() ||
                dateCheck_Order_JSPAgreementFurtherInfo == false ||
                dateCheck_Order_JSPAgreementFurtherInfo == false ||
                endDateCheck_JSPAgreementFurtherInfo == false ||
                startDateCheck_JSPAgreementFurtherInfo == false) {


                return;
            }



            waitAgreementFurtherInfo = createDialog("wait");
            isc.RPCManager.sendRequest(TrDSRequest(saveActionUrlTeacherCertification,
                methodAgreementFurtherInfo,
                JSON.stringify(DynamicForm_JspTAgreementFurtherInfo.getValues()),
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
        fields: [

            {

                name: "salaryBase",
                title: "<spring:message code='salaryBase'/>",
            },
            {
                name: "currency.title",
                canFilter: false,
                sortNormalizer: function (record) {
                    return record.currency.title;
                }
            },
            {
                name: "teachingExperience",
                title: "<spring:message code='teachingExperience'/>",
            },


            {
                name: "teacherRank",
                title: "<spring:message code='teacherRank'/>",
                align: "center",
                filterOnKeypress: true,
                filterEditorProperties:{
                    pickListProperties: {
                        showFilterEditor: false
                    }
                },
                filterOperator: "equals",
                valueMap: {
                    "1":  "<spring:message code='teacher'/>",
                    "2": "<spring:message code='associateProfessor'/>",
                    "3": "<spring:message code='assistantProfessor'/>",
                    "4": "<spring:message code='coach'/>",
                    "5": "<spring:message code='educator'/>"
                }}



        ],
        doubleClick: function () {
            ListGrid_AgreementFurtherInfo_Edit();
        },
        filterEditorSubmit: function () {
            ListGrid_JspAgreementFurtherInfo.invalidateCache();
        },
        align: "center",
        filterOperator: "iContains",
        filterOnKeypress: true,
        sortField: 1,
        sortDirection: "descending",
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
                        ExportToFile.downloadExcelRestUrl(null, ListGrid_JspAgreementFurtherInfo, agreementFurtherInfoUrl + "/iscList/" + teacherIdAgreementFurtherInfo, 0,null, '', "استاد - اطلاعات پايه - اطلاعات تکمیلی تفاهم نامه", ListGrid_JspAgreementFurtherInfo.getCriteria(), null)
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
        var record = ListGrid_JspAgreementFurtherInfo.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            methodAgreementFurtherInfo = "PUT";
            saveActionUrlAgreementFurtherInfo = agreementFurtherInfoUrl + "/" + record.id;
            DynamicForm_JspAgreementFurtherInfo.clearValues();
            var clonedRecord = Object.assign({}, record);
            clonedRecord.teacherRank = null;

            DynamicForm_JspAgreementFurtherInfo.editRecord(clonedRecord);
            // if (record.teacherRank == null || record.teacherRank.isEmpty())
            //     DynamicForm_JspAgreementFurtherInfo.getField("subCategories").disable();
            // else {
            //     DynamicForm_JspTeacherCertification.getField("subCategories").enable();
            //     var catIds = [];
            //     for (var i = 0; i < record.categories.length; i++)
            //         catIds.add(record.categories[i].id);
            //     DynamicForm_JspTeacherCertification.getField("categories").setValue(catIds);
            //     isCategoriesChanged_JspTeacherCertification = true;
            //     DynamicForm_JspTeacherCertification.getField("subCategories").focus(null, null);
            // }
            // if (record.subCategories != null && !record.subCategories.isEmpty()) {
            //     var subCatIds = [];
            //     for (var i = 0; i < record.subCategories.length; i++)
            //         subCatIds.add(record.subCategories[i].id);
            //     DynamicForm_JspTeacherCertification.getField("subCategories").setValue(subCatIds);
            // }
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
            <%--if (resp.httpResponseCode === 405) {--%>
            <%--    createDialog("info", "<spring:message code="teacherCertification.title.duplicate"/>",--%>
            <%--        "<spring:message code="message"/>");--%>
            <%--}--%>

            <%--else if (resp.httpResponseCode === 406 && resp.httpResponseText === "DuplicateRecord") {--%>
            <%--    createDialog("info", "<spring:message code="msg.record.duplicate"/>");--%>
            <%--} else {--%>
            <%--    createDialog("info", "<spring:message code="msg.operation.error"/>");--%>
            <%--}--%>
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