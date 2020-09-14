<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="Spring" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>
    var method = "POST";
    var job_JobGroup = null;
    var naJob_JobGroup = null;
    var personnelJob_JobGroup = null;
    var postJob_JobGroup = null;
    var jobsSelection=false;
    let oLoadAttachments_Job_Group = null;

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

    var RestDataSource_Job_Group_Jsp = isc.TrDS.create({
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "code", title: "<spring:message code='code'/>", align: "center", filterOperator: "iContains"},
            {name: "titleFa", title: "نام گروه شغل", align: "center", filterOperator: "iContains"},
            {name: "titleEn", title: "نام لاتین گروه شغل ", align: "center", filterOperator: "iContains"},
            {name: "description", title: "توضیحات", align: "center"},
            {name: "competenceCount", title: "تعداد شایستگی", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelCount", title: "تعداد پرسنل", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "lastModifiedDateNA", title: "<spring:message code="update.date"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "modifiedByNA", title: "<spring:message code="updated.by"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "version", title: "version", canEdit: false, hidden: true}
        ],
        fetchDataURL: viewJobGroupUrl + "/iscList"
    });
    var RestDataSource_Job_Group_Jobs_Jsp = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="job.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains"},
            {name: "competenceCount", title: "تعداد شایستگی", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelCount", title: "تعداد پرسنل", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {
                name: "enabled",
                title: "<spring:message code="active.status"/>",
                align: "center",
                filterOperator: "equals",
                autoFitWidth: true,
                autoFitWidthApproach: "both",
            },
        ],
        fetchDataURL: viewJobUrl + "/iscList"
    });
    var RestDataSource_All_Jobs = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code", filterOperator: "iContains"},
            {name: "titleFa", filterOperator: "iContains"},
            {name: "titleEn", filterOperator: "iContains"},
            {name: "description", filterOperator: "iContains"},
            {name: "version"},
            {
                name: "isEnabled",
                title: "<spring:message code="active.status"/>",
                align: "center",
                filterOperator: "equals",
                autoFitWidth: true,
                autoFitWidthApproach: "both",
            },
        ]
        , fetchDataURL: jobUrl + "/iscList"
    });
    var RestDataSource_ForThisJobGroup_GetJobs = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "description"},
            {name: "version"},
            {
                name: "isEnabled",
                width:80,
                title: "<spring:message code="active.status"/>"
            },
        ]
    });
    var Menu_ListGrid_Job_Group_Jsp = isc.Menu.create({
        width: 150,
        data: [{
            title: "بازخوانی اطلاعات", icon: "<spring:url value="refresh.png"/>", click: function () {
                ListGrid_Job_Group_refresh();
            }
        }, {
            title: " ایجاد", icon: "<spring:url value="create.png"/>", click: function () {
                ListGrid_Job_Group_add();
            }
        }, {
            title: "ویرایش", icon: "<spring:url value="edit.png"/>", click: function () {
                ListGrid_Job_Group_edit();
            }
        }, {
            title: "حذف", icon: "<spring:url value="remove.png"/>", click: function () {
                ListGrid_Job_Group_remove();
            }
        },
            {isSeparator: true}, {
                title: "لیست شغل ها", icon: "<spring:url value="job.png"/>", click: function () {
                    var record = ListGrid_Job_Group_Jsp.getSelectedRecord();


                    if (record == null || record.id == null) {

                        isc.Dialog.create({

                            message: "<spring:message code="msg.jobGroup.notFound"/>",
                            icon: "[SKIN]ask.png",
                            title: "پیام",
                            buttons: [isc.IButtonSave.create({title: "تائید"})],
                            buttonClick: function (button, index) {
                                this.close();
                            }
                        });
                    } else {

                        RestDataSource_ForThisJobGroup_GetJobs.fetchDataURL = jobGroupUrl + record.id + "/getJobs"

                        jobsSelection=true;
                        ListGrid_ForThisJobGroup_GetJobs.invalidateCache();
                        ListGrid_ForThisJobGroup_GetJobs.fetchData();
                        DynamicForm_thisJobGroupHeader_Jsp.setValue("sgTitle", getFormulaMessage(record.titleFa, "2", "red", "B"));
                        Window_Add_Job_to_JobGroup.show();
                    }
                }
            }
        ]
    });

    var ListGrid_Job_Group_Jsp = isc.TrLG.create({
        color: "red",
        dataSource: RestDataSource_Job_Group_Jsp,
        contextMenu: Menu_ListGrid_Job_Group_Jsp,
        autoFetchData: true,
        selectionType: "single",
        canMultiSort: true,
        initialSort: [
            {property: "competenceCount", direction: "ascending"},
            {property: "id", direction: "descending"}
        ],
        selectionUpdated: function () {
            selectionUpdated_JobGroupGroup();
        },
        doubleClick: function () {
            ListGrid_Job_Group_edit();
        },
        getCellCSSText: function (record) {
            return setColorForListGrid(record)
        },
    });
    var Menu_ListGrid_Job_Group_Jobs = isc.Menu.create({
        width: 150,
        data: [{
            title: "بازخوانی اطلاعات", icon: "<spring:url value="refresh.png"/>", click: function () {
                ListGrid_Job_Group_Jobs_refresh();
            }
        }, {
            title: " حذف شغل از گروه شغل مربوطه", icon: "<spring:url value="remove.png"/>", click: function () {
                activeJobGroup = ListGrid_Job_Group_Jsp.getSelectedRecord();
                activeJob = ListGrid_Job_Group_Jobs.getSelectedRecord();
                if (activeJobGroup == null || activeJob == null) {
                    simpleDialog("پیام", "شغل یا گروه شغل انتخاب نشده است.", 0, "confirm");

                } else {
                    var Dialog_Delete = isc.Dialog.create({
                        message: getFormulaMessage("آیا از حذف  شغل:' ", "2", "black", "c") + getFormulaMessage(activeJob.titleFa, "3", "red", "U") + getFormulaMessage(" از گروه شغل:' ", "2", "black", "c") + getFormulaMessage(activeJobGroup.titleFa, "3", "red", "U") + getFormulaMessage(" ' مطمئن هستید؟", "2", "black", "c"),//"<font size='2' color='red'>"+"آیا از حذف گروه شغل:' " +record.titleFa+ " ' مطمئن هستید؟" +"</font>",
                        icon: "[SKIN]ask.png",
                        title: "تائید حذف",
                        buttons: [isc.IButtonSave.create({title: "بله"}), isc.IButtonCancel.create({
                            title: "خیر"
                        })],
                        buttonClick: function (button, index) {
                            this.close();

                            if (index == 0) {
                                deleteJobFromJobGroup(activeJob.id, activeJobGroup.id);
                            }
                        }
                    });

                }
            }
        },

        ]
    });

    var DynamicForm_thisJobGroupHeader_Jsp = isc.DynamicForm.create({
        align: "right",
        autoDraw: false,
        fields: [
            {
                name: "sgTitle",
                type: "staticText",
                title: "افزودن شغل به گروه شغل:",
            }
        ]
    });
    var ListGrid_AllJobs = isc.TrLG.create({
        //title:"تمام شغل ها",
        width: "100%",
        height: "100%",
        autoFetchData: false,
        dataSource: RestDataSource_All_Jobs,
        fields: [
            {name: "id", title: "id", primaryKey: true, hidden: true},
            {name: "code", title: "کد شغل", align: "center", width: "20%",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "titleFa", title: "نام شغل", align: "center", width: "60%"},
            //{name: "titleEn", title: "نام لاتین شغل", align: "center", hidden: true},
            //{name: "description", title: "توضیحات", align: "center", hidden: true},
            //{name: "version", title: "version", canEdit: false, hidden: true},
            {name: "isEnabled",
                valueMap:{
                    "undefined" : "فعال",
                    74 : "غیر فعال",
                },filterOnKeypress: true,canSort:false
            },
            {name: "OnAdd", title: " ", align: "center",canSort:false,canFilter:false}
        ],
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 22,
        showFilterEditor: true,
        filterOnKeypress: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        selectionAppearance: "checkbox",
        selectionType: "simple",
        dataArrived:function(startRow, endRow){
            let lgIds = ListGrid_ForThisJobGroup_GetJobs.data.getAllCachedRows().map(function(item) {
                return item.id;
            });

            let findRows=ListGrid_AllJobs.findAll({_constructor:"AdvancedCriteria",operator:"and",criteria:[{fieldName:"id",operator:"inSet",value:lgIds}]});
            ListGrid_AllJobs.setSelectedState(findRows);
            findRows.setProperty("enabled", false);
        },
        createRecordComponent: function (record, colNum) {
            var fieldName = this.getFieldName(colNum);
            if (fieldName == "OnAdd") {
                var recordCanvas = isc.HLayout.create({
                    height: 20,
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
                        let selected=ListGrid_ForThisJobGroup_GetJobs.data.getAllCachedRows().map(function(item) {return item.id;});

                        let jobIds = [];

                        if ($.inArray(current.id, selected) === -1){
                            jobIds.push(current.id);
                        }

                        if(jobIds.length!=0){
                            let findRows=ListGrid_AllJobs.findAll({_constructor:"AdvancedCriteria",operator:"and",criteria:[{fieldName:"id",operator:"equals",value:current.id}]});

                            let jobGroupRecord = ListGrid_Job_Group_Jsp.getSelectedRecord();
                            let jobGroupId = jobGroupRecord.id;

                            let JSONObj = {"ids": jobIds};
                            wait.show();
                            isc.RPCManager.sendRequest({
                                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                                useSimpleHttp: true,
                                contentType: "application/json; charset=utf-8",
                                actionURL: jobGroupUrl + "addJobs/" + jobGroupId + "/" + jobIds,
                                httpMethod: "POST",
                                data: JSON.stringify(JSONObj),
                                serverOutputAsString: false,
                                callback: function (resp) {
                                    wait.close();
                                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                        ListGrid_AllJobs.selectRecord(findRows);
                                        findRows.setProperty("enabled", false);

                                        ListGrid_AllJobs.redraw();

                                        ListGrid_ForThisJobGroup_GetJobs.invalidateCache();
                                        ListGrid_ForThisJobGroup_GetJobs.fetchData();
                                    } else {
                                        isc.say("خطا");
                                    }
                                }
                            });
                        }
                    }
                });
                recordCanvas.addMember(addIcon);
                return recordCanvas;
            } else
                return null;
        }

    });
    var ListGrid_ForThisJobGroup_GetJobs = isc.TrLG.create({
        //title:"تمام شغل ها",
        width: "100%",
        height: "100%",
        //showRowNumbers: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        selectionAppearance: "checkbox",
        selectionType: "simple",
        dataSource: RestDataSource_ForThisJobGroup_GetJobs,
        fields: [
            {name: "id", title: "id", primaryKey: true, hidden: true},
            {name: "code", title: "کد شغل", align: "center", width: "20%",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "titleFa", title: "نام شغل", align: "center", width: "70%"},
            {name: "isEnabled",
                valueMap:{
                    74 : "غیر فعال",
                },
                filterOnKeypress: true,
                canSort:false,
                emptyDisplayValue:"فعال",
            },
            {name: "OnDelete", title: " ", align: "center",canSort:false,canFilter:false}
        ],
        dataArrived:function(){
            if(jobsSelection) {
                ListGrid_AllJobs.invalidateCache();
                ListGrid_AllJobs.fetchData();
                jobsSelection=false;
            }
        },
        createRecordComponent: function (record, colNum) {
            var fieldName = this.getFieldName(colNum);

            if (fieldName == "OnDelete") {
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
                    prompt: "حذف کردن",
                    height: 16,
                    width: 16,
                    grid: this,
                    click: function () {
                        var activeJob = record;
                        var activeJobId = activeJob.id;
                        var activeJobGroup = ListGrid_Job_Group_Jsp.getSelectedRecord();
                        var activeJobGroupId = activeJobGroup.id;
                        isc.RPCManager.sendRequest({
                            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            actionURL: jobGroupUrl + "removeJob/" + activeJobGroupId + "/" + activeJobId,
                            httpMethod: "DELETE",
                            serverOutputAsString: false,
                            callback: function (resp) {
                                if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {

                                    ListGrid_ForThisJobGroup_GetJobs.invalidateCache();

                                    let findRows=ListGrid_AllJobs.findAll({_constructor:"AdvancedCriteria",operator:"and",criteria:[{fieldName:"id",operator:"inSet",value:[activeJobId]}]});

                                    if(typeof (findRows)!='undefined' && findRows.length>0){
                                        findRows.setProperty("enabled", true);
                                        ListGrid_AllJobs.deselectRecord(findRows[0]);
                                    }

                                } else {
                                    isc.say("خطا در پاسخ سرویس دهنده");
                                }
                            }
                        });
                    }
                });
                recordCanvas.addMember(removeIcon);
                return recordCanvas;
            } else
                return null;
        },

        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 22,
        autoFetchData: false,
        showFilterEditor: true,
        filterOnKeypress: true,
    });

    var SectionStack_All_Jobs_Jsp = isc.SectionStack.create({
        visibilityMode: "multiple",
        width: "50%",
        sections: [
            {
                title: "لیست شغل ها",
                expanded: true,
                canCollapse: false,
                align: "center",
                items: [
                    ListGrid_AllJobs,
                    isc.ToolStripButtonAdd.create({
                        width:"100%",
                        height:25,
                        title:"اضافه کردن گروهی",
                        click: function () {
                            let jobIds = ListGrid_AllJobs.getSelection().filter(function(x){return x.enabled!=false}).map(function(item) {return item.id;});

                            if (!jobIds || jobIds==0)
                                return;

                            let dialog = createDialog('ask', "<spring:message code="msg.record.adds.ask"/>");
                            dialog.addProperties({
                                buttonClick: function (button, index) {
                                    this.close();
                                    if (index == 0) {
                                        var activeJobGroup = ListGrid_Job_Group_Jsp.getSelectedRecord();
                                        var activeJobGroupId = activeJobGroup.id;
                                        let JSONObj = {"ids": jobIds};
                                        isc.RPCManager.sendRequest({
                                            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                                            useSimpleHttp: true,
                                            contentType: "application/json; charset=utf-8",
                                            actionURL: jobGroupUrl + "addJobs/" + activeJobGroupId + "/" + jobIds,
                                            httpMethod: "POST",
                                            data: JSON.stringify(JSONObj),
                                            serverOutputAsString: false,
                                            callback: function (resp) {
                                                if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                                                    ListGrid_ForThisJobGroup_GetJobs.invalidateCache();

                                                    let findRows=ListGrid_AllJobs.findAll({_constructor:"AdvancedCriteria",operator:"and",criteria:[{fieldName:"id",operator:"inSet",value:jobIds}]});

                                                    if(typeof (findRows)!='undefined' && findRows.length>0){
                                                        findRows.setProperty("enabled", false);
                                                        ListGrid_AllJobs.redraw();
                                                    }
                                                    isc.say("عملیات با موفقیت انجام شد.");

                                                } else {
                                                    isc.say("خطا در پاسخ سرویس دهنده");
                                                }
                                            }
                                        });
                                    }
                                }
                            })

                        }
                    })
                ]
            }
        ]
    });

    var SectionStack_Current_Job_JspClass = isc.SectionStack.create({
        visibilityMode: "multiple",
        width: "50%",
        sections: [
            {
                title: "لیست شغل های این گروه شغل",
                expanded: true,
                canCollapse: false,
                align: "center",
                items: [
                    ListGrid_ForThisJobGroup_GetJobs,
                    isc.ToolStripButtonRemove.create({
                        width:"100%",
                        height:25,
                        title:"حذف گروهی",
                        click: function () {
                            let jobIds = ListGrid_ForThisJobGroup_GetJobs.getSelection().map(function(item) {return item.id;});

                            if (!jobIds || jobIds==0)
                                return;

                            let dialog = createDialog('ask', "<spring:message code="msg.record.remove.ask"/>");
                            dialog.addProperties({
                                buttonClick: function (button, index) {
                                    this.close();
                                    if (index == 0) {
                                        var activeJobGroup = ListGrid_Job_Group_Jsp.getSelectedRecord();
                                        var activeJobGroupId = activeJobGroup.id;
                                        let JSONObj = {"ids": jobIds};
                                        isc.RPCManager.sendRequest({
                                            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                                            useSimpleHttp: true,
                                            contentType: "application/json; charset=utf-8",
                                            actionURL: jobGroupUrl + "removeJobs/" + activeJobGroupId + "/" + jobIds,
                                            httpMethod: "DELETE",
                                            data: JSON.stringify(JSONObj),
                                            serverOutputAsString: false,
                                            callback: function (resp) {
                                                if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {

                                                    ListGrid_ForThisJobGroup_GetJobs.invalidateCache();
                                                    let findRows=ListGrid_AllJobs.findAll({_constructor:"AdvancedCriteria",operator:"and",criteria:[{fieldName:"id",operator:"inSet",value:jobIds}]});

                                                    if(typeof (findRows)!='undefined' && findRows.length>0){
                                                        findRows.setProperty("enabled", true);
                                                        ListGrid_AllJobs.deselectRecord(findRows);
                                                        ListGrid_AllJobs.redraw();
                                                    }
                                                    isc.say("عملیات با موفقیت انجام شد.");
                                                } else {
                                                    isc.say("خطا در پاسخ سرویس دهنده");
                                                }
                                            }
                                        });
                                    }
                                }
                            })

                        }
                    })
                ]
            }
        ]
    });

    var HStack_thisJobGroup_AddJob_Jsp = isc.HStack.create({
        membersMargin: 10,
        height: 500,
        members: [
            SectionStack_All_Jobs_Jsp,
            SectionStack_Current_Job_JspClass
        ]
    });
    
    var HLayOut_thisJobGroup_AddJob_Jsp = isc.HLayout.create({
        width: "100%",
        height: "10%",
        border: "0px solid yellow",
        layoutMargin: 5,
        align: "center",

        members: [
            DynamicForm_thisJobGroupHeader_Jsp
        ]
    });
    
    var VLayOut_JobGroup_Jobs_Jsp = isc.VLayout.create({
        width: "100%",
        height: "100%",
        border: "3px solid gray", layoutMargin: 5,
        members: [
            HLayOut_thisJobGroup_AddJob_Jsp,
            HStack_thisJobGroup_AddJob_Jsp
        ]
    });

    var Window_Add_Job_to_JobGroup = isc.Window.create({
        title: "لیست شغل ها",
        width: "900",
        height: "400",
        align: "center",
        closeClick: function () {
            ListGrid_Job_Group_Jobs.invalidateCache();
            this.hide();
        },
        items: [
            VLayOut_JobGroup_Jobs_Jsp
        ]
    });

    let ToolStrip_Job_Grpup_Job_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let criteria = ListGrid_Job_Group_Jobs.getCriteria();

                    if(typeof(criteria.operator)=='undefined'){
                        criteria._constructor="AdvancedCriteria";
                        criteria.operator="and";
                    }

                    if(typeof(criteria.criteria)=='undefined'){
                        criteria.criteria=[];
                    }
                    criteria.criteria.push({fieldName: "jobGroupSet", operator: "equals", value: ListGrid_Job_Group_Jsp.getSelectedRecord().id});

                    ExportToFile.downloadExcel(null, ListGrid_Job_Group_Jobs , "View_Job", 0, null, '',"لیست شغل ها - آموزش"  , criteria, null);
                }
            })
        ]
    });

    let ActionsTS_Job_Group_Job = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStrip_Job_Grpup_Job_Export2EXcel
        ]
    });
    
    var ListGrid_Job_Group_Jobs = isc.TrLG.create({
        width: "100%",
        height: "100%",
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        dataSource: RestDataSource_Job_Group_Jobs_Jsp,
        contextMenu: Menu_ListGrid_Job_Group_Jobs,
        gridComponents: [ActionsTS_Job_Group_Job, "header", "filterEditor", "body",],
        fields: [{name: "code",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "titleFa"},
            {name: "competenceCount"},
            {name: "personnelCount"},
            {name: "enabled",
                valueMap:{
                    // undefined : "فعال",
                    74 : "غیر فعال"
                },filterOnKeypress: true,
            },
        ],
        sortField: 1,
        sortDirection: "descending",
        autoFetchData: false,
    });
    
    var DynamicForm_Job_Group_Jsp = isc.DynamicForm.create({
        width: "750",
        height: "150",
        align: "center",
        canSubmit: true,
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: true,
        errorOrientation: "right",
        titleAlign: "right",
        requiredMessage: "فیلد اجباری است.",
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
                title: "نام گروه شغل",
                type: "text",
                required: true,
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9 ]",
                validators: [TrValidators.NotEmpty, TrValidators.NotStartWithSpecialChar, TrValidators.NotStartWithNumber],
                hint: "Persian/فارسی",
                showHintInField: true,
                length: "250",
                width: "*",
                height: "40"
            },
            {
                name: "code",
                title: "<spring:message code='code'/>"
            },
            {
                name: "titleEn",
                type: "text",
                length: "250",
                width: "*",
                height: "40",
                title: "نام لاتین گروه شغل ",
                hint: "English/انگلیسی",
                showHintInField: true,
                keyPressFilter: "[a-z|A-Z|0-9 |]",
                validators: [TrValidators.NotEmpty, TrValidators.NotStartWithSpecialChar, TrValidators.NotStartWithNumber],
            },
            {
                name: "description",
                type: "text",
                length: "250",
                width: "*",
                height: "40",
                title: "توضیحات",
                hint: "توضیحات",
                showHintInField: true,
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9 ]",
                validators: [TrValidators.NotEmpty, TrValidators.NotStartWithSpecialChar, TrValidators.NotStartWithNumber],
            }
        ]
    });

    defineWindowsEditNeedsAssessment(ListGrid_Job_Group_Jsp);
    defineWindowTreeNeedsAssessment();
    
    var IButton_Job_Group_Exit_Jsp = isc.IButtonCancel.create({
        top: 260, title: "لغو",
        //icon: "<spring:url value="remove.png"/>",
        align: "center",
        click: function () {
            Window_Job_Group_Jsp.close();
        }
    });

    var IButton_Job_Group_Save_Jsp = isc.IButtonSave.create({
        top: 260, title: "ذخیره",
        //icon: "pieces/16/save.png",
        align: "center", click: function () {

            DynamicForm_Job_Group_Jsp.validate();
            if (DynamicForm_Job_Group_Jsp.hasErrors()) {
                return;
            }
            let data = DynamicForm_Job_Group_Jsp.getValues();

            isc.RPCManager.sendRequest({
                actionURL: url,
                httpMethod: method,
                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                showPrompt: false,
                data: JSON.stringify(data),
                serverOutputAsString: false,
                callback: function (resp) {
                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                        let OK = isc.Dialog.create({
                            message: "عملیات با موفقیت انجام شد.",
                            icon: "[SKIN]say.png",
                            title: "انجام فرمان"
                        });
                        setTimeout(function () {
                            OK.close();
                        }, 3000);
                        ListGrid_Job_Group_refresh();
                        Window_Job_Group_Jsp.close();
                    } else {
                        let ERROR = isc.Dialog.create({
                            message: ("اجرای عملیات با مشکل مواجه شده است!"),
                            icon: "[SKIN]stop.png",
                            title: "پیغام"
                        });
                        setTimeout(function () {
                            ERROR.close();
                        }, 3000);
                    }

                }
            });
        }
    });

    var HLayOut_Job_GroupSaveOrExit_Jsp = isc.HLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "700",
        height: "10",
        alignLayout: "center",
        align: "center",
        padding: 10,
        membersMargin: 10,
        members: [IButton_Job_Group_Save_Jsp, IButton_Job_Group_Exit_Jsp]
    });

    var Window_Job_Group_Jsp = isc.Window.create({
        title: " گروه شغل ",
        width: 700,
        height: 200,
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
        items: [isc.VLayout.create({
            width: "100%",
            height: "100%",
            members: [DynamicForm_Job_Group_Jsp, HLayOut_Job_GroupSaveOrExit_Jsp]
        })]
    });

    let ToolStripButton_EditNA_JobGroup = isc.ToolStripButton.create({
        title: "ویرایش نیازسنجی",
        click: function () {
            if (ListGrid_Job_Group_Jsp.getSelectedRecord() == null){
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                return;
            }
            Window_NeedsAssessment_Edit.showUs(ListGrid_Job_Group_Jsp.getSelectedRecord(), "JobGroup");
        }
    });
    let ToolStripButton_TreeNA_JobGroup = isc.ToolStripButton.create({
        title: "درخت نیازسنجی",
        click: function () {
            if (ListGrid_Job_Group_Jsp.getSelectedRecord() == null){
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                return;
            }
            Window_NeedsAssessment_Tree.showUs(ListGrid_Job_Group_Jsp.getSelectedRecord(), "JobGroup");
        }
    });
    let ToolStrip_NA_JobGroup = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [ToolStripButton_EditNA_JobGroup, ToolStripButton_TreeNA_JobGroup]
    });

    var ToolStripButton_Refresh_Job_Group_Jsp = isc.ToolStripButtonRefresh.create({
        // icon: "<spring:url value="refresh.png"/>",
        title: "بازخوانی اطلاعات",
        click: function () {
            ListGrid_Job_Group_refresh();
        }
    });
    var ToolStripButton_Edit_Job_Group_Jsp = isc.ToolStripButtonEdit.create({

        title: "ویرایش",
        click: function () {

            ListGrid_Job_Group_edit();
        }
    });
    var ToolStripButton_Add_Job_Group_Jsp = isc.ToolStripButtonAdd.create({

        title: "ایجاد",
        click: function () {

            ListGrid_Job_Group_add();
        }
    });
    var ToolStripButton_Remove_Job_Group_Jsp = isc.ToolStripButtonRemove.create({

        title: "حذف",
        click: function () {
            ListGrid_Job_Group_remove();
        }
    });
    
    var ToolStripButton_Add_Job_Group_AddJob_Jsp = isc.ToolStripButton.create({
        <%--icon: "<spring:url value="job.png"/>",--%>
        title: "لیست شغل ها",
        click: function () {
            var record = ListGrid_Job_Group_Jsp.getSelectedRecord();

            if (record == null || record.id == null) {


                isc.Dialog.create({

                    message: "<spring:message code="msg.jobGroup.notFound"/>",
                    icon: "[SKIN]ask.png",
                    title: "پیام",
                    buttons: [isc.IButtonSave.create({title: "تائید"})],
                    buttonClick: function (button, index) {
                        this.close();
                    }
                });

            } else {

                RestDataSource_ForThisJobGroup_GetJobs.fetchDataURL = jobGroupUrl + record.id + "/getJobs";

                jobsSelection=true;
                ListGrid_ForThisJobGroup_GetJobs.invalidateCache();
                ListGrid_ForThisJobGroup_GetJobs.fetchData();

                DynamicForm_thisJobGroupHeader_Jsp.setValue("sgTitle", getFormulaMessage(record.titleFa, "2", "red", "B"));

                Window_Add_Job_to_JobGroup.show();

            }
        }
    });

    let ToolStrip_Job_Group_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let criteria = ListGrid_Job_Group_Jsp.getCriteria();
                    ExportToFile.downloadExcel(null, ListGrid_Job_Group_Jsp , "View_Job_Group", 0, null, '',"لیست گروه شغلی ها- آموزش"  , criteria, null);
                }
            })
        ]
    });

    var ToolStrip_Actions_Job_Group_Jsp = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        // members: [ToolStripButton_Refresh_Job_Group_Jsp,
        //     ToolStripButton_Add_Job_Group_Jsp,
        //     ToolStripButton_Edit_Job_Group_Jsp,
        //     ToolStripButton_Remove_Job_Group_Jsp,
        //     ToolStripButton_Add_Job_Group_AddJob_Jsp]
        members: [
            ToolStripButton_Add_Job_Group_Jsp,
            ToolStripButton_Edit_Job_Group_Jsp,
            ToolStripButton_Remove_Job_Group_Jsp,
            // ToolStripButton_Print_Job_Group_Jsp,
            ToolStripButton_Add_Job_Group_AddJob_Jsp,
            ToolStrip_Job_Group_Export2EXcel,
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_Refresh_Job_Group_Jsp,
                ]
            }),

        ]
    });

    var HLayout_Actions_Job_Group_Jsp = isc.VLayout.create({
        width: "100%",
        members: [ToolStrip_Actions_Job_Group_Jsp, ToolStrip_NA_JobGroup]
    });

    ////////////////////////////////////////////////////////////personnel///////////////////////////////////////////////
    PersonnelDS_JobGroup = isc.TrDS.create({
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
            {name: "postCode", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpArea", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpAssistant", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpAffairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpSection", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpUnit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: personnelUrl + "/iscList",
    });

    let ToolStrip_Job_Group_Personnel_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let criteria = PersonnelLG_JobGroup.getCriteria();

                    if(typeof(criteria.operator)=='undefined'){
                        criteria._constructor="AdvancedCriteria";
                        criteria.operator="and";
                    }

                    if(typeof(criteria.criteria)=='undefined'){
                        criteria.criteria=[];
                    }
                    criteria.criteria.push({fieldName: "jobGroupId", operator: "equals", value: ListGrid_Job_Group_Jsp.getSelectedRecord().id});

                    ExportToFile.downloadExcel(null, PersonnelLG_JobGroup , "Job_Group_Personnel", 0, null, '',"لیست پرسنل - آموزش"  , criteria, null);
                }
            })
        ]
    });

    let ActionsTS_Personnel_Job_Group = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStrip_Job_Group_Personnel_Export2EXcel
        ]
    });

    PersonnelLG_JobGroup = isc.TrLG.create({
        dataSource: PersonnelDS_JobGroup,
        selectionType: "single",
        alternateRecordStyles: true,
        // groupByField: "jobTitle",
        gridComponents: [ActionsTS_Personnel_Job_Group, "header", "filterEditor", "body",],
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
            {name: "ccpArea"},
            {name: "ccpAssistant"},
            {name: "ccpAffairs"},
            {name: "ccpSection"},
            {name: "ccpUnit"},
        ]
    });

    ///////////////////////////////////////////////////////////needs assessment/////////////////////////////////////////
    PriorityDS_JobGroup = isc.TrDS.create({
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

    DomainDS_JobGroup = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/NeedsAssessmentDomain"
    });

    CompetenceTypeDS_JobGroup = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/competenceType"
    });

    NADS_JobGroup = isc.TrDS.create({
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

    let ToolStrip_Job_Group_NA_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let criteria = NALG_JobGroup.getCriteria();

                    if(typeof(criteria.operator)=='undefined'){
                        criteria._constructor="AdvancedCriteria";
                        criteria.operator="and";
                    }

                    if(typeof(criteria.criteria)=='undefined'){
                        criteria.criteria=[];
                    }
                    criteria.criteria.push({fieldName: "objectId", operator: "equals", value: ListGrid_Job_Group_Jsp.getSelectedRecord().id});
                    criteria.criteria.push({fieldName: "objectType", operator: "equals", value: "JobGroup"});
                    // criteria.criteria.push({fieldName: "personnelNo", operator: "equals", value: null});

                    ExportToFile.downloadExcel(null, NALG_JobGroup , "NeedsAssessmentReport", 0, null, '',"لیست نیازسنجی - آموزش"  , criteria, null);
                }
            })
        ]
    });

    let ActionsTS_NA_Job_Group = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStrip_Job_Group_NA_Export2EXcel
        ]
    });

    NALG_JobGroup = isc.TrLG.create({
        dataSource: NADS_JobGroup,
        selectionType: "none",
        autoFetchData: false,
        alternateRecordStyles: true,
        showAllRecords: true,
        gridComponents: [
            ActionsTS_NA_Job_Group,
            "header", "filterEditor", "body",],
        fields: [
            {name: "competence.title"},
            {
                name: "competence.competenceTypeId",
                type: "SelectItem",
                filterOnKeypress: true,
                displayField: "title",
                valueField: "id",
                optionDataSource: CompetenceTypeDS_JobGroup,
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
                optionDataSource: PriorityDS_JobGroup,
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
                optionDataSource: DomainDS_JobGroup,
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
    PostDS_JobGroup = isc.TrDS.create({
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

    let ToolStrip_Job_Group_Post_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let criteria = JSON.parse(JSON.stringify(PostLG_JobGroup.getCriteria()));

                    if(typeof(criteria.operator)=='undefined'){
                        criteria._constructor="AdvancedCriteria";
                        criteria.operator="and";
                    }

                    if(typeof(criteria.criteria)=='undefined'){
                        criteria.criteria=[];
                    }
                    criteria.criteria.push({fieldName: "jobGroup", operator: "equals", value: ListGrid_Job_Group_Jsp.getSelectedRecord().id});

                    ExportToFile.downloadExcel(null, PostLG_JobGroup, "Job_Group_Post", 0, null, '',"لیست پست - آموزش"  , criteria, null);
                }
            })
        ]
    });

    let ActionsTS_Post_Job_Group = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStrip_Job_Group_Post_Export2EXcel
        ]
    });

    PostLG_JobGroup = isc.TrLG.create({
        dataSource: PostDS_JobGroup,
        autoFetchData: false,
        sortField: "id",
        gridComponents: [ActionsTS_Post_Job_Group, "header", "filterEditor", "body"],
        // groupByField: "job.titleFa",
    });

    Detail_Tab_Job_Group = isc.TabSet.create({
        tabBarPosition: "top",
        width: "100%",
        height: "100%",
        tabs: [
            {name: "TabPane_Job_Group_Job", title: "لیست شغل ها", pane: ListGrid_Job_Group_Jobs},
            {name: "TabPane_Post_JobGroup", title: "لیست پست ها", pane: PostLG_JobGroup},
            {name: "TabPane_Personnel_JobGroup", title: "لیست پرسنل", pane: PersonnelLG_JobGroup},
            {name: "TabPane_NA_JobGroup", title: "<spring:message code='need.assessment'/>", pane: NALG_JobGroup},
            {
                ID: "Job_GroupAttachmentsTab",
                title: "<spring:message code="attachments"/>",
                // pane: isc.ViewLoader.create({autoDraw: true, viewURL: "tclass/attachments-tab"})
            },
        ],
        tabSelected: function (){
            selectionUpdated_JobGroupGroup();
        }
    });

    var HLayout_Tab_Job_Group = isc.HLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [Detail_Tab_Job_Group]
    });

    var HLayout_Grid_Job_Group_Jsp = isc.HLayout.create({
        width: "100%",
        height: "100%",
        showResizeBar:true,
        members: [ListGrid_Job_Group_Jsp]
    });
    var VLayout_Body_Job_Group_Jsp = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            HLayout_Actions_Job_Group_Jsp
            , HLayout_Grid_Job_Group_Jsp
            , HLayout_Tab_Job_Group
        ]

    });

    function ListGrid_Job_Group_Jobs_refresh() {

        if (ListGrid_Job_Group_Jsp.getSelectedRecord() == null)
            ListGrid_Job_Group_Jobs.setData([]);
        else
            refreshLG(ListGrid_Job_Group_Jobs);
    }

    function deleteJobFromJobGroup(jobId, jobGroupId) {

        isc.RPCManager.sendRequest({
            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
            useSimpleHttp: true,
            contentType: "application/json; charset=utf-8",
            actionURL: jobGroupUrl + "removeJob/" + jobGroupId + "/" + jobId,
            httpMethod: "DELETE",
            serverOutputAsString: false,
            callback: function (resp) {
                if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                    ListGrid_Job_Group_Jobs.invalidateCache();

                } else {
                    isc.say("خطا در پاسخ سرویس دهنده");
                }
            }
        });
    }

    function ListGrid_Job_Group_edit() {
        var record = ListGrid_Job_Group_Jsp.getSelectedRecord();
        if (record == null || record.id == null) {

            simpleDialog("پیغام", "گروه شغلی انتخاب نشده است.", 0, "say");

        } else {
            DynamicForm_Job_Group_Jsp.clearValues();
            method = "PUT";
            url = jobGroupUrl + record.id;
            DynamicForm_Job_Group_Jsp.editRecord(record);
            Window_Job_Group_Jsp.show();
        }
    }

    function ListGrid_Job_Group_remove() {
        var record = ListGrid_Job_Group_Jsp.getSelectedRecord();
        if (record == null) {
            simpleDialog("پیغام", "گروه شغلی انتخاب نشده است.", 0, "ask");
        } else {
            var Dialog_Delete = isc.Dialog.create({
                message: getFormulaMessage("آیا از حذف گروه شغل:' ", "2", "black", "c") + getFormulaMessage(record.titleFa, "3", "red", "U") + getFormulaMessage(" ' مطمئن هستید؟", "2", "black", "c"),//"<font size='2' color='red'>"+"آیا از حذف گروه شغل:' " +record.titleFa+ " ' مطمئن هستید؟" +"</font>",
                icon: "[SKIN]ask.png",
                title: "تائید حذف",
                buttons: [isc.IButtonSave.create({title: "بله"}), isc.IButtonCancel.create({
                    title: "خیر"
                })],
                buttonClick: function (button, index) {
                    this.close();
                    if (index == 0) {
                        wait.show();
                        isc.RPCManager.sendRequest({
                            actionURL: jobGroupUrl + record.id,
                            httpMethod: "DELETE",
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                            showPrompt: true,
                            serverOutputAsString: false,
                            callback: function (resp) {
                                wait.close();
                                if (resp.httpResponseCode == 200) {
                                    ListGrid_Job_Group_Jsp.invalidateCache();
                                    simpleDialog("انجام فرمان", "حذف با موفقیت انجام شد", 2000, "say");
                                    ListGrid_Job_Group_Jobs.setData([]);
                                } else {
                                    simpleDialog("پیام خطا", "حذف با خطا مواجه شد", 2000, "stop");

                                }
                            }
                        });
                    }
                }
            });
        }
    }

    function ListGrid_Job_Group_refresh() {
        objectIdAttachment=null
        refreshLG(ListGrid_Job_Group_Jsp);
        ListGrid_Job_Group_Jobs.setData([]);
        PostLG_JobGroup.setData([]);
        PersonnelLG_JobGroup.setData([]);
        NALG_JobGroup.setData([]);
        oLoadAttachments_Job_Group.ListGrid_JspAttachment.setData([]);
        job_JobGroup = null;
        naJob_JobGroup = null;
        personnelJob_JobGroup = null;
        postJob_JobGroup = null;


    }

    function ListGrid_Job_Group_add() {
        method = "POST";
        url = jobGroupUrl;
        DynamicForm_Job_Group_Jsp.clearValues();
        Window_Job_Group_Jsp.show();
    }



    function selectionUpdated_JobGroupGroup(){
        let jobGroup = ListGrid_Job_Group_Jsp.getSelectedRecord();
        let tab = Detail_Tab_Job_Group.getSelectedTab();
        if (jobGroup == null && tab.pane != null){
            tab.pane.setData([]);
            return;
        }

        switch (tab.name || tab.ID) {
            case "TabPane_Job_Group_Job":{
                if (job_JobGroup === jobGroup.id)
                    return;
                job_JobGroup = jobGroup.id;
                ListGrid_Job_Group_Jobs.setImplicitCriteria({
                    _constructor: "AdvancedCriteria",
                    operator: "and",
                    criteria: [{fieldName: "jobGroupSet", operator: "equals", value: jobGroup.id}]
                });
                ListGrid_Job_Group_Jobs.invalidateCache();
                ListGrid_Job_Group_Jobs.fetchData();
                break;
            }
            case "TabPane_Post_JobGroup":{
                if (postJob_JobGroup === jobGroup.id)
                    return;
                // postJob_JobGroup = jobGroup.id;
                // PostLG_JobGroup.setImplicitCriteria({
                //     _constructor: "AdvancedCriteria",
                //     operator: "and",
                //     criteria: [{fieldName: "jobGroup", operator: "equals", value: jobGroup.id}]
                // });
                // PostLG_JobGroup.invalidateCache();
                // PostLG_JobGroup.fetchData();
                PostDS_JobGroup.fetchDataURL = jobGroupUrl + "postIscList/" + jobGroup.id;
                PostLG_JobGroup.invalidateCache();
                PostLG_JobGroup.fetchData();
                break;
            }
            case "TabPane_Personnel_JobGroup":{
                if (personnelJob_JobGroup === jobGroup.id)
                    return;
                personnelJob_JobGroup = jobGroup.id;
                PersonnelDS_JobGroup.fetchDataURL = jobGroupUrl + "personnelIscList/" + jobGroup.id;
                PersonnelLG_JobGroup.invalidateCache();
                PersonnelLG_JobGroup.fetchData();
                break;
            }
            case "TabPane_NA_JobGroup":{
                if (naJob_JobGroup === jobGroup.id)
                    return;
                naJob_JobGroup = jobGroup.id;
                NADS_JobGroup.fetchDataURL = needsAssessmentReportsUrl + "?objectId=" + jobGroup.id + "&objectType=JobGroup";
                NADS_JobGroup.invalidateCache();
                NADS_JobGroup.fetchData();
                NALG_JobGroup.invalidateCache();
                NALG_JobGroup.fetchData();
                break;
            }
            case "Job_GroupAttachmentsTab": {

                if (typeof oLoadAttachments_Job_Group.loadPage_attachment_Job!== "undefined")
                    oLoadAttachments_Job_Group.loadPage_attachment_Job("JobGroup", jobGroup.id, "<spring:message code="attachment"/>", {
                        1: "جزوه",
                        2: "لیست نمرات",
                        3: "لیست حضور و غیاب",
                        4: "نامه غیبت موجه"
                    }, false);
                break;
            }
        }
    }

    if (!loadjs.isDefined('load_Attachments_Job_Group')) {
        loadjs('<spring:url value='tclass/attachments-tab' />', 'load_Attachments_Job_Group');
    }

    loadjs.ready('load_Attachments_Job_Group', function () {
        setTimeout(()=> {
            oLoadAttachments_Job_Group = new loadAttachments();
            Detail_Tab_Job_Group.updateTab(Job_GroupAttachmentsTab, oLoadAttachments_Job_Group.VLayout_Body_JspAttachment)
        },0);

    });


    // </script>