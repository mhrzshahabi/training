<%@ page import="static com.nicico.copper.core.SecurityUtil.hasAuthority" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>
    let LoadAttachments_Post = null;
    let PostDS_Url = viewPostUrl + "/post/iscList";

    // ------------------------------------------- Menu -------------------------------------------
    PostMenu_post = isc.Menu.create({
        data: [
            <sec:authorize access="hasAuthority('Post_R')">
            {
                title: "<spring:message code="refresh"/>",
                icon: "<spring:url value="refresh.png"/>",
                click: function () {
                    objectIdAttachment=null;
                    LoadAttachments_Post.ListGrid_JspAttachment.setData([]);
                    closeToShowUnGroupedPosts_POST();
                    refreshLG(PostLG_post);
                }
            },
            </sec:authorize>
            {isSeparator: true},
            <sec:authorize access="hasAuthority('remove.uncertainty.needAssessment.changes')">
            {
                title: "<spring:message code="remove.uncertainty.needAssessment.changes"/>",
                click: function () {
                    receive_post_response();
                }
            }
            </sec:authorize>

        ]
    });

    // ------------------------------------------- forms -------------------------------------------
    // var DynamicForm_PostAlarmSelection = isc.DynamicForm.create({
    //     width: "85%",
    //     height: "100%",
    //     fields: [
    //         {
    //
    //             name: "loadTypeSelect",
    //             title: "",
    //             type: "radioGroup",
    //             defaultValue: "1",
    //             valueMap: {
    //                 "1": "لیست تمامی پست ها",
    //                 "2": "لیست پست های عملیاتی",
    //             },
    //             vertical: false,
    //             changed: function (form, item, value) {
    //                 if (value === "1") {
    //                     LoadAttachments_Post.ListGrid_JspAttachment.setData([]);
    //                     objectIdAttachment=null
    //                     PostDS_Url = viewPostUrl + "/iscList" ;
    //                     PostDS_post.fetchDataURL = PostDS_Url ;
    //                     PostLG_post.invalidateCache();
    //                     closeToShowUnGroupedPosts_POST();
    //                 } else if(value === "2"){
    //                     objectIdAttachment=null
    //                     LoadAttachments_Post.ListGrid_JspAttachment.setData([]);
    //                     PostDS_Url = viewPostUrl + "/roleIndPostIscList" ;
    //                     PostDS_post.fetchDataURL = PostDS_Url ;
    //                     PostLG_post.invalidateCache();
    //                 }
    //
    //             },
    //         }
    //     ]
    // });


    // ------------------------------------------- ToolStrip -------------------------------------------
    ToolStripButton_EditNA_POST = isc.ToolStripButton.create({
        title: "ویرایش نیازسنجی",
        click: function () {
            if (PostLG_post.getSelectedRecord() == null){
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                return;
            }
            if (postAdmin==="true" || (ListGrid_TrainingPost_Jsp.getSelectedRecord().hasPermission!==undefined && ListGrid_TrainingPost_Jsp.getSelectedRecord().hasPermission!==null && ListGrid_TrainingPost_Jsp.getSelectedRecord().hasPermission===true)){
                Window_NeedsAssessment_Edit.showUs(PostLG_post.getSelectedRecord(), "Post",false);
            }else {
                simpleDialog("پیغام", "شما دسترسی ویرایش نیازسنجی ندارید . در صورت نیاز , دسترسی به پست مربوطه را در نقش عملیاتی داده شود", 0, "say");

            }
        }
    });
    ToolStripButton_EditNA_POSTGap = isc.ToolStripButton.create({
        title: "ویرایش نیازسنجی (گپ)",
        click: function () {
            if (PostLG_post.getSelectedRecord() == null){
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                return;
            }
            if (postAdmin==="true"  || (ListGrid_TrainingPost_Jsp.getSelectedRecord().hasPermission!==undefined && ListGrid_TrainingPost_Jsp.getSelectedRecord().hasPermission!==null && ListGrid_TrainingPost_Jsp.getSelectedRecord().hasPermission===true)){
                Window_NeedsAssessment_Edit_Gap.showUs(PostLG_post.getSelectedRecord(), "Post",true);
            }else {
                simpleDialog("پیغام", "شما دسترسی ویرایش نیازسنجی ندارید . در صورت نیاز , دسترسی به پست مربوطه را در نقش عملیاتی داده شود", 0, "say");
            }
        }
    });
    ToolStripButton_NA_Post_all_competece_gap = isc.ToolStripButton.create({
        title: "نمای کلی  نیازسنجی بر اساس گپ شایستگی",
        click: function () {
            if (PostLG_post.getSelectedRecord() == null) {
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                return;
            }
            Window_NeedsAssessment_all_competence_gap.showUs(PostLG_post.getSelectedRecord(), "Post",true);
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
            <sec:authorize access="hasAuthority('NeedAssessment_U')">
            ToolStripButton_EditNA_POST,
            </sec:authorize>
            <sec:authorize access="hasAuthority('NeedAssessment_T')">
            ToolStripButton_TreeNA_JspPost,
            </sec:authorize>
            <sec:authorize access="hasAuthority('NeedAssessment_U')">
            ToolStripButton_EditNA_POSTGap,
            </sec:authorize>
            <sec:authorize access="hasAuthority('NeedAssessment_U')">
            ToolStripButton_NA_Post_all_competece_gap,
            </sec:authorize>
            <sec:authorize access="hasAuthority('Post_P')">
            ToolStrip_Post_Export2EXcel
            </sec:authorize>
        ]
    });

    PostTS_post = isc.ToolStrip.create({
        membersMargin: 5,
        members: [
            <sec:authorize access="hasAuthority('Post_R')">
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
            </sec:authorize>
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
                    <sec:authorize access="hasAuthority('Post_R')">
                    isc.ToolStripButtonRefresh.create({
                        click: function () {
                            LoadAttachments_Post.ListGrid_JspAttachment.setData([]);
                            objectIdAttachment=null
                            PostDS_post.fetchDataURL = PostDS_Url ;
                            closeToShowUnGroupedPosts_POST();
                            refreshLG(PostLG_post);
                        }
                    })
                    </sec:authorize>
                ]
            })
        ]
    });
    Delete_Button_response_post = isc.Button.create({
        title: "حذف نیازسنجی فعلی"  ,
        top: 260,
        layoutMargin: 5,
        membersMargin: 5,
        click: function () {
            delete_uncertainly_assessment_post();
        }
    });
    Cancel_Button_Response_post = isc.IButtonCancel.create({
        layoutMargin: 5,
        membersMargin: 5,
        width: 120,
        click: function () {
            Window_delete_uncertainly_needAssessment_post.close();
        }
    });
    HLayout_IButtons_Uncertainly_needAssessment_post = isc.HLayout.create({
        layoutMargin: 5,
        membersMargin: 15,
        width: "100%",
        height: "100%",
        align: "center",
        members: [
            Delete_Button_response_post,

            Cancel_Button_Response_post,

        ]
    });

    DynamicForm_Uncertainly_needAssessment_post= isc.DynamicForm.create({
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
    Window_delete_uncertainly_needAssessment_post = isc.Window.create({
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

            DynamicForm_Uncertainly_needAssessment_post,
            HLayout_IButtons_Uncertainly_needAssessment_post,

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
            {name: "mojtameTitle", title: "<spring:message code="complex"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "assistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "section", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterCode", title: "<spring:message code="reward.cost.center.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterTitleFa", title: "<spring:message code="reward.cost.center.title"/>", filterOperator: "iContains", autoFitWidth: true},
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
            // if (postAdmin !== undefined && postAdmin != null) {
            //
            //     if (postAdmin === "true") {
                    PostDS_post.fetchDataURL = viewPostUrl + "/post/iscList";
                // } else {
                //     PostDS_post.fetchDataURL = viewPostUrl + "/roleIndPostIscList";
                // }
            // }
            transformCriteriaForLastModifiedDateNA(dsRequest);
            return this.Super("transformRequest", arguments);
        },
        // fetchDataURL: PostDS_Url_User_posts
    });

    PostLG_post = isc.TrLG.create({
        selectionType: "single",
        <sec:authorize access="hasAuthority('Post_R')">
        dataSource: PostDS_post,
        autoFetchData: true,
        </sec:authorize>
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
            {name: "area", hidden: true},
            {name: "mojtameTitle"},
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

    RestDataSource_Post_PostInfo = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "startDate"},
            {name: "endDate"},
            {name: "personnelCompanyName"},
            {name: "personnelCode"},
            {name: "firstName"},
            {name: "lastName"},
            {name: "nationalCode"}
        ]
    });
    ListGrid_Post_PostInfo = isc.TrLG.create({
        dataSource: RestDataSource_Post_PostInfo,
        selectionType: "single",
        autoFetchData: false,
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "personnelCompanyName",title: "شرکت"},
            {name: "personnelCode",title: "کد پرسنلی"},
            {name: "startDate",title: "تاریخ شروع",
                formatCellValue: function (value) {
                    if (value) {
                        let date = new Date (value);
                        return date.toLocaleString('fa',{ year: 'numeric', month: 'numeric', day: 'numeric' });
                    }
                }},
            {name: "endDate",title: "تاریخ پایان",
                formatCellValue: function (value) {
                    if (value) {
                        let date = new Date (value);
                        return date.toLocaleString('fa',{ year: 'numeric', month: 'numeric', day: 'numeric' });
                    }
                }},
            {name: "firstName",title: "نام"},
            {name: "lastName",title: "نام خانوادگی"},
            {name: "nationalCode",title: "کد ملی"}

        ]
    });

    defineWindowsEditNeedsAssessment(PostLG_post);
    defineWindowsEditNeedsAssessmentForGap(PostLG_post);
    defineWindow_NeedsAssessment_all_competence_gap(PostLG_post);
    defineWindowTreeNeedsAssessment();


    // ------------------------------------------- Window -------------------------------------------

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

                    let record = PostLG_post.getSelectedRecord();
                    if (record == null)
                        createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                    else {
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

                        ExportToFile.downloadExcel(null, CoursesLG_POST , "NeedsAssessmentReport", 0, null, '',"لیست نیازسنجی پست انفرادی - کدپست: " + record.code + " " + "عنوان پست: " + record.titleFa, criteria, null);
                    }
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
                title: "<spring:message code='need.assessment'/>",
                pane: CoursesLG_POST
            },
            {
                ID: "Post_AttachmentsTab",
                title: "<spring:message code="attachments"/>",
            },
            {
                ID: "Post_PostInfoTab",
                title: "<spring:message code="post.info"/>",
                pane:ListGrid_Post_PostInfo
            }
        ],
        tabSelected: function (){
            selectionUpdated_Post();
        }
    });

    //////////////////////////////////////////////////////////////detailTab/////////////////////////////////////////////

    isc.TrVLayout.create({
        members: [
            PostLG_post,
            <sec:authorize access="hasAuthority('Post_R')">
            DetailTS_Post
            </sec:authorize>
        ]
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
           case "Post_PostInfoTab": {
               RestDataSource_Post_PostInfo.fetchDataURL = hrmDataUrl + "/postHistory-by-postCode?postCode="+ post.code;
               ListGrid_Post_PostInfo.fetchData();
               ListGrid_Post_PostInfo.invalidateCache();
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
    function receive_post_response(){
        let record= PostLG_post.getSelectedRecord();
        DynamicForm_Uncertainly_needAssessment_post.clearValues();
        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/getNeedAssessmentTempByCode?code=" + record.code, "GET", null, function (resp) {
            wait.close();
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                let detail = JSON.parse(resp.httpResponseText);
                DynamicForm_Uncertainly_needAssessment_post.setValues(detail);
                Window_delete_uncertainly_needAssessment_post.show();
            } else {
                createDialog("info", "<spring:message code="this.code.doesnt.have.needAssessment"/>", "<spring:message code="error"/>");
            }
        }));



    }
    function delete_uncertainly_assessment_post(){
        let record=  PostLG_post.getSelectedRecord();

        if (postAdmin==="true"  || (record.hasPermission!==undefined && record.hasPermission!==null && record.hasPermission===true)){
            DynamicForm_Uncertainly_needAssessment_post.clearValues();
            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/removeConfirmation?code=" + record.code, "GET", null, function (resp) {
                wait.close();
                if (resp.httpResponseCode === 201 || resp.httpResponseCode===200)   {

                    Window_delete_uncertainly_needAssessment_post.close();
                    createDialog("info","عملیات حذف موفقیت آمیز بود")
                } else {
                    createDialog("info", "<spring:message code="delete.was.not.successful"/>", "<spring:message code="error"/>");
                }
            }));
        }else {
            simpleDialog("پیغام", "شما دسترسی حذف ندارید . در صورت نیاز , دسترسی به پست مربوطه  در نقش عملیاتی داده شود", 0, "say");

        }

    }

    // </script>