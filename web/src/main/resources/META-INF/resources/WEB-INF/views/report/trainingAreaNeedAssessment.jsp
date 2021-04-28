<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

//<script>

    var complex = [];
    var assistance = [];
    var affairs = [];
    var section = [];
    var unit = [];

    //--------------------------------------------------------REST DataSources-----------------------------------------------------//

    var RestDataSource_view_training_Post = isc.TrDS.create({
        fields: [
            { name: "id", title: "id", primaryKey: true, hidden: true },
            {name: "peopleType", title: "<spring:message code="people.type"/>", filterOperator: "equals", autoFitWidth: true, valueMap:peopleTypeMap, filterOnKeypress: true},
            {name: "code", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "jobTitleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "postGradeTitleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "mojtameTitle", title: "<spring:message code="complex"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "assistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "section", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterCode", title: "<spring:message code="reward.cost.center.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterTitleFa", title: "<spring:message code="reward.cost.center.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "competenceCount", title: "تعداد شایستگی", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
        ],
        fetchDataURL: viewTrainingPostUrl + "/iscListReport?_endRow=10000"
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

    IButton_JspTrainingAreaNeedAsssesment = isc.IButtonSave.create({
        top: 260,
        title: "چاپ گزارش",
        width: 300,
        click: function () {

            if (organSegmentFilter.hasErrors())
                return;

            let reportCriteria = organSegmentFilter.getCriteria();
            complex = [];
            assistance = [];
            affairs = [];
            section = [];
            unit = [];

            for (let i = 0; i < reportCriteria.criteria.size(); i++) {

                if (reportCriteria.criteria[i].fieldName === "complexTitle") {
                    reportCriteria.criteria[i].fieldName = "mojtameTitle";
                    reportCriteria.criteria[i].operator = "inSet";
                    complex.add(reportCriteria.criteria[i].value);
                } else if (reportCriteria.criteria[i].fieldName === "assistant") {
                    reportCriteria.criteria[i].fieldName = "assistance";
                    reportCriteria.criteria[i].operator = "inSet";
                    assistance.add(reportCriteria.criteria[i].value);
                } else if (reportCriteria.criteria[i].fieldName === "affairs") {
                    reportCriteria.criteria[i].fieldName = "affairs";
                    reportCriteria.criteria[i].operator = "inSet";
                    affairs.add(reportCriteria.criteria[i].value);
                } else if (reportCriteria.criteria[i].fieldName === "section") {
                    reportCriteria.criteria[i].fieldName = "section";
                    reportCriteria.criteria[i].operator = "inSet";
                    section.add(reportCriteria.criteria[i].value);
                } else if (reportCriteria.criteria[i].fieldName === "unit") {
                    reportCriteria.criteria[i].fieldName = "unit";
                    reportCriteria.criteria[i].operator = "inSet";
                    unit.add(reportCriteria.criteria[i].value);
                }
            }

            reportCriteria.criteria.add({
                fieldName: "competenceCount",
                operator: "equals",
                value: 0
                });

            ListGrid_Training_Post.implicitCriteria = reportCriteria;
            ListGrid_Training_Post.invalidateCache();
            ListGrid_Training_Post.fetchData();
        }
    });

    var HLayOut_Confirm_JspTrainingAreaNeedAsssesment = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "70%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_JspTrainingAreaNeedAsssesment
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

    var organSegmentFilter = init_OrganSegmentFilterDF(true, true , null, "complexTitle","assistant","affairs", "section", "unit");

    VLayout_Body_Training_Area = isc.TrVLayout.create({
        members: [
            organSegmentFilter,
            HLayOut_Confirm_JspTrainingAreaNeedAsssesment,
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

        let fieldNames = "peopleType,code,titleFa,mojtameTitle,assistance,affairs,section," +
            "unit,costCenterCode,costCenterTitleFa";

        let headerNames = '"<spring:message code="people.type"/>","<spring:message code="post.code"/>","<spring:message code="post.title"/>","<spring:message code="complex"/>",' +
                '"<spring:message code="assistance"/>","<spring:message code="affairs"/>","<spring:message code="section"/>","<spring:message code="unit"/>",' +
                '"<spring:message code="reward.cost.center.code"/>","<spring:message code="reward.cost.center.title"/>"';

        let downloadForm = isc.DynamicForm.create({
                    method: "POST",
                    action: "/training/reportsToExcel/areaNeedAssessment",
                    target: "_Blank",
                    canSubmit: true,
                    fields:
                        [
                            {name: "fields", type: "hidden"},
                            {name: "headers", type: "hidden"},
                            {name: "complex", type: "hidden"},
                            {name: "assistance", type: "hidden"},
                            {name: "affairs", type: "hidden"},
                            {name: "section", type: "hidden"},
                            {name: "unit", type: "hidden"}
                        ]
                });
                downloadForm.setValue("fields", fieldNames);
                downloadForm.setValue("headers", headerNames);

                downloadForm.setValue("complex", complex);
                downloadForm.setValue("assistance", assistance);
                downloadForm.setValue("affairs", affairs);
                downloadForm.setValue("section", section);
                downloadForm.setValue("unit", unit);

                downloadForm.show();
                downloadForm.submitForm();
    }

//</script>