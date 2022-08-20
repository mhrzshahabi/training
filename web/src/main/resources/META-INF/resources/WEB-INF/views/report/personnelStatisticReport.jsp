<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

    var  RestDataSource_ListResult_JspPersonnelStatistic = isc.TrDS.create({
        fields: [
            {name: "complexTitle"},
            {name: "assistance"},
            {name: "affairs"},
            {name: "section"},
            {name: "unit"},
            {name: "totalNumber"},
            {name: "managerNumber"},
            {name: "bossNumber"},
            {name: "supervisorNumber"},
            {name: "expertsNumber"},
            {name: "attendantsNumber"},
            {name: "workersNumber"},
            {name: "unrankedNumber"},
            {name: "empStatus"},

        ],

    });

    var organSegmentFilter_personnelStatistic = init_OrganSegmentFilterDF(true,true, true,false,false, null, "complexTitle","assistant","affairs", "section", "unit")

    var DynamicForm_EmploymentStatus = isc.DynamicForm.create({
        colWidths: ["5%", "25%", "5%", "25%","5%","25%"],
        numCols: 4,
        align: "right",
        titleAlign:"center",
        titleWidth: 0,
        overflow: "auto",
        height: 100,
        padding: 10,
        fields: [
            {
                name: "empStatus",
                title: "<spring:message code="employment.status"/>",
                type: "SelectItem",
                operator: "inSet",
                textAlign:"center",
                required: true,
                multiple: true,
                valueMap: {
                    "1": "اشتغال",
                    "2": "بازنشسته",
                    "3" : "بازنشسته&-پیش از موعد",
                    "4" : "از کار افتاده ناشی از کار",
                    "5": "از کار افتاده غیر ناشی از کار",
                    "6" : "انفصال دایم",
                    "7" :"خاتمه قرارداد",
                    "8" : "اخراج",
                    "9" : "فوت",
                    "10" : "فوت ناشی از کار",
                    "11" : "فوت غیر ناشی از کار"
                },
                pickListProperties: {
                    showFilterEditor: false
                },
                defaultValue: ["1"]
            },

        ],
        itemKeyPress: function (item, keyName) {
            if (keyName == "Enter") {
                searchBtnJspPersonnelStatistic.click(DynamicForm_EmploymentStatus);
            }
        }
    });

    searchBtn_personnelStatistic = isc.IButtonSave.create({
        top: 260,
        title: "<spring:message code="search"/>",
        width: 300,
        click() {

            if ((DynamicForm_EmploymentStatus.getValuesAsAdvancedCriteria() == null || DynamicForm_EmploymentStatus.getValuesAsAdvancedCriteria().criteria.size() <= 1)
                && ((organSegmentFilter_personnelStatistic.getCriteria(DynamicForm_EmploymentStatus.getValuesAsAdvancedCriteria())).criteria.length <= 1)) {
                createDialog("info", "فیلتری انتخاب نشده است.");
                return;
            }


            DynamicForm_EmploymentStatus.validate();
            if (DynamicForm_EmploymentStatus.hasErrors())
                return;


            else {
                data_values = organSegmentFilter_personnelStatistic.getCriteria(DynamicForm_EmploymentStatus.getValuesAsAdvancedCriteria());
                var personnel_statistic_wait = createDialog("wait");
                setTimeout(function () {
                    for (let i = 0; i < data_values.criteria.size(); i++){
                        if (data_values.criteria[i].fieldName == "empStatus") {
                            data_values.criteria[i].fieldName = "empStatus";
                            data_values.criteria[i].operator = "equals";
                        }
                        else if (data_values.criteria[i].fieldName == "companyName") {
                            data_values.criteria[i].fieldName = "companyName";
                            data_values.criteria[i].operator = "inSet";
                        }
                        else if (data_values.criteria[i].fieldName == "assistant") {
                            data_values.criteria[i].fieldName = "ccpAssistant";
                            data_values.criteria[i].operator = "inSet";
                        }
                        else if (data_values.criteria[i].fieldName == "unit") {
                            data_values.criteria[i].fieldName = "ccpUnit";
                            data_values.criteria[i].operator = "inSet";
                        }
                        else if (data_values.criteria[i].fieldName == "affairs") {
                            data_values.criteria[i].fieldName = "ccpAffairs";
                            data_values.criteria[i].operator = "inSet";
                        }
                        else if (data_values.criteria[i].fieldName == "section") {
                            data_values.criteria[i].fieldName = "ccpSection";
                            data_values.criteria[i].operator = "inSet";
                        }

                        else if (data_values.criteria[i].fieldName == "complexTitle") {
                            data_values.criteria[i].fieldName = "complexTitle";
                            data_values.criteria[i].operator = "inSet";
                        }


                    }
                    debugger;
                    let url =   synonymPersonnel + "/statistic-iscList";
                    RestDataSource_ListResult_JspPersonnelStatistic.fetchDataURL = url;
                    ListGrid_PersonnelStatistic.invalidateCache();
                    ListGrid_PersonnelStatistic.fetchData(data_values);
                    personnel_statistic_wait.close();
                }, 100);
            }
        }
    });

    clearBtn_personnelStatistic = isc.IButtonCancel.create({
        top: 260,
        title: "<spring:message code="clear"/>",
        width: 100,
        click(form, item) {
            DynamicForm_EmploymentStatus.clearValues();
            DynamicForm_EmploymentStatus.clearErrors();
            organSegmentFilter_personnelStatistic.clearValues();
            ListGrid_PersonnelStatistic.invalidateCache();
            ListGrid_PersonnelStatistic.setData([]);
        }
    });

    var HLayOut_Confirm_PersonnelStatistic_buttons = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "70%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            searchBtn_personnelStatistic,clearBtn_personnelStatistic
        ]
    });

    var ListGrid_PersonnelStatistic = isc.TrLG.create({
        ID: "TrainingOverTimeGrid",
        dynamicTitle: true,
        filterOnKeypress: false,
        showFilterEditor:true,
        gridComponents: [organSegmentFilter_personnelStatistic,DynamicForm_EmploymentStatus,HLayOut_Confirm_PersonnelStatistic_buttons,
            isc.ToolStripButtonExcel.create({
                margin:5,
                click:function() {
                    let title  ="گزارش آماری پرسنل";

                    ExportToFile.downloadExcel(null, ListGrid_PersonnelStatistic, 'PersonnelStatistic', 0, null, '', title, DynamicForm_EmploymentStatus.getValuesAsAdvancedCriteria(), null,2);
                }
            })
            , "header", "filterEditor", "body"],

        dataSource: RestDataSource_ListResult_JspPersonnelStatistic,

        fields: [
            {name: "complexTitle", title: "<spring:message code='complex'/>",
            },
            {name: "assistance", title: "<spring:message code='assistance'/>", autoFitWidth:true,
            },
            {name: "affairs", title: "<spring:message code='affairs'/>"},
            {name: "section", title: "<spring:message code='section'/>",},
            {name: "unit", title: "<spring:message code='unit'/>"},
            {name : "empStatus" , title: "<spring:message code='employment.status'/>", filterOperator:"equals",
                valueMap: {
                      "1": "اشتغال",
                      "2": "بازنشسته",
                      "3" : "بازنشسته&-پیش از موعد",
                      "4" : "از کار افتاده ناشی از کار",
                      "5": "از کار افتاده غیر ناشی از کار",
                      "6" : "انفصال دایم",
                      "7" :"خاتمه قرارداد",
                      "8" : "اخراج",
                      "9" : "فوت",
                      "10" : "فوت ناشی از کار",
                      "11" : "فوت غیر ناشی از کار"


                  }

                },
            {name: "totalNumber", title: "<spring:message code='personnel.total'/>",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
                },
            {name: "managerNumber", title: "تعداد مدیر" ,   filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }},
            {name: "bossNumber", title: "تعداد رییس"  ,
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
                },
            {name: "supervisorNumber", title: "تعداد سرپرست و کارشناس ارشد",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
                },
            {name: "expertsNumber", title: "تعداد کارشناس و مسئول" ,
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
                },
            {name: "attendantsNumber", title: "تعداد متصدی و تکنیسین"     ,
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
                },
            {name: "workersNumber", title: "تعداد کارگر"  ,
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
                },
            {name: "unrankedNumber", title: "تعداد بدون رده" ,
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
                },
        ]
    });
    var VLayout_Body_Personnel_Statistic= isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            ListGrid_PersonnelStatistic
        ]
    });

    //</script>