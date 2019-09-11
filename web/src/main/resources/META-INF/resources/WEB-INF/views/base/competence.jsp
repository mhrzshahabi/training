<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="sprig" uri="http://java.sun.com/jsp/jstl/fmt" %>

// <script>
    let competenceMethod_competence;

    // ------------------------------------------- Menu -------------------------------------------
    CompetenceMenu_competence = isc.TrMenu.create({
        data: [
            {
                title: "<spring:message code="refresh"/>",
                icon: "<spring:url value="refresh.png"/>",
                click: function () {
                    refresh_competence();
                }
            },
            {
                title: "<spring:message code="create"/>",
                icon: "<spring:url value="create.png"/>",
                click: function () {
                    showNewForm_competence();
                }
            },
            {
                title: "<spring:message code="edit"/>",
                icon: "<spring:url value="edit.png"/>",
                click: function () {
                    showEditForm_competence();
                }
            },
            {
                title: "<spring:message code="remove"/>",
                icon: "<spring:url value="remove.png"/>",
                click: function () {
                    showRemoveForm_competence();
                }
            },
        ]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------
    CompetenceTS_competence = isc.TrTS.create({
        members: [
            isc.TrRefreshBtn.create({
                click: function () {
                    refresh_competence();
                }
            }),
            isc.TrCreateBtn.create({
                click: function () {
                    showNewForm_competence();
                }
            }),
            isc.TrEditBtn.create({
                click: function () {
                    showEditForm_competence();
                }
            }),
            isc.TrRemoveBtn.create({
                click: function () {
                    showRemoveForm_competence();
                }
            }),
            isc.TrPrintBtnCommon.create({
                click: function () {
                    printCompetence_competence();
                }
            }),
            isc.LayoutSpacer.create({
                width: "*"
            }),
            isc.Label.create({
                padding: 5,
                ID: "totalsLabel"
            }),
            isc.LayoutSpacer.create({
                width: "40"
            }),
        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------
    CompetenceDS_competence = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "<spring:message code="competence.title"/>", filterOperator: "contains"},
            {name: "titleEn", title: "<spring:message code="title.en"/>", filterOperator: "contains"},
            {name: "description", title: "<spring:message code="description"/>", filterOperator: "contains"},
        ],
        fetchDataURL: competenceUrl + "iscList"
    });

    CompetenceLG_competence = isc.TrLG.create({
        dataSource: CompetenceDS_competence,
        fields: [
            {name: "titleFa",},
            {name: "titleEn",},
            {name: "description",},
        ],
        autoFetchData: true,
        gridComponents: [CompetenceTS_competence, "header", "filterEditor", "body",],
        contextMenu: CompetenceMenu_competence,
        sortField: 0,
        dataChanged : function () {
            this.Super("dataChanged", arguments);
            var totalRows = this.data.getLength();
            if (totalRows > 0 && this.data.lengthIsKnown()) {
                totalsLabel.setContents("<spring:message code="records.count"/>" + ": <b>" + totalRows + "</b>");
            } else {
                totalsLabel.setContents("&nbsp;");
            }
        }
    });

    // ------------------------------------------- DynamicForm & Window -------------------------------------------
    let CompetenceDF_competence = isc.TrDynamicForm.create({
        ID: "CompetenceDF_competence",
        fields: [
            {name: "id", hidden: true},
            {
                name: "titleFa", title: "<spring:message code="competence.title"/>",
                required: true, validators: [TrValidators.NotEmpty],
                width: "*",
            },
            {
                name: "titleEn", title: "<spring:message code="title.en"/>",
                keyPressFilter: EnNumSpcFilter,
                width: "*",
            },
            {
                name: "description", title: "<spring:message code="description"/>",
                type: "TextAreaItem",
                width: "*",
            },
        ]
    });

    let CompetenceWin_competence = isc.TrWindow.create({
        items: [CompetenceDF_competence, isc.TrHLayoutButtons.create({
            members: [
                isc.TrSaveButton.create({
                    click: function () {
                        saveCompetence_competence();
                    }
                }),
                isc.TrSaveNextButton.create({
                    click: function () {
                    }
                }),
                isc.TrCancelButton.create({
                    click: function () {
                        CompetenceWin_competence.close();
                    }
                }),
            ],
        }),]
    });

    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrVLayout.create({
        members: [CompetenceTS_competence, CompetenceLG_competence],
    });

    // ------------------------------------------- Functions -------------------------------------------
    function refresh_competence() {
        if (CompetenceWin_competence.isDrawn()) {
            CompetenceWin_competence.close();
        }
        CompetenceLG_competence.invalidateCache();
    };

    function showNewForm_competence() {
        competenceMethod_competence = "POST";
        CompetenceDF_competence.clearValues();
        CompetenceWin_competence.setTitle("<spring:message code="create"/> " + "<spring:message code="job.competence"/>");
        CompetenceWin_competence.show();
    };

    function showEditForm_competence() {
    };

    function saveCompetence_competence() {
        if (!CompetenceDF_competence.validate()) {
            return;
        }
        let data = CompetenceDF_competence.getValues();
        isc.RPCManager.sendRequest(
            TrDSRequest(competenceUrl, competenceMethod_competence, JSON.stringify(data), "callback: studyRcpResponse(rpcResponse, '<spring:message code="job.competence"/>', '<spring:message code="created"/>')")
        );
    };

    function studyRcpResponse(resp, entityType, action) {
        let respCode = resp.httpResponseCode;
        let data = resp.data;
        if (respCode == 200) {
            let msg = entityType + ' \'<b>' + JSON.parse(data).titleFa + '</b>\' ' + action;
            showOkDialog(msg);
        } else {
            alert('error');
            switch (respCode) {
                case 0:
                    break;
                default:
            }
        }
        refresh_competence();
    };

    function showOkDialog(msg, iconName) {
        iconName = iconName ? iconName : 'say';
        dialog = isc.TrOkDialog.create({message: msg, icon: "[SKIN]" + iconName + ".png",});
        Timer.setTimeout(function () {
            dialog.close();
        }, 2500);
    };

    function showRemoveForm_competence() {
        let record = CompetenceLG_competence.getSelectedRecord();
        if (checkRecordAsSelected(record, true)) {
            isc.TrYesNoDialog.create({
                message: "آیا رکورد انتخاب شده حذف گردد؟",
                buttonClick: function (button, index) {
                    this.close();
                    if (index == 0) {
                        isc.RPCManager.sendRequest(
                            TrDSRequest(competenceUrl + record.id, "DELETE", null, "callback: studyRcpResponse(rpcResponse, '<spring:message code="job.competence"/>', '<spring:message code="removed"/>')")
                        );
                    }
                }
            });
        }
    };

    function checkRecordAsSelected(record, showDialog, msg,) {
        if (record ? (record.constructor === Array ? ((record.length > 0) ? true : false) : true) : false) {
            return true;
        }
        if (showDialog) {
            msg = msg ? msg : "<spring:message code="msg.not.selected.record"/>";
            showOkDialog(msg, 'notify');
        }
        return false;
    };


    /*

function show_CompetenceEditForm_competence() {
let record = LG_Competence_competence.getSelectedRecord();
if (checkRecord_competence(record, true)) {
competenceMethod_competence = "PUT";
DF_Competence_competence.clearValues();
DF_Competence_competence.editRecord(record);
Win_Competence_competence.setTitle("ویرایش شایستگی شغلی");
Win_Competence_competence.show();
}
};


        function show_CompetenceRemoveForm_competence() {
            let record = LG_Competence_competence.getSelectedRecord();
            if (checkRecord_competence(record, true)) {
                isc.MyYesNoDialog.create({
                    message: "آیا رکورد انتخاب شده حذف گردد؟",
                    buttonClick: function (button, index) {
                        this.close();
                        if (index == 0) {
                            isc.RPCManager.sendRequest(MyDsRequest(competenceUrl + record.id, "DELETE", null, "callback: show_CompetenceActionResult_competence(rpcResponse)"));
                        }
                    }
                });
            }
        };
    */


    //     MyOkDialog_job = isc.MyOkDialog.create({
    //         message: "خطا در اجراي عمليات! کد خطا: " + resp.httpResponseCode,
    //     });


    /* if (competenceMethod_competence.localeCompare("PUT") == 0) {
         let competenceRecord = LG_Competence_competence.getSelectedRecord();
         competenceSaveUrl += competenceRecord.id;
     }*/


    // function save_JobCompetence_competence() {
    //
    //     competenceId = DF_CompetenceInfo_competence.getValue('id');
    //     eJobCompetenceTypeId = DF_JobCompetenceType_competence.getValue('ejobCompetenceType.id');
    //     if (jobCompetenceMethod_competence.localeCompare("POST") == 0) {
    //         let jobRecords = LG_Job_competence.getSelectedRecords();
    //         if (checkRecord_competence(jobRecords, true, 'حداقل يک شغل را انتخاب نمائيد.')) {
    //             let data = {
    //                     "competenceId": competenceId, "jobIds": jobRecords.map(r => r.id), "eJobCompetenceTypeId":
    //                     eJobCompetenceTypeId
    //                 }
    //             ;
    //             isc.RPCManager.sendRequest(MyDsRequest(jobCompetenceUrl + "competence", jobCompetenceMethod_competence, JSON.stringify(data), "callback: show_JobCompetenceActionResult_competence(rpcResponse)"));
    //         }
    //     } else {
    //         let jobId = DF_JobInfo_competence.getValue('job.id');
    //         let data = {"competenceId": competenceId, "jobId": jobId, "eJobCompetenceTypeId": eJobCompetenceTypeId};
    //         isc.RPCManager.sendRequest(MyDsRequest(jobCompetenceUrl, jobCompetenceMethod_competence, JSON.stringify(data), "callback: show_JobCompetenceActionResult_competence(rpcResponse)"));
    //     }
    // };