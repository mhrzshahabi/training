<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>

    var naJob_PostGrade = null;
    var personnelJob_PostGrade = null;
    var postJob_PostGrade = null;

    // ------------------------------------------- Menu -------------------------------------------
    PostGradeMenu_postGrade = isc.Menu.create({
        data: [
            {
                title: "<spring:message code="refresh"/>",
                icon: "<spring:url value="refresh.png"/>",
                click: function () {
                    refreshPostGradeLG_postGrade();
                }
            },
        ]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------
    ToolStripButton_EditNA_PostGrade = isc.ToolStripButton.create({
        title: "ویرایش نیازسنجی",
        click: function () {
            if (PostGradeLG_postGrade.getSelectedRecord() == null){
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                return;
            }
            Window_NeedsAssessment_Edit.showUs(PostGradeLG_postGrade.getSelectedRecord(), "PostGrade");
        }
    });
    ToolStripButton_TreeNA_PostGrade = isc.ToolStripButton.create({
        title: "درخت نیازسنجی",
        click: function () {
            if (PostGradeLG_postGrade.getSelectedRecord() == null){
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                return;
            }
            Window_NeedsAssessment_Tree.showUs(PostGradeLG_postGrade.getSelectedRecord(), "PostGrade");
        }
    });
    ToolStrip_NA_PostGrade = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [ToolStripButton_EditNA_PostGrade, ToolStripButton_TreeNA_PostGrade]
    });
    
    PostGradeTS_postGrade = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.Label.create({
                ID: "totalsLabel_postGrade"
            }),
            isc.LayoutSpacer.create({
                width: "*"
            }),
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    isc.ToolStripButtonRefresh.create({
                        click: function () {
                            refreshPostGradeLG_postGrade();
                        }
                    })
                ]
            })

        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------
    PostGradeDS_postGrade = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {
                name: "code",
                title: "<spring:message code="post.grade.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {name: "titleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains"},
            {name: "competenceCount", title: "تعداد شایستگی", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelCount", title: "تعداد پرسنل", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"}
        ],
        fetchDataURL: viewPostGradeUrl + "/iscList"
    });

    PostGradeLG_postGrade = isc.TrLG.create({
        dataSource: PostGradeDS_postGrade,
        fields: [
            {name: "code",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "titleFa"},
            {name: "competenceCount"},
            {name: "personnelCount"}
        ],
        autoFetchData: true,
        gridComponents: [PostGradeTS_postGrade, ToolStrip_NA_PostGrade, "filterEditor", "header", "body",],
        contextMenu: PostGradeMenu_postGrade,
        sortField: 2,
        selectionType: "single",
        dataChanged: function () {
            this.Super("dataChanged", arguments);
            var totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown()) {
                totalsLabel_postGrade.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            } else {
                totalsLabel_postGrade.setContents("&nbsp;");
            }
        },
        getCellCSSText: function (record) {
            if (record.competenceCount === 0)
                return "color:red;font-size: 12px;";
        },
        selectionUpdated: function () {
            selectionUpdated_PostGrade();
        },
    });

    defineWindowsEditNeedsAssessment(PostGradeLG_postGrade);
    defineWindowTreeNeedsAssessment();

    ////////////////////////////////////////////////////////////personnel///////////////////////////////////////////////
    PersonnelDS_PostGrade = isc.TrDS.create({
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

    PersonnelLG_PostGrade = isc.TrLG.create({
        dataSource: PersonnelDS_PostGrade,
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
    PriorityDS_PostGrade = isc.TrDS.create({
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

    DomainDS_PostGrade = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/NeedsAssessmentDomain"
    });

    CompetenceTypeDS_PostGrade = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/competenceType"
    });

    NADS_PostGrade = isc.TrDS.create({
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

    NALG_PostGrade = isc.TrLG.create({
        dataSource: NADS_PostGrade,
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
                optionDataSource: CompetenceTypeDS_PostGrade,
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
                optionDataSource: PriorityDS_PostGrade,
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
                optionDataSource: DomainDS_PostGrade,
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
    PostDS_PostGrade = isc.TrDS.create({
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

    PostLG_PostGrade = isc.TrLG.create({
        dataSource: PostDS_PostGrade,
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

    // ------------------------------------------- Page UI -------------------------------------------

    Detail_Tab_PostGrade = isc.TabSet.create({
        height: "40%",
        tabBarPosition: "top",
        tabs: [
            {name: "TabPane_Post_PostGrade", title: "لیست پست ها", pane: PostLG_PostGrade},
            {name: "TabPane_Personnel_JobGroup", title: "لیست پرسنل", pane: PersonnelLG_PostGrade},
            {name: "TabPane_NA_PostGrade", title: "<spring:message code='need.assessment'/>", pane: NALG_PostGrade},
        ],
        tabSelected: function (){
            selectionUpdated_PostGrade();
        }
    });
    
    isc.TrVLayout.create({
        members: [PostGradeLG_postGrade, Detail_Tab_PostGrade],
    });

    // ------------------------------------------- Functions -------------------------------------------
    function refreshPostGradeLG_postGrade() {
        refreshLG(PostGradeLG_postGrade);
        PostLG_PostGrade.setData([]);
        PersonnelLG_PostGrade.setData([]);
        NALG_PostGrade.setData([]);
        naJob_PostGrade = null;
        personnelJob_PostGrade = null;
        postJob_PostGrade = null;
    }

    function selectionUpdated_PostGrade(){
        let postGrade = PostGradeLG_postGrade.getSelectedRecord();
        let tab = Detail_Tab_PostGrade.getSelectedTab();
        if (postGrade == null && tab.pane != null){
            tab.pane.setData([]);
            return;
        }

        switch (tab.name) {
            case "TabPane_Post_PostGrade":{
                if (postJob_PostGrade === postGrade.id)
                    return;
                postJob_PostGrade = postGrade.id;
                PostLG_PostGrade.setImplicitCriteria({
                    _constructor: "AdvancedCriteria",
                    operator: "and",
                    criteria: [{fieldName: "postGrade", operator: "equals", value: postGrade.id}]
                });
                PostLG_PostGrade.invalidateCache();
                PostLG_PostGrade.fetchData();
                break;
            }
            case "TabPane_Personnel_JobGroup":{
                if (personnelJob_PostGrade === postGrade.id)
                    return;
                personnelJob_PostGrade = postGrade.id;
                PersonnelLG_PostGrade.setImplicitCriteria({
                    _constructor: "AdvancedCriteria",
                    operator: "and",
                    criteria: [
                        {fieldName: "postGradeCode", operator: "equals", value: postGrade.code},
                        {fieldName: "active", operator: "equals", value: 1},
                        {fieldName: "employmentStatusId", operator: "equals", value: 5}
                    ]
                });
                PersonnelLG_PostGrade.invalidateCache();
                PersonnelLG_PostGrade.fetchData();
                break;
            }
            case "TabPane_NA_PostGrade":{
                if (naJob_PostGrade === postGrade.id)
                    return;
                naJob_PostGrade = postGrade.id;
                NADS_PostGrade.fetchDataURL = needsAssessmentReportsUrl + "?objectId=" + postGrade.id + "&objectType=PostGrade";
                NADS_PostGrade.invalidateCache();
                NADS_PostGrade.fetchData();
                NALG_PostGrade.invalidateCache();
                NALG_PostGrade.fetchData();
                break;
            }
        }
    }

    // </script>