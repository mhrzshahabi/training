<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="Spring" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<% final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN); %>

// <script>

    let saveMethodInManagement = null;
    let selectedObject_Request_management = null;

    //----------------------------------------------------Rest DataSource-----------------------------------------------

    RestDataSource_Competence_Management = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "applicant", title: "درخواست دهنده", filterOperator: "iContains"},
            {name: "requestDate", title: "تاریخ درخواست", filterOperator: "iContains"},
            {name: "letterDate", title: "تاریخ نامه", filterOperator: "iContains"},
            {name: "letterNumber", title: "شماره نامه کارگزینی", filterOperator: "iContains"},
            {name: "complex", title: "مجتمع", filterOperator: "iContains"},
            {name: "title", title: "عنوان", filterOperator: "iContains"},
            {name: "acceptor", title: "تایید کننده", filterOperator: "iContains"},
            {name: "description", title: "توضیحات", filterOperator: "iContains"}
        ],
        fetchDataURL: trainingRequestManagementUrl + "/spec-list"
    });

    let RestDataSource_complex_Department_Filter = isc.TrDS.create({
        fields: [{name: "id"}, {name: "code"}, {name: "title"}, {name: "enabled"}],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/organ-segment-iscList/mojtame"
    });

    UserDS_JspTrainingRequest = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {
                name: "firstName",
                title: "<spring:message code="firstName"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "lastName",
                title: "<spring:message code="lastName"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "username",
                title: "<spring:message code="username"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "nationalCode",
                title: "<spring:message code="national.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {name: "version", hidden: true}
        ],
        fetchDataURL: oauthUserUrl + "/spec-list"
    });

    RestDataSource_req_item = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true,hidden:true},
            {
                name: "name",
                title: "نام",
                filterOperator: "iContains"},{
                name: "lastName",
                title: "نام خانوادگی",
                filterOperator: "iContains"},{
                name: "nationalCode",
                title: "کد ملی",
                filterOperator: "iContains"},{
                name: "currentPostTitle",
                title: "عنوان پست فعلی",
                filterOperator: "iContains"},{
                name: "currentPostCode",
                title: "کد پست فعلی",
                filterOperator: "iContains"},{
                name: "personnelNo2",
                title: "کد پرسنلی ۱۰ رقمی",
                filterOperator: "iContains"},{
                name: "personnelNo",
                title: "کد پرسنلی ۶ رقمی",
                filterOperator: "iContains"},{
                name: "nextPostTitle",
                title: "عنوان پست جاری",
                filterOperator: "iContains"},{
                name: "nextPostCode",
                title: "کد پست پیشنهادی",
                filterOperator: "iContains"},
        ]

    });

    let PersonnelDS_JspReqManagement = isc.TrDS.create({
        fields: [
            {name: "id", filterOperator: "equals", primaryKey: true, hidden: true},
            {name: "fullName", title: "نام و نام خانوادگی", filterOperator: "iContains"},
            {
                name: "nationalCode",
                title: "<spring:message code="national.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                autoFitWidthApproach: "both"
            },
            {
                name: "personnelNo",
                title: "<spring:message code="personnel.no"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                autoFitWidthApproach: "both"
            },
            {
                name: "personnelNo2",
                title: "<spring:message code="personnel.no.6.digits"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                autoFitWidthApproach: "both"
            },
        ],
        fetchDataURL: viewActivePersonnelUrl + "/iscList",
    });

    PostDS_Request_management = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "peopleType", title: "<spring:message code="people.type"/>", filterOperator: "equals", autoFitWidth: true, valueMap:{"Personal" : "شرکتی", "ContractorPersonal" : "پیمان کار"},filterOnKeypress: true},
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
            {name: "competenceCount", hidden: true, title: "تعداد شایستگی", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelCount", hidden: true, title: "تعداد پرسنل", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "lastModifiedDateNA", title: "<spring:message code="update.date"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "modifiedByNA", title: "<spring:message code="updated.by"/>", align: "center", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals", autoFitWidth: true, filterOnKeypress: true,valueMap:{74 : "غیر فعال"}}
        ],
        fetchDataURL: viewPostUrl + "/iscList"
    });

    PriorityDS_Management = isc.TrDS.create({
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

    CompetenceTypeDS_Management = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/competenceType"
    });

    DomainDS_Management= isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/NeedsAssessmentDomain"
    });

    ScoresStateDS_Management = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/PassedStatus"
    });


    needAssessmentDS_Request_management = isc.TrDS.create({
        fields: [
        {name: "id", primaryKey: true, hidden: true},
        {name: "needsAssessmentPriorityId", title: "<spring:message code='priority'/>", filterOperator: "equals", autoFitWidth: true},
        {name: "needsAssessmentDomainId", title: "<spring:message code='domain'/>", filterOperator: "equals", autoFitWidth: true},
        {name: "competence.title", title: "<spring:message code="competence"/>", filterOperator: "iContains", autoFitWidth: true},
        {name: "competence.competenceTypeId", title: "<spring:message code="competence.type"/>", filterOperator: "equals", autoFitWidth: true},
        {name: "skill.code", title: "<spring:message code="skill.code"/>", filterOperator: "iContains", autoFitWidth: true},
        {name: "skill.titleFa", title: "<spring:message code="skill"/>", filterOperator: "iContains", autoFitWidth: true},
        {name: "skill.course.theoryDuration", title: "<spring:message code="duration"/>", filterOperator: "equals", autoFitWidth: true,
            filterEditorProperties: {
                keyPressFilter: "[0-9]"
            }
        },
        {name: "skill.course.scoresState", title: "<spring:message code='status'/>", filterOperator: "equals", autoFitWidth: true},
        {name: "skill.course.scoresStatus", title: "<spring:message code='score.state'/>", filterOperator: "iContains", autoFitWidth: true},
        {name: "skill.course.code", title: "<spring:message code="course.code"/>", filterOperator: "iContains", autoFitWidth: true},
        {name: "skill.course.titleFa", title: "<spring:message code="course"/>", filterOperator: "iContains", autoFitWidth: true}
        ],
        cacheAllData: true,
        fetchDataURL: null
    });

    needAssessmentDS_Request_managementGap = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "needsAssessmentPriorityId", title: "<spring:message code='priority'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "needsAssessmentDomainId", title: "<spring:message code='domain'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "limitSufficiency", title: "حد بسندگی", filterOperator: "equals", autoFitWidth: true},
            {name: "competence.title", title: "<spring:message code="competence"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "competence.competenceType.title", title: "<spring:message code="competence.type"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "skill.code", title: "<spring:message code="skill.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "skill.titleFa", title: "<spring:message code="skill"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "skill.course.theoryDuration", title: "<spring:message code="duration"/>", filterOperator: "equals", autoFitWidth: true,
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "skill.course.scoresState", title: "<spring:message code='status'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "skill.course.scoresStatus", title: "<spring:message code='score.state'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "skill.course.code", title: "<spring:message code="course.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "skill.course.titleFa", title: "<spring:message code="course"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "committeeScore", title: "نمره داده شده توسط کمیته", filterOperator: "iContains", autoFitWidth: true},
            {name: "competenceStatus", title: "وضعیت شایستگی", filterOperator: "iContains", autoFitWidth: true}
        ],
        cacheAllData: true,
        fetchDataURL: null
    });


    PostsLG_Request_management = isc.TrLG.create({
        dataSource: PostDS_Request_management,
        selectionType: "single",
        autoFetchData: true,

        rowDoubleClick: "Select_Post_Request_management()",
        sortField: 1,
        sortDirection: "descending"
    });

    PriorityDS_Request_managementGap = isc.TrDS.create({
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

    needAssessmenLG_Request_management = isc.TrLG.create({
        dataSource: needAssessmentDS_Request_management,
         selectionType: "single",
        autoFetchData: true,
        sortField: 1,
        fields: [
            {
                name: "needsAssessmentPriorityId",
                hidden: true,
                filterOnKeypress: true,
                editorType: "SelectItem",
                displayField: "title",
                valueField: "id",
                optionDataSource: PriorityDS_Management,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [
                    {name: "title", width: "30%"}
                ],
                sortNormalizer(record){
                    switch (record.needsAssessmentPriorityId) {
                        case 574:
                            return 0;
                        case 111:
                            return 1;
                        case 112:
                            return 2;
                        case 113:
                            return 3;
                        default:
                            return record.needsAssessmentPriorityId;
                    }
                }
            },
            {
                name: "competence.title",
                // hidden: true
            },
            {
                name: "competence.competenceTypeId",
                // hidden: true,
                type: "SelectItem",
                filterOnKeypress: true,
                displayField: "title",
                valueField: "id",
                optionDataSource: CompetenceTypeDS_Management,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [
                    {name: "title", width: "30%"}
                ],
            },
            {
                name: "needsAssessmentDomainId",
                // hidden: true,
                // type: "IntegerItem",
                filterOnKeypress: true,
                editorType: "SelectItem",
                displayField: "title",
                valueField: "id",
                optionDataSource: DomainDS_Management,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [
                    {name: "title", width: "30%"}
                ],
            },
            {
                name: "skill.code",
                // hidden: true
            },
            {
                name: "skill.titleFa",
                // hidden: true
            },

            {name: "skill.course.code"},
            {name: "skill.course.titleFa"},
            {
                name: "skill.course.theoryDuration",
                showGroupSummary: true
            },
            {
                name: "skill.course.scoresState",
                // type: "IntegerItem",
                filterOnKeypress: true,
                editorType: "SelectItem",
                displayField: "title",
                valueField: "id",
                optionDataSource: ScoresStateDS_Management,
                addUnknownValues: false,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [
                    {name: "title", width: "30%"}
                ],
            },
            {
                name: "skill.course.scoresStatus"
            },
        ],
        sortDirection: "descending"
    });


    needAssessmenLG_Request_managementGap = isc.TrLG.create({
        dataSource: needAssessmentDS_Request_managementGap,
        selectionType: "single",
        autoFetchData: false,
        alternateRecordStyles: true,
        showAllRecords: true,
        groupByField: "needsAssessmentPriorityId",
        groupStartOpen: "all",
        showGroupSummary: true,
        useClientFiltering: true,
        fields: [
            {
                name: "needsAssessmentPriorityId",
                hidden: true,
                filterOnKeypress: true,
                editorType: "SelectItem",
                displayField: "title",
                valueField: "id",
                optionDataSource: PriorityDS_Request_managementGap,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [
                    {name: "title", width: "30%"}
                ],
                sortNormalizer(record){
                    switch (record.needsAssessmentPriorityId) {
                        case 574:
                            return 0;
                        case 111:
                            return 1;
                        case 112:
                            return 2;
                        case 113:
                            return 3;
                        default:
                            return record.needsAssessmentPriorityId;
                    }
                }
            },
            {
                name: "competence.title",
                // hidden: true
            },
            {
                name: "competence.competenceType.title",
                filterOnKeypress: true,
            },
            {
                name: "needsAssessmentDomainId",
                filterOnKeypress: true,
                editorType: "SelectItem",
                displayField: "title",
                valueField: "id",
                optionDataSource: DomainDS_Management,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [
                    {name: "title", width: "30%"}
                ],
            },
            {
                name: "skill.code",
                // hidden: true
            },
            {
                name: "limitSufficiency",
                // hidden: true
            },
            {
                name: "skill.titleFa",
                // hidden: true
            },

            {name: "skill.course.code"},
            {name: "skill.course.titleFa"},
            // {
            //     name: "skill.course.theoryDuration",
            //     showGroupSummary: true,
            //     summaryFunction: fullSummaryFunc_NAGap
            // },
            {
                name: "skill.course.scoresState",
                // type: "IntegerItem",
                filterOnKeypress: true,
                editorType: "SelectItem",
                displayField: "title",
                valueField: "id",
                optionDataSource: ScoresStateDS_Management,
                addUnknownValues: false,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [
                    {name: "title", width: "30%"}
                ],
            },
            {
                name: "skill.course.scoresStatus"
            },
            {name: "committeeScore"},
            {name: "competenceStatus"}
        ],
        sortField: "needsAssessmentPriorityId"
    });


    //--------------------------------------------------------Actions---------------------------------------------------

    ToolStripButton_Add_training_Managment = isc.ToolStripButtonCreate.create({
        title: "افزودن درخواست",
        click: function () {
            addTrainingRequestManagement();
        }
    });
    ToolStripButton_Edit_training_Request = isc.ToolStripButtonEdit.create({
        click: function () {
            editTrainingRequestRequest();
        }
    });
    ToolStripButton_Delete_training_Managment = isc.ToolStripButtonRemove.create({
        click: function () {
            deleteTrainingManagementRequest();
        }
    });
    ToolStripButton_Excel_Competence_Managment = isc.ToolStripButton.create({
        name: "excelTemplate",
        title: "دریافت فایل خام اکسل",
        icon: "<spring:url value="excel.png"/>",
        click: function () {
            // window.open("excel/certification-input.xlsx");
        }
    });
    ToolStripButton_Refresh_Competence_Managment = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_training_Managment.invalidateCache();
        }
    });

    ToolStrip_Actions_Requests_Managment = isc.ToolStrip.create({
        width: "100%",
        border: '0px',
        membersMargin: 5,
        members: [
            ToolStripButton_Add_training_Managment,
            ToolStripButton_Edit_training_Request,
            ToolStripButton_Delete_training_Managment,
            // ToolStripButton_Excel_Competence_Managment,
            isc.ToolStrip.create({
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_Refresh_Competence_Managment
                ]
            })
        ]
    });


    HLayout_IButtons_req_item = isc.HLayout.create({
        layoutMargin: 5,
        membersMargin: 15,
        width: "100%",
        height: "100%",
        align: "center",
        members: [
            isc.IButtonSave.create({
                top: 260,
                layoutMargin: 5,
                membersMargin: 5,
                click: function () {
                    saveChildReqManagement(ListGrid_req_item,DynamicForm_req_item,Window_req_item)
                }
            }),
            isc.IButtonCancel.create({
                layoutMargin: 5,
                membersMargin: 5,
                width: 120,
                click: function () {
                    Window_req_item.close();
                }
            })
        ]
    });

    IButton_Post_Ok_Request_management = isc.IButtonSave.create({
        title: "<spring:message code="select"/>",
        click: "Select_Post_Request_management()"
    });

    HLayout_Post_Ok_Request_management = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        members: [IButton_Post_Ok_Request_management]
    });


    Tabset_Object_Request_management = isc.TabSet.create({
        tabBarPosition: "right",
        tabBarThickness: 100,
        tabs: [
            {title: "<spring:message code="post.individual"/>", name: "Post", pane: PostsLG_Request_management},
        ],
    });

    Tabset_Object_needAssessment_req_management = isc.TabSet.create({
        tabBarPosition: "right",
        tabBarThickness: 150,
        tabs: [
            {title: "گزارش نیازسنجی", name: "needAssessment", pane: needAssessmenLG_Request_management},
            {title: "پایش شایستگی فرد", name: "needAssessmentGap", pane: needAssessmenLG_Request_managementGap}
        ]
        ,tabSelected: function () {
        let tab = Tabset_Object_needAssessment_req_management.getSelectedTab();



        switch (tab.name) {
            case "needAssessment": {
                needAssessmentDS_Request_management.fetchDataURL = needsAssessmentReportsUrl + "?objectId=" +ListGrid_req_item.getSelectedRecord().postId  + "&personnelId=" + ListGrid_req_item.getSelectedRecord().personnelId + "&objectType=Post";
                needAssessmentDS_Request_management.invalidateCache();
                needAssessmentDS_Request_management.fetchData();
                needAssessmenLG_Request_management.invalidateCache();
                needAssessmenLG_Request_management.fetchData();

                break;
            }
            case "needAssessmentGap": {
                needAssessmentDS_Request_managementGap.fetchDataURL = needsAssessmentReportsWithGapUrl + "?objectId=" +ListGrid_req_item.getSelectedRecord().postId  + "&personnelId=" + ListGrid_req_item.getSelectedRecord().personnelId + "&objectType=Post";
                needAssessmentDS_Request_managementGap.invalidateCache();
                needAssessmentDS_Request_managementGap.fetchData();
                needAssessmenLG_Request_managementGap.invalidateCache();
                needAssessmenLG_Request_managementGap.fetchData();

                break;
            }
        }
    }
    });



    Window_Post_Request_management = isc.Window.create({
        placement: "fillScreen",
        title: "",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        minWidth: 1024,
        items: [isc.TrVLayout.create({
            members: [
                Tabset_Object_Request_management,
                HLayout_Post_Ok_Request_management
            ]
        })]
    });
    Window_needAssessment_req_management = isc.Window.create({
        placement: "fillScreen",
        title: "",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        minWidth: 1024,
        items: [isc.TrVLayout.create({
            members: [
                Tabset_Object_needAssessment_req_management
            ]
        })]
    });





    //----------------------------------------------------Request Window------------------------------------------------
    DynamicForm_req_item = isc.DynamicForm.create({
        width: 400,
        height: "100%",
        numCols: 2,
        fields: [
            {
                name: "id",
                title: "id",
                primaryKey: true,
                canEdit: false,
                hidden: true
            },
            {
                name: "personnelId",
                required: true,
                wrapTitle: false,
                title: "پرسنل",
                type: "SelectItem",
                textAlign: "center",
                optionDataSource: PersonnelDS_JspReqManagement,
                autoFetchData: false,
                valueField: "id",
                pickListWidth: 500,
                pickListFields: [{name: "personnelNo2"}, {name: "fullName"}, {name: "nationalCode"}, {name: "personnelNo"}],
                pickListProperties: {sortField: "personnelNo2", showFilterEditor: true},
                formatValue: function (value, record, form, item) {
                    let selectedRecord = item.getSelectedRecord();
                    if (selectedRecord != null) {
                        return selectedRecord.firstName + " " + selectedRecord.lastName;
                    } else {
                        return value;
                    }
                }
            }, {
                name: "postId",
                title: "انتخاب پست",
                // hidden: true,
                type: "ButtonItem",
                align: "right",
                autoFit: true,
                startRow: false,
                endRow: false,
                click() {
                    PostsLG_Request_management.fetchData();
                    Window_Post_Request_management.show();
                }
            },  {
                name: "postName",
                canEdit: false,
                title: "پست انتخاب شده : ",
                required: true,
                validators: [ TrValidators.NotContainSpecialChar,TrValidators.NotContainSpecialWords,
                    {
                        type: "regexp",
                        errorMessage: "<spring:message code="msg.field.length"/>",
                        expression: /^.{2,150}$/

                    }]
            },


        ]
    });



    DynamicForm_training_Request = isc.DynamicForm.create({
        width: 400,
        height: "100%",
        numCols: 2,
        fields: [
            {
                name: "id",
                title: "id",
                primaryKey: true,
                canEdit: false,
                hidden: true
            },
            {
                name: "applicant",
                title: "درخواست دهنده",
                required: true,
                canEdit: false
            },
            {
                name: "requestDate",
                ID: "date_requestDate_training",
                title: "تاریخ درخواست",
                required: true,
                defaultValue: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('date_requestDate_training', this, 'ymd', '/');
                    }
                }],
                changed: function (form, item, value) {
                    if (value == null || value === "" || checkDate(value))
                        item.clearErrors();
                    else
                        item.setErrors("<spring:message code='msg.correct.date'/>");
                }
            },
            {
                name: "letterDate",
                ID: "letter_requestDate_training",
                title: "تاریخ نامه",
                required: true,
                defaultValue: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('letter_requestDate_training', this, 'ymd', '/');
                    }
                }],
                changed: function (form, item, value) {
                    if (value == null || value === "" || checkDate(value))
                        item.clearErrors();
                    else
                        item.setErrors("<spring:message code='msg.correct.date'/>");
                }
            },
            {
                name: "letterNumber",
                length: 10,
                title: "شماره نامه کارگزینی",
                required: true,
                validators: [ TrValidators.NotContainSpecialChar,TrValidators.NotContainSpecialWords]
            },
            {
                name: "complex",
                editorType: "ComboBoxItem",
                title: "<spring:message code="complex"/>:",
                // pickListWidth: 200,
                optionDataSource: RestDataSource_complex_Department_Filter,
                displayField: "title",
                autoFetchData: true,
                valueField: "title",
                textAlign: "center",
                textMatchStyle: "substring",
                pickListFields: [
                    {name: "title", autoFitWidth: true, autoFitWidthApproach: true},
                ],
                pickListProperties: {
                    sortField: 0,
                    showFilterEditor: false
                },
                required: true
            },
            {
                name: "title",
                length: 50,
                title: "عنوان",
                required: true,
                validators: [ TrValidators.NotContainSpecialChar,TrValidators.NotContainSpecialWords]
            },
            {
                name: "acceptor",
                title: "تایید کننده",
                optionDataSource: UserDS_JspTrainingRequest,
                valueField: "nationalCode",
                displayField: "lastName",
                filterOnKeypress: true,
                type: "SelectItem",
                multiple: false,
                comboBoxProperties: {
                    hint: "",
                    filterFields: ["firstName", "lastName", "username", "nationalCode"],
                    textMatchStyle: "substring",
                    pickListWidth: 335,
                    pickListProperties: {
                        autoFitWidthApproach: "both",
                        gridComponents: [
                            isc.ToolStrip.create({
                                autoDraw:false,
                                height:30,
                                width: "100%",
                                members: [
                                ]
                            }),
                            "header","body"
                        ]
                    },
                    pickListFields: [
                        {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
                        {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains"},
                        {name: "username", title: "<spring:message code="username"/>", filterOperator: "iContains", autoFitWidth: true},
                        {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true}
                    ],
                },
                required: true
            },
            {
                name: "description",
                title: "توضیحات",
                length: 100,
                required: false,
                validators: [ TrValidators.NotContainSpecialChar,TrValidators.NotContainSpecialWords]
            }
        ]
    });

    Save_Button_Add_training_req = isc.IButtonSave.create({
        top: 260,
        layoutMargin: 5,
        membersMargin: 5,
        click: function () {
            saveTrainingRequestManagement();
        }
    });
    Cancel_Button_Add_trainingRequest = isc.IButtonCancel.create({
        layoutMargin: 5,
        membersMargin: 5,
        width: 120,
        click: function () {
            Window_training_Request.close();
        }
    });
    HLayout_IButtons_training_Request = isc.HLayout.create({
        layoutMargin: 5,
        membersMargin: 15,
        width: "100%",
        height: "100%",
        align: "center",
        members: [
            Save_Button_Add_training_req,
            Cancel_Button_Add_trainingRequest
        ]
    });

    Window_training_Request = isc.Window.create({
        title: "افزودن درخواست",
        width: 450,
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: true,
        items: [
            DynamicForm_training_Request,
            HLayout_IButtons_training_Request
        ]
    });
    Window_req_item = isc.Window.create({
         width: 450,
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: true,
        items: [
            DynamicForm_req_item,
            HLayout_IButtons_req_item
        ]
    });

    req_item_actions = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonCreate.create({
                title: "افزودن",
                click: function () {
                    selectedObject_Request_management=null
                    addChildReqManagement(DynamicForm_req_item,Window_req_item,"افزودن انتصاب سمت")
                }.bind(this)
            }),
            isc.ToolStripButtonRemove.create({
                title: "حذف",
                click: function () {
                    deleteReqManagement()
                }.bind(this)
            }),
            isc.ToolStripButtonRefresh.create({
                title: "گزارش نیازسنجی",
                click: function () {
                    needAssessmentReportWindow()
                }.bind(this)
            })
        ]
    });
    //------------------------------------------------------List Grids--------------------------------------------------

    ListGrid_training_Managment = isc.TrLG.create({
        showFilterEditor: true,
        canAutoFitFields: true,
        width: "100%",
        height: "100%",
<%--        <sec:authorize access="hasAuthority('CompetenceRequest_R')">--%>
        dataSource: RestDataSource_Competence_Management,
        // contextMenu: Menu_Requests_Certification,
<%--        </sec:authorize>--%>
        autoFetchData: true,
        alternateRecordStyles: true,
        wrapCells: false,
        showRollOver: false,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        autoFitExpandField: true,
        virtualScrolling: true,
        loadOnExpand: true,
        loaded: false,
        initialSort: [
            {property: "id", direction: "descending"}
        ],
        recordClick: function () {
            selectionUpdated_Management();
        },
        fields: [
            {
                name: "id",
                title: "شماره درخواست",
                primaryKey: true,
                canEdit: false,
                width: "10%",
                align: "center"
            },
            {
                name: "applicant",
                title: "درخواست دهنده",
                width: "10%",
                align: "center"
            },
            {
                name: "title",
                title: "عنوان",
                width: "10%",
                align: "center"
            },
            {
                name: "requestDate",
                title: "تاریخ درخواست",
                width: "10%",
                align: "center",
                canFilter: false,
                formatCellValue: function (value) {
                    if (value) {
                        let date = new Date (value);
                        return date.toLocaleDateString('fa-IR');
                    }
                }
            },

            {
                name: "letterDate",
                title: "تاریخ نامه",
                width: "10%",
                align: "center",
                canFilter: false,
                formatCellValue: function (value) {
                    if (value) {
                        let date = new Date (value);
                        return date.toLocaleDateString('fa-IR');
                    }
                }
            },
            {
                name: "letterNumber",
                title: "شماره نامه کارگزینی",
                width: "10%",
                align: "center"
            },
            {
                name: "complex",
                title: "مجتمع",
                width: "10%",
                align: "center"
            },
            {
                name: "description",
                title: "توضیحات",
                width: "10%",
                align: "center"
            },
            {
                name: "acceptor",
                title: "کد ملی تایید کننده",
                width: "10%",
                align: "center"
            }
        ],

    });

    ListGrid_req_item = isc.ListGrid.create({
        dataSource: RestDataSource_req_item,
        sortDirection: "descending",
        showFilterEditor: true,
        filterOnKeypress: true,
        canAutoFitFields: true,
        width: "100%",
        height: "100%",
        autoFetchData: false,
        initialSort: [
            {property: "id", direction: "descending"}
        ],
        fields: [
            {
                name: "id",
                hidden: true,
                primaryKey: true,
                canFilter: false,
                canEdit: false,
                align: "center"
            },{
                name: "name",
                hidden: false,
                canFilter: false,
                canEdit: false,
                align: "center"
            },{
                name: "lastName",
                hidden: false,
                canFilter: false,
                align: "center"
            },{
                name: "nationalCode",
                hidden: false,
                canFilter: false,
                canEdit: false,
                align: "center"
            },{
                name: "currentPostTitle",
                hidden: false,
                canFilter: false,
                canEdit: false,
                align: "center"
            },{
                name: "currentPostCode",
                hidden: false,
                canFilter: false,
                canEdit: false,
                align: "center"
            },{
                name: "personnelNo2",
                hidden: false,
                canFilter: false,
                canEdit: false,
                align: "center"
            },{
                name: "personnelNo",
                hidden: false,
                canEdit: false,
                canFilter: false,
                align: "center"
            },{
                name: "nextPostCode",
                hidden: false,
                canFilter: false,
                canEdit: false,
                align: "center"
            },{
                name: "nextPostTitle",
                hidden: false,
                canFilter: false,
                canEdit: false,
                align: "center"
            },{
                name: "personnelId",
                hidden: true,
                canFilter: false,
                canEdit: false,
                align: "center"
            },{
                name: "postId",
                hidden: true,
                canFilter: false,
                canEdit: false,
                align: "center"
            }



        ],
        gridComponents: [req_item_actions, "filterEditor", "header", "body", "summaryRow"]


    });


    Managment_Detail_Tabs = isc.TabSet.create({
        tabBarPosition: "top",
        width: "100%",
        height: "100%",
        tabs: [
            {name: "TabPane_position_appointment", title: "انتصاب سمت"
                , pane: ListGrid_req_item
            },
            {name: "TabPane_switching", title: " تغییر وضعیت"
                , pane: ListGrid_req_item
            },
            {name: "TabPane_ojt", title: "درخواست دوره OJT"
                , pane: ListGrid_req_item
            },
            {name: "TabPane_sps", title: "درخواست دوره SPS"
                , pane: ListGrid_req_item
            },
         ],
        tabSelected: function () {
            selectionUpdated_Management();
        }
    });

    //------------------------------------------------------Main Layout-------------------------------------------------

    VLayout_Requests_Managment = isc.VLayout.create({
        width: "100%",
        height: "1%",
        members: [
            ToolStrip_Actions_Requests_Managment,
            ListGrid_training_Managment
        ]
    });
    VLayout_Requests_Detail_Managment = isc.VLayout.create({
        width: "100%",
        members: [
            // ListGrid_Competence_Request_Items
        ]
    });
    HLayout_Body_Managment_Jsp = isc.HLayout.create({
        minWidth: "100%",
        width: "100%",
        members: [
            isc.SectionStack.create({
                sections: [
                    {
                        title: "درخواست های تاییدیه",
                        items: VLayout_Requests_Managment,
                        showHeader: false,
                        expanded: true
                    },
                    {
                        title: "جزئیات درخواست",
                        hidden: true,
                        // items: VLayout_Requests_Detail_Managment,
                        expanded: false
                    }
                ]
            })
        ]
    });

    HLayout_Tabs_Managment = isc.HLayout.create({
        minWidth: "100%",
        width: "100%",
        height: "39%",
        members: [Managment_Detail_Tabs]
    });

    VLayout_Body_Managment_Jsp = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            HLayout_Body_Managment_Jsp,
            HLayout_Tabs_Managment
        ]
    });

    //-------------------------------------------------------Functions--------------------------------------------------

    function addTrainingRequestManagement() {
        saveMethodInManagement = "POST";
        DynamicForm_training_Request.clearValues();
        DynamicForm_training_Request.clearErrors();
        DynamicForm_training_Request.setValue("applicant", userUserName);
        DynamicForm_training_Request.getItem("requestDate").setDisabled(false);
        DynamicForm_training_Request.getItem("letterDate").setDisabled(false);
        Window_training_Request.show();
    }
    function editTrainingRequestRequest() {

        let rec = JSON.parse(JSON.stringify(ListGrid_training_Managment.getSelectedRecord()));

        if (rec == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            saveMethodInManagement = "PUT";
            rec.requestDate = new Date(rec.requestDate).toLocaleDateString('fa-IR');
            rec.letterDate = new Date(rec.letterDate).toLocaleDateString('fa-IR');
            DynamicForm_training_Request.editRecord(rec);
            DynamicForm_training_Request.getItem("requestDate").setDisabled(true);
            DynamicForm_training_Request.getItem("letterDate").setDisabled(true)
            Window_training_Request.show();
        }
    }
    function saveTrainingRequestManagement() {

        if (!DynamicForm_training_Request.validate())
            return;



        if (saveMethodInManagement === "POST") {

            let data = DynamicForm_training_Request.getValues();
            data.requestDate = JalaliDate.jalaliToGregori(data.requestDate);
            data.letterDate = JalaliDate.jalaliToGregori(data.letterDate);

            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(trainingRequestManagementUrl, "POST", JSON.stringify(data), function (resp) {
                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                    wait.close();
                    createDialog("info", "<spring:message code="global.form.request.successful"/>");
                    Window_training_Request.close();
                    ListGrid_training_Managment.invalidateCache();
                } else {
                    wait.close();
                    createDialog("info", "خطایی رخ داده است");
                }
            }));
        } else {


            let record = ListGrid_training_Managment.getSelectedRecord();

            let data = DynamicForm_training_Request.getValues();
            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(trainingRequestManagementUrl + "/" + record.id, "PUT", JSON.stringify(data), function (resp) {
                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                    wait.close();
                    createDialog("info", "<spring:message code="global.form.request.successful"/>");
                    Window_training_Request.close();
                    ListGrid_training_Managment.invalidateCache();
                } else {
                    wait.close();
                    createDialog("info", "خطایی رخ داده است");
                }
            }));
        }

    }
    function deleteTrainingManagementRequest() {

        let record = ListGrid_training_Managment.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            let Dialog_Competence_Request_remove = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                "<spring:message code="verify.delete"/>");
            Dialog_Competence_Request_remove.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        wait.show();
                        isc.RPCManager.sendRequest(TrDSRequest(trainingRequestManagementUrl + "/" + record.id, "DELETE", null, function (resp) {
                            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                wait.close();
                                createDialog("info", "<spring:message code="global.form.request.successful"/>");
                                ListGrid_training_Managment.invalidateCache();

                            } else {
                                wait.close();
                                createDialog("info", "خطایی رخ داده است");
                            }
                        }));
                    }
                }
            });
        }
    }


    function selectionUpdated_Management() {
        let record = ListGrid_training_Managment.getSelectedRecord();
        let tab = Managment_Detail_Tabs.getSelectedTab();

        if (record == null && tab.pane != null) {
            tab.pane.setData([]);
            return;
        }
        switch (tab.name) {
            case "TabPane_position_appointment": {
                RestDataSource_req_item.fetchDataURL = trainingRequestManagementUrl + "/list-items/"+record.id+"/position-appointment";
                ListGrid_req_item.invalidateCache();
            let    cri = createCriteriaInTraRe("trainingRequestManagementId", "equals", record.id);
            let    cri2 = createCriteriaInTraRe("ref", "equals", "position-appointment");
                let mainCriteria = createMainCriteriaInTraReq(cri,cri2);
                ListGrid_req_item.fetchData(mainCriteria);
                break;
            }
            case "TabPane_switching": {
                RestDataSource_req_item.fetchDataURL = trainingRequestManagementUrl + "/list-items/"+record.id+"/switching";
                ListGrid_req_item.invalidateCache();
            let    cri = createCriteriaInTraRe("trainingRequestManagementId", "equals", record.id);
            let    cri2 = createCriteriaInTraRe("ref", "equals", "switching");
                let mainCriteria = createMainCriteriaInTraReq(cri,cri2);
                ListGrid_req_item.fetchData(mainCriteria);
                break;
            }
            case "TabPane_ojt": {
                RestDataSource_req_item.fetchDataURL = trainingRequestManagementUrl + "/list-items/"+record.id+"/ojt";
                ListGrid_req_item.invalidateCache();
                let    cri = createCriteriaInTraRe("trainingRequestManagementId", "equals", record.id);
                let    cri2 = createCriteriaInTraRe("ref", "equals", "ojt");
                let mainCriteria = createMainCriteriaInTraReq(cri,cri2);
                ListGrid_req_item.fetchData(mainCriteria);
                break;
            }
            case "TabPane_sps": {
                RestDataSource_req_item.fetchDataURL = trainingRequestManagementUrl + "/list-items/"+record.id+"/sps";
                ListGrid_req_item.invalidateCache();
                let    cri = createCriteriaInTraRe("trainingRequestManagementId", "equals", record.id);
                let    cri2 = createCriteriaInTraRe("ref", "equals", "sps");
                let mainCriteria = createMainCriteriaInTraReq(cri,cri2);
                ListGrid_req_item.fetchData(mainCriteria);
                break;
            }


        }
    }

    function createCriteriaInTraRe(fieldName, operator, value) {
        let criteriaObject = {};
        criteriaObject.fieldName = fieldName;
        criteriaObject.operator = operator;
        criteriaObject.value = value;
        return criteriaObject;
    }
    function createMainCriteriaInTraReq(cri,cri2) {
        let mainCriteria = {};
        mainCriteria._constructor = "AdvancedCriteria";
        mainCriteria.operator = "and";
        mainCriteria.criteria = [];
        mainCriteria.criteria.add(cri);
        mainCriteria.criteria.add(cri2);
        return mainCriteria;
    }

    function addChildReqManagement(dynamicForm,window,title) {
        dynamicForm.clearValues();
        dynamicForm.clearErrors();
        window.setTitle(title);
        window.show();
    }

    function saveChildReqManagement(listGrid,dynamicForm,window) {
        let record = ListGrid_training_Managment.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            return;
        }
        if (!dynamicForm.validate())
            return;
        if(selectedObject_Request_management==null) {
            createDialog("info","پست انتخاب نشده است");
            return;
        }
        let data={}

            data.personnelId=dynamicForm.getValue("personnelId")
            data.reqId=record.id
            data.postId=selectedObject_Request_management.id

        switch ( Managment_Detail_Tabs.getSelectedTab().name) {
            case "TabPane_position_appointment": {
                data.ref = "position-appointment";
                break;
            }
            case "TabPane_switching": {
                data.ref = "switching";
                break;
            }
            case "TabPane_ojt": {
                data.ref = "ojt";
                break;
            }
            case "TabPane_sps": {
                data.ref =  "sps";
                break;
            }
        }


        wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(trainingRequestManagementUrl+"/add", "POST", JSON.stringify(data), function (resp) {
                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                    wait.close();
                    createDialog("info", "<spring:message code="global.form.request.successful"/>");
                    window.close();
                    listGrid.invalidateCache();
                } else {
                    wait.close();
                    createDialog("warning", JSON.parse(resp.httpResponseText).message, "اخطار")
                }
            }));


    }


    function Select_Post_Request_management() {

        let  selected_Post = PostsLG_Request_management.getSelectedRecord();

        if (selected_Post == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            return;
        }
        selectedObject_Request_management = selected_Post;

        DynamicForm_req_item.getItem("postName").setValue(selected_Post.titleFa);

        Window_Post_Request_management.close();
    }
    function needAssessmentReportWindow() {
        let  itemSelected = ListGrid_req_item.getSelectedRecord();
        let recordTrManagement = ListGrid_training_Managment.getSelectedRecord();

        if (itemSelected == null || recordTrManagement==null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            return;
        }
        Tabset_Object_needAssessment_req_management.selectTab(0)
        Window_needAssessment_req_management.show();
    }

    function deleteReqManagement() {

        let recordTrManagement = ListGrid_training_Managment.getSelectedRecord();
        if (recordTrManagement == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            return;
        }


        let record = ListGrid_req_item.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            let Dialog_dec_remove = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                "<spring:message code="verify.delete"/>");
            Dialog_dec_remove.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        let data={}
                             data.reqId=recordTrManagement.id
                             data.PositionAppointmentId=record.id

                        switch ( Managment_Detail_Tabs.getSelectedTab().name) {
                            case "TabPane_position_appointment": {
                                data.ref = "position-appointment";
                                break;
                            }
                            case "TabPane_switching": {
                                data.ref = "switching";
                                break;
                            }
                            case "TabPane_ojt": {
                                data.ref = "ojt";
                                break;
                            }
                            case "TabPane_sps": {
                                data.ref =  "sps";
                                break;
                            }
                        }

                        wait.show();
                        isc.RPCManager.sendRequest(TrDSRequest(trainingRequestManagementUrl+"/delete"+"/"+recordTrManagement.id+"/"+record.id, "DELETE", null, function (resp) {
                            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                wait.close();
                                createDialog("info", "<spring:message code="global.form.request.successful"/>");
                                ListGrid_req_item.invalidateCache();

                            } else {
                                wait.close();
                                createDialog("info", "خطایی رخ داده است");
                            }
                        }));
                    }
                }
            });
        }
    }


    // </script>