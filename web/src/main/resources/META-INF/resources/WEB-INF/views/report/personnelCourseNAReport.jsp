<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>
    
    var selectedPerson_TrainingFile = null;
    var printUrl_TrainingFile = "<spring:url value="/web/print/class-student/"/>";

    NACourseDS_PCNR = isc.TrDS.create({
        fields: [
            {name: "courseId", primaryKey: true, hidden: true},
            {name: "courseCode", title:"<spring:message code='corse_code'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "courseTitleFa", title:"<spring:message code='course'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "totalEssentialPersonnelCount", title: "تعداد کل ضروری", filterOperator: "equals", autoFitWidth: true},
            {name: "notPassedEssentialPersonnelCount", title:"تعداد افراد نگذرانده در اولویت ضروری", filterOperator: "equals", autoFitWidth: true},
            {name: "totalImprovingPersonnelCount", title: "تعداد کل بهبود", filterOperator: "equals", autoFitWidth: true},
            {name: "notPassedImprovingPersonnelCount", title:"تعداد افراد نگذرانده در اولویت بهبود", filterOperator: "equals", autoFitWidth: true},
            {name: "totalDevelopmentalPersonnelCount", title: "تعداد کل توسعه ای", filterOperator: "equals", autoFitWidth: true},
            {name: "notPassedDevelopmentalPersonnelCount", title:"تعداد افراد نگذرانده در اولویت توسعه ای", filterOperator: "equals", autoFitWidth: true},
        ],
        fetchDataURL: personnelCourseNAReportUrl
    });

    CompanyDS_PCNR = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="company"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: personnelUrl + "/all-field-values?fieldName=companyName"
    });
    AreaDS_PCNR = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: personnelUrl + "/all-field-values?fieldName=ccpArea"
    });
    ComplexDS_PCNR = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="complex"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: personnelUrl + "/all-field-values?fieldName=complexTitle"
    });
    AssistantDS_PCNR = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: personnelUrl + "/all-field-values?fieldName=ccpAssistant"
    });
    AffairsDS_PCNR = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: personnelUrl + "/all-field-values?fieldName=ccpAffairs"
    });
    
    UnitDS_PCNR = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: personnelUrl + "/all-field-values?fieldName=ccpUnit"
    });
    SectionDS_PCNR = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="term.code"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: personnelUrl + "/all-field-values?fieldName=ccpSection"
    });

    CourseDS_PCNR = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code", title: "<spring:message code="course.code"/>"},
            {name: "titleFa", title: "<spring:message code="course.title"/>"},
        ],
        fetchDataURL: courseUrl + "spec-list",
    });

    FilterDF_PCNR = isc.DynamicForm.create({
        numCols: 10,
        padding: 10,
        margin:0,
        // cellPadding: 10,
        titleAlign:"left",
        wrapItemTitles: true,
        // colWidths:[50,150,50,150,50,150,50,150, 50, 150],
        // sectionVisibilityMode: "mutex",
        fields: [
            {
                name: "personnelPersonnelNo2",
                title:"پرسنلی 6رقمی",
                <%--title:"<spring:message code="personnel.no.6.digits"/>",--%>
                textAlign: "center",
                // width: "*"
            },
            {
                name: "personnelPersonnelNo",
                title:"<spring:message code="personnel.no"/> ",
                textAlign: "center",
                // width: "*"
            },
            {
                name: "personnelNationalCode",
                title:"<spring:message code="national.code"/> ",
                textAlign: "center",
                // width: "*",
            },
            {
                name: "personnelFirstName",
                title:"<spring:message code="firstName"/> ",
                textAlign: "center",
                // width: "*"
            },
            {
                name: "personnelLastName",
                title:"<spring:message code="lastName"/> ",
                textAlign: "center",
                // width: "*"
            },
            {
                name: "personnelComplexTitle",
                title: "<spring:message code="complex"/>",
                optionDataSource: ComplexDS_PCNR,
                autoFetchData: false,
                filterFields: ["value", "value"],
                pickListWidth: 300,
                type: "ComboBoxItem",
                textMatchStyle: "substring",
                pickListProperties: {
                    showFilterEditor: false,
                    showClippedValuesOnHover: true,
                },
                valueField: "value",
                displayField: "value",
            },
            {
                name: "personnelCompanyName",
                title: "<spring:message code="company"/>",
                filterFields: ["value", "value"],
                pickListWidth: 300,
                type: "ComboBoxItem",
                textMatchStyle: "substring",
                pickListProperties: {
                    showFilterEditor: false,
                    showClippedValuesOnHover: true,
                },
                optionDataSource: CompanyDS_PCNR,
                autoFetchData: false,
                valueField: "value",
                displayField: "value",
            },
            {
                name: "personnelCcpArea",
                title: "<spring:message code="area"/>",
                filterFields: ["value", "value"],
                pickListWidth: 300,
                type: "ComboBoxItem",
                textMatchStyle: "substring",
                pickListProperties: {
                    showFilterEditor: false,
                    showClippedValuesOnHover: true,
                },
                optionDataSource: AreaDS_PCNR,
                autoFetchData: false,
                valueField: "value",
                displayField: "value",
            },
            {
                name: "personnelCcpAssistant",
                title: "<spring:message code="assistance"/>",
                filterFields: ["value", "value"],
                pickListWidth: 300,
                type: "ComboBoxItem",
                textMatchStyle: "substring",
                pickListProperties: {
                    showFilterEditor: false,
                    showClippedValuesOnHover: true,
                },
                optionDataSource: AssistantDS_PCNR,
                autoFetchData: false,
                valueField: "value",
                displayField: "value",
            },
            {
                name: "personnelCcpSection",
                title: "<spring:message code="section.cost"/>",
                filterFields: ["value", "value"],
                pickListWidth: 300,
                type: "ComboBoxItem",
                textMatchStyle: "substring",
                pickListProperties: {
                    showFilterEditor: false,
                    showClippedValuesOnHover: true,
                },
                optionDataSource: SectionDS_PCNR,
                autoFetchData: false,
                valueField: "value",
                displayField: "value",
            },
            {
                name: "personnelCcpUnit",
                title: "<spring:message code="unitName"/>",
                filterFields: ["value", "value"],
                pickListWidth: 300,
                type: "ComboBoxItem",
                textMatchStyle: "substring",
                pickListProperties: {
                    showFilterEditor: false,
                    showClippedValuesOnHover: true,
                },
                optionDataSource: UnitDS_PCNR,
                autoFetchData: false,
                valueField: "value",
                displayField: "value",
            },
            {
                name: "personnelCcpAffairs",
                title: "<spring:message code="affairs"/>",
                optionDataSource: AffairsDS_PCNR,
                autoFetchData: false,
                filterFields: ["value", "value"],
                type: "ComboBoxItem",
                textMatchStyle: "substring",
                pickListProperties: {
                    showFilterEditor: false,
                    showClippedValuesOnHover: true,
                },
                valueField: "value",
                displayField: "value",
            },
            {
                name: "courseId",
                title: "<spring:message code="course"/>",
                optionDataSource: CourseDS_PCNR,
                autoFetchData: false,
                type: "MultiComboBoxItem",
                valueField: "id",
                displayField: "code",
                // comboBoxWidth: 200,
                // layoutStyle: "horizontal",
                comboBoxProperties: {
                    hint: "",
                    pickListWidth: 400,
                    pickListFields: [
                        {name: "code", autoFitWidth: true},
                        {name: "titleFa"},
                    ],
                    filterFields: ["titleFa", "code"],
                    textMatchStyle: "substring",

                },
            },
        ],
    });

    <%--Menu_Courses_PCNR = isc.Menu.create({--%>
    <%--    data: [--%>
    <%--        &lt;%&ndash;{&ndash;%&gt;--%>
    <%--            &lt;%&ndash;title: "<spring:message code="global.form.print.pdf"/>",&ndash;%&gt;--%>
    <%--            &lt;%&ndash;click: function () {&ndash;%&gt;--%>
    <%--                &lt;%&ndash;print_Training_File();&ndash;%&gt;--%>
    <%--            &lt;%&ndash;}&ndash;%&gt;--%>
    <%--        &lt;%&ndash;}, &ndash;%&gt;--%>
    <%--        {--%>
    <%--            title: "<spring:message code="global.form.print.excel"/>",--%>
    <%--            click: function () {--%>
    <%--                console.log(CourseLG_PCNR.getFields().subList(1,10));--%>
    <%--                exportToExcel(CourseLG_PCNR.getFields().subList(1,10) ,CourseLG_PCNR.getData().localData)--%>
    <%--                // print_Training_File("excel");--%>
    <%--            }--%>
    <%--        },--%>
    <%--        &lt;%&ndash;{&ndash;%&gt;--%>
    <%--            &lt;%&ndash;title: "<spring:message code="global.form.print.html"/>",&ndash;%&gt;--%>
    <%--            &lt;%&ndash;click: function () {&ndash;%&gt;--%>
    <%--                &lt;%&ndash;print_Training_File("html");&ndash;%&gt;--%>
    <%--            &lt;%&ndash;}&ndash;%&gt;--%>
    <%--        &lt;%&ndash;}&ndash;%&gt;--%>
    <%--    ]--%>
    <%--});--%>

    IButton_Confirm_PCNR = isc.IButtonSave.create({
        // top: 260,
        title: "گزارش گیری",
        width: 300,
        hAlign: "center",
        padding: 10,
        click: function () {
            if(Object.keys(FilterDF_PCNR.getValuesAsCriteria()).length === 0) {
                createDialog("info","فیلتری انتخاب نشده است.");
            } else{
                CourseLG_PCNR.invalidateCache();
                NACourseDS_PCNR.implicitCriteria = FilterDF_PCNR.getValuesAsAdvancedCriteria();
                CourseLG_PCNR.fetchData()
            }
        }
    });

    CourseLG_PCNR = isc.TrLG.create({
        dynamicTitle: true,
        autoFetchData: false,
        allowAdvancedCriteria: true,
        // contextMenu: Menu_Courses_PCNR,
        dataSource: NACourseDS_PCNR,
        filterOnKeypress: true,
        showFilterEditor: false,
        alignLayout: "center",
        align: "center",
        gridComponents: [FilterDF_PCNR, IButton_Confirm_PCNR, "header", "filterEditor", "body"],
        fields:[
            {name: "courseCode"},
            {name: "courseTitleFa"},
            {name: "totalEssentialPersonnelCount"},
            {name: "notPassedEssentialPersonnelCount"},
            {name: "totalImprovingPersonnelCount"},
            {name: "notPassedImprovingPersonnelCount"},
            {name: "totalDevelopmentalPersonnelCount"},
            {name: "notPassedDevelopmentalPersonnelCount"},
            {
                name: "totalNotPassed",
                title: "جمع کل نگذرانده",
                filterOperator: "equals",
                autoFitWidth: true,
                formatCellValue: function (value, record, rowNum, colNum, grid) {
                    return record.notPassedEssentialPersonnelCount + record.notPassedImprovingPersonnelCount + record.notPassedDevelopmentalPersonnelCount;
                },
                sortNormalizer: function (record, fieldName, context) {
                    return record.notPassedEssentialPersonnelCount + record.notPassedImprovingPersonnelCount + record.notPassedDevelopmentalPersonnelCount;
                }
            },
        ]
    });

    <%--var ToolStripButton_Training_File = isc.ToolStripButtonPrint.create({--%>
    <%--    &lt;%&ndash;title: "<spring:message code='print'/>",&ndash;%&gt;--%>
    <%--    click: function () {--%>
    <%--        print_Training_File();--%>
    <%--    }--%>
    <%--});--%>

    // var ToolStrip_Actions_Training_File = isc.ToolStrip.create({
    //     width: "100%",
    //     membersMargin: 5,
    //     members: [ToolStripButton_Training_File]
    // });

    VLayout_Body_PCNR = isc.VLayout.create({
        width: "100%",
        height: "100%",
        // overflow: "scroll",
        members: [
            // ToolStrip_Actions_Training_File,
            CourseLG_PCNR
        ]
    });

 //</script>