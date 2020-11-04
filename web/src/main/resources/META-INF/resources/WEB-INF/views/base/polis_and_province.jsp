<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


// <script>
    var provinceMethod = "GET";
    var waitDialog;
    let polisMethod;

    // ------------------------------------------- Menu -------------------------------------------

    Menu_ListGrid_Province = isc.Menu.create({
        ID:"ProvinceMenu",
        data: [
            {title: "<spring:message code='refresh'/>", click: function () {refreshLG(ListGrid_Province);}},
            {title: "<spring:message code='create'/>", click: function () {createProvince("<spring:message code='province'/>");}},
            {title: "<spring:message code='edit'/>", click: function () {DynamicForm_Province.clearValues();editProvince("<spring:message code='province'/>");}},
            {title: "<spring:message code='remove'/>", click: function () {removeProvince("<spring:message code='msg.province.remove'/>");}},
            {isSeparator: true},
            {title: "<spring:message code='global.form.print.pdf'/>", click: function () {trPrintWithCriteria("<spring:url value="polis_and_province/province/printWithCriteria/"/>" + "pdf", ListGrid_Province.getCriteria());}},
            {title: "<spring:message code='global.form.print.excel'/>", click: function () {trPrintWithCriteria("<spring:url value="polis_and_province/province/printWithCriteria/"/>" + "excel", ListGrid_Province.getCriteria());}},
            {title: "<spring:message code='global.form.print.html'/>", click: function () {trPrintWithCriteria("<spring:url value="polis_and_province/province/printWithCriteria/"/>" + "html", ListGrid_Province.getCriteria());}}
            ]
    });

    Menu_ListGrid_Polis = isc.Menu.create({
        ID:"PolisMenu",
        data: [
            {title: "<spring:message code='refresh'/>", click: function () {refreshPolisLG();}},
            {title: "<spring:message code='create'/>", click: function () {createPolis();}},
            {title: "<spring:message code='edit'/>", click: function () {editPolis();}},
            {title: "<spring:message code='remove'/>", click: function () {removePolis("<spring:message code='msg.polis.remove'/>");}},
            {isSeparator: true},
            {title: "<spring:message code='global.form.print.pdf'/>", click: function () {trPrintWithCriteria("<spring:url value="polis_and_province/polis/printWithCriteria/"/>" + "pdf", ListGrid_Polis.getCriteria());}},
            {title: "<spring:message code='global.form.print.excel'/>", click: function () {trPrintWithCriteria("<spring:url value="polis_and_province/polis/printWithCriteria/"/>" + "excel", ListGrid_Polis.getCriteria());}},
            {title: "<spring:message code='global.form.print.html'/>", click: function () {trPrintWithCriteria("<spring:url value="polis_and_province/polis/printWithCriteria/"/>" + "html", ListGrid_Polis.getCriteria());}}
        ]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------

    var ToolStrip_Province = isc.ToolStrip.create({
        ID: "ProvinceTS",
        members: [
            isc.ToolStripButtonCreate.create({click: function () {createProvince("<spring:message code='province'/>");}}),
            isc.ToolStripButtonEdit.create({click: function () {DynamicForm_Province.clearValues();editProvince("<spring:message code='province'/>");}}),
            isc.ToolStripButtonRemove.create({click: function () {removeProvince("<spring:message code='msg.province.remove'/>");}}),
            isc.ToolStripButtonPrint.create({click: function () {trPrintWithCriteria("<spring:url value="polis_and_province/province/printWithCriteria/"/>" + "pdf", ListGrid_Province.getCriteria());}}),
            isc.ToolStrip.create({border: '0px', members: [isc.ToolStripButtonRefresh.create({click: function () {refreshLG(ListGrid_Province);}}),]}),
            isc.LayoutSpacer.create({width: "*"}),
            isc.ToolStrip.create({align: "left", padding: 5, ID: "totalsLabel_province"}),
        ]
    });

    var ToolStrip_Polis = isc.ToolStrip.create({
        ID: "PolisTS",
        members: [
            isc.ToolStripButtonCreate.create({click: function () {createPolis();}}),
            isc.ToolStripButtonEdit.create({click: function () {editPolis();}}),
            isc.ToolStripButtonRemove.create({click: function () {removePolis("<spring:message code='msg.polis.remove'/>");}}),
            isc.ToolStripButtonPrint.create({click: function () {trPrintWithCriteria("<spring:url value="polis_and_province/polis/printWithCriteria/"/>" + "pdf", ListGrid_Polis.getCriteria());}}),
            isc.ToolStrip.create({border: '0px', members: [isc.ToolStripButtonRefresh.create({click: function () {refreshPolisLG();}}),]}),
            isc.LayoutSpacer.create({width: "*"}),
            isc.ToolStrip.create({align: "left", padding: 5, ID: "totalsLabel_polis"}),
        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------

    var RestDataSourceProvince = isc.TrDS.create({
        ID:"ProvinceDS",
        fields: [
            {name: "id", primaryKey: true},
            {name: "nameFa"},
            {name: "nameEn"},
        ],
        fetchDataURL: provinceUrl + "isclist"
    });

    var ListGrid_Province = isc.TrLG.create({
        ID:"ProvinceLG",
        dataSource: RestDataSourceProvince, contextMenu: Menu_ListGrid_Province, selectionType: "multiple", sortField: 0, sortDirection: "descending", dataPageSize: 50, autoFetchData: true,
        fields: [
            {name: "nameFa", title: "<spring:message code="global.titleFa"/>", filterOperator: "iContains"},
            {name: "nameEn", title: "<spring:message code="global.titleEn"/>", filterOperator: "iContains"},
        ],
        rowDoubleClick: function () {
            editProvince("<spring:message code='province'/>");
        },
        dataChanged: function () {
            this.Super("dataChanged", arguments);
            var totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown()) {
                totalsLabel_province.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            } else {
                totalsLabel_province.setContents("&nbsp;");
            }
        },
        selectionUpdated:function (record) {refreshPolisLG();}
    });


    var RestDataSourcePolis = isc.TrDS.create({
        ID:"PolisDS",
        fields: [
            {name: "provinceId", primaryKey: true},
            {name: "nameFa"},
            {name: "nameEn"},
        ],
    });

    var ListGrid_Polis = isc.TrLG.create({
        ID:"PolisLG",
        dataSource: RestDataSourcePolis, contextMenu: Menu_ListGrid_Polis, selectionType: "multiple", sortField: 0, sortDirection: "descending", dataPageSize: 50, autoFetchData: true,
        fields: [
            {name: "nameFa", title: "<spring:message code="global.titleFa"/>", filterOperator: "iContains"},
            {name: "nameEn", title: "<spring:message code="global.titleEn"/>", filterOperator: "iContains"},
        ],
        dataChanged: function () {
            this.Super("dataChanged", arguments);
            var totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown()) {
                totalsLabel_polis.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            } else {
                totalsLabel_polis.setContents("&nbsp;");
            }
        },
        recordDoubleClick: function () { editPolis(); }
    });

    // ------------------------------------------- DynamicForm & Window -------------------------------------------
    var DynamicForm_Province = isc.DynamicForm.create({
        ID: "ProvinceDF",
        width: "100%", height: "100%",
        fields: [
            {name: "id", hidden: true},
            {name: "nameFa",cssClass:"test" , title: "<spring:message code="global.titleFa"/>", required: true, validateOnExit: true, type: 'text', length: "100",
                //keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|' ']",
            changed: function (_1,_2,_3) {
            var blackList = ["+","-"];
                convertEn2Fa(_1,_2,_3,blackList);
            }
            },

            {name: "nameEn", title: "<spring:message code="global.titleEn"/>",
                required: false,
                validateOnExit: true,
                type: 'text',
                length: "100",
                // keyPressFilter: "[a-z|A-Z|0-9|' ']"
                changed: function (_1, _2, _3) {
                var blackList = [];
                    convertFa2En(_1, _2, _3,blackList);
                }
            },

        ]
    });

    var Window_Province = isc.Window.create({
        ID: "ProvinceWin",
        width: "300", align: "center", border: "1px solid gray", closeClick: function () {
            this.Super("closeClick", arguments);
        },
        items: [
            isc.TrVLayout.create({
                members: [
                    DynamicForm_Province,
                    isc.TrHLayoutButtons.create({
                        layoutMargin: 5, showEdges: false, edgeImage: "", width: "100%", padding: 10,
                        members: [
                            isc.IButtonSave.create({
                                top: 260, click: function () {
                                    saveProvince();
                                }
                            }),
                            isc.IButtonCancel.create({
                                prompt: "",
                                width: 100,
                                orientation: "vertical",
                                click: function () {
                                    DynamicForm_Province.clearValues();
                                    Window_Province.close();
                                }
                            })
                        ]
                    })
                ]
            })
        ]
    });


    var DynamicForm_Polis = isc.DynamicForm.create({
        ID: "PolisDF",
        width: "100%", height: "100%",
        fields: [
            {name: "id", hidden: true},
            {name: "province.id", dataPath: "provinceId", hidden: true,},
            {
                name: "nameFa",
                title: "<spring:message code="global.titleFa"/>", required: true, validateOnExit: true, type: 'text', length: "100",
                // keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|' ']"
                changed: convertEn2Fa
            },
            {name: "nameEn", title: "<spring:message code="global.titleEn"/>", required: false, validateOnExit: true, type: 'text', length: "100",
                // keyPressFilter: "[a-z|A-Z|0-9|' ']"
                changed: convertFa2En
            },
        ]
    });

    var Window_Polis = isc.Window.create({
        ID: "PolisWin",
        width: "300", align: "center", border: "1px solid gray", closeClick: function () {this.Super("closeClick", arguments);},
        items: [
            isc.TrVLayout.create({
                members: [
                    DynamicForm_Polis,
                    isc.TrHLayoutButtons.create({
                        layoutMargin: 5, showEdges: false, edgeImage: "", width: "100%", padding: 10,
                        members: [
                            isc.IButtonSave.create({top: 260, click: function () {savePolis();}}),
                            isc.IButtonCancel.create({prompt: "", width: 100, orientation: "vertical", click: function () {DynamicForm_Polis.clearValues();Window_Polis.close();}})
                        ]})
                ]})
        ]
    });

    // ------------------------------------------- Page UI -------------------------------------------


    var HLayout_Actions_Province = isc.HLayout.create({
        width: "100%",
        members: [ToolStrip_Province]
    });


    var HLayout_Grid_Province = isc.TrHLayout.create({
        members: [ListGrid_Province]
    });

    var VLayout_Body_Province = isc.TrVLayout.create({
        members: [HLayout_Actions_Province,
            HLayout_Grid_Province
        ]
    });


    var HLayout_Actions_Polis = isc.HLayout.create({
        width: "100%",
        members: [ToolStrip_Polis]
    });


    var HLayout_Grid_Polis = isc.TrHLayout.create({
        members: [ListGrid_Polis]
    });

    var VLayout_Body_Polis = isc.TrVLayout.create({
        members: [HLayout_Actions_Polis,
            HLayout_Grid_Polis
        ]
    });


    /*isc.TrVLayout.create({
        members:[ToolStrip_Actions_Province,ListGrid_Province],
    });*/

    isc.TrHLayout.create({
        members: [VLayout_Body_Province,VLayout_Body_Polis]
    });


    // ------------------------------------------- Functions -------------------------------------------
    function createProvince(title) {
        provinceMethod = "POST";
        DynamicForm_Province.clearValues();
        Window_Province.setTitle(title);
        Window_Province.show();
    }

    function editProvince(title) {
        var record = ListGrid_Province.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            provinceMethod = "PUT";
            DynamicForm_Province.clearValues();
            DynamicForm_Province.editRecord(record);
            Window_Province.setTitle(title);
            Window_Province.show();
        }
    }

    function saveProvince() {
        if (!DynamicForm_Province.validate()) {
            return;
        }
        let provinceSaveUrl = provinceUrl;
        if (provinceMethod.localeCompare("PUT") == 0) {
            let record = ListGrid_Province.getSelectedRecord();
            provinceSaveUrl += record.id;
        }
        var data = DynamicForm_Province.getValues();
        isc.RPCManager.sendRequest(TrDSRequest(provinceSaveUrl, provinceMethod, JSON.stringify(data)
            ,"callback: save_province_result(rpcResponse)"));
    }

    function removeProvince(msg) {
        var record = ListGrid_Province.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            var Dialog_Province_remove = createDialog("ask", msg, "<spring:message code='verify.delete'/>");
            Dialog_Province_remove.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        waitDialog = createDialog("wait");
                        isc.RPCManager.sendRequest(TrDSRequest(provinceUrl + "delete/" + record.id, "DELETE", null,
                            "callback: delete_province_result(rpcResponse)"));
                    }
                }
            });
        }
    }

    function save_province_result(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            var responseID = JSON.parse(resp.data).id;
            //------------------------------------
            refreshLG(ListGrid_Province);
            var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>");
            setTimeout(function () {
                OK.close();
            }, 3000);
            Window_Province.close();
            //------------------------------------
        } else {
            let respText = resp.httpResponseText;
            if (resp.httpResponseCode === 406) {
                createDialog("info", "<spring:message code="msg.record.duplicate"/>");
            }
        }
    }

    function delete_province_result(resp) {
        waitDialog.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            refreshLG(ListGrid_Province);
            ListGrid_Polis.c([]);
            var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>");
            setTimeout(function () {
                OK.close();
            }, 3000);
        } else {
            let respText = resp.httpResponseText;
            if (resp.httpResponseCode === 406) {
                createDialog("info", "<spring:message code='msg.record.cannot.deleted'/>");
            }
        }
    }
    // ---------------------------------------------------------------------------------------------------

    function refreshPolisLG() {
        var record = ListGrid_Province.getSelectedRecord();
        if (checkRecordAsSelected(record, false)) {
            refreshLgDs(ListGrid_Polis, RestDataSourcePolis, polisUrl + "iscList/" + record.id)
        }
    }

    function createPolis() {
        let record = ListGrid_Province.getSelectedRecord();
        if (checkRecordAsSelected(record, true, "<spring:message code="province"/>")) {
            polisMethod = "POST";
            DynamicForm_Polis.clearValues();
            DynamicForm_Polis.getItem("province.id").setValue(record.id);
            Window_Polis.setTitle("<spring:message code="create"/>&nbsp;" + "<spring:message code="polis"/>");
            Window_Polis.show();
        }
    }

    function editPolis() {
        let Record = ListGrid_Province.getSelectedRecord();
        let record = ListGrid_Polis.getSelectedRecord();
        if (checkRecordAsSelected(record, true, "<spring:message code="polis"/>") && checkRecordAsSelected(Record, true, "<spring:message code="province"/>")) {
            polisMethod = "PUT";
            DynamicForm_Polis.clearValues();
            DynamicForm_Polis.editRecord(record);
            DynamicForm_Polis.getItem("province.id").setValue(Record.id);
            Window_Polis.setTitle("<spring:message code="edit"/>&nbsp;" + "<spring:message code="polis"/>");
            Window_Polis.show();
        }
    }

    function savePolis() {
        if (!DynamicForm_Polis.validate()) {
            return;
        }
        let polisSaveUrl = polisUrl;
        <%--let action = '<spring:message code="create"/>';--%>
        if (polisMethod.localeCompare("PUT") == 0) {
            let record = ListGrid_Polis.getSelectedRecord();
            polisSaveUrl +=  record.id;
            <%--action = '<spring:message code="edit"/>';--%>
        }
        let data = DynamicForm_Polis.getValues();
        isc.RPCManager.sendRequest(
            TrDSRequest(polisSaveUrl, polisMethod, JSON.stringify(data)
                , "callback: save_polis_result(rpcResponse)")
        );
    }

    function removePolis(msg) {
        let Record = ListGrid_Province.getSelectedRecord();
        let record = ListGrid_Polis.getSelectedRecord();
        if (!checkRecordAsSelected(record, true, "<spring:message code="polis"/>") || !checkRecordAsSelected(Record, true, "<spring:message code="province"/>")) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            var Dialog_Polis_remove = createDialog("ask", msg, "<spring:message code='verify.delete'/>");
            Dialog_Polis_remove.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        waitDialog = createDialog("wait");
                        isc.RPCManager.sendRequest(TrDSRequest(polisUrl+"delete/"+ record.id, "DELETE", null
                            , "callback: delete_polis_result(rpcResponse)"));
                    }
                }
            });
        }
    }

    function save_polis_result(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            var responseID = JSON.parse(resp.data).id;
            //------------------------------------
            refreshPolisLG();
            var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>");
            setTimeout(function () {
                OK.close();
            }, 3000);
            Window_Polis.close();
            //------------------------------------
        } else {
            let respText = resp.httpResponseText;
            if (resp.httpResponseCode === 406) {
                createDialog("info", "<spring:message code="msg.record.duplicate"/>");
            }
        }
    }

    function delete_polis_result(resp) {
        waitDialog.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            refreshPolisLG();
            var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>");
            setTimeout(function () {
                OK.close();
            }, 3000);
        } else {
            let respText = resp.httpResponseText;
            if (resp.httpResponseCode === 406) {
                createDialog("info", "<spring:message code='msg.record.cannot.deleted'/>");
            } else {
                createDialog("info", "<spring:message code="msg.operation.error"/>");
            }
        }
    }

            setTimeout(function(){$("#isc_5G").keyup(function(){
            })},3000);

    //</script>