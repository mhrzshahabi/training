<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


// <script>
    var RestDataSource_cost_class_teacher_JspClass = isc.TrDS.create({
        ID:"RestDataSource_cost_class_teacher_JspClass",
        fields: [
            {name: "id", type: "Integer", primaryKey: true},
            {name: "personality.firstNameFa"},
            {name: "personality.lastNameFa"},
            {name: "personality.nationalCode"},

        ],


    });
    //=================================================================
    var DynamicForm_costClass = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        align: "center",
        canSubmit: true,
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: false,
        errorOrientation: "right",
        numCols: 6,
        padding: 20,
        colWidths: ["1%", "5%","5%", "30"],
        items: [
            {
                //colSpan: 3,

                name:"itemID",
                type:"ComboBoxItem",
                width:240,
                title:"نام و نام خانوادگی استاد",
                optionDataSource:RestDataSource_cost_class_teacher_JspClass,
                displayField: "fullNameFa",
                valueField: "id",
                filterFields: "fullNameFa",
                pickListWidth:260,
                pickListFields: [
                    {name: "personality.firstNameFa", title: "<spring:message code="firstName"/>"},
                    {name: "personality.lastNameFa", title: "<spring:message code="lastName"/>"},
                    {name: "personality.nationalCode", title: "<spring:message code="national.code"/>"},
                ]
            },
            {
                type: "radioGroup",
                title: "قرارداد آموزشی",
                //  icon: "<spring:url value="check-mark.png"/>",
                width:"10",
                colSpan: 1,
                rowSpan: 1,
                height:"30",
                showDownIcon: true,
                startRow: false,
                endRow: false,
                valueMap: {
                    "1": "دارد",
                    "2": "ندارد",

                },
                click: function () {

                }
            },

        ]
    })


    var HLayout_Body_Top = isc.HLayout.create({
        width: "100%",
        height: "100%",

        members: [DynamicForm_costClass],
    });    var All_Body = isc.VLayout.create({
        width: "100%",
        showEdges: true,
        members: [HLayout_Body_Top]
    });

    //========================================FUNCTION=======================================




    function loadPage_costClass(classRecord) {

        if (!(classRecord == undefined || classRecord == null)) {
            RestDataSource_cost_class_teacher_JspClass.fetchDataURL =teacherUrl+'fullName'+'/'+classRecord.teacherId

        } else {

        }
    }