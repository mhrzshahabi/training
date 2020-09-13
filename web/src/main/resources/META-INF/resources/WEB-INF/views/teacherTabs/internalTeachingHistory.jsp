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
            {name: "course.code", filterOperator: "iContains"},
            {name: "course.titleFa", filterOperator: "equals"},
            {name: "startDate"},
            {name: "endDate"},
            {name: "evaluationGrade"},
            {name: "code"}
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Grid*/
    //--------------------------------------------------------------------------------------------------------------------//

    ListGrid_JspInternalTeachingHistory = isc.TrLG.create({
        dataSource: RestDataSource_JspInternalTeachingHistory ,
        fields: [
            {name: "id",hidden: true},
            {
                name: "course.code",
                title: "کد دوره",
                filterOperator: "iContains"
            },
            {
                name: "course.titleFa",
                title: "نام دوره",
                filterOperator: "iContains"
            },
            {
                name: "code",
                title: "کد کلاس",
                filterOperator: "iContains"
            },
            {
                name: "startDate",
                title: "تاریخ شروع",
                filterOperator: "iContains",
                filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                }
            },
            {
                name: "endDate",
                title: "تاریخ خاتمه",
                filterOperator: "iContains",
                filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                }
            },
            {
                name: "evaluationGrade",
                title: "نمره ارزیابی فراگیران به مدرس",
                canFilter: false
            }
        ],
        align: "center",
        filterOnKeypress: true,
        filterLocally: true,
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
            isc.HLayout.create({
                width: "100%",
                height: "1%",
                margin: 10,
                members: [ isc.ToolStripButtonExcel.create({
                    click: function () {
                        ExportToFile.downloadExcelRestUrl(null, ListGrid_JspInternalTeachingHistory, classUrl + "listByteacherID/" + teacherIdInternalTeachingHistory, 0,null, '', "استاد - اطلاعات پايه - سوابق تدریس در این مرکز", ListGrid_JspInternalTeachingHistory.getCriteria(), null)
                    }
                })
                ]
            }),
            ListGrid_JspInternalTeachingHistory
        ]
    });

    function ListGrid_InternalTeachingHistory_refresh() {
        ListGrid_JspInternalTeachingHistory.invalidateCache();
        ListGrid_JspInternalTeachingHistory.filterByEditor();
    }


    function loadPage_InternalTeachingHistory(id) {
            teacherIdInternalTeachingHistory = id;
            RestDataSource_JspInternalTeachingHistory.fetchDataURL = classUrl + "listByteacherID/" + teacherIdInternalTeachingHistory;
            ListGrid_JspInternalTeachingHistory.fetchData();
            ListGrid_InternalTeachingHistory_refresh();
    }

    function clear_InternalTeachingHistory() {
        ListGrid_JspInternalTeachingHistory.clear();
    }

    //</script>