<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>
    // for (var i = 0; i <document.getElementsByTagName("div").length ; i++) {
    //     document.getElementsByTagName("div")[i].style.borderRadius = "10px";
    // }


    var classMethod = "POST";
    var classWait;
    var str1 = "";
    var str2 = "";
    var str3 = "";
    var class_userCartableId;
    var startDateCheck = true;
    var endDateCheck = true;
    var selectedClassId = null;
    //--------------------------------------------------------------------------------------------------------------------//
    /*Rest Data Sources*/
    //--------------------------------------------------------------------------------------------------------------------//

    var RestDataSource_Class_JspClass = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "group"},
            {name: "startDate"},
            {name: "endDate"},
            {name: "code"},
            {name: "duration"},
            {name: "teacher.personality.lastNameFa"},
            {name: "course.code"},
            {name: "course.titleFa"}
        ],
        fetchDataURL: classUrl + "spec-list"
    });

    var RestDataSource_Teacher_JspClass = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "personality"},
            {name: "personality.lastNameFa"}
        ],
        // fetchDataURL: teacherUrl + "fullName-list?_startRow=0&_endRow=55"
        fetchDataURL: teacherUrl + "fullName-list"
    });

    var RestDataSource_Course_JspClass = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code", title:"کد دوره"},
            {name: "titleFa", title:"نام دوره"},
            {name: "theoryDuration"},
        ],
        fetchDataURL: courseUrl + "spec-list?_startRow=0&_endRow=55"

    });

    // var RestDataSource_Course_JspClass_workFlow = isc.TrDS.create({
    //     fields: [
    //         {name: "id", primaryKey: true},
    //         {name: "code"},
    //         {name: "titleFa"},
    //         {name: "theoryDuration"}
    //     ],
    //
    //   });


    var RestDataSource_Class_Student_JspClass = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "personality.lastNameFa"},
            {name: "studentID"}
        ],
        fetchDataURL: classUrl + "otherStudent"
    });

    var RestDataSource_Class_CurrentStudent_JspClass = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "personality.lastNameFa"},
            {name: "studentID"}
        ],
        fetchDataURL: classUrl + "student"
    });

    var RestDataSource_Term_JspClass = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "startDate"},
            {name: "endDate"}
        ],
        fetchDataURL: termUrl + "spec-list?_startRow=0&_endRow=55"
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Menu*/
    //--------------------------------------------------------------------------------------------------------------------//

    var Menu_ListGrid_Class_JspClass = isc.Menu.create({
        // width: 150,
        data: [{
            title: "<spring:message code='refresh'/>", icon: "<spring:url value="refresh.png"/>", click: function () {
                ListGrid_Class_refresh();
            }
        }, {
            title: "<spring:message code='create'/>", icon: "<spring:url value="create.png"/>", click: function () {
                ListGrid_Class_add();
            }
        }, {
            title: "<spring:message code='edit'/>", icon: "<spring:url value="edit.png"/>", click: function () {
                ListGrid_class_edit();
            }
        }, {
            title: "<spring:message code='remove'/>", icon: "<spring:url value="remove.png"/>",
            click: function () {
                ListGrid_class_remove();
            }
        }, {isSeparator: true}, {
            title: "<spring:message code='print.pdf'/>", icon: "<spring:url value="pdf.png"/>", click: function () {
                ListGrid_class_print("pdf");
            }
        }, {
            title: "<spring:message code='print.excel'/>", icon: "<spring:url value="excel.png"/>", click: function () {
                ListGrid_class_print("excel");
            }
        }, {
            title: "<spring:message code='print.html'/>", icon: "<spring:url value="html.png"/>", click: function () {
                ListGrid_class_print("html");
            }
        },
            {isSeparator: true}, {
                title: "<spring:message code='students.list'/>", icon: "icon/classroom.png", click: function () {
                    Add_Student();
                }
            }
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*ListGrid*/
    //--------------------------------------------------------------------------------------------------------------------//

    var ListGrid_Class_JspClass = isc.TrLG.create({
        width: "100%",
        height: "100%",
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        selectionType: "single",
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>",
        dataSource: RestDataSource_Class_JspClass,
        contextMenu: Menu_ListGrid_Class_JspClass,
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "code", title: "<spring:message code='class.code'/>", align: "center", filterOperator: "equals"},
            {
                name: "course.code",
                title: "<spring:message code='course.code'/>",
                align: "center",
                filterOperator: "equals",
                sortNormalizer: function (record) {
                    return record.course.code;
                }
            },
            {
                name: "course.titleFa",
                title: "<spring:message code='course.title'/>",
                align: "center",
                filterOperator: "iContains",
                sortNormalizer: function (record) {
                    return record.course.titleFa;
                }
            },
            {name: "duration", title: "<spring:message code='duration'/>", align: "center", filterOperator: "equals"},
            {
                name: "startDate",
                title: "<spring:message code='start.date'/>",
                align: "center",
                filterOperator: "iContains"
            },
            {name: "endDate", title: "<spring:message code='end.date'/>", align: "center", filterOperator: "contains"},
            {name: "group", title: "<spring:message code='group'/>", align: "center", filterOperator: "equals"},
            {
                name: "teacher.personality.lastNameFa",
                title: "<spring:message code='trainer'/>",
                align: "center",
                filterOperator: "iContains",
                sortNormalizer: function (record) {
                    return record.teacher.personality.lastNameFa;
                }
            },
             {name: "information", title: "اطلاعات تکمیلی", align: "center"}

        ],
        selectionUpdated: function(record){
            if(record === null)
                return;
            selectedClassId=record.id;
            changeSelectedId(record);
        },
        dataArrived: function () {
                if (class_userCartableId != null) {
                var responseID = class_userCartableId;
                 class_userCartableId = null;
                var gridState = "[{id:" + responseID + "}]";
                ListGrid_Class_JspClass.setSelectedState(gridState);
                var record = ListGrid_Class_JspClass.getSelectedRecord();
                 classMethod = "PUT";
               // classUrl = classUrl + record.id;
                Window_Class_JspClass.show();
                DynamicForm_Class_JspClass.clearValues();
                DynamicForm_Class_JspClass.editRecord(record);
                DynamicForm_Class_JspClass.getItem("course.titleFa").setValue(DynamicForm_Class_JspClass.getItem("courseId").getSelectedRecord().titleFa);
            }
        },
        createRecordComponent: function (record, colNum) {
            var fieldName = this.getFieldName(colNum);
            if (fieldName === "information") {
                var recordCanvas = isc.HLayout.create({
                    height: 20,
                    width: "100%",
                    layoutMargin: 5,
                    membersMargin: 10,
                    align: "center"
                });
                var checkIcon = isc.ImgButton.create({
                    showDown: false,
                    showRollOver: false,
                    layoutAlign: "center",
                    src: "<spring:url value='info.png'/>",
                    height: 16,
                    width: 16,
                    grid: this,
                    click: function () {
                    pane: isc.ViewLoader.create(
                    {viewURL: "tclass/checkList-tab"}
                      )
                     alert("sdfgsdfgsdfg")
                    //     var activePostGradeGroup = ListGrid_Class_JspClass.getSelectedRecord();
                    //     var postGradeIds = [record.id];
                    //     isc.RPCManager.sendRequest(TrDSRequest(postGradeGroupUrl + "removePostGrades/" + activePostGradeGroup.id + "/" + postGradeIds,
                    //         "DELETE", null, "callback: postGrade_remove_result(rpcResponse)"));
                    }
                });
                recordCanvas.addMember(checkIcon);
                return recordCanvas;
            } else
                return null;
        },
         doubleClick: function () {
            ListGrid_class_edit();
        },

    });

    var VM_JspClass = isc.ValuesManager.create({

    })

    //--------------------------------------------------------------------------------------------------------------------//
    /*DynamicForm Add Or Edit*/
    //--------------------------------------------------------------------------------------------------------------------//

    var DynamicForm_Class_JspClass = isc.DynamicForm.create({
        // width: "700",
        height: "100%",
        isGroup: true,
        groupTitle: "اطلاعات پایه",
        groupBorderCSS: "1px solid lightBlue",
        borderRadius:"6px",
        numCols: 8,
        colWidths:["6%","24%","6%","12%","12%","6%","12%","12%"],
        padding: 10,
        align: "center",
        valuesManager: "VM_JspClass",
      /*  margin: 50,

        canTabToIcons: false,*/
        fields: [
            {name: "id", hidden: true},
            <%--{--%>
                <%--name: "course.titleFa",--%>
                <%--title: "<spring:message code='course.title'/>",--%>
                <%--disabled: true--%>
            <%--},--%>
            <%--{--%>
                <%--name: "code",--%>
                <%--title: "<spring:message code='class.code'/>",--%>
                <%--disabled: true--%>
            <%--},--%>
            <%--{--%>
                <%--name: "courseId",--%>
                <%--title: "<spring:message code='course.code'/>",--%>
                <%--textAlign: "center",--%>
                <%--required: true,--%>
                <%--editorType: "ComboBoxItem",--%>
                <%--// pickListWidth: 230,--%>
                <%--displayField: "code",--%>
                <%--valueField: "id",--%>
                <%--optionDataSource: RestDataSource_Course_JspClass,--%>
                <%--autoFetchData: true,--%>
                <%--cachePickListResults: true,--%>
                <%--useClientFiltering: true,--%>
                <%--filterFields: ["titleFa"],--%>
                <%--sortField: ["id"],--%>
                <%--textMatchStyle: "startsWith",--%>
                <%--generateExactMatchCriteria: true,--%>
                <%--pickListFields: [--%>
                    <%--{--%>
                        <%--name: "code",--%>
                        <%--title: "<spring:message code='course.code'/>",--%>
                        <%--width: "70%",--%>
                        <%--filterOperator: "iContains"--%>
                    <%--},--%>
                    <%--{--%>
                        <%--name: "titleFa",--%>
                        <%--title: "<spring:message code='course.title'/>",--%>
                        <%--width: "70%",--%>
                        <%--filterOperator: "iContains"--%>
                    <%--}--%>
                <%--],--%>
                <%--changed: function (form) {--%>
                    <%--(form.getItem("course.titleFa")).setValue(form.getItem("courseId").getSelectedRecord().titleFa);--%>
                    <%--(form.getItem("duration")).setValue(form.getItem("courseId").getSelectedRecord().theoryDuration);--%>
                <%--}--%>
            <%--},--%>
            {
                name:"course.id", editorType:"TrComboAutoRefresh", title:"دوره:",
                // width:"250",
                align:"center",
                optionDataSource:RestDataSource_Course_JspClass,
                // addUnknownValues:false,
                displayField:"titleFa", valueField:"id",
                filterFields:["titleFa", "code"],
                // pickListPlacement: "fillScreen",
                // pickListWidth:300,
                pickListFields:[
                    {name:"code"},
                    {name:"titleFa"}
                ]
            },
            {
                name:"minCapacity",
                title:"ظرفیت:",
                hint:"حداقل",
                showHintInField: true
            },
            {
                name:"maxCapacity",
                showTitle:false,
                hint:"حداکثر",
                showHintInField: true
            },
            {
                name:"code",
                title:"کد کلاس:",
                colSpan:2,
                type:"staticText",textBoxStyle:"textItemLite"
            },
            {
                name:"titleClass",
                title:"عنوان کلاس:",
                // type:"staticText",
                // textBoxStyle:"textItemLite"
            },
            {
                name:"teachingType",
                colSpan:2,
                title:"روش آموزش:",
                type:"radioGroup",
                vertical:false,
                fillHorizontalSpace:true,
                defaultValue:1,
                valueMap: {
                    "1":"حضوری",
                    "2":"غیر حضوری",
                    "3":"مجازی"
                }
                // textBoxStyle:"textItemLite"
            },
            {
                name:"hDuration",
                title:"مدت:",
                hint:"ساعت",
                showHintInField: true
            },
            {
                name:"dDuration",
                showTitle:false,
                hint:"روز",
                showHintInField: true
            },
            {
                // name: "teacher.personality.id",
                name: "teacherSet",
                // multipleAppearance: "picklist",
                // colSpan:2,
                title: "<spring:message code='trainer'/>:",
                textAlign: "center",
                editorType: "select",
                multiple: true,
                // pickListWidth: 230,
                // changeOnKeypress: true,
                displayField: "fullNameFa",
                valueField: "id",
                required: true,
                optionDataSource: RestDataSource_Teacher_JspClass,
                // cachePickListResults: false,
                // filterFields: ["personality.lastNameFa"],
                // textMatchStyle: "startsWith",
                // generateExactMatchCriteria: true,
                // addUnknownValues: false,
                // pickListFields:
                //     [{name: "personality.lastNameFa", filterOperator: "iContains"}]
                pickListFields:[
                    {name:"personality.lastNameFa",title:"نام خانوادگی", titleAlign:"center"},
                    {name:"personality.firstNameFa",title:"نام", titleAlign:"center"},
                    {name:"personality.nationalCode",title:"کد ملی", titleAlign:"center"}
                ],
                filterFields:[
                    {name:"personality.lastNameFa"},
                    {name:"personality.firstNameFa"},
                    {name:"personality.nationalCode"}
                ]
            },
            {
                name:"supervisor",
                colSpan:2,
                title:"مسئول اجرا:",
                type:"selectItem",
                valueMap: {
                    1:"آقای دکتر سعیدی",
                    2:"خانم شاکری",
                    3:"خانم اسماعیلی",
                    4:"خانم احمدی",
                }
                // textBoxStyle:"textItemLite"
            },
            {
                name:"reason",
                colSpan:2,
                title:"علت برگزاری:",
                // type:"selectItem",
                // valueMap: {
                //     1:"آقای دکتر سعیدی",
                //     2:"خانم شاکری",
                //     3:"خانم اسماعیلی",
                //     4:"خانم احمدی",
                // }
                // textBoxStyle:"textItemLite"
            },
            {
                name:"classStatus",
                // colSpan:2,
                rowSpan:2,
                title:"وضعیت کلاس:",
                type:"radioGroup",
                // vertical:false,
                fillHorizontalSpace:true,
                defaultValue:1,
                startRow:true,
                valueMap: {
                    "1":"برنامه ریزی",
                    "2":"در حال اجرا",
                    "3":"پایان یافته"
                }
                // textBoxStyle:"textItemLite"
            },
            {
                name:"instituteId", editorType:"TrComboAutoRefresh", title:"برگزار کننده:",
                // width:"250",
                colSpan:2,
                align:"center",
                // optionDataSource:RestDataSource_Institute_JspClass,
                // addUnknownValues:false,
                displayField:"titleFa", valueField:"id",
                filterFields:["titleFa", "code"],
                // pickListPlacement: "fillScreen",
                // pickListWidth:300,
                pickListFields:[
                    {name:"code"},
                    {name:"titleFa"}
                ],
                // startRow:true,
            },
            {
                name:"topology",
                colSpan:2,
                // rowSpan:2,
                title:"چیدمان:",
                type:"radioGroup",
                vertical:false,
                fillHorizontalSpace:true,
                defaultValue:1,
                valueMap: {
                    "1":"U شکل",
                    "2":"عادی",
                    "3":"مدور"
                }
                // textBoxStyle:"textItemLite"
            },
            {
                name:"trainingPlaceSet", editorType:"TrComboAutoRefresh", title:"محل برگزاری:",
                colSpan:2,
                // width:"250",
                align:"center",
                // optionDataSource:RestDataSource_Institute_JspClass,
                // addUnknownValues:false,
                displayField:"titleFa", valueField:"id",
                filterFields:["titleFa", "code"],
                // pickListPlacement: "fillScreen",
                // pickListWidth:300,
                pickListFields:[
                    {name:"code"},
                    {name:"titleFa"}
                ]
            },
            {
                name:"group",
                title:"گروه:",
                colSpan:2,
                type:"staticText",textBoxStyle:"textItemLite"
            },
// {name: },
            <%--{--%>
                <%--name: "duration",--%>
                <%--title: "<spring:message code='duration'/>",--%>
                <%--keyPressFilter: "[0-9]",--%>
                <%--length: "4",--%>
                <%--validators: [{--%>
                    <%--type: "isInteger", validateOnExit: true, stopOnError: true,--%>
                    <%--errorMessage: "<spring:message code='msg.number.type'/>"--%>
                <%--}]--%>
            <%--},--%>
            <%--{--%>
                <%--name: "group",--%>
                <%--title: "<spring:message code='group'/>",--%>
                <%--required: true,--%>
                <%--keyPressFilter: "[0-9]",--%>
                <%--length: "4",--%>
                <%--validators: [{--%>
                    <%--type: "isInteger", validateOnExit: true, stopOnError: true,--%>
                    <%--errorMessage: "<spring:message code='msg.number.type'/>"--%>
                <%--}]--%>
            <%--},--%>

        ],
        itemChanged: function (item) {
            if (item.name === "courseId" || item.name === "termId" || item.name === "group") {
                if (DynamicForm_Class_JspClass.getItem("courseId").getSelectedRecord() !== undefined)
                    str1 = DynamicForm_Class_JspClass.getItem("courseId").getSelectedRecord().code;
                if (DynamicForm_Class_JspClass.getItem("termId").getSelectedRecord() !== undefined)
                    str2 = DynamicForm_Class_JspClass.getItem("termId").getSelectedRecord().code;
                if (DynamicForm_Class_JspClass.getItem("group").getValue() !== undefined)
                    str3 = DynamicForm_Class_JspClass.getItem("group").getValue();
                var code_value = str1 + "/" + str2 + "/" + str3;
                DynamicForm_Class_JspClass.getItem("code").setValue(code_value);
            }
        }
    });
    var DynamicForm1_Class_JspClass = isc.DynamicForm.create({
        // width: "700",
        height: "100%",
        isGroup: true,
        groupTitle: "اطلاعات پایه",
        groupBorderCSS: "1px solid lightBlue",
        borderRadius:"6px",
        numCols: 14,
        colWidths:["7%","7%","7%","7%","7%","7%","7%","7%","7%","7%","7%","7%","7%","7%"],
        padding: 10,
        align: "center",
        valuesManager: "VM_JspClass",
        /*  margin: 50,

          canTabToIcons: false,*/
        fields: [
            {
                name: "termId",
                titleColSpan:1,
                title: "<spring:message code='term'/>",
                textAlign: "center",
                required: true,
                editorType: "ComboBoxItem",
                displayField: "code",
                valueField: "id",
                optionDataSource: RestDataSource_Term_JspClass,
                autoFetchData: true,
                cachePickListResults: true,
                useClientFiltering: true,
                filterFields: ["code"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                colSpan: 3,
                endRow:true,
                pickListFields: [
                    {
                        name: "code",
                        title: "<spring:message code='term.code'/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "startDate",
                        title: "<spring:message code='start.date'/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "endDate",
                        title: "<spring:message code='end.date'/>",
                        filterOperator: "iContains"
                    }
                ]
            },
            {
                name: "startDate",
                titleColSpan:1,

                title: "<spring:message code='start.date'/>",
                ID: "startDate_jspClass",
                required: true,
                hint: "YYYY/MM/DD",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('startDate_jspClass', this, 'ymd', '/');
                    }
                }],
                colSpan: 3,
                changed: function () {
                    var dateCheck;
                    dateCheck = checkDate(DynamicForm_Class_JspClass.getValue("startDate"));
                    startDateCheck = dateCheck;
                    if (dateCheck === false)
                        DynamicForm_Class_JspClass.addFieldErrors("startDate", "<spring:message code='msg.correct.date'/>", true);
                    if (dateCheck === true)
                        DynamicForm_Class_JspClass.clearFieldErrors("startDate", true);
                }
            },
            {
                name:"teachingBrand",
                title:"نحوه آموزش:",
                type:"radioGroup",
                // vertical:false,
                rowSpan:2,
                fillHorizontalSpace:true,
                defaultValue:1,
                endRow:true,
                valueMap: {
                    1:"تمام وقت",
                    2:"نیمه وقت",
                    3:"پاره وقت"
                }
                // textBoxStyle:"textItemLite"
            },
            {
                name: "endDate",
                titleColSpan:1,

                title: "<spring:message code='end.date'/>",
                ID: "endDate_jspClass",
                type: 'text', required: true,
                hint: "YYYY/MM/DD",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('endDate_jspClass', this, 'ymd', '/');
                    }
                }],
                colSpan: 3,
                changed: function () {
                    var dateCheck;
                    dateCheck = checkDate(DynamicForm_Class_JspClass.getValue("endDate"));
                    var endDate = DynamicForm_Class_JspClass.getValue("endDate");
                    var startDate = DynamicForm_Class_JspClass.getValue("startDate");
                    if (dateCheck === false) {
                        DynamicForm_Class_JspClass.clearFieldErrors("endDate", true);
                        DynamicForm_Class_JspClass.addFieldErrors("endDate", "<spring:message code='msg.correct.date'/>", true);
                        endDateCheck = false;
                    }
                    if (dateCheck === true) {
                        if (startDate === undefined)
                            DynamicForm_Class_JspClass.clearFieldErrors("endDate", true);
                        if (startDate !== undefined && startDate > endDate) {
                            DynamicForm_Class_JspClass.clearFieldErrors("endDate", true);
                            DynamicForm_Class_JspClass.addFieldErrors("endDate", "<spring:message code='msg.date.order'/>", true);
                            endDateCheck = false;
                        }
                        if (startDate !== undefined && startDate < endDate) {
                            DynamicForm_Class_JspClass.clearFieldErrors("endDate", true);
                            endDateCheck = true;
                        }
                    }
                }
            },
            {
                type:"BlurbItem",
                value:"روزهای هفته:",
            },
            {name: "saturday", type:"checkbox", title:"شنبه", titleOrientation:"top", labelAsTitle :true},
            {name: "sunday", type:"checkbox", title:"یکشنبه", titleOrientation:"top", labelAsTitle :true},
            {name: "monday", type:"checkbox", title:"دوشنبه", titleOrientation:"top", labelAsTitle :true},
            {name: "tuesday", type:"checkbox", title:"سه&#8202شنبه", titleOrientation:"top", labelAsTitle :true},
            {name: "wednesday", type:"checkbox", title:"چهارشنبه", titleOrientation:"top", labelAsTitle :true},
            {name: "thursday", type:"checkbox", title:"پنجشنبه", titleOrientation:"top", labelAsTitle :true},
            {name: "friday", type:"checkbox", title:"جمعه", titleOrientation:"top", labelAsTitle :true},
        ],
        itemChanged: function (item) {
            // if (item.name === "courseId" || item.name === "termId" || item.name === "group") {
            //     if (DynamicForm_Class_JspClass.getItem("courseId").getSelectedRecord() !== undefined)
            //         str1 = DynamicForm_Class_JspClass.getItem("courseId").getSelectedRecord().code;
            //     if (DynamicForm_Class_JspClass.getItem("termId").getSelectedRecord() !== undefined)
            //         str2 = DynamicForm_Class_JspClass.getItem("termId").getSelectedRecord().code;
            //     if (DynamicForm_Class_JspClass.getItem("group").getValue() !== undefined)
            //         str3 = DynamicForm_Class_JspClass.getItem("group").getValue();
            //     var code_value = str1 + "/" + str2 + "/" + str3;
            //     DynamicForm_Class_JspClass.getItem("code").setValue(code_value);
            // }
        }
    });

    var IButton_Class_Exit_JspClass = isc.TrCancelBtn.create({
        icon: "<spring:url value="remove.png"/>",
        align: "center",
        click: function () {
            Window_Class_JspClass.close();
        }
    });

    var IButton_Class_Save_JspClass = isc.TrSaveBtn.create({
        align: "center",
        click: function () {

            if (startDateCheck === false || endDateCheck === false)
                return;
            VM_JspClass.validate();
            if (VM_JspClass.hasErrors()) {
                return;
            }

            var data = VM_JspClass.getValues();
            data.courseId = data.course.id;

            var classSaveUrl = classUrl;
            if (classMethod.localeCompare("PUT") === 0) {
                var classRecord = ListGrid_Class_JspClass.getSelectedRecord();
                classSaveUrl += classRecord.id;
            }

           isc.RPCManager.sendRequest(TrDSRequest(classSaveUrl, classMethod, JSON.stringify(data), "callback: class_action_result(rpcResponse)"));
        }
    });

    var HLayOut_ClassSaveOrExit_JspClass = isc.TrHLayoutButtons.create({
        members: [IButton_Class_Save_JspClass, IButton_Class_Exit_JspClass]
    });

    var VLayOut_FormClass_JspClass = isc.TrVLayout.create({
        margin:10,
        members:[DynamicForm_Class_JspClass,DynamicForm1_Class_JspClass]
    });

    var Window_Class_JspClass = isc.Window.create({
        title: "<spring:message code='class'/>",
        width: "90%",
        autoSize:false,
        height: "70%",
        keepInParentRect:true,
        // placement:"fillPanel",
        align: "center",
        border: "1px solid gray",
        show:function(){
            this.Super("show",arguments);
            for (let i = 0; i < document.getElementsByClassName("textItemLiteRTL").length; i++) {
                document.getElementsByClassName("textItemLiteRTL")[i].style.borderRadius = "10px";
            };
            for (let j = 0; j < document.getElementsByClassName("selectItemLiteControlRTL").length; j++) {
                document.getElementsByClassName("selectItemLiteControlRTL")[j].style.borderRadius = "10px";
            };
            for (let c = 0; c < document.getElementsByClassName("formCellDisabledRTL").length; c++) {
                document.getElementsByClassName("formCellDisabledRTL")[c].style.borderRadius = "10px";
            };
        },
        closeClick: function () {
            this.Super("closeClick", arguments);
        },
        items: [isc.TrVLayout.create({
            members: [VLayOut_FormClass_JspClass, HLayOut_ClassSaveOrExit_JspClass]
        })]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Add Student Section*/
    //--------------------------------------------------------------------------------------------------------------------//

    var DynamicForm_ClassStudentHeaderGridHeader_JspClass = isc.DynamicForm.create({
        titleWidth: 400,
        width: 700,
        align: "right",
        fields: [
            {name: "id", type: "hidden", title: ""},
            {
                name: "course.titleFa",
                type: "staticText",
                title: "<spring:message code='course.title'/>",
                wrapTitle: false,
                width: 250
            },
            {
                name: "group",
                type: "staticText",
                title: "<spring:message code='group'/>",
                wrapTitle: false,
                width: 250
            }
        ]
    });

    var ListGrid_All_Students_JspClass = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        canAcceptDroppedRecords: true,
        canReorderRecords: true,
        dragTrackerMode: "none",
        dataSource: RestDataSource_Class_Student_JspClass,
        showRowNumbers: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        autoFetchData: false,
        border: "0px solid green",
        showConnectors: true,
        canDragRecordsOut: true,
        closedIconSuffix: "",
        openIconSuffix: "",
        selectedIconSuffix: "",
        dropIconSuffix: "",
        showOpenIcons: false,
        showDropIcons: false,
        selectionType: "multiple",
        canDragSelect: false,
        rowNumberFieldProperties: {
            autoFitWidthApproach: "both",
            canDragResize: true,
            autoFitWidth: false,
            headerTitle: "<spring:message code='row'/>",
            width: 50
        },
        fields: [
            {name: "id", hidden: true},
            {name: "lastNameFa", title: "<spring:message code='firstName'/>", align: "center"},
            {name: "studentID", title: "<spring:message code='student.ID'/>", align: "center"}
        ],
        recordDoubleClick: function (viewer, record) {
            var StudentID = record.id;
            var ClassRecord = ListGrid_Class_JspClass.getSelectedRecord();
            var ClassID = ClassRecord.id;
            isc.RPCManager.sendRequest(TrDSRequest(classUrl + "addStudent/" + StudentID + "/" + ClassID, "POST", null, "callback: class_add_student_result(rpcResponse)"));
        },
        dataPageSize: 50
    });

    var ListGrid_Current_Students_JspClass = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        autoDraw: false,
        canDragRecordsOut: false,
        dragTrackerMode: "none",
        canAcceptDroppedRecords: true,
        canReorderRecords: true,
        alternateRecordStyles: true,
        alternateFieldStyles: false,
        dataSource: RestDataSource_Class_CurrentStudent_JspClass,
        canDragSelect: true,
        autoFetchData: false,
        showRowNumbers: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        rowNumberFieldProperties: {
            autoFitWidthApproach: "both",
            canDragResize: true,
            autoFitWidth: false,
            headerTitle: "<spring:message code='row'/>",
            width: 50
        },
        canEdit: true,
        editEvent: "click",
        editByCell: true,
        rowEndEditAction: "done",
        listEndEditAction: "next",
        fields: [
            {name: "id", hidden: true},
            {
                name: "lastNameFa", title: "<spring:message
        code='firstName'/>", align: "center", width: "25%", canEdit: false
            },
            {
                name: "studentID",
                title: "<spring:message code='student.ID'/>",
                align: "center",
                width: "25%",
                canEdit: false
            },
            {name: "iconDelete", title: "<spring:message code='remove'/>", width: "15%", align: "center"}
        ],

        recordDrop: function (dropRecords) {
            var ClassRecord = ListGrid_Class_JspClass.getSelectedRecord();
            var ClassID = ClassRecord.id;
            var StudentID = [];
            for (var i = 0; i < dropRecords.getLength(); i++) {
                StudentID.add(dropRecords[i].id);
            }
            var JSONObj = {"ids": StudentID};
            isc.RPCManager.sendRequest(TrDSRequest(classUrl + "addStudents/" + ClassID, "POST", JSON.stringify(JSONObj), "callback: class_add_students_result(rpcResponse)"));
        },

        createRecordComponent: function (record, colNum) {
            var fieldName = this.getFieldName(colNum);

            if (fieldName === "iconDelete") {
                var recordCanvas = isc.HLayout.create({
                    height: 22,
                    width: "100%",
                    layoutMargin: 5,
                    membersMargin: 10,
                    align: "center"
                });

                var removeIcon = isc.ImgButton.create({
                    showDown: false,
                    showRollOver: false,
                    layoutAlign: "center",
                    src: "pieces/16/icon_delete.png",
                    prompt: "<spring:message code='remove'/>",
                    height: 16,
                    width: 16,
                    grid: this,
                    click: function () {
                        var ClassRecord = ListGrid_Class_JspClass.getSelectedRecord();
                        var ClassID = ClassRecord.id;
                        var StudentID = record.id;
                        isc.RPCManager.sendRequest(TrDSRequest(classUrl + "removeStudent/" + StudentID + "/" + ClassID, "DELETE", null, "callback: class_remove_student_result(rpcResponse)"));
                    }
                });
                recordCanvas.addMember(removeIcon);
                return recordCanvas;
            } else
                return null;
        },
        dataPageSize: 50
    });

    var SectionStack_All_Student_JspClass = isc.SectionStack.create({
        visibilityMode: "multiple",
        width: "50%",
        sections: [
            {
                title: "<spring:message code='unregistred.students'/>",
                expanded: true,
                canCollapse: false,
                align: "center",
                items: [
                    ListGrid_All_Students_JspClass
                ]
            }
        ]
    });

    var SectionStack_Current_Student_JspClass = isc.SectionStack.create({
        visibilityMode: "multiple",
        width: "50%",
        sections: [
            {
                title: "<spring:message code='registred.students'/>",
                expanded: true,
                canCollapse: false,
                align: "center",
                items: [
                    ListGrid_Current_Students_JspClass
                ]
            }
        ]
    });

    var HStack_ClassStudent_JspClass = isc.HStack.create({
        membersMargin: 10,
        height: 500,
        members: [
            SectionStack_All_Student_JspClass,
            SectionStack_Current_Student_JspClass
        ]
    });

    var HLayOut_ClassStudentGridHeader_JspClass = isc.HLayout.create({
        width: 700,
        height: 30,
        border: "0px solid yellow",
        layoutMargin: 5,
        align: "center",
        members: [
            DynamicForm_ClassStudentHeaderGridHeader_JspClass
        ]
    });

    var VLayOut_ClassStudent_JspClass = isc.VLayout.create({
        width: "100%",
        height: 400,
        autoDraw: false,
        border: "0px solid red", layoutMargin: 5,
        members: [
            HLayOut_ClassStudentGridHeader_JspClass,
            HStack_ClassStudent_JspClass
        ]
    });

    var Window_AddStudents_JspClass = isc.Window.create({
        title: "<spring:message code='students.list'/>",
        width: 900,
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: true,
        closeClick: function () {
            this.hide();
        },
        items: [
            VLayOut_ClassStudent_JspClass
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*ToolStrips and Layout*/
    //--------------------------------------------------------------------------------------------------------------------//

    var ToolStripButton_Refresh_JspClass = isc.TrRefreshBtn.create({
        click: function () {
            ListGrid_Class_refresh();
        }
    });

    var ToolStripButton_Edit_JspClass = isc.TrEditBtn.create({
        click: function () {
            ListGrid_class_edit();
        }
    });

    var ToolStripButton_Add_JspClass = isc.TrCreateBtn.create({
        click: function () {
            ListGrid_Class_add();
        }
    });

    var ToolStripButton_Remove_JspClass = isc.TrRemoveBtn.create({
        click: function () {
            ListGrid_class_remove();
        }
    });

    var ToolStripButton_Print_JspClass = isc.ToolStripButton.create({
        icon: "[SKIN]/RichTextEditor/print.png",
        title: "<spring:message code='print'/>",
        click: function () {
            ListGrid_class_print("pdf");
        }
    });

    var ToolStripButton_Add_Student_JspClass = isc.ToolStripButton.create({
        // icon: "icon/classroom.png",
        title: " <spring:message code='students.list'/>",
        click: function () {
            Add_Student();
        }
    });

    var ToolStrip_Actions_JspClass = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStripButton_Refresh_JspClass,
            ToolStripButton_Add_JspClass,
            ToolStripButton_Edit_JspClass,
            ToolStripButton_Remove_JspClass,
            ToolStripButton_Print_JspClass,
            ToolStripButton_Add_Student_JspClass]
    });

    var HLayout_Actions_Class_JspClass = isc.HLayout.create({
        width: "100%",
        height: "1%",
        members: [ToolStrip_Actions_JspClass]
    });

    var HLayout_Grid_Class_JspClass = isc.TrHLayout.create({
        showResizeBar: true,
        width: "100%",
        height: "60%",
        members: [ListGrid_Class_JspClass]
    });

    var TabSet_Class = isc.TabSet.create({
        tabBarPosition: "top",
        tabs: [
            {
                title: "<spring:message code="sessions"/>",//جلسات
                pane: isc.ViewLoader.create(
                    {viewURL: "tclass/sessions-tab"}
                )
            },
            {
                title: "<spring:message code="alarms"/>",//هشدارها
                pane: isc.ViewLoader.create(
                    {viewURL: "tclass/alarms-tab"}
                )
            },
            {
                // id: "TabPane_Post",
                title: "<spring:message code="licenses"/>",//مجوزها
                pane: isc.ViewLoader.create(
                    {viewURL: "tclass/licenses-tab"}
                )
            },
            {
                title: "<spring:message code="attendance"/>",//حضور و غیاب
                pane: isc.ViewLoader.create(
                    {viewURL: "tclass/attendance-tab"}
                )
            },
            {
                title: "<spring:message code="teachers"/>",//مدرسان
                pane: isc.ViewLoader.create(
                    {viewURL: "tclass/teachers-tab"}
                )
            },
            {
                // id: "TabPane_Competence",
                title: "<spring:message code="exam"/>",//آزمون
                pane: isc.ViewLoader.create(
                    {viewURL: "tclass/exam-tab"}
                )
            },
            {
                title: "<spring:message code="assessment"/>",//ارزیابی
                pane: isc.ViewLoader.create(
                    {viewURL: "tclass/assessment-tab"}
                )
            },
            {
                title: "<spring:message code="checkList"/>",//چک لیست
                pane: isc.ViewLoader.create(
                    {viewURL: "tclass/checkList-tab"}
                )
            },
            {
                title: "<spring:message code="attachments"/>",//ضمائم
                pane: isc.ViewLoader.create(
                    {viewURL: "tclass/attachments-tab"}
                )
            }


        ]
    });

    var HLayout_Tab_Class = isc.HLayout.create({
        width: "100%",
        height: "40%",
        members: [TabSet_Class]
    });


    var VLayout_Body_Class_JspClass = isc.TrVLayout.create({
        members: [
            HLayout_Actions_Class_JspClass,
            HLayout_Grid_Class_JspClass,
            HLayout_Tab_Class
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Functions*/
    //--------------------------------------------------------------------------------------------------------------------//

    function ListGrid_class_remove() {
        var record = ListGrid_Class_JspClass.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.not.selected.record'/>");
        } else {
            var Dialog_Class_remove = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                "<spring:message code='global.warning'/>");
            Dialog_Class_remove.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        classWait = createDialog("wait");
                        isc.RPCManager.sendRequest(TrDSRequest(classUrl + record.id, "DELETE", null, "callback: class_delete_result(rpcResponse)"));
                    }
                }
            });
        }
    }

    function ListGrid_class_edit() {
        DynamicForm_Class_JspClass.getField("teacherSet").fetchData();
        var record = ListGrid_Class_JspClass.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.not.selected.record'/>");
        } else {
            classMethod = "PUT";
            url = classUrl + record.id;
            VM_JspClass.clearValues();
            VM_JspClass.editRecord(record);
            console.log(VM_JspClass)
            // DynamicForm_Class_JspClass.getField("courseId").fetchData();
            // DynamicForm_Class_JspClass.getField("courseId").setValue(record.courseId);
            // DynamicForm_Class_JspClass.getItem("course.titleFa").setValue(DynamicForm_Class_JspClass.getItem("courseId").getSelectedRecord().titleFa);
            Window_Class_JspClass.show();
        }
    }

    function ListGrid_Class_refresh() {
        ListGrid_Class_JspClass.invalidateCache();
        ListGrid_Class_JspClass.filterByEditor();
    }

    function ListGrid_Class_add() {
        classMethod = "POST";
        url = classUrl;
        DynamicForm_Class_JspClass.clearValues();
        Window_Class_JspClass.show();
    }

    function ListGrid_class_print(type) {
        var advancedCriteria = ListGrid_Class_JspClass.getCriteria();
        var criteriaForm = isc.DynamicForm.create({
            method: "POST",
            action: "<spring:url value="/tclass/printWithCriteria/"/>" + type,
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "CriteriaStr", type: "hidden"}
                ]
        });
        criteriaForm.setValue("CriteriaStr", JSON.stringify(advancedCriteria));
        criteriaForm.show();
        criteriaForm.submitForm();
    }

    function class_action_result(resp) {

        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {

            var courseId = JSON.parse(resp.data).courseId;

            var VarParams = [{
                "processKey": "ClassWorkFlow",
                "cId": JSON.parse(resp.data).id,
                "code": JSON.parse(resp.data).code,
                "course": DynamicForm_Class_JspClass.getItem("courseId").getSelectedRecord().code,
                "coursetitleFa": DynamicForm_Class_JspClass.getItem("course.titleFa").getValue(),
                "startDate": JSON.parse(resp.data).startDate,
                "endDate": JSON.parse(resp.data).endDate,
               // "classCreator": "classCreator",
                "classCreatorId": "${username}",
                "classCreator": userFullName,
                "REJECT": "",
                "REJECTVAL": "",
                "target": "/tclass/show-form",
                "targetTitleFa": "کلاس"
            }]
            if (classMethod.localeCompare("POST") === 0) {
                isc.RPCManager.sendRequest(TrDSRequest(workflowUrl + "startProcess", "POST", JSON.stringify(VarParams), "callback:startProcess(rpcResponse)"));
            }

            var OK = createDialog("info", "<spring:message code='msg.operation.successful'/>",
                "<spring:message code="msg.command.done"/>");
            setTimeout(function () {
                var responseID = JSON.parse(resp.data).id;
                var gridState = "[{id:" + responseID + "}]";
                ListGrid_Class_JspClass.setSelectedState(gridState);
                OK.close();

            }, 1000);
            ListGrid_Class_refresh();
            Window_Class_JspClass.close();
                     } else {
            createDialog("info", "<spring:message code='error'/>");
        }
    }

    function startProcess(resp) {

        if (resp.httpResponseCode === 200)
            isc.say("فایل فرایند با موفقیت روی موتور گردش کار قرار گرفت");
        else {
            isc.say("کد خطا : " + resp.httpResponseCode);
        }
    }


    function class_delete_result(resp) {
        classWait.close();
        if (resp.httpResponseCode === 200) {
            ListGrid_Class_JspClass.invalidateCache();
            var OK = createDialog("info", "<spring:message code='msg.operation.successful'/>",
                "<spring:message code="msg.command.done"/>");
            setTimeout(function () {
                OK.close();
            }, 3000);
        } else {
            createDialog("info", "<spring:message code='error'/>");
        }
    }

    function class_remove_student_result(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            ListGrid_Current_Students_JspClass.invalidateCache();
            ListGrid_All_Students_JspClass.invalidateCache();
        } else {
            isc.say("<spring:message code='error'/>");
        }
    }

    function class_add_student_result(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            ListGrid_Current_Students_JspClass.invalidateCache();
            ListGrid_All_Students_JspClass.invalidateCache();
        } else {
            isc.say("<spring:message code='error'/>");
        }
    }

    function class_add_students_result(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            ListGrid_Current_Students_JspClass.invalidateCache();
            ListGrid_All_Students_JspClass.invalidateCache();
        } else {
            isc.say("<spring:message code='error'/>");
        }
    }

    function Add_Student() {
        var record = ListGrid_Class_JspClass.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.not.selected.record'/>");
        } else {
            ListGrid_All_Students_JspClass.invalidateCache();
            ListGrid_Current_Students_JspClass.invalidateCache();
            DynamicForm_ClassStudentHeaderGridHeader_JspClass.invalidateCache();
            DynamicForm_ClassStudentHeaderGridHeader_JspClass.setValue("course.titleFa", record.course.titleFa);
            DynamicForm_ClassStudentHeaderGridHeader_JspClass.setValue("group", record.group);
            DynamicForm_ClassStudentHeaderGridHeader_JspClass.setValue("id", record.id);
            ListGrid_All_Students_JspClass.fetchData({"classID": record.id});
            ListGrid_Current_Students_JspClass.fetchData({"classID": record.id});
            Window_AddStudents_JspClass.show();
        }
    }
    // </script>
function test() {
var x=isc.DataSource.create({
ID: "preCourseDS",
clientOnly: true,
dataURL:courseUrl + "spec-list?_startRow=0&_endRow=55",
fields: [
{name: "id", primaryKey: true},
{name: "code"},
{name: "titleFa"},
{name: "theoryDuration"}
]
});
}


// var record=ListGrid_Class_JspClass.getSelectedRecord();
// classMethod = "PUT";
// url = classUrl + record.id;
// DynamicForm_Class_JspClass.clearValues();
// DynamicForm_Class_JspClass.editRecord(record);
// DynamicForm_Class_JspClass.getItem("course.titleFa").setValue(DynamicForm_Class_JspClass.getItem("courseId").getSelectedRecord().titleFa);
// Window_Class_JspClass.show();
//
//


