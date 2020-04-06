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
            {name: "id",hidden: true},
            {
                name: "code",
                title: "کد کلاس",
            },
            {
                name: "titleClass",
                title: "نام کلاس",
            },
            {
                name: "startDate",
                title: "تاریخ شروع",
            },
            {
                name: "endDate",
                title: "تاریخ خاتمه",
            },
            {
                name: "evaluationGrade",
                title: "نمره ارزیابی فراگیران به استاد",
            }
        ],
        filterEditorSubmit: function () {
            ListGrid_JspInternalTeachingHistory.invalidateCache();
        },
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

    VLayout_Body_JspInternalTeachingHistory = isc.TrVLayout.create({
        members: [
            ListGrid_JspInternalTeachingHistory
        ]
    });

    function loadPage_InternalTeachingHistory(id) {
        if (teacherIdInternalTeachingHistory !== id) {
            teacherIdInternalTeachingHistory = id;
            RestDataSource_JspInternalTeachingHistory.fetchDataURL = classUrl + "listByteacherID/" + teacherIdInternalTeachingHistory;
            ListGrid_JspInternalTeachingHistory.fetchData();
        }
    }


    //</script>