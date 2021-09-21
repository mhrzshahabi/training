<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    var complex = [];
    var assistance = [];
    var affairs = [];
    var section = [];
    var unit = [];

    let reportCriteria_AreaNeedAssessment;

    //--------------------------------------------------------REST DataSources-----------------------------------------------------//

    var RestDataSource_view_training_Post = isc.TrDS.create({
        fields: [
            { name: "id", title: "id", primaryKey: true, hidden: true },
            {name: "peopleType", title: "<spring:message code="people.type"/>", filterOperator: "equals", valueMap:peopleTypeMap, filterOnKeypress: true},
            {name: "code", title: "<spring:message code="post.code"/>", filterOperator: "iContains"},
            {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains"},
            {name: "jobTitleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains"},
            {name: "postGradeTitleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains"},
            {name: "mojtameTitle", title: "<spring:message code="complex"/>", filterOperator: "iContains"},
            {name: "assistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains"},
            {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains"},
            {name: "section", title: "<spring:message code="section"/>", filterOperator: "iContains"},
            {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains"},
            {name: "costCenterCode", title: "<spring:message code="reward.cost.center.code"/>", filterOperator: "iContains"},
            {name: "costCenterTitleFa", title: "<spring:message code="reward.cost.center.title"/>", filterOperator: "iContains"},
            {name: "competenceCount", title: "تعداد شایستگی", align: "center", filterOperator: "equals", autoFitWidthApproach: "both"},
        ],
        fetchDataURL: viewTrainingPostUrl + "/iscListReport?_endRow=10000",
        implicitCriteria: {
            _constructor:"AdvancedCriteria",
            operator:"and",
            criteria:[
                { fieldName: "competenceCount", operator: "equals", value: 0}
            ]
        }
    });

    //------------------------------------------------------Main Window--------------------------------------------------------------//

    ToolStripButton_Export2EXcel_THNA = isc.ToolStripButtonExcel.create({

        click: function () {

            makeExcelOutput();
        }
    });

    ToolStripButton_Refresh_THNA = isc.ToolStripButtonRefresh.create({
        click: function () {

            ListGrid_Training_Post.invalidateCache();
        }
    });

    IButton_JspTrainingAreaNeedAssessment = isc.IButtonSave.create({
        top: 260,
        title: "چاپ گزارش",
        width: 300,
        click: function () {

            if (organSegmentFilter.hasErrors())
                return;

            reportCriteria_AreaNeedAssessment = organSegmentFilter.getCriteria();
            complex = [];
            assistance = [];
            affairs = [];
            section = [];
            unit = [];

            if (reportCriteria_AreaNeedAssessment !== undefined) {

                for (let i = 0; i < reportCriteria_AreaNeedAssessment.criteria.size(); i++) {

                    if (reportCriteria_AreaNeedAssessment.criteria[i].fieldName === "complexTitle") {
                        reportCriteria_AreaNeedAssessment.criteria[i].fieldName = "mojtameTitle";
                        reportCriteria_AreaNeedAssessment.criteria[i].operator = "inSet";
                        complex.add(reportCriteria_AreaNeedAssessment.criteria[i].value);
                    } else if (reportCriteria_AreaNeedAssessment.criteria[i].fieldName === "assistant") {
                        reportCriteria_AreaNeedAssessment.criteria[i].fieldName = "assistance";
                        reportCriteria_AreaNeedAssessment.criteria[i].operator = "inSet";
                        assistance.add(reportCriteria_AreaNeedAssessment.criteria[i].value);
                    } else if (reportCriteria_AreaNeedAssessment.criteria[i].fieldName === "affairs") {
                        reportCriteria_AreaNeedAssessment.criteria[i].fieldName = "affairs";
                        reportCriteria_AreaNeedAssessment.criteria[i].operator = "inSet";
                        affairs.add(reportCriteria_AreaNeedAssessment.criteria[i].value);
                    } else if (reportCriteria_AreaNeedAssessment.criteria[i].fieldName === "section") {
                        reportCriteria_AreaNeedAssessment.criteria[i].fieldName = "section";
                        reportCriteria_AreaNeedAssessment.criteria[i].operator = "inSet";
                        section.add(reportCriteria_AreaNeedAssessment.criteria[i].value);
                    } else if (reportCriteria_AreaNeedAssessment.criteria[i].fieldName === "unit") {
                        reportCriteria_AreaNeedAssessment.criteria[i].fieldName = "unit";
                        reportCriteria_AreaNeedAssessment.criteria[i].operator = "inSet";
                        unit.add(reportCriteria_AreaNeedAssessment.criteria[i].value);
                    }
                }

                reportCriteria_AreaNeedAssessment.criteria.add(RestDataSource_view_training_Post.implicitCriteria.criteria.get(0));
                ListGrid_Training_Post.implicitCriteria = reportCriteria_AreaNeedAssessment;
                ListGrid_Training_Post.invalidateCache();
                ListGrid_Training_Post.fetchData();

            } else {

                reportCriteria_AreaNeedAssessment = RestDataSource_view_training_Post.implicitCriteria;
                ListGrid_Training_Post.implicitCriteria = reportCriteria_AreaNeedAssessment;
                ListGrid_Training_Post.invalidateCache();
                ListGrid_Training_Post.fetchData();
            }
        }
    });

    IButton_Clear_JspTrainingAreaNeedAssessment = isc.IButtonSave.create({
        top: 260,
        title: "پاک کردن",
        width: 300,
        click: function () {

            organSegmentFilter.clearValues();
            ListGrid_Training_Post.setData([]);
        }
    });

    var HLayOut_Confirm_JspTrainingAreaNeedAssessment = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "70%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_JspTrainingAreaNeedAssessment,
            IButton_Clear_JspTrainingAreaNeedAssessment
        ]
    });

    var ListGrid_Training_Post = isc.TrLG.create({
        width: "100%",
        showRowNumbers: true,
        dataSource: RestDataSource_view_training_Post,
        selectionType: "single",
        autoFetchData: false,
        dataPageSize: 15,
        allowAdvancedCriteria: true,
        alternateRecordStyles: true,
        allowFilterOperators: true,
        showFilterEditor: true,
        fields: [
            {
                name: "peopleType",
                filterOnKeypress: true
            },
            {
                name: "code",
                filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                }
            },
            {name: "titleFa"},
            {name: "jobTitleFa"},
            {name: "postGradeTitleFa"},
            {name: "mojtameTitle"},
            {name: "assistance"},
            {name: "affairs"},
            {name: "section"},
            {name: "unit"},
            {
                name: "costCenterCode",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "costCenterTitleFa"},
            {name: "competenceCount"}
        ]
    });

    ToolStrip_Actions_THNA = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_THNA,
                        ToolStripButton_Export2EXcel_THNA
                    ]
                })
            ]
    });

    var organSegmentFilter = init_OrganSegmentFilterDF(true,true, true , null, "complexTitle","assistant","affairs", "section", "unit");

    VLayout_Body_Training_Area = isc.TrVLayout.create({
        members: [
            organSegmentFilter,
            HLayOut_Confirm_JspTrainingAreaNeedAssessment,
            ListGrid_Training_Post
        ]
    });

    VLayout_Report = isc.TrVLayout.create({
        border: "2px solid blue",
        members: [
            ToolStrip_Actions_THNA,
            VLayout_Body_Training_Area
       ]
    });

    //-----------------------------------------------------------FUNCTIONS---------------------------------------------------------//

    function makeExcelOutput() {

        if (ListGrid_Training_Post.getOriginalData().localData === undefined)
            createDialog("info", "ابتدا چاپ گزارش را انتخاب کنید");
        else
            ExportToFile.downloadExcelRestUrl(null, ListGrid_Training_Post, viewTrainingPostUrl + "/iscListReport?_endRow=10000", 0, null, '',"گزارش پست های نیازسنجی نشده"  ,
                reportCriteria_AreaNeedAssessment, null);
    }

//</script>