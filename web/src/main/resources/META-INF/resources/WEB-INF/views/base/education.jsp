<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>
    var methodEducation = "GET";
    var saveActionUrl;
    var educationLevelUrl = educationUrl + "level/";
    var educationMajorUrl = educationUrl + "major/";
    var educationOrientationUrl = educationUrl + "orientation/";
    var EducationListGrid;
    var wait;


    //////////////////////////////////////////////////////////
    ///////////////////////DataSource/////////////////////////
    /////////////////////////////////////////////////////////

    var RestDataSourceEducationLevel = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa"}, {name: "titleEn"}],
        fetchDataURL: educationLevelUrl + "spec-list"
    });

    var RestDataSourceEducationMajor = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa"}, {name: "titleEn"}],
        fetchDataURL: educationMajorUrl + "spec-list"
    });

    var RestDataSourceEducationOrientation = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "educationLevelId", hidden: true},
            {name: "educationMajorId", hidden: true},
            {name: "educationLevel.titleFa"},
            {name: "educationMajor.titleFa"}
        ],
        fetchDataURL: educationOrientationUrl + "spec-list"
    });

    var RestDataSource_eduLevel = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa"}
        ],
        fetchDataURL: educationLevelUrl + "spec-list?_startRow=0&_endRow=55",
        autoFetchData: true
    });

    var RestDataSource_eduMajor = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa"}
        ],
        fetchDataURL: educationMajorUrl + "spec-list?_startRow=0&_endRow=100",
        autoFetchData: true
    });


    //////////////////////////////////////////////////////////
    /////////////////Education Orientation////////////////////
    /////////////////////////////////////////////////////////

    Menu_ListGrid_EducationOrientation = isc.Menu.create({
        data: [
            {
                title: "بازخوانی اطلاعات", icon: "<spring:url value="refresh.png"/>", click: function () {
                    ListGrid_Education_refresh(ListGrid_EducationOrientation);
                }
            }, {
                title: "ایجاد", icon: "<spring:url value="create.png"/>", click: function () {
                    ListGrid_Education_Add(educationOrientationUrl, "<spring:message code='education.add.orientation'/>",
                        DynamicForm_EducationOrientation, Window_EducationOrientation);
                }
            }, {
                title: "ویرایش", icon: "<spring:url value="edit.png"/>", click: function () {
                    DynamicForm_EducationOrientation.clearValues();
                    ListGrid_Education_Edit(ListGrid_EducationOrientation, educationOrientationUrl,
                        "<spring:message code='education.edit.orientation'/>",
                        DynamicForm_EducationOrientation, Window_EducationOrientation);
                }
            }, {
                title: "حذف", icon: "<spring:url value="remove.png"/>", click: function () {
                    EducationListGrid = ListGrid_EducationOrientation;
                    ListGrid_Education_Remove(educationOrientationUrl, "<spring:message code='msg.education.orientation.remove'/>");
                }
            }, {isSeparator: true}, {
                title: "ارسال به Pdf", icon: "<spring:url value="pdf.png"/>", click: function () {
                    trPrintWithCriteria("<spring:url value="education/orientation/printWithCriteria/"/>" + "pdf",
                        ListGrid_EducationOrientation.getCriteria());
                }
            }, {
                title: "ارسال به Excel", icon: "<spring:url value="excel.png"/>", click: function () {
                    trPrintWithCriteria("<spring:url value="education/orientation/printWithCriteria/"/>" + "excel",
                        ListGrid_EducationOrientation.getCriteria());
                }
            }, {
                title: "ارسال به Html", icon: "<spring:url value="html.png"/>", click: function () {
                    trPrintWithCriteria("<spring:url value="education/orientation/printWithCriteria/"/>" + "html",
                        ListGrid_EducationOrientation.getCriteria());
                }
            }]
    });

    var ListGrid_EducationOrientation = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSourceEducationOrientation,
        contextMenu: Menu_ListGrid_EducationOrientation,
        fields: [
            {name: "id", title: "شماره", hidden: true},
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
            },
            {name: "educationLevelId", hidden: true},
            {name: "educationMajorId", hidden: true},
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
        selectionType: "multiple",
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        allowAdvancedCriteria: true,
        autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
        autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
        filterUsingText: "فیلتر کردن",
        groupByText: "گروه بندی",
        freezeFieldText: "ثابت نگه داشتن",
        doubleClick: function () {
            ListGrid_Education_Edit(ListGrid_EducationOrientation, educationOrientationUrl,
                "<spring:message code='education.edit.orientation'/>",
                DynamicForm_EducationOrientation, Window_EducationOrientation);
        }
    });

    var DynamicForm_EducationOrientation = isc.DynamicForm.create({
        fields: [
            {name: "id", hidden: true},
            {
                name: "titleFa",
                title: "<spring:message code="global.titleFa"/>",
                required: true,
                length: "100",
                readonly: true,
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|' ']"
            },
            {
                name: "titleEn",
                title: "<spring:message code="global.titleEn"/>",
                length: "100",
                keyPressFilter: "[a-z|A-Z|0-9|' ']"
            },
            {
                name: "educationLevelId",
                title: "<spring:message code="education.level"/>",
                editorType: "ComboBoxItem",
                addUnknownValues: false,
                required: true,
                optionDataSource: RestDataSource_eduLevel,
                displayField: "titleFa",
                valueField: "id",
                filterFields: ["titleFa"],
                filterOperator: "contains",
                pickListFields: [{name: "titleFa"}]
            },
            {
                name: "educationMajorId",
                title: "<spring:message code="education.major"/>",
                editorType: "ComboBoxItem",
                addUnknownValues: false,
                required: true,
                optionDataSource: RestDataSource_eduMajor,
                displayField: "titleFa",
                valueField: "id",
                filterFields: ["titleFa"],
                filterOperator: "contains",
                pickListFields: [{name: "titleFa"}]
            }
        ]
    });

    var ToolStripButton_Refresh_EducationOrientation = isc.TrRefreshBtn.create({
        click: function () {
            ListGrid_Education_refresh(ListGrid_EducationOrientation);
        }
    });

    var ToolStripButton_Edit_EducationOrientation = isc.TrEditBtn.create({
        click: function () {
            DynamicForm_EducationOrientation.clearValues();
            ListGrid_Education_Edit(ListGrid_EducationOrientation, educationOrientationUrl,
                "<spring:message code='education.edit.orientation'/>",
                DynamicForm_EducationOrientation, Window_EducationOrientation);
        }
    });
    var ToolStripButton_Add_EducationOrientation = isc.TrCreateBtn.create({
        click: function () {
            ListGrid_Education_Add(educationOrientationUrl, "<spring:message code='education.add.orientation'/>",
                DynamicForm_EducationOrientation, Window_EducationOrientation);
        }
    });
    var ToolStripButton_Remove_EducationOrientation = isc.TrRemoveBtn.create({
        icon: "[SKIN]/actions/remove.png",
        title: "<spring:message code="remove"/> ",
        click: function () {
            EducationListGrid = ListGrid_EducationOrientation;
            ListGrid_Education_Remove(educationOrientationUrl, "<spring:message code='msg.education.orientation.remove'/>");
        }
    });
    var ToolStripButton_Print_EducationOrientation = isc.ToolStripButton.create({
        icon: "[SKIN]/RichTextEditor/print.png",
        title: "<spring:message code='print'/>",
        click: function () {
            trPrintWithCriteria("<spring:url value="education/orientation/printWithCriteria/"/>" + "pdf",
                ListGrid_EducationOrientation.getCriteria());
        }
    });
    var ToolStrip_Actions_EducationOrientation = isc.ToolStrip.create({
        width: "100%",
        members: [ToolStripButton_Refresh_EducationOrientation,
            ToolStripButton_Add_EducationOrientation,
            ToolStripButton_Edit_EducationOrientation,
            ToolStripButton_Remove_EducationOrientation,
            ToolStripButton_Print_EducationOrientation]
    });


    var IButton_EducationOrientation_Save = isc.TrSaveBtn.create({
        top: 260,
        click: function () {
            DynamicForm_EducationOrientation.validate();
            if (DynamicForm_EducationOrientation.hasErrors()) {
                return;
            }
            var data = DynamicForm_EducationOrientation.getValues();
            isc.RPCManager.sendRequest(TrDSRequest(saveActionUrl, methodEducation, JSON.stringify(data),
                "callback: edu_save_result(rpcResponse)"));
        }
    });
    var HLayout_EducationOrientation_SaveOrExit = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        members: [IButton_EducationOrientation_Save, isc.TrCancelBtn.create({
            prompt: "",
            width: 100,
            icon: "<spring:url value="remove.png"/>",
            orientation: "vertical",
            click: function () {
                DynamicForm_EducationOrientation.clearValues();
                Window_EducationOrientation.close();
            }
        })]
    });
    var Window_EducationOrientation = isc.Window.create({
        align: "center",
        border: "1px solid gray",
        closeClick: function () {
            this.Super("closeClick", arguments);
        },
        items: [isc.TrVLayout.create({
            width: "300",
            height: "120",
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
                title: "بازخوانی اطلاعات", icon: "<spring:url value="refresh.png"/>", click: function () {
                    ListGrid_Education_refresh(ListGrid_EducationMajor);
                }
            }, {
                title: "ایجاد", icon: "<spring:url value="create.png"/>", click: function () {
                    ListGrid_Education_Add(educationMajorUrl, "<spring:message code='education.add.major'/>",
                        DynamicForm_EducationMajor, Window_EducationMajor);
                }
            }, {
                title: "ویرایش", icon: "<spring:url value="edit.png"/>", click: function () {
                    DynamicForm_EducationMajor.clearValues();
                    ListGrid_Education_Edit(ListGrid_EducationMajor, educationMajorUrl,
                        "<spring:message code='education.edit.major'/>",
                        DynamicForm_EducationMajor, Window_EducationMajor);
                }
            }, {
                title: "حذف", icon: "<spring:url value="remove.png"/>", click: function () {
                    EducationListGrid = ListGrid_EducationMajor;
                    ListGrid_Education_Remove(educationMajorUrl, "<spring:message code='msg.education.major.remove'/>");
                }
            }, {isSeparator: true}, {
                title: "ارسال به Pdf", icon: "<spring:url value="pdf.png"/>", click: function () {
                    trPrintWithCriteria("<spring:url value="education/major/printWithCriteria/"/>" + "pdf",
                        ListGrid_EducationMajor.getCriteria());
                }
            }, {
                title: "ارسال به Excel", icon: "<spring:url value="excel.png"/>", click: function () {
                    trPrintWithCriteria("<spring:url value="education/major/printWithCriteria/"/>" + "excel",
                        ListGrid_EducationMajor.getCriteria());
                }
            }, {
                title: "ارسال به Html", icon: "<spring:url value="html.png"/>", click: function () {
                    trPrintWithCriteria("<spring:url value="education/major/printWithCriteria/"/>" + "html",
                        ListGrid_EducationMajor.getCriteria());
                }
            }]
    });

    var ListGrid_EducationMajor = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSourceEducationMajor,
        contextMenu: Menu_ListGrid_EducationMajor,
        fields: [
            {name: "id", title: "شماره", hidden: true},
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
        selectionType: "multiple",
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        allowAdvancedCriteria: true,
        autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
        autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
        filterUsingText: "فیلتر کردن",
        groupByText: "گروه بندی",
        freezeFieldText: "ثابت نگه داشتن",
        doubleClick: function () {
            ListGrid_Education_Edit(ListGrid_EducationMajor, educationMajorUrl,
                "<spring:message code='education.edit.major'/>",
                DynamicForm_EducationMajor, Window_EducationMajor);
        }
    });

    var DynamicForm_EducationMajor = isc.DynamicForm.create({
        fields: [
            {name: "id", hidden: true},
            {
                name: "titleFa",
                title: "<spring:message code="global.titleFa"/>",
                required: true,
                length: "100",
                readonly: true,
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

    var ToolStripButton_Refresh_EducationMajor = isc.TrRefreshBtn.create({
        click: function () {
            ListGrid_Education_refresh(ListGrid_EducationMajor);
        }
    });

    var ToolStripButton_Edit_EducationMajor = isc.TrEditBtn.create({
        click: function () {
            DynamicForm_EducationMajor.clearValues();
            ListGrid_Education_Edit(ListGrid_EducationMajor, educationMajorUrl,
                "<spring:message code='education.edit.major'/>",
                DynamicForm_EducationMajor, Window_EducationMajor);
        }
    });
    var ToolStripButton_Add_EducationMajor = isc.TrCreateBtn.create({
        click: function () {
            ListGrid_Education_Add(educationMajorUrl, "<spring:message code='education.add.major'/>",
                DynamicForm_EducationMajor, Window_EducationMajor);
        }
    });
    var ToolStripButton_Remove_EducationMajor = isc.TrRemoveBtn.create({
        click: function () {
            EducationListGrid = ListGrid_EducationMajor;
            ListGrid_Education_Remove(educationMajorUrl, "<spring:message code='msg.education.major.remove'/>");
        }
    });
    var ToolStripButton_Print_EducationMajor = isc.ToolStripButton.create({
        icon: "[SKIN]/RichTextEditor/print.png",
        title: "<spring:message code='print'/>",
        click: function () {
            trPrintWithCriteria("<spring:url value="education/major/printWithCriteria/"/>" + "pdf",
                ListGrid_EducationMajor.getCriteria());
        }
    });
    var ToolStrip_Actions_EducationMajor = isc.ToolStrip.create({
        width: "100%",
        members: [ToolStripButton_Refresh_EducationMajor,
            ToolStripButton_Add_EducationMajor,
            ToolStripButton_Edit_EducationMajor,
            ToolStripButton_Remove_EducationMajor,
            ToolStripButton_Print_EducationMajor]
    });


    var IButton_EducationMajor_Save = isc.TrSaveBtn.create({
        top: 260,
        click: function () {
            DynamicForm_EducationMajor.validate();
            if (DynamicForm_EducationMajor.hasErrors()) {
                return;
            }
            var data = DynamicForm_EducationMajor.getValues();
            isc.RPCManager.sendRequest(TrDSRequest(saveActionUrl, methodEducation, JSON.stringify(data),
                "callback: edu_save_result(rpcResponse)"));
        }
    });
    var HLayout_EducationMajor_SaveOrExit = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        padding: 10,
        members: [IButton_EducationMajor_Save, isc.TrCancelBtn.create({
            prompt: "",
            width: 100,
            icon: "<spring:url value="remove.png"/>",
            orientation: "vertical",
            click: function () {
                DynamicForm_EducationMajor.clearValues();
                Window_EducationMajor.close();
            }
        })]
    });
    var Window_EducationMajor = isc.Window.create({
        align: "center",
        border: "1px solid gray",
        closeClick: function () {
            this.Super("closeClick", arguments);
        },
        items: [isc.TrVLayout.create({
            width: "300",
            height: "120",
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
                title: "بازخوانی اطلاعات", icon: "<spring:url value="refresh.png"/>", click: function () {
                    ListGrid_Education_refresh(ListGrid_EducationLevel);
                }
            }, {
                title: "ایجاد", icon: "<spring:url value="create.png"/>", click: function () {
                    ListGrid_Education_Add(educationLevelUrl, "<spring:message code='education.add.level'/>",
                        DynamicForm_EducationLevel, Window_EducationLevel);
                }
            }, {
                title: "ویرایش", icon: "<spring:url value="edit.png"/>", click: function () {
                    DynamicForm_EducationLevel.clearValues();
                    ListGrid_Education_Edit(ListGrid_EducationLevel, educationLevelUrl,
                        "<spring:message code='education.edit.level'/>",
                        DynamicForm_EducationLevel, Window_EducationLevel);
                }
            }, {
                title: "حذف", icon: "<spring:url value="remove.png"/>", click: function () {
                    EducationListGrid = ListGrid_EducationLevel;
                    ListGrid_Education_Remove(educationLevelUrl, "<spring:message code='msg.education.level.remove'/>");
                }
            }, {isSeparator: true}, {
                title: "ارسال به Pdf", icon: "<spring:url value="pdf.png"/>", click: function () {
                    trPrintWithCriteria("<spring:url value="education/level/printWithCriteria/"/>" + "pdf",
                        ListGrid_EducationLevel.getCriteria());
                }
            }, {
                title: "ارسال به Excel", icon: "<spring:url value="excel.png"/>", click: function () {
                    trPrintWithCriteria("<spring:url value="education/level/printWithCriteria/"/>" + "excel",
                        ListGrid_EducationLevel.getCriteria());
                }
            }, {
                title: "ارسال به Html", icon: "<spring:url value="html.png"/>", click: function () {
                    trPrintWithCriteria("<spring:url value="education/level/printWithCriteria/"/>" + "html",
                        ListGrid_EducationLevel.getCriteria());
                }
            }]
    });

    var ListGrid_EducationLevel = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSourceEducationLevel,
        contextMenu: Menu_ListGrid_EducationLevel,
        fields: [
            {name: "id", title: "شماره", hidden: true},
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
        selectionType: "multiple",
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        allowAdvancedCriteria: true,
        autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
        autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
        filterUsingText: "فیلتر کردن",
        groupByText: "گروه بندی",
        freezeFieldText: "ثابت نگه داشتن",
        doubleClick: function () {
            ListGrid_Education_Edit(ListGrid_EducationLevel, educationLevelUrl,
                "<spring:message code='education.edit.level'/>",
                DynamicForm_EducationLevel, Window_EducationLevel);
        }
    });

    var DynamicForm_EducationLevel = isc.DynamicForm.create({
        fields: [
            {name: "id", hidden: true},
            {
                name: "titleFa",
                title: "<spring:message code="global.titleFa"/>",
                required: true,
                type: 'text',
                length: "100",
                readonly: true,
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|' ']"
            },
            {
                name: "titleEn",
                title: "<spring:message code="global.titleEn"/>",
                type: 'text',
                length: "100",
                keyPressFilter: "[a-z|A-Z|0-9|' ']"
            }
        ]
    });

    var ToolStripButton_Refresh_EducationLevel = isc.TrRefreshBtn.create({
        click: function () {
            ListGrid_Education_refresh(ListGrid_EducationLevel);
        }
    });

    var ToolStripButton_Edit_EducationLevel = isc.TrEditBtn.create({
        click: function () {
            DynamicForm_EducationLevel.clearValues();
            ListGrid_Education_Edit(ListGrid_EducationLevel, educationLevelUrl,
                "<spring:message code='education.edit.level'/>",
                DynamicForm_EducationLevel, Window_EducationLevel);
        }
    });
    var ToolStripButton_Add_EducationLevel = isc.TrCreateBtn.create({
        click: function () {
            ListGrid_Education_Add(educationLevelUrl, "<spring:message code='education.add.level'/>",
                DynamicForm_EducationLevel, Window_EducationLevel);
        }
    });
    var ToolStripButton_Remove_EducationLevel = isc.TrRemoveBtn.create({
        click: function () {
            EducationListGrid = ListGrid_EducationLevel;
            ListGrid_Education_Remove(educationLevelUrl, "<spring:message code='msg.education.level.remove'/>");
        }
    });
    var ToolStripButton_Print_EducationLevel = isc.ToolStripButton.create({
        icon: "[SKIN]/RichTextEditor/print.png",
        title: "<spring:message code='print'/>",
        click: function () {
            trPrintWithCriteria("<spring:url value="education/level/printWithCriteria/"/>" + "pdf",
                ListGrid_EducationLevel.getCriteria());
        }
    });
    var ToolStrip_Actions_EducationLevel = isc.ToolStrip.create({
        width: "100%",
        members: [ToolStripButton_Refresh_EducationLevel,
            ToolStripButton_Add_EducationLevel,
            ToolStripButton_Edit_EducationLevel,
            ToolStripButton_Remove_EducationLevel,
            ToolStripButton_Print_EducationLevel]
    });


    var IButton_EducationLevel_Save = isc.TrSaveBtn.create({
        top: 260,
        click: function () {
            DynamicForm_EducationLevel.validate();
            if (DynamicForm_EducationLevel.hasErrors()) {
                return;
            }
            var data = DynamicForm_EducationLevel.getValues();
            isc.RPCManager.sendRequest(TrDSRequest(saveActionUrl, methodEducation, JSON.stringify(data),
                "callback: edu_save_result(rpcResponse)"));
        }
    });
    var HLayout_EducationLevel_SaveOrExit = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        padding: 10,
        members: [IButton_EducationLevel_Save, isc.TrCancelBtn.create({
            prompt: "",
            width: 100,
            icon: "<spring:url value="remove.png"/>",
            orientation: "vertical",
            click: function () {
                DynamicForm_EducationLevel.clearValues();
                Window_EducationLevel.close();
            }
        })]
    });
    var Window_EducationLevel = isc.Window.create({
        align: "center",
        border: "1px solid gray",
        closeClick: function () {
            this.Super("closeClick", arguments);
        },
        items: [isc.TrVLayout.create({
            width: "300",
            height: "120",
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
        var record = EducationListGrid.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.not.selected.record'/>");
        } else {
            var Dialog_Education_remove = createDialog("ask", msg, "<spring:message code='global.warning'/>");
            Dialog_Education_remove.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        wait = createDialog("wait");
                        isc.RPCManager.sendRequest(TrDSRequest(Url + "delete/" + record.id, "DELETE", null,
                            "callback: edu_delete_result(rpcResponse)"));
                    }
                }
            });
            ListGrid_Education_refresh(EducationListGrid);
        }
    }

    function ListGrid_Education_Edit(EducationListGrid, Url, title, EducationDynamicForm, EducationWindows) {
        var record = EducationListGrid.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.not.selected.record'/>");
        } else {
            methodEducation = "PUT";
            saveActionUrl = Url + record.id;
            EducationDynamicForm.clearValues();
            EducationDynamicForm.editRecord(record);
            EducationWindows.setTitle(title);
            EducationWindows.show();
        }
    }

    function ListGrid_Education_refresh(EducationListGrid) {
        var record = EducationListGrid.getSelectedRecord();
        if (record != null && record.id != null) {
            EducationListGrid.selectRecord(record);
        }
        EducationListGrid.invalidateCache();
        EducationListGrid.filterByEditor();
    }

    function ListGrid_Education_Add(Url, title, EducationDynamicForm, EducationWindows) {
        methodEducation = "POST";
        saveActionUrl = Url + "create/";
        EducationDynamicForm.clearValues();
        EducationWindows.setTitle(title);
        EducationWindows.show();
    }

    function edu_save_result(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            var responseID = JSON.parse(resp.data).id;
            var gridState = "[{id:" + responseID + "}]";
            var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",
                "<spring:message code="msg.command.done"/>");
            if (resp.context.actionURL.contains("major")) {
                edu_after_save(ListGrid_EducationMajor, Window_EducationMajor, gridState);
            } else if ((resp.context.actionURL).contains("level")) {
                edu_after_save(ListGrid_EducationLevel, Window_EducationLevel, gridState);
            } else if (resp.context.actionURL.contains("orientation")) {
                edu_after_save(ListGrid_EducationOrientation, Window_EducationOrientation, gridState);
            }
            setTimeout(function () {
                OK.close();
            }, 3000);
        } else {
            let respText = resp.httpResponseText;
            if (resp.httpResponseCode === 406 && respText === "DuplicateRecord") {
                createDialog("info", "<spring:message code="msg.record.duplicate"/>",
                    "<spring:message code="message"/>");
            } else if (resp.httpResponseCode === 406 && respText === "NotEditable") {
                createDialog("info", "<spring:message code='msg.education.orientation.edit.error'/>");
            } else {
                createDialog("info", "<spring:message code="msg.operation.error"/>",
                    "<spring:message code="message"/>");
            }
        }
    }

    function edu_delete_result(resp) {
        wait.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            EducationListGrid.invalidateCache();
            var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",
                "<spring:message code="msg.command.done"/>");
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