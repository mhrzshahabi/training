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
            {name: "version"}
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
            {name: "version"}
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
            <%--{isSeparator: true},--%>
            <%--{--%>
            <%--    title: "چاپ همه گروه شغل ها", icon: "<spring:url value="pdf.png"/>",--%>
            <%--    click: "window.open('job-group/print/pdf/<%=accessToken%>/')"--%>
            <%--},--%>
            <%--{--%>
            <%--    title: "چاپ با جزئیات", icon: "<spring:url value="pdf.png"/>",--%>
            <%--    click: "window.open('job-group/printDetail/pdf/<%=accessToken%>/'+ListGrid_Job_Group_Jsp.getSelectedRecord().id)"--%>
            <%--},--%>
            {isSeparator: true}, {
                title: "حذف گروه شغل از تمام شایستگی ها", icon: "<spring:url value="remove.png"/>", click: function () {
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


                        var Dialog_Delete = isc.Dialog.create({
                            message: getFormulaMessage("آیا از حذف  گروه شغل:' ", "2", "black", "c") + getFormulaMessage(record.titleFa, "3", "red", "U") + getFormulaMessage(" از  کلیه شایستگی هایش ", "2", "black", "c") + getFormulaMessage("  مطمئن هستید؟", "2", "black", "c"),//"<font size='2' color='red'>"+"آیا از حذف گروه شغل:' " +record.titleFa+ " ' مطمئن هستید؟" +"</font>",
                            icon: "[SKIN]ask.png",
                            title: "تائید حذف",
                            buttons: [isc.IButtonSave.create({title: "بله"}), isc.IButtonCancel.create({
                                title: "خیر"
                            })],
                            buttonClick: function (button, index) {
                                this.close();

                                if (index == 0) {
                                    deleteJobGroupFromAllCompetence(record.id);
                                    simpleDialog("پیغام", "حذف با موفقیت انجام گردید.", 0, "confirm");
                                }
                            }
                        });


                        // ListGrid_Job_Group_Competence.invalidateCache();

                    }
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

                        // RestDataSource_All_Jobs.fetchDataURL = jobGroupUrl + record.id + "/unAttachJobs";
                        // RestDataSource_All_Jobs.invalidateCache();
                        // RestDataSource_All_Jobs.fetchData();
                        ListGrid_AllJobs.fetchData();
                        ListGrid_AllJobs.invalidateCache();


                        RestDataSource_ForThisJobGroup_GetJobs.fetchDataURL = jobGroupUrl + record.id + "/getJobs"
                        // RestDataSource_ForThisJobGroup_GetJobs.invalidateCache();
                        // RestDataSource_ForThisJobGroup_GetJobs.fetchData();
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
        sortField: 5,
        autoFetchData: true,
        selectionType: "single",
        selectionUpdated: function () {
            selectionUpdated_JobGroupGroup();
        },
        doubleClick: function () {
            ListGrid_Job_Group_edit();
        },
        getCellCSSText: function (record) {
            if (record.competenceCount === 0)
                return "color:red;font-size: 12px;";
        },
    });
    var Menu_ListGrid_Job_Group_Competences = isc.Menu.create({
        width: 150,
        data: [{
            title: "بازخوانی اطلاعات", icon: "<spring:url value="refresh.png"/>", click: function () {
                ListGrid_Job_Group_Competence_refresh();
            }
        }, {
            title: " حذف گروه شغل از  شایستگی مربوطه", icon: "<spring:url value="remove.png"/>", click: function () {
                activeJobGroup = ListGrid_Job_Group_Jsp.getSelectedRecord();
                activeCompetence = ListGrid_Job_Group_Competence.getSelectedRecord();
                if (activeJobGroup == null || activeCompetence == null) {
                    simpleDialog("پیام", "شایستگی یا گروه شغل انتخاب نشده است.", 0, "confirm");

                } else {
                    var Dialog_Delete = isc.Dialog.create({
                        message: getFormulaMessage("آیا از حذف  گروه شغل:' ", "2", "black", "c") + getFormulaMessage(activeJobGroup.titleFa, "3", "red", "U") + getFormulaMessage(" از  شایستگی:' ", "2", "black", "c") + getFormulaMessage(activeCompetence.titleFa, "3", "red", "U") + getFormulaMessage(" ' مطمئن هستید؟", "2", "black", "c"),//"<font size='2' color='red'>"+"آیا از حذف گروه شغل:' " +record.titleFa+ " ' مطمئن هستید؟" +"</font>",
                        icon: "[SKIN]ask.png",
                        title: "تائید حذف",
                        buttons: [isc.IButtonSave.create({title: "بله"}), isc.IButtonCancel.create({
                            title: "خیر"
                        })],
                        buttonClick: function (button, index) {
                            this.close();

                            if (index == 0) {
                                deleteCompetenceFromJobGroup(activeCompetence.id, activeJobGroup.id);
                            }
                        }
                    });

                }
            }
        },

        ]
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
        titleWidth: "400",
        width: "700",
        align: "right",
        autoDraw: false,
        fields: [
            {
                name: "sgTitle",
                type: "staticText",
                title: "افزودن شغل به گروه شغل:",
                wrapTitle: false,
                width: 250
            }
        ]
    });
    var ListGrid_AllJobs = isc.TrLG.create({
        //title:"تمام شغل ها",
        width: "100%",
        height: "100%", canDragResize: true,
        canDragRecordsOut: true,
        canAcceptDroppedRecords: true,
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
            {name: "titleEn", title: "نام لاتین شغل", align: "center", hidden: true},
            {name: "description", title: "توضیحات", align: "center", hidden: true},
            {name: "version", title: "version", canEdit: false, hidden: true}
        ],
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 22,
        showFilterEditor: true,
        filterOnKeypress: true,
        dragTrackerMode: "title",
        canDrag: true,
        selectionAppearance: "checkbox",
        selectionType: "simple",
        recordDrop: function (dropRecords, targetRecord, index, sourceWidget) {
            let jobGroupRecord = ListGrid_Job_Group_Jsp.getSelectedRecord();
            let jobGroupId = jobGroupRecord.id;
            let jobIds = [];
            for (let i = 0; i < dropRecords.getLength(); i++) {
                jobIds.add(dropRecords[i].id);
            }
            let JSONObj = {"ids": jobIds};
            wait.show();
            isc.RPCManager.sendRequest({
                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                actionURL: jobGroupUrl + "removeJobs/" + jobGroupId + "/" + jobIds,
                httpMethod: "DELETE",
                data: JSON.stringify(JSONObj),
                serverOutputAsString: false,
                callback: function (resp) {
                    wait.close();
                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                        ListGrid_ForThisJobGroup_GetJobs.invalidateCache();
                        ListGrid_AllJobs.invalidateCache();
                    } else {
                        isc.say("خطا");
                    }
                }
            });
        }

    });
    var ListGrid_ForThisJobGroup_GetJobs = isc.TrLG.create({
        //title:"تمام شغل ها",
        width: "100%",
        height: "100%",
        canDragRecordsOut: true,
        canAcceptDroppedRecords: true,
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
            {name: "OnDelete", title: "حذف", align: "center"}
        ],
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
                    prompt: "remove",
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

                                    // RestDataSource_ForThisJobGroup_GetJobs.removeRecord(activeJob);
                                    ListGrid_AllJobs.invalidateCache();
                                    ListGrid_ForThisJobGroup_GetJobs.invalidateCache();
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
        recordDrop: function (dropRecords, targetRecord, index, sourceWidget) {
            let jobGroupRecord = ListGrid_Job_Group_Jsp.getSelectedRecord();
            let jobGroupId = jobGroupRecord.id;
            let jobIds = [];
            for (let i = 0; i < dropRecords.getLength(); i++) {
                jobIds.add(dropRecords[i].id);
            }
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
                        ListGrid_ForThisJobGroup_GetJobs.invalidateCache();
                        ListGrid_AllJobs.invalidateCache();
                    } else {
                        isc.say("خطا");
                    }
                }
            });
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
                    ListGrid_AllJobs
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
                    ListGrid_ForThisJobGroup_GetJobs
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
            ListGrid_Job_Group_Competence.invalidateCache();
            ListGrid_Job_Group_Jobs.invalidateCache();
            this.hide();
        },
        items: [
            VLayOut_JobGroup_Jobs_Jsp
        ]
    });
    var RestDataSource_Job_Group_Competencies_Jsp = isc.TrDS.create({
        fields: [
            {name: "id"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "description"},
            {name: "version"}
        ]
        //,fetchDataURL:"${restApiUrl}/api/job-group/?/getCompetences"
    });
    
    var ListGrid_Job_Group_Jobs = isc.TrLG.create({
        width: "100%",
        height: "100%",
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        showResizeBars: true,
        dataSource: RestDataSource_Job_Group_Jobs_Jsp,
        contextMenu: Menu_ListGrid_Job_Group_Jobs,
        fields: [{name: "code",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            }, {name: "titleFa"}, {name: "competenceCount"}, {name: "personnelCount"}],
        sortField: 1,
        sortDirection: "descending",
        autoFetchData: false,
    });
    
    var ListGrid_Job_Group_Competence = isc.TrLG.create({
        width: "100%",
        height: "100%",
        showResizeBars: true,
        dataSource: RestDataSource_Job_Group_Competencies_Jsp,
        contextMenu: Menu_ListGrid_Job_Group_Competences,
        doubleClick: function () {
            //    ListGrid_Job_Group_edit();
        },
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "titleFa", title: "نام شایستگی", align: "center"},
            {name: "titleEn", title: "نام لاتین شایستگی ", align: "center"},
            {name: "description", title: "توضیحات", align: "center"},
            {name: "version", title: "version", canEdit: false, hidden: true}
        ],
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 22,
        autoFetchData: false,
        showFilterEditor: true,
        filterOnKeypress: true,
        sortFieldAscendingText: "مرتب سازی صعودی ",
        sortFieldDescendingText: "مرتب سازی نزولی",
        configureSortText: "تنظیم مرتب سازی",
        autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
        autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
        filterUsingText: "فیلتر کردن",
        groupByText: "گروه بندی",
        freezeFieldText: "ثابت نگه داشتن"
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
            var data = DynamicForm_Job_Group_Jsp.getValues();

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
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                        var OK = isc.Dialog.create({
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
                        var ERROR = isc.Dialog.create({
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
            //  var xx;
            //  yesNoDialog("taeed","salam???",0,"stop",xx);
            //
            // if(parseInt(xx)==0){
            // }
            // else{
            //     }


            ListGrid_Job_Group_refresh();
            //ListGrid_Job_Group_Competence_refresh();
            //ListGrid_Job_Group_Jobs_refresh();
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
                // RestDataSource_All_Jobs.fetchDataURL = jobGroupUrl + record.id + "/unAttachJobs";
                // RestDataSource_All_Jobs.fetchDataURL = jobUrl + "/iscList";
                ListGrid_AllJobs.fetchData();
                ListGrid_AllJobs.invalidateCache();

                RestDataSource_ForThisJobGroup_GetJobs.fetchDataURL = jobGroupUrl + record.id + "/getJobs";
                ListGrid_ForThisJobGroup_GetJobs.invalidateCache();
                ListGrid_ForThisJobGroup_GetJobs.fetchData();
                DynamicForm_thisJobGroupHeader_Jsp.setValue("sgTitle", getFormulaMessage(record.titleFa, "2", "red", "B"));
                Window_Add_Job_to_JobGroup.show();


                //Window_Add_Job_to_JobGroup.
                //   Window_Add_Job_to_JobGroup.show();

            }
        }
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

    PersonnelLG_JobGroup = isc.TrLG.create({
        dataSource: PersonnelDS_JobGroup,
        selectionType: "single",
        alternateRecordStyles: true,
        groupByField: "jobTitle",
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

    NALG_JobGroup = isc.TrLG.create({
        dataSource: NADS_JobGroup,
        selectionType: "none",
        autoFetchData: false,
        alternateRecordStyles: true,
        showAllRecords: true,
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
            {name: "code", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "job.titleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "job.code", title: "<spring:message code="job.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "postGrade.titleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "area", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "assistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "section", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterCode", title: "<spring:message code="reward.cost.center.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterTitleFa", title: "<spring:message code="reward.cost.center.title"/>", filterOperator: "iContains", autoFitWidth: true}

        ],
        fetchDataURL: postUrl + "/iscList"
    });

    PostLG_JobGroup = isc.TrLG.create({
        dataSource: PostDS_JobGroup,
        autoFetchData: false,
        showResizeBar: true,
        sortField: 0,
        groupByField: "job.titleFa",
        fields: [
            {name: "code",
                filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                }
            },
            {name: "titleFa"},
            {name: "job.titleFa"},
            {name: "postGrade.titleFa"},
            {name: "area"},
            {name: "assistance"},
            {name: "affairs"},
            {name: "section"},
            {name: "unit"},
            {name: "costCenterCode",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "costCenterTitleFa"}
        ],
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

    function ListGrid_Job_Group_Competence_refresh() {

        if (ListGrid_Job_Group_Jsp.getSelectedRecord() == null)
            ListGrid_Job_Group_Competence.setData([]);
        else
            refreshLG(ListGrid_Job_Group_Competence);
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

    function deleteCompetenceFromJobGroup(competenceId, jobGroupId) {
        isc.RPCManager.sendRequest({
            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
            useSimpleHttp: true,
            contentType: "application/json; charset=utf-8",
            actionURL: jobGroupUrl + "removeCompetence/" + jobGroupId + "/" + competenceId,
            httpMethod: "DELETE",
            serverOutputAsString: false,
            callback: function (resp) {
                if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                    ListGrid_Job_Group_Competence.invalidateCache();

                } else {
                    isc.say("خطا در پاسخ سرویس دهنده");
                }
            }
        });
    }

    function deleteJobGroupFromAllCompetence(jobGroupId) {


        isc.RPCManager.sendRequest({
            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
            useSimpleHttp: true,
            contentType: "application/json; charset=utf-8",
            actionURL: jobGroupUrl + "removeAllCompetence/" + jobGroupId + "/",
            httpMethod: "DELETE",
            serverOutputAsString: false,
            callback: function (resp) {
                if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                    ListGrid_Job_Group_Competence.invalidateCache();

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
                                    ListGrid_Job_Group_Competence.setData([]);

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
        refreshLG(ListGrid_Job_Group_Jsp);
        ListGrid_Job_Group_Jobs.setData([]);
        PostLG_JobGroup.setData([]);
        PersonnelLG_JobGroup.setData([]);
        NALG_JobGroup.setData([]);
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

        switch (tab.name) {
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
                postJob_JobGroup = jobGroup.id;
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
        }
    }

    // </script>