<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>



    let reasonErrorStartDate = "";
    let reasonErrorStartDate2 = "";
    let reasonErrorEndDate = "";
    let reasonErrorEndDate2 = "";
    let countErrorStartDate = 0;
    let countErrorStartDate2 = 0;
    let countErrorEndDate = 0;
    let countErrorEndDate2 = 0;
   // var modalDialog;
    let criteria = null;

    var RestDataSource_Year_Filter_courseWithOutTeacher = isc.TrDS.create({
        fields: [
            {name: "year"}
        ],
        fetchDataURL: termUrl + "years",
        autoFetchData: true
    });

    var RestDataSource_Term_Filter = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "startDate"},
            {name: "endDate"}
        ],
    });

    var RestDataSource_CourseWithOutTeacher = isc.TrDS.create({

        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {
                "Authorization": "Bearer <%= accessToken %>"
            };
            return this.Super("transformRequest", arguments);
        },
        fields: [{name: "id", primaryKey: true, canFilter: false},
            {name: "code", autoFitWidth: true, canFilter: false },
            {name: "title", autoFitWidth: true, canFilter: false},
            {name: "max_start_date", autoFitWidth: true, canFilter: false},
        ], dataFormat: "json",

        // autoFetchData: true,
    });

    var RestDataSource_Teacher_JspcourseWithOutClass = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "personality.firstNameFa", filterOperator: "iContains"},
            {name: "personality.lastNameFa", filterOperator: "iContains"},
            {name: "personality.nationalCode", filterOperator: "iContains"},
            {name: "fullNameFa"}
        ],
        fetchDataURL: teacherUrl + "fullName"
    });


    RestDataSource_CourseDS = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code", title: "<spring:message code="course.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="course.title"/>", filterOperator: "iContains"}
        ],
        fetchDataURL: courseUrl + "spec-list"
    });

    var ButtonExcel =isc.ToolStripButtonExcel.create({
        margin:5,
        disabled: true,
        click: function () {
            let rows = List_Grid_Reaport_CourseWithOutTeacher.data.getAllLoadedRows();
            let result = ExportToFile.getAllFields(List_Grid_Reaport_CourseWithOutTeacher);
            result.fields.splice(1, 0, {name:"titleClass",title:"عنوان کلاس"});
            result.isValueMap.splice(1, 0, false);
            let fields = result.fields;
            let isValueMaps = result.isValueMap;
            let data = [];
            for (let i = 0; i < rows.length; i++) {
                data[i] = {};
                for (let j = 0; j < fields.length; j++) {
                    if (fields[j].name == 'rowNum') {
                        data[i][fields[j].name] = (i + 1).toString();
                    } else {
                        let tmpStr = ExportToFile.getData(rows[i], fields[j].name.split('.'), 0);
                        data[i][fields[j].name] = typeof (tmpStr) == 'undefined' ? '' : ((!isValueMaps[j]) ? tmpStr : listGrid.getDisplayValue(fields[j].name, tmpStr));
                    }
                }
            }
            criteria = DynamicForm_Report_CourseWithOutTeacher.getValuesAsAdvancedCriteria();
            isc.Dialog.create({
                message: "ممکن است خروجی اکسل متفاوت باشد",
                icon: "[SKIN]ask.png",
                title: "<spring:message code='message'/>",
                buttons: [isc.Button.create({title: "<spring:message code='ok'/>"})],
                buttonClick: function (button, index) {
                    if (index == 0) {
                        ExportToFile.downloadExcelRestUrl(null, List_Grid_Reaport_CourseWithOutTeacher, courseUrl + "courseWithOutClass", 0, null, '',"دوره های فاقد کلاس"  , criteria, null);
                    }
                    this.close();
                }
            });


        }
    })
    var ToolStrip_Actions = isc.ToolStrip.create({
        // width: "100%",
        members: [
            ButtonExcel,
            isc.LayoutSpacer.create({width: "*"}),
            isc.Label.create({
                //padding: 5,
                width: "100%%",
                align: "center",
                contents: "<b style='font-size: 10px;'>گزارش شامل دوره هایی است که با توجه به پارامترهای وارد شده، برای آنها کلاسی تشکیل نشده است</b>"
            }),
            isc.Label.create({
                ID: "totalsCount_Rows"
            })]

    })
    var List_Grid_Reaport_CourseWithOutTeacher = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_CourseWithOutTeacher,
        showRowNumbers: true,
        //autoFetchData: true,
        showFilterEditor: false,
        fields: [
            {name: "code", title: "<spring:message code="code"/>", align: "center", filterOperator: "iContains",autoFitWidth:true, filterOnKeypress: false},
            {name: "title", title:"<spring:message code="course"/>", align: "center", filterOperator: "iContains",autoFitWidth:true, filterOnKeypress: false},
            {name: "max_start_date", title:"تاریخ شروع آخرین کلاس", align: "center", filterOperator: "iContains",autoFitWidth:true, filterOnKeypress: false},

        ],
        recordDoubleClick: function () {

        },
        gridComponents: [ToolStrip_Actions,"filterEditor", "header", "body"],



        dataArrived: function ()
        {
            //modalDialog.close();

            let totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown())
                totalsCount_Rows.setContents("<b style='font-size: 10px;'>" + "<spring:message code="records.count"/>" + ":&nbsp;" + totalRows + "</b>");
            else
                totalsCount_Rows.setContents("&nbsp;");
        },
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        useClientFiltering:true,
        filterOnKeypress: true,
        sortField: 0,
    });

    var DynamicForm_Report_CourseWithOutTeacher = isc.DynamicForm.create({
        width: "550px",
        height: "45%",
        overflow:"auto",
        padding: 5,
        cellPadding: 5,
        // titleWidth: 0,
        // titleAlign: "center",
        numCols: 4,
        // colWidths: ["3"],
        items: [
            {

                name: "startDate",
                //height: 35,
                //   titleColSpan: 1,
                // colSpan: 2,
                // titleAlign:"center",
                title: "تاریخ شروع : از",
                ID: "startDate_jspReport",
                type: 'text',
                textAlign: "center",
                // required: true,
                hint: "YYYY/MM/DD",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('startDate_jspReport', this, 'ymd', '/');
                    }
                }],
                editorExit:function(){
                    let result=reformat(DynamicForm_Report_CourseWithOutTeacher.getValue("startDate"));
                    if (result){
                        DynamicForm_Report_CourseWithOutTeacher.getItem("startDate").setValue(result);
                    }
                },
                blur: function () {
                    let dateCheck;
                    if (DynamicForm_Report_CourseWithOutTeacher.getValue("startDate")) {
                        dateCheck = checkDate(DynamicForm_Report_CourseWithOutTeacher.getValue("startDate"));
                        if (dateCheck == false) {
                            DynamicForm_Report_CourseWithOutTeacher.addFieldErrors("startDate", "<spring:message code='msg.correct.date'/>", true);
                        }
                        if (dateCheck == true) {
                            DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("startDate", true);
                            let startDate2 = DynamicForm_Report_CourseWithOutTeacher.getValue("startDate2");
                            let startDate = DynamicForm_Report_CourseWithOutTeacher.getValue("startDate");
                            let endDate = DynamicForm_Report_CourseWithOutTeacher.getValue("endDate");
                            let endDate2 = DynamicForm_Report_CourseWithOutTeacher.getValue("endDate2");

                            countErrorStartDate = 0;
                            if (startDate2 && startDate > startDate2 && reasonErrorStartDate2 != "startDate2LessThanStartDate") {
                                DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("startDate2", true);
                                DynamicForm_Report_CourseWithOutTeacher.addFieldErrors("startDate2", "<spring:message code='msg.equal.less.start.date'/>", true);
                                reasonErrorStartDate = "startDate2LessThanStartDate";
                                countErrorStartDate++;
                            }
                            if (endDate && startDate > endDate && reasonErrorEndDate != "endDateLessThanStartDate") {
                                DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("startDate", true);
                                DynamicForm_Report_CourseWithOutTeacher.addFieldErrors("startDate", "<spring:message code='msg.equal.less.end.date'/>", true);
                                reasonErrorStartDate = "endDateLessThanStartDate"
                                countErrorStartDate++;
                            }
                            if (endDate2 && startDate > endDate2 && reasonErrorEndDate2 != "endDate2LessThanStartDate") {
                                DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("startDate", true);
                                DynamicForm_Report_CourseWithOutTeacher.addFieldErrors("startDate", "<spring:message code='msg.equal.less.end.date'/>", true);
                                reasonErrorStartDate = "endDate2LessThanStartDate";
                                countErrorStartDate++;
                            }
                            if(countErrorStartDate == 0)
                                reasonErrorStartDate = "";
                        }
                    }
                    else {
                        DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("startDate", true);
                        reasonErrorStartDate = "";
                        if(reasonErrorStartDate2 == "startDate2LessThanStartDate"){
                            DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("startDate2", true);
                            reasonErrorStartDate2 = "";
                        }
                        if (reasonErrorEndDate == "endDateLessThanStartDate") {
                            DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("endDate", true);
                            reasonErrorEndDate = "";
                        }
                        if(reasonErrorEndDate2 == "endDate2LessThanStartDate"){
                            DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("endDate2", true);
                            reasonErrorEndDate2 = "";
                        }
                    }
                }
            },

            {
                name: "startDate2",
                // height: 35,
                //  width:"1%",
                //  titleColSpan: 1,
                title: "تا",
                titleAlign:"center",
                ID: "startDate2_jspReport",
                // required: true,
                hint: "YYYY/MM/DD",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                textAlign: "center",
                // colSpan: 2,
                // focus: function () {
                //     displayDatePicker('endDate_jspReport', this, 'ymd', '/');
                // },
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('startDate2_jspReport', this, 'ymd', '/');

                    }
                }],
                editorExit:function(){
                    let result=reformat(DynamicForm_Report_CourseWithOutTeacher.getValue("startDate2"));
                    if (result){
                        DynamicForm_Report_CourseWithOutTeacher.getItem("startDate2").setValue(result);
                    }
                },
                blur: function () {

                    let dateCheck;
                    if (DynamicForm_Report_CourseWithOutTeacher.getValue("startDate2")) {
                        dateCheck = checkDate(DynamicForm_Report_CourseWithOutTeacher.getValue("startDate2"));
                        let startDate2 = DynamicForm_Report_CourseWithOutTeacher.getValue("startDate2");
                        let startDate = DynamicForm_Report_CourseWithOutTeacher.getValue("startDate");
                        if (dateCheck == false) {
                            DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("startDate2", true);
                            DynamicForm_Report_CourseWithOutTeacher.addFieldErrors("startDate2", "<spring:message code='msg.correct.date'/>", true);
                        }
                        if (dateCheck == true) {
                            DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("startDate2", true);

                            let endDate = DynamicForm_Report_CourseWithOutTeacher.getValue("endDate");
                            let endDate2 = DynamicForm_Report_CourseWithOutTeacher.getValue("endDate2");

                            countErrorStartDate2 = 0;

                            if (startDate && startDate2 < startDate && reasonErrorStartDate != "startDate2LessThanStartDate") {
                                DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("startDate2", true);
                                DynamicForm_Report_CourseWithOutTeacher.addFieldErrors("startDate2", "<spring:message code='msg.equal.less.start.date'/>", true);
                                reasonErrorStartDate2 = "startDate2LessThanStartDate";
                                countErrorStartDate2++;
                            }
                            if (endDate && startDate2 > endDate && reasonErrorEndDate != "endDateLessThanStartDate2" ) {
                                DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("startDate2", true);
                                DynamicForm_Report_CourseWithOutTeacher.addFieldErrors("startDate2", "<spring:message code='msg.equal.less.end.date'/>", true);
                                reasonErrorStartDate2 = "endDateLessThanStartDate2"
                                countErrorStartDate2++;
                            }
                            if (endDate2 && startDate2 > endDate2 && reasonErrorEndDate2 != "endDate2LessThanStartDate2" ) {
                                DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("endDate2", true);
                                DynamicForm_Report_CourseWithOutTeacher.addFieldErrors("startDate2", "<spring:message code='msg.equal.less.end.date'/>", true);
                                reasonErrorStartDate2 = "endDate2LessThanStartDate2";
                                countErrorStartDate2++;
                            }
                            if(countErrorStartDate2 == 0)
                                reasonErrorStartDate2 = "";
                        }

                    }
                    else{
                        DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("startDate2", true);
                        reasonErrorStartDate2 = "";
                        if (reasonErrorStartDate == "startDate2LessThanStartDate") {
                            DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("startDate", true);
                            reasonErrorStartDate = "";
                        }
                        if (reasonErrorEndDate == "endDateLessThanStartDate2") {
                            DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("endDate", true);
                            reasonErrorEndDate = "";
                        }
                        if (reasonErrorEndDate2 == "endDate2LessThanStartDate2") {
                            DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("endDate2", true);
                            reasonErrorEndDate2 = "";
                        }
                    }
                }

            },
            {

                name: "endDate",
                //height: 35,
                // width:"5%",
                //   titleColSpan: 1,
                //   colSpan: 2,
                titleAlign:"center",
                title: "تاریخ پایان : از",
                ID: "endDate_jspReport",
                type: 'text',
                textAlign: "center",
                // required: true,
                hint: "YYYY/MM/DD",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                // focus: function () {
                //     displayDatePicker('startDate_jspReport', this, 'ymd', '/');
                // },
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('endDate_jspReport', this, 'ymd', '/');
                    }
                }],

                editorExit:function(){
                    let result=reformat(DynamicForm_Report_CourseWithOutTeacher.getValue("endDate"));
                    if (result){
                        DynamicForm_Report_CourseWithOutTeacher.getItem("endDate").setValue(result);
                    }
                },

                blur: function () {
                    let dateCheck;
                    if (DynamicForm_Report_CourseWithOutTeacher.getValue("endDate")) {
                        dateCheck = checkDate(DynamicForm_Report_CourseWithOutTeacher.getValue("endDate"));
                        if (dateCheck == false) {
                            DynamicForm_Report_CourseWithOutTeacher.addFieldErrors("endDate", "<spring:message code='msg.correct.date'/>", true);
                        }
                        if (dateCheck == true) {
                            DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("endDate", true);
                            let endDate = DynamicForm_Report_CourseWithOutTeacher.getValue("endDate");
                            let endDate2 = DynamicForm_Report_CourseWithOutTeacher.getValue("endDate2");
                            let startDate = DynamicForm_Report_CourseWithOutTeacher.getValue("startDate");
                            let startDate2 = DynamicForm_Report_CourseWithOutTeacher.getValue("startDate2");

                            countErrorEndDate = 0;
                            if (startDate &&  endDate < startDate &&  reasonErrorStartDate != "endDateLessThanStartDate") {
                                DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors(endDate);
                                DynamicForm_Report_CourseWithOutTeacher.addFieldErrors("endDate", "<spring:message code='msg.equal.less.start.date'/>", true);
                                reasonErrorEndDate = "endDateLessThanStartDate";
                                countErrorEndDate++;
                            }
                            if (startDate2 &&  endDate < startDate2 && reasonErrorStartDate2 != "endDateLessThanStartDate2") {
                                DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors(endDate);
                                DynamicForm_Report_CourseWithOutTeacher.addFieldErrors("endDate", "<spring:message code='msg.equal.less.start.date'/>", true);
                                reasonErrorEndDate = "endDateLessThanStartDate2";
                                countErrorEndDate++;
                            }
                            if (endDate2 &&   endDate > endDate2 && reasonErrorEndDate2 != "endDate2LessThanEndDate" ) {
                                DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors(endDate);
                                DynamicForm_Report_CourseWithOutTeacher.addFieldErrors("endDate", "<spring:message code='msg.equal.less.end.date'/>", true);
                                reasonErrorEndDate = "endDate2LessThanEndDate";
                                countErrorEndDate++;
                            }
                            if(countErrorEndDate == 0)
                                reasonErrorEndDate = "";
                        }
                    }else{
                        DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("endDate", true);
                        reasonErrorEndDate = "";
                        if (reasonErrorStartDate == "endDateLessThanStartDate") {
                            DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("startDate", true);
                            reasonErrorStartDate = "";
                        }
                        if (reasonErrorStartDate2 == "endDateLessThanStartDate2") {
                            DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("startDate2", true);
                            reasonErrorStartDate2 = "";
                        }
                        if (reasonErrorEndDate2 == "endDate2LessThanEndDate") {
                            DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("endDate2", true);
                            reasonErrorEndDate2 = "";
                        }
                    }
                }
            },

            {
                name: "endDate2",
                // height: 35,
                //  width:"5%",
                // titleColSpan: 1,
                title: "تا",
                titleAlign:"center",
                ID: "endDate2_jspReport",
                // required: true,
                hint: "YYYY/MM/DD",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                textAlign: "center",
                // colSpan: 2,
                // focus: function () {
                //     displayDatePicker('endDate_jspReport', this, 'ymd', '/');
                // },
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('endDate2_jspReport', this, 'ymd', '/');

                    }
                }],
                editorExit:function(){
                    let result=reformat(DynamicForm_Report_CourseWithOutTeacher.getValue("endDate2"));
                    if (result){
                        DynamicForm_Report_CourseWithOutTeacher.getItem("endDate2").setValue(result);
                    }
                },
                blur: function () {

                    let dateCheck;
                    if (DynamicForm_Report_CourseWithOutTeacher.getValue("endDate2")) {
                        dateCheck = checkDate(DynamicForm_Report_CourseWithOutTeacher.getValue("endDate2"));
                        let endDate2 = DynamicForm_Report_CourseWithOutTeacher.getValue("endDate2");
                        let endDate = DynamicForm_Report_CourseWithOutTeacher.getValue("endDate");
                        if (dateCheck == false) {
                            DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("endDate2", true);
                            DynamicForm_Report_CourseWithOutTeacher.addFieldErrors("endDate2", "<spring:message code='msg.correct.date'/>", true);
                        }
                        if (dateCheck == true) {

                            DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("endDate2", true);
                            countErrorEndDate2 = 0;

                            let startDate2 = DynamicForm_Report_CourseWithOutTeacher.getValue("startDate2");
                            let startDate = DynamicForm_Report_CourseWithOutTeacher.getValue("startDate");

                            if (startDate  && endDate2 < startDate && reasonErrorStartDate != "endDate2LessThanStartDate" ) {
                                DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("endDate2", true);
                                DynamicForm_Report_CourseWithOutTeacher.addFieldErrors("endDate2", "<spring:message code='msg.equal.less.start.date'/>", true);
                                reasonErrorEndDate2 = "endDate2LessThanStartDate";
                                countErrorEndDate2++;
                            }
                            if (startDate2  && endDate2 < startDate2 && reasonErrorStartDate2 != "endDate2LessThanStartDate2") {
                                DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("endDate2", true);
                                DynamicForm_Report_CourseWithOutTeacher.addFieldErrors("endDate2", "<spring:message code='msg.equal.less.start.date'/>", true);
                                reasonErrorEndDate2 = "endDate2LessThanStartDate2";
                                countErrorEndDate2++;
                            }
                            if (endDate &&  endDate2 < endDate && reasonErrorEndDate != "endDate2LessThanEndDate") {
                                DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("endDate2", true);
                                DynamicForm_Report_CourseWithOutTeacher.addFieldErrors("endDate2", "<spring:message code='msg.equal.less.end.date'/>", true);
                                reasonErrorEndDate2 = "endDate2LessThanEndDate";
                                countErrorEndDate2++;
                            }
                            if(countErrorEndDate2 ==0)
                                reasonErrorEndDate2 = "";
                        }
                    }else{
                        DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("endDate2", true);
                        reasonErrorEndDate2 = "";
                        if(reasonErrorStartDate == "endDate2LessThanStartDate")
                        {
                            DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("startDate", true);
                            reasonErrorStartDate = "";
                        }
                        if(reasonErrorStartDate2 == "endDate2LessThanStartDate2")
                        {
                            DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("startDate2", true);
                            reasonErrorStartDate2= "";
                        }
                        if(reasonErrorEndDate == "endDate2LessThanEndDate")
                        {
                            DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("endDate", true);
                            reasonErrorEndDate= "";
                        }
                    }
                }
            },


            {
                name: "tclassYears",
                title: "سال کاری",
                width:430,
                colSpan:4,
                textAlign:"center",
                titleAlign:"center",
                type: "SelectItem",
                multiple: true,
                optionDataSource: RestDataSource_Year_Filter_courseWithOutTeacher,
                valueField: "year",
                displayField: "year",
                filterFields: ["year"],
                filterLocally: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains",
                    gridComponents: [
                        isc.ToolStrip.create({
                            autoDraw: false,
                            height: 30,
                            width: "100%",
                            members: [
                                isc.ToolStripButton.create({
                                    width: "50%",
                                    icon: "[SKIN]/actions/approve.png",
                                    title: "انتخاب همه",
                                    click: function () {
                                        var item =DynamicForm_Report_CourseWithOutTeacher.getField("tclassYears"),
                                            fullData = item.pickList.data,
                                            cache = fullData.localData,
                                            values = [];

                                        for (var i = 0; i < cache.length; i++) {
                                            values[i] = cache[i].year;
                                        }
                                        item.setValue(values);
                                        item.pickList.hide();
                                        DynamicForm_Report_CourseWithOutTeacher.getField("termFilters").setDisabled(true)


                                    }
                                }),
                                isc.ToolStripButton.create({
                                    width: "50%",
                                    icon: "[SKIN]/actions/close.png",
                                    title: "حذف همه",
                                    click: function () {
                                        var item =DynamicForm_Report_CourseWithOutTeacher.getField("tclassYears");
                                        item.setValue([]);
                                        item.pickList.hide();
                                        //  DynamicForm_Report_CourseWithOutTeacher.getField("termFilters").setValue([]);
                                        // DynamicForm_Report_CourseWithOutTeacher.getField("termFilters").pickList.hide();
                                    }
                                })
                            ]
                        }),
                        "header", "body"
                    ]
                },
                changed: function (form, item, value) {
                    if (value != null && value != undefined && value.size() == 1) {
                        DynamicForm_Report_CourseWithOutTeacher.getField("termFilters").setValue([])
                        let criteria= '{"fieldName":"startDate","operator":"iStartsWith","value":"' + value[0] + '"}';
                        RestDataSource_Term_Filter.fetchDataURL = termUrl + "spec-list?operator=or&_constructor=AdvancedCriteria&criteria=" + criteria;
                        DynamicForm_Report_CourseWithOutTeacher.getField("termFilters").optionDataSource = RestDataSource_Term_Filter;
                        DynamicForm_Report_CourseWithOutTeacher.getField("termFilters").fetchData();
                        DynamicForm_Report_CourseWithOutTeacher.getField("termFilters").enable();
                    } else {
                        DynamicForm_Report_CourseWithOutTeacher.getField("termFilters").setDisabled(true)
                        DynamicForm_Report_CourseWithOutTeacher.getField("termFilters").setValue([])
                    }
                },
                icons:[
                    {
                        name: "clear",
                        src: "[SKIN]actions/remove.png",
                        width: 15,
                        height: 15,
                        inline: true,
                        prompt: "پاک کردن",
                        click : function (form, item, icon) {
                            item.clearValue();
                            item.focusInItem();
                            form.setValue(null);
                        }
                    }
                ],

            },

            {
                name: "termFilters",
                title: "<spring:message code='term'/>",
                width:430,
                colSpan:4,
                textAlign:"center",
                titleAlign:"center",
                endRow:false,
                startRow:true,
                disabled: true,
                textAlign: "center",
                type: "SelectItem",
                multiple: true,
                filterLocally: true,
                displayField: "code",
                valueField: "id",
                filterFields: ["code"],
                sortField: ["code"],
                sortDirection: "descending",
                defaultToFirstOption: true,
                useClientFiltering: true,
                filterEditorProperties: {
                    keyPressFilter: "[0-9]",
                },
                pickListFields: [
                    {
                        name: "code",
                        title: "<spring:message code='term.code'/>",
                        filterOperator: "iContains",
                        filterEditorProperties: {
                            keyPressFilter: "[0-9]"
                        }
                    },
                    {
                        name: "startDate",
                        title: "<spring:message code='start.date'/>",
                        filterOperator: "iContains",
                        filterEditorProperties: {
                            keyPressFilter: "[0-9/]"
                        }
                    },
                    {
                        name: "endDate",
                        title: "<spring:message code='end.date'/>",
                        filterOperator: "iContains",
                        filterEditorProperties: {
                            keyPressFilter: "[0-9/]"
                        }
                    }
                ],
                pickListProperties: {
                    gridComponents: [
                        isc.ToolStrip.create({
                            autoDraw: false,
                            height: 30,
                            width: "100%",
                            members: [
                                isc.ToolStripButton.create({
                                    width: "50%",
                                    icon: "[SKIN]/actions/approve.png",
                                    title: "انتخاب همه",
                                    click: function () {
                                        var item =    DynamicForm_Report_CourseWithOutTeacher.getField("termFilters"),
                                            fullData = item.pickList.data,
                                            cache = fullData.localData,
                                            values = [];

                                        for (var i = 0; i < cache.length; i++) {
                                            values[i] = cache[i].id;
                                        }
                                        item.setValue(values);
                                        item.pickList.hide();

                                    }
                                }),
                                isc.ToolStripButton.create({
                                    width: "50%",
                                    icon: "[SKIN]/actions/close.png",
                                    title: "حذف همه",
                                    click: function () {
                                        DynamicForm_Report_CourseWithOutTeacher.getField("termFilters").setValue([])
                                    }
                                })
                            ]
                        }),
                        "header", "body"
                    ]
                },
                changed: function (form, item, value) {
                    // load_classes_by_term(value);
                },
                dataArrived:function (startRow, endRow, data) {
                    //if(data.allRows[0].id !== undefined)
                    //  {
                    // DynamicForm_Term_Filter.getItem("termFilters").clearValue();
                    // DynamicForm_Term_Filter.getItem("termFilters").setValue(data.allRows[0].code);
                    // load_classes_by_term(data.allRows[0].id);
                    // }
                },
                icons:[
                    {
                        name: "clear",
                        src: "[SKIN]actions/remove.png",
                        width: 15,
                        height: 15,
                        inline: true,
                        prompt: "پاک کردن",
                        click : function (form, item, icon) {
                            item.clearValue();
                            // item.focusInItem();
                            item.setValue([])
                        }
                    }
                ],
            },

            {
                name: "teacherId",
                title: "مدرس",
                width:430,
                colSpan:4,
                textAlign:"center",
                titleAlign:"center",
                endRow:false,
                startRow:true,
                //type: "ComboBoxItem",
                type: "SelectItem",
                multiple: true,
                autoFetchData: false,
                optionDataSource:RestDataSource_Teacher_JspcourseWithOutClass,
                valueField: "id",
                displayField: "fullNameFa",
                filterFields: ["personality.firstNameFa", "personality.lastNameFa", "personality.nationalCode"],
                pickListFields: [
                    {name: "personality.firstNameFa", title: "نام"},
                    {name: "personality.lastNameFa", title: "نام خانوادگی"},
                    {name: "personality.nationalCode", title: "کد ملی"}],
                pickListProperties: {
                    showFilterEditor: true
                },
                icons:[
                    {
                        name: "clear",
                        src: "[SKIN]actions/remove.png",
                        width: 15,
                        height: 15,
                        inline: true,
                        prompt: "پاک کردن",
                        click : function (form, item, icon) {
                            item.clearValue();
                            item.focusInItem();
                            form.setValue(null);
                        }
                    }
                ],
            },

            {
                name: "courseId",
                title: "<spring:message code="course"/>",
                titleAlign:"center",
                width:430,
                colSpan:4,
                // operator: "inSet",
                textAlign:"center",
                titleAlign:"center",
                endRow:false,
                startRow:true,
                optionDataSource: RestDataSource_CourseDS,
                autoFetchData: false,
                type: "SelectItem",
                multiple: true,
                valueField: "id",
                displayField: ["code"],
                comboBoxWidth: 200,
                pickListProperties: {
                    showFilterEditor: true,
                },
                pickListFields: [
                    {name: "titleFa", title: "<spring:message code="title"/>"},
                    {name: "code", title: "<spring:message code="code"/>"}
                ],
                icons:[
                    {
                        name: "clear",
                        src: "[SKIN]actions/remove.png",
                        width: 15,
                        height: 15,
                        inline: true,
                        prompt: "پاک کردن",
                        click : function (form, item, icon) {
                            item.clearValue();
                            item.focusInItem();
                            form.setValue(null);
                        }
                    }
                ],
            },
        ]

    })

    var ToolStrip_ToolStrip_Personnel_Info_Training_Action = isc.ToolStrip.create({
        width: "30%",
        padding:16,
        members: [
            ToolStrip_Actions
        ]
    });

    var Hlayout__Personnel_Info_Training_body_CWOTR = isc.HLayout.create({
        height:"10%",
        top:20,
        members: [ToolStrip_ToolStrip_Personnel_Info_Training_Action]
    });


    var Hlayout_Reaport_body =  isc.VLayout.create({
        //width: "500px",
        height: "100%",
        members: [DynamicForm_Report_CourseWithOutTeacher, isc.HLayout.create({
            width: "500px",
            height: "55%",
            layoutAlign:"center",
            align:"center",
            members:[
                isc.IButton.create({
                    title: "تهیه گزارش",
                    width: "120px",
                    iconOrientation: "right",
                    titleAlign: "center",
                    click: function () {

                        if (!DynamicForm_Report_CourseWithOutTeacher.validate()) {
                            return;
                        }
                        if (reasonErrorStartDate != "" || reasonErrorStartDate2 != "" || reasonErrorEndDate != "" || reasonErrorEndDate2 != "") {
                            isc.Dialog.create({
                                message: "تاریخ های وارد شده برای ایجاد گزارش مناسب نیستند",
                                icon: "[SKIN]ask.png",
                                title: "<spring:message code='message'/>",
                                buttons: [isc.Button.create({title: "<spring:message code='ok'/>"})],
                                buttonClick: function (button, index) {
                                    this.close();
                                }
                            });
                            return;

                        }
                        criteria = DynamicForm_Report_CourseWithOutTeacher.getValuesAsAdvancedCriteria();
                        if (criteria == null || criteria.criteria.size() <= 0) {
                            isc.Dialog.create({
                                message: "<spring:message code='msg.no.filter.selected'/>",
                                icon: "[SKIN]ask.png",
                                title: "<spring:message code='message'/>",
                                buttons: [isc.Button.create({title: "<spring:message code='ok'/>"})],
                                buttonClick: function (button, index) {
                                    this.close();
                                }
                            });
                        } else {
                            //modalDialog = createDialog('wait');
                            List_Grid_Reaport_CourseWithOutTeacher.invalidateCache();
                            RestDataSource_CourseWithOutTeacher.fetchDataURL = courseUrl + "courseWithOutClass";
                            List_Grid_Reaport_CourseWithOutTeacher.fetchData({
                                _constructor: "AdvancedCriteria",
                                operator: "and",
                                criteria: criteria.criteria
                            });
                            ButtonExcel.setDisabled(false);
                        }
                    }
                })
            ]
        })]
        //, Hlayout__Personnel_Info_Training_body_CWOTR]
    })

    var Hlayout_Reaport_body1= isc.VLayout.create({
        width: "70%",
        height: "100%",
        border: "1px solid gray",
        members:[List_Grid_Reaport_CourseWithOutTeacher],
    })

    var Vlayout_Report_body = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [Hlayout_Reaport_body,Hlayout_Reaport_body1]
    })

    function Print(startDate,endDate) {
        var criteriaForm = isc.DynamicForm.create({
            method: "POST",
            action: "<spring:url value="/unjustified/unjustifiedabsence"/>" +"/"+startDate + "/" + endDate,
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "token", type: "hidden"}
                ]
        })
        criteriaForm.setValue("token", "<%= accessToken %>")
        criteriaForm.show();
        criteriaForm.submitForm();
    }

    function  PrintPreTest(startDate,endDate)
    {
        var criteriaForm = isc.DynamicForm.create({
            method: "POST",
            action: "<spring:url value="/preTestScoreReport/printPreTestScore"/>" +"/"+startDate + "/" + endDate,
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "token", type: "hidden"}
                ]
        })
        criteriaForm.setValue("token", "<%= accessToken %>")
        criteriaForm.show();
        criteriaForm.submitForm();
    }

    function load_term_by_year(value)
    {
        let criteria= '{"fieldName":"startDate","operator":"iStartsWith","value":"' + value + '"}';
        RestDataSource_Term_Filter.fetchDataURL = termUrl + "spec-list?operator=or&_constructor=AdvancedCriteria&criteria=" + criteria;
        DynamicForm_Report_CourseWithOutTeacher.getItem("termFilters").fetchData();
    }