var RestDataSource_Grid_JspQuestionEvaluation = isc.TrDS.create({
    fields: [
        {name: "titleClass"},
        {name: "code"},
        {name: "courseId"},
    ],
    fetchDataURL: classUrl + "tuple-list"
});

var ListGrid_Grid_JspQuestionEvaluation = isc.TrLG.create({
    width: "100%",
    height: "100%",
    dataSource: RestDataSource_Grid_JspQuestionEvaluation,
    dataPageSize: 15,
    allowAdvancedCriteria: true,
    allowFilterExpressions: true,
    selectionType: "single",
    autoFetchData: false,
    initialSort: [
        {property: "startDate", direction: "descending", primarySort: true}
    ],
    doubleClick: function () {
    },
    fields: [
        {name: "",title:"نوع فرم ارزیابی"},
        {name: "",title:"نام فرم ارزیابی"},
        {name: "",title:"کد کلاس"},
        {name: "",title:"کد دوره"},
        {name: "",title:"عنوان دوره"},
        {name: "",title:"نام استاد"},
        {name: "hasWarning", title: " ", width: 40, type: "image", imageURLPrefix: "", imageURLSuffix: ".gif"},
        {name: "id",hidden:true},
        {name: "classId", hidden: true}
    ]
});

function call_questionEvaluation(selectedStudent) {
    RestDataSource_Grid_JspQuestionEvaluation.fetchDataURL = studentPortalUrl + "/class-student/studentEvaluationForms/" + selectedStudent.nationalCode;
    ListGrid_Grid_JspQuestionEvaluation.fetchData();
    ListGrid_Grid_JspQuestionEvaluation.invalidateCache();
}