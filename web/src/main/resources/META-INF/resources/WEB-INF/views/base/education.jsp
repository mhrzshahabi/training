<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>
    var methodEducation = "GET";
    var saveActionUrlEducation;
    var listGridEducation;
    var waitEducation;

    //////////////////////////////////////////////////////////
    ///////////////////////DataSource/////////////////////////
    /////////////////////////////////////////////////////////

    var RestDataSourceEducationLevel = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "code"}
        ],
        fetchDataURL: educationLevelUrl + "iscList"
    });

    var RestDataSourceEducationMajor = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa"}, {name: "titleEn"}],
        fetchDataURL: educationMajorUrl + "iscList"
    });

    var RestDataSourceEducationOrientation = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "educationLevelId"},
            {name: "educationMajorId"},
            {name: "educationLevel.titleFa"},
            {name: "educationMajor.titleFa"}
        ],
        fetchDataURL: educationOrientationUrl + "iscList"
    });


    //////////////////////////////////////////////////////////
    /////////////////Education Orientation////////////////////
    /////////////////////////////////////////////////////////

    Menu_ListGrid_EducationOrientation = isc.Menu.create({
        data: [
            {
                title: "<spring:message code='refresh'/>",
                icon: "<spring:url value="refresh.png"/>",
                click: function () {
                    ListGrid_Education_refresh(ListGrid_EducationOrientation);
                }
            }, {
                title: "<spring:message code='create'/>", icon: "<spring:url value="create.png"/>", click: function () {
                    ListGrid_Education_Add(educationOrientationUrl, "<spring:message code='education.orientation'/>",
                        DynamicForm_EducationOrientation, Window_EducationOrientation);
                }
            }, {
                title: "<spring:message code='edit'/>", icon: "<spring:url value="edit.png"/>", click: function () {
                    DynamicForm_EducationOrientation.clearValues();
                    ListGrid_Education_Edit(ListGrid_EducationOrientation, educationOrientationUrl,
                        "<spring:message code='education.orientation'/>",
                        DynamicForm_EducationOrientation, Window_EducationOrientation);
                }
            }, {
                title: "<spring:message code='remove'/>", icon: "<spring:url value="remove.png"/>", click: function () {
                    listGridEducation = ListGrid_EducationOrientation;
                    ListGrid_Education_Remove(educationOrientationUrl, "<spring:message code='msg.education.orientation.remove'/>");
                }
            }, {isSeparator: true}, {
                title: "<spring:message code='global.form.print.pdf'/>",
                icon: "<spring:url value="pdf.png"/>",
                click: function () {
                    trPrintWithCriteria("<spring:url value="educationOrientation/printWithCriteria/"/>" + "pdf",
                        ListGrid_EducationOrientation.getCriteria());
                }
            }, {
                title: "<spring:message code='global.form.print.excel'/>",
                icon: "<spring:url value="excel.png"/>",
                click: function () {
                    trPrintWithCriteria("<spring:url value="educationOrientation/printWithCriteria/"/>" + "excel",
                        ListGrid_EducationOrientation.getCriteria());
                }
            }, {
                title: "<spring:message code='global.form.print.html'/>",
                icon: "<spring:url value="html.png"/>",
                click: function () {
                    trPrintWithCriteria("<spring:url value="educationOrientation/printWithCriteria/"/>" + "html",
                        ListGrid_EducationOrientation.getCriteria());
                }
            }]
    });

    var ListGrid_EducationOrientation = isc.TrLG.create({
        dataSource: RestDataSourceEducationOrientation,
        contextMenu: Menu_ListGrid_EducationOrientation,
        selectionType: "multiple",
        sortField: 0,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        fields: [
            {
                name: "titleFa",
                title: "<spring:message code="global.titleFa"/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "titleEn",
                title: "<spring:message code="global.titleEn"/>",
                align: "center",
                filterOperator: "iContains"
            },
            {
                name: "educationLevel.titleFa",
                title: "<spring:message code="education.level"/>",
                align: "center",
                filterOperator: "iContains",
                sortNormalizer: function (record) {
                    return record.titleFa;
                }
            },
            {
                name: "educationMajor.titleFa",
                title: "<spring:message code="education.major"/>",
                align: "center",
                filterOperator: "iContains",
                sortNormalizer: function (record) {
                    return record.titleFa;
                }
            }
        ],
        rowDoubleClick: function () {
            ListGrid_Education_Edit(ListGrid_EducationOrientation, educationOrientationUrl,
                "<spring:message code='education.orientation'/>",
                DynamicForm_EducationOrientation, Window_EducationOrientation);
        }
    });

    var DynamicForm_EducationOrientation = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        fields: [
            {name: "id", hidden: true},
            {
                name: "titleFa",
                title: "<spring:message code="global.titleFa"/>",
                required: true,
                validateOnChange: true,
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|' ']"
            },
            {
                name: "titleEn",
                title: "<spring:message code="global.titleEn"/>",
                keyPressFilter: "[a-z|A-Z|0-9|' ']"
            },
            {
                name: "educationLevelId",
                title: "<spring:message code="education.level"/>",
                editorType: "TrComboAutoRefresh",
                addUnknownValues: false,
                required: true,
                validateOnChange: true,
                optionDataSource: RestDataSourceEducationLevel,
                displayField: "titleFa",
                valueField: "id",
                filterFields: ["titleFa"],
                filterOperator: "iContains",
                pickListFields: [{name: "titleFa"}]
            },
            {
                name: "educationMajorId",
                title: "<spring:message code="education.major"/>",
                editorType: "TrComboAutoRefresh",
                addUnknownValues: false,
                required: true,
                validateOnChange: true,
                optionDataSource: RestDataSourceEducationMajor,
                displayField: "titleFa",
                valueField: "id",
                filterFields: ["titleFa"],
                filterOperator: "iContains",
                pickListFields: [{name: "titleFa"}]
            }
        ]
    });

    var ToolStripButton_Refresh_EducationOrientation = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_Education_refresh(ListGrid_EducationOrientation);
        }
    });

    var ToolStripButton_Edit_EducationOrientation = isc.ToolStripButtonEdit.create({
        click: function () {
            DynamicForm_EducationOrientation.clearValues();
            ListGrid_Education_Edit(ListGrid_EducationOrientation, educationOrientationUrl,
                "<spring:message code='education.orientation'/>",
                DynamicForm_EducationOrientation, Window_EducationOrientation);
        }
    });
    var ToolStripButton_Add_EducationOrientation = isc.ToolStripButtonCreate.create({
        click: function () {
            ListGrid_Education_Add(educationOrientationUrl, "<spring:message code='education.orientation'/>",
                DynamicForm_EducationOrientation, Window_EducationOrientation);
        }
    });
    var ToolStripButton_Remove_EducationOrientation = isc.ToolStripButtonRemove.create({
        click: function () {
            listGridEducation = ListGrid_EducationOrientation;
            ListGrid_Education_Remove(educationOrientationUrl, "<spring:message code='msg.education.orientation.remove'/>");
        }
    });
    var ToolStripButton_Print_EducationOrientation = isc.ToolStripButtonPrint.create({
        click: function () {
            trPrintWithCriteria("<spring:url value="educationOrientation/printWithCriteria/"/>" + "pdf",
                ListGrid_EducationOrientation.getCriteria());
        }
    });
    var ToolStrip_Actions_EducationOrientation = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            ToolStripButton_Add_EducationOrientation,
            ToolStripButton_Edit_EducationOrientation,
            ToolStripButton_Remove_EducationOrientation,
            ToolStripButton_Print_EducationOrientation,
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_Refresh_EducationOrientation,
                ]
            }),
        ]
    });


    var IButton_EducationOrientation_Save = isc.IButtonSave.create({
        top: 260,
        click: function () {
            if (!DynamicForm_EducationOrientation.validate()) {
                return;
            }
            var data = DynamicForm_EducationOrientation.getValues();
            isc.RPCManager.sendRequest(TrDSRequest(saveActionUrlEducation, methodEducation, JSON.stringify(data),
                "callback: edu_save_result(rpcResponse)"));
        }
    });
    var HLayout_EducationOrientation_SaveOrExit = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        members: [IButton_EducationOrientation_Save, isc.IButtonCancel.create({
            prompt: "",
            width: 100,
            orientation: "vertical",
            click: function () {
                DynamicForm_EducationOrientation.clearValues();
                Window_EducationOrientation.close();
            }
        })]
    });
    var Window_EducationOrientation = isc.Window.create({
        width: "300",
        align: "center",
        border: "1px solid gray",
        closeClick: function () {
            this.Super("closeClick", arguments);
        },
        items: [isc.TrVLayout.create({
            members: [DynamicForm_EducationOrientation, HLayout_EducationOrientation_SaveOrExit]
        })]
    });

    var HLayout_Actions_EducationOrientation = isc.HLayout.create({
        width: "100%",
        members: [ToolStrip_Actions_EducationOrientation]
    });


    var HLayout_Grid_EducationOrientation = isc.TrHLayout.create({
        members: [ListGrid_EducationOrientation]
    });

    var VLayout_Body_EducationOrientation = isc.TrVLayout.create({
        members: [HLayout_Actions_EducationOrientation,
            HLayout_Grid_EducationOrientation
        ]
    });


    //////////////////////////////////////////////////////////
    ///////////////////Education Major////////////////////////
    /////////////////////////////////////////////////////////

    Menu_ListGrid_EducationMajor = isc.Menu.create({
        data: [
            {
                title: "<spring:message code='refresh'/>",
                icon: "<spring:url value="refresh.png"/>",
                click: function () {
                    ListGrid_Education_refresh(ListGrid_EducationMajor);
                }
            }, {
                title: "<spring:message code='create'/>", icon: "<spring:url value="create.png"/>", click: function () {
                    ListGrid_Education_Add(educationMajorUrl, "<spring:message code='education.major'/>",
                        DynamicForm_EducationMajor, Window_EducationMajor);
                }
            }, {
                title: "<spring:message code='edit'/>", icon: "<spring:url value="edit.png"/>", click: function () {
                    DynamicForm_EducationMajor.clearValues();
                    ListGrid_Education_Edit(ListGrid_EducationMajor, educationMajorUrl,
                        "<spring:message code='education.major'/>",
                        DynamicForm_EducationMajor, Window_EducationMajor);
                }
            }, {
                title: "<spring:message code='remove'/>", icon: "<spring:url value="remove.png"/>", click: function () {
                    listGridEducation = ListGrid_EducationMajor;
                    ListGrid_Education_Remove(educationMajorUrl, "<spring:message code='msg.education.major.remove'/>");
                }
            }, {isSeparator: true}, {
                title: "<spring:message code='global.form.print.pdf'/>",
                icon: "<spring:url value="pdf.png"/>",
                click: function () {
                    trPrintWithCriteria("<spring:url value="educationMajor/printWithCriteria/"/>" + "pdf",
                        ListGrid_EducationMajor.getCriteria());
                }
            }, {
                title: "<spring:message code='global.form.print.excel'/>",
                icon: "<spring:url value="excel.png"/>",
                click: function () {
                    trPrintWithCriteria("<spring:url value="educationMajor/printWithCriteria/"/>" + "excel",
                        ListGrid_EducationMajor.getCriteria());
                }
            }, {
                title: "<spring:message code='global.form.print.html'/>",
                icon: "<spring:url value="html.png"/>",
                click: function () {
                    trPrintWithCriteria("<spring:url value="educationMajor/printWithCriteria/"/>" + "html",
                        ListGrid_EducationMajor.getCriteria());
                }
            }]
    });

    var ListGrid_EducationMajor = isc.TrLG.create({
        dataSource: RestDataSourceEducationMajor,
        contextMenu: Menu_ListGrid_EducationMajor,
        selectionType: "multiple",
        sortField: 0,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        fields: [
            {
                name: "titleFa",
                title: "<spring:message code="global.titleFa"/>",
                align: "center",
                filterOperator: "iContains"
            },
            {
                name: "titleEn",
                title: "<spring:message code="global.titleEn"/>",
                align: "center",
                filterOperator: "iContains"
            }
        ],
        rowDoubleClick: function () {
            ListGrid_Education_Edit(ListGrid_EducationMajor, educationMajorUrl,
                "<spring:message code='education.major'/>",
                DynamicForm_EducationMajor, Window_EducationMajor);
        }
    });

    var DynamicForm_EducationMajor = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        fields: [
            {name: "id", hidden: true},
            {
                name: "titleFa",
                title: "<spring:message code="global.titleFa"/>",
                required: true,
                validateOnChange: true,
                length: "100",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|' ']"
            },
            {
                name: "titleEn",
                title: "<spring:message code="global.titleEn"/>",
                length: "100",
                keyPressFilter: "[a-z|A-Z|0-9|' ']"
            }
        ]
    });

    var ToolStripButton_Refresh_EducationMajor = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_Education_refresh(ListGrid_EducationMajor);
        }
    });

    var ToolStripButton_Edit_EducationMajor = isc.ToolStripButtonEdit.create({
        click: function () {
            DynamicForm_EducationMajor.clearValues();
            ListGrid_Education_Edit(ListGrid_EducationMajor, educationMajorUrl,
                "<spring:message code='education.major'/>",
                DynamicForm_EducationMajor, Window_EducationMajor);
        }
    });
    var ToolStripButton_Add_EducationMajor = isc.ToolStripButtonCreate.create({
        click: function () {
            ListGrid_Education_Add(educationMajorUrl, "<spring:message code='education.major'/>",
                DynamicForm_EducationMajor, Window_EducationMajor);
        }
    });
    var ToolStripButton_Remove_EducationMajor = isc.ToolStripButtonRemove.create({
        click: function () {
            listGridEducation = ListGrid_EducationMajor;
            ListGrid_Education_Remove(educationMajorUrl, "<spring:message code='msg.education.major.remove'/>");
        }
    });
    var ToolStripButton_Print_EducationMajor = isc.ToolStripButtonPrint.create({
        click: function () {
            trPrintWithCriteria("<spring:url value="educationMajor/printWithCriteria/"/>" + "pdf",
                ListGrid_EducationMajor.getCriteria());
        }
    });
    var ToolStrip_Actions_EducationMajor = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            ToolStripButton_Add_EducationMajor,
            ToolStripButton_Edit_EducationMajor,
            ToolStripButton_Remove_EducationMajor,
            ToolStripButton_Print_EducationMajor,
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_Refresh_EducationMajor,
                ]
            }),

        ]
    });


    var IButton_EducationMajor_Save = isc.IButtonSave.create({
        top: 260,
        click: function () {
            if (!DynamicForm_EducationMajor.validate()) {
                return;
            }
            var data = DynamicForm_EducationMajor.getValues();
            isc.RPCManager.sendRequest(TrDSRequest(saveActionUrlEducation, methodEducation, JSON.stringify(data),
                "callback: edu_save_result(rpcResponse)"));
        }
    });
    var HLayout_EducationMajor_SaveOrExit = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        padding: 10,
        members: [IButton_EducationMajor_Save, isc.IButtonCancel.create({
            prompt: "",
            width: 100,
            orientation: "vertical",
            click: function () {
                DynamicForm_EducationMajor.clearValues();
                Window_EducationMajor.close();
            }
        })]
    });
    var Window_EducationMajor = isc.Window.create({
        width: "300",
        align: "center",
        border: "1px solid gray",
        closeClick: function () {
            this.Super("closeClick", arguments);
        },
        items: [isc.TrVLayout.create({
            members: [DynamicForm_EducationMajor, HLayout_EducationMajor_SaveOrExit]
        })]
    });

    var HLayout_Actions_EducationMajor = isc.HLayout.create({
        width: "100%",
        members: [ToolStrip_Actions_EducationMajor]
    });


    var HLayout_Grid_EducationMajor = isc.TrVLayout.create({
        members: [ListGrid_EducationMajor]
    });

    var VLayout_Body_EducationMajor = isc.TrVLayout.create({
        members: [HLayout_Actions_EducationMajor,
            HLayout_Grid_EducationMajor
        ]
    });

    //////////////////////////////////////////////////////////
    /////////////////////////Education Level/////////////////
    /////////////////////////////////////////////////////////

    Menu_ListGrid_EducationLevel = isc.Menu.create({
        data: [
            {
                title: "<spring:message code='refresh'/>",
                icon: "<spring:url value="refresh.png"/>",
                click: function () {
                    ListGrid_Education_refresh(ListGrid_EducationLevel);
                }
            }, {
                title: "<spring:message code='create'/>", icon: "<spring:url value="create.png"/>", click: function () {
                    ListGrid_Education_Add(educationLevelUrl, "<spring:message code='education.level'/>",
                        DynamicForm_EducationLevel, Window_EducationLevel);
                }
            }, {
                title: "<spring:message code='edit'/>", icon: "<spring:url value="edit.png"/>", click: function () {
                    DynamicForm_EducationLevel.clearValues();
                    ListGrid_Education_Edit(ListGrid_EducationLevel, educationLevelUrl,
                        "<spring:message code='education.level'/>",
                        DynamicForm_EducationLevel, Window_EducationLevel);
                }
            }, {
                title: "<spring:message code='remove'/>", icon: "<spring:url value="remove.png"/>", click: function () {
                    listGridEducation = ListGrid_EducationLevel;
                    ListGrid_Education_Remove(educationLevelUrl, "<spring:message code='msg.education.level.remove'/>");
                }
            }, {isSeparator: true}, {
                title: "<spring:message code='global.form.print.pdf'/>",
                icon: "<spring:url value="pdf.png"/>",
                click: function () {
                    trPrintWithCriteria("<spring:url value="educationLevel/printWithCriteria/"/>" + "pdf",
                        ListGrid_EducationLevel.getCriteria());
                }
            }, {
                title: "<spring:message code='global.form.print.excel'/>",
                icon: "<spring:url value="excel.png"/>",
                click: function () {
                    trPrintWithCriteria("<spring:url value="educationLevel/printWithCriteria/"/>" + "excel",
                        ListGrid_EducationLevel.getCriteria());
                }
            }, {
                title: "<spring:message code='global.form.print.html'/>",
                icon: "<spring:url value="html.png"/>",
                click: function () {
                    trPrintWithCriteria("<spring:url value="educationLevel/printWithCriteria/"/>" + "html",
                        ListGrid_EducationLevel.getCriteria());
                }
            }]
    });

    var ListGrid_EducationLevel = isc.TrLG.create({
        dataSource: RestDataSourceEducationLevel,
        contextMenu: Menu_ListGrid_EducationLevel,
        selectionType: "multiple",
        sortField: 0,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        fields: [
            {
                name: "titleFa",
                title: "<spring:message code="global.titleFa"/>",
                filterOperator: "iContains"
            },
            {
                name: "titleEn",
                title: "<spring:message code="global.titleEn"/>",
                filterOperator: "iContains"
            },
            {
                name: "code",
                title: "<spring:message code='code'/>",
                filterOperator: "equals"
            },
        ],
        rowDoubleClick: function () {
            ListGrid_Education_Edit(ListGrid_EducationLevel, educationLevelUrl,
                "<spring:message code='education.level'/>",
                DynamicForm_EducationLevel, Window_EducationLevel);
        }
    });

    var DynamicForm_EducationLevel = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        fields: [
            {name: "id", hidden: true},
            {
                name: "titleFa",
                title: "<spring:message code="global.titleFa"/>",
                required: true,
                validateOnChange: true,
                type: 'text',
                length: "100",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|' ']"
            },
            {
                name: "titleEn",
                title: "<spring:message code="global.titleEn"/>",
                type: 'text',
                length: "100",
                keyPressFilter: "[a-z|A-Z|0-9|' ']"
            },
            {
                name: "code",
                title: "<spring:message code='code'/>",
                required: true,
                validateOnChange: true,
                length: "5",
                keyPressFilter: "[0-9]"
            },
        ]
    });

    var ToolStripButton_Refresh_EducationLevel = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_Education_refresh(ListGrid_EducationLevel);
        }
    });

    var ToolStripButton_Edit_EducationLevel = isc.ToolStripButtonEdit.create({
        click: function () {
            DynamicForm_EducationLevel.clearValues();
            ListGrid_Education_Edit(ListGrid_EducationLevel, educationLevelUrl,
                "<spring:message code='education.level'/>",
                DynamicForm_EducationLevel, Window_EducationLevel);
        }
    });
    var ToolStripButton_Add_EducationLevel = isc.ToolStripButtonCreate.create({
        click: function () {
            ListGrid_Education_Add(educationLevelUrl, "<spring:message code='education.level'/>",
                DynamicForm_EducationLevel, Window_EducationLevel);
        }
    });
    var ToolStripButton_Remove_EducationLevel = isc.ToolStripButtonRemove.create({
        click: function () {
            listGridEducation = ListGrid_EducationLevel;
            ListGrid_Education_Remove(educationLevelUrl, "<spring:message code='msg.education.level.remove'/>");
        }
    });
    var ToolStripButton_Print_EducationLevel = isc.ToolStripButtonPrint.create({
        click: function () {
            trPrintWithCriteria("<spring:url value="educationLevel/printWithCriteria/"/>" + "pdf",
                ListGrid_EducationLevel.getCriteria());
        }
    });
    var ToolStrip_Actions_EducationLevel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            ToolStripButton_Add_EducationLevel,
            ToolStripButton_Edit_EducationLevel,
            ToolStripButton_Remove_EducationLevel,
            ToolStripButton_Print_EducationLevel,
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_Refresh_EducationLevel,
                ]
            }),

        ]
    });


    var IButton_EducationLevel_Save = isc.IButtonSave.create({
        top: 260,
        click: function () {
            if (!DynamicForm_EducationLevel.validate()) {
                return;
            }
            var data = DynamicForm_EducationLevel.getValues();
            isc.RPCManager.sendRequest(TrDSRequest(saveActionUrlEducation, methodEducation, JSON.stringify(data),
                "callback: edu_save_result(rpcResponse)"));
        }
    });
    var HLayout_EducationLevel_SaveOrExit = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        padding: 10,
        members: [IButton_EducationLevel_Save, isc.IButtonCancel.create({
            prompt: "",
            width: 100,
            orientation: "vertical",
            click: function () {
                DynamicForm_EducationLevel.clearValues();
                Window_EducationLevel.close();
            }
        })]
    });
    var Window_EducationLevel = isc.Window.create({
        width: "300",
        align: "center",
        border: "1px solid gray",
        closeClick: function () {
            this.Super("closeClick", arguments);
        },
        keyPress: function () {
            if (isc.EventHandler.getKey() == "Enter") {
                IButton_EducationLevel_Save.click();
            }
        },
        items: [isc.TrVLayout.create({
            members: [DynamicForm_EducationLevel, HLayout_EducationLevel_SaveOrExit]
        })]
    });

    var HLayout_Actions_EducationLevel = isc.HLayout.create({
        width: "100%",
        members: [ToolStrip_Actions_EducationLevel]
    });


    var HLayout_Grid_EducationLevel = isc.TrHLayout.create({
        members: [ListGrid_EducationLevel]
    });

    var VLayout_Body_EducationLevel = isc.TrVLayout.create({
        members: [HLayout_Actions_EducationLevel,
            HLayout_Grid_EducationLevel
        ]
    });


    //////////////////////////////////////////////////////////
    /////////////////////////Main Layout//////////////////////
    //////////////////////////////////////////////////////////

    var VLayout_Tabset_Education = isc.TabSet.create({
        tabBarPosition: "right",
        tabBarThickness: 100,
        tabs: [
            {title: "<spring:message code="education.level"/>", pane: VLayout_Body_EducationLevel},
            {title: "<spring:message code="education.major"/>", pane: VLayout_Body_EducationMajor},
            {title: "<spring:message code="education.orientation"/>", pane: VLayout_Body_EducationOrientation}
        ]
    });

    var VLayout_Tab_Education = isc.TrVLayout.create({
        members: [VLayout_Tabset_Education]
    });

    var VLayout_Body_Education = isc.TrVLayout.create({
        members: [VLayout_Tab_Education]
    });

    //////////////////////////////////////////////////////////
    ////////////////////////Functions/////////////////////////
    /////////////////////////////////////////////////////////

    function ListGrid_Education_Remove(Url, msg) {
        var record = listGridEducation.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            var Dialog_Education_remove = createDialog("ask", msg, "<spring:message code='verify.delete'/>");
            Dialog_Education_remove.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        waitEducation = createDialog("wait");
                        isc.RPCManager.sendRequest(TrDSRequest(Url + "delete/" + record.id, "DELETE", null,
                            "callback: edu_delete_result(rpcResponse)"));
                    }
                }
            });
        }
    }

    function ListGrid_Education_Edit(listGridEducation, Url, title, EducationDynamicForm, EducationWindows) {
        var record = listGridEducation.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            methodEducation = "PUT";
            saveActionUrlEducation = Url + record.id;
            EducationDynamicForm.clearValues();
            EducationDynamicForm.editRecord(record);
            EducationWindows.setTitle(title);
            EducationWindows.show();
        }
    }

    function ListGrid_Education_refresh(listGridEducation) {
        listGridEducation.invalidateCache();
        listGridEducation.filterByEditor();
    }

    function ListGrid_Education_Add(Url, title, EducationDynamicForm, EducationWindows) {
        methodEducation = "POST";
        saveActionUrlEducation = Url;
        EducationDynamicForm.clearValues();
        EducationWindows.setTitle(title);
        EducationWindows.show();
    }

    function edu_save_result(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            var responseID = JSON.parse(resp.data).id;
            var gridState = "[{id:" + responseID + "}]";
            var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>");
            if (resp.context.actionURL.contains("Major")) {
                edu_after_save(ListGrid_EducationMajor, Window_EducationMajor, gridState);
            } else if ((resp.context.actionURL).contains("Level")) {
                edu_after_save(ListGrid_EducationLevel, Window_EducationLevel, gridState);
            } else if (resp.context.actionURL.contains("Orientation")) {
                edu_after_save(ListGrid_EducationOrientation, Window_EducationOrientation, gridState);
            }
            setTimeout(function () {
                OK.close();
            }, 3000);
        } else {
            let respText = resp.httpResponseText;
            if (resp.httpResponseCode === 406 && respText === "DuplicateRecord") {
                createDialog("info", "<spring:message code="msg.record.duplicate"/>");
            } else if (resp.httpResponseCode === 406 && respText === "NotEditable") {
                createDialog("info", "<spring:message code='msg.education.orientation.edit.error'/>");
            } else {
                createDialog("info", "<spring:message code="msg.operation.error"/>");
            }
        }
    }

    function edu_delete_result(resp) {
        waitEducation.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            ListGrid_Education_refresh(listGridEducation);
            var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>");
            setTimeout(function () {
                OK.close();
            }, 3000);
        } else {
            let respText = resp.httpResponseText;
            if (resp.httpResponseCode === 406 && respText === "NotDeletable") {
                createDialog("info", "<spring:message code='msg.record.cannot.deleted'/>");
            } else {
                createDialog("info", "<spring:message code="msg.operation.error"/>");
            }
        }
    }

    function edu_after_save(edu_grid, edu_window, gridState) {
        ListGrid_Education_refresh(edu_grid);
        setTimeout(function () {
            edu_grid.setSelectedState(gridState);
        }, 1000);
        edu_window.close();
    }

    //</script>