<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="sprig" uri="http://java.sun.com/jsp/jstl/fmt" %>

// <script>

    let competenceMethod_competence;

    // ------------------------------------------- Menu -------------------------------------------
    CompetenceMenu_competence = isc.Menu.create({
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

    let ToolStrip_Competence_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let criteria = CompetenceLG_competence.getCriteria();

                    if(typeof(criteria.operator)=='undefined'){
                        criteria._constructor="AdvancedCriteria";
                        criteria.operator="and";
                    }

                    if(typeof(criteria.criteria)=='undefined'){
                        criteria.criteria=[];
                    }

                    ExportToFile.downloadExcel(null, CompetenceLG_competence , "Competence", 0, null, '',"لیست شایستگی ها - آموزش"  , criteria, null);
                }
            })
        ]
    });

    CompetenceTS_competence = isc.ToolStrip.create({
        members: [
            isc.ToolStripButtonRefresh.create({
                click: function () {
                    refresh_competence();
                }
            }),
            isc.ToolStripButtonAdd.create({
                click: function () {
                    showNewForm_competence();
                }
            }),
            isc.ToolStripButtonEdit.create({
                click: function () {
                    showEditForm_competence();
                }
            }),
            isc.ToolStripButtonRemove.create({
                click: function () {
                    showRemoveForm_competence();
                }
            }),

            ToolStrip_Competence_Export2EXcel,

            /*isc.TrPrintBtnCommon.create({
                click: function () {
                    printCompetence_competence();
                }
            }),*/
            isc.LayoutSpacer.create({
                width: "*"
            }),
            isc.Label.create({
                padding: 5,
                ID: "totalsLabel_competence"
            }),
        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------
    CompetenceDS_competence = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {
                name: "titleFa",
                title: "<spring:message code="competence.title"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "titleEn",
                title: "<spring:message code="title.en"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "etechnicalType.titleFa",
                title: "<spring:message code="technical.type"/>",
                filterOperator: "iContains", autoFitWidth: true
            },
            {
                name: "ecompetenceInputType.titleFa",
                title: "<spring:message code="input"/>",
                filterOperator: "iContains", autoFitWidth: true
            },
            {name: "workFlowStatusCode", title: "وضعیت گردش کار"},
            {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: competenceUrl + "/iscList"
    });

    CompetenceLG_competence = isc.TrLG.create({
        dataSource: CompetenceDS_competence,
        fields: [
            {name: "titleFa",},
            {name: "titleEn",},
            {name: "etechnicalType.titleFa",},
            {name: "ecompetenceInputType.titleFa",},
            {name: "description",},
        ],
        autoFetchData: true,
        gridComponents: [CompetenceTS_competence, "filterEditor", "header", "body",],
        contextMenu: CompetenceMenu_competence,
        sortField: 0,
        dataChanged: function () {
            this.Super("dataChanged", arguments);
            var totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown()) {
                totalsLabel_competence.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            } else {
                totalsLabel_competence.setContents("&nbsp;");
            }
        },
        doubleClick: function () {
            showEditForm_competence();
        },
    });

    let ETechnicalTypeDS_competence = isc.TrDS.create({
        fields: [
            {name: "id", hidden: true},
            {name: "titleFa"},],
        <%--fetchDataURL: enumUrl + "eTechnicalType/spec-list"--%>
    fetchDataURL: parameterValueUrl + "/iscList/103"
    });

    let ECompetenceInputTypeDS_competence = isc.TrDS.create({
        fields: [
            {name: "id", hidden: true},
            {name: "titleFa"},],
        fetchDataURL: enumUrl + "eCompetenceInputType/spec-list"
    });

    // ------------------------------------------- DynamicForm & Window -------------------------------------------
    let CompetenceDF_competence = isc.DynamicForm.create({
        ID: "CompetenceDF_competence",
        fields: [
            {name: "id", hidden: true},
            {
                name: "titleFa", title: "<spring:message code="competence.title"/>",
                required: true, validators: [TrValidators.NotEmpty],
            },
            {
                name: "titleEn", title: "<spring:message code="title.en"/>",
                keyPressFilter: enNumSpcFilter,
            },
            {
                name: "etechnicalTypeId", title: "<spring:message code="technical.type"/>",
                optionDataSource: ETechnicalTypeDS_competence,
                valueField: "id", displayField: "titleFa", sortField: "titleFa",
                required: true,
            },
            {
                name: "ecompetenceInputTypeId", title: "<spring:message code="input"/>",
                optionDataSource: ECompetenceInputTypeDS_competence,
                valueField: "id", displayField: "titleFa", sortField: "titleFa",
                required: true,
            },
            {
                name: "description", title: "<spring:message code="description"/>",
                type: "TextAreaItem",
            },
        ]
    });

    let CompetenceWin_competence = isc.Window.create({
        width: 800,
        items: [CompetenceDF_competence, isc.TrHLayoutButtons.create({
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
        CompetenceWin_competence.setTitle("<spring:message code="create"/>&nbsp;" + "<spring:message code="competence"/>");
        CompetenceWin_competence.show();
    };

    function showEditForm_competence() {
        let record = CompetenceLG_competence.getSelectedRecord();
        if (checkRecordAsSelected(record, true)) {
            competenceMethod_competence = "PUT";
            CompetenceDF_competence.clearValues();
            CompetenceDF_competence.editRecord(record);
            CompetenceWin_competence.setTitle("<spring:message code="edit"/>&nbsp;" + "<spring:message code="competence"/>" + '&nbsp;\'' + record.titleFa + '\'');
            CompetenceWin_competence.show();
        }
    };

    function saveCompetence_competence() {
        if (!CompetenceDF_competence.validate()) {
            return;
        }
        let competenceSaveUrl = competenceUrl;
        let competenceAction = '<spring:message code="created"/>';
        if (competenceMethod_competence.localeCompare("PUT") == 0) {
            let record = CompetenceLG_competence.getSelectedRecord();
            competenceSaveUrl += "/" + record.id;
            competenceAction = '<spring:message code="edited"/>';
        }
        let data = CompetenceDF_competence.getValues();
        isc.RPCManager.sendRequest(
            TrDSRequest(competenceSaveUrl, competenceMethod_competence, JSON.stringify(data), "callback: studyRcpResponse(rpcResponse, '<spring:message code="competence"/>', '" + competenceAction + "')")
        );
    };

    function showRemoveForm_competence() {
        let record = CompetenceLG_competence.getSelectedRecord();
        if (checkRecordAsSelected(record, true)) {
            isc.TrYesNoDialog.create({
                message: "<spring:message code="msg.ask.record.remove"/>",
                buttonClick: function (button, index) {
                    this.close();
                    if (index == 0) {
                        isc.RPCManager.sendRequest(
                            TrDSRequest(competenceUrl + "/" + record.id, "DELETE", null, "callback: studyRcpResponse(rpcResponse, '<spring:message code="competence"/>', '<spring:message code="removed"/>', '" + record.titleFa + "')")
                        );
                    }
                }
            });
        }
    };

    function studyRcpResponse(resp, entityType, action, entityName) {
        let respCode = resp.httpResponseCode;
        if (respCode == 200) {
            let name;
            if (entityName && (entityName !== 'undefined')) {
                name = entityName;
            } else {
                name = JSON.parse(resp.data).titleFa;
            }
            let msg = entityType + '&nbsp;\'<b>' + name + '</b>\'&nbsp;' + action + '.';
            showOkDialog(msg);
        } else {
            showOkDialog("این شایستگی به دلیل استفاده در نیازسنجی، قابل حذف شدن نمی باشد.");
            switch (respCode) {
                case 0:
                    break;
                default:
            }
        }
        refresh_competence();
    };

    // To check the 'record' argument is a valid selected record of list grid
    function checkRecordAsSelected(record, flagShowDialog, dialogMsg) {
        if (record ? (record.constructor === Array ? ((record.length > 0) ? true : false) : true) : false) {
            return true;
        }
        if (flagShowDialog) {
            dialogMsg = dialogMsg ? dialogMsg : "<spring:message code="msg.no.records.selected"/>";
            showOkDialog(dialogMsg, 'notify');
        }
        return false;
    };

    // To show an ok dialog
    function showOkDialog(msg, iconName) {
        // createDialog('info', 'info');
        // createDialog('ask', 'ask');
        // createDialog('confirm', 'confirm');
        iconName = iconName ? iconName : 'say';
        // let dialog = isc.TrOkDialog.create({message: msg, icon: "[SKIN]" + iconName + ".png", autoDraw: true});
        let dialog = isc.MyOkDialog.create({message: msg, autoDraw: true});
        Timer.setTimeout(function () {
            dialog.close();
        }, 3000);
    };
