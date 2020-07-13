<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>

    var naJob_Job = null;
    var personnelJob_Job = null;
    var postJob_Job = null;

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

    ///////////////////////////////////////////////////Menu/////////////////////////////////////////////////////////////
    JobMenu_job = isc.Menu.create({
        data: [
            {
                title: "<spring:message code="refresh"/>",
                icon: "<spring:url value="refresh.png"/>",
                click: function () {
                    refresh_Job();
                }
            },
        ]
    });

    ///////////////////////////////////////////////ToolStrip////////////////////////////////////////////////////////////
    ToolStripButton_EditNA_Job = isc.ToolStripButton.create({
        title: "ویرایش نیازسنجی",
        click: function () {
            if (JobLG_job.getSelectedRecord() == null){
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                return;
            }
            Window_NeedsAssessment_Edit.showUs(JobLG_job.getSelectedRecord(), "Job");
        }
    });
    ToolStripButton_TreeNA_JspJob = isc.ToolStripButton.create({
        title: "درخت نیازسنجی",
        click: function () {
            if (JobLG_job.getSelectedRecord() == null){
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                return;
            }
            Window_NeedsAssessment_Tree.showUs(JobLG_job.getSelectedRecord(), "Job");
        }
    });

    let ToolStrip_Job_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let criteria = JobLG_job.getCriteria();
                    ExportToFile.showDialog(null, JobLG_job , "View_Job", 0, null, '',"لیست شغل ها - آموزش"  , criteria, null);
                }
            })
        ]
    });

    ToolStrip_NA_Job = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [ToolStripButton_EditNA_Job, ToolStripButton_TreeNA_JspJob, ToolStrip_Job_Export2EXcel]
    });
    
    JobTS_job = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.LayoutSpacer.create({
                width: "*"
            }),
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    isc.Label.create({
                        ID: "totalsLabel_job"
                    }),
                    isc.ToolStripButtonRefresh.create({
                        click: function () {
                            refresh_Job();
                        }
                    }),
                ]
            })
        ]
    });

    //////////////////////////////////////////////DataSource & ListGrid/////////////////////////////////////////////////
    JobDS_job = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="job.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains"},
            {name: "competenceCount", title: "تعداد شایستگی", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelCount", title: "تعداد پرسنل", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
        ],
        fetchDataURL: viewJobUrl + "/iscList"
    });

    JobLG_job = isc.TrLG.create({
        dataSource: JobDS_job,
        fields: [
            {name: "code",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "titleFa",},
            {name: "competenceCount"},
            {name: "personnelCount"}
        ],
        autoFetchData: true,
        gridComponents: [JobTS_job, ToolStrip_NA_Job, "filterEditor", "header", "body"],
        contextMenu: JobMenu_job,
        showResizeBar: true,
        canMultiSort: true,
        initialSort: [
            {property: "competenceCount", direction: "ascending"},
            {property: "code", direction: "ascending"}
        ],
        selectionType: "single",
        dataChanged: function () {
            this.Super("dataChanged", arguments);
            let totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown()) {
                totalsLabel_job.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            } else {
                totalsLabel_job.setContents("&nbsp;");
            }
        },
        selectionUpdated: function (){
            selectionUpdated_Job();
        },
        getCellCSSText: function (record) {
            if (record.competenceCount === 0)
                return "color:red;font-size: 12px;";
        },
    });

    defineWindowsEditNeedsAssessment(JobLG_job);
    defineWindowTreeNeedsAssessment();

    ////////////////////////////////////////////////////////////personnel///////////////////////////////////////////////
    PersonnelDS_Job = isc.TrDS.create({
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
            {name: "postCode", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpArea", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpAssistant", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpAffairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpSection", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpUnit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: personnelUrl + "/iscList",
    });

    let ToolStrip_Job_Personnel_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let criteria = PersonnelLG_Job.getCriteria();

                    if(typeof(criteria.operator)=='undefined'){
                        criteria._constructor="AdvancedCriteria";
                        criteria.operator="and";
                    }

                    if(typeof(criteria.criteria)=='undefined'){
                        criteria.criteria=[];
                    }
                    criteria.criteria.push({fieldName: "jobNo", operator: "equals", value: JobLG_job.getSelectedRecord().code});
                    criteria.criteria.push({fieldName: "active", operator: "equals", value: 1});
                    criteria.criteria.push({fieldName: "employmentStatusId", operator: "equals", value: 5});

                    ExportToFile.showDialog(null, PersonnelLG_Job , "Personnel", 0, null, '',"لیست پرسنل - آموزش"  , criteria, null);
                }
            })
        ]
    });

    let ActionsTS_Personnel_Job = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStrip_Job_Personnel_Export2EXcel
        ]
    });

    PersonnelLG_Job = isc.TrLG.create({
        dataSource: PersonnelDS_Job,
        selectionType: "single",
        alternateRecordStyles: true,
        gridComponents: [ActionsTS_Personnel_Job, "header", "filterEditor", "body",],
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
            {name: "ccpArea"},
            {name: "ccpAssistant"},
            {name: "ccpAffairs"},
            {name: "ccpSection"},
            {name: "ccpUnit"},
        ]
    });

    ///////////////////////////////////////////////////////////needs assessment/////////////////////////////////////////
    PriorityDS_Job = isc.TrDS.create({
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

    DomainDS_Job = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/NeedsAssessmentDomain"
    });

    CompetenceTypeDS_Job = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/competenceType"
    });

    NADS_Job = isc.TrDS.create({
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

    let ToolStrip_Job_NA_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let criteria = NALG_Job.getCriteria();

                    if(typeof(criteria.operator)=='undefined'){
                        criteria._constructor="AdvancedCriteria";
                        criteria.operator="and";
                    }

                    if(typeof(criteria.criteria)=='undefined'){
                        criteria.criteria=[];
                    }
                    criteria.criteria.push({fieldName: "objectId", operator: "equals", value: JobLG_job.getSelectedRecord().id});
                    criteria.criteria.push({fieldName: "objectType", operator: "equals", value: "Job"});
                    criteria.criteria.push({fieldName: "personnelNo", operator: "equals", value: null});

                    ExportToFile.showDialog(null, NALG_Job , "NeedsAssessment", 0, null, '',"لیست نیازسنجی - آموزش"  , criteria, null);
                }
            })
        ]
    });

    let ActionsTS_NA_Job = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStrip_Job_NA_Export2EXcel
        ]
    });

    NALG_Job = isc.TrLG.create({
        dataSource: NADS_Job,
        selectionType: "none",
        autoFetchData: false,
        alternateRecordStyles: true,
        showAllRecords: true,
        gridComponents: [ActionsTS_NA_Job, "header", "filterEditor", "body",],
        fields: [
            {name: "competence.title"},
            {
                name: "competence.competenceTypeId",
                type: "SelectItem",
                filterOnKeypress: true,
                displayField: "title",
                valueField: "id",
                optionDataSource: CompetenceTypeDS_Job,
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
                optionDataSource: PriorityDS_Job,
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
                optionDataSource: DomainDS_Job,
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
    PostDS_Job = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "jobTitleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "postGradeTitleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "area", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "assistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "section", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterCode", title: "<spring:message code="reward.cost.center.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterTitleFa", title: "<spring:message code="reward.cost.center.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "competenceCount", title: "تعداد شایستگی", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelCount", title: "تعداد پرسنل", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},

        ],
        fetchDataURL: viewPostUrl + "/iscList"
    });

    let ToolStrip_Job_Post_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let criteria = PostLG_Job.getCriteria();

                    if(typeof(criteria.operator)=='undefined'){
                        criteria._constructor="AdvancedCriteria";
                        criteria.operator="and";
                    }

                    if(typeof(criteria.criteria)=='undefined'){
                        criteria.criteria=[];
                    }
                    criteria.criteria.push({fieldName: "jobCode", operator: "equals", value: JobLG_job.getSelectedRecord().code});

                    ExportToFile.showDialog(null, PostLG_Job , "View_Post", 0, null, '',"لیست پست - آموزش"  , criteria, null);
                }
            })
        ]
    });

    let ActionsTS_Post_Job = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStrip_Job_Post_Export2EXcel
        ]
    });

    PostLG_Job = isc.TrLG.create({
        dataSource: PostDS_Job,
        gridComponents: [ActionsTS_Post_Job, "header", "filterEditor", "body",],
        fields: [
            {name: "code",
                filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                }
            },
            {name: "titleFa",},
            {name: "jobTitleFa",},
            {name: "postGradeTitleFa",},
            {name: "area",},
            {name: "assistance",},
            {name: "affairs",},
            {name: "section",},
            {name: "unit",},
            {name: "costCenterCode",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "costCenterTitleFa"},
            {name: "competenceCount"},
            {name: "personnelCount"}
        ],
        autoFetchData: false,
        showResizeBar: true,
        sortField: 0,
    });

    //////////////////////////////////////////////////////////TabSet////////////////////////////////////////////////////
    DetailTab_Job = isc.TabSet.create({
        tabBarPosition: "top",
        width: "100%",
        height: "40%",
        tabs: [
            {name: "TabPane_Post_Job", title: "لیست پست ها", pane: PostLG_Job},
            {name: "TabPane_Personnel_Job", title: "لیست پرسنل", pane: PersonnelLG_Job},
            {name: "TabPane_NA_Job", title: "<spring:message code='need.assessment'/>", pane: NALG_Job}
        ],
        tabSelected: function (){
            selectionUpdated_Job();
        }
    });

    //////////////////////////////////////////////////////////Form//////////////////////////////////////////////////////
    isc.TrVLayout.create({
        members: [JobLG_job, DetailTab_Job],
    });

    /////////////////////////////////////////////////////////Functions//////////////////////////////////////////////////
    function selectionUpdated_Job(){
        let job = JobLG_job.getSelectedRecord();
        let tab = DetailTab_Job.getSelectedTab();
        if (job == null && tab.pane != null){
            tab.pane.setData([]);
            return;
        }

        switch (tab.name) {
            case "TabPane_Post_Job":{
                if (postJob_Job === job.id)
                    return;
                postJob_Job = job.id;
                PostLG_Job.setImplicitCriteria({
                    _constructor: "AdvancedCriteria",
                    operator: "and",
                    criteria: [{fieldName: "jobCode", operator: "equals", value: job.code}]
                });
                PostLG_Job.invalidateCache();
                PostLG_Job.fetchData();
                break;
            }
            case "TabPane_Personnel_Job":{
                if (personnelJob_Job === job.id)
                    return;
                personnelJob_Job = job.id;
                PersonnelLG_Job.setImplicitCriteria({
                    _constructor: "AdvancedCriteria",
                    operator: "and",
                    criteria: [
                        {fieldName: "jobNo", operator: "equals", value: job.code},
                        {fieldName: "active", operator: "equals", value: 1},
                        {fieldName: "employmentStatusId", operator: "equals", value: 5}
                    ]
                });
                PersonnelLG_Job.invalidateCache();
                PersonnelLG_Job.fetchData();
                break;
            }
            case "TabPane_NA_Job":{
                if (naJob_Job === job.id)
                    return;
                naJob_Job = job.id;
                NADS_Job.fetchDataURL = needsAssessmentReportsUrl + "?objectId=" + job.id + "&objectType=Job";
                NADS_Job.invalidateCache();
                NADS_Job.fetchData();
                NALG_Job.invalidateCache();
                NALG_Job.fetchData();
                break;
            }
        }
    }

    function refresh_Job (){
        refreshLG(JobLG_job);
        PostLG_Job.setData([]);
        PersonnelLG_Job.setData([]);
        NALG_Job.setData([]);
        naJob_Job = null;
        personnelJob_Job = null;
        postJob_Job = null;
    }

    // </script>

