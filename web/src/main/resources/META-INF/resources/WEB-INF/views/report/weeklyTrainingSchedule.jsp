<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.core.SecurityUtil" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
// <script>
    var userNationalCode_JspWeeklyTrainingSchedule = "<%= SecurityUtil.getNationalCode()%>";
    //----------------------------------------------------Variables-----------------------------------------------------
    RestDataSource_Class_JspWeeklyTrainingSchedule = isc.TrDS.create({
        fields: [
            {name: "id"},
            {name: "sessionDate"},
            {name: "dayName"},
            {name: "sessionHour"},
            {name: "sessionStartHour"},
            {name: "sessionStateFa"},
            {name: "tclass.code"},
            {name: "tclass.course.code"},
            {name: "tclass.course.titleFa"},
            {name: "studentStatus"},
            {name: "studentPresentStatus"}
            ],
        fetchDataURL: studentPortalUrl + "/sessionService/specListWeeklyTrainingSchedule/" + userNationalCode_JspWeeklyTrainingSchedule
    });
    //----------------------------------------------------ListGrid Result-----------------------------------------------
    ListGrid_Result_JspWeeklyTrainingSchedule  = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Class_JspWeeklyTrainingSchedule,
        initialSort: [
            // {property: "studentStatus", direction:"ascending"},
            {property: "sessionDate", direction: "ascending"},
            {property: "sessionStartHour", direction: "ascending"}
        ],
        canAddFormulaFields: false,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: true,
        selectionType: "single",
        canMultiSort: true,
        autoFetchData: true,
        fields: [
            {name: "id", title: "id", canEdit: false, hidden: true},
            {
                name: "tclass.code",
                title: "کد کلاس"
            },
            {
                name: "tclass.course.code",
                title: "کد دوره"
            },
            {
                name: "tclass.course.titleFa",
                title: "نام دوره"
            },
            {
                name: "sessionDate",
                title: "تاریخ"
            },
            {
                name: "sessionStartHour",
                title: "ساعت شروع",
                filterOperator: "iContains",
                hidden: true},
            {
                name: "dayName",
                title: "روز"
            },
            {
                name: "sessionHour",
                title: "ساعت"
            },
            {
                name: "sessionStateFa",
                title: "وضعیت برگزاری",
                align: "center",
                valueMap: {
                    "شروع نشده" : "شروع نشده",
                    "در حال اجرا" : "در حال اجرا",
                    "پایان" : "پایان"
                }
            },
            {
                name: "studentStatus",
                title: "وضعیت شما",
                align: "center",
                valueMap: {
                    "ثبت نام شده" : "ثبت نام شده",
                    "ثبت نام نشده": "ثبت نام نشده"
                }
            },
            {
                name: "studentPresentStatus",
                title: "وضعیت حضور و غیاب شما",
                align: "center",
                valueMap: {
                    "0": "نامشخص",
                    "1": "حاضر",
                    "2": "حاضر و اضافه کار",
                    "3": "غیبت غیر موجه",
                    "4": "غیبت موجه",
                }
            },
        ],
    });

    VLayout_Body_JspWeeklyTrainingSchedule = isc.TrVLayout.create({
        members: [
           ListGrid_Result_JspWeeklyTrainingSchedule
        ]
    });


    // </script>