<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>
    let naJob_PostGrade = null;
    let personnelJob_PostGrade = null;
    let postJob_PostGrade = null;
    let oLoadAttachments_PostGrade = null;
    // ------------------------------------------- Menu -------------------------------------------
    PostGradeMenu_postGrade = isc.Menu.create({
        data: [
            <sec:authorize access="hasAuthority('PostGrade_R')">
            {
                title: "<spring:message code="refresh"/>",
                icon: "<spring:url value="refresh.png"/>",
                click: function () {
                    refreshPostGradeLG_postGrade();
                }
            },
            </sec:authorize>
            {isSeparator: true},
            <sec:authorize access="hasAuthority('remove.uncertainty.needAssessment.changes')">
            {
                title: "<spring:message code="remove.uncertainty.needAssessment.changes"/>",
                click: function () {
                    receive_job_response_postGrade();

                }
            }
            </sec:authorize>
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

    let ToolStrip_Post_Grade_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let criteria = PostGradeLG_postGrade.getCriteria();
                    ExportToFile.downloadExcel(null, PostGradeLG_postGrade , "View_Post_Grade", 0, null, '',"لیست رده های پستی - آموزش"  , criteria, null);
                }
            })
        ]
    });

    ToolStrip_NA_PostGrade = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            <sec:authorize access="hasAuthority('NeedAssessment_U')">
            ToolStripButton_EditNA_PostGrade,
            </sec:authorize>
            <sec:authorize access="hasAuthority('NeedAssessment_T')">
            ToolStripButton_TreeNA_PostGrade,
            </sec:authorize>
            <sec:authorize access="hasAuthority('PostGrade_P')">
            ToolStrip_Post_Grade_Export2EXcel
            </sec:authorize>
        ]
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
            <sec:authorize access="hasAuthority('PostGrade_R')">
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
            </sec:authorize>
        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------
    PostGradeDS_postGrade = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "peopleType", title: "<spring:message code="people.type"/>", filterOperator: "equals", autoFitWidth: true, valueMap:peopleTypeMap},
            {
                name: "code",
                title: "<spring:message code="post.grade.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {name: "titleFa2", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains"},
            {name: "competenceCount", title: "تعداد شایستگی", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelCount", title: "تعداد پرسنل", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "lastModifiedDateNA", title: "<spring:message code="update.date"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "modifiedByNA", title: "<spring:message code="updated.by"/>", align: "center", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {
                name: "enabled",
                title: "<spring:message code="active.status"/>",
                align: "center",
                filterOperator: "equals",
                autoFitWidth: true,
                autoFitWidthApproach: "both",
            },
        ],
        transformRequest: function (dsRequest) {
            transformCriteriaForLastModifiedDateNA(dsRequest);
            return this.Super("transformRequest", arguments);
        },
        fetchDataURL: viewPostGradeUrl + "/iscList"
    });

    PostGradeLG_postGrade = isc.TrLG.create({
        <sec:authorize access="hasAuthority('PostGrade_R')">
        dataSource: PostGradeDS_postGrade,
        </sec:authorize>
        fields: [
            {name: "code",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "peopleType", filterOnKeypress: true},
            {name: "titleFa2"},
            {name: "competenceCount"},
            {name: "personnelCount"},
            {name: "lastModifiedDateNA"},
            {name: "modifiedByNA"},
            {name: "enabled",
                valueMap:{
                    // undefined : "فعال",
                    74 : "غیر فعال"
                },filterOnKeypress: true,

            },
        ],
        autoFetchData: true,
        gridComponents: [PostGradeTS_postGrade, ToolStrip_NA_PostGrade, "filterEditor", "header", "body",],
        contextMenu: PostGradeMenu_postGrade,
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
                totalsLabel_postGrade.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            } else {
                totalsLabel_postGrade.setContents("&nbsp;");
            }
        },
        getCellCSSText: function (record) {
            return setColorForListGrid(record)
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

    let ToolStrip_Post_Grade_Personnel_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let criteria = PersonnelLG_PostGrade.getCriteria();

                    if(typeof(criteria.operator)=='undefined'){
                        criteria._constructor="AdvancedCriteria";
                        criteria.operator="and";
                    }

                    if(typeof(criteria.criteria)=='undefined'){
                        criteria.criteria=[];
                    }

                    criteria.criteria.push({fieldName: "postGradeId", operator: "equals", value: PostGradeLG_postGrade.getSelectedRecord().id});
                    // criteria.criteria.push({fieldName: "active", operator: "equals", value: 1});
                    // criteria.criteria.push({fieldName: "employmentStatusId", operator: "equals", value: 5});

                    ExportToFile.downloadExcel(null, PersonnelLG_PostGrade , "postGradePersonnel", 0, null, '',"لیست پرسنل - آموزش"  , criteria, null);
                }
            })
        ]
    });

    let ActionsTS_Personnel_Post_Grade = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStrip_Post_Grade_Personnel_Export2EXcel
        ]
    });

    PersonnelLG_PostGrade = isc.TrLG.create({
        dataSource: PersonnelDS_PostGrade,
        selectionType: "single",
        alternateRecordStyles: true,
        gridComponents: [ActionsTS_Personnel_Post_Grade, "header", "filterEditor", "body",],
        sortField: 1,
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

    let ToolStrip_NA_Post_Grade_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let criteria = NALG_PostGrade.getCriteria();

                    if(typeof(criteria.operator)=='undefined'){
                        criteria._constructor="AdvancedCriteria";
                        criteria.operator="and";
                    }

                    if(typeof(criteria.criteria)=='undefined'){
                        criteria.criteria=[];
                    }
                    criteria.criteria.push({fieldName: "objectId", operator: "equals", value: PostGradeLG_postGrade.getSelectedRecord().id});
                    criteria.criteria.push({fieldName: "objectType", operator: "equals", value: "PostGrade"});
                    // criteria.criteria.push({fieldName: "personnelNo", operator: "equals", value: null});

                    ExportToFile.downloadExcel(null, NALG_PostGrade , "NeedsAssessmentReport", 0, null, '',"لیست نیازسنجی - آموزش"  , criteria, null);
                }
            })
        ]
    });

    let ActionsTS_NA_Post_Grade_Job
        = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStrip_NA_Post_Grade_Export2EXcel
        ]
    });

    NALG_PostGrade = isc.TrLG.create({
        dataSource: NADS_PostGrade,
        selectionType: "none",
        autoFetchData: false,
        alternateRecordStyles: true,
        showAllRecords: true,
        gridComponents: [
            ActionsTS_NA_Post_Grade_Job,
            "header", "filterEditor", "body",],
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
    Delete_Button_response_postGrade = isc.Button.create({
        title: "حذف نیازسنجی فعلی"  ,
        top: 260,
        layoutMargin: 5,
        membersMargin: 5,
        click: function () {
            delete_uncertainly_assessment_postGrade();
        }
    });
    Cancel_Button_Response_postGrade = isc.IButtonCancel.create({
        layoutMargin: 5,
        membersMargin: 5,
        width: 120,
        click: function () {
            Window_delete_uncertainly_needAssessment_postGrade.close();
        }
    });
    HLayout_IButtons_Uncertainly_needAssessment_postGrade = isc.HLayout.create({
        layoutMargin: 5,
        membersMargin: 15,
        width: "100%",
        height: "100%",
        align: "center",
        members: [
            Delete_Button_response_postGrade,

            Cancel_Button_Response_postGrade,

        ]
    });

    DynamicForm_Uncertainly_needAssessment_postGrade= isc.DynamicForm.create({
        width: 600,
        height: 100,
        numCols: 2,
        fields: [
            {
                name: "createdBy",
                title: "ایجاد کننده :",
                canEdit: false,
                hidden: false
            },
            {
                name: "mainWorkStatus",
                title: "وضعیت نیازسنجی :",
                canEdit: false
            },

        ]

    });
    Window_delete_uncertainly_needAssessment_postGrade = isc.Window.create({
        title: "حذف تغییرات نیازسنجی بلا تکلیف",
        width: 600,
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: true,
        items: [

            DynamicForm_Uncertainly_needAssessment_postGrade,
            HLayout_IButtons_Uncertainly_needAssessment_postGrade,

        ]

    });

    //////////////////////////////////////////////////////////posts/////////////////////////////////////////////////////
    PostDS_PostGrade = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "peopleType", title: "<spring:message code="people.type"/>", filterOperator: "equals", autoFitWidth: true, valueMap: {"Personal" : "شرکتی", "ContractorPersonal" : "پیمان کار"}, filterOnKeypress: true},
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
            {name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both", valueMap:{74 : "غیر فعال"},filterOnKeypress: true,}
        ],
        fetchDataURL: viewTrainingPostUrl + "/spec-list"
    });

    let ToolStrip_Post_Grade_Post_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let criteria = PostLG_PostGrade.getCriteria();

                    if(typeof(criteria.operator)=='undefined'){
                        criteria._constructor="AdvancedCriteria";
                        criteria.operator="and";
                    }

                    if(typeof(criteria.criteria)=='undefined'){
                        criteria.criteria=[];
                    }
                    criteria.criteria.push({fieldName: "postGrade", operator: "equals", value: PostGradeLG_postGrade.getSelectedRecord().id});

                    ExportToFile.downloadExcel(null, PostLG_PostGrade , "Post", 0, null, '',"لیست پست - آموزش"  , criteria, null);
                }
            })
        ]
    });

    let ActionsTS_Post_Post_Grade = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStrip_Post_Grade_Post_Export2EXcel
        ]
    });

    PostLG_PostGrade = isc.TrLG.create({
        dataSource: PostDS_PostGrade,
        autoFetchData: false,
        showResizeBar: true,
        sortField: "id",
        gridComponents: [ActionsTS_Post_Post_Grade, "header", "filterEditor", "body",],
    });

    // ------------------------------------------- Page UI -------------------------------------------

    Detail_Tab_PostGrade = isc.TabSet.create({
        height: "40%",
        tabBarPosition: "top",
        tabs: [
            {name: "TabPane_Post_PostGrade", title: "لیست پست ها", pane: PostLG_PostGrade},
            {name: "TabPane_Personnel_JobGroup", title: "لیست پرسنل", pane: PersonnelLG_PostGrade},
            {name: "TabPane_NA_PostGrade", title: "<spring:message code='need.assessment'/>", pane: NALG_PostGrade},
            {
                ID: "PostGrade_AttachmentsTab",
                title: "<spring:message code="attachments"/>",
                // pane: isc.ViewLoader.create({autoDraw: true, viewURL: "tclass/attachments-tab"})
            },
        ],
        tabSelected: function (){
            selectionUpdated_PostGrade();
        }
    });
    
    isc.TrVLayout.create({
        members: [
            PostGradeLG_postGrade,
            <sec:authorize access="hasAuthority('PostGrade_R')">
            Detail_Tab_PostGrade
            </sec:authorize>
        ]
    });

    // ------------------------------------------- Functions -------------------------------------------
    function refreshPostGradeLG_postGrade() {
        objectIdAttachment=null
        refreshLG(PostGradeLG_postGrade);
        PostLG_PostGrade.setData([]);
        PersonnelLG_PostGrade.setData([]);
        NALG_PostGrade.setData([]);
        oLoadAttachments_PostGrade.ListGrid_JspAttachment.setData([]);
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

        switch (tab.name ||tab.ID) {
            case "TabPane_Post_PostGrade":{
                if (postJob_PostGrade === postGrade.id)
                    return;
                postJob_PostGrade = postGrade.id;
                PostLG_PostGrade.setImplicitCriteria({
                    _constructor: "AdvancedCriteria",
                    operator: "and",
                    criteria: [{fieldName: "postGradeId", operator: "equals", value: postGrade.id}]
                });
                PostLG_PostGrade.invalidateCache();
                PostLG_PostGrade.fetchData();
                break;
            }
            case "TabPane_Personnel_JobGroup":{
                if (personnelJob_PostGrade === postGrade.id)
                    return;
                personnelJob_PostGrade = postGrade.id;
                PersonnelDS_PostGrade.fetchDataURL = postGradeUrl + "/personnelIscList/" + postGrade.id;
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

            case "PostGrade_AttachmentsTab": {

                if (typeof oLoadAttachments_PostGrade.loadPage_attachment_Job!== "undefined")
                    oLoadAttachments_PostGrade.loadPage_attachment_Job("PostGrade", postGrade.id, "<spring:message code="attachment"/>", {
                        1: "جزوه",
                        2: "لیست نمرات",
                        3: "لیست حضور و غیاب",
                        4: "نامه غیبت موجه"
                    }, false);
                break;
            }



        }
    }
    if (!loadjs.isDefined('load_Attachments_postGroup')) {
        loadjs('<spring:url value='tclass/attachments-tab' />', 'load_Attachments_postGroup');
    }

    loadjs.ready('load_Attachments_postGroup', function () {
        setTimeout(()=> {
            oLoadAttachments_PostGrade = new loadAttachments();
            Detail_Tab_PostGrade.updateTab(PostGrade_AttachmentsTab, oLoadAttachments_PostGrade.VLayout_Body_JspAttachment)
        },0);

    });
    function  receive_job_response_postGrade(){
        let record=  PostGradeLG_postGrade.getSelectedRecord();
        DynamicForm_Uncertainly_needAssessment_postGrade.clearValues();
        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/getNeedAssessmentTempByCode?code=" + record.code, "GET", null, function (resp) {
            wait.close();
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                let detail = JSON.parse(resp.httpResponseText);
                DynamicForm_Uncertainly_needAssessment_postGrade.setValues(detail);
                Window_delete_uncertainly_needAssessment_postGrade.show();
            } else {
                createDialog("info", "<spring:message code="this.code.doesnt.have.needAssessment"/>", "<spring:message code="error"/>");
            }
        }));



    }
    function delete_uncertainly_assessment_postGrade(){

        let record=   PostGradeLG_postGrade.getSelectedRecord();
        DynamicForm_Uncertainly_needAssessment_postGrade.clearValues();
        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/removeConfirmation?code=" + record.code, "GET", null, function (resp) {
            wait.close();
            if (resp.httpResponseCode === 201 || resp.httpResponseCode===200)   {

                Window_delete_uncertainly_needAssessment_postGrade.close();
                createDialog("info","عملیات حذف موفقیت آمیز بود")
            } else {
                createDialog("info", "<spring:message code="delete.was.not.successful"/>", "<spring:message code="error"/>");
            }
        }));



    }
    // </script>