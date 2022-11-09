<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="Spring" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>


// <script>

    let method = "POST";
    let url;
    let wait_groupOfPersonnelGroup;
    let personnel_Group_Id = null;
    let personnelGroupSelection=false;



    let RestDataSource_GroupForGap_Jsp = isc.TrDS.create({
        fields: [
            {name: "id", title: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "عنوان تیم", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code='code'/>", filterOperator: "iContains"},
            {name: "description", title: "<spring:message code='description'/>", filterOperator: "iContains"},
            {name: "competenceCount", title: "تعداد شایستگی", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelCount", title: "تعداد پرسنل", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "lastModifiedDateNA", title: "<spring:message code="update.date"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "modifiedByNA", title: "<spring:message code="updated.by"/>", align: "center", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
        ],
        implicitCriteria: {
            _constructor:"AdvancedCriteria",
            operator:"or",
            criteria: [{fieldName: "code", operator: "notEqual", value: "organizationCompetence"}]
        },
        // transformRequest: function (dsRequest) {
        //     transformCriteriaForLastModifiedDateNA(dsRequest);
        //     return this.Super("transformRequest", arguments);
        // },
        fetchDataURL: groupOfPersonnelUrl + "iscList"
    });

    let RestDataSource_PersonnelForGroup_Jsp = isc.TrDS.create({
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
            {name: "peopleType", title: "<spring:message code="people.type"/>", filterOperator: "equals", autoFitWidth: true, valueMap:{"Personal" : "شرکتی", "ContractorPersonal" : "پیمان کار",}, filterOnKeypress: true},
        ],
        fetchDataURL: postGradeUrl + "/iscList"
    });
    let RestDataSource_All_Personnel_forGap_Jsp = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "lastName"},
            {name: "firstName"},
            {name: "nationalCode"},
            {name: "personnelNo"},
            {name: "personnelNo2"},
        ],
        fetchDataURL: viewActivePersonnelUrl + "/iscList"
    });
    let RestDataSource_ForThisPersonnel_to_Group_Jsp = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "lastName"},
            {name: "firstName"},
            {name: "nationalCode"},
            {name: "personnelNo"},
            {name: "personnelNo2"},
        ]
    });

    ////////////////////////////////////////////////////////////////////////////////////////////////////////



    let ListGrid_GroupForGap_Jsp = isc.TrLG.create({
        selectionType: "single",
        autoFetchData: true,
        <sec:authorize access="hasAuthority('PostGradeGroup_R')">
        dataSource: RestDataSource_GroupForGap_Jsp,
        </sec:authorize>
        // contextMenu: Menu_ListGrid_Post_Grade_Group_Jsp,
        canMultiSort: true,
        initialSort: [
            // {property: "competenceCount", direction: "ascending"},
            {property: "id", direction: "descending"}
        ],
        // getCellCSSText: function (record) {
        //     return setColorForListGrid(record)
        // },
        selectionUpdated: function () {
            selectionUpdated_GroupOfPersonnel();
        },
        doubleClick: function () {
            ListGrid_GroupForGap_edit();
        }
    });

    <%--defineWindowsEditNeedsAssessment(ListGrid_GroupForGap_Jsp);--%>
    defineWindowsEditNeedsAssessmentForGap(ListGrid_GroupForGap_Jsp);
    <%--defineWindow_NeedsAssessment_all_competence_gap(ListGrid_GroupForGap_Jsp);--%>
    <%--defineWindowTreeNeedsAssessment();--%>

    let DynamicForm_thisGroupPersonnelHeader_Jsp = isc.DynamicForm.create({
        titleWidth: "400",
        width: "700",
        align: "right",
        fields: [
            {
                name: "sgTitle",
                type: "staticText",
                title: "افزودن پرسنل به تیم / گروه",
                wrapTitle: false,
                width: 250
            }
        ]
    });

    let ListGrid_AllPersonnelForGroup = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_All_Personnel_forGap_Jsp,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        autoFetchData: false,
        showRowNumbers: true,
        sortField: 1,
        sortDirection: "descending",
        fields: [
            {name: "firstName", title: "نام ", filterOperator: "iContains", align: "center"},
            {name: "lastName", title: "نام خانوادگی", filterOperator: "iContains", align: "center"},
            {name: "nationalCode", title: "کد ملی", filterOperator: "iContains", align: "center"},
            {name: "personnelNo", title: "کد پرسنلی 6 رقمی", filterOperator: "iContains", align: "center"},
            {name: "personnelNo2", title: "کد پرسنلی 10 رقمی", filterOperator: "iContains", align: "center"},
        ],
        selectionAppearance: "checkbox",
        selectionType: "simple",
        dataArrived:function(startRow, endRow){
            let lgIds = ListGrid_ForThisGroup_GetPersonnel_Jpa.data.getAllCachedRows().map(function(item) {
                return item.id;
            });

            let findRows=ListGrid_AllPersonnelForGroup.findAll({_constructor:"AdvancedCriteria",operator:"and",criteria:[{fieldName:"id",operator:"inSet",value:lgIds}]});
            ListGrid_AllPersonnelForGroup.setSelectedState(findRows);
            findRows.setProperty("enabled", false);
        },
        createRecordComponent: function (record, colNum) {
            let fieldName = this.getFieldName(colNum);
            if (fieldName == "OnAdd") {
                let recordCanvas = isc.HLayout.create({
                    height: "100%",
                    width: "100%",
                    layoutMargin: 5,
                    membersMargin: 10,
                    align: "center"
                });
                let addIcon = isc.ImgButton.create({
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
                        let selected=ListGrid_ForThisGroup_GetPersonnel_Jpa.data.getAllCachedRows().map(function(item) {return item.id;});

                        let ids = [];

                        if ($.inArray(current.id, selected) === -1){
                            ids.push(current.id);
                        }

                        if(ids.length!=0){
                            let findRows=ListGrid_AllPersonnelForGroup.findAll({_constructor:"AdvancedCriteria",operator:"and",criteria:[{fieldName:"id",operator:"equals",value:current.id}]});

                            let groupRecord = ListGrid_GroupForGap_Jsp.getSelectedRecord();
                            let groupId = groupRecord.id;

                            let JSONObj = {"ids": ids};
                            wait.show();
                            isc.RPCManager.sendRequest(TrDSRequest(groupOfPersonnelUrl + "addPersonnel/" + groupId + "/" + ids,

                                    "POST", null, function (resp) {
                                    wait.close();
                                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                        ListGrid_AllPersonnelForGroup.selectRecord(findRows);
                                        findRows.setProperty("enabled", false);
                                        ListGrid_AllPersonnelForGroup.redraw();

                                        ListGrid_ForThisGroup_GetPersonnel_Jpa.invalidateCache();
                                        ListGrid_ForThisGroup_GetPersonnel_Jpa.fetchData();

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

    let ListGrid_ForThisGroup_GetPersonnel_Jpa = isc.TrLG.create({
        width: "100%",
        height: "100%",
        canDragRecordsOut: true,
        canAcceptDroppedRecords: true,
        showRowNumbers: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        autoFetchData: false,
        dataSource: RestDataSource_ForThisPersonnel_to_Group_Jsp,
        selectionAppearance: "checkbox",
        selectionType: "simple",
        fields: [
            {name: "firstName", title: "نام ", filterOperator: "iContains", align: "center"},
            {name: "lastName", title: "نام خانوادگی", filterOperator: "iContains", align: "center"},
            {name: "nationalCode", title: "کد ملی", filterOperator: "iContains", align: "center"},
            {name: "personnelNo", title: "کد پرسنلی 6 رقمی", filterOperator: "iContains", align: "center"},
            {name: "personnelNo2", title: "کد پرسنلی 10 رقمی", filterOperator: "iContains", align: "center"},
         ],
        dataArrived:function(){
            if(personnelGroupSelection) {
                ListGrid_AllPersonnelForGroup.invalidateCache();
                ListGrid_AllPersonnelForGroup.fetchData();
                personnelGroupSelection=false;
            }
        },
        // createRecordComponent: function (record, colNum) {
        //     let fieldName = this.getFieldName(colNum);
        //     if (fieldName === "OnDelete") {
        //         let recordCanvas = isc.HLayout.create({
        //             height: 20,
        //             width: "100%",
        //             layoutMargin: 5,
        //             membersMargin: 10,
        //             align: "center"
        //         });
        //         let removeIcon = isc.ImgButton.create({
        //             showDown: false,
        //             showRollOver: false,
        //             layoutAlign: "center",
        //             src: "[SKIN]/actions/remove.png",
        //             height: 16,
        //             width: 16,
        //             grid: this,
        //             click: function () {
        //                 let active = record;
        //                 let activeId = active.id;
        //                 let activeGroup = ListGrid_GroupForGap_Jsp.getSelectedRecord();
        //                 let activeGroupId = activeGroup.id;
        //                 isc.RPCManager.sendRequest(TrDSRequest(postGradeGroupUrl + "removePostGrades/" + activeGroupId + "/" + [activeId],
        //                     "DELETE", null, function (resp) {
        //                         if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
        //
        //                             ListGrid_ForThisGroup_GetPersonnel_Jpa.invalidateCache();
        //
        //                             let findRows=ListGrid_AllPersonnelForGroup.findAll({_constructor:"AdvancedCriteria",operator:"and",criteria:[{fieldName:"id",operator:"inSet",value:[activeId]}]});
        //
        //                             if(typeof (findRows)!='undefined' && findRows.length>0){
        //                                 findRows.setProperty("enabled", true);
        //                                 ListGrid_AllPersonnelForGroup.deselectRecord(findRows[0]);
        //                             }
        //
        //                         } else {
        //                             isc.say("خطا در پاسخ سرویس دهنده");
        //                         }
        //                     }));
        //             }
        //         });
        //         recordCanvas.addMember(removeIcon);
        //         return recordCanvas;
        //     } else
        //         return null;
        // }
    });
    let ListGrid_ForThisGroup_GetPersonnel_Jpa_inMain = isc.TrLG.create({
        width: "100%",
        height: "100%",
        canDragRecordsOut: true,
        canAcceptDroppedRecords: true,
        showRowNumbers: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        autoFetchData: false,
        dataSource: RestDataSource_ForThisPersonnel_to_Group_Jsp,
        selectionType: "simple",
        fields: [
            {name: "firstName", title: "نام ", filterOperator: "iContains", align: "center"},
            {name: "lastName", title: "نام خانوادگی", filterOperator: "iContains", align: "center"},
            {name: "nationalCode", title: "کد ملی", filterOperator: "iContains", align: "center"},
            {name: "personnelNo", title: "کد پرسنلی 6 رقمی", filterOperator: "iContains", align: "center"},
            {name: "personnelNo2", title: "کد پرسنلی 10 رقمی", filterOperator: "iContains", align: "center"},
         ],
    });

    let SectionStack_All_PersonnelInGap_Jsp = isc.SectionStack.create({
        visibilityMode: "multiple",
        width: "50%",
        sections: [
            {
                title: "لیست کل پرسنل",
                expanded: true,
                canCollapse: false,
                align: "center",
                items: [
                    ListGrid_AllPersonnelForGroup,
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
                                        let ids = ListGrid_AllPersonnelForGroup.getSelection().filter(function(x){return x.enabled!=false}).map(function(item) {return item.id;});
                                        let activeGroup = ListGrid_GroupForGap_Jsp.getSelectedRecord();
                                        let activeGroupId = activeGroup.id;
                                        let JSONObj = {"ids": ids};

                                        isc.RPCManager.sendRequest(TrDSRequest(groupOfPersonnelUrl + "addPersonnel/" + activeGroupId + "/" + ids,
                                            "POST", null, function (resp) {
                                                wait.close();
                                                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                                    ListGrid_ForThisGroup_GetPersonnel_Jpa.invalidateCache();
                                                    ListGrid_ForThisGroup_GetPersonnel_Jpa.fetchData();

                                                    let findRows=ListGrid_AllPersonnelForGroup.findAll({_constructor:"AdvancedCriteria",operator:"and",criteria:[{fieldName:"id",operator:"inSet",value:ids}]});

                                                    if(typeof (findRows)!='undefined' && findRows.length>0){
                                                        findRows.setProperty("enabled", false);
                                                        ListGrid_AllPersonnelForGroup.redraw();
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

    let SectionStack_Current_GroupPersonnel_Jsp = isc.SectionStack.create({
        visibilityMode: "multiple",
        width: "50%",
        sections: [
            {
                expanded: true,
                canCollapse: false,
                align: "center",
                items: [
                    ListGrid_ForThisGroup_GetPersonnel_Jpa,
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
                                        let ids = ListGrid_ForThisGroup_GetPersonnel_Jpa.getSelection().map(function(item) {return item.id;});
                                        let activeGroup = ListGrid_GroupForGap_Jsp.getSelectedRecord();
                                        let activeGroupId = activeGroup.id;
                                        let JSONObj = {"ids": ids};


                                        isc.RPCManager.sendRequest(TrDSRequest(groupOfPersonnelUrl + "removePersonnel/" + activeGroupId + "/" + ids,
                                            "DELETE", null, function (resp) {

                                                wait.close();
                                                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                                    ListGrid_ForThisGroup_GetPersonnel_Jpa.invalidateCache();
                                                    ListGrid_ForThisGroup_GetPersonnel_Jpa.fetchData();

                                                    let findRows=ListGrid_AllPersonnelForGroup.findAll({_constructor:"AdvancedCriteria",operator:"and",criteria:[{fieldName:"id",operator:"inSet",value:ids}]});

                                                    if(typeof (findRows)!='undefined' && findRows.length>0){
                                                        findRows.setProperty("enabled", true);
                                                        ListGrid_AllPersonnelForGroup.deselectRecord(findRows);
                                                        ListGrid_AllPersonnelForGroup.redraw();
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

    let HStack_thisGroupPersonnel_AddPersonnel_Jsp = isc.HStack.create({
        membersMargin: 10,
        height: 500,
        members: [
            SectionStack_All_PersonnelInGap_Jsp,
            SectionStack_Current_GroupPersonnel_Jsp
        ]
    });

    let HLayOut_thisGroupPersonnel_AddPersonnel_Jsp = isc.TrHLayout.create({
        height: "10%",
        border: "0px solid yellow",
        layoutMargin: 5,
        align: "center",

        members: [
            DynamicForm_thisGroupPersonnelHeader_Jsp
        ]
    });

    let VLayOut_GroupPersonnel_Jsp = isc.TrVLayout.create({
        border: "3px solid gray",
        layoutMargin: 5,
        members: [
            HLayOut_thisGroupPersonnel_AddPersonnel_Jsp,
            HStack_thisGroupPersonnel_AddPersonnel_Jsp
        ]
    });

    let Window_Add_Personnel_to_Group_Jsp = isc.Window.create({
        title: "لیست پرسنل",
        width: "900",
        height: "400",
        align: "center",
        closeClick: function () {
            ListGrid_Personnel_for_Group_Jsp.invalidateCache();
            this.hide();
        },
        items: [
            VLayOut_GroupPersonnel_Jsp
        ]
    });

    let ToolStrip_GroupPersonnel_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let criteria = ListGrid_Personnel_for_Group_Jsp.getCriteria();

                    if(typeof(criteria.operator)=='undefined'){
                        criteria._constructor="AdvancedCriteria";
                        criteria.operator="and";
                    }

                    if(typeof(criteria.criteria)=='undefined'){
                        criteria.criteria=[];
                    }
                    // criteria.criteria.push({fieldName: "postGradeGroup", operator: "inSet", value: [ListGrid_GroupForGap_Jsp.getSelectedRecord().id]});

                    // ExportToFile.downloadExcel(null, ListGrid_Personnel_for_Group_Jsp , "Post_Grade_Without_Permission", 0, null, '',"لیست رده پستی - آموزش"  , criteria, null);
                }
            })
        ]
    });

    let ActionsTS_GroupPersonnel = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStrip_GroupPersonnel_Export2EXcel
        ]
    });

    let ListGrid_Personnel_for_Group_Jsp = isc.TrLG.create({
        dataSource: RestDataSource_PersonnelForGroup_Jsp,
        autoFetchData: false,
        gridComponents: [ActionsTS_GroupPersonnel, "header", "filterEditor", "body",],
        fields: [
            {name: "peopleType", title: "<spring:message code="people.type"/>", filterOperator: "equals", autoFitWidth: true, valueMap:{
                    "Personal" : "شرکتی",
                    "ContractorPersonal" : "پیمان کار"},
                filterOnKeypress: true},
            {
                name: "code",
                title: "<spring:message code='post.grade.code'/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                },
                hidden: true
            },
            {
                name: "titleFa",
                title: "<spring:message code='post.grade.title'/>",
                filterOperator: "iContains"
            },
            {name: "enabled",
                valueMap:{
                    74 : "غیر فعال"
                },filterOnKeypress: true,
            },
        ]
    });

    let DynamicForm_GroupForGap_Jsp = isc.DynamicForm.create({
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
                name: "description",
                title: "<spring:message code='description'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9 ]",
                validators: [TrValidators.NotEmpty, TrValidators.NotStartWithSpecialChar, TrValidators.NotStartWithNumber]
            }
        ]
    });


    let IButton_GroupForGap_Exit_Jsp = isc.IButtonCancel.create({
        click: function () {
            Window_GroupForGap_Jsp.close();
        }
    });

    let IButton_GroupForGap_Save_Jsp = isc.IButtonSave.create({
        click: function () {
            DynamicForm_GroupForGap_Jsp.validate();
            if (DynamicForm_GroupForGap_Jsp.hasErrors()) {
                return;
            }
            let data = DynamicForm_GroupForGap_Jsp.getValues();
            isc.RPCManager.sendRequest(TrDSRequest(url, method, JSON.stringify(data),
                "callback: GroupForGap_save_result(rpcResponse)"));
        }
    });

    let HLayOut_GroupForGapSaveOrExit_Jsp = isc.TrHLayoutButtons.create({
        members: [IButton_GroupForGap_Save_Jsp, IButton_GroupForGap_Exit_Jsp]
    });

    let Window_GroupForGap_Jsp = isc.Window.create({
        title: "پرسنل حاضر در گروه / تیم ",
        width: 700,
        align: "center",
        border: "1px solid gray",
        closeClick: function () {
            this.Super("closeClick", arguments);
        },
        items: [isc.TrVLayout.create({
            members: [DynamicForm_GroupForGap_Jsp, HLayOut_GroupForGapSaveOrExit_Jsp]
        })]
    });



    ToolStripButton_EditNA_PGGGapGroupForGap = isc.ToolStripButton.create({
        title: "ویرایش نیازسنجی (گپ)",
        click: function () {
            if (ListGrid_GroupForGap_Jsp.getSelectedRecord() == null){
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                return;
            }
            Window_NeedsAssessment_Edit_Gap.showUs(ListGrid_GroupForGap_Jsp.getSelectedRecord(), "GroupOfPersonnel",true);
        }
    });


    ToolStrip_NA_PGG_GroupForGap = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            <sec:authorize access="hasAuthority('NeedAssessment_U')">
            ToolStripButton_EditNA_PGGGapGroupForGap,
            </sec:authorize>
        ]
    });

    let ToolStripButton_Refresh_GroupForGap_Jsp = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_GroupOfPersonnel_refresh();
        }
    });
    let ToolStripButton_Edit_GroupForGap_Jsp = isc.ToolStripButtonEdit.create({
        click: function () {
            ListGrid_GroupForGap_edit();
        }
    });
    let ToolStripButton_Add_GroupForGap_Jsp = isc.ToolStripButtonCreate.create({
        click: function () {
            ListGrid_GroupForGap_add();
        }
    });
    let ToolStripButton_Remove_GroupForGap_Jsp = isc.ToolStripButtonRemove.create({
        click: function () {
            ListGrid_groupOfPersonnel_remove();
        }
    });

    let ToolStripButton_Add_GroupForGap_Add_Jsp = isc.ToolStripButton.create({
        <%--icon: "<spring:url value="post.png"/>",--%>
        title: "لیست پرسنل تیم / گروه",
        click: function () {
            Add_Personnel_to_Group_Jsp();
        }
    });


    <%--/////////////////////////////////////////////////////////////////////////////////////////////--%>

    let ToolStrip_Actions_GroupForGap_Jsp = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            <sec:authorize access="hasAuthority('PostGradeGroup_C')">
            ToolStripButton_Add_GroupForGap_Jsp,
            </sec:authorize>
            <sec:authorize access="hasAuthority('PostGradeGroup_U')">
            ToolStripButton_Edit_GroupForGap_Jsp,
            </sec:authorize>
            <sec:authorize access="hasAuthority('PostGradeGroup_D')">
            ToolStripButton_Remove_GroupForGap_Jsp,
            </sec:authorize>
            <sec:authorize access="hasAuthority('PostGradeGroup_R')">
            ToolStripButton_Add_GroupForGap_Add_Jsp,
            </sec:authorize>
<%--            <sec:authorize access="hasAuthority('PostGradeGroup_P')">--%>
<%--            ToolStrip_Post_Grade_Group_Export2EXcel,--%>
<%--            </sec:authorize>--%>
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    <sec:authorize access="hasAuthority('PostGradeGroup_R')">
                    ToolStripButton_Refresh_GroupForGap_Jsp,
                    </sec:authorize>
                ]
            }),

        ]
    });

    let HLayout_Actions_GroupForGap_Jsp = isc.VLayout.create({
        width: "100%",
        members: [ToolStrip_Actions_GroupForGap_Jsp,
            ToolStrip_NA_PGG_GroupForGap
        ]
    });


    <%--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////--%>

    let Detail_Tab_GroupForGap = isc.TabSet.create({
        tabBarPosition: "top",
        tabs: [
            {name: "TabPane_Personnel_in_one_group", title: "لیست پرسنل", pane: ListGrid_ForThisGroup_GetPersonnel_Jpa_inMain},
        ],
        tabSelected: function (){
            selectionUpdated_GroupOfPersonnel();
        }
    });

    let HLayout_Tab_GroupForGap = isc.TrHLayout.create({
        members: [
            <sec:authorize access="hasAuthority('PostGradeGroup_R')">
            Detail_Tab_GroupForGap
            </sec:authorize>
        ]
    });

    let HLayout_Grid_GroupForGap_Jsp = isc.TrHLayout.create({
        showResizeBar:true,
        members: [ListGrid_GroupForGap_Jsp]
    });

    let VLayout_Body_GroupForGap_Jsp = isc.TrVLayout.create({
        members: [
            HLayout_Actions_GroupForGap_Jsp,
            HLayout_Grid_GroupForGap_Jsp,
            HLayout_Tab_GroupForGap
        ]

    });


    ///////////////////////////////////////////////functions/////////////////////////////////////////////////////


    function GroupForGap_save_result(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            let OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",
                "<spring:message code="msg.command.done"/>");
            setTimeout(function () {
                OK.close();
            }, 2000);
            ListGrid_GroupOfPersonnel_refresh();
            Window_GroupForGap_Jsp.close();
        } else {
            let respText =  JSON.parse(resp.httpResponseText);
            createDialog("info", respText.message,
                "<spring:message code="message"/>");
        }
    }

    function Add_Personnel_to_Group_Jsp() {
        let record = ListGrid_GroupForGap_Jsp.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            personnelGroupSelection=true;
            RestDataSource_ForThisPersonnel_to_Group_Jsp.fetchDataURL = groupOfPersonnelUrl + record.id + "/get-group-personnel";
            ListGrid_ForThisGroup_GetPersonnel_Jpa.invalidateCache();
            ListGrid_ForThisGroup_GetPersonnel_Jpa.fetchData();
            DynamicForm_thisGroupPersonnelHeader_Jsp.setValue("sgTitle", getFormulaMessage(record.titleFa, "2", "red", "B"));
            SectionStack_Current_GroupPersonnel_Jsp.setSectionTitle(0,"پرسنل حاضر در گروه / تیم " + " " +
                getFormulaMessage(record.titleFa, "2", "red", "B"));
            Window_Add_Personnel_to_Group_Jsp.show();
        }
    }

    function ListGrid_GroupForGap_edit() {
        let record = ListGrid_GroupForGap_Jsp.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            DynamicForm_GroupForGap_Jsp.clearValues();
            method = "PUT";
            url = groupOfPersonnelUrl + record.id;
            DynamicForm_GroupForGap_Jsp.editRecord(record);
            Window_GroupForGap_Jsp.show();
        }
    }

    function ListGrid_groupOfPersonnel_remove() {
        let record = ListGrid_GroupForGap_Jsp.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            let Dialog_Post_Grade_Group_remove = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                "<spring:message code='global.warning'/>");
            Dialog_Post_Grade_Group_remove.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        wait_groupOfPersonnelGroup = createDialog("wait");
                        isc.RPCManager.sendRequest(TrDSRequest(groupOfPersonnelUrl + record.id+"/GroupOfPersonnel", "DELETE", null,
                            "callback: groupOfPersonnelDel_result(rpcResponse)"));
                    }
                }
            });
        }
    }

    function groupOfPersonnelDel_result(resp) {
        wait_groupOfPersonnelGroup.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            ListGrid_GroupForGap_Jsp.invalidateCache();
            let OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",
                "<spring:message code="msg.command.done"/>");
            ListGrid_Personnel_for_Group_Jsp.setData([]);
            setTimeout(function () {
                OK.close();
            }, 2000);
        } else {
            let respText =  JSON.parse(resp.httpResponseText);
            createDialog("info", respText.message,
                "<spring:message code="message"/>");
        }
    }

    function ListGrid_GroupOfPersonnel_refresh() {
        refreshLG(ListGrid_GroupForGap_Jsp);
        ListGrid_GroupForGap_Jsp.setData([]);
        personnel_Group_Id = null;
    }

    function ListGrid_GroupForGap_add() {
        method = "POST";
        url = groupOfPersonnelUrl;
        DynamicForm_GroupForGap_Jsp.clearValues();
        Window_GroupForGap_Jsp.show();
    }


    function selectionUpdated_GroupOfPersonnel(){
        let rec = ListGrid_GroupForGap_Jsp.getSelectedRecord();
        let tab = Detail_Tab_GroupForGap.getSelectedTab();
        if (rec == null && tab.pane != null){
            tab.pane.setData([]);
            return;
        }

        switch (tab.name || tab.ID) {
            case "TabPane_Personnel_in_one_group":{
                if (personnel_Group_Id === rec.id)
                    return;
                personnel_Group_Id = rec.id;
                RestDataSource_ForThisPersonnel_to_Group_Jsp.fetchDataURL = groupOfPersonnelUrl + personnel_Group_Id+ "/get-group-personnel";
                ListGrid_ForThisGroup_GetPersonnel_Jpa_inMain.invalidateCache();
                ListGrid_ForThisGroup_GetPersonnel_Jpa_inMain.fetchData();
                break;
            }
        }
    }



    ////////////////////////////////////////////////////////////////////////////////////////////////////

    // </script>