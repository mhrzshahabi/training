<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>
    let LoadAttachments_Post = null;
    <%--if(Window_NeedsAssessment_Edit === undefined) {--%>
        <%--var Window_NeedsAssessment_Edit = isc.Window.create({--%>
            <%--ID: "Window_NeedsAssessment_Edit",--%>
            <%--title: "<spring:message code="needs.assessment"/>",--%>
            <%--minWidth: 1024,--%>
            <%--items: [isc.ViewLoader.create({autoDraw: true, viewURL: "web/edit-needs-assessment/"})],--%>
            <%--// items: [isc.ViewLoader.create({autoDraw: true, viewURL: "web/diff-needs-assessment/"})],--%>
            <%--placement: "fillScreen",--%>
            <%--showUs(record, objectType) {--%>
                <%--loadEditNeedsAssessment(record, objectType);--%>
                <%--// loadDiffNeedsAssessment(record, objectType);--%>
                <%--isChanged = false;--%>
                <%--this.Super("show", arguments);--%>
            <%--},--%>
        <%--});--%>
    // }

    <%--if(Window_NeedsAssessment_Tree === undefined) {--%>
        <%--var Window_NeedsAssessment_Tree = isc.Window.create({--%>
            <%--title: "<spring:message code="needs.assessment"/>",--%>
            <%--placement: "fillScreen",--%>
            <%--minWidth: 1024,--%>
            <%--items: [isc.ViewLoader.create({autoDraw: true, viewURL: "web/tree-needs-assessment/"})],--%>
            <%--showUs(record, objectType) {--%>
                <%--loadNeedsAssessmentTree(record, objectType);--%>
                <%--this.Super("show", arguments);--%>
            <%--},--%>
        <%--});--%>
    <%--}--%>



    // ------------------------------------------- Menu -------------------------------------------
    PostMenu_post = isc.Menu.create({
        data: [
            {
                title: "<spring:message code="refresh"/>",
                icon: "<spring:url value="refresh.png"/>",
                click: function () {
                    objectIdAttachment=null
                    LoadAttachments_Post.ListGrid_JspAttachment.setData([]);
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
        }
    });
    ToolStripButton_TreeNA_JspPost = isc.ToolStripButton.create({
        title: "درخت نیازسنجی",
        click: function () {
            if (PostLG_post.getSelectedRecord() == null){
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                return;
            }
            Window_NeedsAssessment_Tree.showUs(PostLG_post.getSelectedRecord(), "Post");
        }
    });

    let ToolStrip_Post_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let criteria = PostLG_post.getCriteria();
                    ExportToFile.downloadExcel(null, PostLG_post , "View_Post", 0, null, '',"لیست پست ها- آموزش"  , criteria, null);
                }
            })
        ]
    });

    ToolStrip_NA_POST = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            ToolStripButton_unGroupedPosts_POST,
            ToolStripButton_newPosts_POST,
            ToolStripButton_EditNA_POST,
            ToolStripButton_TreeNA_JspPost,
            ToolStrip_Post_Export2EXcel
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
            // isc.ToolStripButton.create({
            //     title: 'نمايش مجتمع ها از وبسرويس',
            //     click: function () {
            //         DepartmentWebserviceLG_post.invalidateCache();
            //         DepartmentWebserviceLG_post.fetchData();
            //         Window_DepartmentWebService_Post.show();
            //     }
            // }),
            // isc.ToolStripButton.create({
            //     title: 'نمايش پست ها از وبسرويس',
            //     click: function () {
            //         PostWebserviceLG_post.invalidateCache();
            //         PostWebserviceLG_post.fetchData();
            //         Window_PostWebService_Post.show();
            //     }
            // }),
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
                            LoadAttachments_Post.ListGrid_JspAttachment.setData([]);
                            objectIdAttachment=null
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
            {name: "peopleType", title: "<spring:message code="people.type"/>", filterOperator: "equals", autoFitWidth: true, valueMap:peopleTypeMap},
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
            {name: "lastModifiedDateNA", title: "<spring:message code="update.date"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "modifiedByNA", title: "<spring:message code="updated.by"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {
                name: "enabled",
                title: "<spring:message code="active.status"/>",
                align: "center",
                filterOperator: "equals",
                autoFitWidth: true,
                autoFitWidthApproach: "both",
            },
        ],
        fetchDataURL: viewPostUrl + "/iscList"
    });

    DepartmentWebserviceDS_post = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true, filterOperator: "equals"},
            {name: "code", filterOperator: "iContains"},
            {name: "latinTitle", filterOperator: "iContains"},
            {name: "title", filterOperator: "iContains"},
            {name: "type", filterOperator: "iContains"},
            {name: "nature", filterOperator: "iContains"},
            {name: "startDate", filterOperator: "iContains"},
            {name: "endDate", filterOperator: "iContains"},
            {name: "legacyCreateDate", filterOperator: "iContains"},
            {name: "legacyChangeDate", filterOperator: "iContains"},
            {name: "active", filterOperator: "iContains"},
            {name: "oldCode", filterOperator: "iContains"},
            {name: "newCode", filterOperator: "iContains"},
            {name: "user", filterOperator: "iContains"},
            {name: "issuable", filterOperator: "iContains"},
            {name: "comment", filterOperator: "iContains"},
            {name: "correction", filterOperator: "iContains"},
            {name: "alignment", filterOperator: "iContains"},

        ],
        fetchDataURL: masterDataUrl + "/department/iscList"
    });

    PostWebserviceDS_post = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
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
        ],
        fetchDataURL: masterDataUrl + "/post/iscList?type=ContractorPersonal"
    });

    PostLG_post = isc.TrLG.create({
        selectionType: "single",
        dataSource: PostDS_post,
        fields: [
            {name: "code",
                filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                }
            },
            {name: "peopleType", filterOnKeypress: true},
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
        gridComponents: [PostTS_post, ToolStrip_NA_POST, "filterEditor", "header", "body",],
        contextMenu: PostMenu_post,
        showResizeBar: true,
        canMultiSort: true,
        initialSort: [
            {property: "competenceCount", direction: "ascending"},
            {property: "code", direction: "ascending"}
        ],
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
            selectionUpdated_Post()
        },
        getCellCSSText: function (record) {
            return setColorForListGrid(record)

        },
    });

    defineWindowsEditNeedsAssessment(PostLG_post);
    defineWindowTreeNeedsAssessment();


    DepartmentWebserviceLG_post = isc.TrLG.create({
        dataSource: DepartmentWebserviceDS_post,
        autoFetchData: true,
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code"},
            {name: "latinTitle"},
            {name: "title"},
            {name: "type"},
            {name: "nature"},
            {name: "startDate"},
            {name: "endDate"},
            {name: "legacyCreateDate"},
            {name: "legacyChangeDate"},
            {name: "active"},
            {name: "oldCode"},
            {name: "newCode"},
            {name: "user"},
            {name: "issuable"},
            {name: "comment"},
            {name: "correction"},
            {name: "alignment"}
        ],

        gridComponents: [isc.Label.create({
            ID: "totalsDepartmentWebserviceLabel_post"
        }), "filterEditor", "header", "body"],
        dataChanged: function () {
            let totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown()) {
                totalsDepartmentWebserviceLabel_post.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            } else {
                totalsDepartmentWebserviceLabel_post.setContents("&nbsp;");
            }
        },
        sortField: 0
    });

    PostWebserviceLG_post = isc.TrLG.create({
        dataSource: PostWebserviceDS_post,
        autoFetchData: true,
        fields: [
            {name: "code"},
            {name: "titleFa"},
            {name: "jobTitleFa"},
            {name: "postGradeTitleFa", canFilter: false, canSort: false},
            {name: "area", canFilter: false, canSort: false},
            {name: "assistance", canFilter: false, canSort: false},
            {name: "affairs", canFilter: false, canSort: false},
            {name: "section", canFilter: false, canSort: false},
            {name: "unit", canFilter: false, canSort: false},
            {name: "costCenterCode"},
            {name: "costCenterTitleFa"},
            {name: "competenceCount", canFilter: false, canSort: false},
            {name: "personnelCount", canFilter: false, canSort: false}
        ],

        gridComponents: [isc.FormLayout.create({
            items: [{
                name: "alignment", type: "radioGroup", showTitle: false,
                valueMap: {"Personal":"Personal", "ContractorPersonal":"ContractorPersonal"}, defaultValue: "ContractorPersonal",
                change:"PostWebserviceDS_post.fetchDataURL = masterDataUrl+'/post/iscList?type=' + value;PostWebserviceLG_post.dataSource=PostWebserviceDS_post;refreshLG(PostWebserviceLG_post);"
            }]
        }), isc.Label.create({
            ID: "totalsPostWebserviceLabel_post"
        }), "filterEditor", "header", "body"],
        dataChanged: function () {
            let totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown()) {
                totalsPostWebserviceLabel_post.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            } else {
                totalsPostWebserviceLabel_post.setContents("&nbsp;");
            }
        },
        sortField: 0
    });

    // ------------------------------------------- Window -------------------------------------------

    var Window_DepartmentWebService_Post = isc.Window.create({
        title: "<spring:message code='department'/>",
        width: "100%",
        height: "100%",
        minWidth: "100%",
        minHeight: "100%",
        autoSize: false,
        items: [
            DepartmentWebserviceLG_post,
            isc.HLayout.create({
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
                            Window_DepartmentWebService_Post.close();
                        }
                    })
                ]
            })

        ]
    });


    var Window_PostWebService_Post = isc.Window.create({
        title: "<spring:message code='post'/>",
        width: "100%",
        height: "100%",
        minWidth: "100%",
        minHeight: "100%",
        autoSize: false,
        items: [
            PostWebserviceLG_post,
            isc.HLayout.create({
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
                            Window_DepartmentWebService_Post.close();
                        }
                    })
                ]
            })

        ]
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
        fetchDataURL: personnelUrl + "/iscList"
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

    let ToolStrip_Course_Post_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let criteria = CoursesLG_POST.getCriteria();

                    if(typeof(criteria.operator)=='undefined'){
                        criteria._constructor="AdvancedCriteria";
                        criteria.operator="and";
                    }

                    if(typeof(criteria.criteria)=='undefined'){
                        criteria.criteria=[];
                    }
                    criteria.criteria.push({fieldName: "objectId", operator: "equals", value: PostLG_post.getSelectedRecord().id});
                    criteria.criteria.push({fieldName: "objectType", operator: "equals", value: "Post"});
                    // criteria.criteria.push({fieldName: "personnelNo", operator: "equals", value: null});

                    ExportToFile.downloadExcel(null, CoursesLG_POST , "NeedsAssessmentReport", 0, null, '',"لیست نیازسنجی - آموزش"  , criteria, null);
                }
            })
        ]
    });

    let ActionsTS_Course_Post = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStrip_Course_Post_Export2EXcel
        ]
    });

    CoursesLG_POST = isc.TrLG.create({
        dataSource: CourseDS_POST,
        selectionType: "none",
        autoFetchData: false,
        alternateRecordStyles: true,
        showAllRecords: true,
        gridComponents: [
            ActionsTS_Course_Post,
            "header", "filterEditor", "body",],
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
            {
                ID:"Post_NeedAssesment",
                title: "<spring:message code='need.assessment'/>", pane: CoursesLG_POST},
            {
                ID: "Post_AttachmentsTab",
                title: "<spring:message code="attachments"/>",
            },

        ],
        tabSelected: function (){
            selectionUpdated_Post();
        }
    });

    //////////////////////////////////////////////////////////////detailTab/////////////////////////////////////////////

    isc.TrVLayout.create({
        members: [PostLG_post, DetailTS_Post],
    });

    // ------------------------------------------- Functions -------------------------------------------

    function setDetailViewer_Personnel(postId) {
        DetailViewer_Personnel.setImplicitCriteria({
            _constructor: "AdvancedCriteria",
            operator: "and",
            criteria: [{fieldName: "postId", operator: "equals", value: postId},
                        {fieldName: "deleted", operator: "equals", value: 0}]
        });
        DetailViewer_Personnel.invalidateCache();
        DetailViewer_Personnel.fetchData();
    }

    function callToShowUnGroupedPosts_POST(criteria){
        CoursesLG_POST.setData([]);
        PostLG_post.setImplicitCriteria(criteria);
        PostLG_post.invalidateCache();
        PostLG_post.fetchData();
    }
    function selectionUpdated_Post() {
       let post = PostLG_post.getSelectedRecord();
       let tab = DetailTS_Post.getSelectedTab();
       if (post == null && tab.pane != null) {
           tab.pane.setData([]);
           return;
       }

       switch (tab.name || tab.ID) {
           case "Post_NeedAssesment": {
               CourseDS_POST.fetchDataURL = needsAssessmentReportsUrl + "?objectId=" + post.id + "&objectType=Post";
               CourseDS_POST.invalidateCache();
               CourseDS_POST.fetchData();
               CoursesLG_POST.invalidateCache();
               CoursesLG_POST.fetchData();
               break;
           }
           case "Post_AttachmentsTab": {
               if (typeof LoadAttachments_Post.loadPage_attachment_Job !== "undefined")
                   LoadAttachments_Post.loadPage_attachment_Job("Post", post.id, "<spring:message code="attachment"/>", {
                       1: "جزوه",
                       2: "لیست نمرات",
                       3: "لیست حضور و غیاب",
                       4: "نامه غیبت موجه"
                   }, false);
               break;
           }


       }
   }
    function closeToShowUnGroupedPosts_POST(){
        PostLG_post.setImplicitCriteria(null);
    }

    if (!loadjs.isDefined('load_Attachments_post')) {
        loadjs('<spring:url value='tclass/attachments-tab' />', 'load_Attachments_post');
    }

    loadjs.ready('load_Attachments_post', function () {
        setTimeout(()=> {
            LoadAttachments_Post = new loadAttachments();
            DetailTS_Post.updateTab(Post_AttachmentsTab, LoadAttachments_Post.VLayout_Body_JspAttachment)
        },0);

    })

    // </script>