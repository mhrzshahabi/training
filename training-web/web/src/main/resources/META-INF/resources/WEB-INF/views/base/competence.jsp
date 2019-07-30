<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    let competenceMethod_competence;
    let jobCompetenceMethod_competence;


    //****************************************************************************************************************
    // Menu
    //****************************************************************************************************************
    Menu_Competence_competence = isc.Menu.create({
        data: [
            {
                title: "بازخوانی اطلاعات", icon: "pieces/16/refresh.png", click: function () {
                    refresh_CompetenceListGrid_competence();
                }
            }, {
                title: "ایجاد", icon: "pieces/16/icon_add.png", click: function () {
                    show_CompetenceNewForm_competence();
                }
            }, {
                title: "ویرایش", icon: "pieces/16/icon_edit.png", click: function () {
                    show_CompetenceEditForm_competence();
                }
            }, {
                title: "حذف", icon: "pieces/16/icon_delete.png", click: function () {
                    show_CompetenceRemoveForm_competence();
                }
            }, ]
    });
    //****************************************************************************************************************
    // RestDataSource & ListGrid
    //****************************************************************************************************************
    let DS_Competence_competence = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "titleFa", title: "عنوان شايستگي", align: "center"},
            {name: "titleEn", title: "عنوان انگليسي", align: "center"},
            {name: "etechnicalType.titleFa", title: "نوع تخصص", align: "center"},
            {name: "ecompetenceInputType.titleFa", title: "نوع ورودي", align: "center"},
            {name: "description", title: "توضيحات", align: "center"}],
        fetchDataURL: competenceUrl + "spec-list"
    });

    let LG_Competence_competence = isc.MyListGrid.create({
        dataSource: DS_Competence_competence,
        autoFetchData: true,
        contextMenu: Menu_Competence_competence,
        doubleClick: function () {
            show_CompetenceEditForm_competence();
        },
        selectionUpdated: function (record, state) {
            refresh_JobCompetenceListGrid_competence();
            refresh_SkillListGrid_competence();
            refresh_SkillGroupListGrid_competence();
            refresh_CourseListGrid_competence();
        },
        sortField: 0,
    });

    let DS_JobCompetence_competence = isc.MyRestDataSource.create({
        fields: [
            {name: "job.id", primaryKey: true, canEdit: false, hidden: true},
            {name: "job.titleFa", title: "عنوان شغل", align: "center"},
            {name: "job.titleEn", title: "عنوان انگليسي", align: "center"},
            {name: "job.code", title: "کد شغل", align: "center"},
            {name: "job.costCenter", title: "مرکز هزينه", align: "center"},
            {name: "job.description", title: "توضيحات", align: "center"},
            {name: "ejobCompetenceType.titleFa", title: "نوع ارتباط شغل با شايستگي", align: "center"},]
    });

    let LG_JobCompetence_competence = isc.MyListGrid.create({
        dataSource: DS_JobCompetence_competence,
        doubleClick: function () {
            show_JobCompetenceEditForm_competence();
        },
    });

    let DS_Job_competence = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "titleFa", title: "عنوان شغل", align: "center"},
            {name: "titleEn", title: "عنوان انگليسي", align: "center"},
            {name: "code", title: "کد شغل", align: "center"},
            {name: "costCenter", title: "مرکز هزينه", align: "center"},
            {name: "description", title: "توضيحات", align: "center"}],
    });

    let LG_Job_competence = isc.MyListGrid.create({
        dataSource: DS_Job_competence,
        height: 200,
        selectionType: "multiple",
        autoDraw: false,
        showResizeBar: false,
    });

    let DS_Skill_competence = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "titleFa", title: "عنوان مهارت", align: "center"},
            {name: "titleEn", title: "عنوان انگليسي", align: "center"},
            {name: "code", title: "کد", align: "center"},
            {name: "skillLevel.titleFa", title: "سطح مهارت", align: "center"},
            {name: "edomainType.titleFa", title: "حوزه", align: "center"},
            {name: "category.titleFa", title: "گروه", align: "center"},
            {name: "subCategory.titleFa", title: "زیر گروه", align: "center"},
            {name: "description", title: "توضيحات", align: "center"}]
    });

    let LG_Skill_competence = isc.MyListGrid.create({
        dataSource: DS_Skill_competence,
        doubleClick: function () {
        },
    });

    let DS_SkillGroup_competence = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "titleFa", title: "عنوان گروه مهارت", align: "center"},
            {name: "titleEn", title: "عنوان انگليسي", align: "center"},
            {name: "description", title: "توضيحات", align: "center"}]
    });

    let LG_SkillGroup_competence = isc.MyListGrid.create({
        dataSource: DS_SkillGroup_competence,
        doubleClick: function () {
        },
    });

    let DS_eTechnicalType_competence = isc.MyRestDataSource.create({
        fields: [
            {name: "id", hidden: true},
            {name: "titleFa"},],
        fetchDataURL: enumUrl + "eTechnicalType/spec-list"
    });

    let DS_eCompetenceInputType_competence = isc.MyRestDataSource.create({
        fields: [
            {name: "id", hidden: true},
            {name: "titleFa"},],
        fetchDataURL: enumUrl + "eCompetenceInputType/spec-list"
    });

    let DS_eJobCompetenceType_competence = isc.MyRestDataSource.create({
        fields: [
            {name: "id", hidden: true},
            {name: "titleFa"},],
        fetchDataURL: enumUrl + "eJobCompetenceType/spec-list"
    });

    var DS_Course_competence = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "titleFa", title: "عنوان دوره", align: "center"},
            {name: "titleEn", title: "عنوان انگلیسی", align: "center"},
            {name: "category.titleFa", title: "گروه", align: "center"},
            {name: "subCategory.titleFa", title: "زیرگروه", align: "center"},
            {name: "erunType.titleFa", title: "نوع اجرا", align: "center"},
            {name: "elevelType.titleFa", title: "سطح دوره", align: "center"},
            {name: "etheoType.titleFa", title: "نوع دوره", align: "center"},
            {name: "theoryDuration", title: "طول دوره (ساعت)", align: "center"},
            {name: "etechnicalType.titleFa", title: "نوع تخصص", align: "center"},
            {name: "minTeacherDegree", title: "حداقل مدرک استاد", align: "center"},
            {name: "minTeacherExpYears", title: "حداقل سابقه تدريس", align: "center"},
            {name: "minTeacherEvalScore", title: "حداقل نمره ارزيابي", align: "center"},
        ],
    });

    let LG_Course_competence  = isc.MyListGrid.create({
        dataSource: DS_Course_competence,
        doubleClick: function () {
        },
    });

    //****************************************************************************************************************
    // ToolStrip
    //****************************************************************************************************************

    let TS_CompetenceActions_competence = isc.MyToolStrip.create({
        members: [
            isc.MyRefreshButton.create({
                click: function () {
                    refresh_CompetenceListGrid_competence();
                }
            }), isc.MyCreateButton.create({
                click: function () {
                    show_CompetenceNewForm_competence();
                }
            }), isc.MyEditButton.create({
                click: function () {
                    show_CompetenceEditForm_competence();
                }
            }), isc.MyRemoveButton.create({
                click: function () {
                    show_CompetenceRemoveForm_competence();
                }
            }), ,
        ]
    });

    let TS_JobCompetenceActions_competence = isc.MyToolStrip.create({
        members: [
            isc.MyRefreshButton.create({
                click: function () {
                    refresh_JobCompetenceListGrid_competence();
                    refresh_SkillListGrid_competence();
                    refresh_SkillGroupListGrid_competence();
                    refresh_CourseListGrid_competence();
                }
            }), isc.MyCreateButton.create({
                title: "افزودن شغل به شايستگي شغلي",
                click: function () {
                    show_JobCompetenceNewForm_competence();
                }
            }), isc.MyEditButton.create({
                click: function () {
                    show_JobCompetenceEditForm_competence();
                }
            }), isc.MyRemoveButton.create({
                click: function () {
                    show_JobCompetenceRemoveForm_competence();
                }
            }),
        ]
    });
    //****************************************************************************************************************
    // DynamicForm & Window
    //****************************************************************************************************************

    let DF_Competence_competence = isc.MyDynamicForm.create({
        ID: "DF_Competence_competence",
        fields: [
            {name: "id", hidden: true},
            {
                name: "titleFa", title: "عنوان شايستگي",
                required: true, keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]", length: "250",
                width: "*", height: 27, hint: "Persian/فارسی", showHintInField: true,
                validators: [MyValidators.NotEmpty],
            }, {
                name: "titleEn", title: "عنوان انگليسي",
                keyPressFilter: "[a-z|A-Z |]", length: "250",
                width: "*", height: 27, hint: "English/انگليسي", showHintInField: true,
            },
            {
                name: "etechnicalType.id",
                dataPath: "etechnicalType.id",
                title: "نوع تخصص",
                required: true,
                editorType: "MyComboBoxItem",
                optionDataSource: DS_eTechnicalType_competence,
                valueField: "id",
                displayField: "titleFa",
                sortField: ["titleFa"],
            },
            {
                name: "ecompetenceInputType.id",
                dataPath: "ecompetenceInputType.id",
                title: "نوع ورودي",
                required: true,
                editorType: "MyComboBoxItem",
                optionDataSource: DS_eCompetenceInputType_competence,
                valueField: "id",
                displayField: "titleFa",
                sortField: ["titleFa"],
            },
            {
                name: "description", title: "توضيحات",
                length: "250", width: "*", height: 27,
            },
        ]
    });

    let Win_Competence_competence = isc.MyWindow.create({
        title: "شايستگي شغلي",
        width: 500,
        items: [DF_Competence_competence, isc.MyHLayoutButtons.create({
            members: [isc.MyButton.create({
                title: "ذخیره",
                icon: "pieces/16/save.png",
                click: function () {
                    save_Competence_competence();
                }
            }), isc.MyButton.create({
                title: "لغو",
                icon: "pieces/16/icon_delete.png",
                click: function () {
                    Win_Competence_competence.close();
                }
            })],
        }),]
    });

    let DF_CompetenceInfo_competence = isc.MyDynamicForm.create({
        ID: "DF_CompetenceInfo_competence",
        fields: [
            {name: "id", hidden: true},
            {name: "titleFa", title: "عنوان شايستگي", type: "staticText",},
            {name: "titleEn", title: "عنوان انگليسي", type: "staticText", showIf: "form.getValue('titleEn') != null",},
            {name: "etechnicalType.titleFa", title: "نوع تخصص", type: "staticText",},
            {name: "ecompetenceInputType.titleFa", title: "نوع ورودي", type: "staticText",},
            {
                name: "description",
                title: "توضيحات",
                type: "staticText",
                showIf: "form.getValue('description') != null",
            },
        ]
    });

    let DF_JobInfo_competence = isc.MyDynamicForm.create({
        ID: "DF_JobInfo_competence",
        fields: [
            {name: "job.id", hidden: true},
            {name: "job.titleFa", title: "عنوان شغل", type: "staticText",},
            {
                name: "job.titleEn",
                title: "عنوان انگليسي",
                type: "staticText",
                showIf: "form.getValue('job.titleEn') != null",
            },
            {name: "job.code", title: "کد شغل", type: "staticText",},
            {name: "job.costCenter", title: "مرکز هزينه", type: "staticText",},
            {
                name: "job.description",
                title: "توضيحات",
                type: "staticText",
                showIf: "form.getValue('job.description') != null",
            },
        ],
        visibility: "hidden"
    });

    let DF_JobCompetenceType_competence = isc.MyDynamicForm.create({
        ID: "DF_JobCompetenceType_competence",
        fields: [
            {
                name: "ejobCompetenceType.id",
                dataPath: "ejobCompetenceType.id",
                title: "نوع ارتباط",
                required: true,
                editorType: "MyComboBoxItem",
                optionDataSource: DS_eJobCompetenceType_competence,
                valueField: "id",
                displayField: "titleFa",
                sortField: ["titleFa"],
                width: "200",
            }
        ]
    });

    let Win_JobCompetence_competence = isc.MyWindow.create({
            title: "شايستگي شغلي - شغل",
            width: 1000,
            items: [
                isc.MyHLayout.create({
                    members: [
                        isc.MyVLayout.create({members: DF_CompetenceInfo_competence, width: "50%",}),
                        isc.MyVLayout.create({members: DF_JobInfo_competence, width: "50%"})],
                }),
                isc.MyHLayout.create({
                    members: [
                        isc.MyVLayout.create({members: DF_JobCompetenceType_competence, width: "50%",})]
                }),
                LG_Job_competence,
                isc.MyHLayoutButtons.create({
                    members: [isc.MyButton.create({
                        title: "ذخیره",
                        icon: "pieces/16/save.png",
                        click: function () {
                            save_JobCompetence_competence();
                        }
                    }), isc.MyButton.create({
                        title: "لغو",
                        icon: "pieces/16/icon_delete.png",
                        click: function () {
                            Win_JobCompetence_competence.close();
                        }
                    })],
                }),
            ]
        })
    ;
    //****************************************************************************************************************
    // TabSet
    //****************************************************************************************************************

    let Tabs_Competence_competence = isc.MyTabSet.create({
        tabs: [{
            title: "ليست شغل ها",
            pane: isc.MyVLayout.create({
                members: [TS_JobCompetenceActions_competence, LG_JobCompetence_competence]
            }),
        }, {
            title: "ليست مهارت ها", pane: isc.MyVLayout.create({
                members: [LG_Skill_competence]
            }),
        }, {
            title: "ليست گروه مهارت ها", pane: isc.MyVLayout.create({
                members: [LG_SkillGroup_competence]
            }),
        }, {
            title: "ليست دوره ها",
            pane: isc.MyVLayout.create({
                members: [LG_Course_competence]
            }),
        }]
    });

    isc.MyVLayout.create({
        members: [TS_CompetenceActions_competence, LG_Competence_competence, Tabs_Competence_competence],
    });

    //****************************************************************************************************************
    // Functions
    //****************************************************************************************************************

    function checkRecord_competence(record, showDialog, msg, title,) {
        if (record ? (record.constructor === Array ? ((record.length > 0) ? true : false) : true) : false) {
            return true;
        }
        if (showDialog) {
            title = title ? title : "";
            msg = msg ? msg : "رکوردی انتخاب نشده است!";
            var  MyOkDialog_job = isc.MyOkDialog.create({
                message: msg,
                title: title,
            });

            setTimeout(function () {
                MyOkDialog_job.close();
            }, 3000);
        }
        return false;
    };

    function refresh_CompetenceListGrid_competence() {
        LG_Competence_competence.invalidateCache();
        refresh_JobCompetenceListGrid_competence();
        refresh_SkillListGrid_competence();
        refresh_SkillGroupListGrid_competence();
        refresh_CourseListGrid_competence();
    };

    function show_CompetenceNewForm_competence() {
        competenceMethod_competence = "POST";
        DF_Competence_competence.clearValues();
        Win_Competence_competence.setTitle("ایجاد شایستگی شغلی");
        Win_Competence_competence.show();
    };

    function show_CompetenceEditForm_competence() {
        let record = LG_Competence_competence.getSelectedRecord();
        if (checkRecord_competence(record, true)) {
            competenceMethod_competence = "PUT";
            DF_Competence_competence.clearValues();
            DF_Competence_competence.editRecord(record);
            Win_Competence_competence.setTitle("ویرایش شایستگی شغلی");
            Win_Competence_competence.show();
        }
    };

    function save_Competence_competence() {
        if (!DF_Competence_competence.validate()) {
            return;
        }
        let competenceData = DF_Competence_competence.getValues();
        let competenceSaveUrl = competenceUrl;
        if (competenceMethod_competence.localeCompare("PUT") == 0) {
            let competenceRecord = LG_Competence_competence.getSelectedRecord();
            competenceSaveUrl += competenceRecord.id;
        }
        isc.RPCManager.sendRequest(MyDsRequest(competenceSaveUrl, competenceMethod_competence, JSON.stringify(competenceData), "callback: show_CompetenceActionResult_competence(rpcResponse)"));
    };

    function show_CompetenceActionResult_competence(resp) {
        let respCode = resp.httpResponseCode;
        if (respCode == 200 || respCode == 201) {
            MyOkDialog_job = isc.MyOkDialog.create({
                message: "عمليات با موفقيت اجرا شد.",
            });
            setTimeout(function () {
                MyOkDialog_job.close();
            }, 3000);
            Win_Competence_competence.close();
            refresh_CompetenceListGrid_competence();
        } else {
            MyOkDialog_job = isc.MyOkDialog.create({
                message: "خطا در اجراي عمليات! کد خطا: " + resp.httpResponseCode,
            });
            setTimeout(function () {
                MyOkDialog_job.close();
            }, 3000);
        }
    };

    function show_CompetenceRemoveForm_competence() {
        let record = LG_Competence_competence.getSelectedRecord();
        if (checkRecord_competence(record, true)) {
            isc.MyYesNoDialog.create({
                message: "آیا رکورد انتخاب شده حذف گردد؟",
                buttonClick: function (button, index) {
                    this.close();
                    if (index == 0) {
                        isc.RPCManager.sendRequest(MyDsRequest(competenceUrl + record.id, "DELETE", null, "callback: show_CompetenceActionResult_competence(rpcResponse)"));
                    }
                }
            });
        }
    };

    function refresh_JobCompetenceListGrid_competence() {
        let record = LG_Competence_competence.getSelectedRecord();
        if (checkRecord_competence(record)) {
            DS_JobCompetence_competence.fetchDataURL = competenceUrl + record.id + "/job-competence/spec-list";
            LG_JobCompetence_competence.invalidateCache();
            LG_JobCompetence_competence.fetchData();
        } else {
            LG_JobCompetence_competence.setData([]);
        }
    };

    function refresh_SkillListGrid_competence() {
        let record = LG_Competence_competence.getSelectedRecord();
        if (checkRecord_competence(record)) {
            DS_Skill_competence.fetchDataURL = competenceUrl + record.id + "/skills/spec-list";
            LG_Skill_competence.invalidateCache();
            LG_Skill_competence.fetchData();
        } else {
            LG_Skill_competence.setData([]);
        }
    };

    function refresh_SkillGroupListGrid_competence() {
        let record = LG_Competence_competence.getSelectedRecord();
        console.log(record);
        if (checkRecord_competence(record)) {
            DS_SkillGroup_competence.fetchDataURL = competenceUrl + record.id + "/skillGroups/spec-list";
            LG_SkillGroup_competence.invalidateCache();
            LG_SkillGroup_competence.fetchData();
        } else {
            LG_SkillGroup_competence.setData([]);
        }
    };

    function show_JobCompetenceNewForm_competence() {
        let record = LG_Competence_competence.getSelectedRecord();
        if (checkRecord_competence(record, true, 'ابتدا يک شايستگي شغلي را انتخاب نمائيد.')) {

            jobCompetenceMethod_competence = "POST";

            DF_CompetenceInfo_competence.clearValues();
            DF_CompetenceInfo_competence.editRecord(record);

            DF_JobInfo_competence.hide();

            DF_JobCompetenceType_competence.clearValues();

            DS_Job_competence.fetchDataURL = jobUrl + "competence/not/" + record.id + "/spec-list";
            LG_Job_competence.invalidateCache();
            LG_Job_competence.fetchData();
            LG_Job_competence.show();
            Win_JobCompetence_competence.setTitle("افزدن شغل به شایستگی شغلی");
            Win_JobCompetence_competence.show();
        }
    };

    function save_JobCompetence_competence() {
        if (!DF_JobCompetenceType_competence.validate()) {
            return;
        }
        competenceId = DF_CompetenceInfo_competence.getValue('id');
        eJobCompetenceTypeId = DF_JobCompetenceType_competence.getValue('ejobCompetenceType.id');
        if (jobCompetenceMethod_competence.localeCompare("POST") == 0) {
            let jobRecords = LG_Job_competence.getSelectedRecords();
            if (checkRecord_competence(jobRecords, true, 'حداقل يک شغل را انتخاب نمائيد.')) {
                let data = {
                        "competenceId": competenceId, "jobIds": jobRecords.map(r => r.id), "eJobCompetenceTypeId":
                        eJobCompetenceTypeId
                    }
                ;
                isc.RPCManager.sendRequest(MyDsRequest(jobCompetenceUrl + "competence", jobCompetenceMethod_competence, JSON.stringify(data), "callback: show_JobCompetenceActionResult_competence(rpcResponse)"));
            }
        } else {
            let jobId = DF_JobInfo_competence.getValue('job.id');
            let data = {"competenceId": competenceId, "jobId": jobId, "eJobCompetenceTypeId": eJobCompetenceTypeId};
            isc.RPCManager.sendRequest(MyDsRequest(jobCompetenceUrl, jobCompetenceMethod_competence, JSON.stringify(data), "callback: show_JobCompetenceActionResult_competence(rpcResponse)"));
        }
    };

    function show_JobCompetenceEditForm_competence() {
        let competenceRecord = LG_Competence_competence.getSelectedRecord();
        if (checkRecord_competence(competenceRecord, true, 'ابتدا يک شايستگي شغلي را انتخاب نمائيد.')) {
            let jobRecord = LG_JobCompetence_competence.getSelectedRecord();
            if (checkRecord_competence(jobRecord, true, 'يک شغل را انتخاب نمائيد.')) {

                jobCompetenceMethod_competence = "PUT";

                DF_CompetenceInfo_competence.clearValues();
                DF_CompetenceInfo_competence.editRecord(competenceRecord);

                DF_JobInfo_competence.clearValues();
                DF_JobInfo_competence.editRecord(jobRecord);
                DF_JobInfo_competence.show();

                DF_JobCompetenceType_competence.clearValues();
                DF_JobCompetenceType_competence.editRecord(jobRecord);

                LG_Job_competence.hide();
                Win_JobCompetence_competence.setTitle("ویرایش نوع ارتباط شایستگی شغلی با شغل");
                Win_JobCompetence_competence.show();
            }
        }
    };

    function show_JobCompetenceRemoveForm_competence() {
        let competenceRecord = LG_Competence_competence.getSelectedRecord();
        if (checkRecord_competence(competenceRecord, true, 'ابتدا يک شايستگي شغلي را انتخاب نمائيد.')) {
            let jobRecord = LG_JobCompetence_competence.getSelectedRecord();
            if (checkRecord_competence(jobRecord, true, 'يک شغل را انتخاب نمائيد.')) {
                isc.MyYesNoDialog.create({
                    message: "آیا رکورد انتخاب شده حذف گردد؟",
                    buttonClick: function (button, index) {
                        this.close();
                        actionUrl = jobCompetenceUrl + jobRecord.job.id + "/" + competenceRecord.id;
                        if (index == 0) {
                            isc.RPCManager.sendRequest(MyDsRequest(actionUrl, "DELETE", null, "callback: show_JobCompetenceActionResult_competence(rpcResponse)"));
                        }
                    }
                });
            }
        }
    };

    function show_JobCompetenceActionResult_competence(resp) {
        respCode = resp.httpResponseCode;
        if (respCode == 200 || respCode == 201) {
            MyOkDialog_job = isc.MyOkDialog.create({
                message: "عمليات با موفقيت اجرا شد.",
            });

            setTimeout(function () {
                MyOkDialog_job.close();
            }, 3000);

            Win_JobCompetence_competence.close();
            refresh_JobCompetenceListGrid_competence();
            refresh_SkillListGrid_competence();
            refresh_SkillGroupListGrid_competence();
            refresh_CourseListGrid_competence();
        } else {
            MyOkDialog_job = isc.MyOkDialog.create({
                message: "خطا در اجراي عمليات! کد خطا: " + resp.httpResponseCode,
            });
            setTimeout(function () {
                MyOkDialog_job.close();
            }, 3000);

        }
    };

    function refresh_CourseListGrid_competence() {
        let record = LG_Competence_competence.getSelectedRecord();
        if (checkRecord_competence(record)) {
            DS_Course_competence.fetchDataURL = competenceUrl + record.id + "/courses/spec-list";
            LG_Course_competence.invalidateCache();
            LG_Course_competence.fetchData();
        } else {
            LG_Course_competence.setData([]);
        }
    };
