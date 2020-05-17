<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>

    var studentRemoveWait;
    var studentDefaultPresenceId = 103;
    var evalData;
    // ------------------------------------------- Menu -------------------------------------------
    StudentMenu_student = isc.Menu.create({
        data: [
            {
                title: "<spring:message code="refresh"/>", icon: "<spring:url value="refresh.png"/>", click: function () {
                    refreshStudentsLG_student();
                }
            },
            {
                title: "<spring:message code="add"/>", icon: "<spring:url value="create.png"/>", click: function () {
                    addStudent_student();
                }
            },
            {
                title: "<spring:message code="remove"/>", icon: "<spring:url value="remove.png"/>", click: function () {
                    removeStudent_student();
                }
            },
            {
                title: "<spring:message code="evaluation"/>", icon: "<spring:url value="remove.png"/>", click: function () {
                    evaluationStudent_student();
                }
            },
        ]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------
    StudentTS_student = isc.ToolStrip.create({
        members: [

            isc.ToolStripButtonAdd.create({
                click: function () {
                    addStudent_student();
                }
            }),
            isc.ToolStripButtonRemove.create({
                click: function () {
                    removeStudent_student();
                }
            }),
            isc.ToolStripButton.create({
                title: "<spring:message code="evaluation"/>",
                click: function () {
                    evaluationStudent_student();
                }
            }),
            isc.ToolStripButtonExcel.create({
                click: function () {
                    ExportToFile.DownloadExcelFormClient(StudentsLG_student, ListGrid_Class_JspClass, '', "کلاس - فراگيران");
                   /* //roya
                    let allRows = StudentsLG_student.data.allRows.toArray();
                    var classRecord = ListGrid_Class_JspClass.getSelectedRecord();

                    var data = [];
                    var fields = [];
                    var titr = "گزارش فراگیران کلاس " + classRecord.course.titleFa +
                        " دارای کد دوره: " + classRecord.course.code +
                        " و کد کلاس: " +  classRecord.code +
                        " و استاد: " + classRecord.teacher +
                            " و مدت: " + classRecord.course.theoryDuration +
                            " ساعت و تاریخ شروع: " +  classRecord.startDate +
                            " و تاریخ پایان: " +  classRecord.endDate;

                    var record = {};
                    record.title = "ردیف";
                    record.name = "row";
                    fields.push(record);

                    record = {};
                    record.title = "شماره پرسنلی 6 رقمی";
                    record.name = "personnelNo";
                    fields.push(record);

                    record = {};
                    record.title = "کد ملی";
                    record.name = "nationalCode";
                    fields.push(record);

                    record = {};
                    record.title = "نام";
                    record.name = "firstName";
                    fields.push(record);

                    record = {};
                    record.title = "نام خانوادگی";
                    record.name = "lastName";
                    fields.push(record);

                    record = {};
                    record.title = "نام پدر";
                    record.name = "fatherName";
                    fields.push(record);

                    record = {};
                    record.title = "شرکت";
                    record.name = "companyName";
                    fields.push(record);

                    record = {};
                    record.title = "حوزه";
                    record.name = "ccpArea";
                    fields.push(record);

                    record = {};
                    record.title = "معاونت";
                    record.name = "ccpAssistant";
                    fields.push(record);

                    record = {};
                    record.title = "امور";
                    record.name = "ccpAffairs";
                    fields.push(record);

                    for(var i=0;i< allRows.length;i++){
                        data[i] = new Object();
                        data[i].row =  i+1;
                        data[i].personnelNo =  allRows[i].student.personnelNo2;
                        data[i].nationalCode =  allRows[i].student.nationalCode;
                        data[i].firstName =  allRows[i].student.firstName;
                        data[i].lastName =  allRows[i].student.lastName;
                        data[i].fatherName =  allRows[i].student.fatherName;
                        data[i].companyName =  allRows[i].applicantCompanyName;
                        data[i].ccpArea =  allRows[i].student.ccpArea;
                        data[i].ccpAssistant =  allRows[i].student.ccpAssistant;
                        data[i].ccpAffairs =  allRows[i].student.ccpAffairs;
                    }

                    exportToExcel(fields, data,titr);*/
                }
            }),
            isc.ToolStripButton.create({
                icon: "[SKIN]/RichTextEditor/print.png",
                title: "<spring:message code='print'/>",
                click: function () {
                    var classRecord = ListGrid_Class_JspClass.getSelectedRecord();
                    var titr = "گزارش فراگیران کلاس " + classRecord.course.titleFa +
                        " دارای کد دوره: " + classRecord.course.code +
                        " و کد کلاس: " +  classRecord.code +
                        " و استاد: " + classRecord.teacher +
                        " و مدت: " + classRecord.course.theoryDuration +
                        " ساعت و تاریخ شروع: " +  classRecord.startDate +
                        " و تاریخ پایان: " +  classRecord.endDate;
                    let params = {};
                    params.titr = titr;

                    let localData = StudentsLG_student.data.localData.toArray();
                    let data = [];

                    for (let i = 0; i < localData.length; i++) {
                        let obj = {};
                        obj.personnelNo =  localData[i].student.personnelNo2;
                        obj.nationalCode =  localData[i].student.nationalCode;
                        obj.firstName =  localData[i].student.firstName;
                        obj.lastName =  localData[i].student.lastName;
                        obj.fatherName =  localData[i].student.fatherName;
                        obj.companyName =  localData[i].applicantCompanyName;
                        obj.ccpArea =  localData[i].student.ccpArea;
                        obj.ccpAssistant =  localData[i].student.ccpAssistant;
                        obj.ccpAffairs =  localData[i].student.ccpAffairs;
                        data.push(obj);
                    }

                    printToJasper(data, params, "ClassStudents.jasper");

                }
            }),
            isc.LayoutSpacer.create({width: "*"}),
            isc.Label.create({ID: "StudentsCount_student"}),

            isc.ToolStripButtonRefresh.create({
                click: function () {
                    refreshStudentsLG_student();
                }
            }),
        ]
    });

    PersonnelsTS_student = isc.ToolStrip.create({
        members: [
            isc.LayoutSpacer.create({width: "*"}),
            isc.Label.create({ID: "PersonnelsCount_student"}),
        ]
    });

    var RegisteredTS_student = isc.ToolStrip.create({
        members: [
            isc.LayoutSpacer.create({width: "*"}),
            isc.Label.create({ID: "RegisteredCount_student"}),
        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------

    var RestDataSource_company_Student = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "workDomain", title: "<spring:message code="workDomain"/>", filterOperator: "iContains"},
            {name: "email", title: "<spring:message code="email"/>", filterOperator: "iContains"},
        ],
        canAddFormulaFields: false,
        filterOnKeypress: true,
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        // filterOnKeypress: false,
        sortFieldAscendingText: "<spring:message code='sort.ascending'/>",
        sortFieldDescendingText: "<spring:message code='sort.descending'/>",
        configureSortText: "<spring:message code='configureSortText'/>",
        autoFitAllText: "<spring:message code='autoFitAllText'/>",
        autoFitFieldText: "<spring:message code='autoFitFieldText'/>",
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>",
        fetchDataURL: companyUrl + "spec-list"
    });

    StudentsDS_student = isc.TrDS.create({
        <%--transformRequest: function (dsRequest) {--%>
        <%--    dsRequest.httpHeaders = {--%>
        <%--        "Authorization": "Bearer <%= accessToken1 %>"--%>
        <%--    };--%>
        <%--    return this.Super("transformRequest", arguments);--%>
        <%--},--%>
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "student.id", hidden: true},
            {name: "student.firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "student.lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "student.nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "applicantCompanyName", title: "<spring:message code="company.applicant"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "presenceTypeId", title: "<spring:message code="class.presence.type"/>", filterOperator: "equals", autoFitWidth: true},
            {name: "student.companyName", title: "<spring:message code="company.name"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "student.personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "student.personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains"},
            {name: "student.postTitle", title: "<spring:message code="post"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "student.ccpArea", title: "<spring:message code="reward.cost.center.area"/>", filterOperator: "iContains"},
            {name: "student.ccpAssistant", title: "<spring:message code="reward.cost.center.assistant"/>", filterOperator: "iContains"},
            {name: "student.ccpAffairs", title: "<spring:message code="reward.cost.center.affairs"/>", filterOperator: "iContains"},
            {name: "student.ccpSection", title: "<spring:message code="reward.cost.center.section"/>", filterOperator: "iContains"},
            {name: "student.ccpUnit", title: "<spring:message code="reward.cost.center.unit"/>", filterOperator: "iContains"},
            {name: "student.fatherName", title: "<spring:message code="father.name"/>", filterOperator: "iContains"}
        ],

        fetchDataURL: tclassStudentUrl + "/students-iscList/"
    });

    StudentsDS_PresenceType = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        fetchDataURL: parameterValueUrl + "/iscList/98"
    });

    StudentsLG_student = isc.TrLG.create({
        dataSource: StudentsDS_student,
       // selectionType: "single",
        selectionType: "multiple",
        fields: [
            {name: "student.firstName"},
            {name: "student.lastName"},
            {name: "student.nationalCode"},
            {name: "student.fatherName",hidden:true},
            {
                name: "applicantCompanyName",
                textAlign: "center",
                width: "*",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "titleFa",
                optionDataSource: RestDataSource_company_Student,
                autoFetchData: true,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                canEdit: true,
                // filterEditorType: "TextItem",
                pickListFields: [
                    {
                        name: "titleFa",
                        width: "70%",
                        filterOperator: "iContains"
                    }
                ],
                changed: function (form, item, value) {
                    ListGrid_Cell_Update_Student(this.grid.getRecord(this.rowNum), value, item);
                }
            },
            {
                name: "presenceTypeId",
                type: "selectItem",
                optionDataSource: StudentsDS_PresenceType,
                valueField: "id",
                displayField: "title",
                filterOnKeypress: true,
                canEdit: true,
                changed: function (form, item, value) {
                    ListGrid_Cell_Update_Student(this.grid.getRecord(this.rowNum), value, item);
                }
            },
            {name: "student.personnelNo"},
            {name: "student.personnelNo2"},
            {name: "student.postTitle"},
            {name: "student.ccpArea"},
            {name: "student.ccpAssistant"},
            {name: "student.ccpAffairs"},
            {name: "student.ccpSection"},
            {name: "student.ccpUnit"}
        ],
        gridComponents: [StudentTS_student, "filterEditor", "header", "body"],
        contextMenu: StudentMenu_student,
        dataChanged: function () {
            this.Super("dataChanged", arguments);
            totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown()) {
                StudentsCount_student.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            } else {
                StudentsCount_student.setContents("&nbsp;");
            }
        }
    });

    SelectedPersonnelsLG_student = isc.TrLG.create({
        ID: "SelectedPersonnelsLG_student",
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: true,
        selectionType: "single",
        fields: [
            {name: "id", hidden: true},
            {name: "remove", tile: "<spring:message code="remove"/>", isRemoveField: true},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {
                name: "applicantCompanyName",
                title: "<spring:message code="company.applicant"/>",
                textAlign: "center",
                canEdit: true,
                width: "*",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "titleFa",
                optionDataSource: RestDataSource_company_Student,
                autoFetchData: true,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                // filterEditorType: "TextItem",
                pickListFields: [
                    {
                        name: "titleFa",
                        width: "70%",
                        filterOperator: "iContains"
                    }
                ]
            },
            {
                name: "presenceTypeId",
                title: "<spring:message code="class.presence.type"/>",
                type: "selectItem",
                optionDataSource: StudentsDS_PresenceType,
                canEdit: true,
                valueField: "id",
                displayField: "title",
                filterOnKeypress: true,
            },
            <%--{name: "companyName", title: "<spring:message code="company.name"/>", filterOperator: "iContains", autoFitWidth: true},--%>
            <%--{name: "personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true},--%>
            <%--{name: "personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains"},--%>
            <%--{name: "postTitle", title: "<spring:message code="post"/>", filterOperator: "iContains", autoFitWidth: true},--%>
            <%--{name: "ccpArea", title: "<spring:message code="reward.cost.center.area"/>", filterOperator: "iContains"},--%>
            <%--{name: "ccpAssistant", title: "<spring:message code="reward.cost.center.assistant"/>", filterOperator: "iContains"},--%>
            <%--{name: "ccpAffairs", title: "<spring:message code="reward.cost.center.affairs"/>", filterOperator: "iContains"},--%>
            <%--{name: "ccpSection", title: "<spring:message code="reward.cost.center.section"/>", filterOperator: "iContains"},--%>
            <%--{name: "ccpUnit", title: "<spring:message code="reward.cost.center.unit"/>", filterOperator: "iContains"},--%>
        ],
        gridComponents: ["filterEditor", "header", "body"],
        canRemoveRecords: true,
    });

    PersonnelDS_student = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "companyName", title: "<spring:message code="company.name"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains",},
            {name: "postTitle", title: "<spring:message code="post"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpArea", title: "<spring:message code="reward.cost.center.area"/>", filterOperator: "iContains"},
            {name: "ccpAssistant", title: "<spring:message code="reward.cost.center.assistant"/>", filterOperator: "iContains"},
            {name: "ccpAffairs", title: "<spring:message code="reward.cost.center.affairs"/>", filterOperator: "iContains"},
            {name: "ccpSection", title: "<spring:message code="reward.cost.center.section"/>", filterOperator: "iContains"},
            {name: "ccpUnit", title: "<spring:message code="reward.cost.center.unit"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: personnelUrl + "/iscList",
    });

    PersonnelsLG_student = isc.TrLG.create({
        dataSource: PersonnelDS_student,
        selectionType: "single",
        fields: [
           // {name: "id", hidden: true},
            {name: "firstName"},
            {name: "lastName"},
            {name: "nationalCode"},
            {name: "companyName",hidden:true},
            {name: "personnelNo"},
            {name: "personnelNo2"},
            {name: "postTitle"},
            {name: "ccpArea"},
            {name: "ccpAssistant",hidden:true},
            {name: "ccpAffairs",hidden:true},
            {name: "ccpSection",hidden:true},
            {name: "ccpUnit",hidden:true},
        ],
        gridComponents: [PersonnelsTS_student, "filterEditor", "header", "body"],
        dataChanged: function () {
            this.Super("dataChanged", arguments);
            totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown()) {
                PersonnelsCount_student.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            } else {
                PersonnelsCount_student.setContents("&nbsp;");
            }
        },
        selectionAppearance: "checkbox",
        selectionUpdated: function () {

            SelectedPersonnelsLG_student.setData(this.getSelection().concat(SelectedPersonnelsLG_student.data).reduce(function (accumulator, current) {

                if(!nationalCodeExists(current.nationalCode))
                {
                    if (checkIfAlreadyExist(current)) {
                        return accumulator
                    } else {
                        current.applicantCompanyName = current.companyName;
                        current.presenceTypeId = studentDefaultPresenceId;
                        current.registerTypeId = 1;
                        return accumulator.concat([current]);
                    }

                    function checkIfAlreadyExist(currentVal) {
                        return accumulator.some(function (item) {
                            return (item.nationalCode === currentVal.nationalCode);
                        });
                    }
                }
                else {
                    isc.Dialog.create({
                        message: "<spring:message code="student.is.duplicate"/>",
                        icon: "[SKIN]stop.png",
                        title: "<spring:message code="message"/>",
                        buttons: [isc.Button.create({title: "<spring:message code="ok"/>"})],
                        buttonClick: function (button, index) {
                            this.close();
                        }
                    });
                }

            }, []));

           // var record = PersonnelsRegLG_student.getSelectedRecord();
            // checkStudentDuplicateNationalCode(record.getValue("nationalCode"));

            // var record = PersonnelsRegLG_student.getSelectedRecord().getValue("nationalCode");
            //  checkStudentDuplicateNationalCode();
        }
    });

    function nationalCodeExists(nationalCode) {
        return StudentsLG_student.data.localData.some(function(el) {
            return el.nationalCode === nationalCode;
        });
    }

    PersonnelRegDS_student = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "companyName", title: "<spring:message code="company.name"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains"},
            {name: "postTitle", title: "<spring:message code="post"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpArea", title: "<spring:message code="reward.cost.center.area"/>", filterOperator: "iContains"},
            {name: "ccpAssistant", title: "<spring:message code="reward.cost.center.assistant"/>", filterOperator: "iContains"},
            {name: "ccpAffairs", title: "<spring:message code="reward.cost.center.affairs"/>", filterOperator: "iContains"},
            {name: "ccpSection", title: "<spring:message code="reward.cost.center.section"/>", filterOperator: "iContains"},
            {name: "ccpUnit", title: "<spring:message code="reward.cost.center.unit"/>", filterOperator: "iContains"},
        ],
        // autoFetchData: true,
        fetchDataURL: personnelRegUrl + "/spec-list",
    });

    PersonnelsRegLG_student = isc.TrLG.create({
        dataSource: PersonnelRegDS_student,
        selectionType: "single",
        fields: [
            //{name: "id", hidden: true},
            {name: "firstName"},
            {name: "lastName"},
            {name: "nationalCode"},
            {name: "companyName",hidden:true},
            {name: "personnelNo"},
            {name: "personnelNo2"},
            {name: "postTitle"},
            {name: "ccpArea"},
            {name: "ccpAssistant",hidden:true},
            {name: "ccpAffairs",hidden:true},
            {name: "ccpSection",hidden:true},
            {name: "ccpUnit",hidden:true},
        ],
        gridComponents: [RegisteredTS_student, "filterEditor", "header", "body"],
        dataChanged: function () {
            this.Super("dataChanged", arguments);
            totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown()) {
                PersonnelsCount_student.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            } else {
                PersonnelsCount_student.setContents("&nbsp;");
            }
        },
        selectionAppearance: "checkbox",
        selectionUpdated: function () {
            SelectedPersonnelsLG_student.setData(this.getSelection().concat(SelectedPersonnelsLG_student.data).reduce(function (accumulator, current) {
                if(!nationalCodeExists(current.nationalCode))
                {
                if (checkIfAlreadyExist(current)) {
                    return accumulator
                } else {
                    current.applicantCompanyName = current.companyName;
                    current.presenceTypeId = studentDefaultPresenceId;
                    current.registerTypeId = 2;
                    return accumulator.concat([current]);
                }

                function checkIfAlreadyExist(currentVal) {
                    return accumulator.some(function (item) {
                        return (item.nationalCode === currentVal.nationalCode);
                    });
                }


                }
                else {
                    isc.Dialog.create({
                        message: "<spring:message code="student.is.duplicate"/>",
                        icon: "[SKIN]stop.png",
                        title: "<spring:message code="message"/>",
                        buttons: [isc.Button.create({title: "<spring:message code="ok"/>"})],
                        buttonClick: function (button, index) {
                            this.close();
                        }
                    });
                }


            }, []));

            // var record = PersonnelsRegLG_student.getSelectedRecord();
            // checkStudentDuplicateNationalCode(record.getValue("nationalCode"));

            // var record = PersonnelsRegLG_student.getSelectedRecord().getValue("nationalCode");
            // checkStudentDuplicateNationalCode();
        }
    });

    // ------------------------------------------- DynamicForm & Window -------------------------------------------

    var personnel_List_VLayout = isc.VLayout.create({
        width: "100%",
        height: "100%",
        autoDraw: false,
        border: "0px solid red", layoutMargin: 5,
        members: [
            isc.SectionStack.create({
                sections: [{
                    title: "<spring:message code="all.persons"/>",
                    expanded: true,
                    canCollapse: false,
                    align: "center",
                    items: [
                        PersonnelsLG_student
                    ]
                }]
            }),
        ]
    });

    var registered_List_VLayout = isc.VLayout.create({
        width: "100%",
        height: "100%",
        autoDraw: false,
        border: "0px solid red", layoutMargin: 5,
        members: [
            isc.SectionStack.create({
                sections: [{
                    title: "<spring:message code="all.persons"/>",
                    expanded: true,
                    canCollapse: false,
                    align: "center",
                    items: [
                        PersonnelsRegLG_student
                    ]
                }]
            }),

        ]
    });

    var personnelTabs = isc.TabSet.create({
        height: "50%",
        width: "100%",
        showTabScroller: false,
        tabs: [
            {
                title: "<spring:message code='personnel.tab.persone'/>",
                pane: personnel_List_VLayout
            },
            {
                title: "<spring:message code='personnel.tab.registered'/>",
                pane: registered_List_VLayout
            }
        ]
    });

    ClassStudentWin_student = isc.Window.create({
        width: 1024,
        height: 600,
        minWidth: 1024,
        minHeight: 600,
        autoSize: false,
        items: [
            personnelTabs,
            isc.SectionStack.create({
                sections: [{
                    title: "<spring:message code="selected.persons"/>", expanded: true, canCollapse: false, align: "center",
                    items: [
                        SelectedPersonnelsLG_student,
                        isc.TrHLayoutButtons.create({
                            members: [
                                isc.IButtonSave.create({
                                    top: 260,
                                    title: "<spring:message code='save'/>",
                                    align: "center",
                                    icon: "[SKIN]/actions/save.png",
                                    click: function () {
                                        var classId = ListGrid_Class_JspClass.getSelectedRecord().id;
                                        var students = [];
                                        for (let i = 0; i < SelectedPersonnelsLG_student.data.length; i++) {
                                            students.add({
                                                "personnelNo": SelectedPersonnelsLG_student.data[i].personnelNo,
                                                "applicantCompanyName": SelectedPersonnelsLG_student.data[i].applicantCompanyName,
                                                "presenceTypeId": SelectedPersonnelsLG_student.data[i].presenceTypeId,
                                                "registerTypeId": SelectedPersonnelsLG_student.data[i].registerTypeId
                                            });
                                        }
                                        if (students.getLength() > 0)
                                            isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/register-students/" + classId, "POST", JSON.stringify(students),class_add_students_result));

                                        SelectedPersonnelsLG_student.data.clearAll();
                                    }
                                }), isc.IButtonCancel.create({
                                    top: 260,
                                    title: "<spring:message code='cancel'/>",
                                    align: "center",
                                    icon: "[SKIN]/actions/cancel.png",
                                    click: function () {

                                        SelectedPersonnelsLG_student.invalidateCache();
                                        ClassStudentWin_student.close();
                                    }
                                }),
                            ],
                        }),
                    ]
                }
                ]
            }),
        ]
    });

    var evaluationViewloader = isc.ViewLoader.create({
        width: "100%",
        height: "100%",
        autoDraw: true,
        loadingMessage: " "
    });

    var  evaluationWindowViewloader  = isc.Window.create({
        width: 800,
        height: 900,
        autoSize:false,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: true,
        items: [
            evaluationViewloader
        ]
    });

    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrVLayout.create({
        members: [
            StudentsLG_student
        ],
    });

    // ------------------------------------------- Functions -------------------------------------------
    function refreshStudentsLG_student() {
        // StudentsLG_student.filterByEditor();
        StudentsLG_student.invalidateCache();

    }

    function addStudent_student() {
        classRecord = ListGrid_Class_JspClass.getSelectedRecord();
        if (classRecord == null || classRecord.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            return;
        }
        ClassStudentWin_student.setTitle("<spring:message code="add.student.to.class"/> \'" + classRecord.titleClass + "\'");
        PersonnelsLG_student.invalidateCache();
        PersonnelsLG_student.fetchData();
        PersonnelsRegLG_student.invalidateCache();
        PersonnelsRegLG_student.fetchData();
        SelectedPersonnelsLG_student.setData([]);
        ClassStudentWin_student.show();
    }

    function class_add_students_result(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            var classId = ListGrid_Class_JspClass.getSelectedRecord().id;
            ClassStudentWin_student.close();
            refreshLG(StudentsLG_student);
            var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",

                "<spring:message code="msg.command.done"/>");
            setTimeout(function () {
                OK.close();
            }, 3000);
        } else {
            var OK = createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>",
                "<spring:message code="error"/>");
            setTimeout(function () {
                OK.close();
            }, 3000);
        }
    }

    function removeStudent_student() {
        var studentIds=new Array();
        var classId = ListGrid_Class_JspClass.getSelectedRecord().id;
        var studentRecord = StudentsLG_student.getSelectedRecords();

        if (studentRecord == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            var Dialog_Delete = isc.Dialog.create({
                message: "<spring:message code='msg.record.remove.ask'/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code='msg.remove.title'/>",
                buttons: [isc.Button.create({title: "<spring:message code='yes'/>"}), isc.Button.create({
                    title: "<spring:message code='no'/>"
                })],
                buttonClick: function (button, index) {
                    this.close();

                    if (index == 0) {
                        studentRemoveWait = isc.Dialog.create({
                            message: "<spring:message code='msg.waiting'/>",
                            icon: "[SKIN]say.png",
                            title: "<spring:message code='message'/>"
                        });

                        for(i=0;i<studentRecord.getLength();i++)
                        {
                            studentIds.add(studentRecord[i].id)
                        }

                         isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/" + studentIds, "DELETE", null, class_remove_student_result));
                      //  isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/" + studentRecord.id, "DELETE", null, class_remove_student_result));
                    }
                }
            });
        }
    };

    function class_remove_student_result(resp) {
        studentRemoveWait.close();
        if (resp.httpResponseCode == 200) {
            simpleDialog("<spring:message code="create"/>", "<spring:message code="msg.operation.successful"/>", 2000, "say");
            refreshLG(StudentsLG_student);
        }
        else if (resp.data == false) {
            var ERROR = isc.Dialog.create({
                message: "<spring:message code='msg.student.remove.error'/>",
                icon: "[SKIN]stop.png",
                title: "<spring:message code='message'/>"
            });
            setTimeout(function () {
                ERROR.close();
            }, 3000);
        }
        else {
            var ERROR = isc.Dialog.create({
                message: "<spring:message code='msg.record.remove.failed'/>",
                icon: "[SKIN]stop.png",
                title: "<spring:message code='message'/>"
            });
            setTimeout(function () {
                ERROR.close();
            }, 3000);
        }
    };

    function ListGrid_Cell_Update_Student(record, newValue, item) {
        var updating = {};
        if(item.name === "applicantCompanyName"){
            updating.applicantCompanyName = newValue;
            updating.presenceTypeId = record.presenceTypeId;
        } else if (item.name === "presenceTypeId"){
            updating.applicantCompanyName = record.applicantCompanyName;
            updating.presenceTypeId = newValue;
        }
        isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/" + record.id, "PUT", JSON.stringify(updating), class_student_update_student_result));
    }

    function class_student_update_student_result(resp) {
        var classId = ListGrid_Class_JspClass.getSelectedRecord().id;
        if (resp.httpResponseCode === 200) {
            refreshLG(StudentsLG_student);
        }
        else {
            isc.Dialog.create({
                message: "<spring:message code='msg.operation.error'/>",
                icon: "[SKIN]stop.png",
                title: "<spring:message code='message'/>"
            });
        }
    }

    function loadPage_student() {
        classRecord = ListGrid_Class_JspClass.getSelectedRecord();
        if (!(classRecord === undefined || classRecord == null)) {
            StudentsDS_student.fetchDataURL = tclassStudentUrl + "/students-iscList/" + classRecord.id;
            StudentsLG_student.invalidateCache();
            StudentsLG_student.fetchData();
        }
    }

    // ------------------------------------------- Duplicate Student

    function checkStudentDuplicateNationalCode() {
        var record = PersonnelsRegLG_student.getSelectedRecord().getValue("nationalCode");
        var classId = ListGrid_Class_JspClass.getSelectedRecord().id;
        isc.RPCManager.sendRequest(TrDSRequest(classUrl + "checkStudentInClass/" + nationalCode + "/" + classId, "GET",
            null, "callback: student_national_code_findOne_result(rpcResponse)"));
    }


    function student_national_code_findOne_result(resp) {
        if (resp == null || resp == undefined || resp.data == "") {
            duplicateCodePerReg = true;
            var ERROR = isc.Dialog.create({
                message: ("<spring:message code='msg.national.code.duplicate'/>"),
                icon: "[SKIN]stop.png",
                title: "<spring:message code='message'/>"
            });
            setTimeout(function () {
                ERROR.close();
            }, 3000);
        }
    }
    
    
    
    
    function  evaluationStudent_student() {

        var studentId = StudentsLG_student.getSelectedRecord();
        var classId = ListGrid_Class_JspClass.getSelectedRecord();
        if (studentId == null || studentId == undefined || classId == null || classId == undefined ) {
            var ERROR = isc.Dialog.create({
                message: ("<spring:message code='global.grid.record.not.selected'/>"),
                icon: "[SKIN]stop.png",
                title: "<spring:message code='message'/>"
            });
            setTimeout(function () {
                ERROR.close();
            }, 3000);
        }
        else {
        isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/checkEvaluationStudentInClass/" + studentId.student.id + "/" + classId.id , "GET",
            null, "callback: student_evaluation_class_findOne_result(rpcResponse)"));
        }
    }

    function student_evaluation_class_findOne_result(resp) {
        if (resp == null || resp == undefined || resp.data == "") {
            var ERROR = isc.Dialog.create({
                message: ("<spring:message code='msg.operation.error'/>"),
                icon: "[SKIN]stop.png",
                title: "<spring:message code='message'/>"
            });
            setTimeout(function () {
                ERROR.close();
            }, 3000);
        } else {
            evalData = resp.data;
            // var studentId = StudentsLG_student.getSelectedRecord().student.id;
            // var classId = ListGrid_Class_JspClass.getSelectedRecord().id;

            var studentRecord = StudentsLG_student.getSelectedRecord();
            var classRecord = ListGrid_Class_JspClass.getSelectedRecord();
            switch (evalData) {
                case "1": {
                    // evaluationViewloader.setViewURL("evaluation/reaction-form"+ studentId + "/" + classId);

                    evaluationViewloader.setViewURL("evaluation/reaction-form");
                    evaluationWindowViewloader.setTitle("<spring:message code="evaluation.reaction"/>");
                    evaluationWindowViewloader.show();
                    setTimeout(function () {
                        loadPage_reaction();
                    }, 100);

                    break;
                }
                case "2": {
                    evaluationViewloader.setViewURL("evaluation/learning-form");
                    evaluationWindowViewloader.setTitle("<spring:message code="evaluation.learning"/>");
                    evaluationWindowViewloader.show();
                    break;
                }
                case "3": {
                    evaluationViewloader.setViewURL("evaluation/behavioral-form");
                    evaluationWindowViewloader.setTitle("<spring:message code="evaluation.behavioral"/>");
                    evaluationWindowViewloader.show();
                    break;
                }
                case "4": {
                    evaluationViewloader.setViewURL("evaluation/results-form");
                    evaluationWindowViewloader.setTitle("<spring:message code="evaluation.results"/>");
                    evaluationWindowViewloader.show();
                    break;
                }
            }
        }
    }






    //