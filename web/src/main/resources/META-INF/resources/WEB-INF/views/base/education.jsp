<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

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
            {name: "code", type: "integer", filterOperator: "equals"}
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
            <sec:authorize access="hasAuthority('EducationOrientation_R')">
            {
                title: "<spring:message code='refresh'/>",
                click: function () {
                    refreshLG(ListGrid_EducationOrientation);
                }
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('EducationOrientation_C')">
            {
                title: "<spring:message code='create'/>",
                click: function () {
                    ListGrid_Education_Add(educationOrientationUrl, "<spring:message code='education.orientation'/>",
                        DynamicForm_EducationOrientation, Window_EducationOrientation);
                }
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('EducationOrientation_U')">
            {
                title: "<spring:message code='edit'/>",
                click: function () {
                    DynamicForm_EducationOrientation.clearValues();
                    ListGrid_Education_Edit(ListGrid_EducationOrientation, educationOrientationUrl,
                        "<spring:message code='education.orientation'/>",
                        DynamicForm_EducationOrientation, Window_EducationOrientation);
                }
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('EducationOrientation_D')">
            {
                title: "<spring:message code='remove'/>",
                click: function () {
                    listGridEducation = ListGrid_EducationOrientation;
                    ListGrid_Education_Remove(educationOrientationUrl, "<spring:message code='msg.education.orientation.remove'/>");
                }
            },
            </sec:authorize>
            {isSeparator: true},
            <sec:authorize access="hasAuthority('EducationOrientation_P')">
            {
                title: "<spring:message code='global.form.print.pdf'/>",
                click: function () {
                    trPrintWithCriteria("<spring:url value="education/educationOrientation/printWithCriteria/"/>" + "pdf",
                        ListGrid_EducationOrientation.getCriteria());
                }
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('EducationOrientation_P')">
            {
                title: "<spring:message code='global.form.print.excel'/>",
                click: function () {
                    trPrintWithCriteria("<spring:url value="education/educationOrientation/printWithCriteria/"/>" + "excel",
                        ListGrid_EducationOrientation.getCriteria());
                }
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('EducationOrientation_P')">
            {
                title: "<spring:message code='global.form.print.html'/>",
                click: function () {
                    trPrintWithCriteria("<spring:url value="education/educationOrientation/printWithCriteria/"/>" + "html",
                        ListGrid_EducationOrientation.getCriteria());
                }
            }
            </sec:authorize>
            ]
    });

    var ListGrid_EducationOrientation = isc.TrLG.create({
        <sec:authorize access="hasAuthority('EducationOrientation_R')">
        dataSource: RestDataSourceEducationOrientation,
        </sec:authorize>
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
                validateOnExit: true,
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
                type: "SelectItem",
                addUnknownValues: false,
                required: true,
                validateOnExit: true,
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
                type: "SelectItem",
                addUnknownValues: false,
                required: true,
                validateOnExit: true,
                optionDataSource: RestDataSourceEducationMajor,
                displayField: "titleFa",
                valueField: "id",
                filterFields: ["titleFa"],
                filterOperator: "iContains",
                pickListFields: [{name: "titleFa"}],
            }
        ]
    });

    var ToolStripButton_Refresh_EducationOrientation = isc.ToolStripButtonRefresh.create({
        click: function () {
            refreshLG(ListGrid_EducationOrientation);
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
            trPrintWithCriteria("<spring:url value="education/educationOrientation/printWithCriteria/"/>" + "pdf",
                ListGrid_EducationOrientation.getCriteria());
        }
    });

    let ToolStrip_EducationOrientation_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let criteria = ListGrid_EducationOrientation.getCriteria();
                    ExportToFile.downloadExcel(null, ListGrid_EducationOrientation , "EducationOrientation", 0, null, '',"لیست مقاطع تحصیلی - آموزش"  , criteria, null);
                }
            })
        ]
    });

    var ToolStrip_Actions_EducationOrientation = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            <sec:authorize access="hasAuthority('EducationOrientation_C')">
            ToolStripButton_Add_EducationOrientation,
            </sec:authorize>
            <sec:authorize access="hasAuthority('EducationOrientation_U')">
            ToolStripButton_Edit_EducationOrientation,
            </sec:authorize>
            <sec:authorize access="hasAuthority('EducationOrientation_D')">
            ToolStripButton_Remove_EducationOrientation,
            </sec:authorize>
            <sec:authorize access="hasAuthority('EducationOrientation_P')">
            ToolStripButton_Print_EducationOrientation,
            </sec:authorize>
            <sec:authorize access="hasAuthority('EducationOrientation_P')">
            ToolStrip_EducationOrientation_Export2EXcel,
            </sec:authorize>
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    <sec:authorize access="hasAuthority('EducationOrientation_R')">
                    ToolStripButton_Refresh_EducationOrientation,
                    </sec:authorize>
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
        width: "500",
        align: "center",
        border: "1px solid gray",
        closeClick: function () {
            this.Super("closeClick", arguments);
        },
        keyPress: function () {
            if (isc.EventHandler.getKey() === "Enter") {
                IButton_EducationOrientation_Save.click();
            }
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
            <sec:authorize access="hasAuthority('EducationMajor_R')">
            {
                title: "<spring:message code='refresh'/>",
                click: function () {
                    refreshLG(ListGrid_EducationMajor);
                }
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('EducationMajor_C')">
            {
                title: "<spring:message code='create'/>",
                click: function () {
                    ListGrid_Education_Add(educationMajorUrl, "<spring:message code='education.major'/>",
                        DynamicForm_EducationMajor, Window_EducationMajor);
                }
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('EducationMajor_U')">
            {
                title: "<spring:message code='edit'/>",
                click: function () {
                    DynamicForm_EducationMajor.clearValues();
                    ListGrid_Education_Edit(ListGrid_EducationMajor, educationMajorUrl,
                        "<spring:message code='education.major'/>",
                        DynamicForm_EducationMajor, Window_EducationMajor);
                }
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('EducationMajor_D')">
            {
                title: "<spring:message code='remove'/>",
                click: function () {
                    listGridEducation = ListGrid_EducationMajor;
                    ListGrid_Education_Remove(educationMajorUrl, "<spring:message code='msg.education.major.remove'/>");
                }
            },
            </sec:authorize>
            {isSeparator: true},
            <sec:authorize access="hasAuthority('EducationMajor_P')">
            {
                title: "<spring:message code='global.form.print.pdf'/>",
                click: function () {
                    trPrintWithCriteria("<spring:url value="education/educationMajor/printWithCriteria/"/>" + "pdf",
                        ListGrid_EducationMajor.getCriteria());
                }
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('EducationMajor_P')">
            {
                title: "<spring:message code='global.form.print.excel'/>",
                click: function () {
                    trPrintWithCriteria("<spring:url value="education/educationMajor/printWithCriteria/"/>" + "excel",
                        ListGrid_EducationMajor.getCriteria());
                }
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('EducationMajor_P')">
            {
                title: "<spring:message code='global.form.print.html'/>",
                click: function () {
                    trPrintWithCriteria("<spring:url value="education/educationMajor/printWithCriteria/"/>" + "html",
                        ListGrid_EducationMajor.getCriteria());
                }
            }
            </sec:authorize>
            ]
    });

    var ListGrid_EducationMajor = isc.TrLG.create({
        <sec:authorize access="hasAuthority('EducationMajor_R')">
        dataSource: RestDataSourceEducationMajor,
        </sec:authorize>
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
                validateOnExit: true,
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
            refreshLG(ListGrid_EducationMajor);
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
            trPrintWithCriteria("<spring:url value="education/educationMajor/printWithCriteria/"/>" + "pdf",
                ListGrid_EducationMajor.getCriteria());
        }
    });

    let ToolStrip_EducationMajor_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let criteria = ListGrid_EducationMajor.getCriteria();
                    ExportToFile.downloadExcel(null, ListGrid_EducationMajor , "EducationMajor", 0, null, '',"لیست رشته های تحصیلی - آموزش"  , criteria, null);
                }
            })
        ]
    });

    var ToolStrip_Actions_EducationMajor = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            <sec:authorize access="hasAuthority('EducationMajor_C')">
            ToolStripButton_Add_EducationMajor,
            </sec:authorize>
            <sec:authorize access="hasAuthority('EducationMajor_U')">
            ToolStripButton_Edit_EducationMajor,
            </sec:authorize>
            <sec:authorize access="hasAuthority('EducationMajor_D')">
            ToolStripButton_Remove_EducationMajor,
            </sec:authorize>
            <sec:authorize access="hasAuthority('EducationMajor_P')">
            ToolStripButton_Print_EducationMajor,
            </sec:authorize>
            <sec:authorize access="hasAuthority('EducationMajor_P')">
            ToolStrip_EducationMajor_Export2EXcel,
            </sec:authorize>
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    <sec:authorize access="hasAuthority('EducationMajor_R')">
                    ToolStripButton_Refresh_EducationMajor,
                    </sec:authorize>
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
        keyPress: function () {
            if (isc.EventHandler.getKey() === "Enter") {
                IButton_EducationMajor_Save.click();
            }
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
            <sec:authorize access="hasAuthority('EducationLevel_R')">
            {
                title: "<spring:message code='refresh'/>",
                click: function () {
                    refreshLG(ListGrid_EducationLevel);
                }
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('EducationLevel_C')">
            {
                title: "<spring:message code='create'/>",
                click: function () {
                    ListGrid_Education_Add(educationLevelUrl, "<spring:message code='education.level'/>",
                        DynamicForm_EducationLevel, Window_EducationLevel);
                }
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('EducationLevel_U')">
            {
                title: "<spring:message code='edit'/>",
                click: function () {
                    DynamicForm_EducationLevel.clearValues();
                    ListGrid_Education_Edit(ListGrid_EducationLevel, educationLevelUrl,
                        "<spring:message code='education.level'/>",
                        DynamicForm_EducationLevel, Window_EducationLevel);
                }
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('EducationLevel_D')">
            {
                title: "<spring:message code='remove'/>",
                click: function () {
                    listGridEducation = ListGrid_EducationLevel;
                    ListGrid_Education_Remove(educationLevelUrl, "<spring:message code='msg.education.level.remove'/>");
                }
            },
            </sec:authorize>
            {isSeparator: true},
            <sec:authorize access="hasAuthority('EducationLevel_P')">
            {
                title: "<spring:message code='global.form.print.pdf'/>",
                click: function () {
                    trPrintWithCriteria("<spring:url value="education/educationLevel/printWithCriteria/"/>" + "pdf",
                        ListGrid_EducationLevel.getCriteria());
                }
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('EducationLevel_P')">
            {
                title: "<spring:message code='global.form.print.excel'/>",
                click: function () {
                    trPrintWithCriteria("<spring:url value="education/educationLevel/printWithCriteria/"/>" + "excel",
                        ListGrid_EducationLevel.getCriteria());
                }
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('EducationLevel_P')">
            {
                title: "<spring:message code='global.form.print.html'/>",
                click: function () {
                    trPrintWithCriteria("<spring:url value="education/educationLevel/printWithCriteria/"/>" + "html",
                        ListGrid_EducationLevel.getCriteria());
                }
            }
            </sec:authorize>
        ]
    });

    var ListGrid_EducationLevel = isc.TrLG.create({
        dataSource: RestDataSourceEducationLevel,
        <sec:authorize access="hasAuthority('EducationLevel_R')">
        contextMenu: Menu_ListGrid_EducationLevel,
        </sec:authorize>
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
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
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
                validateOnExit: true,
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
                validateOnExit: true,
                length: "5",
                keyPressFilter: "[0-9]"
            },
        ]
    });

    var ToolStripButton_Refresh_EducationLevel = isc.ToolStripButtonRefresh.create({
        click: function () {
            refreshLG(ListGrid_EducationLevel);
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
            trPrintWithCriteria("<spring:url value="education/educationLevel/printWithCriteria/"/>" + "pdf",
                ListGrid_EducationLevel.getCriteria());
        }
    });

    let ToolStrip_EducationLevel_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let criteria = ListGrid_EducationLevel.getCriteria();
                    ExportToFile.downloadExcel(null, ListGrid_EducationLevel , "EducationLevel", 0, null, '',"لیست گرایش های تحصیلی - آموزش"  , criteria, null);
                }
            })
        ]
    });

    var ToolStrip_Actions_EducationLevel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            <sec:authorize access="hasAuthority('EducationLevel_C')">
            ToolStripButton_Add_EducationLevel,
            </sec:authorize>
            <sec:authorize access="hasAuthority('EducationLevel_U')">
            ToolStripButton_Edit_EducationLevel,
            </sec:authorize>
            <sec:authorize access="hasAuthority('EducationLevel_D')">
            ToolStripButton_Remove_EducationLevel,
            </sec:authorize>
            <sec:authorize access="hasAuthority('EducationLevel_P')">
            ToolStripButton_Print_EducationLevel,
            </sec:authorize>
            <sec:authorize access="hasAuthority('EducationLevel_P')">
            ToolStrip_EducationLevel_Export2EXcel,
            </sec:authorize>
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    <sec:authorize access="hasAuthority('EducationLevel_R')">
                    ToolStripButton_Refresh_EducationLevel,
                    </sec:authorize>
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
            if (isc.EventHandler.getKey() === "Enter") {
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
            if (resp.context.actionURL.toLowerCase().contains("major")) {
                edu_after_save(ListGrid_EducationMajor, Window_EducationMajor, gridState);
            } else if ((resp.context.actionURL).toLowerCase().contains("level")) {
                edu_after_save(ListGrid_EducationLevel, Window_EducationLevel, gridState);
            } else if (resp.context.actionURL.toLowerCase().contains("orientation")) {
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
            refreshLG(listGridEducation);
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
        refreshLG(edu_grid);
        setTimeout(function () {
            edu_grid.setSelectedState(gridState);
        }, 1000);
        edu_window.close();
    }

    //</script>