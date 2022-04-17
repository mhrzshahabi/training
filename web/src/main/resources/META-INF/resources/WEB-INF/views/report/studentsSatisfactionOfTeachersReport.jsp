<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>
    var teacherMethod = "POST";
    var teacherWait;
    var responseID;
    var attachName;
    var attachNameTemp;
    var nationalCodeCheck = true;
    var cellPhoneCheck = true;
    var mailCheck = true;
    var persianDateCheck = true;
    var selectedRecordPersonalID = null;
    var isCategoriesChanged;
    var selected_record = null;
    var selected_teacher = null;
    var tab_selected = null;
    var selectedRecordID = null;
    var isFileAttached = false;
    var editTeacherMode = false;
    let oLoadAttachments_Teacher = null;
    var vm = isc.ValuesManager.create({});


    //----------------------------------------------------Rest Data Sources---------------------------------------------
    var RestDataSource_Teacher_JspSatisfaction = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "personality.id"},
            {name: "teacherCode"},
            {name: "personnelCode"},
            {name: "personality.firstNameFa"},
            {name: "personality.lastNameFa"},
            {name: "personality.educationLevel.titleFa"},
            {name: "personality.educationMajor.titleFa"},
            {name: "personality.contactInfo.mobile"},
            {name: "categories", filterOperator: "inSet"},
            {name: "subCategories", filterOperator: "inSet"},
            {name: "personality.contactInfo.homeAddress.id"},
            {name: "personality.contactInfo.workAddress.id"},
            {name: "personality.accountInfo.id"},
            {name: "personality.educationLevelId"},
            {name: "lastClass", canFilter: false, canSort: false},
            {name: "personnelStatus",
                valueMap: {
                    "true":  "<spring:message code='company.staff'/>",
                    "false": "<spring:message code='external.teacher'/>"
                }},
            {name: "teacherClassCount"},
            {name: "teacherLastEvalAverageResult"},
        ],
        fetchDataURL: teacherUrl + "spec-list-satisfaction"
    });

    var RestDataSource_Category_JspSatisfaction = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: categoryUrl + "iscList"
    });

    var RestDataSource_SubCategory_JspSatisfaction = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: subCategoryUrl + "iscList"
    });

    var RestDataSource_Education_Level_JspSatisfaction = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa", filterOperator: "equals"}],
        fetchDataURL: educationLevelUrl + "iscList"
    });

    var RestDataSource_Education_Level_ByID_JspSatisfaction = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa", filterOperator: "equals"}],
        fetchDataURL: educationLevelUrl + "spec-list-by-id"
    });

    var RestDataSource_Education_Major_JspSatisfaction = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa", filterOperator: "equals"}],
        autoCacheAllData: true,
        fetchDataURL: educationMajorUrl + "iscList",
    });

    var RestDataSource_Education_Major_ByID_JspSatisfaction = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa", filterOperator: "equals"}],
        fetchDataURL: educationMajorUrl + "spec-list-by-id"
    });

    var RestDataSource_Education_Orientation_JspSatisfaction = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleEn"}, {name: "titleFa"}]
    });

    var RestDataSource_Home_City_JspSatisfaction = isc.TrDS.create({
        fields: [{name: "id"}, {name: "name"}]
    });

    var RestDataSource_Home_State_JspSatisfaction = isc.TrDS.create({
        fields: [{name: "id"}, {name: "name"}],
        fetchDataURL: stateUrl + "spec-list?_startRow=0&_endRow=100"
    });

    var RestDataSource_Work_City_JspSatisfaction = isc.TrDS.create({
        fields: [{name: "id"}, {name: "name"}]
    });

    var RestDataSource_Work_State_JspSatisfaction = isc.TrDS.create({
        fields: [{name: "id"}, {name: "name"}],
        fetchDataURL: stateUrl + "spec-list?_startRow=0&_endRow=100"
    });

    var RestDataSource_BasicInfo_JspSatisfaction = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "personality.id"},
            {name: "teacherCode"},
            {name: "personnelCode"},
            {name: "personality.firstNameFa"},
            {name: "personality.lastNameFa"},
            {name: "personality.educationMajor.titleFa"},
            {name: "personality.contactInfo.mobile"},
            {name: "categories"},
            {name: "personality.contactInfo.homeAddress.id"},
            {name: "personality.contactInfo.workAddress.id"},

        ],
        fetchDataURL: teacherUrl + "spec-list"
    });

    var RestDataSource_Year_Filter_JspSatisfaction = isc.TrDS.create({
        fields: [
            {name: "year"}
        ],
        fetchDataURL: termUrl + "years",
        autoFetchData: true
    });

    var RestDataSource_Term_Filter_JspSatisfaction = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "startDate"},
            {name: "endDate"}
        ],
        fetchDataURL: termUrl + "spec-list"
    });

    var ListGrid_Teacher_JspSatisfaction = isc.TrLG.create({
        width: "100%",
        height: "100%",

        dataSource: RestDataSource_Teacher_JspSatisfaction,


        initialSort: [
            {property: "teacherCode", direction: "descending", primarySort: true}
        ],
        fields: [
            {name: "id", title: "id", canEdit: false, hidden: true},
            {
                name: "teacherCode",
                title: "<spring:message code='teacher.code'/>",
                align: "center",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {
                name: "personality.firstNameFa",
                title: "<spring:message code='firstName'/>",
                align: "center",
                sortNormalizer: function (record) {
                    return record.personality.firstNameFa;
                }
            },
            {
                name: "personality.lastNameFa",
                title: "<spring:message code='lastName'/>",
                align: "center",
                sortNormalizer: function (record) {
                    return record.personality.lastNameFa;
                }
            },
            {
                name: "personnelCode",
                title: "<spring:message code='personnel.code.six.digit'/>",
                align: "center",
            },
            {
                name: "categories",
                title: "<spring:message code='category'/>",
                editorType: "SelectItem",
                optionDataSource: RestDataSource_Category_JspSatisfaction,
                valueField: "id",
                displayField: "titleFa",
                filterOnKeypress: true,
                canSort: false,
                filterEditorProperties:{
                    optionDataSource: RestDataSource_Category_JspSatisfaction,
                    valueField: "id",
                    displayField: "titleFa",
                    autoFetchData: true,
                    filterFields: ["titleFa","titleFa"],
                    textMatchStyle: "substring",
                    generateExactMatchCriteria: true,
                    pickListProperties: {
                        showFilterEditor: false,
                        autoFitWidthApproach: "both"
                    },
                    pickListFields: [
                        {name: "titleFa"}
                    ]
                }
            },


            {
                name: "personality.educationMajor.titleFa",
                title: "<spring:message code='education.major'/>",
                align: "center",
                filterOperator: "equals",
                sortNormalizer: function (record) {
                    return record.personality.educationMajor.titleFa;
                }
            },
            {
                name: "personality.contactInfo.mobile",
                title: "<spring:message code='mobile.connection'/>",
                align: "center",
                type: "phoneNumber",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                },
                sortNormalizer: function (record) {
                    return record.personality.contactInfo.mobile;
                }
            },

            {
                name: "lastClass",
                title: "آخرین دعوت استاد",
                align: "center",
                filterOnKeypress: false,
                canFilter: false,
                canSort: false,
            },
            {
                name: "personnelStatus",
                title: "<spring:message code='teacher.type'/>",
                align: "center",
                filterOnKeypress: true,
                filterEditorProperties:{
                    pickListProperties: {
                        showFilterEditor: false
                    }
                },
                filterOperator: "equals",
                valueMap: {
                    "true": "<spring:message code='company.staff'/>",
                    "false": "<spring:message code='external.teacher'/>"
                }
            },
            {
                name: "teacherClassCount",
                title: "<spring:message code='teacher.class.count'/>",
                align: "center",
                canFilter: false,
                canSort: false

            } ,
            {
                name: "teacherLastEvalAverageResult",
                title: "<spring:message code='teacher.lastEval.averageResult'/>",
                align: "center",
                canFilter:false,
                canSort:false

            }

        ],
        selectionUpdated: function (record) {
           loadTeachingSubject();
        },
        filterEditorSubmit: function () {
            ListGrid_Teacher_JspSatisfaction.invalidateCache();
        },
        filterOperator: "iContains",
        filterOnKeypress: false,
        autoFetchData: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        selectionType: "single",
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>"
    });
    //------------------------------------tabSet------------------------------------------------------------------------
    var TabSet_teachingSubject = isc.TabSet.create({
        enabled: false,
        tabBarPosition: "top",
        tabs: [

            {
                ID: "internalTeachingHistory",
                title: "سوابق تدریس ",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "teacher/internalTeachingSubject-tab"})
            },
        ],
        tabSelected: function (tabNum, tabPane, ID, tab, name) {

        }
    });

    //----------------------------------------------ToolStrips and Layout-Grid------------------------------------------
    var ToolStripButton_Refresh_JspSatisfaction = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_satisfaction_refresh();
        }
    });


    var ToolStrip_Actions_JspSatisfaction = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [

            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_Refresh_JspSatisfaction
                ]
            })

        ]
    });

    var HLayout_Grid_Teacher_JspSatisfaction = isc.TrHLayout.create({
        members: [ListGrid_Teacher_JspSatisfaction]
    });

    var HLayout_Actions_Satisfaction = isc.HLayout.create({
        width: "100%",
        members: [ToolStrip_Actions_JspSatisfaction]
    });
    let HLayout_Tab_teachingSubject = isc.HLayout.create({
        minWidth: "100%",
        width: "100%",
        height: "39%",
        members: [TabSet_teachingSubject]
    });

    var VLayout_Body_Teacher_JspSatisfaction = isc.TrVLayout.create({
        members: [
            HLayout_Actions_Satisfaction,
            HLayout_Grid_Teacher_JspSatisfaction,
            HLayout_Tab_teachingSubject
        ]
    });


    //-------------------------------------------------Functions--------------------------------------------------------
    function ListGrid_satisfaction_refresh() {
        ListGrid_Teacher_JspSatisfaction.invalidateCache();
        ListGrid_Teacher_JspSatisfaction.filterByEditor();
        editTeacherMode = false;
    }
   function loadTeachingSubject(){
       let record =  ListGrid_Teacher_JspSatisfaction.getSelectedRecord();
       if (record === null) {
           TabSet_teachingSubject.disable();
           return;
       }else {
           loadPage_InternalTeachingSubject(record.id);
       }
       TabSet_teachingSubject.enable();
   }

    // </script>