<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="Spring" uri="http://java.sun.com/jsp/jstl/fmt" %>

// <script>

    var method = "POST";
    var url;
    var wait_PostGradeGroup;
    var postGrade_PGG = null;
    var naJob_PGG = null;
    var personnelJob_PGG = null;
    var post_PGG = null;
    var postGradesSelection=false;
    let oLoadAttachments_PostGradeGroup = null;

    <%--if(Window_NeedsAssessment_Edit === undefined) {--%>
        <%--var Window_NeedsAssessment_Edit = isc.Window.create({--%>
            <%--title: "<spring:message code="needs.assessment"/>",--%>
            <%--placement: "fillScreen",--%>
            <%--minWidth: 1024,--%>
            <%--items: [isc.ViewLoader.create({autoDraw: true, viewURL: "web/edit-needs-assessment/"})],--%>
            <%--showUs(record, objectType) {--%>
                <%--loadEditNeedsAssessment(record, objectType);--%>
                <%--this.Super("show", arguments);--%>
            <%--}--%>
        <%--});--%>
    <%--}--%>

    //////////////////////////////////////////////////////////////////////////////////////////////

    var RestDataSource_PostGradeGroup_Jsp = isc.TrDS.create({
        fields: [
            {name: "id", title: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "<spring:message code='post.grade.group.titleFa'/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code='code'/>", filterOperator: "iContains"},
            {name: "titleEn", title: "<spring:message code='post.grade.group.titleEn'/>", filterOperator: "iContains"},
            {name: "description", title: "<spring:message code='description'/>", filterOperator: "iContains"},
            {name: "competenceCount", title: "تعداد شایستگی", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelCount", title: "تعداد پرسنل", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "lastModifiedDateNA", title: "<spring:message code="update.date"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "modifiedByNA", title: "<spring:message code="updated.by"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
        ],
        fetchDataURL: viewPostGradeGroupUrl + "/iscList"
    });

    var RestDataSource_Post_Grade_Group_PostGradeGroup_Jsp = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code"},
            {name: "titleFa"},
            {
                name: "enabled",
                title: "<spring:message code="active.status"/>",
                align: "center",
                filterOperator: "equals",
                autoFitWidth: true,
                autoFitWidthApproach: "both",
            },
        ],
        fetchDataURL: postGradeUrl + "/iscList"
    });
    var RestDataSource_All_PostGrades_PostGradeGroup_Jsp = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "titleFa"},
            {
                name: "enabled",
                title: "<spring:message code="active.status"/>",
                align: "center",
                filterOperator: "equals",
                autoFitWidth: true,
                autoFitWidthApproach: "both",
            },
        ],
        fetchDataURL: postGradeUrl + "/iscList"
    });
    var RestDataSource_ForThisPostGroup_GetPosts_PostGradeGroup_Jsp = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "titleFa"},
            {
                name: "enabled",
                title: "<spring:message code="active.status"/>",
                align: "center",
                filterOperator: "equals",
                autoFitWidth: true,
                autoFitWidthApproach: "both",
            },
        ]
    });

    ////////////////////////////////////////////////////////////////////////////////////////////////////////

    Menu_ListGrid_Post_Grade_Group_Jsp = isc.Menu.create({
        data: [
            {
                title: "<spring:message code='refresh'/>",
                click: function () {
                    ListGrid_Post_Grade_Group_refresh();
                }
            }, {
                title: "<spring:message code='create'/>",
                click: function () {
                    ListGrid_Post_Grade_Group_add();
                }
            }, {
                title: "<spring:message code='edit'/>",
                click: function () {
                    ListGrid_Post_Grade_Group_edit();
                }
            }, {
                title: "<spring:message code='remove'/>",
                click: function () {
                    ListGrid_Post_Grade_Group_remove();
                }
            },
            {
                isSeparator: true
            },
            {
                title: "<spring:message code="post.grade.list"/>",
                click: function () {
                    Add_Post_Grade_Group_AddPostGrade_Jsp();
                }
            }
        ]
    });

    var ListGrid_Post_Grade_Group_Jsp = isc.TrLG.create({
        selectionType: "single",
        autoFetchData: true,
        dataSource: RestDataSource_PostGradeGroup_Jsp,
        contextMenu: Menu_ListGrid_Post_Grade_Group_Jsp,
        canMultiSort: true,
        initialSort: [
            {property: "competenceCount", direction: "ascending"},
            {property: "id", direction: "descending"}
        ],
        getCellCSSText: function (record) {
            return setColorForListGrid(record)
        },
        selectionUpdated: function () {
            selectionUpdated_PostGrade();
        },
        doubleClick: function () {
            ListGrid_Post_Grade_Group_edit();
        }
    });

    defineWindowsEditNeedsAssessment(ListGrid_Post_Grade_Group_Jsp);
    defineWindowTreeNeedsAssessment();

    var DynamicForm_thisPostGradeGroupHeader_Jsp = isc.DynamicForm.create({
        titleWidth: "400",
        width: "700",
        align: "right",
        fields: [
            {
                name: "sgTitle",
                type: "staticText",
                title: "<spring:message code='post.grade.group.add.title'/>",
                wrapTitle: false,
                width: 250
            }
        ]
    });

    var ListGrid_AllPostGrades = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_All_PostGrades_PostGradeGroup_Jsp,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        autoFetchData: false,
        showRowNumbers: true,
        sortField: 1,
        sortDirection: "descending",
        fields: [
            {name: "code", title: "<spring:message code='post.grade.code'/>", filterOperator: "iContains", align: "center",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "titleFa", title: "<spring:message code='post.grade.title'/>", filterOperator: "iContains", align: "center"},
            {name: "enabled",
                valueMap:{
                    // undefined : "فعال",
                    74 : "غیر فعال"
                },filterOnKeypress: true,

            },
            {name: "OnAdd", title: " ", align: "center",canSort:false,canFilter:false},
        ],
        selectionAppearance: "checkbox",
        selectionType: "simple",
        dataArrived:function(startRow, endRow){
            let lgIds = ListGrid_ForThisPostGradeGroup_GetPostGrades_Jpa.data.getAllCachedRows().map(function(item) {
                return item.id;
            });

            let findRows=ListGrid_AllPostGrades.findAll({_constructor:"AdvancedCriteria",operator:"and",criteria:[{fieldName:"id",operator:"inSet",value:lgIds}]});
            ListGrid_AllPostGrades.setSelectedState(findRows);
            findRows.setProperty("enabled", false);
        },
        createRecordComponent: function (record, colNum) {
            var fieldName = this.getFieldName(colNum);
            if (fieldName == "OnAdd") {
                var recordCanvas = isc.HLayout.create({
                    height: "100%",
                    width: "100%",
                    layoutMargin: 5,
                    membersMargin: 10,
                    align: "center"
                });
                var addIcon = isc.ImgButton.create({
                    showDown: false,
                    showRollOver: false,
                    layoutAlign: "center",
                    src: "[SKIN]/actions/add.png",
                    prompt: "اضافه کردن",
                    height: 16,
                    width: 16,
                    grid: this,
                    click: function () {
                        let current = record;
                        let selected=ListGrid_ForThisPostGradeGroup_GetPostGrades_Jpa.data.getAllCachedRows().map(function(item) {return item.id;});

                        let ids = [];

                        if ($.inArray(current.id, selected) === -1){
                            ids.push(current.id);
                        }

                        if(ids.length!=0){
                            let findRows=ListGrid_AllPostGrades.findAll({_constructor:"AdvancedCriteria",operator:"and",criteria:[{fieldName:"id",operator:"equals",value:current.id}]});

                            let groupRecord = ListGrid_Post_Grade_Group_Jsp.getSelectedRecord();
                            let groupId = groupRecord.id;

                            let JSONObj = {"ids": ids};
                            wait.show();
                            isc.RPCManager.sendRequest(TrDSRequest(postGradeGroupUrl + "addPostGrades/" + groupId + "/" + ids,
                                    "POST", null, function (resp) {
                                    wait.close();
                                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                        ListGrid_AllPostGrades.selectRecord(findRows);
                                        findRows.setProperty("enabled", false);
                                        ListGrid_AllPostGrades.redraw();

                                        ListGrid_ForThisPostGradeGroup_GetPostGrades_Jpa.invalidateCache();
                                        ListGrid_ForThisPostGradeGroup_GetPostGrades_Jpa.fetchData();

                                    } else {
                                        createDialog("info", "<spring:message code="msg.operation.error"/>",
                                        "<spring:message code="message"/>");
                                    }
                                    }
                                )
                            );
                        }
                    }
                });
                recordCanvas.addMember(addIcon);
                return recordCanvas;
            } else
                return null;
        }
    });

    var ListGrid_ForThisPostGradeGroup_GetPostGrades_Jpa = isc.TrLG.create({
        width: "100%",
        height: "100%",
        canDragRecordsOut: true,
        canAcceptDroppedRecords: true,
        showRowNumbers: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        autoFetchData: false,
        dataSource: RestDataSource_ForThisPostGroup_GetPosts_PostGradeGroup_Jsp,
        selectionAppearance: "checkbox",
        selectionType: "simple",
        fields: [
            {name: "code", title: "<spring:message code='post.grade.code'/>", filterOperator: "iContains", align: "center",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "titleFa", title: "<spring:message code='post.grade.title'/>", filterOperator: "iContains", align: "center"},
            {name: "enabled",
                valueMap:{
                    // undefined : "فعال",
                    74 : "غیر فعال"
                },filterOnKeypress: true,

            },
            {name: "OnDelete", title: " ", align: "center", canFilter: false}
        ],
        dataArrived:function(){
            if(postGradesSelection) {
                ListGrid_AllPostGrades.invalidateCache();
                ListGrid_AllPostGrades.fetchData();
                postGradesSelection=false;
            }
        },
        createRecordComponent: function (record, colNum) {
            var fieldName = this.getFieldName(colNum);
            if (fieldName === "OnDelete") {
                var recordCanvas = isc.HLayout.create({
                    height: 20,
                    width: "100%",
                    layoutMargin: 5,
                    membersMargin: 10,
                    align: "center"
                });
                var removeIcon = isc.ImgButton.create({
                    showDown: false,
                    showRollOver: false,
                    layoutAlign: "center",
                    src: "[SKIN]/actions/remove.png",
                    height: 16,
                    width: 16,
                    grid: this,
                    click: function () {
                        let active = record;
                        let activeId = active.id;
                        let activeGroup = ListGrid_Post_Grade_Group_Jsp.getSelectedRecord();
                        let activeGroupId = activeGroup.id;
                        isc.RPCManager.sendRequest(TrDSRequest(postGradeGroupUrl + "removePostGrades/" + activeGroupId + "/" + [activeId],
                            "DELETE", null, function (resp) {
                                if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {

                                    ListGrid_ForThisPostGradeGroup_GetPostGrades_Jpa.invalidateCache();

                                    let findRows=ListGrid_AllPostGrades.findAll({_constructor:"AdvancedCriteria",operator:"and",criteria:[{fieldName:"id",operator:"inSet",value:[activeId]}]});

                                    if(typeof (findRows)!='undefined' && findRows.length>0){
                                        findRows.setProperty("enabled", true);
                                        ListGrid_AllPostGrades.deselectRecord(findRows[0]);
                                    }

                                } else {
                                    isc.say("خطا در پاسخ سرویس دهنده");
                                }
                            }));
                    }
                });
                recordCanvas.addMember(removeIcon);
                return recordCanvas;
            } else
                return null;
        }
    });

    var SectionStack_All_Posts_Jsp = isc.SectionStack.create({
        visibilityMode: "multiple",
        width: "50%",
        sections: [
            {
                title: "<spring:message code="post.grade.list"/>",
                expanded: true,
                canCollapse: false,
                align: "center",
                items: [
                    ListGrid_AllPostGrades,
                    isc.ToolStripButtonAdd.create({
                        width:"100%",
                        height:25,
                        title:"اضافه کردن گروهی",
                        click: function () {
                            let dialog = createDialog('ask', "<spring:message code="msg.record.adds.ask"/>");
                            dialog.addProperties({
                                buttonClick: function (button, index) {
                                    this.close();
                                    if (index == 0) {
                                        var ids = ListGrid_AllPostGrades.getSelection().filter(function(x){return x.enabled!=false}).map(function(item) {return item.id;});
                                        var activeGroup = ListGrid_Post_Grade_Group_Jsp.getSelectedRecord();
                                        var activeGroupId = activeGroup.id;
                                        let JSONObj = {"ids": ids};

                                        isc.RPCManager.sendRequest(TrDSRequest(postGradeGroupUrl + "addPostGrades/" + activeGroupId + "/" + ids,
                                            "POST", null, function (resp) {
                                                wait.close();
                                                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                                    ListGrid_ForThisPostGradeGroup_GetPostGrades_Jpa.invalidateCache();
                                                    ListGrid_ForThisPostGradeGroup_GetPostGrades_Jpa.fetchData();

                                                    let findRows=ListGrid_AllPostGrades.findAll({_constructor:"AdvancedCriteria",operator:"and",criteria:[{fieldName:"id",operator:"inSet",value:ids}]});

                                                    if(typeof (findRows)!='undefined' && findRows.length>0){
                                                        findRows.setProperty("enabled", false);
                                                        ListGrid_AllPostGrades.redraw();
                                                    }
                                                    isc.say("عملیات با موفقیت انجام شد.");



                                                } else {
                                                    createDialog("info", "<spring:message code="msg.operation.error"/>",
                                                        "<spring:message code="message"/>");
                                                }
                                            }
                                        ));
                                    }
                                }
                            })

                        }
                    })
                ]
            }
        ]
    });

    var SectionStack_Current_Post_Grade_Jsp = isc.SectionStack.create({
        visibilityMode: "multiple",
        width: "50%",
        sections: [
            {
                expanded: true,
                canCollapse: false,
                align: "center",
                items: [
                    ListGrid_ForThisPostGradeGroup_GetPostGrades_Jpa,
                    isc.ToolStripButtonRemove.create({
                        width:"100%",
                        height:25,
                        title:"حذف گروهی",
                        click: function () {
                            let dialog = createDialog('ask', "<spring:message code="msg.record.remove.ask"/>");
                            dialog.addProperties({
                                buttonClick: function (button, index) {
                                    this.close();
                                    if (index == 0) {
                                        var ids = ListGrid_ForThisPostGradeGroup_GetPostGrades_Jpa.getSelection().map(function(item) {return item.id;});
                                        var activeGroup = ListGrid_Post_Grade_Group_Jsp.getSelectedRecord();
                                        var activeGroupId = activeGroup.id;
                                        let JSONObj = {"ids": ids};


                                        isc.RPCManager.sendRequest(TrDSRequest(postGradeGroupUrl + "removePostGrades/" + activeGroupId + "/" + ids,
                                            "DELETE", null, function (resp) {

                                                wait.close();
                                                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                                    ListGrid_ForThisPostGradeGroup_GetPostGrades_Jpa.invalidateCache();
                                                    ListGrid_ForThisPostGradeGroup_GetPostGrades_Jpa.fetchData();

                                                    let findRows=ListGrid_AllPostGrades.findAll({_constructor:"AdvancedCriteria",operator:"and",criteria:[{fieldName:"id",operator:"inSet",value:ids}]});

                                                    if(typeof (findRows)!='undefined' && findRows.length>0){
                                                        findRows.setProperty("enabled", true);
                                                        ListGrid_AllPostGrades.deselectRecord(findRows);
                                                        ListGrid_AllPostGrades.redraw();
                                                    }
                                                    isc.say("عملیات با موفقیت انجام شد.");



                                                } else {
                                                    createDialog("info", "<spring:message code="msg.operation.error"/>",
                                                        "<spring:message code="message"/>");
                                                }
                                            }
                                        ));
                                    }
                                }
                            })

                        }
                    })
                ]
            }
        ]
    });

    var HStack_thisPostGradeGroup_AddPostGrade_Jsp = isc.HStack.create({
        membersMargin: 10,
        height: 500,
        members: [
            SectionStack_All_Posts_Jsp,
            SectionStack_Current_Post_Grade_Jsp
        ]
    });

    var HLayOut_thisPostGradeGroup_AddPostGrade_Jsp = isc.TrHLayout.create({
        height: "10%",
        border: "0px solid yellow",
        layoutMargin: 5,
        align: "center",

        members: [
            DynamicForm_thisPostGradeGroupHeader_Jsp
        ]
    });

    var VLayOut_PostGradeGroup_PostGrades_Jsp = isc.TrVLayout.create({
        border: "3px solid gray",
        layoutMargin: 5,
        members: [
            HLayOut_thisPostGradeGroup_AddPostGrade_Jsp,
            HStack_thisPostGradeGroup_AddPostGrade_Jsp
        ]
    });

    var Window_Add_PostGrade_to_PostGradeGroup_Jsp = isc.Window.create({
        title: "<spring:message code="post.grade.list"/>",
        width: "900",
        height: "400",
        align: "center",
        closeClick: function () {
            ListGrid_Grades_Post_Grade_Group_Jsp.invalidateCache();
            this.hide();
        },
        items: [
            VLayOut_PostGradeGroup_PostGrades_Jsp
        ]
    });

    let ToolStrip_Post_Grade_Group_Grades_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let criteria = ListGrid_Grades_Post_Grade_Group_Jsp.getCriteria();

                    if(typeof(criteria.operator)=='undefined'){
                        criteria._constructor="AdvancedCriteria";
                        criteria.operator="and";
                    }

                    if(typeof(criteria.criteria)=='undefined'){
                        criteria.criteria=[];
                    }
                    criteria.criteria.push({fieldName: "postGradeGroup", operator: "inSet", value: [ListGrid_Post_Grade_Group_Jsp.getSelectedRecord().id]});

                    ExportToFile.showDialog(null, ListGrid_Grades_Post_Grade_Group_Jsp , "Post_Grade_Without_Permission", 0, null, '',"لیست رده پستی - آموزش"  , criteria, null);
                }
            })
        ]
    });

    let ActionsTS_Post_Grade_Group_Grades = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStrip_Post_Grade_Group_Grades_Export2EXcel
        ]
    });

    var ListGrid_Grades_Post_Grade_Group_Jsp = isc.TrLG.create({
        dataSource: RestDataSource_Post_Grade_Group_PostGradeGroup_Jsp,
        autoFetchData: false,
        gridComponents: [ActionsTS_Post_Grade_Group_Grades, "header", "filterEditor", "body",],
        fields: [
            {
                name: "code",
                title: "<spring:message code='post.grade.code'/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {
                name: "titleFa",
                title: "<spring:message code='post.grade.title'/>",
                filterOperator: "iContains"
            },
            {name: "enabled",
                valueMap:{
                    // undefined : "فعال",
                    74 : "غیر فعال"
                },filterOnKeypress: true,
            },
        ]
    });

    var DynamicForm_Post_Grade_Group_Jsp = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        align: "center",
        canSubmit: true,
        showInlineErrors: true,
        showErrorText: false,
        titleAlign: "right",
        validateOnExit: true,
        numCols: 2,
        wrapTitle: false,
        colWidths: [140, "*"],
        margin: 10,
        padding: 5,
        fields: [
            {name: "id", hidden: true},
            {
                name: "titleFa",
                title: "<spring:message code='global.titleFa'/>",
                required: true,
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9 ]",
                validators: [TrValidators.NotEmpty, TrValidators.NotStartWithSpecialChar, TrValidators.NotStartWithNumber]
            },
            {
                name: "code",
                title: "<spring:message code='code'/>"
            },
            {
                name: "titleEn",
                title: "<spring:message code='global.titleEn'/>",
                keyPressFilter: "[a-z|A-Z|0-9 |]",
                validators: [TrValidators.NotEmpty, TrValidators.NotStartWithSpecialChar, TrValidators.NotStartWithNumber]
            },
            {
                name: "description",
                title: "<spring:message code='description'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9 ]",
                validators: [TrValidators.NotEmpty, TrValidators.NotStartWithSpecialChar, TrValidators.NotStartWithNumber]
            }
        ]
    });


    var IButton_Post_Grade_Group_Exit_Jsp = isc.IButtonCancel.create({
        click: function () {
            Window_Post_Grade_Group_Jsp.close();
        }
    });

    var IButton_Post_Grade_Group_Save_Jsp = isc.IButtonSave.create({
        click: function () {
            DynamicForm_Post_Grade_Group_Jsp.validate();
            if (DynamicForm_Post_Grade_Group_Jsp.hasErrors()) {
                return;
            }
            var data = DynamicForm_Post_Grade_Group_Jsp.getValues();
            isc.RPCManager.sendRequest(TrDSRequest(url, method, JSON.stringify(data),
                "callback: post_grade_group_save_result(rpcResponse)"));
        }
    });

    var HLayOut_Post_Grade_GroupSaveOrExit_Jsp = isc.TrHLayoutButtons.create({
        members: [IButton_Post_Grade_Group_Save_Jsp, IButton_Post_Grade_Group_Exit_Jsp]
    });

    var Window_Post_Grade_Group_Jsp = isc.Window.create({
        title: "<spring:message code='post.grade.group'/>",
        width: 700,
        align: "center",
        border: "1px solid gray",
        closeClick: function () {
            this.Super("closeClick", arguments);
        },
        items: [isc.TrVLayout.create({
            members: [DynamicForm_Post_Grade_Group_Jsp, HLayOut_Post_Grade_GroupSaveOrExit_Jsp]
        })]
    });

    ToolStripButton_EditNA_PGG = isc.ToolStripButton.create({
        title: "ویرایش نیازسنجی",
        click: function () {
            if (ListGrid_Post_Grade_Group_Jsp.getSelectedRecord() == null){
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                return;
            }
            Window_NeedsAssessment_Edit.showUs(ListGrid_Post_Grade_Group_Jsp.getSelectedRecord(), "PostGradeGroup");
        }
    });

    ToolStripButton_TreeNA_PGG = isc.ToolStripButton.create({
        title: "درخت نیازسنجی",
        click: function () {
            if (ListGrid_Post_Grade_Group_Jsp.getSelectedRecord() == null){
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                return;
            }
            Window_NeedsAssessment_Tree.showUs(ListGrid_Post_Grade_Group_Jsp.getSelectedRecord(), "PostGradeGroup");
        }
    });

    ToolStrip_NA_PGG = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [ToolStripButton_EditNA_PGG, ToolStripButton_TreeNA_PGG]
    });

    var ToolStripButton_Refresh_Post_Grade_Group_Jsp = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_Post_Grade_Group_refresh();
        }
    });
    var ToolStripButton_Edit_Post_Grade_Group_Jsp = isc.ToolStripButtonEdit.create({
        click: function () {
            ListGrid_Post_Grade_Group_edit();
        }
    });
    var ToolStripButton_Add_Post_Grade_Group_Jsp = isc.ToolStripButtonCreate.create({
        click: function () {
            ListGrid_Post_Grade_Group_add();
        }
    });
    var ToolStripButton_Remove_Post_Grade_Group_Jsp = isc.ToolStripButtonRemove.create({
        click: function () {
            ListGrid_Post_Grade_Group_remove();
        }
    });

    var ToolStripButton_Add_Post_Grade_Group_AddPostGrade_Jsp = isc.ToolStripButton.create({
        <%--icon: "<spring:url value="post.png"/>",--%>
        title: "<spring:message code="post.grade.list"/>",
        click: function () {
            Add_Post_Grade_Group_AddPostGrade_Jsp();
        }
    });

    let ToolStrip_Post_Grade_Group_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let criteria = ListGrid_Post_Grade_Group_Jsp.getCriteria();
                    ExportToFile.showDialog(null, ListGrid_Post_Grade_Group_Jsp , "View_Post_Grade_Group", 0, null, '',"لیست پست ها- آموزش"  , criteria, null);
                }
            })
        ]
    });

    /////////////////////////////////////////////////////////////////////////////////////////////

    var ToolStrip_Actions_Post_Grade_Group_Jsp = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            ToolStripButton_Add_Post_Grade_Group_Jsp,
            ToolStripButton_Edit_Post_Grade_Group_Jsp,
            ToolStripButton_Remove_Post_Grade_Group_Jsp,
            ToolStripButton_Add_Post_Grade_Group_AddPostGrade_Jsp,
            ToolStrip_Post_Grade_Group_Export2EXcel,
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_Refresh_Post_Grade_Group_Jsp,
                ]
            }),

        ]
    });

    var HLayout_Actions_Post_Grade_Group_Jsp = isc.VLayout.create({
        width: "100%",
        members: [ToolStrip_Actions_Post_Grade_Group_Jsp, ToolStrip_NA_PGG]
    });

    ////////////////////////////////////////////////////////////personnel///////////////////////////////////////////////
    PersonnelDS_PGG = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true,
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "companyName", title: "<spring:message code="company.name"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true,
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains", autoFitWidth: true,
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "postTitle", title: "<spring:message code="post"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "jobTitle", title: "<spring:message code="job"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "postGradeTitle", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "postCode", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpArea", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpAssistant", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpAffairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpSection", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpUnit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: personnelUrl + "/iscList",
    });

    let ToolStrip_Post_Grade_Group_Personnel_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let criteria = PersonnelLG_PGG.getCriteria();

                    if(typeof(criteria.operator)=='undefined'){
                        criteria._constructor="AdvancedCriteria";
                        criteria.operator="and";
                    }

                    if(typeof(criteria.criteria)=='undefined'){
                        criteria.criteria=[];
                    }
                    criteria.criteria.push({fieldName: "PostGradeGroupId", operator: "equals", value:ListGrid_Post_Grade_Group_Jsp.getSelectedRecord().id});

                    ExportToFile.showDialog(null, PersonnelLG_PGG , "Post_Grade_Group_Personnel", 0, null, '',"لیست پرسنل - آموزش"  , criteria, null);
                }
            })
        ]
    });

    let ActionsTS_Personnel_Post_Grade_Group = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStrip_Post_Grade_Group_Personnel_Export2EXcel
        ]
    });

    PersonnelLG_PGG = isc.TrLG.create({
        dataSource: PersonnelDS_PGG,
        selectionType: "single",
        alternateRecordStyles: true,
        // groupByField: "postGradeTitle",
        gridComponents: [ActionsTS_Personnel_Post_Grade_Group, "header", "filterEditor", "body",],
        fields: [
            {name: "firstName"},
            {name: "lastName"},
            {name: "nationalCode",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "companyName"},
            {name: "personnelNo",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "personnelNo2",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "postCode"},
            {name: "postTitle"},
            {name: "jobTitle"},
            {name: "postGradeTitle"},
            {name: "ccpArea"},
            {name: "ccpAssistant"},
            {name: "ccpAffairs"},
            {name: "ccpSection"},
            {name: "ccpUnit"},
        ]
    });

    ///////////////////////////////////////////////////////////needs assessment/////////////////////////////////////////
    PriorityDS_PGG = isc.TrDS.create({
        fields:
            [
                {name: "id", primaryKey: true, hidden: true},
                {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
                {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
            ],
        autoFetchData: false,
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/NeedsAssessmentPriority"
    });

    DomainDS_PGG = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/NeedsAssessmentDomain"
    });

    CompetenceTypeDS_PGG = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/competenceType"
    });

    NADS_PGG = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "needsAssessmentPriorityId", title: "<spring:message code='priority'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "needsAssessmentDomainId", title: "<spring:message code='domain'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "competence.title", title: "<spring:message code="competence"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "competence.competenceTypeId", title: "<spring:message code="competence.type"/>", filterOperator: "equals", autoFitWidth: true},
            {name: "skill.code", title: "<spring:message code="skill.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "skill.titleFa", title: "<spring:message code="skill"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "skill.course.theoryDuration", title: "<spring:message code="duration"/>", filterOperator: "equals", autoFitWidth: true},
            {name: "skill.course.scoresState", title: "<spring:message code='status'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "skill.course.code", title: "<spring:message code="course.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "skill.course.titleFa", title: "<spring:message code="course"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: null
    });

    let ToolStrip_Post_Grade_Group_NA_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let criteria = NALG_PGG.getCriteria();

                    if(typeof(criteria.operator)=='undefined'){
                        criteria._constructor="AdvancedCriteria";
                        criteria.operator="and";
                    }

                    if(typeof(criteria.criteria)=='undefined'){
                        criteria.criteria=[];
                    }
                    criteria.criteria.push({fieldName: "objectId", operator: "equals", value: ListGrid_Post_Grade_Group_Jsp.getSelectedRecord().id});
                    criteria.criteria.push({fieldName: "objectType", operator: "equals", value: "PostGradeGroup"});
                    // criteria.criteria.push({fieldName: "personnelNo", operator: "equals", value: null});

                    ExportToFile.showDialog(null, NALG_PGG , "NeedsAssessmentReport", 0, null, '',"لیست نیازسنجی - آموزش"  , criteria, null);
                }
            })
        ]
    });

    let ActionsTS_NA_Post_Grade_Group = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStrip_Post_Grade_Group_NA_Export2EXcel
        ]
    });

    NALG_PGG = isc.TrLG.create({
        dataSource: NADS_PGG,
        selectionType: "none",
        autoFetchData: false,
        alternateRecordStyles: true,
        showAllRecords: true,
        gridComponents: [
            ActionsTS_NA_Post_Grade_Group,
            "header", "filterEditor", "body",],
        fields: [
            {name: "competence.title"},
            {
                name: "competence.competenceTypeId",
                type: "SelectItem",
                filterOnKeypress: true,
                displayField: "title",
                valueField: "id",
                optionDataSource: CompetenceTypeDS_PGG,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [
                    {name: "title", width: "30%"}
                ],
            },
            {
                name: "needsAssessmentPriorityId",
                filterOnKeypress: true,
                editorType: "SelectItem",
                displayField: "title",
                valueField: "id",
                optionDataSource: PriorityDS_PGG,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [
                    {name: "title", width: "30%"}
                ],
            },
            {
                name: "needsAssessmentDomainId",
                filterOnKeypress: true,
                editorType: "SelectItem",
                displayField: "title",
                valueField: "id",
                optionDataSource: DomainDS_PGG,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [
                    {name: "title", width: "30%"}
                ],
            },
            {name: "skill.code"},
            {name: "skill.titleFa"},
            {name: "skill.course.code"},
            {name: "skill.course.titleFa"}
        ],
    });

    //////////////////////////////////////////////////////////posts/////////////////////////////////////////////////////
    PostDS_PGG = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "peopleType", title: "<spring:message code="people.type"/>", filterOperator: "equals", autoFitWidth: true, valueMap:peopleTypeMap, filterOnKeypress: true},
            {
                name: "code",
                title: "<spring:message code="post.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "titleFa",
                title: "<spring:message code="post.title"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "jobTitleFa",
                title: "<spring:message code="job.title"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "postGradeTitleFa",
                title: "<spring:message code="post.grade.title"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {name: "area", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},
            {
                name: "assistance",
                title: "<spring:message code="assistance"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "affairs",
                title: "<spring:message code="affairs"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "section",
                title: "<spring:message code="section"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
            {
                name: "costCenterCode",
                title: "<spring:message code="reward.cost.center.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "costCenterTitleFa",
                title: "<spring:message code="reward.cost.center.title"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "competenceCount",
                title: "تعداد شایستگی",
                align: "center",
                filterOperator: "equals",
                autoFitWidth: true,
                autoFitWidthApproach: "both"
            },
            {
                name: "personnelCount",
                title: "تعداد پرسنل",
                align: "center",
                filterOperator: "equals",
                autoFitWidth: true,
                autoFitWidthApproach: "both"
            },
            {
                name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both",
                valueMap:{
                    // undefined : "فعال",
                    74 : "غیر فعال"
                },filterOnKeypress: true,
            }
        ],
        fetchDataURL: viewTrainingPostUrl + "/spec-list"
    });

    let ToolStrip_Post_Grade_Group_Post_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let criteria = PostLG_PGG.getCriteria();

                    if(typeof(criteria.operator)=='undefined'){
                        criteria._constructor="AdvancedCriteria";
                        criteria.operator="and";
                    }

                    if(typeof(criteria.criteria)=='undefined'){
                        criteria.criteria=[];
                    }
                    criteria.criteria.push({fieldName: "PostGradeGroup", operator: "equals", value: ListGrid_Post_Grade_Group_Jsp.getSelectedRecord().id});

                    ExportToFile.showDialog(null, PostLG_PGG , "Post_Grade_Group_Post", 0, null, '',"لیست پست ها - آموزش"  , criteria, null);
                }
            })
        ]
    });

    let ActionsTS_Post_Post_Grade_Group = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStrip_Post_Grade_Group_Post_Export2EXcel
        ]
    });

    PostLG_PGG = isc.TrLG.create({
        dataSource: PostDS_PGG,
        autoFetchData: false,
        sortField: "id",
        // groupByField: "postGrade.titleFa",
        gridComponents: [ActionsTS_Post_Post_Grade_Group, "header", "filterEditor", "body",],
    });

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    var Detail_Tab_Post_Grade_Group = isc.TabSet.create({
        tabBarPosition: "top",
        tabs: [
            {name: "TabPane_Post_Grade_PGG", title: "<spring:message code='post.grade.list'/>", pane: ListGrid_Grades_Post_Grade_Group_Jsp},
            {name: "TabPane_Post_PGG", title: "لیست پست ها", pane: PostLG_PGG},
            {name: "TabPane_Personnel_PGG", title: "لیست پرسنل", pane: PersonnelLG_PGG},
            {name: "TabPane_NA_PGG", title: "<spring:message code='need.assessment'/>", pane: NALG_PGG},
            {
                ID: "PostGradeGroup_AttachmentsTab",
                title: "<spring:message code="attachments"/>",
                // pane: isc.ViewLoader.create({autoDraw: true, viewURL: "tclass/attachments-tab"})
            },
        ],
        tabSelected: function (){
            selectionUpdated_PostGrade();
        }
    });

    var HLayout_Tab_Post_Grade_Group = isc.TrHLayout.create({
        members: [Detail_Tab_Post_Grade_Group]
    });

    var HLayout_Grid_Post_Grade_Group_Jsp = isc.TrHLayout.create({
        showResizeBar:true,
        members: [ListGrid_Post_Grade_Group_Jsp]
    });

    var VLayout_Body_Post_Grade_Group_Jsp = isc.TrVLayout.create({
        members: [
            HLayout_Actions_Post_Grade_Group_Jsp,
            HLayout_Grid_Post_Grade_Group_Jsp,
            HLayout_Tab_Post_Grade_Group
        ]

    });


    ///////////////////////////////////////////////functions/////////////////////////////////////////////////////

    function deletePostFromPostGroup(postId, postGroupId) {
        isc.RPCManager.sendRequest(TrDSRequest(postGroupUrl + "/removePost/" + postGroupId + "/" + postId,
            "DELETE", null, "callback: delete_post_grade_result(rpcResponse)"));
    }

    function delete_post_grade_result(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            ListGrid_Grades_Post_Grade_Group_Jsp.invalidateCache();

        } else {
            let respText = resp.httpResponseText;
            if (resp.httpResponseCode === 406 && respText === "NotDeletable") {
                createDialog("info", "<spring:message code='msg.record.cannot.deleted'/>");
            } else {
                createDialog("info", "<spring:message code="msg.operation.error"/>");
            }
        }
    }

    function post_grade_group_save_result(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            var responseID = JSON.parse(resp.data).id;
            var gridState = "[{id:" + responseID + "}]";
            var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",
                "<spring:message code="msg.command.done"/>");
            setTimeout(function () {
                OK.close();
            }, 2000);
            ListGrid_Post_Grade_Group_refresh();
            setTimeout(function () {
                ListGrid_Post_Grade_Group_Jsp.setSelectedState(gridState);
            }, 1000);
            Window_Post_Grade_Group_Jsp.close();
        } else {
            let respText = resp.httpResponseText;
            if (resp.httpResponseCode === 406 && respText === "DuplicateRecord") {
                createDialog("info", "<spring:message code="msg.record.duplicate"/>",
                    "<spring:message code="message"/>");
            } else {
                createDialog("info", "<spring:message code="msg.operation.error"/>",
                    "<spring:message code="message"/>");
            }
        }
    }

    function Add_Post_Grade_Group_AddPostGrade_Jsp() {
        var record = ListGrid_Post_Grade_Group_Jsp.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            postGradesSelection=true;
            RestDataSource_ForThisPostGroup_GetPosts_PostGradeGroup_Jsp.fetchDataURL = postGradeGroupUrl + record.id + "/getPostGrades";
            ListGrid_ForThisPostGradeGroup_GetPostGrades_Jpa.invalidateCache();
            ListGrid_ForThisPostGradeGroup_GetPostGrades_Jpa.fetchData();
            DynamicForm_thisPostGradeGroupHeader_Jsp.setValue("sgTitle", getFormulaMessage(record.titleFa, "2", "red", "B"));
            SectionStack_Current_Post_Grade_Jsp.setSectionTitle(0,"<spring:message code='post.grade.group'/>" + " " +
                getFormulaMessage(record.titleFa, "2", "red", "B"));
            Window_Add_PostGrade_to_PostGradeGroup_Jsp.show();
        }
    }

    function ListGrid_Post_Grade_Group_edit() {
        var record = ListGrid_Post_Grade_Group_Jsp.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            DynamicForm_Post_Grade_Group_Jsp.clearValues();
            method = "PUT";
            url = postGradeGroupUrl + record.id;
            DynamicForm_Post_Grade_Group_Jsp.editRecord(record);
            Window_Post_Grade_Group_Jsp.show();
        }
    }

    function ListGrid_Post_Grade_Group_remove() {
        var record = ListGrid_Post_Grade_Group_Jsp.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            var Dialog_Post_Grade_Group_remove = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                "<spring:message code='global.warning'/>");
            Dialog_Post_Grade_Group_remove.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        wait_PostGradeGroup = createDialog("wait");
                        isc.RPCManager.sendRequest(TrDSRequest(postGradeGroupUrl + record.id, "DELETE", null,
                            "callback: Post_Grade_Group_remove_result(rpcResponse)"));
                    }
                }
            });
        }
    }

    function Post_Grade_Group_remove_result(resp) {
        wait_PostGradeGroup.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            ListGrid_Post_Grade_Group_Jsp.invalidateCache();
            var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",
                "<spring:message code="msg.command.done"/>");
            ListGrid_Grades_Post_Grade_Group_Jsp.setData([]);
            setTimeout(function () {
                OK.close();
            }, 2000);
        } else {
            let respText = resp.httpResponseText;
            if (resp.httpResponseCode === 406 && respText === "NotDeletable") {
                createDialog("info", "<spring:message code='msg.record.cannot.deleted'/>");
            } else {
                createDialog("info", "<spring:message code="msg.operation.error"/>");
            }
        }
    }

    function ListGrid_Post_Grade_Group_refresh() {
        objectIdAttachment=null
        refreshLG(ListGrid_Post_Grade_Group_Jsp);
        ListGrid_Grades_Post_Grade_Group_Jsp.setData([]);
        PostLG_PGG.setData([]);
        PersonnelLG_PGG.setData([]);
        NALG_PGG.setData([]);
        postGrade_PGG = null;
        naJob_PGG = null;
        personnelJob_PGG = null;
        post_PGG = null;
        oLoadAttachments_PostGradeGroup.ListGrid_JspAttachment.setData([]);
    }

    function ListGrid_Post_Grade_Group_add() {
        method = "POST";
        url = postGradeGroupUrl;
        DynamicForm_Post_Grade_Group_Jsp.clearValues();
        Window_Post_Grade_Group_Jsp.show();
    }

    function ListGrid_Post_Grade_Group_Posts_refresh() {
        if (ListGrid_Post_Grade_Group_Jsp.getSelectedRecord() == null)
            ListGrid_Grades_Post_Grade_Group_Jsp.setData([]);
        else {
            ListGrid_Grades_Post_Grade_Group_Jsp.invalidateCache();
            ListGrid_Grades_Post_Grade_Group_Jsp.filterByEditor();
        }
    }

    function selectionUpdated_PostGrade(){
        let postGradeGroup = ListGrid_Post_Grade_Group_Jsp.getSelectedRecord();
        let tab = Detail_Tab_Post_Grade_Group.getSelectedTab();
        if (postGradeGroup == null && tab.pane != null){
            tab.pane.setData([]);
            return;
        }

        switch (tab.name || tab.ID) {
            case "TabPane_Post_Grade_PGG":{
                if (postGrade_PGG === postGradeGroup.id)
                    return;
                postGrade_PGG = postGradeGroup.id;
                ListGrid_Grades_Post_Grade_Group_Jsp.setImplicitCriteria({
                    _constructor: "AdvancedCriteria",
                    operator: "and",
                    criteria: [{fieldName: "postGradeGroup", operator: "equals", value: postGradeGroup.id}]
                });
                ListGrid_Grades_Post_Grade_Group_Jsp.invalidateCache();
                ListGrid_Grades_Post_Grade_Group_Jsp.fetchData();
                break;
            }
            case "TabPane_Post_PGG":{
                if (post_PGG === postGradeGroup.id)
                    return;
                post_PGG = postGradeGroup.id;
                PostLG_PGG.setImplicitCriteria({
                    _constructor: "AdvancedCriteria",
                    operator: "and",
                    criteria: [{fieldName: "postGGI", operator: "equals", value: postGradeGroup.id}]
                });
                PostLG_PGG.invalidateCache();
                PostLG_PGG.fetchData();
                break;
            }
            case "TabPane_Personnel_PGG":{
                if (personnelJob_PGG === postGradeGroup.id)
                    return;
                personnelJob_PGG = postGradeGroup.id;
                PersonnelDS_PGG.fetchDataURL = postGradeGroupUrl + "personnelIscList/" + postGradeGroup.id;
                PersonnelLG_PGG.invalidateCache();
                PersonnelLG_PGG.fetchData();
                break;
            }
            case "TabPane_NA_PGG":{
                if (naJob_PGG === postGradeGroup.id)
                    return;
                naJob_PGG = postGradeGroup.id;
                NADS_PGG.fetchDataURL = needsAssessmentReportsUrl + "?objectId=" + postGradeGroup.id + "&objectType=PostGradeGroup";
                NADS_PGG.invalidateCache();
                NADS_PGG.fetchData();
                NALG_PGG.invalidateCache();
                NALG_PGG.fetchData();
                break;
            }
            case "PostGradeGroup_AttachmentsTab": {

                if (typeof oLoadAttachments_PostGradeGroup.loadPage_attachment_Job!== "undefined")
                    oLoadAttachments_PostGradeGroup.loadPage_attachment_Job("PostGradeGroup", postGradeGroup.id, "<spring:message code="attachment"/>", {
                        1: "جزوه",
                        2: "لیست نمرات",
                        3: "لیست حضور و غیاب",
                        4: "نامه غیبت موجه"
                    }, false);
                break;
            }
        }
    }

    if (!loadjs.isDefined('load_Attachments_postGradeGroup')) {
        loadjs('<spring:url value='tclass/attachments-tab' />', 'load_Attachments_postGradeGroup');
    }

    loadjs.ready('load_Attachments_postGradeGroup', function () {
        setTimeout(()=> {
            oLoadAttachments_PostGradeGroup = new loadAttachments();
            Detail_Tab_Post_Grade_Group.updateTab(PostGradeGroup_AttachmentsTab, oLoadAttachments_PostGradeGroup.VLayout_Body_JspAttachment)
        },0);

    });
    ////////////////////////////////////////////////////////////////////////////////////////////////////

    // </script>