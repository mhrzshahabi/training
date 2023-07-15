<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>

// <script>

    let RestDataSource_Teacher_TQCR = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "personality.firstNameFa", filterOperator: "iContains"},
            {name: "personality.lastNameFa", filterOperator: "iContains"},
            {name: "personality.nationalCode", filterOperator: "iContains"},
            {name: "fullNameFa"}
        ],
        fetchDataURL: teacherUrl + "fullName"
    });

    let RestDataSource_Course_TQCR = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "categoryId"},
            {name: "subCategory.titleFa"},
            {name: "erunType.titleFa"},
            {name: "elevelType.titleFa"},
            {name: "etheoType.titleFa"},
            {name: "theoryDuration"},
            {name: "etechnicalType.titleFa"},
            {name: "minTeacherDegree"},
            {name: "minTeacherExpYears"},
            {name: "minTeacherEvalScore"},
            {name: "needText"},
            {name: "description"},
            {name: "workflowStatus"},
            {name: "workflowStatusCode"},
            {name: "hasGoal"},
            {name: "hasSkill"},
            {name: "evaluation"},
            {
                name: "behavioralLevel",
            }
            // {name: "version"},
        ],
        fetchDataURL: courseUrl + "spec-list",
    });

    let RestDataSource_View_TQCR = isc.TrDS.create({
        fields: [
            {name: "id", title: "id", primaryKey: true, hidden: true},
            <%--{name: "courseId", title: "<spring:message code="course"/>", filterOperator: "iContains"},--%>
            {name: "courseCode", title: "<spring:message code="course.code"/>", filterOperator: "iContains"},
            {name: "courseTitle", title: "<spring:message code="course"/>", filterOperator: "iContains"},
            {name: "teacherFullName", title: "<spring:message code="teacher.name"/>", filterOperator: "iContains"},
            {
                name: "teacherNationalCode",
                title: "<spring:message code="teacher.national"/>",
                filterOperator: "iContains"
            },
            {name: "year", title: "<spring:message code="year"/>", filterOperator: "iContains"},
            {name: "questionCount", title: "تعداد سوال", filterOperator: "iContains"},
        ],
        fetchDataURL: viewTeacherQuestionCountReportUrl + "/list",
    });

    let DynamicForm_TQCR = isc.DynamicForm.create({
        numCols: 6,
        layoutAlign: "center",
        fields: [
            {
                name: "yearOfQuestion",
                title: "<spring:message code='year'/>",
                textAlign: "center",
                titleAlign: "left",
                required: true,
                defaultToFirstOption: true,
                type: "float",
                keyPressFilter: "[0-9]",
                length: "4"
            },
            {
                name: "teacherId",
                title: "<spring:message code="teacher"/>",
                textAlign: "center",
                titleAlign: "left",
                autoFetchData: false,
                required: false,
                height: "30",
                width: "*",
                optionDataSource: RestDataSource_Teacher_TQCR,
                valueField: "id",
                displayField: "fullNameFa",
                filterFields: ["personality.firstNameFa", "personality.lastNameFa", "personality.nationalCode"],
                filterOnKeypress: true,
                pickListFields: [
                    {name: "personality.firstNameFa", title: "نام"},
                    {name: "personality.lastNameFa", title: "نام خانوادگی"},
                    {name: "personality.nationalCode", title: "کد ملی"}],
                pickListProperties: {
                    showFilterEditor: true
                },
                icons: [
                    {
                        name: "clear",
                        src: "[SKIN]actions/remove.png",
                        width: 15,
                        height: 15,
                        inline: true,
                        prompt: "پاک کردن",
                        click: function (form, item, icon) {
                            item.clearValue();
                            item.focusInItem();
                            form.setValue(null);
                        }
                    }
                ]
            },
            {
                name: "courseId",
                title: "<spring:message code="course"/>",
                textAlign: "center",
                titleAlign: "left",
                required: false,
                autoFetchData: false,
                height: "30",
                width: "*",
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Course_TQCR,
                filterOnKeypress: true,
                filterFields: ["titleFa", "code"],
                pickListProperties: {
                    showFilterEditor: true,
                },
                pickListFields: [
                    {
                        name: "titleFa",
                        title: "<spring:message code="title"/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "code",
                        title: "<spring:message code="code"/>",
                        filterOperator: "iContains"
                    }
                ],
                icons: [
                    {
                        name: "clear",
                        src: "[SKIN]actions/remove.png",
                        width: 15,
                        height: 15,
                        inline: true,
                        prompt: "پاک کردن",
                        click: function (form, item, icon) {
                            item.clearValue();
                            item.focusInItem();
                            form.setValue(null);
                        }
                    }
                ],
            },
        ]
    })

    let IButton_Report_TQCR = isc.IButtonSave.create({
        title: "چاپ گزارش",
        width: 300,
        click: function () {
            if (!DynamicForm_TQCR.validate()) {
                return;
            }

            let dataValues = DynamicForm_TQCR.getValuesAsAdvancedCriteria();

            for (let i = 0; i < dataValues.criteria.size(); i++) {
                if (dataValues.criteria[i].fieldName === "courseId") {
                    dataValues.criteria[i].operator = "equals";
                }
                if (dataValues.criteria[i].fieldName === "teacherId") {
                    dataValues.criteria[i].operator = "equals";
                }
            }

            ListGrid_Report_TQCR.invalidateCache();
            ListGrid_Report_TQCR.fetchData(dataValues);
        }
    });

    let ListGrid_Report_TQCR = isc.TrLG.create({
        marginTop: 10,
        width: "100%",
        height: "100%",
        showRowNumbers: true,
        dataSource: RestDataSource_View_TQCR,
        selectionType: "single",
        autoFetchData: false,
        allowAdvancedCriteria: true,
        alternateRecordStyles: true,
        allowFilterOperators: true,
        showFilterEditor: true,
        fields: [
            {name: "id", title: "id", primaryKey: true, hidden: true},
            <%--{name: "courseId", title: "<spring:message code="course"/>", filterOperator: "iContains"},--%>
            {name: "courseCode", title: "<spring:message code="course.code"/>", filterOperator: "iContains"},
            {name: "courseTitle", title: "<spring:message code="course"/>", filterOperator: "iContains"},
            {name: "teacherFullName", title: "<spring:message code="teacher.name"/>", filterOperator: "iContains"},
            {
                name: "teacherNationalCode",
                title: "<spring:message code="teacher.national"/>",
                filterOperator: "iContains"
            },
            {name: "yearOfQuestion", title: "<spring:message code="year"/>", filterOperator: "iContains"},
            {name: "questionCount", title: "تعداد سوال", filterOperator: "iContains"},
        ],
        fetchDataURL: viewTeacherQuestionCountReportUrl + "/list"
    });

    let HLayout_Report_Top = isc.HLayout.create({
        width: "100%",
        height: "5%",
        members: [DynamicForm_TQCR]
    })

    let HLayout_Report_Middle = isc.HLayout.create({
        width: "100%",
        height: "5%",
        align: "center",
        members: [IButton_Report_TQCR],
    })

    let HLayout_Report_Bottom = isc.HLayout.create({
        width: "100%",
        height: "90%",
        members: [ListGrid_Report_TQCR],
    })

    let VLayout_Report_body = isc.VLayout.create({
        margin: 5,
        members: [HLayout_Report_Top, HLayout_Report_Middle, HLayout_Report_Bottom]
    })

    // </script>