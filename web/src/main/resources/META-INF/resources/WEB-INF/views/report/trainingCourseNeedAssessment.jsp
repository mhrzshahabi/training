<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

//<script>

    var category = null;

//--------------------------------------------------------REST DataSources-----------------------------------------------------//

    var courseCategorieItems = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa"}
        ],
        fetchDataURL: categoriesListUrl + "spec-list",
    });

    Rest_data_List_Grid = isc.TrDS.create({

        fields: [
            {name: "id", title: "<spring:message code='course.id'/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code='course.code'/>", filterOperator: "equals"},
            {name: "categoryId", title: "<spring:message code='group.code'/>", filterOperator: "iContains"},
            {name: "courseTitle", title: "<spring:message code='course.title'/>", filterOperator: "iContains"},
            {name: "categoryTitle", title: "<spring:message code='category'/>", filterOperator: "iContains"},
            {name: "subCategoryTitle", title: "<spring:message code='subcategory'/>", filterOperator: "iContains"},
        ],
        fetchDataURL: courseListNeedAssessment + "list?_endRow=10000"
    });

//----------------------------------- layOut -----------------------------------------------------------------------

    let DynamicForm_CriteriaForm_JspTrainingFileNAReport = isc.DynamicForm.create({
        width: "100%",
        align: "right",
        showInlineErrors: true,
        showErrorText: false,
        numCols: 6,
        fields: [
            {
                colSpan: 2,
                type: "header",
                defaultValue: " گزارش تمام دوره های گروه زیر که در نیازسنجی مشاغل هستند:"
            },
            {
                colSpan: 2,
                name: "category",
                title: "گروه:",
                optionDataSource: courseCategorieItems,
                displayField: "titleFa",
                valueField: "id",
                pickListProperties: {
                    showFilterEditor: false
                }
            },
            {
                colSpan: 2,
                name: "personnelNo1",
                title: "نمایش گزارش",
                showHintInField: true,
                startRow: false,
                endRow: false,
                type: "Button",
                click: function (form) {

                    category = form.getItem("category").getValue();
                    if (category != undefined && category != null)
                        fetchListGridData(category);
                }
            }
        ]
    });

    Grid_Course_Need_Assessment_List = isc.TrLG.create({
        dataSource: Rest_data_List_Grid,
        selectionType: "single",
        width: "100%",
        dataPageSize: 30,
        showRowNumbers: true,
        allowAdvancedCriteria: true,
        allowFilterOperators: true,
        showFilterEditor: false
    });

    let VLayOut_CriteriaForm = isc.TrVLayout.create({
        members: [
            DynamicForm_CriteriaForm_JspTrainingFileNAReport,
            Grid_Course_Need_Assessment_List
        ]
    });

    ToolStripButton_Export2EXcel_TCNA = isc.ToolStripButtonExcel.create({

        click: function () {

            makeExcelOutput();
        }
    });

    ToolStripButton_Refresh_TCNA = isc.ToolStripButtonRefresh.create({
        click: function () {

            Grid_Course_Need_Assessment_List.invalidateCache();
        }
    });

    ToolStrip_Actions_TCNA = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_TCNA,
                        ToolStripButton_Export2EXcel_TCNA
                    ]
                })
            ]
    });

    let VLayout_Body_JspTrainingFileNAReport = isc.TrVLayout.create({
        height: "100%",
        width: "100%",
        align: "top",
        alignLayout: "top",
        vAlign: "top",
        members: [
            ToolStrip_Actions_TCNA,
            VLayOut_CriteriaForm
        ]
    });

    function fetchListGridData(category) {

        let reportCriteria = {
            _constructor: "AdvancedCriteria",
            operator: "and",
            criteria: [
                {
                    fieldName: "categoryId",
                    operator: "equals",
                    value: category
                }
            ]
        };

        Rest_data_List_Grid.fetchData(reportCriteria, function (dsResponse, data, dsRequest) {
            if (data.length)
                Grid_Course_Need_Assessment_List.setData(data);
            else
                Grid_Course_Need_Assessment_List.setData([]);

        });
    }

    function makeExcelOutput() {

        let fieldNames = "id,categoryId,courseTitle,categoryTitle,subCategoryTitle,code";

        let headerNames = '"<spring:message code='course.id'/>","<spring:message code='group.code'/>","<spring:message code='course.title'/>","<spring:message code='category'/>",' +
                '"<spring:message code='subcategory'/>","<spring:message code='course.code'/>"';

        let downloadForm = isc.DynamicForm.create({
                    method: "POST",
                    action: "/training/reportsToExcel/courseNeedAssessment",
                    target: "_Blank",
                    canSubmit: true,
                    fields:
                        [
                            {name: "fields", type: "hidden"},
                            {name: "headers", type: "hidden"},
                            {name: "category", type: "hidden"}
                        ]
                });
                downloadForm.setValue("fields", fieldNames);
                downloadForm.setValue("headers", headerNames);
                downloadForm.setValue("category", category);

                downloadForm.show();
                downloadForm.submitForm();
    }

//</script>