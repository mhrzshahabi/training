<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page import="com.nicico.copper.core.SecurityUtil" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
// <script>
    var userNationalCode_JspWeeklyTrainingSchedule = "<%= SecurityUtil.getNationalCode()%>";
    //----------------------------------------------------Variables-----------------------------------------------------
    var RestDataSource_Class_JspWeeklyTrainingSchedule = isc.TrDS.create({
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
            ],
        fetchDataURL: sessionServiceUrl + "specListWeeklyTrainingSchedule/" + userNationalCode_JspWeeklyTrainingSchedule
    });
    //----------------------------------------------------ListGrid Result-----------------------------------------------
    var ListGrid_Result_JspWeeklyTrainingSchedule  = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Class_JspWeeklyTrainingSchedule,
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
                name: "dayName",
                title: "روز"
            },
            {
                name: "sessionStateFa",
                title: "وضعیت برگزاری",
                align: "center",
                valueMap: {
                    true: "برگزار شده",
                    false: "برگزار نشده"
                }
            },
            {
                name: "sessionHour",
                title: "ساعت"
            },
            {
                name: "personnelStatus2",
                title: "وضعیت شما",
                align: "center",
                valueMap: {
                    true: "ثبت نام شده",
                    false: "ثبت نام نشده"
                }
            },
            {
                name: "personnelStatus3",
                title: "وضعیت حضور و غیاب شما",
                align: "center",
                valueMap: {
                    1: "حاضر",
                    2 : "غایب با مجوز",
                    3: "غایب بدون مجوز",
                    4 : "اضافه کار"
                }
            },
            {
                name: "sessionStartHour",
                title: "تاریخ شروع",
                hidden: true
            }
        ],
        // canMultiSort: true,
        initialSort: [
            {property: "sessionDate", direction: "ascending"},
            {property: "sessionStartHour", direction: "ascending"}
        ],
        cellHeight: 43,
        filterOperator: "iContains",
        filterOnKeypress: true,
        // sortField: 1,
        // sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        allowAdvancedCriteria: true,
        showFilterEditor: true,
        allowFilterExpressions: true,
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>"
    });

    var VLayout_Body_JspWeeklyTrainingSchedule = isc.TrVLayout.create({
        members: [
           ListGrid_Result_JspWeeklyTrainingSchedule
        ]
    });

