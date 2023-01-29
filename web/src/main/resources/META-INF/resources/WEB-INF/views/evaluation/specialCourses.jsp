<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>

    //----------------------------------------------------Rest DataSource-----------------------------------------------
    let RestDataSource_Course_SC = isc.TrDS.create({
        ID: "specialCourseDS",
        fields: [
            {name: "id", type: "Integer", primaryKey: true},
            {name: "code"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "category"},
            {name: "subCategory.titleFa"},
            {name: "runType.titleFa"},
            {name: "levelType.titleFa"},
            {name: "theoType.titleFa"},
            {name: "duration"},
            {name: "technicalType.titleFa"},
            {name: "minTeacherDegree"},
            {name: "minTeacherExpYears"},
            {name: "minTeacherEvalScore"},
            {name: "issueTitle"},
            {name: "description"},
            {name: "workflowStatus"},
            {name: "workflowStatusCode"},
            {name: "hasGoal"},
            {name: "hasSkill"},
            {name: "evaluation"},
            {name: "behavioralLevel"}
        ],
        fetchDataURL: courseUrl + "search"
    });

    let RestDataSource_Category_SC = isc.TrDS.create({
        ID: "specialCourseCategoryDS",
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", type: "text"}
        ],
        fetchDataURL: categoryUrl + "spec-list"
    });

    let RestDataSource_SubCategory_SC = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", type: "text"}
        ],
        fetchDataURL: subCategoryUrl + "spec-list"
    });

    let RestDataSource_Special_Courses = isc.TrDS.create({
        fields: [
            {name: "id", title: "id", primaryKey: true, hidden: true},
            {name: "name", title: "<spring:message code="course.title"/>"},
            {name: "code", title: "<spring:message code="course.code"/>"},
            {name: "category", title: "<spring:message code="category"/>"},
            {name: "subCategory", title: "<spring:message code="subcategory"/>"},
            {name: "state", title: "<spring:message code="status"/>"}
        ],
        fetchDataURL: selfDeclarationUrl + "/list"
    });
    //----------------------------------- layOut -----------------------------------------------------------------------
    let ToolStripButton_Add_SC = isc.ToolStripButtonCreate.create({
        title: "افزودن به دوره های خاص",
        click: function () {
            
        }
    });

    let ToolStripButton_Refresh_SC = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_SC.invalidateCache();
        }
    });

    let ToolStrip_Actions_SC = isc.ToolStrip.create({
        width: "100%",
        height: "5%",
        membersMargin: 5,
        members:
            [
                ToolStripButton_Add_SC,
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_SC
                    ]
                })
            ]
    });

    let ListGrid_SC = isc.TrLG.create({
        height: "90%",
        filterOnKeypress: true,
        showFilterEditor: true,
        autoFetchData: true,
        gridComponents: ["filterEditor", "header", "body"],
        // dataSource: RestDataSource_Special_Courses,
        fields: [
            {name: "id", hidden: true},
            {name: "name", title: "<spring:message code="course.title"/>"},
            {name: "code", title: "<spring:message code="course.code"/>"},
            {name: "category", title: "<spring:message code="category"/>"},
            {name: "subCategory", title: "<spring:message code="subcategory"/>"},
            {name: "state", title: "<spring:message code="status"/>"}
        ]
    });

    let VLayout_Body_SC = isc.TrVLayout.create({
        padding: 5,
        members: [
            ToolStrip_Actions_SC,
            ListGrid_SC
        ]
    });

    //------------------------------------------------- Functions ------------------------------------------------------


    // </script>