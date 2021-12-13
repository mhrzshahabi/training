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
            if(DynamicForm_CriteriaForm_REFR_Passed_UnPassed.getField("courseCategory").getValue()===undefined || DynamicForm_CriteriaForm_REFR_Passed_UnPassed.getField("courseCategory").getValue()===null) {
                createDialog("info","گروه کاری را مشخص کنید");
                return;
            }

            //
            // excelData = [];
            // excelData.add({
            //     rowNum: "ردیف",
            //     course_code: "کد دوره",
            //     course_title_fa: "عنوان دوره",
            //     personnel_personnel_no: "شماره پرسنلی ده رقمی",
            //     personnel_cpp_affairs: "امور",
            //     personnel_cpp_assistant: "معاونت",
            //     personnel_cpp_section: "قسمت",
            //     personnel_cpp_unit: "واحد",
            //     personnel_company_name: "شرکت",
            //     personnel_complex_title: "مجتمع",
            //     personnel_education_level_title: "مدرک تحصیلی",
            //     personnel_first_name: "نام فراگیر",
            //     personnel_last_name: "نام خانوادگی فراگیر",
            //     personnel_national_code: "کد ملی فراگیر",
            //     personnel_emp_no: "کد پرسنلی 6 رقمی",
            //     personnel_post_code: "کد پست",
            //     personnel_post_title: "عنوان پست",
            //
            //
            // });

            let data_values = DynamicForm_CriteriaForm_REFR_Passed_UnPassed.getField("courseCategory").getValue();

            let downloadForm = isc.DynamicForm.create({
                method: "POST",
                action: "/training/export/excel/un-passed",
                target: "_Blank",
                canSubmit: true,
                fields:
                    [
                        {name: "criteria", type: "hidden"},
                    ]
            });
            downloadForm.setValue("criteria", JSON.stringify(data_values));
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
    var VLayOut_CriteriaForm_REFR_Passed_UnPassed = isc.VLayout.create({
        showEdges: false,
        edgeImage: "",
        width: "100%",
        alignLayout: "center",
        members: [
            DynamicForm_CriteriaForm_REFR_Passed_UnPassed]
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