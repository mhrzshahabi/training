<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<% final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN); %>

// <script>

    //----------------------------------------------------Variables-----------------------------------------------------

    let personnelTypeEx="" ;
    let personnelIdEx="";

    let postTypeEx="" ;
    let postIdEx="";
    let postCodeEX="";

    //----------------------------------------------------Rest DataSource-----------------------------------------------

    let editOrSave="save"
    RestDataSource_Committee = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "complex", title: "گستردگي کميته", filterOperator: "iContains"},
            {name: "title", title: "نام", filterOperator: "iContains"},
            {name: "address", title: "آدرس", filterOperator: "iContains"},
            {name: "phone", title: "تلفن", filterOperator: "iContains"},
            {name: "fax", title: "فاکس", filterOperator: "iContains"},
            {name: "email", title: "ایمیل", filterOperator: "iContains"},
            {name: "createdBy", title: "ایجاد کننده", filterOperator: "iContains"},
            {name: "createdDate", title: "تاریخ ایجاد", filterOperator: "iContains"},
            {name: "lastModifiedBy", title: "ویرایش کننده", filterOperator: "iContains"},
            {name: "lastModifiedDate", title: "تاریخ ویرایش", filterOperator: "iContains"},
        ],
        fetchDataURL: committeeRequestUrl + "/spec-list"
    });

    let RestDataSource_committee_Department_Filter = isc.TrDS.create({
        fields: [{name: "id"}, {name: "code"}, {name: "title"}, {name: "enabled"}],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/organ-segment-iscList/mojtame"
    });


    RestDataSource_Perssons = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "type"},
            {name: "nationalCode"},
            {name: "personnelNo"},
            {name: "personnelNo2"},
            {name: "firstName"},
            {name: "lastName"},
            {name: "phone"},
            {name: "postTitle"},
            {name: "role"},
            {name: "position"},

        ],


    });

    RestDataSource_Posts = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "type"},
            {name: "nationalCode"},
            {name: "personnelNo"},
            {name: "personnelNo2"},
            {name: "firstName"},
            {name: "lastName"},
            {name: "phone"},
            {name: "postTitle"},
            {name: "role"},
            {name: "position"},

        ],


    });

    //----------------------------------------------------Request Window------------------------------------------------






    DynamicForm_Committee_Ex = isc.DynamicForm.create({
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
                name: "complex",
                title: "گستردگي کميته",
                required: true,
                optionDataSource: RestDataSource_committee_Department_Filter,
                autoFetchData: false,
                type: "SelectItem",
                multiple: true,
                displayField: "title",
                valueField: "title",
                pickListFields: [
                    {
                        name: "title",
                        title: "<spring:message code="title"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    }
                ],
            },
            {
                name: "title",
                title: "عنوان",
                length: 200,
                required: true},
            {
                name: "address",
                title: "آدرس",
                length: 150
            },
            {
                name: "phone",
                title: "تلفن",
                keyPressFilter: "[0-9/]",
                length: 20
            },
            {
                name: "fax",
                title: "فاکس",
                keyPressFilter: "[0-9/]",
                length: 30
            },
            {
                name: "email",
                title: "ایمیل",
                length: 150,
                validators: [TrValidators.EmailValidate],
                keyPressFilter: "[a-z|A-Z|0-9|.|@]",
            },

        ]
    });
    DynamicForm_Committee_personnel = isc.DynamicForm.create({
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
                name: "personnel",
                title: "انتخاب پرسنل",
                colSpan: 2,
                align: "center",
                width: 170,
                type: "button",
                startRow: false,
                endRow: false,
                click: function () {
                    showPersonnelWin();
                }
            },
            {
                name: "personnelName",
                canEdit: false,
                title: "فرد انتخاب شده",
                required: true
            },
            {
                name: "role",
                length: 150,
                title: "نقش در کمیته",
                required: true,
                defaultValue: "عضو عادي",
                valueMap: {
                    "عضو خارجي کميته" : "عضو خارجي کميته",
                    "نماينده آموزش در کميته" : "نماينده آموزش در کميته",
                    "عضو عادي" : "عضو عادي"
                }

            },
            {
                name: "position",
                length: 150,
                title: "سمت در کمیته",
                required: true,
                defaultValue:  "رئيس و هماهنگ کننده کميته",
                valueMap: {
                    "رئيس و هماهنگ کننده کميته" : "رئيس و هماهنگ کننده کميته",
                    "اعضای کميته" : "اعضای کميته"
                }

            },

        ]
    });

    DynamicForm_Committee_post = isc.DynamicForm.create({
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
                name: "personnel",
                title: "انتخاب پست",
                colSpan: 2,
                align: "center",
                width: 170,
                type: "button",
                startRow: false,
                endRow: false,
                click: function () {
                    showPostWin();
                }
            },
            {
                name: "objectCode",
                canEdit: false,
                title: "کد پست انتخاب شده : ",
                required: true
            },
            {
                name: "objectType",
                canEdit: false,
                title: "نوع پست انتخاب شده : ",
                required: true
            },


        ]
    });



    Save_Button_Add_Committee_Ex = isc.IButtonSave.create({
        top: 260,
        layoutMargin: 5,
        membersMargin: 5,
        click: function () {
            saveCommitteeOfExperts();
        }
    });
    edit_Button_Add_Committee_Ex = isc.ToolStripButtonEdit.create({

        title: "ویرایش",
        click: function () {
            editCommitteeOfExperts();
        }
    });

    Cancel_Button_Add_Committee_Ex = isc.IButtonCancel.create({
        layoutMargin: 5,
        membersMargin: 5,
        width: 120,
        click: function () {
            Window_Committee_Experts.close();
        }
    });



    //------------------------------------------------------List Grids--------------------------------------------------



    let PersonnelRegDS_student_ex = isc.TrDS.create({
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
                name: "nationalCode",
                title: "<spring:message code="national.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "companyName",
                title: "<spring:message code="company.name"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "personnelNo",
                title: "<spring:message code="personnel.no"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "personnelNo2",
                title: "<spring:message code="personnel.no.6.digits"/>",
                filterOperator: "iContains"
            },
            {
                name: "postTitle",
                title: "<spring:message code="post"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },

        ],
        // autoFetchData: true,
        fetchDataURL: personnelRegUrl + "/spec-list",
    });



    let PersonnelsRegLG_student_ex = isc.TrLG.create({
        ID: "PersonnelsRegLG_student",
        dataSource: PersonnelRegDS_student_ex,
        selectionType: "single",
        fields: [
            //{name: "id", hidden: true},
            {name: "firstName"},
            {name: "lastName"},
            {
                name: "nationalCode",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "companyName", hidden: true},
            {
                name: "personnelNo",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {
                name: "personnelNo2",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "postTitle"}
        ],




    });

    let SynonymPersonnelsDS_student_ex = isc.TrDS.create({
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
                name: "nationalCode",
                title: "<spring:message code="national.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "companyName",
                title: "<spring:message code="company.name"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "personnelNo",
                title: "<spring:message code="personnel.no"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "personnelNo2",
                title: "<spring:message code="personnel.no.6.digits"/>",
                filterOperator: "iContains"
            },
            {
                name: "postTitle",
                title: "<spring:message code="post"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            }

        ],
        fetchDataURL: personnelUrl + "/Synonym/iscList"
    });




    let Post_DS_ex_committee = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "has_committee", hidden: true},
            {name: "committee", title: " کمیته  ",  filterOperator: "iContains",autoFitWidth: true},
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

    let Post_DS_ex_committee_with_filter = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "has_committee", hidden: true},
            {name: "committee", title: " کمیته  ",  filterOperator: "iContains",autoFitWidth: true},
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
    let training_Post_DS_ex_committee = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "committee", title: " کمیته ",  filterOperator: "iContains",autoFitWidth: true},

            {name: "peopleType", title: "<spring:message code="people.type"/>", filterOperator: "equals", autoFitWidth: true, valueMap:peopleTypeMap, filterOnKeypress: true},
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
            {
                name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both",
                valueMap:{
                    // undefined : "فعال",
                    74 : "غیر فعال"
                },filterOnKeypress: true,
            }
        ],
        fetchDataURL: viewTrainingPostUrl + "/iscList"
    });
    let training_Post_DS_ex_committee_with_filter = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "committee", title: " کمیته ",  filterOperator: "iContains",autoFitWidth: true},

            {name: "peopleType", title: "<spring:message code="people.type"/>", filterOperator: "equals", autoFitWidth: true, valueMap:peopleTypeMap, filterOnKeypress: true},
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
            {
                name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both",
                valueMap:{
                    // undefined : "فعال",
                    74 : "غیر فعال"
                },filterOnKeypress: true,
            }
        ],
        fetchDataURL: viewTrainingPostUrl + "/iscList"
    });

    let group_Post_DS_ex_committee = isc.TrDS.create({
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "committee", title: " کمیته  ", filterOperator: "iContains", autoFitWidth: true},

            {name: "code", title: "<spring:message code='code'/>", align: "center", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "titleFa", title: "نام گروه پست", align: "center", filterOperator: "iContains"},
            {name: "titleEn", title: "نام لاتین گروه پست ", align: "center", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "description", title: "توضیحات", align: "center", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "competenceCount", title: "تعداد شایستگی", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelCount", title: "تعداد پرسنل", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "lastModifiedDateNA", title: "<spring:message code="update.date"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "modifiedByNA", title: "<spring:message code="updated.by"/>", align: "center", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "version", title: "version", canEdit: false, hidden: true}

        ],
        fetchDataURL: viewPostGroupUrl + "/iscList"
    });
    let group_Post_DS_ex_committee_with_filter = isc.TrDS.create({
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "committee", title: " کمیته  ", filterOperator: "iContains", autoFitWidth: true},

            {name: "code", title: "<spring:message code='code'/>", align: "center", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "titleFa", title: "نام گروه پست", align: "center", filterOperator: "iContains"},
            {name: "titleEn", title: "نام لاتین گروه پست ", align: "center", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "description", title: "توضیحات", align: "center", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "competenceCount", title: "تعداد شایستگی", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelCount", title: "تعداد پرسنل", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "lastModifiedDateNA", title: "<spring:message code="update.date"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "modifiedByNA", title: "<spring:message code="updated.by"/>", align: "center", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "version", title: "version", canEdit: false, hidden: true}

        ],
        fetchDataURL: viewPostGroupUrl + "/iscList"
    });






    let SynonymPersonnelsLG_student_ex = isc.TrLG.create({
        ID: "SynonymPersonnelsLG_student",
        dataSource: SynonymPersonnelsDS_student_ex,
        selectionType: "single",
        fields: [
            {name: "id", hidden: true},
            {name: "firstName"},
            {name: "lastName"},
            {
                name: "nationalCode",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "companyName", hidden: true},
            {
                name: "personnelNo",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {
                name: "personnelNo2",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "postTitle"}
        ],

    });



    let Post_lsLG_ex = isc.TrLG.create({
         dataSource: Post_DS_ex_committee,
        selectionType: "single",
        sortField:"id",

    });

    let Post_lsLG_ex_with_filter = isc.TrLG.create({
         dataSource: Post_DS_ex_committee_with_filter,
        selectionType: "single",
        sortField:"id",

    });

    let training_Post_lsLG_ex = isc.TrLG.create({
         dataSource: training_Post_DS_ex_committee,
        selectionType: "single",
        sortField: "id",


    });
    let training_Post_lsLG_ex_with_filter = isc.TrLG.create({
         dataSource: training_Post_DS_ex_committee_with_filter,
        selectionType: "single",
        sortField: "id",


    });

    let group_Post_lsLG_ex = isc.TrLG.create({
         dataSource: group_Post_DS_ex_committee,
        selectionType: "single",
        sortField: "id",
    });
    let group_Post_lsLG_ex_with_filter = isc.TrLG.create({
         dataSource: group_Post_DS_ex_committee_with_filter,
        selectionType: "single",
        sortField: "id",
    });




    ListGrid_Committee_EX = isc.ListGrid.create({
        sortDirection: "descending",
        showFilterEditor: true,
        filterOnKeypress: true,
        // canAutoFitFields: true,
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Committee,
        autoFetchData: true,
        initialSort: [
            {property: "id", direction: "descending"}
        ],
        recordClick: function () {
            committeeSelectionUpdated_Tabs();
        },
        fields: [
            {
                name: "id",
                hidden: true,
                primaryKey: true,
                canEdit: false,
                align: "center"
            },
            {
                name: "complex",
                title: "گستردگي کميته",
                width: "10%",
                align: "center"
            },
            {
                name: "title",
                title: "عنوان",
                width: "10%",
                align: "center",
            },
            {
                name: "address",
                title: "آدرس",
                width: "10%",
                align: "center",
            },
            {
                name: "phone",
                title: "تلفن",
                width: "10%",
                align: "center",
            },
            {
                name: "fax",
                title: "فاکس",
                width: "10%",
                align: "center",
            },
            {
                name: "email",
                title: "ایمیل",
                width: "10%",
                align: "center",
            } ,
            {name: "createdBy",
                title: "ایجاد کننده",
                width: "10%",
                align: "center",

            },
            {name: "createdDate",
                title: "تاریخ ایجاد",
                width: "10%",
                align: "center",
                formatCellValue: function (value) {
                    if (value) {
                        let d = new Date(value);
                        return d.toLocaleString('fa',{ year: 'numeric', month: 'numeric', day: 'numeric' });
                    }
                }

            },
            {name: "lastModifiedBy",
                title: "ویرایش کننده",
                width: "10%",
                align: "center",
            },
            {name: "lastModifiedDate",
                title: "تاریخ ویرایش",
                width: "10%",
                align: "center",
                formatCellValue: function (value) {
                    if (value) {
                        let d = new Date(value);
                        return d.toLocaleString('fa',{ year: 'numeric', month: 'numeric', day: 'numeric' });
                    }
                }
            }
        ],

    });

    Committee_Persons_actions = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonCreate.create({
                title: "افزودن",
                click: function () {
                    addToCommittee(ListGrid_Committee_EX,DynamicForm_Committee_personnel,Window_base_Decision_committee_persons)
                }.bind(this)
            }),
            isc.ToolStripButtonRemove.create({
                title: "حذف",
                click: function () {
                    deleteFromCommittee(ListGrid_Committee_EX,ListGrid_Committee_Persons,"/deletePart/")
                }.bind(this)
            })
        ]
    });
    Committee_Post_actions = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonCreate.create({
                title: "افزودن",
                click: function () {
                    addToCommittee(ListGrid_Committee_EX,DynamicForm_Committee_post,Window_base_Decision_committee_post)
                }.bind(this)
            }),
            isc.ToolStripButtonRemove.create({
                title: "حذف",
                click: function () {
                    deleteFromCommittee(ListGrid_Committee_EX,ListGrid_Committee_Posts,"/deletePost/")
                }.bind(this)
            })
        ]
    });

    ListGrid_Committee_Persons = isc.ListGrid.create({
        dataSource: RestDataSource_Perssons,
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
                canEdit: false,
                align: "center"
            },

            {
                name: "firstName",
                title: "نام",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "lastName",
                title: "نام خانوادگی",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "nationalCode",
                title: "کد ملی",
                width: "10%",
                canFilter: false,
                align: "center"
            },
            {
                name: "personnelNo",
                title: "شماره پرسنلی",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "personnelNo2",
                title: "پرسنلی 6 رقمی",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "phone",
                title: "تلفن",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "postTitle",
                title: "عنوان پست",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "role",
                title: "نقش در کمیته",
                width: "10%",
                align: "center",
                canFilter: false
            },{
                name: "position",
                title: "سمت در کمیته",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "type",
                title: "نوع پرسنل ",
                width: "10%",
                align: "center",
                canFilter: false
            }
        ],
        gridComponents: [Committee_Persons_actions, "filterEditor", "header", "body", "summaryRow"]

    });
    ListGrid_Committee_Posts = isc.ListGrid.create({
        dataSource: RestDataSource_Posts,
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
                canEdit: false,
                align: "center"
            },
            {
                name: "objectType",
                title: "نوع پست",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "objectCode",
                title: "کد پست",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "userNationalCode",
                title: "کد ملي فرد حاضر در پست",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "userName",
                title: "نام فرد حاضر در پست",
                width: "10%",
                canFilter: false,
                align: "center"
            },
            {
                name: "phone",
                title: "موبايل",
                width: "10%",
                align: "center",
                canFilter: false
            }
        ],
        gridComponents: [Committee_Post_actions, "filterEditor", "header", "body", "summaryRow"]

    });



    let registered_List_VLayout_ex = isc.VLayout.create({
        width: "100%",
        height: "100%",
        autoDraw: false,
        border: "0px solid red", layoutMargin: 5,
        members: [
            isc.SectionStack.create({
                sections: [{
                    title: "<spring:message code="all.persons"/>",
                    expanded: true,
                    canCollapse: false,
                    align: "center",
                    items: [
                        PersonnelsRegLG_student_ex
                    ]
                }]
            }),
        ]
    });
    let synonym_Personnel_List_VLayout_ex = isc.VLayout.create({
        width: "100%",
        height: "100%",
        autoDraw: false,
        border: "0px solid red", layoutMargin: 5,
        members: [
            isc.SectionStack.create({
                sections: [{
                    title: "<spring:message code="all.persons"/>",
                    expanded: true,
                    canCollapse: false,
                    align: "center",
                    items: [
                        SynonymPersonnelsLG_student_ex
                    ]
                }]
            }),
        ]
    });

    let post_committee_List_VLayout_ex = isc.VLayout.create({
        width: "100%",
        height: "100%",
        autoDraw: false,
        border: "0px solid red", layoutMargin: 5,
        members: [
            isc.SectionStack.create({
                sections: [{
                    expanded: true,
                    canCollapse: false,
                    align: "center",
                    items: [
                        Post_lsLG_ex
                    ]
                }]
            }),
        ]
    });
    let post_committee_List_VLayout_ex_with_filter = isc.VLayout.create({
        width: "100%",
        height: "100%",
        autoDraw: false,
        border: "0px solid red", layoutMargin: 5,
        members: [
            isc.SectionStack.create({
                sections: [{
                    expanded: true,
                    canCollapse: false,
                    align: "center",
                    items: [
                        Post_lsLG_ex_with_filter
                    ]
                }]
            }),
        ]
    });

    let training_committee_List_VLayout_ex = isc.VLayout.create({
        width: "100%",
        height: "100%",
        autoDraw: false,
        border: "0px solid red", layoutMargin: 5,
        members: [
            isc.SectionStack.create({
                sections: [{
                    expanded: true,
                    canCollapse: false,
                    align: "center",
                    items: [
                        training_Post_lsLG_ex
                    ]
                }]
            }),
        ]
    });
    let training_committee_List_VLayout_ex_with_filter = isc.VLayout.create({
        width: "100%",
        height: "100%",
        autoDraw: false,
        border: "0px solid red", layoutMargin: 5,
        members: [
            isc.SectionStack.create({
                sections: [{
                    expanded: true,
                    canCollapse: false,
                    align: "center",
                    items: [
                        training_Post_lsLG_ex_with_filter
                    ]
                }]
            }),
        ]
    });

    let group_Post_List_VLayout_ex = isc.VLayout.create({
        width: "100%",
        height: "100%",
        autoDraw: false,
        border: "0px solid red", layoutMargin: 5,
        members: [
            isc.SectionStack.create({
                sections: [{
                    expanded: true,
                    canCollapse: false,
                    align: "center",
                    items: [
                        group_Post_lsLG_ex
                    ]
                }]
            }),
        ]
    });
    let group_Post_List_VLayout_ex_with_filter = isc.VLayout.create({
        width: "100%",
        height: "100%",
        autoDraw: false,
        border: "0px solid red", layoutMargin: 5,
        members: [
            isc.SectionStack.create({
                sections: [{
                    expanded: true,
                    canCollapse: false,
                    align: "center",
                    items: [
                        group_Post_lsLG_ex_with_filter
                    ]
                }]
            }),
        ]
    });


    let personnelTabs_ex = isc.TabSet.create({
        height: "50%",
        width: "100%",
        showTabScroller: false,
        tabs: [
            {
                name:"PersonnelList_Tab_synonym_Personnel",
                title: "<spring:message code='PersonnelList_Tab_synonym_Personnel'/>",
                pane: synonym_Personnel_List_VLayout_ex
            },
            {
                name:"personnel.tab.registered",
                title: "<spring:message code='personnel.tab.registered'/>",
                pane: registered_List_VLayout_ex
            }

        ]
        ,tabSelected: function () {

            let tab = personnelTabs_ex.getSelectedTab();



            switch (tab.name) {
                case "personnel.tab.registered": {
                    PersonnelsRegLG_student_ex.invalidateCache();
                    PersonnelsRegLG_student_ex.fetchData();
                    break;
                }
                case "PersonnelList_Tab_synonym_Personnel": {
                    SynonymPersonnelsLG_student_ex.invalidateCache();
                    SynonymPersonnelsLG_student_ex.fetchData();

                    break;
                }

            }
        }
    });
    let PostTabs_ex = isc.TabSet.create({
        height: "50%",
        width: "100%",
        showTabScroller: false,
        tabs: [

            {
                name:"training_Post_committee",
                title: "پست ",
                pane: training_committee_List_VLayout_ex
            },
            {
                name:"group_Post_committee",
                title: "پست گروهی",
                pane: group_Post_List_VLayout_ex
            },
            {
                name:"post_committee",
                title: "پست انفرادی",
                pane: post_committee_List_VLayout_ex
            }

        ]
        ,tabSelected: function () {

            let tab = PostTabs_ex.getSelectedTab();



            switch (tab.name) {
                case "post_committee": {
                    Post_lsLG_ex.invalidateCache();
                    Post_lsLG_ex.fetchData();
                    break;
                }
                case "training_Post_committee": {
                    training_Post_lsLG_ex.invalidateCache();
                    training_Post_lsLG_ex.fetchData();

                    break;
                }
                case "group_Post_committee": {
                    group_Post_lsLG_ex.invalidateCache();
                    group_Post_lsLG_ex.fetchData();

                    break;
                }

            }
        }
    });

    let PostTabs_ex_with_filter = isc.TabSet.create({
        height: "50%",
        width: "100%",
        showTabScroller: false,
        tabs: [

            {
                name:"training_Post_committee",

                title: "پست ",
                pane: training_committee_List_VLayout_ex_with_filter
            },
            {
                name:"group_Post_committee",

                title: "پست گروهی",
                pane: group_Post_List_VLayout_ex_with_filter
            } ,{
                name:"post_committee",

                title: "پست انفرادی",
                pane: post_committee_List_VLayout_ex_with_filter
            }

        ]
        ,tabSelected: function () {
            let tab = PostTabs_ex_with_filter.getSelectedTab();



            switch (tab.name) {
                case "post_committee": {
                    Post_lsLG_ex_with_filter.invalidateCache();
                    Post_lsLG_ex_with_filter.fetchData();
                    break;
                }
                case "training_Post_committee": {
                    training_Post_lsLG_ex_with_filter.invalidateCache();
                    training_Post_lsLG_ex_with_filter.fetchData();

                    break;
                }
                case "group_Post_committee": {
                    group_Post_lsLG_ex_with_filter.invalidateCache();
                    group_Post_lsLG_ex_with_filter.fetchData();

                    break;
                }

            }
        }
    });


    let personnelTabs_exHlayout = isc.TrHLayoutButtons.create({
        members: [
            isc.IButtonSave.create({
                top: 100,
                title: "<spring:message code='save'/>",
                align: "center",
                icon: "[SKIN]/actions/save.png",
                click: function () {
                    let tab = personnelTabs_ex.getSelectedTab();
                    switch (tab.name) {
                        case "personnel.tab.registered": {
                            let record = PersonnelsRegLG_student_ex.getSelectedRecord();
                            if (record == null) {
                                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                            } else {
                                personnelTypeEx ="registered";
                                personnelIdEx=record.id;
                                DynamicForm_Committee_personnel.getItem("personnelName").setValue(record.firstName + " "+record.lastName);
                            }

                            break;
                        }
                        case "PersonnelList_Tab_synonym_Personnel": {

                            let record = SynonymPersonnelsLG_student_ex.getSelectedRecord();
                            if (record == null) {
                                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                            } else {
                                personnelTypeEx ="Synonym";
                                personnelIdEx=record.id;
                                DynamicForm_Committee_personnel.getItem("personnelName").setValue(record.firstName + " "+record.lastName);
                            }

                            break;
                        }

                    }




                    ClassStudentWin_student_ex.close();
                }
            }),
            isc.IButtonCancel.create({
                top: 100,
                title: "<spring:message code='cancel'/>",
                align: "center",
                icon: "[SKIN]/actions/cancel.png",
                click: function () {
                    ClassStudentWin_student_ex.close();
                }
            }),
        ]
    });
    let PostTabs_exHlayout = isc.TrHLayoutButtons.create({
        members: [
            isc.IButtonSave.create({
                top: 100,
                title: "<spring:message code='save'/>",
                align: "center",
                icon: "[SKIN]/actions/save.png",
                click: function () {
                    let tab = PostTabs_ex.getSelectedTab();
                    switch (tab.name) {
                        case "post_committee": {
                            let record = Post_lsLG_ex.getSelectedRecord();
                            if (record == null) {
                                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                            } else {
                                postTypeEx ="post";
                                postIdEx=record.id;
                                postCodeEX=record.code;
                                DynamicForm_Committee_post.getItem("objectCode").setValue(record.code);
                                DynamicForm_Committee_post.getItem("objectType").setValue("پست انفرادی");
                            }
                            break;
                        }
                        case "training_Post_committee": {
                            let record = training_Post_lsLG_ex.getSelectedRecord();
                            if (record == null) {
                                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                            } else {

                                postTypeEx ="training_Post";
                                postIdEx=record.id;
                                postCodeEX=record.code;
                                DynamicForm_Committee_post.getItem("objectCode").setValue(record.code);
                                DynamicForm_Committee_post.getItem("objectType").setValue("پست");
                            }
                            break;
                        }
                        case "group_Post_committee": {
                            let record = group_Post_lsLG_ex.getSelectedRecord();
                            if (record == null) {
                                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                            } else {
                                postTypeEx ="group_Post";
                                postIdEx=record.id;
                                postCodeEX=record.code;
                                DynamicForm_Committee_post.getItem("objectCode").setValue(record.code);
                                DynamicForm_Committee_post.getItem("objectType").setValue("گروه پستی");
                            }
                            break;
                        }

                    }


                    Post_Win_ex.close();
                }
            }),
            isc.IButtonCancel.create({
                top: 100,
                title: "<spring:message code='cancel'/>",
                align: "center",
                icon: "[SKIN]/actions/cancel.png",
                click: function () {
                    Post_Win_ex.close();
                }
            }),
        ]
    });


    let ClassStudentWin_student_ex = isc.Window.create({
        width: 1000,
        title:"انتخاب پرسنل",
        height: 768,
        minWidth: 1000,
        minHeight: 600,
        autoSize: false,
        items: [
            personnelTabs_ex,
            personnelTabs_exHlayout
        ]
    });
    let Post_Win_ex = isc.Window.create({
        width: 1000,
        title:"انتخاب پست",
        height: 768,
        minWidth: 1000,
        minHeight: 600,
        autoSize: false,
        items: [
            PostTabs_ex,
            PostTabs_exHlayout
        ]
    });

    let Post_not_in_committee_Win_ex = isc.Window.create({
        width: 1000,
        title:" پست هاي فاقد کميته ",
        height: 768,
        minWidth: 1000,
        minHeight: 600,
        autoSize: false,
        items: [
            PostTabs_ex_with_filter
        ]
    });


    //----------------------------------------------------Actions --------------------------------------------------

    ToolStripButton_Add_Committee = isc.ToolStripButtonCreate.create({
        title: "افزودن کمیته خبرگان",
        click: function () {
            addCommittee();
        }
    });

    ToolStripButton_Delete_Committee = isc.ToolStripButtonRemove.create({
        click: function () {
            deleteCommittee();
        }
    });

    ToolStripButton_Refresh_Committee = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_Committee_EX.invalidateCache();
        }
    });
    ToolStripButton_not_post_in_Committee = isc.ToolStripButtonRefresh.create({
        title:" پست هاي فاقد کميته ",

        click: function () {

            Post_lsLG_ex_with_filter.invalidateCache();
            training_Post_lsLG_ex_with_filter.invalidateCache();
            group_Post_lsLG_ex_with_filter.invalidateCache();


            let criteria = {
                _constructor: "AdvancedCriteria",
                operator: "and",
                criteria: [
                    {fieldName: "hasCommittee", operator: "equals",value:0},
                ]
            };

            Post_DS_ex_committee_with_filter.fetchDataURL = viewPostUrl + "/iscList?operator=and&_constructor=AdvancedCriteria&criteria=" +  JSON.stringify(criteria);

             training_Post_DS_ex_committee_with_filter.fetchDataURL = viewTrainingPostUrl + "/iscList?operator=and&_constructor=AdvancedCriteria&criteria=" +  JSON.stringify(criteria);

             group_Post_DS_ex_committee_with_filter.fetchDataURL = viewPostGroupUrl + "/iscList?operator=and&_constructor=AdvancedCriteria&criteria=" +  JSON.stringify(criteria);




            Post_not_in_committee_Win_ex.show();

        }
    });



    //////////////////// tab ////////////////////////////////////////////


    Committee_Tabs = isc.TabSet.create({
        tabBarPosition: "top",
        tabs: [
            {name: "TabPane_Committee_Persons", title: "اعضاي کميته", pane: ListGrid_Committee_Persons},
            {name: "TabPane_Committee_Posts", title: "پست هاي تحت پوشش", pane: ListGrid_Committee_Posts},

        ],
        tabSelected: function () {
            committeeSelectionUpdated_Tabs();
        }
    });



    //----------------------------------- layOut -----------------------------------------------------------------------

    HLayout_IButtons_Committee_Ex = isc.HLayout.create({
        layoutMargin: 5,
        membersMargin: 15,
        width: "100%",
        height: "100%",
        align: "center",
        members: [
            Save_Button_Add_Committee_Ex,
            Cancel_Button_Add_Committee_Ex
        ]
    });
    HLayout_IButtons_committee_persons = isc.HLayout.create({
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
                    savePartOfCommitte()
                }
            }),
            isc.IButtonCancel.create({
                layoutMargin: 5,
                membersMargin: 5,
                width: 120,
                click: function () {
                    Window_base_Decision_committee_persons.close();
                }
            })
        ]
    });

    HLayout_IButtons_committee_post = isc.HLayout.create({
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
                    savePostFoeCommitte()
                }
            }),
            isc.IButtonCancel.create({
                layoutMargin: 5,
                membersMargin: 5,
                width: 120,
                click: function () {
                    Window_base_Decision_committee_post.close();
                }
            })
        ]
    });


    Window_Committee_Experts = isc.Window.create({
        title: "افزودن کمیته خبرگان",
        width: 450,
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: true,
        items: [
            DynamicForm_Committee_Ex,
            HLayout_IButtons_Committee_Ex
        ]
    });

    Window_base_Decision_committee_persons = isc.Window.create({
        title: "افزودن اعضای کمیته",
        width: 450,
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: true,
        items: [
            DynamicForm_Committee_personnel,
            HLayout_IButtons_committee_persons
        ]
    });

    Window_base_Decision_committee_post = isc.Window.create({
        title: "افزودن پست",
        width: 450,
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: true,
        items: [
            DynamicForm_Committee_post,
            HLayout_IButtons_committee_post
        ]
    });

    ToolStrip_Actions_Committee = isc.ToolStrip.create({
        width: "100%",
        border: '0px',
        membersMargin: 5,
        members: [
            ToolStripButton_Add_Committee,
            ToolStripButton_Delete_Committee,
            edit_Button_Add_Committee_Ex,
            isc.ToolStrip.create({
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_not_post_in_Committee,
                    ToolStripButton_Refresh_Committee
                ]
            })
        ]
    });

    VLayout_Body_Committee = isc.TrVLayout.create({
        members: [
            ToolStrip_Actions_Committee,
            ListGrid_Committee_EX
        ]
    });

    HLayout_Tabs_Committee = isc.HLayout.create({
        minWidth: "100%",
        width: "100%",
        height: "80%",
        members: [Committee_Tabs]
    });

    VLayout_Body_Committee_Jsp = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            VLayout_Body_Committee,
            HLayout_Tabs_Committee
        ]
    });

    //------------------------------------------------- Functions ------------------------------------------------------
    function addCommittee() {
        editOrSave="save"
        DynamicForm_Committee_Ex.clearValues();
        DynamicForm_Committee_Ex.clearErrors();
        Window_Committee_Experts.show();
    }

    function editCommitteeOfExperts() {
        let record = ListGrid_Committee_EX.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            editOrSave="edit"
            DynamicForm_Committee_Ex.clearValues();
            DynamicForm_Committee_Ex.clearErrors();
            Window_Committee_Experts.show();
            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(committeeRequestUrl+"/get/"+record.id, "Get", null, function (resp) {
                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                    wait.close();
                    let currentCommittee = JSON.parse(resp.data);

                    DynamicForm_Committee_Ex.getItem("complex").setValue(currentCommittee.complex);
                    DynamicForm_Committee_Ex.getItem("title").setValue(currentCommittee.title);
                    DynamicForm_Committee_Ex.getItem("address").setValue(currentCommittee.address);
                    DynamicForm_Committee_Ex.getItem("phone").setValue(currentCommittee.phone);
                    DynamicForm_Committee_Ex.getItem("fax").setValue(currentCommittee.fax);
                    DynamicForm_Committee_Ex.getItem("email").setValue(currentCommittee.email);

                } else {
                    wait.close();
                    createDialog("info", "خطایی رخ داده است");
                }
            }));
        }


    }



    function saveCommitteeOfExperts() {

        if (!DynamicForm_Committee_Ex.validate())
            return;

        let data = DynamicForm_Committee_Ex.getValues();

        wait.show();
        if (editOrSave === "save"){
            isc.RPCManager.sendRequest(TrDSRequest(committeeRequestUrl, "POST", JSON.stringify(data), function (resp) {
                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                    wait.close();
                    createDialog("info", "<spring:message code="global.form.request.successful"/>");
                    Window_Committee_Experts.close();
                    ListGrid_Committee_EX.invalidateCache();
                } else {
                    wait.close();
                    createDialog("info", "خطایی رخ داده است");
                }
            }));

        }else if (editOrSave === "edit"){
            let record = ListGrid_Committee_EX.getSelectedRecord();
            data.id=record.id
            isc.RPCManager.sendRequest(TrDSRequest(committeeRequestUrl, "PUT", JSON.stringify(data), function (resp) {
                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                    wait.close();
                    createDialog("info", "<spring:message code="global.form.request.successful"/>");
                    Window_Committee_Experts.close();
                    ListGrid_Committee_EX.invalidateCache();
                } else {
                    wait.close();
                    createDialog("info", "خطایی رخ داده است");
                }
            }));

        }


    }
    function showPersonnelWin() {
        SynonymPersonnelsLG_student_ex.invalidateCache();
        PersonnelsRegLG_student_ex.invalidateCache();
        ClassStudentWin_student_ex.show();

    }

    function showPostWin() {
        Post_lsLG_ex.invalidateCache();
        training_Post_lsLG_ex.invalidateCache();
        group_Post_lsLG_ex.invalidateCache();

        Post_DS_ex_committee.fetchDataURL = viewPostUrl + "/iscList";

        training_Post_DS_ex_committee.fetchDataURL = viewTrainingPostUrl + "/iscList";

        group_Post_DS_ex_committee.fetchDataURL = viewPostGroupUrl + "/iscList";



        Post_Win_ex.show();

    }

    function addToCommittee(listGrid,dynamicForm,window) {
        let record = listGrid.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            dynamicForm.clearValues();
            dynamicForm.clearErrors();
            window.show();
        }
    }
    function savePartOfCommitte() {
        let record = ListGrid_Committee_EX.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            return;
        }
        if (!DynamicForm_Committee_personnel.validate())
            return;

        let data = DynamicForm_Committee_personnel.getValues();

        data.personnelType =personnelTypeEx
        data.personnelId =personnelIdEx
        data.parentId =record.id
        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(committeeRequestUrl+"/addPartOfPersonnel", "POST", JSON.stringify(data), function (resp) {
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                wait.close();
                createDialog("info", "<spring:message code="global.form.request.successful"/>");
                Window_base_Decision_committee_persons.close();
                DynamicForm_Committee_personnel.invalidateCache();
                ListGrid_Committee_Persons.invalidateCache();
            } else {
                let result = JSON.parse(resp.httpResponseText);
                wait.close();
                createDialog("info", result.message);
            }
        }));


    }

    function savePostFoeCommitte() {
        let record = ListGrid_Committee_EX.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            return;
        }
        if (!DynamicForm_Committee_post.validate())
            return;

        let data = DynamicForm_Committee_post.getValues();

        data.postType =postTypeEx
        data.postId =postIdEx
        data.postCode =postCodeEX
        data.parentId =record.id
        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(committeeRequestUrl+"/addPartOfPost", "POST", JSON.stringify(data), function (resp) {
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                wait.close();
                createDialog("info", "<spring:message code="global.form.request.successful"/>");
                Window_base_Decision_committee_post.close();
                DynamicForm_Committee_post.invalidateCache();
                ListGrid_Committee_Posts.invalidateCache();
            } else {
                wait.close();
                createDialog("info", "خطایی رخ داده است");
            }
        }));


    }

    function deleteFromCommittee(parentListGrid,childListGrid,url) {
        let parentRecord = parentListGrid.getSelectedRecord();
        let childRecord = childListGrid.getSelectedRecord();
        if (parentRecord == null || childRecord==null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            let Dialog_dec_remove = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                "<spring:message code="verify.delete"/>");
            Dialog_dec_remove.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        wait.show();
                        isc.RPCManager.sendRequest(TrDSRequest(committeeRequestUrl+ url+ parentRecord.id+"/"+childRecord.id, "DELETE", null, function (resp) {
                            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                wait.close();
                                createDialog("info", "<spring:message code="global.form.request.successful"/>");
                                parentListGrid.invalidateCache();
                                childListGrid.invalidateCache();

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

    function deleteCommittee() {
        let record = ListGrid_Committee_EX.getSelectedRecord();
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
                        isc.RPCManager.sendRequest(TrDSRequest(committeeRequestUrl + "/" + record.id, "DELETE", null, function (resp) {
                            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                wait.close();
                                createDialog("info", "<spring:message code="global.form.request.successful"/>");
                                ListGrid_Committee_EX.invalidateCache();

                            } else {
                                wait.close();
                                createDialog("info", "رکورد مورد نظر دارای زیر مجموعه می باشد");
                            }
                        }));
                    }
                }
            });
        }
    }

    function committeeSelectionUpdated_Tabs() {

        let record = ListGrid_Committee_EX.getSelectedRecord();
        let tab = Committee_Tabs.getSelectedTab();

        if (record == null && tab.pane != null) {
            tab.pane.setData([]);
            return;
        }


        switch (tab.name) {
            case "TabPane_Committee_Persons": {
                RestDataSource_Perssons.fetchDataURL = committeeRequestUrl + "/listOfParts/"+record.id;
                ListGrid_Committee_Persons.invalidateCache();
                ListGrid_Committee_Persons.fetchData();
                break;
            }
            case "TabPane_Committee_Posts": {
                RestDataSource_Posts.fetchDataURL = committeeRequestUrl + "/listOfPosts/"+record.id;
                ListGrid_Committee_Posts.invalidateCache();
                ListGrid_Committee_Posts.fetchData();
                break;
            }

        }
    }

    // </script>