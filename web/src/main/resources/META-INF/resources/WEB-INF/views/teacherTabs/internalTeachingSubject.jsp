<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>


    var averageEvalGradeLabel = isc.Label.create({
        margin: 2,
        contents: "میانگین نمره فراگیران به استاد : ",
        border: "0px solid black",
        align: "left",
        width: "50%",
        height: "100%"
    });
    var chartData_teachingSubject = [
        {title: "<spring:message code='class'/>" , type: 0, duration: 0},
        {title: "<spring:message code='students.average.grade'/>",  type: 0, duration: 0}

    ];


    //--------------------------------------------------------------------------------------------------------------------//
    /*RestDataSource*/
    //--------------------------------------------------------------------------------------------------------------------//

    RestDataSource_JspInternalTeachingSubject = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "course.code", filterOperator: "iContains"},
            {name: "course.titleFa", filterOperator: "equals"},
            {name: "organizer.titleFa", filterOperator: "equals"},
            {name: "startDate"},
            {name: "endDate"},
            {name: "teacherEvalGrade"},
            {name: "evaluationGrade"},
            {name: "code"}
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Grid*/
    //--------------------------------------------------------------------------------------------------------------------//

    ListGrid_JspInternalTeachingSubject = isc.TrLG.create({
        dataSource: RestDataSource_JspInternalTeachingSubject ,
        fields: [
            {name: "id",hidden: true},
            {
                name: "course.code",
                title: "کد دوره",
                filterOperator: "iContains"
            },
            {
                name: "course.titleFa",
                title: "نام دوره",
                filterOperator: "iContains"
            },
            {
                name: "code",
                title: "کد کلاس",
                filterOperator: "iContains"
            },
            {
                name: "startDate",
                title: "تاریخ شروع",
                filterOperator: "iContains",
                filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                }
            },
            {
                name: "endDate",
                title: "تاریخ خاتمه",
                filterOperator: "iContains",
                filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                }
            },
            {
                name: "organizer.titleFa",
                title: "برگزارکننده",
                filterOperator: "iContains"
            },
            {
                name: "teacherEvalGrade",
                title: "نمره ارزیابی فراگیران به مدرس",
                canFilter: false,


            },
            {
                name: "evaluationGrade",
                title: "نمره ارزیابی فراگیران به مدرس",
                hidden: true
            },



        ],
        align: "center",
        filterOnKeypress: true,
        filterLocally: true,
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>",
        dataArrived: function () {
            this.Super("dataArrived", arguments);
            let localData = this.data.localData;

            let total = 0;
            let average = 0;
            let averageCount = 0;
            if (localData.length) {
                ToolStripButton_ShowChart_TeachingSubject.setEnabled(true);
                for (let i = 0; i < localData.length; i++) {
                    total += localData[i].evaluationGrade;
                    if (localData[i].evaluationGrade !== 0)
                        averageCount += 1
                }
                if (averageCount !== 0) {
                    average = total / averageCount;
                    averageEvalGradeLabel.setContents("میانگین نمره فراگیران به استاد : " + (Math.round(average * 100) / 100).toFixed(2));
                }else{
                    averageEvalGradeLabel.setContents("میانگین نمره فراگیران به استاد : ثبت نشده ");
                }

            }
        },
    });
    //----------------------------------------------------------------------------Toolscrip--------------------------------------------------------------------
    ToolStripButton_ShowChart_TeachingSubject = isc.ToolStripButton.create({
        margin: 2,
        enabled: false,
        title:"نمایش نمودار رضایت فراگیر",
        click: function () {
            let localData = ListGrid_JspInternalTeachingSubject.data.localData;
            showChart_teachingSubject(localData);
        }
    });
    Chart_teachingSubject = isc.FacetChart.create({
        valueProperty: "duration",
        showTitle: false,
        filled: true,
        stacked: false,
    });

    Window_Chart_teachingSubject = isc.Window.create({
        placement: "fillScreen",
        title: "",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        minWidth: 720,
        minHeight: 540,
        items: [isc.TrVLayout.create({
            members: [Chart_teachingSubject]
        })]
    });

    let Export_To_Excel = isc.ToolStripButtonExcel.create({
        margin: 2,
        click: function () {
            makeExcelReport();
        }
    });

    let HLayout_Buttons = isc.HLayout.create({
        width: "50%",
        height: "100%",
        members: [
            ToolStripButton_ShowChart_TeachingSubject, Export_To_Excel
        ]
    })

    VLayout_Body_JspInternalTeachingSubject = isc.TrVLayout.create({
        members: [
            isc.HLayout.create({
                width: "100%",
                height: "1%",
                margin: 10,
                members: [HLayout_Buttons, averageEvalGradeLabel]
            }),
            ListGrid_JspInternalTeachingSubject
        ],

    });
    //--------------------------------------------------------------function-------------------------------------------------------------------------------------
    function ListGrid_InternalTeachingSubject_refresh() {
        ListGrid_JspInternalTeachingSubject.invalidateCache();
        ListGrid_JspInternalTeachingSubject.filterByEditor();
    }

    let teacher_fullName = "";

    function loadPage_InternalTeachingSubject(record) {

        let teacherIdInternalTeachingSubject = record.id
        teacher_fullName = record.fullName

        RestDataSource_JspInternalTeachingSubject.fetchDataURL = classUrl + "listByteacherID/" + teacherIdInternalTeachingSubject;

         ListGrid_InternalTeachingSubject_refresh();
    }

    function clear_InternalTeachingSubject() {
        ListGrid_JspInternalTeachingSubject.clear();
    }
    function showChart_teachingSubject (data,avrage) {

        let criteriaForm = isc.DynamicForm.create({
            method: "POST",
            action: "<spring:url value="/tclass/chartPrint/pdf"/>",
            target: "_Blank",
            canSubmit: true,
            fields:[
                {name: "list", type: "hidden"},
                {name: "fullName", type: "hidden"}
            ]
        });



          criteriaForm.setValue("list", JSON.stringify(data));
          criteriaForm.setValue("fullName", teacher_fullName);
          criteriaForm.show();
          criteriaForm.submitForm();




    }

    function makeExcelReport() {
        if (ListGrid_JspInternalTeachingSubject.getOriginalData().localData === undefined)
            createDialog("info", "ابتدا چاپ گزارش را انتخاب کنید");
        else {
            let restUrl = classUrl + "/spec-list?_endRow=10000";
            ExportToFile.downloadExcelRestUrl(
                null,
                ListGrid_JspInternalTeachingSubject,
                restUrl,
                0,
                null,
                '',
                "گزارش رضایت فراگیر از استاد",
                ListGrid_JspInternalTeachingSubject.getCriteria(),
                null
            );
        }
    }


    //</script>