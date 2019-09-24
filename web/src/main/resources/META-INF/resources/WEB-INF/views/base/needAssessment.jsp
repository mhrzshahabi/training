<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="sprig" uri="http://java.sun.com/jsp/jstl/fmt" %>

//<script>

    let needAssessmentMethod_needAssessment;

    // ------------------------------------------- Menu -------------------------------------------
    NeedAssessmentMenu_needAssessment = isc.Menu.create({
        data: [
            {
                title: "<spring:message code="refresh"/>",
                icon: "<spring:url value="refresh.png"/>",
                click: function () {
                    refresh_needAssessment();
                }
            },
            {
                title: "<spring:message code="create"/>",
                icon: "<spring:url value="create.png"/>",
                click: function () {
                    showNewForm_needAssessment();
                }
            },
            {
                title: "<spring:message code="edit"/>",
                icon: "<spring:url value="edit.png"/>",
                click: function () {
                    showEditForm_needAssessment();
                }
            },
            {
                title: "<spring:message code="remove"/>",
                icon: "<spring:url value="remove.png"/>",
                click: function () {
                    showRemoveForm_needAssessment();
                }
            },
        ]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------
    NeedAssessmentTS_needAssessment = isc.ToolStrip.create({
        members: [
            isc.TrRefreshBtn.create({
                click: function () {
                    refresh_needAssessment();
                }
            }),
            isc.TrCreateBtn.create({
                click: function () {
                    showNewForm_needAssessment();
                }
            }),
            isc.TrEditBtn.create({
                click: function () {
                    showEditForm_needAssessment();
                }
            }),
            isc.TrRemoveBtn.create({
                click: function () {
                    showRemoveForm_needAssessment();
                }
            }),
            /* isc.TrPrintBtnCommon.create({
                 click: function () {
                     printNeedAssessment_needAssessment();
                 }
             }),*/
            isc.LayoutSpacer.create({
                width: "*"
            }),
            isc.Label.create({
                padding: 5,
                ID: "totalsLabel_needAssessment"
            }),
            isc.LayoutSpacer.create({
                width: "40"
            }),
        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------
    NeedAssessmentDS_needAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "post.titleFa", title: "<spring:message code="post"/>", filterOperator: "contains"},
            {name: "competence.titleFa", title: "<spring:message code="competence"/>", filterOperator: "contains"},
            {
                name: "edomainType.titleFa",
                title: "<spring:message code="domain"/>",
                filterOperator: "contains"
            },
            {
                name: "eneedAssessmentPriority.titleFa",
                title: "<spring:message code="priority"/>",
                filterOperator: "contains"
            },
            {name: "skill.titleFa", title: "<spring:message code="skill"/>", filterOperator: "contains"},
            {name: "description", title: "<spring:message code="description"/>", filterOperator: "contains"},
        ],
        fetchDataURL: needAssessmentUrl + "iscList"
    });

    NeedAssessmentLG_needAssessment = isc.TrLG.create({
        dataSource: NeedAssessmentDS_needAssessment,
        fields: [
            {name: "post.titleFa",},
            {name: "competence.titleFa",},
            {name: "edomainType.titleFa",},
            {name: "eneedAssessmentPriority.titleFa",},
            {name: "skill.titleFa",},
            {name: "description",},
        ],
        autoFetchData: true,
        gridComponents: [NeedAssessmentTS_needAssessment, "header", "filterEditor", "body",],
        contextMenu: NeedAssessmentMenu_needAssessment,
        sortField: 0,
        dataChanged: function () {
            this.Super("dataChanged", arguments);
            var totalRows = this.data.getLength();
            if (totalRows > 0 && this.data.lengthIsKnown()) {
                totalsLabel_needAssessment.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            } else {
                totalsLabel_needAssessment.setContents("&nbsp;");
            }
        },
        doubleClick: function () {
            showEditForm_needAssessment();
        },
    });

    PostDS_needAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="post.code"/>", filterOperator: "contains"},
            {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "contains"},
            {name: "job.titleFa", title: "<spring:message code="job.title"/>", filterOperator: "contains"},
            {name: "postGrade.titleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "contains"},
        ],
        fetchDataURL: postUrl + "iscList"
    });

    CompetenceDS_needAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "<spring:message code="competence.title"/>", filterOperator: "contains"},
            {
                name: "etechnicalType.titleFa",
                title: "<spring:message code="technical.type"/>",
                filterOperator: "contains"
            },
            {
                name: "ecompetenceInputType.titleFa",
                title: "<spring:message code="input"/>",
                filterOperator: "contains"
            },
        ],
        fetchDataURL: competenceUrl + "iscList"
    });

    let SkillDS_needAssessment = isc.TrDS.create({
        fields: [
            {name: "id", hidden: true},
            {name: "titleFa"},],
        fetchDataURL: skillUrl + "spec-list"
    });

    let EDomainTypeDS_needAssessment = isc.TrDS.create({
        fields: [
            {name: "id", hidden: true},
            {name: "titleFa"},],
        fetchDataURL: enumUrl + "eDomainType"
    });

    let ENeedAssessmentPriorityDS_needAssessment = isc.TrDS.create({
        fields: [
            {name: "id", hidden: true},
            {name: "titleFa"},],
        fetchDataURL: enumUrl + "eNeedAssessmentPriority/spec-list"
    });

    // ------------------------------------------- DynamicForm & Window -------------------------------------------
    let NeedAssessmentDF_needAssessment = isc.DynamicForm.create({
        ID: "NeedAssessmentDF_needAssessment",
        fields: [
            {name: "id", hidden: true},
            {
                name: "postId",
                title: "<spring:message code="post"/>",
                editorType: "ComboBoxItem", optionDataSource: PostDS_needAssessment,
                valueField: "id", displayField: "titleFa", sortField: "titleFa",
                pickListFields: [{name: "code"}, {name: "titleFa"}, {name: "job.titleFa"}, {name: "postGrade.titleFa"}],
                filterFields: [{name: "titleFa"},],
                required: true,
            },
            {
                name: "competenceId", title: "<spring:message code="competence"/>",
                editorType: "TrComboAutoRefresh", optionDataSource: CompetenceDS_needAssessment,
                valueField: "id", displayField: "titleFa", sortField: "titleFa",
                required: true,
            },
            {
                name: "edomainTypeId", title: "<spring:message code="domain"/>",
                editorType: "ComboBoxItem", optionDataSource: EDomainTypeDS_needAssessment,
                valueField: "id", displayField: "titleFa",
                required: true,
            },
            {
                name: "eneedAssessmentPriorityId", title: "<spring:message code="priority"/>",
                editorType: "ComboBoxItem", optionDataSource: ENeedAssessmentPriorityDS_needAssessment,
                valueField: "id", displayField: "titleFa",
                required: true,
            },
            {
                name: "skillId", title: "<spring:message code="skill"/>",
                editorType: "TrComboAutoRefresh", optionDataSource: SkillDS_needAssessment,
                valueField: "id", displayField: "titleFa",
                required: true,
            },
            {
                name: "description", title: "<spring:message code="description"/>",
                type: "TextAreaItem",
            },
            {
                name: "error", title: "<spring:message code="error"/>",
                type: "TextAreaItem",
                visible: false,
            },
        ]
    });

    let NeedAssessmentWin_needAssessment = isc.Window.create({
        items: [NeedAssessmentDF_needAssessment, isc.TrHLayoutButtons.create({
            members: [
                isc.TrSaveBtn.create({
                    click: function () {
                        saveNeedAssessment_needAssessment();
                    }
                }),
                isc.TrCancelBtn.create({
                    click: function () {
                        NeedAssessmentWin_needAssessment.close();
                    }
                }),
            ],
        }),]
    });

    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrVLayout.create({
        members: [NeedAssessmentTS_needAssessment, NeedAssessmentLG_needAssessment],
    });

    // ------------------------------------------- Functions -------------------------------------------
    function refresh_needAssessment() {
        if (NeedAssessmentWin_needAssessment.isDrawn()) {
            NeedAssessmentWin_needAssessment.close();
        }
        NeedAssessmentLG_needAssessment.invalidateCache();
    };

    function showNewForm_needAssessment() {
        needAssessmentMethod_needAssessment = "POST";
        NeedAssessmentDF_needAssessment.clearValues();
        NeedAssessmentWin_needAssessment.setTitle("<spring:message code="create"/>&nbsp;" + "<spring:message code="need.assessment"/>");
        NeedAssessmentWin_needAssessment.show();
    };

    function showEditForm_needAssessment() {
        let record = NeedAssessmentLG_needAssessment.getSelectedRecord();
        if (checkRecordAsSelected(record, true)) {
            needAssessmentMethod_needAssessment = "PUT";
            NeedAssessmentDF_needAssessment.clearValues();
            NeedAssessmentDF_needAssessment.editRecord(record);
            NeedAssessmentWin_needAssessment.setTitle("<spring:message code="edit"/>&nbsp;" + "<spring:message code="need.assessment"/>" + '&nbsp;\'' + record.titleFa + '\'');
            NeedAssessmentWin_needAssessment.show();
        }
    };

    function saveNeedAssessment_needAssessment() {
        if (!NeedAssessmentDF_needAssessment.validate()) {
            return;
        }
        let needAssessmentSaveUrl = needAssessmentUrl;
        let needAssessmentAction = '<spring:message code="created"/>';
        if (needAssessmentMethod_needAssessment.localeCompare("PUT") == 0) {
            let record = NeedAssessmentLG_needAssessment.getSelectedRecord();
            needAssessmentSaveUrl += record.id;
            needAssessmentAction = '<spring:message code="edited"/>';
        }
        let data = NeedAssessmentDF_needAssessment.getValues();
        isc.RPCManager.sendRequest(
            TrDSRequest(needAssessmentSaveUrl, needAssessmentMethod_needAssessment, JSON.stringify(data), "callback: studyRcpResponse(rpcResponse, '<spring:message code="need.assessment"/>', '" + needAssessmentAction + "')")
        );
    };

    function showRemoveForm_needAssessment() {
        let record = NeedAssessmentLG_needAssessment.getSelectedRecord();
        if (checkRecordAsSelected(record, true)) {
            isc.TrYesNoDialog.create({
                message: "<spring:message code="msg.ask.record.remove"/>",
                buttonClick: function (button, index) {
                    this.close();
                    if (index == 0) {
                        isc.RPCManager.sendRequest(
                            TrDSRequest(needAssessmentUrl + record.id, "DELETE", null, "callback: studyRcpResponse(rpcResponse, '<spring:message code="need.assessment"/>', '<spring:message code="removed"/>')")
                        );
                    }
                }
            });
        }
    };

    function studyRcpResponse(resp, entityType, action, entityName) {
        let respCode = resp.httpResponseCode;
        if (respCode == 200) {
            msg = entityType + '&nbsp;' + action + '.';
            showOkDialog(msg);
            refresh_needAssessment();
        } else {
            let respText = resp.httpResponseText;
            NeedAssessmentDF_needAssessment.getItem('error').setValue('');
            NeedAssessmentDF_needAssessment.getItem('error').show();
            if (respText === 'CompetenceNotFound') {
                NeedAssessmentDF_needAssessment.getItem('error').setValue('شایستگی انتخاب شده، لحظاتی قبل حذف گردیده است. مجددا شایستگی را انتخاب نمائید.');
                NeedAssessmentDF_needAssessment.getItem('competenceId').setValue('');
            } else if (respText === 'SkillNotFound') {
                NeedAssessmentDF_needAssessment.getItem('error').setValue(NeedAssessmentDF_needAssessment.getItem('error').getValue() + 'مهارت انتخاب شده، لحظاتی قبل حذف گردیده است. مجددا مهارت را انتخاب نمائید.');
            } else {
                showOkDialog("<spring:message code="msg.error.connecting.to.server"/>");
            }
                NeedAssessmentDF_needAssessment.validate();
        }
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
        iconName = iconName ? iconName : 'say';
        let dialog = isc.TrOkDialog.create({message: msg, icon: "[SKIN]" + iconName + ".png",});
        Timer.setTimeout(function () {
            dialog.close();
        }, 3000);
    };


    // ------------------------------------------- DynamicForm & Window -------------------------------------------
    /*let NeedAssessmentDF_needAssessment1 = isc.DynamicForm.create({
        ID: "NeedAssessmentDF_needAssessment",
        fields: [
            {name: "id", hidden: true},
            {
                name: "postId",
                title: "<spring:message code="post"/>",
                editorType: "ComboBoxItem", optionDataSource: PostDS_needAssessment,
                valueField: "id", displayField: "titleFa", sortField: "titleFa",
                pickListFields: [{name: "code"}, {name: "titleFa"}, {name: "job.titleFa"}, {name: "postGrade.titleFa"}],
                filterFields: [{name: "titleFa"},],
                required: true,
            },
            {
                name: "competenceId", title: "<spring:message code="competence"/>",
                editorType: "ComboBoxItem", optionDataSource: CompetenceDS_needAssessment,
                valueField: "id", displayField: "titleFa", sortField: "titleFa",
                required: true,
            },
            {
                name: "edomainTypeId", title: "<spring:message code="domain"/>",
                editorType: "ComboBoxItem", optionDataSource: EDomainTypeDS_needAssessment,
                valueField: "id", displayField: "titleFa",
                required: true,
            },
            {
                name: "eneedAssessmentPriorityId", title: "<spring:message code="priority"/>",
                editorType: "ComboBoxItem", optionDataSource: ENeedAssessmentPriorityDS_needAssessment,
                valueField: "id", displayField: "titleFa",
                required: true,
            },
            {
                name: "skillId", title: "<spring:message code="skill"/>",
                editorType: "ComboBoxItem", optionDataSource: SkillDS_needAssessment,
                valueField: "id", displayField: "titleFa",
                required: true,
            },
            {
                name: "description", title: "<spring:message code="description"/>",
                type: "TextAreaItem",
            },
        ]
    });

    let NeedAssessmentWin_needAssessment1 = isc.Window.create({
        items: [NeedAssessmentDF_needAssessment, isc.TrHLayoutButtons.create({
            members: [
                isc.TrSaveBtn.create({
                    click: function () {
                        saveNeedAssessment_needAssessment();
                    }
                }),
                isc.TrCancelBtn.create({
                    click: function () {
                        NeedAssessmentWin_needAssessment.close();
                    }
                }),
            ],
        }),]
    });*/