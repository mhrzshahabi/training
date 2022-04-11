<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>


    var averageEvalGradeLabel = isc.Label.create({
        contents: "میانگین نمره فراگیران به استاد : ",
        border: "0px solid black",
        align: "center",
        width: "100%",
        height: "100%"
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*RestDataSource*/
    //--------------------------------------------------------------------------------------------------------------------//

    RestDataSource_JspInternalTeachingSubject = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "course.code", filterOperator: "iContains"},
            {name: "course.titleFa", filterOperator: "equals"},
            {name: "organizer.titleFa", filterOperator: "equals"},
            {name: "startDate"},
            {name: "endDate"},
            {name: "teacherEvalGrade"},
            {name: "evaluationGrade"},
            {name: "code"}
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Grid*/
    //--------------------------------------------------------------------------------------------------------------------//

    ListGrid_JspInternalTeachingSubject = isc.TrLG.create({
        dataSource: RestDataSource_JspInternalTeachingSubject ,
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
                name: "organizer.titleFa",
                title: "برگزارکننده",
                filterOperator: "iContains"
            },
            {
                name: "teacherEvalGrade",
                title: "نمره ارزیابی فراگیران به مدرس",
                canFilter: false
            },
            {
                name: "evaluationGrade",
                title: "نمره ارزیابی فراگیران به مدرس",
                hidden: true
            },



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
        freezeFieldText: "<spring:message code='freezeFieldText'/>",
        dataArrived: function () {
            this.Super("dataArrived", arguments);
            let localData = this.data.localData;

            let total = 0;
            let average = 0;
            let averageCount = 0;
            if (localData.length) {
                for (let i = 0; i < localData.length; i++) {
                    total += localData[i].evaluationGrade;
                    if (localData[i].evaluationGrade !== 0)
                        averageCount += 1
                }
                if (averageCount !== 0) {
                    average = total / averageCount;
                    averageEvalGradeLabel.setContents("میانگین نمره فراگیران به استاد : " + (Math.round(average * 100) / 100).toFixed(2));
                }else{
                    averageEvalGradeLabel.setContents("میانگین نمره فراگیران به استاد : - ");
                }

            }
            debugger;
        },
    });

    VLayout_Body_JspInternalTeachingSubject = isc.TrVLayout.create({
        members: [
            isc.HLayout.create({
                width: "100%",
                height: "1%",
                margin: 10,
                members: [ isc.ToolStripButtonChart.create({
                    click: function () {
                        ExportToFile.downloadExcelRestUrl(null, ListGrid_JspInternalTeachingSubject, classUrl + "listByteacherID/" + teacherIdInternalTeachingSubject, 0,null, '', "استاد - اطلاعات پايه - سوابق تدریس در این مرکز", ListGrid_JspInternalTeachingSubject.getCriteria(), null)
                    }
                }),averageEvalGradeLabel
                ]
            }),
            ListGrid_JspInternalTeachingSubject
        ],

    });

    function ListGrid_InternalTeachingSubject_refresh() {
        ListGrid_JspInternalTeachingSubject.invalidateCache();
        ListGrid_JspInternalTeachingSubject.filterByEditor();
    }


    function loadPage_InternalTeachingSubject(id) {

        teacherIdInternalTeachingSubject = id;
        RestDataSource_JspInternalTeachingSubject.fetchDataURL = classUrl + "listByteacherID/" + teacherIdInternalTeachingSubject;

         ListGrid_InternalTeachingSubject_refresh();
    }

    function clear_InternalTeachingSubject() {
        ListGrid_JspInternalTeachingSubject.clear();
    }


    //</script>