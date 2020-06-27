<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>

    var studentRemoveWait;
    var studentDefaultPresenceId = 103;
    var evalData;
    var isEditing=false;
    var url='';
    var studentSelection=false;

    // ------------------------------------------- Menu -------------------------------------------
    StudentMenu_student = isc.Menu.create({
        data: [

            <sec:authorize access="hasAnyAuthority('TclassStudentsTab_R','TclassStudentsTab_classStatus')">
            {
                title: "<spring:message code="refresh"/>", icon: "<spring:url value="refresh.png"/>", click: function () {

                    refreshStudentsLG_student();
                }
            },
            </sec:authorize>

            <sec:authorize access="hasAnyAuthority('TclassStudentsTab_ADD','TclassStudentsTab_classStatus')">
            {
                title: "<spring:message code="add"/>", icon: "<spring:url value="create.png"/>", click: function () {
                    addStudent_student();
                }
            },
            </sec:authorize>

            <sec:authorize access="hasAnyAuthority('TclassStudentsTab_D','TclassStudentsTab_classStatus')">
            {
                title: "<spring:message code="remove"/>", icon: "<spring:url value="remove.png"/>", click: function () {
                    removeStudent_student();
                }
            },
            </sec:authorize>

            <sec:authorize access="hasAnyAuthority('TclassStudentsTab_E','TclassStudentsTab_classStatus')">
            {
                title: "<spring:message code="evaluation"/>", icon: "<spring:url value="remove.png"/>", click: function () {
                    evaluationStudent_student();
                }
            },
            </sec:authorize>
        ]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------
    StudentTS_student = isc.ToolStrip.create({
        members: [

            <sec:authorize access="hasAnyAuthority('TclassStudentsTab_ADD','TclassStudentsTab_classStatus')">
            isc.ToolStripButtonAdd.create({
                click: function () {
                    addStudent_student();
                }
            }),
            </sec:authorize>

            <sec:authorize access="hasAnyAuthority('TclassStudentsTab_D','TclassStudentsTab_classStatus')">
            isc.ToolStripButtonRemove.create({
                click: function () {
                    removeStudent_student();
                }
            }),
            </sec:authorize>

            <sec:authorize access="hasAnyAuthority('TclassStudentsTab_E','TclassStudentsTab_classStatus')">
            isc.ToolStripButton.create({
                title: "<spring:message code="evaluation"/>",
                click: function () {
                    evaluationStudent_student();
                }
            }),
            </sec:authorize>

            <sec:authorize access="hasAnyAuthority('TclassStudentsTab_P','TclassStudentsTab_classStatus')">
            isc.ToolStripButtonExcel.create({
                click: function () {
                    ExportToFile.downloadExcelFromClient(StudentsLG_student, ListGrid_Class_JspClass, '', "کلاس - فراگيران");
                }
            }),
            isc.ToolStripButton.create({
                icon: "[SKIN]/RichTextEditor/print.png",
                title: "<spring:message code='print'/>",
                click: function () {
                    var classRecord = ListGrid_Class_JspClass.getSelectedRecord();

                    let startDateStr=[...classRecord.startDate.split("/").reverse()].join("/");
                    let endDateStr=[...classRecord.endDate.split("/").reverse()].join("/");

                    var titr = "گزارش فراگیران کلاس " + classRecord.course.titleFa +
                        " دارای کد دوره: " + classRecord.course.code +
                        " و کد کلاس: " +  classRecord.code +
                        " و استاد: " + classRecord.teacher +
                        " و مدت: " + classRecord.hduration +
                        " ساعت و تاریخ شروع: " +  startDateStr +
                        " و تاریخ پایان: " +  endDateStr;

                    let params = {};
                    params.titr = titr;

                    let localData = StudentsLG_student.data.localData.toArray();
                    let data = [];

                    for (let i = 0; i < localData.length; i++) {
                        let obj = {};
                        obj.personnelNo =  localData[i].student.personnelNo2;
                        obj.nationalCode =  localData[i].student.nationalCode;
                        obj.firstName =  localData[i].student.firstName.trim();
                        obj.lastName =  localData[i].student.lastName.trim();
                        obj.fatherName =  localData[i].student.fatherName;
                        obj.companyName =  localData[i].applicantCompanyName;
                        obj.ccpArea =  localData[i].student.ccpArea;
                        obj.ccpAssistant =  localData[i].student.ccpAssistant;
                        obj.ccpAffairs =  localData[i].student.ccpAffairs;
                        data.push(obj);
                    }

                    // method 1:
                    // data=data.sort((a, b) => (a.lastName[0] > b.lastName[0] ? -1 : 1));

                    // method 2:
                    data=data.sort(new Intl.Collator("fa").compare);

                    printToJasper(data, params, "ClassStudents.jasper");

                }
            }),
            </sec:authorize>
            isc.LayoutSpacer.create({width: "*"}),
            isc.Label.create({ID: "StudentsCount_student"}),

            <sec:authorize access="hasAnyAuthority('TclassStudentsTab_R','TclassStudentsTab_classStatus')">
            isc.ToolStripButtonRefresh.create({
                click: function () {
                    refreshStudentsLG_student();
                }
            }),
            </sec:authorize>
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
            {name: "student.fatherName", title: "<spring:message code="father.name"/>", filterOperator: "iContains"},
            {name: "student.mobile", title: "<spring:message code="mobile"/>", filterOperator: "iContains"},
            {name: "student.birthCertificateNo", title: "<spring:message code="birth.certificate.no"/>", filterOperator: "iContains"}
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
        <sec:authorize access="hasAnyAuthority('TclassStudentsTab_R','TclassStudentsTab_classStatus')">
        dataSource: StudentsDS_student,
        </sec:authorize>
       // selectionType: "single",
        selectionType: "multiple",
        sortField: 1,
        sortDirection: "descending",
        fields: [
            {name: "student.firstName", autoFitWidth: true},
            {name: "student.lastName", autoFitWidth: true},
            {name: "student.nationalCode",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }, autoFitWidth: true
            },
            {name: "student.fatherName",hidden:true},
            {
                name: "applicantCompanyName",
                textAlign: "center",
                autoFitWidth: true,
                <%--editorType: "ComboBoxItem",--%>
                <%--changeOnKeypress: true,--%>
                <%--displayField: "titleFa",--%>
                <%--valueField: "titleFa",--%>
                <%--<sec:authorize access="hasAuthority('TclassStudentsTab_R')">--%>
                <%--optionDataSource: RestDataSource_company_Student,--%>
                <%--</sec:authorize>--%>
                <%--autoFetchData: true,--%>
                <%--addUnknownValues: false,--%>
                <%--cachePickListResults: false,--%>
                <%--useClientFiltering: true,--%>
                <%--filterFields: ["titleFa"],--%>
                <%--sortField: ["id"],--%>
                <%--textMatchStyle: "startsWith",--%>
                <%--generateExactMatchCriteria: true,--%>
                <%--canEdit: true,--%>
                <%--// filterEditorType: "TextItem",--%>
                <%--pickListFields: [--%>
                    <%--{--%>
                        <%--name: "titleFa",--%>
                        <%--width: "70%",--%>
                        <%--filterOperator: "iContains"--%>
                    <%--}--%>
                <%--],--%>
                <%--changed: function (form, item, value) {--%>
                    <%--ListGrid_Cell_Update_Student(this.grid.getRecord(this.rowNum), value, item);--%>
                <%--}--%>
            },
            {
                name: "presenceTypeId",
                type: "selectItem",
                optionDataSource: StudentsDS_PresenceType,
                valueField: "id",
                displayField: "title",
                autoFitWidth: true,
                filterOnKeypress: true,
                canEdit: true,
                changed: function (form, item, value) {
                    ListGrid_Cell_Update_Student(this.grid.getRecord(this.rowNum), value, item);
                }
            },
            {name: "student.personnelNo",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                },
                autoFitWidth: true
            },
            {name: "student.personnelNo2",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                },
                autoFitWidth: true
            },
            {name: "student.postTitle",autoFitWidth: true},
            {name: "student.mobile",autoFitWidth: true},
            {name: "student.birthCertificateNo",autoFitWidth: true},
            {name: "student.ccpArea",autoFitWidth: true},
            {name: "student.ccpAssistant",autoFitWidth: true},
            {name: "student.ccpAffairs",autoFitWidth: true},
            {name: "student.ccpSection",autoFitWidth: true},
            {name: "student.ccpUnit",autoFitWidth: true}
        ],
        gridComponents: [StudentTS_student, "filterEditor", "header", "body"],
       // contextMenu: StudentMenu_student,
        dataChanged: function () {
            this.Super("dataChanged", arguments);
            totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown()) {
                StudentsCount_student.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            } else {
                StudentsCount_student.setContents("&nbsp;");
            }
        },
        getCellCSSText: function (record, rowNum, colNum) {
            let result="background-color : ";
            let blackColor="; color:black";
            switch (parseInt(record.presenceTypeId)) {
                case 104:
                    result += "#FFF9C4" + blackColor;
                    break;
            }//end switch-case

            return result;
        }//end getCellCSSText
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
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true,
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {
                name: "applicantCompanyName",
                title: "<spring:message code="company.applicant"/>",
                textAlign: "center",
                //canEdit: true,
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
                //canEdit: true,
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
        removeRecordClick:function (rowNum){
            let nationalCode = SelectedPersonnelsLG_student.data[rowNum].nationalCode;

            studentSelection=true;
            let list=PersonnelsLG_student.getSelection();
            let current=list.filter(function(x){return x.nationalCode==nationalCode});
            current.setProperty("enabled", true);
            PersonnelsLG_student.deselectRecord(current)


            list=PersonnelsRegLG_student.getSelection();
            current=list.filter(function(x){return x.nationalCode==nationalCode});
            current.setProperty("enabled", true);
            PersonnelsRegLG_student.deselectRecord(current)

            studentSelection=false;

            SelectedPersonnelsLG_student.data.removeAt(rowNum);
        }
    });

    PersonnelDS_student = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true,
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "companyName", title: "<spring:message code="company.name"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true,
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
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
            {name: "nationalCode",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "companyName",hidden:true},
            {name: "personnelNo",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "personnelNo2",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "postTitle"},
            {name: "ccpArea"},
            {name: "ccpAssistant",hidden:true},
            {name: "ccpAffairs",hidden:true},
            {name: "ccpSection",hidden:true},
            {name: "ccpUnit",hidden:true},
        ],
        dataArrived:function(startRow, endRow){
            let lgNationalCodes = StudentsLG_student.data.localData.map(function(item) {
                return item.student.nationalCode;
            });
            let selectedNationalCodes = SelectedPersonnelsLG_student.data.map(function(item) {
                return item['nationalCode'];
            });

            let nationals=lgNationalCodes.concat(selectedNationalCodes);

            let findRows=PersonnelsLG_student.findAll({_constructor:"AdvancedCriteria",operator:"and",criteria:[{fieldName:"nationalCode",operator:"inSet",value:nationals}]});
            studentSelection=true;

            PersonnelsLG_student.setSelectedState(findRows);
            findRows.setProperty("enabled", false);

            studentSelection=false;
        },
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

            if(studentSelection){
                return ;
            }


            let current=PersonnelsLG_student.getSelection().filter(function(x){return x.enabled!=false})[0];//.filter(p->p.enabled==false);

            if(typeof(current)=="undefined"){
                return;
            }
            if(current.nationalCode=="" || current.nationalCode ==null || typeof(current.nationalCode)=="undefined")
            {
                isc.Dialog.create({
                    message: "اطلاعات شخص مورد نظر ناقص است. کد ملی برای این شخص وارد نشده است.",
                    icon: "[SKIN]stop.png",
                    title: "<spring:message code="message"/>",
                    buttons: [isc.Button.create({title: "<spring:message code="ok"/>"})],
                    buttonClick: function (button, index) {
                        this.close();
                    }
                });

                studentSelection=true;
                PersonnelsLG_student.deselectRecord(current)
                studentSelection=false;
            }
            else if(!nationalCodeExists(current.nationalCode))
            {
                if (checkIfAlreadyExist(current)) {
                    return '';
                } else {
                    current.applicantCompanyName = current.companyName;
                    current.presenceTypeId = studentDefaultPresenceId;
                    current.registerTypeId = 1;

                    SelectedPersonnelsLG_student.data.add(Object.assign({}, current));
                    PersonnelsLG_student.findAll({_constructor:"AdvancedCriteria",operator:"and",criteria:[{fieldName:"nationalCode",operator:"equals",value:current.nationalCode}]}).setProperty("enabled", false);
                }

                function checkIfAlreadyExist(currentVal) {
                    return SelectedPersonnelsLG_student.data.some(function (item) {
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
                studentSelection=true;
                PersonnelsLG_student.deselectRecord(current)
                studentSelection=false;
            }
        }
    });

    let criteria_ActivePersonnel = {
        _constructor: "AdvancedCriteria",
        operator: "and",
        criteria: [
            {fieldName: "active", operator: "equals", value: 1}
        ]
    };

    PersonnelsLG_student.implicitCriteria = criteria_ActivePersonnel;

    function nationalCodeExists(nationalCode) {
        return StudentsLG_student.data.localData.some(function(el) {
            return el.student.nationalCode === nationalCode;
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
            {name: "nationalCode",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "companyName",hidden:true},
            {name: "personnelNo",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "personnelNo2",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "postTitle"},
            {name: "ccpArea"},
            {name: "ccpAssistant",hidden:true},
            {name: "ccpAffairs",hidden:true},
            {name: "ccpSection",hidden:true},
            {name: "ccpUnit",hidden:true},
        ],
        gridComponents: [RegisteredTS_student, "filterEditor", "header", "body"],
        dataArrived:function(startRow, endRow){
            let lgNationalCodes = StudentsLG_student.data.localData.map(function(item) {
                return item.student.nationalCode;
            });
            let selectedNationalCodes = SelectedPersonnelsLG_student.data.map(function(item) {
                return item['nationalCode'];
            });

            let nationals=lgNationalCodes.concat(selectedNationalCodes);

            let findRows=PersonnelsRegLG_student.findAll({_constructor:"AdvancedCriteria",operator:"and",criteria:[{fieldName:"nationalCode",operator:"inSet",value:nationals}]});
            studentSelection=true;

            PersonnelsRegLG_student.setSelectedState(findRows);
            findRows.setProperty("enabled", false);

            studentSelection=false;
        },
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
            if(studentSelection){
                return ;
            }
            let current=PersonnelsRegLG_student.getSelection().filter(function(x){return x.enabled!=false})[0];//.filter(p->p.enabled==false);

            if(typeof(current)=="undefined"){
                return;
            }
            if(current.nationalCode=="" || current.nationalCode ==null || typeof(current.nationalCode)=="undefined")
            {
                isc.Dialog.create({
                    message: "اطلاعات شخص مورد نظر ناقص است. کد ملی برای این شخص وارد نشده است.",
                    icon: "[SKIN]stop.png",
                    title: "<spring:message code="message"/>",
                    buttons: [isc.Button.create({title: "<spring:message code="ok"/>"})],
                    buttonClick: function (button, index) {
                        this.close();
                    }
                });

                studentSelection=true;
                PersonnelsRegLG_student.deselectRecord(current)
                studentSelection=false;
            }
            else if(!nationalCodeExists(current.nationalCode))
            {
                if (checkIfAlreadyExist(current)) {
                    return '';
                } else {
                    current.applicantCompanyName = current.companyName;
                    current.presenceTypeId = studentDefaultPresenceId;
                    current.registerTypeId = 2;

                    SelectedPersonnelsLG_student.data.add(Object.assign({}, current));
                    PersonnelsRegLG_student.findAll({_constructor:"AdvancedCriteria",operator:"and",criteria:[{fieldName:"nationalCode",operator:"equals",value:current.nationalCode}]}).setProperty("enabled", false);
                }

                function checkIfAlreadyExist(currentVal) {
                    return SelectedPersonnelsLG_student.data.some(function (item) {
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

                studentSelection=true;
                PersonnelsRegLG_student.deselectRecord(current)
                studentSelection=false;
            }

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
                        isc.TrHLayoutButtons.create({
                            layoutMargin: 0, showEdges: false, edgeImage: "", width: "100%",height:"40", padding: 0,
                            members: [
                                isc.ToolStripButtonAdd.create({
                                    title:'اضافه کردن گروهي',
                                    click: function () {
                                        groupFilter("اضافه کردن گروهی",personnelUrl+"/checkPersonnelNos/",checkPersonnelNosResponse);
                                    }
                                })
                            ]
                        }),
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
                    items: [isc.TrHLayoutButtons.create({
                            layoutMargin: 0, showEdges: false, edgeImage: "", width: "100%",height:"40", padding: 0,
                            members: [
                                isc.ToolStripButtonAdd.create({
                                    title:'اضافه کردن گروهي',
                                    click: function () {
                                        groupFilter("اضافه کردن گروهی",personnelRegUrl+"/checkPersonnelNos/",checkPersonnelNosResponse);
                                    }
                                })
                            ]
                        }),
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
        height: 768,
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
            let messages = JSON.parse(resp.data);
            let invalMessage = " ";
            let timeOut = 5000;
            if (messages.names !== null && messages.names !== undefined) {
                invalMessage = "<spring:message code="for"/>" + " " + "<spring:message code="student.plural"/>" + " " + messages.names + " " + "<spring:message code="message.define.applicant.company"/>";
                timeOut = 15000
            }

            var OK = createDialog("info", messages.accepted + " " + "<spring:message code="message.students.added.successfully"/>"
                + "<br/>" + invalMessage,

                "<spring:message code="msg.command.done"/>");

            setTimeout(function () {
                OK.close();
            }, timeOut);
        } else {
            var OK = createDialog("info", "<spring:message code="msg.operation.error"/>",
                "<spring:message code="error"/>");
            setTimeout(function () {
                OK.close();
            }, 5000);
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
            if(classRecord.classStatus === "3")
            {
                <sec:authorize access="hasAnyAuthority('TclassStudentsTab_ADD','TclassStudentsTab_D','TclassStudentsTab_E','TclassStudentsTab_P','TclassStudentsTab_R')">
                StudentTS_student.setVisibility(false)

                </sec:authorize>
            }
            else
            {
                <sec:authorize access="hasAnyAuthority('TclassStudentsTab_ADD','TclassStudentsTab_D','TclassStudentsTab_E','TclassStudentsTab_P','TclassStudentsTab_R')">
                StudentTS_student.setVisibility(true)

                </sec:authorize>
            }

            if (classRecord.classStatus === "3")
            {
                <sec:authorize access="hasAuthority('TclassStudentsTab_classStatus')">
                StudentTS_student.setVisibility(true)

                </sec:authorize>
            }
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

    function checkPersonnelNosResponse(url,result){
        isc.RPCManager.sendRequest(TrDSRequest(url, "POST", JSON.stringify(result)
            , "callback: checkPersonnelNos(rpcResponse)"));
    }

    function checkPersonnelNos(resp) {
        if(generalGetResp(resp)){
            if (resp.httpResponseCode === 200) {
                //------------------------------------*/
                let len=GroupSelectedPersonnelsLG_student.data.length;
                let list=GroupSelectedPersonnelsLG_student.data;
                let data=JSON.parse(resp.data);
                let allRowsOK=true;

                for (let i = 0; i < len; i++) {
                    let personnelNo=list[i].personnelNo;

                    if(personnelNo != "" && personnelNo != null && typeof(personnelNo) != "undefined")
                    {
                        let person=data.filter(function (item) {
                            return item.personnelNo==personnelNo|| item.personnelNo2 === personnelNo;
                        });

                        if(person.length==0){
                            allRowsOK=false;
                            list[i].error=true;
                            list[i].hasWarning="warning";
                            list[i].description="<span style=\"color:white !important;background-color:#dc3545 !important;padding: 2px;\">شخصی با کد پرسنلی وارد شده وجود ندارد.</span>";
                        }
                        else if(person[0].nationalCode== "" || person[0].nationalCode == null || typeof(person[0].nationalCode) == "undefined"){
                            allRowsOK=false;
                            list[i].error=true;
                            list[i].hasWarning="warning";
                            list[i].description="<span style=\"color:white !important;background-color:#dc3545 !important;padding: 2px;\">اطلاعات شخص مورد نظر ناقص است. کد ملی برای این شخص وارد نشده است.</span>";
                        }
                        else if(nationalCodeExists(person[0].nationalCode))
                        {
                            allRowsOK=false;
                            list[i].error=true;
                            list[i].hasWarning="warning";
                            list[i].description="<span style=\"color:white !important;background-color:#dc3545 !important;padding: 2px;\">این شخص قبلا اضافه شده است.</span>";
                        }else{
                            list[i].error=false;
                            list[i].hasWarning="check";
                            list[i].description="";
                        }
                    }
                }

                if(allRowsOK){
                    var classId = ListGrid_Class_JspClass.getSelectedRecord().id;
                    var students = [];
                    for (var i=0;i<data.length;i++) {
                        let current = data[i];

                        if (!checkIfAlreadyExist(current)) {
                            students.add({
                                "personnelNo": current.personnelNo,
                                "applicantCompanyName": current.companyName,
                                "presenceTypeId": studentDefaultPresenceId,
                                "registerTypeId": 1
                            });
                        }
                    }


                    function checkIfAlreadyExist(currentVal) {
                        return SelectedPersonnelsLG_student.data.some(function (item) {
                            return (item.nationalCode === currentVal.nationalCode);
                        });
                    }
                    if (students.getLength() > 0)
                        isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/register-students/" + classId, "POST", JSON.stringify(students),class_add_students_result));

                    SelectedPersonnelsLG_student.data.clearAll();


                    /*//Add Result To SelectedListGrid
                    for (var person in data) {
                        let current = data[person];
                        if(!nationalCodeExists(current.nationalCode))
                        {

                            if (!checkIfAlreadyExist(current)) {

                                current.applicantCompanyName = current.companyName;
                                current.presenceTypeId = studentDefaultPresenceId;
                                current.registerTypeId = 1;

                                SelectedPersonnelsLG_student.setData(SelectedPersonnelsLG_student.data.concat([current]));
                            }

                            function checkIfAlreadyExist(currentVal) {
                                return SelectedPersonnelsLG_student.data.some(function (item) {
                                    return (item.nationalCode === currentVal.nationalCode);
                                });
                            }
                        }
                    }*/

                    //Close Window
                    ClassStudentWin_student_GroupInsert.close();
                }else{
                    GroupSelectedPersonnelsLG_student.invalidateCache();
                    GroupSelectedPersonnelsLG_student.fetchData();
                }


            }
        }
    }
    //