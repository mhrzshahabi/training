<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%
%>
// <script>

    //----------------------------------------------------Variables-----------------------------------------------------


    //----------------------------------------------------Default Rest--------------------------------------------------


    //----------------------------------------------------Rest DataSource-----------------------------------------------
    RestDataSource_Category_REFR_Passed_UnPassed = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: categoryUrl + "spec-list"
    });

    //----------------------------------------------------Criteria Form------------------------------------------------


    DynamicForm_CriteriaForm_REFR_Passed_UnPassed = isc.DynamicForm.create({
        align: "right",
        titleWidth: 0,
        titleAlign: "center",
        showInlineErrors: true,
        showErrorText: false,
        numCols: 6,
        colWidths: ["10%", "25%", "25%", "10%", "25%", "25%"],
        fields: [
            {
                name: "courseCategory",
                title: "گروه کاری",
                type: "SelectItem",
                textAlign: "center",
                colSpan: 2,
                titleColSpan: 1,
                optionDataSource: RestDataSource_Category_REFR_Passed_UnPassed,
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                multiple: true,
                filterLocally: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains"
                },
                pickListFields: [
                    {
                        name: "id",
                        hidden: true,
                        align: "center"
                    },
                    {
                        name: "titleFa",
                        title: "عنوان گروه",
                        align: "center"
                    }
                ],
                changed: function () {
                }
            },
            {
                name: "passedOrUnPassed",
                title: "گذرانده / نگذرانده",
                textAlign: "center",
                colSpan: 2,
                titleColSpan: 1,
                type: "radioGroup",
                textMatchStyle: "exact",
                width: "*",
                valueMap: {
                    "unPassed": "نگذرانده",
                    "passed": "گذرانده"
                },
            }
        ]
    });

    IButton_Excel_Report_Passed_UnPassed = isc.IButtonSave.create({
        top: 260,
        baseStyle: 'MSG-btn-orange',
        icon: "<spring:url value="excel.png"/>",
        title: "درخواست گزارش اکسل",
        width: 300,
        click: function () {
             let  data_values_GSIR = null;
            data_values_GSIR = organSegmentFilterCoursePassed.getValuesAsAdvancedCriteria();
            if(DynamicForm_CriteriaForm_REFR_Passed_UnPassed.getField("courseCategory").getValue()===undefined || DynamicForm_CriteriaForm_REFR_Passed_UnPassed.getField("courseCategory").getValue()===null) {
                createDialog("info","گروه کاری را مشخص کنید");
                return;
            }
            if(DynamicForm_CriteriaForm_REFR_Passed_UnPassed.getField("passedOrUnPassed").getValue()===undefined || DynamicForm_CriteriaForm_REFR_Passed_UnPassed.getField("passedOrUnPassed").getValue()===null) {
                createDialog("info","گذرانده / نگذرانده را مشخص کنید");
                return;
            }
            let downloadForm = isc.DynamicForm.create({
                method: "POST",
                action: "/training/export/excel/un-passed",
                target: "_Blank",
                canSubmit: true,
                fields:
                    [
                        {name: "courseCategory", type: "hidden"},
                        {name: "passedOrUnPassed", type: "hidden"},
                        {name: "criteria", type: "hidden"},
                    ]
            });

            downloadForm.setValue("courseCategory", JSON.stringify(DynamicForm_CriteriaForm_REFR_Passed_UnPassed.getField("courseCategory").getValue()));
            downloadForm.setValue("passedOrUnPassed", JSON.stringify(DynamicForm_CriteriaForm_REFR_Passed_UnPassed.getField("passedOrUnPassed").getValue()));
            downloadForm.setValue("criteria", JSON.stringify(data_values_GSIR));
            downloadForm.show();
            downloadForm.submitForm();
        }
    });
    IButton_Clear_REFR_Passed_UnPassed = isc.IButtonSave.create({
        top: 260,
        title: "پاک کردن",
        width: 300,
        click: function () {
            DynamicForm_CriteriaForm_REFR_Passed_UnPassed.clearValues();
            DynamicForm_CriteriaForm_REFR_Passed_UnPassed.clearErrors();
            IButton_Excel_Report_Passed_UnPassed.setDisabled(false)
        }
    });


    //----------------------------------- layOut -----------------------------------------------------------------------

    let organSegmentFilterCoursePassed = init_OrganSegmentFilterDF(true, true, true, true, true, null, "complexTitle", "assistant", "affairs", "section", "unit");


    //----------------------------------- layOut -----------------------------------------------------------------------
    var VLayOut_CriteriaForm_REFR_Passed_UnPassed = isc.VLayout.create({
        showEdges: false,
        edgeImage: "",
        width: "100%",
        alignLayout: "center",
        members: [
            organSegmentFilterCoursePassed,
            DynamicForm_CriteriaForm_REFR_Passed_UnPassed
        ]
    });
    var HLayOut_Confirm_REFR_Passed_UnPassed = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_Clear_REFR_Passed_UnPassed,
            IButton_Excel_Report_Passed_UnPassed
        ]
    });
    var VLayout_Body_REFR_Passed_UnPassed = isc.TrVLayout.create({
        border: "2px solid blue",
        padding: 20,
        members: [
            VLayOut_CriteriaForm_REFR_Passed_UnPassed,
            HLayOut_Confirm_REFR_Passed_UnPassed,
        ]
    });

    //------------------------------------------------- Functions ------------------------------------------------------



    // </script>