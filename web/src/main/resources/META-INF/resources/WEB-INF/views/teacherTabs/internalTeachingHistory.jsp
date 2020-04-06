<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    var teacherIdInternalTeachingHistory = null;
    //--------------------------------------------------------------------------------------------------------------------//
    /*RestDataSource*/
    //--------------------------------------------------------------------------------------------------------------------//

    RestDataSource_JspInternalTeachingHistory = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", filterOperator: "iContains"},
            {name: "titleClass", filterOperator: "equals"},
            {name: "startDate"},
            {name: "endDate"},
            {name: "evaluationGrade"}
        ],
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Grid*/
    //--------------------------------------------------------------------------------------------------------------------//

    ListGrid_JspInternalTeachingHistory = isc.TrLG.create({
        dataSource: RestDataSource_JspInternalTeachingHistory ,
        fields: [
            {
                name: "courseTitle",
                title: "<spring:message code='course.title'/>",
            },
            {
                name: "companyName",
                title: "<spring:message code='company.name'/>",
            },
            {
                name: "educationLevelId",
                type: "IntegerItem",
                title: "<spring:message code='education.level'/>",
                editorType: "SelectItem",
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_EducationLevel_JspTeachingHistory
            },
            {
                name: "categoriesIds",
                title: "<spring:message code='category'/>",
                type: "selectItem",
                optionDataSource: RestDataSource_Category_JspTeachingHistory,
                valueField: "id",
                displayField: "titleFa",
                multiple: true,
                filterOnKeypress: true
            },
            {
                name: "subCategoriesIds",
                title: "<spring:message code='subcategory'/>",
                type: "selectItem",
                optionDataSource: RestDataSource_SubCategory_JspTeachingHistory,
                valueField: "id",
                displayField: "titleFa",
                multiple: true,
                filterOnKeypress: true
            },
            {
                name: "duration",
                title: "<spring:message code='duration'/>",
                filterOperator: "equals"
            },
            {
                name: "startDate",
                title: "<spring:message code='start.date'/>",
                canSort: false
            },
            {
                name: "endDate",
                title: "<spring:message code='end.date'/>",
                canSort: false
            }
        ],
        align: "center",
        filterOperator: "iContains",
        filterOnKeypress: false,
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>"
    });

    VLayout_Body_JspTeachingHistory = isc.TrVLayout.create({
        members: [
            ListGrid_JspInternalTeachingHistory
        ]
    });

    function loadPage_InternalTeachingHistory(id) {
        if (teacherIdInternalTeachingHistory !== id) {
            teacherIdInternalTeachingHistory = id;
            var criteria = "";
            RestDataSource_JspInternalTeachingHistory.fetchDataURL = classUrl + "listByteacherID";
            ListGrid_JspInternalTeachingHistory.fetchData(criteria);
        }
    }


    //</script>