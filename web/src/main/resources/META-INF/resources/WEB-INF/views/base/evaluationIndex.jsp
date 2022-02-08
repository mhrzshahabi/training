<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>

    var evaluationIndexMethod = "POST";
    var evaluationIndexActionUrl = evaluationIndexUrl;
    var evaluationIndexWait;

    var Menu_ListGrid_Evaluation_Index = isc.Menu.create({
        width: 150,
        data: [
            <sec:authorize access="hasAuthority('EvaluationIndex_R')">
            {
                title: "<spring:message code='refresh'/>",
                click: function () {
                    ListGrid_Evaluation_Index_refresh();
                }
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('EvaluationIndex_C')">
            {
                title: "<spring:message code='add'/>",
                click: function () {
                    ListGrid_Evaluation_Index_Add();
                }
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('EvaluationIndex_U')">
            {
                title: "<spring:message code='edit'/>",
                click: function () {
                    ListGrid_Evaluation_Index_edit();
                }
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('EvaluationIndex_D')">
            {
                title: "<spring:message code='remove'/>",
                click: function () {
                    ListGrid_Evaluation_Index_remove();
                }
            }
            </sec:authorize>
        ]
    });

    var RestDataSource_Evaluation_Index = isc.TrDS.create({
        fields: [
            {name: "id"},
            {name: "nameFa", title: "<spring:message code="evaluation.index.nameFa"/>", filterOperator: "iContains"},
            {name: "nameEn", title: "<spring:message code="evaluation.index.nameEn"/>", filterOperator: "iContains"},
            {name: "description", title: "<spring:message code="evaluation.index.description"/>", filterOperator: "iContains"},
            {name: "evalStatus", title: "<spring:message code="evaluation.index.evalStatus"/>", filterOperator: "iContains"},
            {name: "version"}
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

        fetchDataURL: evaluationIndexUrl + "/spec-list"
    });
    var ListGrid_Evaluation_Index = isc.TrLG.create({
        width: "100%",
        height: "100%",
        <sec:authorize access="hasAuthority('EvaluationIndex_R')">
        dataSource: RestDataSource_Evaluation_Index,
        </sec:authorize>
        contextMenu: Menu_ListGrid_Evaluation_Index,
        selectionType: "single",
        doubleClick: function () {
            ListGrid_Evaluation_Index_edit();
        },
        fields: [
            {name: "nameFa"},
            {name: "nameEn"},
            {name: "description"},
            {name: "evalStatus" ,  valueMap:
                    {
                        "0": "<spring:message code='deActive'/>",
                        "1": "<spring:message code='active'/>"}
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
    var DynamicForm_Evaluation_Index = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        align: "center",
        canSubmit: true,
        showInlineErrors: true,
        showErrorText: true,
        showErrorStyle: true,
        errorOrientation: "right",
        colWidths: ["30%", "*"],
        titleAlign: "right",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        numCols: 2,
        margin: 10,
        newPadding: 5,
        fields: [
            {name: "id", hidden: true},
            {
                name: "nameFa",
                title: "<spring:message code="evaluation.index.nameFa"/>",
                required: true,
                type: 'text',
                hint: "Persian/فارسی",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "250",
                validators: [{
                    validateOnExit: true,
                    type: "lengthRange",
                    min: 1,
                    max: 250,
                    stopOnError: true,
                    errorMessage: "<spring:message code="msg.length.error"/>"
                }]
            }, {
                name: "nameEn",
                title: "<spring:message code="evaluation.index.nameEn"/> ",
                type: 'text',
                keyPressFilter: "[a-z|A-Z|0-9 ]",
                length: "250",
                hint: "Latin",
                validators: [{
                    validateOnExit: true,
                    type: "lengthRange",
                    min: 0,
                    max: 250,
                    stopOnError: true,
                    errorMessage: "<spring:message code="msg.length.error"/>"
                }]

            },
            {
                name: "description",
                title: "<spring:message code="evaluation.index.description"/> ",
                type: 'text',
                keyPressFilter: "^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9|a-z|A-Z ]",
                length: "250",
                validators: [{
                    validateOnExit: true,
                    type: "lengthRange",
                    min: 0,
                    max: 250,
                    stopOnError: true,
                    errorMessage: "<spring:message code="msg.length.error"/>"
                }]

            },
            {
                name: "evalStatus",
                title: "<spring:message code="evaluation.index.evalStatus"/> ",
                valueMap:
                    {
                        "0": "<spring:message code='deActive'/>",
                        "1": "<spring:message code='active'/>"}

            }

            ]
    });


    var IButton_Evaluation_Index_Save = isc.IButtonSave.create({
        top: 260, title: "<spring:message code='save'/>",
        click: function () {

            DynamicForm_Evaluation_Index.validate();
            if (DynamicForm_Evaluation_Index.hasErrors()) {
                return;
            }
            else{
                var data = DynamicForm_Evaluation_Index.getValues();
                var evaluationIndexSaveUrl = evaluationIndexUrl;
                if (evaluationIndexMethod.localeCompare("PUT") == 0) {
                    var evaluationIndexRecord = ListGrid_Evaluation_Index.getSelectedRecord();
                    evaluationIndexSaveUrl += "/" + evaluationIndexRecord.id;
                }
                isc.RPCManager.sendRequest(TrDSRequest(evaluationIndexSaveUrl, evaluationIndexMethod, JSON.stringify(data), "callback: evaluationIndex_action_result(rpcResponse)"));
            }
        }
    });
    var Evaluation_IndexSaveOrExitHlayout = isc.TrHLayoutButtons.create({
        members: [
            IButton_Evaluation_Index_Save,
            isc.IButtonCancel.create({
                ID: "courseEditExitIButton",
                title: "<spring:message code='cancel'/>",
                icon: "[SKIN]/actions/cancel.png",
                orientation: "vertical",
                click: function () {
                    Window_Evaluation_Index.close();
                }
            })
        ]
    });
    var Window_Evaluation_Index = isc.Window.create({
        title: "<spring:message code='evaluation.index.title'/>",
        width: 500,
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: false,
        border: "1px solid gray",
        closeClick: function () {
            this.Super("closeClick", arguments);
        },
        items: [
            isc.VLayout.create({
            width: "100%",
            height: "100%",
            members: [
                DynamicForm_Evaluation_Index ,
                Evaluation_IndexSaveOrExitHlayout]
        })]
    });

    function ListGrid_Evaluation_Index_refresh() {
        // var record = ListGrid_Evaluation_Index.getSelectedRecord();
        // if (record == null || record.id == null) {
        // } else {
        //     ListGrid_Evaluation_Index.selectRecord(record);
        // }
        ListGrid_Evaluation_Index.invalidateCache();
    }

    function ListGrid_Evaluation_Index_remove() {


        var record = ListGrid_Evaluation_Index.getSelectedRecord();
        if (record == null) {
            isc.Dialog.create({
                message: "<spring:message code='msg.no.records.selected'/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code='message'/>",
                buttons: [isc.Button.create({title: "<spring:message code='ok'/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            var Dialog_Delete = isc.Dialog.create({
                message: "<spring:message code='msg.record.remove.ask'/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code='msg.remove.title'/>",
                buttons: [isc.Button.create({title: "<spring:message code='yes'/>"}), isc.Button.create({
                    title: "<spring:message code='no'/>"
                })],
                buttonClick: function (button, index) {
                    this.close();

                    if (index == 0) {
                        evaluationIndexWait = isc.Dialog.create({
                            message: "<spring:message code='msg.waiting'/>",
                            icon: "[SKIN]say.png",
                            title: "<spring:message code='message'/>"
                        });
                        isc.RPCManager.sendRequest(TrDSRequest(evaluationIndexUrl + "/" + record.id, "DELETE", null, "callback: evaluationIndex_delete_result(rpcResponse)"));
                    }
                }
            });
        }
    }

    function ListGrid_Evaluation_Index_Add() {
        evaluationIndexMethod = "POST";
        evaluationIndexActionUrl = evaluationIndexUrl;
        DynamicForm_Evaluation_Index.clearValues();
        Window_Evaluation_Index.setTitle("<spring:message code='evaluation.index.title'/>");
        Window_Evaluation_Index.show();
    }

    function ListGrid_Evaluation_Index_edit() {
        var record = ListGrid_Evaluation_Index.getSelectedRecord();
        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "<spring:message code='msg.no.records.selected'/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code='message'/>",
                buttons: [isc.Button.create({title: "<spring:message code='ok'/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            DynamicForm_Evaluation_Index.clearFieldErrors("nameFa", true);
            DynamicForm_Evaluation_Index.clearValues();
            evaluationIndexMethod = "PUT";
            evaluationIndexActionUrl = evaluationIndexUrl + "/" + record.id;
            DynamicForm_Evaluation_Index.editRecord(record);
            Window_Evaluation_Index.setTitle("<spring:message code='evaluation.index.title'/>");
            Window_Evaluation_Index.show();
        }
    }


    var ToolStripButton_Refresh = isc.ToolStripButtonRefresh.create({
        title: "<spring:message code='refresh'/>",
        click: function () {
            ListGrid_Evaluation_Index_refresh();
        }
    });
    var ToolStripButton_Edit = isc.ToolStripButtonEdit.create({
        title: "<spring:message code='edit'/>",
        click: function () {
            ListGrid_Evaluation_Index_edit();
        }
    });
    var ToolStripButton_Add = isc.ToolStripButtonAdd.create({
        title: "<spring:message code='add'/>",
        click: function () {
            ListGrid_Evaluation_Index_Add();
        }
    });
    var ToolStripButton_Remove = isc.ToolStripButtonRemove.create({
        icon: "[SKIN]/actions/remove.png",
        title: "<spring:message code='remove'/>",
        click: function () {
            ListGrid_Evaluation_Index_remove();
        }
    });
    var ToolStrip_Actions = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            <sec:authorize access="hasAuthority('EvaluationIndex_C')">
            ToolStripButton_Add,
            </sec:authorize>
            <sec:authorize access="hasAuthority('EvaluationIndex_U')">
            ToolStripButton_Edit,
            </sec:authorize>
            <sec:authorize access="hasAuthority('EvaluationIndex_D')">
            ToolStripButton_Remove,
            </sec:authorize>
            <sec:authorize access="hasAuthority('EvaluationIndex_P')">
            isc.ToolStripButtonExcel.create({
                click: function () {
                    if (ListGrid_Evaluation_Index.data.size()<1)
                        return;

                    ExportToFile.downloadExcelRestUrl(null, ListGrid_Evaluation_Index,  evaluationIndexUrl + "/spec-list", 0, null, '',"ارزيابی - شاخص ارزیابی", ListGrid_Evaluation_Index.getCriteria(), null);
                }
            }),
            </sec:authorize>
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    <sec:authorize access="hasAuthority('EvaluationIndex_R')">
                    ToolStripButton_Refresh
                    </sec:authorize>
                ]
            })
        ]
    });
    var HLayout_Actions = isc.HLayout.create({width: "100%", members: [ToolStrip_Actions]});
    var HLayout_Grid = isc.HLayout.create({width: "100%", height: "100%", members: [ListGrid_Evaluation_Index]});
    var VLayout_Body = isc.VLayout.create({width: "100%", height: "100%", members: [HLayout_Actions, HLayout_Grid]});


    function evaluationIndex_action_result(resp) {

        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
            var responseID = JSON.parse(resp.data).id;
            var gridState = "[{id:" + responseID + "}]";

            simpleDialog("<spring:message code="create"/>", "<spring:message code="msg.operation.successful"/>", 2000, "say");

            ListGrid_Evaluation_Index_refresh();
            ListGrid_Evaluation_Index.setSelectedState(gridState);
            Window_Evaluation_Index.close();
        } else {
            var ERROR = isc.Dialog.create({
                message: ("<spring:message code='msg.operation.error'/>"),
                icon: "[SKIN]stop.png",
                title: "<spring:message code='message'/>"
            });
            setTimeout(function () {
                ERROR.close();
            }, 3000);
        }

    }

    function evaluationIndex_delete_result(resp) {
        evaluationIndexWait.close();
        if (resp.httpResponseCode == 200) {
            ListGrid_Evaluation_Index.invalidateCache();
            simpleDialog("<spring:message code="create"/>", "<spring:message code="msg.operation.successful"/>", 2000, "say");
            ListGrid_Evaluation_Index_refresh();

        } else if (resp.data == false) {
            var ERROR = isc.Dialog.create({
                message: "<spring:message code='msg.student.remove.error'/>",
                icon: "[SKIN]stop.png",
                title: "<spring:message code='message'/>"
            });
            setTimeout(function () {
                ERROR.close();
            }, 3000);
        } else {
            var ERROR = isc.Dialog.create({
                message: "<spring:message code='msg.record.remove.failed'/>",
                icon: "[SKIN]stop.png",
                title: "<spring:message code='message'/>"
            });
            setTimeout(function () {
                ERROR.close();
            }, 3000);
        }
    }

// </script>