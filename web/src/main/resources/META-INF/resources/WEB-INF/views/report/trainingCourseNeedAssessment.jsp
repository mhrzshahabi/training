<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
// <script>

    let IButton_JspTrainingFileNAReport = isc.IButtonSave.create({
        top: 260,
        title: "چاپ گزارش",
        width: 300,
        click: function (){

        }
    });
    var courseCategorieItems = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa"}
        ],
        fetchDataURL: categoriesListUrl + "spec-list",
    });

    Rest_data_List_Grid = isc.TrDS.create({

        fields: [
            {name: "id", title: "<spring:message code='course.id'/>", filterOperator: "equals"},
            {name: "categoryId", title: "<spring:message code='group.code'/>", filterOperator: "iContains"},
            {name: "courseTitle", title: "<spring:message code='course.title'/>", filterOperator: "iContains"},
            {name: "categoryTitle", title: "<spring:message code='category'/>", filterOperator: "iContains"},
            {name: "subCategoryTitle", title: "<spring:message code='subcategory'/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code='course.code'/>", filterOperator: "equals"},
        ],
        fetchDataURL: courseListNeedAssessment + "list?_endRow=10000"
    });

    let DynamicForm_CriteriaForm_JspTrainingFileNAReport = isc.DynamicForm.create({
        align: "right",
        titleWidth: 0,
        titleAlign: "center",
        showInlineErrors: true,
        showErrorText: false,
        numCols: 3,
        colWidths: ["5%", "25%", "25%"],
        minWidth:1024,
        width: 600,
        fields: [
            { type:"header", defaultValue:" گزارش تمام دوره های گروه زیر که در نیازسنجی مشاغل هستند:" },
            {name: "source", title:"گروه:",
                optionDataSource: courseCategorieItems,
                displayField: "titleFa",
                valueField: "id",
                pickListProperties:{
                    showFilterEditor: false
                },
            },
            {
                name: "personnelNo1",
                title: "نمایش گزارش",
                showHintInField: true,
                // operator: "inSet",
                startRow: false,
                endRow: false,
                type: "Button",
                click: function (form) {

                    if(form.getItem("source").getValue() != undefined && form.getItem("source").getValue() !=null)
                    {
                        fetchListGridData();
                    }
                            }
            },
        ],
    });

    Grid_Course_Need_Assessment_List = isc.TrLG.create({
        padding: 10,
        dataSource: Rest_data_List_Grid,
        selectionType: "single",
        width :"100%",
        dataPageSize: 30,
        showRowNumbers: true,
        allowAdvancedCriteria: true,
        showFilterEditor: false,
    });

    let HLayOut_CriteriaForm = isc.TrVLayout.create({
        height: "90%",
        align: "center",
        alignLayout: "center",
        vAlign: "center",
        members: [
            DynamicForm_CriteriaForm_JspTrainingFileNAReport,
            Grid_Course_Need_Assessment_List
        ]
    });


    //----------------------------------- layOut -----------------------------------------------------------------------


    let HLayOut_Confirm_JspTrainingFileNAReport = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "70%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [

        ]
    });

    let VLayout_Body_JspTrainingFileNAReport = isc.TrVLayout.create({
        height: "100%",
        width: "100%",
        align: "top",
        alignLayout: "top",
        vAlign: "top",
        members: [
            HLayOut_CriteriaForm,
            HLayOut_Confirm_JspTrainingFileNAReport
        ]
    });


    function fetchListGridData() {
        let area = DynamicForm_CriteriaForm_JspTrainingFileNAReport.getValue("source");
        let reportCriteria = {
            _constructor: "AdvancedCriteria",
            operator: "and",
            criteria: [
                {
                    fieldName: "categoryId",
                    operator: "equals",
                    value: area
                }
            ]
        };

        //
        //
        Rest_data_List_Grid.fetchData(reportCriteria, function (dsResponse, data, dsRequest) {
            if (data.length) {
                Grid_Course_Need_Assessment_List.setData(data);
            }
        });
    }