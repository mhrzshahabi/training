<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

//<script>

    let jobMethod;
    let jobCompetenceMethod_job;

    //****************************************************************************************************************
    // Menu
    //****************************************************************************************************************
    Menu_Job_job = isc.Menu.create({
        data: [
            {
                title: "بازخوانی", icon: "pieces/16/refresh.png", click: function () {
                    refresh_JobListGrid();
                }
            }, {
                title: "ایجاد", icon: "pieces/16/icon_add.png", click: function () {
                    show_JobNewForm();
                }
            }, {
                title: "ویرایش", icon: "pieces/16/icon_edit.png", click: function () {
                    show_JobEditForm();
                }
            }, {
                title: "حذف", icon: "pieces/16/icon_delete.png", click: function () {
                    show_JobRemoveForm();
                }
            }, {isSeparator: true}, {
                title: "ارسال به Pdf", icon: "icon/pdf.png", click: function () {
                }
            }, {
                title: "ارسال به Excel", icon: "icon/excel.png", click: function () {
                }
            }, {
                title: "ارسال به Html", icon: "icon/html.jpg", click: function () {
                }
            }]
    });
    //****************************************************************************************************************
    // RestDataSource & ListGrid
    //****************************************************************************************************************
    let DS_Job_job = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "titleFa", title: "عنوان شغل", align: "center"},
            {name: "titleEn", title: "عنوان انگليسي", align: "center"},
            {name: "code", title: "کد شغل", align: "center"},
            {name: "costCenter", title: "مرکز هزينه", align: "center"},
            {name: "description", title: "توضيحات", align: "center"}],
        fetchDataURL: jobUrl + "spec-list"
    });

    let LG_Job_job = isc.MyListGrid.create({
        dataSource: DS_Job_job,
        autoFetchData: true,
        contextMenu: Menu_Job_job,
        doubleClick: function () {
            show_JobEditForm();
        },
        selectionUpdated: function (record, state) {
            refresh_JobCompetenceListGrid();
        },
        sortField: 0,
    });

    let DS_JobCompetence_job = isc.MyRestDataSource.create({
        fields: [
            {name: "competence.id", primaryKey: true, canEdit: false, hidden: true},
            {name: "competence.titleFa", title: "عنوان شايستگي", align: "center"},
            {name: "competence.titleEn", title: "عنوان انگليسي", align: "center"},
            {name: "competence.etechnicalType.titleFa", title: "نوع تخصص", align: "center"},
            {name: "competence.ecompetenceInputType.titleFa", title: "نوع ورودي", align: "center"},
            {name: "ejobCompetenceType.titleFa", title: "نوع ارتباط شغل با شايستگي", align: "center"},
            {name: "competence.description", title: "توضيحات", align: "center"},],
    });

    let LG_JobCompetence_job = isc.MyListGrid.create({
        dataSource: DS_JobCompetence_job,
        doubleClick: function () {
            show_JobCompetenceEditForm();
        },
    });

    let DS_Competence_job = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "titleFa", title: "عنوان شايستگي", align: "center"},
            {name: "titleEn", title: "عنوان انگليسي", align: "center"},
            {name: "etechnicalType.titleFa", title: "نوع تخصص", align: "center"},
            {name: "ecompetenceInputType.titleFa", title: "نوع ورودي", align: "center"},
            {name: "description", title: "توضيحات", align: "center"},],
    });

    let LG_Competence_job = isc.MyListGrid.create({
        dataSource: DS_Competence_job,
        height: 200,
        selectionType: "multiple",
        autoDraw: false,
        showResizeBar: false,
    });

    let DS_eJobCompetenceType_job = isc.MyRestDataSource.create({
        fields: [
            {name: "id", hidden: true},
            {name: "titleFa"},],
        fetchDataURL: enumUrl + "eJobCompetenceType/spec-list"
    });

    //****************************************************************************************************************
    // ToolStrip
    //****************************************************************************************************************

    let TS_JobActions_job = isc.MyToolStrip.create({
        members: [
            isc.MyRefreshButton.create({
                click: function () {
                    refresh_JobListGrid();
                }
            }), isc.MyCreateButton.create({
                click: function () {
                    show_JobNewForm();
                }
            }), isc.MyEditButton.create({
                click: function () {
                    show_JobEditForm();
                }
            }), isc.MyRemoveButton.create({
                click: function () {
                    show_JobRemoveForm();
                }
            }), isc.MyPrintButton.create({
                click: function () {
                }
            }),
        ]
    });

    let TS_JobCompetenceActions_job = isc.MyToolStrip.create({
        members: [
            isc.MyRefreshButton.create({
                click: function () {
                    refresh_JobCompetenceListGrid();
                }
            }), isc.MyCreateButton.create({
                title: "افزودن شايستگي شغلي به شغل",
                click: function () {
                    show_JobCompetenceNewForm();
                }
            }), isc.MyEditButton.create({
                click: function () {
                    show_JobCompetenceEditForm();
                }
            }), isc.MyRemoveButton.create({
                click: function () {
                    show_JobCompetenceRemoveForm();
                }
            }), isc.MyPrintButton.create({
                click: function () {
                }
            }),
        ]
    });

    //****************************************************************************************************************
    // DynamicForm & Window
    //****************************************************************************************************************

    let DF_Job_job = isc.MyDynamicForm.create({
        ID: "DF_Job_job",
        fields: [
            {name: "id", hidden: true},
            {
                name: "titleFa", title: "عنوان شغل",
                required: true, keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]", length: "250",
                width: "*", height: 27, hint: "Persian/فارسی", showHintInField: true,
                validators: [MyValidators.NotEmpty],
            },
            {
                name: "titleEn", title: "عنوان انگليسي",
                keyPressFilter: "[a-z|A-Z |]", length: "250",
                width: "*", height: 27, hint: "English/انگليسي", showHintInField: true,
            },
            {
                name: "code", title: "کد شغل",
                required: true, keyPressFilter: "[/|0-9]", length: "15",
                width: "*", height: 27,
            },
            {
                name: "costCenter", title: "مرکز هزينه",
                required: true, keyPressFilter: "[0-9]", length: "12",
                width: "*", height: 27, hint: "Numeric/اعداد", showHintInField: true,
                validators: [{
                    type: "lengthRange", min: "12", max: "12", errorMessage: "مرکز هزينه 12 رقمي است."
                }]
            },
            {
                name: "description", title: "توضيحات",
                length: "250", width: "*", height: 27,
            },
        ]
    });

    let Win_Job_job = isc.MyWindow.create({
        title: "شغل",
        width: 500,
        items: [DF_Job_job, isc.MyHLayoutButtons.create({
            members: [isc.MyButton.create({
                title: "ذخیره",
                click: function () {
                    save_Job();
                }
            }), isc.MyButton.create({
                title: "لغو",
                click: function () {
                    Win_Job_job.close();
                }
            })],
        }),]
    });

    let DF_JobInfo_job = isc.MyDynamicForm.create({
        ID: "DF_JobInfo_job",
        fields: [
            {name: "id", hidden: true},
            {name: "titleFa", title: "عنوان شغل", type: "staticText",},
            {name: "titleEn", title: "عنوان انگليسي", type: "staticText", showIf: "form.getValue('titleEn') != null",},
            {name: "code", title: "کد شغل", type: "staticText",},
            {name: "costCenter", title: "مرکز هزينه", type: "staticText",},
            {name: "description", title: "توضيحات", type: "staticText", showIf: "form.getValue('description') != null",},
        ]
    });

    let DF_CompetenceInfo_job = isc.MyDynamicForm.create({
        ID: "DF_CompetenceInfo_job",
        fields: [
            {name: "competence.id", hidden: true},
            {name: "competence.titleFa", title: "عنوان شايستگي", type: "staticText",},
            {name: "competence.titleEn", title: "عنوان انگليسي", type: "staticText", showIf: "form.getValue('competence.titleEn') != null",},
            {name: "competence.etechnicalType.titleFa", title: "نوع تخصص", type: "staticText"},
            {name: "competence.ecompetenceInputType.titleFa", title: "نوع ورودي", type: "staticText",},
            {name: "competence.description", title: "توضيحات", type: "staticText", showIf: "form.getValue('competence.description') != null",},
        ],
        visibility: "hidden"
    });

    let DF_JobCompetenceType_job = isc.MyDynamicForm.create({
        ID: "DF_JobCompetenceType_job",
        fields: [
            {
                name: "ejobCompetenceTypeId",
                title: "نوع ارتباط",
                required: true,
                editorType: "MyComboBoxItem",
                optionDataSource: DS_eJobCompetenceType_job,
                valueField: "id",
                displayField: "titleFa",
                sortField: ["titleFa"],
                width: "200",
            }
        ]
    });

    let Win_JobCompetence_job = isc.MyWindow.create({
            width: 1000,
            items: [
                isc.MyHLayout.create({
                    members: [
                        isc.MyVLayout.create({members: DF_JobInfo_job, width: "50%",}),
                        isc.MyVLayout.create({members: DF_CompetenceInfo_job, width: "50%"})],
                }),
                isc.MyHLayout.create({
                    members: [
                        isc.MyVLayout.create({members: DF_JobCompetenceType_job, width: "50%",})]
                }),
                LG_Competence_job,
                isc.MyHLayoutButtons.create({
                    members: [isc.MyButton.create({
                        title: "ذخیره",
                        click: function () {
                            save_JobCompetence();
                        }
                    }), isc.MyButton.create({
                        title: "لغو",
                        click: function () {
                            Win_JobCompetence_job.close();
                        }
                    })],
                }),
            ]
        })
    ;

    //****************************************************************************************************************
    // TabSet
    //****************************************************************************************************************

    let Tabs_Job_job = isc.MyTabSet.create({
        tabs: [{
            title: "ليست شايستگي هاي شغلي",
            pane: isc.MyVLayout.create({
                members: [TS_JobCompetenceActions_job, LG_JobCompetence_job]
            }),
        }]
    });

    isc.MyVLayout.create({
        members: [TS_JobActions_job, LG_Job_job, Tabs_Job_job],
    });

    //****************************************************************************************************************
    // Functions
    //****************************************************************************************************************

    function checkRecord(record, showDialog, msg, title,) {
        if (record ? (record.constructor === Array ? ((record.length > 0) ? true : false) : true) : false) {
            return true;
        }
        if (showDialog) {
            title = title ? title : "";
            msg = msg ? msg : "رکوردی انتخاب نشده است!";
            isc.MyOkDialog.create({
                message: msg,
                title: title,
            });
        }
        return false;
    };

    function refresh_JobListGrid() {
        LG_Job_job.invalidateCache();
        refresh_JobCompetenceListGrid();
    };



    function show_JobNewForm() {
        jobMethod = "POST";
        DF_Job_job.clearValues();
        Win_Job_job.show();
    };

    function show_JobEditForm() {
        let record = LG_Job_job.getSelectedRecord();
        if (checkRecord(record, true)) {
            jobMethod = "PUT";
            DF_Job_job.clearValues();
            DF_Job_job.editRecord(record);
            Win_Job_job.show();
        }
    };

    function save_Job() {
        if (!DF_Job_job.validate()) {
            return;
        }
        let jobData = DF_Job_job.getValues();
        let jobSaveUrl = jobUrl;
        if (jobMethod.localeCompare("PUT") == 0) {
            let jobRecord = LG_Job_job.getSelectedRecord();
            jobSaveUrl += jobRecord.id;
        }
        isc.RPCManager.sendRequest(MyDsRequest(jobSaveUrl, jobMethod, JSON.stringify(jobData), "callback: show_JobActionResult(rpcResponse)"));
    };

    function show_JobActionResult(resp) {
        let respCode = resp.httpResponseCode;
        if (respCode == 200 || respCode == 201) {
            isc.MyOkDialog.create({
                message: "عمليات با موفقيت اجرا شد.",
            });
            Win_Job_job.close();
            refresh_JobListGrid();
        } else {
            isc.MyOkDialog.create({
                message: "خطا در اجراي عمليات! کد خطا: " + resp.httpResponseCode,
            });
        }
    };

    function show_JobRemoveForm() {
        let record = LG_Job_job.getSelectedRecord();
        if (checkRecord(record, true)) {
            isc.MyYesNoDialog.create({
                message: "آیا رکورد انتخاب شده حذف گردد؟",
                buttonClick: function (button, index) {
                    this.close();
                    if (index == 0) {
                        isc.RPCManager.sendRequest(MyDsRequest(jobUrl + record.id, "DELETE", null, "callback: show_JobActionResult(rpcResponse)"));
                    }
                }
            });
        }
    };

    function refresh_JobCompetenceListGrid() {
        let record = LG_Job_job.getSelectedRecord();
        if (checkRecord(record)) {
            DS_JobCompetence_job.fetchDataURL = jobUrl + record.id + "/job-competence/spec-list";
            LG_JobCompetence_job.invalidateCache();
            LG_JobCompetence_job.fetchData();
        } else {
            LG_JobCompetence_job.setData([]);
        }
    };

    function show_JobCompetenceNewForm() {
        let record = LG_Job_job.getSelectedRecord();
        if (checkRecord(record, true, 'ابتدا يک شغل را انتخاب نمائيد.')) {

            jobCompetenceMethod_job = "POST";

            DF_JobInfo_job.clearValues();
            DF_JobInfo_job.editRecord(record);

            DF_CompetenceInfo_job.hide();

            DF_JobCompetenceType_job.clearValues();

            DS_Competence_job.fetchDataURL = competenceUrl + "job/not/" + record.id + "/spec-list";
            LG_Competence_job.invalidateCache();
            LG_Competence_job.fetchData();
            LG_Competence_job.show();
            Win_JobCompetence_job.setTitle("افزودن شايستگي شغلي به شغل");
            Win_JobCompetence_job.show();
        }
    };

    function save_JobCompetence() {
        if (!DF_JobCompetenceType_job.validate()) {
            return;
        }
        jobId = DF_JobInfo_job.getValue('id');
        eJobCompetenceTypeId = DF_JobCompetenceType_job.getValue('ejobCompetenceTypeId');
        if (jobCompetenceMethod_job.localeCompare("POST") == 0) {
            let competenceRecords = LG_Competence_job.getSelectedRecords();
            if (checkRecord(competenceRecords, true, 'حداقل يک شايستگي شغلي را انتخاب نمائيد.')) {
                let data = {"jobId": jobId, "competenceIds": competenceRecords.map(r => r.id), "eJobCompetenceTypeId": eJobCompetenceTypeId};
                isc.RPCManager.sendRequest(MyDsRequest(jobCompetenceUrl + "job", jobCompetenceMethod_job, JSON.stringify(data), "callback: show_JobCompetenceActionResult(rpcResponse)"));
            }
        } else {
            let competenceId = DF_CompetenceInfo_job.getValue('competence.id');
            let data = {"jobId": jobId, "competenceId": competenceId, "eJobCompetenceTypeId": eJobCompetenceTypeId};
            isc.RPCManager.sendRequest(MyDsRequest(jobCompetenceUrl, jobCompetenceMethod_job, JSON.stringify(data), "callback: show_JobCompetenceActionResult(rpcResponse)"));
        }
    };

    function show_JobCompetenceEditForm() {
        let jobRecord = LG_Job_job.getSelectedRecord();
        if (checkRecord(jobRecord, true, 'ابتدا يک شغل را انتخاب نمائيد.')) {
            let competenceRecord = LG_JobCompetence_job.getSelectedRecord();
            if (checkRecord(competenceRecord, true, 'يک شايستگي را انتخاب نمائيد.')) {

                jobCompetenceMethod_job = "PUT";

                DF_JobInfo_job.clearValues();
                DF_JobInfo_job.editRecord(jobRecord);

                DF_CompetenceInfo_job.clearValues();
                DF_CompetenceInfo_job.editRecord(competenceRecord);
                DF_CompetenceInfo_job.show();

                DF_JobCompetenceType_job.clearValues();
                DF_JobCompetenceType_job.editRecord(competenceRecord);

                LG_Competence_job.hide();
                Win_JobCompetence_job.setTitle("ويرايش نوع ارتباط شايستگي شغلي با شغل");
                Win_JobCompetence_job.show();
            }
        }
    };

    function show_JobCompetenceRemoveForm() {
        let jobRecord = LG_Job_job.getSelectedRecord();
        if (checkRecord(jobRecord, true, 'ابتدا يک شغل را انتخاب نمائيد.')) {
            let competenceRecord = LG_JobCompetence_job.getSelectedRecord();
            if (checkRecord(competenceRecord, true, 'يک شايستگي شغلي را انتخاب نمائيد.')) {
                isc.MyYesNoDialog.create({
                    message: "آیا رکورد انتخاب شده حذف گردد؟",
                    buttonClick: function (button, index) {
                        this.close();
                        actionUrl = jobCompetenceUrl + jobRecord.id + "/" + competenceRecord.competence.id;
                        if (index == 0) {
                            isc.RPCManager.sendRequest(MyDsRequest(actionUrl, "DELETE", null, "callback: show_JobCompetenceActionResult(rpcResponse)"));
                        }
                    }
                });
            }
        }
    };

    function show_JobCompetenceActionResult(resp) {
        respCode = resp.httpResponseCode;
        if (respCode == 200 || respCode == 201) {
            isc.MyOkDialog.create({
                message: "عمليات با موفقيت اجرا شد.",
            });
            Win_JobCompetence_job.close();
            refresh_JobCompetenceListGrid();
        } else {
            isc.MyOkDialog.create({
                message: "خطا در اجراي عمليات! کد خطا: " + resp.httpResponseCode,
            });
        }
    };