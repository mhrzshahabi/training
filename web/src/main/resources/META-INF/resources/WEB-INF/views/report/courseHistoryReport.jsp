<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>

// <script>
    //----------------------------------------------------Variables-----------------------------------------------------
    let record = ListGrid_Course.getSelectedRecord();

    //----------------------------------------------------Rest DataSource-----------------------------------------------

    RestDataSource_Course_History_DS = isc.TrDS.create({
        field: [
            {name: "code"},
            {name: "titleFa"},
            {name: "lastModifiedDate"},
            {name: "lastModifiedBy"},
            {name: "revType"},
            {name: "description"},
            {name: "createdDate"},
            {name: "createdBy"},
            {name: "theoryDuration"},
            {name: "etechnicalType.titleFa"},
            {name: "minTeacherDegree"},
            {name: "minTeacherExpYears"},
            {name: "minTeacherEvalScore"},
            {name: "evaluation"},
            {name: "behavioralLevel"},
            {name: "isSpecial"}
        ],
        fetchDataURL: courseUrl + "audit" + "/" + record.id,
    });

    //----------------------------------- LISTGRID -----------------------------------------------------------------------

    var ListGrid_Course_History_LG = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Course_History_DS,
        dataPageSize: 100,
        allowFilterExpressions: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        showRollOver: false,
        selectionType: "single",
        autoFetchData: true,
        showFilterEditor: false,
        fields: [
            {
                name: "titleFa",
                title: "<spring:message code="course_fa_name"/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "code",
                title: "<spring:message code="corse_code"/>",
                align: "center",
            },

            {
                name: "lastModifiedDate",
                title: "تغییر داده شده درتاریخ",
                align: "center",
                canFilter: false,
                formatCellValue: function (value) {
                    if (value) {
                        let date = new Date(value);
                        return date.toLocaleString('fa-IR');
                    }
                }
            },
            {
                name: "lastModifiedBy",
                title: "تغییر داده شده توسط",
                canFilter: false,
                align: "center"
            },
            {
                name: "revType",
                title: "نوع تغییر",
                canFilter: false,
                align: "center",
                formatCellValue: function (value, record) {
                    if (value === 0)
                        return "اضافه شده";
                    else if (value === 1) {
                        if (record.deleted === 75)
                            return "حذف شده";
                        else
                            return "ویرایش شده";
                    } else
                        return "";
                }
            },
            {
                name: "description",
                title: "توضیحات",
                canFilter: false,
                align: "center"
            },
            {
                name: "createdDate",
                title: "ایجاد  شده درتاریخ",
                canFilter: false,
                align: "center",
                formatCellValue: function (value) {
                    if (value) {
                        let date = new Date(value);
                        return date.toLocaleString('fa-IR');
                    }
                }
            },
            {
                name: "createdBy",
                title: "ایجاد  شده توسط",
                canFilter: false,
                align: "center"
            },
            {
                name: "theoryDuration",
                title: "<spring:message code="course_theoryDuration"/>",
            },
            {
                name: "etechnicalType.titleFa",
                title: "<spring:message code="course_etechnicalType"/>",
            },
            {
                name: "minTeacherDegree",
                title: "<spring:message code="course_minTeacherDegree"/>",
            },
            {
                name: "minTeacherExpYears",
                title: "<spring:message code="course_minTeacherExpYears"/>",
            },
            {
                name: "minTeacherEvalScore",
                title: "<spring:message code="course_minTeacherEvalScore"/>",
            },
            {
                name: "evaluation",
                title: "<spring:message code="evaluation.level"/>",
                valueMap: {
                    "1": "واکنشی",
                    "2": "یادگیری",
                    "3": "رفتاری",
                    "4": "نتایج"
                }
            },
            {
                name: "behavioralLevel",
                title: "سطح رفتاری",
                valueMap: {
                    "1": "مشاهده",
                    "2": "مصاحبه",
                    "3": "کار پروژه ای"
                }
            },
            {
                name: "isSpecial",
                title: "نوع دوره",
                valueMap: {
                    "true": "خاص",
                    "false": "غیر خاص"
                }
            }
        ]
    });

    //----------------------------------- layOut -----------------------------------------------------------------------

    var VLayout_Course_History = isc.TrVLayout.create({
        border: "2px solid blue",
        padding: 20,
        members: [
            ListGrid_Course_History_LG
        ]
    });

    // </script>