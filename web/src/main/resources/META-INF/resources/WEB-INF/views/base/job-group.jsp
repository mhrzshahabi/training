<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="Spring" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// script
    var method = "POST";
    var RestDataSource_Job_Group_Jsp = isc.TrDS.create({
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "titleFa", title: "نام گروه شغل", align: "center", filterOperator: "iContains"},
            {name: "titleEn", title: "نام لاتین گروه شغل ", align: "center", filterOperator: "iContains"},
            {name: "description", title: "توضیحات", align: "center"},
            {name: "version", title: "version", canEdit: false, hidden: true}
        ],
        fetchDataURL: jobGroupUrl + "spec-list"
    });
    var RestDataSource_Job_Group_Jobs_Jsp = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa"},
            {name: "code"},
            // {name: "description"},
            // {name: "version"}
        ]
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
        , fetchDataURL: jobUrl + "iscList"
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
        }, {isSeparator: true},
            {
                title: "چاپ همه گروه شغل ها", icon: "<spring:url value="pdf.png"/>",
                click: "window.open('job-group/print/pdf/<%=accessToken%>/')"
            },
            {
                title: "چاپ با جزئیات", icon: "<spring:url value="pdf.png"/>",
                click: "window.open('job-group/printDetail/pdf/<%=accessToken%>/'+ListGrid_Job_Group_Jsp.getSelectedRecord().id)"
            },
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

                        // alert(record.id);
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
        selectionType: "multiple",
        dataSource: RestDataSource_Job_Group_Jsp,
        contextMenu: Menu_ListGrid_Job_Group_Jsp,
        selectionChange: function (record, state) {
            record = ListGrid_Job_Group_Jsp.getSelectedRecord();
            if (record == null || record.id == null) {
            } else {
                // RestDataSource_Job_Group_Competencies_Jsp.fetchDataURL = jobGroupUrl + record.id + "/getCompetences"
                RestDataSource_Job_Group_Jobs_Jsp.fetchDataURL = jobGroupUrl + record.id + "/getJobs";
                ListGrid_Job_Group_Jobs.fetchData();
                ListGrid_Job_Group_Jobs.invalidateCache();
                // RestDataSource_Job_Group_Competencies_Jsp.invalidateCache();
                // RestDataSource_Job_Group_Competencies_Jsp.fetchData();
                // RestDataSource_Job_Group_Jobs_Jsp.invalidateCache();
                // RestDataSource_Job_Group_Jobs_Jsp.fetchData();
                // ListGrid_Job_Group_Competence.invalidateCache();
                // ListGrid_Job_Group_Competence.fetchData();
            }
        },
        doubleClick: function () {
            ListGrid_Job_Group_edit();
        },
        sortField: 1,
        autoFetchData: true,
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
    var ListGrid_AllJobs = isc.ListGrid.create({
        //title:"تمام شغل ها",
        width: "100%",
        height: "100%", canDragResize: true,
        canDragRecordsOut: true,
        canAcceptDroppedRecords: true,
        autoFetchData: false,
        dataSource: RestDataSource_All_Jobs,
        fields: [
            {name: "id", title: "id", primaryKey: true, hidden: true},
            {name: "code", title: "کد شغل", align: "center", width: "20%"},
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
        sortFieldAscendingText: "مرتب سازی صعودی ",
        sortFieldDescendingText: "مرتب سازی نزولی",
        configureSortText: "تنظیم مرتب سازی",
        autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
        autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
        filterUsingText: "فیلتر کردن",
        groupByText: "گروه بندی",
        freezeFieldText: "ثابت نگه داشتن",


        recordDrop: function (dropRecords, targetRecord, index, sourceWidget) {

            // var activeJob = record;
            // var activeJobId = activeJob.id;
            // var activeJobGroup = ListGrid_Job_Group_Jsp.getSelectedRecord();
            // var activeJobGroupId = activeJobGroup.id;

            var jobGroupRecord = ListGrid_Job_Group_Jsp.getSelectedRecord();
            var jobGroupId = jobGroupRecord.id;
            //  alert(jobGroupId);
            // var jobId=dropRecords[0].id;
            var jobIds = new Array();
            for (i = 0; i < dropRecords.getLength(); i++) {
                jobIds.add(dropRecords[i].id);
            }
            ;

            //  alert("${restApiUrl}/api/job-group/addJobs/"+jobGroupId+"/"+jobIds);

            var JSONObj = {"ids": jobIds};
            isc.RPCManager.sendRequest({
                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                actionURL: jobGroupUrl + "removeJobs/" + jobGroupId + "/" + jobIds,
                httpMethod: "DELETE",
                data: JSON.stringify(JSONObj),
                serverOutputAsString: false,
                callback: function (resp) {
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {

                        ListGrid_ForThisJobGroup_GetJobs.invalidateCache();
                        ListGrid_AllJobs.invalidateCache();


                    } else {
                        isc.say("خطا");
                    }
                }
            });
        }

    });
    var ListGrid_ForThisJobGroup_GetJobs = isc.ListGrid.create({
        //title:"تمام شغل ها",
        width: "100%",
        height: "100%",
        canDragRecordsOut: true,
        canAcceptDroppedRecords: true,
        //showRowNumbers: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,

        dataSource: RestDataSource_ForThisJobGroup_GetJobs,
        fields: [
            {name: "id", title: "id", primaryKey: true, hidden: true},
            {name: "code", title: "کد شغل", align: "center", width: "20%"},
            {name: "titleFa", title: "نام شغل", align: "center", width: "70%"},
            {name: "OnDelete", title: "حذف", align: "center"}
        ],

        //--------------------------------------------


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


        //----------------------------------------------------


        recordDrop: function (dropRecords, targetRecord, index, sourceWidget) {

            // alert(dropRecords[0].titleFa);


            var jobGroupRecord = ListGrid_Job_Group_Jsp.getSelectedRecord();
            var jobGroupId = jobGroupRecord.id;
            //  alert(jobGroupId);
            // var jobId=dropRecords[0].id;
            var jobIds = new Array();
            for (i = 0; i < dropRecords.getLength(); i++) {
                jobIds.add(dropRecords[i].id);
            }
            ;
            var JSONObj = {"ids": jobIds};


            TrDSRequest()


            isc.RPCManager.sendRequest({
                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                actionURL: jobGroupUrl + "addJobs/" + jobGroupId + "/" + jobIds, //"${restApiUrl}/api/tclass/addStudents/" + ClassID,
                httpMethod: "POST",
                data: JSON.stringify(JSONObj),
                serverOutputAsString: false,
                callback: function (resp) {
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {

                        ListGrid_ForThisJobGroup_GetJobs.invalidateCache();
                        ListGrid_AllJobs.invalidateCache();

                        // var OK = isc.Dialog.create({
                        //     message: "عملیات با موفقیت انجام شد",
                        //     icon: "[SKIN]say.png",
                        //     title: "پیام موفقیت"
                        // });
                        // setTimeout(function () {
                        //     // OK.close();
                        // }, 3000);
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
        sortFieldAscendingText: "مرتب سازی صعودی ",
        sortFieldDescendingText: "مرتب سازی نزولی",
        configureSortText: "تنظیم مرتب سازی",
        autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
        autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
        filterUsingText: "فیلتر کردن",
        groupByText: "گروه بندی",
        freezeFieldText: "ثابت نگه داشتن"


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


    var ListGrid_Job_Group_Jobs = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        showResizeBars: true,
        filterOnKeypress: true,
        dataSource: RestDataSource_Job_Group_Jobs_Jsp,
        contextMenu: Menu_ListGrid_Job_Group_Jobs,
        doubleClick: function () {
            //    ListGrid_Job_Group_edit();
        },
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "titleFa", title: "نام شغل", align: "center", filterOperator: "iContains"},
            {name: "code", title: "کد شغل ", align: "center", filterOperator: "iContains"},
            // {name: "description", title: "توضیحات", align: "center"},
            {name: "version", title: "version", canEdit: false, hidden: true}
        ],
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 22,
        autoFetchData: false,
        showFilterEditor: true,
        sortFieldAscendingText: "مرتب سازی صعودی ",
        sortFieldDescendingText: "مرتب سازی نزولی",
        configureSortText: "تنظیم مرتب سازی",
        autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
        autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
        filterUsingText: "فیلتر کردن",
        groupByText: "گروه بندی",
        freezeFieldText: "ثابت نگه داشتن"
    });


    var ListGrid_Job_Group_Competence = isc.ListGrid.create({
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

    var ToolStripButton_Refresh_Job_Group_Jsp = isc.ToolStripButtonRefresh.create({
        // icon: "<spring:url value="refresh.png"/>",
        title: "بازخوانی اطلاعات",
        click: function () {
            //  var xx;
            //  yesNoDialog("taeed","salam???",0,"stop",xx);
            //
            // if(parseInt(xx)==0){
            //     alert("yes selected");
            // }
            // else{
            //     alert("noSelected");
            //     }

// alert("abcdef");

            ListGrid_Job_Group_refresh();
            //ListGrid_Job_Group_Competence_refresh();
            //ListGrid_Job_Group_Jobs_refresh();
        }
    });
    var ToolStripButton_Edit_Job_Group_Jsp = isc.ToolStripButtonEdit.create({
        // icon: "[SKIN]/actions/edit.png",
        title: "ویرایش",
        click: function () {

            ListGrid_Job_Group_edit();
        }
    });
    var ToolStripButton_Add_Job_Group_Jsp = isc.ToolStripButtonAdd.create({
        // icon: "[SKIN]/actions/add.png",
        title: "ایجاد",
        click: function () {

            ListGrid_Job_Group_add();
        }
    });
    var ToolStripButton_Remove_Job_Group_Jsp = isc.ToolStripButtonRemove.create({
        //icon: "[SKIN]/actions/remove.png",
        title: "حذف",
        click: function () {
            ListGrid_Job_Group_remove();
        }
    });

    var ToolStripButton_Print_Job_Group_Jsp = isc.ToolStripButtonPrint.create({
        menu: isc.Menu.create({
            data: [
                {
                    title: "<spring:message code="print"/>", icon: "<spring:url value="print.png"/>", submenu: [
                        {
                            title: "<spring:message code="format.pdf"/>", icon: "<spring:url value="pdf.png"/>",
                            click: "window.open('job-group/print/pdf/<%=accessToken%>')"
                        },
                        {
                            title: "<spring:message code="format.excel"/>", icon: "<spring:url value="excel.png"/>",
                            click: "window.open('job-group/print/excel/<%=accessToken%>')"
                        },
                        {
                            title: "<spring:message code="format.html"/>", icon: "<spring:url value="html.png"/>",
                            click: "window.open('job-group/print/html/<%=accessToken%>')"
                        }

                    ]
                },
                {
                    title: "<spring:message code="print.Detail"/>", icon: "<spring:url value="print.png"/>", submenu: [
                        {
                            title: "<spring:message code="format.pdf"/>", icon: "<spring:url value="pdf.png"/>",
                            click: "window.open('job-group/printDetail/pdf/<%=accessToken%>/'+ListGrid_Job_Group_Jsp.getSelectedRecord().id)"
                        },
                        {
                            title: "<spring:message code="format.excel"/>", icon: "<spring:url value="excel.png"/>",
                            click: "window.open('job-group/printDetail/excel/<%=accessToken%>/'+ListGrid_Job_Group_Jsp.getSelectedRecord().id)"
                        },
                        {
                            title: "<spring:message code="format.html"/>", icon: "<spring:url value="html.png"/>",
                            click: "window.open('job-group/printDetail/html/<%=accessToken%>/'+ListGrid_Job_Group_Jsp.getSelectedRecord().id)"
                        }
                    ]
                },
            ]
        })
    });
    var ToolStripButton_Add_Job_Group_AddJob_Jsp = isc.ToolStripButton.create({
        icon: "<spring:url value="job.png"/>",
        title: "لیست شغل ها",
        click: function () {
            var record = ListGrid_Job_Group_Jsp.getSelectedRecord();
            //  alert(Window_Add_Job_to_JobGroup.DynamicForm[0].fields[0]);
            // alert(DynamicForm_thisJobGroupHeader_Jsp.getItem("titleFa"));

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
                // RestDataSource_All_Jobs.fetchDataURL = jobUrl + "iscList";
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
            ToolStripButton_Print_Job_Group_Jsp,
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


    var HLayout_Actions_Job_Group_Jsp = isc.HLayout.create({
        width: "100%",
        members: [ToolStrip_Actions_Job_Group_Jsp]
    });


    var Detail_Tab_Job_Group = isc.TabSet.create({
        tabBarPosition: "top",
        width: "100%",
        height: "100%",
        tabs: [
            {
                id: "TabPane_Job_Group_Job",
                title: "لیست شغل ها",
                pane: ListGrid_Job_Group_Jobs

            },
            // {
            //     id: "TabPane_Job_Group_Competence",
            //     title: "لیست شایستگی ها",
            //     visable:false,
            //     pane: ListGrid_Job_Group_Competence
            // }
            // ,{
            //     id: "TabPane_Job_Group_Competence",
            //     title: "لیست پستهای این گروه شغل",
            //     visable:false,
            //     pane: ListGrid_Job_Group_Competence
            // }
        ]
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
            ListGrid_Job_Group_Jobs.invalidateCache();
    }

    function ListGrid_Job_Group_Competence_refresh() {

        if (ListGrid_Job_Group_Jsp.getSelectedRecord() == null)
            ListGrid_Job_Group_Competence.setData([]);
        else
            ListGrid_Job_Group_Competence.invalidateCache();
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
    };

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
    };

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
    };

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
    };

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
                        var wait = isc.Dialog.create({
                            message: "در حال انجام عملیات...",
                            icon: "[SKIN]say.png",
                            title: "پیام"
                        });
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
    };

    function ListGrid_Job_Group_refresh() {
        ListGrid_Job_Group_Jsp.invalidateCache();
        ListGrid_Job_Group_Jobs_refresh();
        ListGrid_Job_Group_Competence_refresh();


    };

    function ListGrid_Job_Group_add() {
        method = "POST";
        url = jobGroupUrl;
        DynamicForm_Job_Group_Jsp.clearValues();
        Window_Job_Group_Jsp.show();
    };
