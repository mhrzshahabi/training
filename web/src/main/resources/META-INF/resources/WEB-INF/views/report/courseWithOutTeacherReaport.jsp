<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>


    var endDateCheckReportCWOT = true;
    var modalDialog;

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
        fields: [{name: "id", primaryKey: true},
            {name: "code"},
            {name: "title"},
            {name: "max_start_date"},
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
            ExportToFile.exportToExcelFromClient(fields, data, '', "دوره های بدون کلاس")
         ;
        }
    })
    var ToolStrip_Actions = isc.ToolStrip.create({
        // width: "100%",
        members: [
            ButtonExcel,
            isc.LayoutSpacer.create({width: "*"}),
            isc.Label.create({
                ID: "totalsCount_Rows"
            }),]
    })
    var List_Grid_Reaport_CourseWithOutTeacher = isc.TrLG.create({
        width: "100%",
        height: "100%",
      dataSource: RestDataSource_CourseWithOutTeacher,
        showRowNumbers: true,
       //autoFetchData: true,

        fields: [
            {name: "code", title: "<spring:message code="code"/>", align: "center", filterOperator: "iContains",autoFitWidth:true},
            {name: "title", title:"<spring:message code="course"/>", align: "center", filterOperator: "iContains",autoFitWidth:true},
            {name: "max_start_date", title:"تاریخ شروع آخرین کلاس", align: "center", filterOperator: "iContains",autoFitWidth:true},

        ],
        recordDoubleClick: function () {

        },
            gridComponents: [ToolStrip_Actions,"filterEditor", "header", "body"],



        dataArrived: function ()
        {
            modalDialog.close();

            let totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown())
                totalsCount_Rows.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            else
                totalsCount_Rows.setContents("&nbsp;");
        },
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        useClientFiltering:true,
        filterOnKeypress: true,
        sortField: 0,
    });

    var DynamicForm_Report_CourseWithOutTeacher = isc.DynamicForm.create({
        width: "550px",
        height: "100%",
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
                        DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("startDate", true);
                    }
                },
                blur: function () {
                    var dateCheck;
                    dateCheck = checkDate(DynamicForm_Report_CourseWithOutTeacher.getValue("startDate"));
                    if (dateCheck == false)
                        DynamicForm_Report_CourseWithOutTeacher.addFieldErrors("startDate", "<spring:message code='msg.correct.date'/>", true);
                        endDateCheckReportCWOT = false;
                    if (dateCheck == true)
                        DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("startDate", true);
                        endDateCheckReportCWOT = true;
                    var endDate = DynamicForm_Report_CourseWithOutTeacher.getValue("endDate");
                    var startDate = DynamicForm_Report_CourseWithOutTeacher.getValue("startDate");
                    if (endDate != undefined && startDate > endDate) {
                        DynamicForm_Report_CourseWithOutTeacher.addFieldErrors("endDate", "<spring:message code='msg.date.order'/>", true);
                        DynamicForm_Report_CourseWithOutTeacher.getItem("endDate").setValue("");
                        endDateCheckReportCWOT = false;
                    }
                }
            },

                {
                name: "endDate",
               // height: 35,
                  //  width:"1%",
              //  titleColSpan: 1,
               title: "تا",
               titleAlign:"center",
                ID: "endDate_jspReport",
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
                        displayDatePicker('endDate_jspReport', this, 'ymd', '/');

                    }
                }],
                    editorExit:function(){
                        let result=reformat(DynamicForm_Report_CourseWithOutTeacher.getValue("endDate"));
                        if (result){
                            DynamicForm_Report_CourseWithOutTeacher.getItem("endDate").setValue(result);
                            DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("endDate", true);
                        }
                    },
                blur: function () {

                    var dateCheck;
                    dateCheck = checkDate(DynamicForm_Report_CourseWithOutTeacher.getValue("endDate"));
                    var endDate = DynamicForm_Report_CourseWithOutTeacher.getValue("endDate");
                    var startDate = DynamicForm_Report_CourseWithOutTeacher.getValue("startDate");
                    if (dateCheck == false) {
                        DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("endDate", true);
                        DynamicForm_Report_CourseWithOutTeacher.addFieldErrors("endDate", "<spring:message code='msg.correct.date'/>", true);
                        endDateCheckReportCWOT = false;
                    }
                    if (dateCheck == true) {
                        if (startDate == undefined)
                            DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("endDate", true);
                            DynamicForm_Report_CourseWithOutTeacher.addFieldErrors("startDate", "<spring:message code='msg.correct.date'/>", true);
                           endDateCheckReportCWOT = false;
                        if (startDate != undefined && startDate > endDate) {
                            DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("endDate", true);
                            DynamicForm_Report_CourseWithOutTeacher.addFieldErrors("endDate", "<spring:message code='msg.date.order'/>", true);
                            endDateCheckReportCWOT = false;
                        }
                        if (startDate != undefined && startDate < endDate) {
                            DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("endDate", true);
                            DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("startDate", true);
                            endDateCheckReportCWOT = true;
                        }
                    }
                }

            },
            {

                name: "startDate2",
                //height: 35,
               // width:"5%",
                //   titleColSpan: 1,
                //   colSpan: 2,
                titleAlign:"center",
                title: "تاریخ پایان : از",
                ID: "startDate2_jspReport",
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
                        displayDatePicker('startDate2_jspReport', this, 'ymd', '/');
                    }
                }],

                editorExit:function(){
                    let result=reformat(DynamicForm_Report_CourseWithOutTeacher.getValue("startDate2"));
                    if (result){
                        DynamicForm_Report_CourseWithOutTeacher.getItem("startDate2").setValue(result);
                        DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("startDate2", true);
                    }
                },

                blur: function () {
                    var dateCheck;
                    dateCheck = checkDate(DynamicForm_Report_CourseWithOutTeacher.getValue("startDate2"));
                    if (dateCheck == false)
                        DynamicForm_Report_CourseWithOutTeacher.addFieldErrors("startDate2", "<spring:message code='msg.correct.date'/>", true);
                    endDateCheckReportCWOT = false;
                    if (dateCheck == true)
                        DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("startDate2", true);
                    endDateCheckReportCWOT = true;
                    var endDate = DynamicForm_Report_CourseWithOutTeacher.getValue("endDate2");
                    var startDate = DynamicForm_Report_CourseWithOutTeacher.getValue("startDate2");
                    if (endDate != undefined && startDate > endDate) {
                        DynamicForm_Report_CourseWithOutTeacher.addFieldErrors("endDate2", "<spring:message code='msg.date.order'/>", true);
                        DynamicForm_Report_CourseWithOutTeacher.getItem("endDate2").setValue("");
                        endDateCheckReportCWOT = false;
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
                        DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("endDate2", true);
                    }
                },
                blur: function () {

                    var dateCheck;
                    dateCheck = checkDate(DynamicForm_Report_CourseWithOutTeacher.getValue("endDate2"));
                    var endDate = DynamicForm_Report_CourseWithOutTeacher.getValue("endDate2");
                    var startDate = DynamicForm_Report_CourseWithOutTeacher.getValue("startDate2");
                    if (dateCheck == false) {
                        DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("endDate2", true);
                        DynamicForm_Report_CourseWithOutTeacher.addFieldErrors("endDate2", "<spring:message code='msg.correct.date'/>", true);
                        endDateCheckReportCWOT = false;
                    }
                    if (dateCheck == true) {
                        if (startDate == undefined)
                            DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("endDate2", true);
                        DynamicForm_Report_CourseWithOutTeacher.addFieldErrors("startDate2", "<spring:message code='msg.correct.date'/>", true);
                        endDateCheckReportCWOT = false;
                        if (startDate != undefined && startDate > endDate) {
                            DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("endDate2", true);
                            DynamicForm_Report_CourseWithOutTeacher.addFieldErrors("endDate2", "<spring:message code='msg.date.order'/>", true);
                            endDateCheckReportCWOT = false;
                        }
                        if (startDate != undefined && startDate < endDate) {
                            DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("endDate2", true);
                            DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("startDate2", true);
                            endDateCheckReportCWOT = true;
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
                    console.log(value.size())
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

            {type: "SpacerItem"},
            {type: "SpacerItem",colSpan:3},
            {type: "SpacerItem"},
                   {
                type: "button",
                title: "تهیه گزارش",
                 width:418,
                 colSpan:3,
                // align:"left",
                 titleAlign:"center",
                 endRow:false,
                startRow: false,
                click:function () {


                    if (endDateCheckReportCWOT == false)
                        return;

                    if (!DynamicForm_Report_CourseWithOutTeacher.validate()) {
                        return;
                    }
                    modalDialog=createDialog('wait');
                    let strSData =(!DynamicForm_Report_CourseWithOutTeacher.getItem("startDate").getValue() ? '13000101' : DynamicForm_Report_CourseWithOutTeacher.getItem("startDate").getValue().replace(/(\/)/g, ""));
                    let strEData =(!DynamicForm_Report_CourseWithOutTeacher.getItem("endDate").getValue() ? '19000101' : DynamicForm_Report_CourseWithOutTeacher.getItem("endDate").getValue().replace(/(\/)/g, ""));
                    let strSData2 =(!DynamicForm_Report_CourseWithOutTeacher.getItem("startDate2").getValue() ? '13000101': DynamicForm_Report_CourseWithOutTeacher.getItem("startDate2").getValue().replace(/(\/)/g, ""));
                    let strEData2 =(!DynamicForm_Report_CourseWithOutTeacher.getItem("endDate2").getValue() ? '19000101' : DynamicForm_Report_CourseWithOutTeacher.getItem("endDate2").getValue().replace(/(\/)/g, ""));
                    let Years = (!DynamicForm_Report_CourseWithOutTeacher.getField("tclassYears").getValue()  ?  "" : DynamicForm_Report_CourseWithOutTeacher.getField("tclassYears").getValue()) ;
                    let termId =(!DynamicForm_Report_CourseWithOutTeacher.getField("termFilters").getValue()  ?  "" : DynamicForm_Report_CourseWithOutTeacher.getField("termFilters").getValue());
                    let courseId =(!DynamicForm_Report_CourseWithOutTeacher.getField("courseId").getValue()  ?  "" : DynamicForm_Report_CourseWithOutTeacher.getField("courseId").getValue());
                    let teacherId =(!DynamicForm_Report_CourseWithOutTeacher.getField("teacherId").getValue()  ?  "" : DynamicForm_Report_CourseWithOutTeacher.getField("teacherId").getValue());
                    RestDataSource_CourseWithOutTeacher.fetchDataURL=courseUrl + "courseWithOutTeacher"+"/"+strSData + "/" + strEData +"?strSData2=" +strSData2  +"&strEData2=" +strEData2 +"&Years=" +Years +"&termId=" +termId + "&courseId=" +courseId+ "&teacherId="+teacherId;
                    List_Grid_Reaport_CourseWithOutTeacher.invalidateCache();
                    List_Grid_Reaport_CourseWithOutTeacher.fetchData();
                }
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
        width: "500px",
        height: "100%",
        members: [DynamicForm_Report_CourseWithOutTeacher]
        //, Hlayout__Personnel_Info_Training_body_CWOTR]
    })

    var Hlayout_Reaport_body1= isc.VLayout.create({
        width: "50%",
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