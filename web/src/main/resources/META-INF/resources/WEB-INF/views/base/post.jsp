<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>

    if(Window_NeedsAssessment_Edit === undefined) {
        var Window_NeedsAssessment_Edit = isc.Window.create({
            title: "<spring:message code="needs.assessment"/>",
            placement: "fillScreen",
            minWidth: 1024,
            items: [isc.ViewLoader.create({autoDraw: true, viewURL: "web/edit-needs-assessment/"})],
            showUs(record, objectType) {
                loadEditNeedsAssessment(record, objectType);
                this.Super("show", arguments);
            }
        });
    }

    // ------------------------------------------- Menu -------------------------------------------
    PostMenu_post = isc.Menu.create({
        data: [
            {
                title: "<spring:message code="refresh"/>",
                icon: "<spring:url value="refresh.png"/>",
                click: function () {
                    closeToShowUnGroupedPosts_POST();
                    refreshLG(PostLG_post);
                }
            },
        ]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------
    ToolStripButton_unGroupedPosts_POST = isc.ToolStripButton.create({
        title: "پست های فاقد گروه پستی",
        click: function () {
            callToShowUnGroupedPosts_POST({
                _constructor: "AdvancedCriteria",
                operator: "and",
                criteria: [{fieldName: "postGroupSet", operator: "isNull"}]
            });
        }
    });
    ToolStripButton_newPosts_POST = isc.ToolStripButton.create({
        title: "پست های جدید",
        click: function () {
            callToShowUnGroupedPosts_POST({
                _constructor: "AdvancedCriteria",
                operator: "or",
                criteria: [
                    {fieldName: "createdDate", operator: "greaterOrEqual", value: Date.create(today-6048e5).toUTCString()},
                    {fieldName: "lastModifiedDate", operator: "greaterOrEqual", value: Date.create(today-6048e5).toUTCString()}
                ]
            });
        }
    });
    ToolStripButton_EditNA_POST = isc.ToolStripButton.create({
        title: "ویرایش نیازسنجی",
        click: function () {
            if (PostLG_post.getSelectedRecord() == null){
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                return;
            }
            Window_NeedsAssessment_Edit.showUs(PostLG_post.getSelectedRecord(), "Post");
            // createTab(this.title, "web/edit-needs-assessment/", "loadEditNeedsAssessment(PostLG_post.getSelectedRecord(), 'Post')");
        }
    });
    ToolStrip_NA_POST = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            ToolStripButton_unGroupedPosts_POST,
            ToolStripButton_newPosts_POST,
            ToolStripButton_EditNA_POST
        ]
    });

    PostTS_post = isc.ToolStrip.create({
        membersMargin: 5,
        members: [
            <%--isc.ToolStripButtonPrint.create({--%>
            <%--    title: "<spring:message code='print'/>",--%>
            <%--    click: function () {--%>
            <%--        print_PostListGrid("pdf");--%>
            <%--    }--%>
            <%--}),--%>
            isc.ToolStripButton.create({
                top: 260,
                align: "center",
                title: "<spring:message code='post.person.assign'/>",
                click: function () {
                    if (!(PostLG_post.getSelectedRecord() === undefined || PostLG_post.getSelectedRecord() == null)) {
                        setDetailViewer_Personnel(PostLG_post.getSelectedRecord().id);
                        DetailViewer_Personnel.show();
                        Window_DetailViewer_Personnel.show();
                    } else {
                        createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                    }

                }
            }),
            isc.LayoutSpacer.create({
                width: "*"
            }),
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    isc.Label.create({
                        ID: "totalsLabel_post"
                    }),
                    isc.ToolStripButtonRefresh.create({
                        click: function () {
                            closeToShowUnGroupedPosts_POST();
                            refreshLG(PostLG_post);
                        }
                    }),
                ]
            })
        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------
    PostDS_post = isc.TrDS.create({
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

    PostLG_post = isc.TrLG.create({
        dataSource: PostDS_post,
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
        autoFetchData: true,
        gridComponents: [PostTS_post, ToolStrip_NA_POST, "filterEditor", "header", "body",],
        contextMenu: PostMenu_post,
        showResizeBar: true,
        sortField: 0,
        dataChanged: function () {
            this.Super("dataChanged", arguments);
            let totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown()) {
                totalsLabel_post.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            } else {
                totalsLabel_post.setContents("&nbsp;");
            }
        },
        selectionUpdated: function (record) {
            CourseDS_POST.fetchDataURL = needsAssessmentReportsUrl + "?objectId=" + record.id + "&objectType=Post";
            CourseDS_POST.invalidateCache();
            CourseDS_POST.fetchData();
            CoursesLG_POST.invalidateCache();
            CoursesLG_POST.fetchData();
        },
        getCellCSSText: function (record) {
            if (record.competenceCount === 0)
                return "color:red;font-size: 12px;";
        },
    });

    // ------------------------------------------- Page UI -------------------------------------------


    ////////////////////////////Detail Viewer Personnel ////////////////////////////

    PersonnelDS_personnel = isc.TrDS.create({
        fields: [
            {name: "id", hidden: true},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "workPlace", title: "<spring:message code="work.place"/>", filterOperator: "iContains", autoFitWidth: true, width: "*"},
            {name: "employmentStatus", title: "<spring:message code="employment.status"/>", filterOperator: "iContains", autoFitWidth: true, detail: true},
            {name: "complexTitle", title: "<spring:message code="complex"/>", filterOperator: "iContains", autoFitWidth: true, detail: true},
            {name: "workPlaceTitle", title: "<spring:message code="work.place"/>", filterOperator: "iContains", autoFitWidth: true, detail: true},
            {name: "workTurnTitle", title: "<spring:message code="work.turn"/>", filterOperator: "iContains", detail: true, autoFitWidth: true},
            {name: "postTitle", title: "<spring:message code="post.title"/>", filterOperator: "iContains", detail: true, autoFitWidth: true},
            {name: "postCode", title: "<spring:message code="post.code"/>", filterOperator: "iContains", detail: true, autoFitWidth: true},
            {name: "workYears", title: "<spring:message code="work.years"/>", filterOperator: "iContains", detail: true, autoFitWidth: true},
            {name: "educationLevelTitle", title: "<spring:message code="education.degree"/>", filterOperator: "iContains", detail: true, autoFitWidth: true},
            {name: "educationMajorTitle", title: "<spring:message code="education.major"/>", filterOperator: "iContains", detail: true, autoFitWidth: true},
            {name: "jobTitle", title: "<spring:message code="job.title"/>", filterOperator: "iContains", detail: true, autoFitWidth: true},

        ],
        canAddFormulaFields: false,
        filterOnKeypress: true,
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
    });

    DetailViewer_Personnel = isc.DetailViewer.create({

        // var DetailViewer_Personnel = isc.TrLG.create({
        width: 430,
        height: "90%",
        autoDraw: false,
        border: "2px solid black",
        layoutMargin: 5,
        autoFetchData: false,
        dataSource: PersonnelDS_personnel,
        fields: [
            {name: "firstName"},
            {name: "lastName"},
            {name: "nationalCode"},
            {name: "personnelNo"},
            {name: "personnelNo2"},
            {name: "jobTitle"},
            {name: "employmentStatus"},
            {name: "complexTitle"},
            {name: "workPlaceTitle"},
            {name: "workTurnTitle"},
            {name: "postTitle"},
            {name: "postCode"},
            {name: "educationLevelTitle"},
            {name: "educationMajorTitle"},
            {name: "workYears"}
        ]
    });

    DetailViewer_Personnel_HLayout = isc.HLayout.create({
        width: "100%",
        height: "5%",
        autoDraw: false,
        border: "0px solid red",
        align: "center",
        vAlign: "center",
        layoutMargin: 5,
        membersMargin: 7,
        members: [
            DetailViewer_Personnel
        ]
    });

    DetailViewer_Personnel_closeButton_HLayout = isc.HLayout.create({
        width: "100%",
        height: "6%",
        autoDraw: false,
        align: "center",
        members: [
            isc.IButton.create({
                title: "<spring:message code='close'/>",
                icon: "[SKIN]/actions/cancel.png",
                width: "70",
                align: "center",
                click: function () {
                    Window_DetailViewer_Personnel.close();
                }
            })
        ]
    });

    Window_DetailViewer_Personnel = isc.Window.create({
        title: "<spring:message code='personal'/>",
        width: 460,
        height: 515,
        autoSize: false,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        vAlign: "center",
        autoDraw: false,
        dismissOnEscape: true,
        layoutMargin: 5,
        membersMargin: 7,
        items: [
            DetailViewer_Personnel_HLayout,
            DetailViewer_Personnel_closeButton_HLayout

        ]
    });

    //////////////////////////////////////////////////////////////detailTab/////////////////////////////////////////////

    PriorityDS_POST = isc.TrDS.create({
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

    DomainDS_POST = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/NeedsAssessmentDomain"
    });

    CompetenceTypeDS_POST = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/competenceType"
    });

    CourseDS_POST = isc.TrDS.create({
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

    CoursesLG_POST = isc.TrLG.create({
        dataSource: CourseDS_POST,
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
                optionDataSource: CompetenceTypeDS_POST,
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
                optionDataSource: PriorityDS_POST,
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
                optionDataSource: DomainDS_POST,
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

    DetailTS_Post = isc.TabSet.create({
        height: "40%",
        tabBarPosition: "top",
        tabs: [
            {title: "<spring:message code='need.assessment'/>", pane: CoursesLG_POST}
        ]
    });

    //////////////////////////////////////////////////////////////detailTab/////////////////////////////////////////////

    isc.TrVLayout.create({
        members: [PostLG_post, DetailTS_Post],
    });

    // ------------------------------------------- Functions -------------------------------------------

    function setDetailViewer_Personnel(postId) {
        PersonnelDS_personnel.fetchDataURL = personnelUrl + "/byPostCode/" + postId;
        DetailViewer_Personnel.invalidateCache();
        DetailViewer_Personnel.fetchData();
    }

    function callToShowUnGroupedPosts_POST(criteria){
        CoursesLG_POST.setData([]);
        PostLG_post.setImplicitCriteria(criteria);
        PostLG_post.invalidateCache();
        PostLG_post.fetchData();
    }

    function closeToShowUnGroupedPosts_POST(){
        PostLG_post.setImplicitCriteria(null);
    }
    // </script>