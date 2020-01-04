<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    var DynamicForm_JobInfo_JspTeacher = isc.DynamicForm.create({
        height: "100%",
        align: "right",
        canSubmit: true,
        titleWidth: 120,
        showInlineErrors: true,
        showErrorText: false,
        valuesManager: "vm",
        numCols: 6,
        titleAlign: "left",
        margin: 10,
        newPadding: 5,
        fields: [
            {name: "id", hidden: true},
            {
                name: "personality.jobLocation",
                title: "<spring:message code='job'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30"
            },
            {
                name: "personality.jobTitle",
                title: "<spring:message code='work.place'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30"
            },
            {
                name: "personality.contactInfo.workAddress.postalCode",
                title: "<spring:message code='postal.code'/>",
                keyPressFilter: "[0-9]",
                length: "10"
            },
            {
                name: "personality.contactInfo.workAddress.webSite",
                title: "<spring:message code='website'/>",
                length: "30"
            },

            {
                name: "personality.contactInfo.workAddress.stateId",
                title: "<spring:message code='state'/>",
                textAlign: "center",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                width: "*",
                displayField: "name",
                valueField: "id",
                optionDataSource: RestDataSource_Work_State_JspTeacher,
                autoFetchData: true,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["name"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListFields: [
                    {
                        name: "name",
                        width: "70%",
                        filterOperator: "iContains"
                    }
                ]
            },
            {
                name: "personality.contactInfo.workAddress.cityId",
                title: "<spring:message code='city'/>",
                textAlign: "center",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                displayField: "name",
                width: "*",
                valueField: "id",
                autoFetchData: false,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["name"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListFields: [
                    {
                        name: "name",
                        width: "70%",
                        filterOperator: "iContains"
                    }
                ]
            },
            {
                name: "personality.contactInfo.workAddress.otherCountry",
                title: "<spring:message code='other.counteries'/>",
                editorType: "CheckboxItem",
                showUnsetImage: false,
                width: "*",
                showValueIconDisabled: true,
                showValueIconOver: true,
                showValueIconDown: true,
                showValueIconFocused: true
            },
            {
                name: "personality.contactInfo.workAddress.restAddr",
                title: "<spring:message code='address.rest'/>",
                type: "textArea",
                length: "255"
            },
            {
                name: "personality.contactInfo.workAddress.phone",
                title: "<spring:message code='telephone'/>",
                keyPressFilter: "[0-9]",
                length: "11"
            },
            {
                name: "personality.contactInfo.workAddress.fax",
                title: "<spring:message code='telefax'/>"
            }
        ],
        itemChanged: function (item, newValue) {
            if (item.name === "personality.contactInfo.workAddress.stateId") {
                if (newValue === undefined) {
                    DynamicForm_JobInfo_JspTeacher.clearValue("personality.contactInfo.workAddress.cityId");
                } else {
                    DynamicForm_JobInfo_JspTeacher.clearValue("personality.contactInfo.workAddress.cityId");
                    RestDataSource_Work_City_JspTeacher.fetchDataURL = stateUrl + "spec-list-by-stateId/" + newValue;
                    DynamicForm_JobInfo_JspTeacher.getField("personality.contactInfo.workAddress.cityId").optionDataSource = RestDataSource_Work_City_JspTeacher;
                    DynamicForm_JobInfo_JspTeacher.getField("personality.contactInfo.workAddress.cityId").fetchData();
                }
            } else if (item.name === "personality.contactInfo.workAddress.otherCountry") {
                DynamicForm_JobInfo_JspTeacher.clearValue("personality.contactInfo.workAddress.cityId");
                DynamicForm_JobInfo_JspTeacher.clearValue("personality.contactInfo.workAddress.stateId");
                if (newValue === true) {
                    DynamicForm_JobInfo_JspTeacher.getItem("personality.contactInfo.workAddress.cityId").disable();
                    DynamicForm_JobInfo_JspTeacher.getItem("personality.contactInfo.workAddress.stateId").disable();
                } else {
                    DynamicForm_JobInfo_JspTeacher.getItem("personality.contactInfo.workAddress.cityId").enable();
                    DynamicForm_JobInfo_JspTeacher.getItem("personality.contactInfo.workAddress.stateId").enable();
                }
            } else if (item.name === "personality.contactInfo.workAddress.postalCode") {
                if (newValue < 1e9)
                    DynamicForm_JobInfo_JspTeacher.addFieldErrors("personality.contactInfo.workAddress.postalCode",
                        "<spring:message code='msg.postal.code.validation'/>", true);
                else {
                    DynamicForm_JobInfo_JspTeacher.clearFieldErrors("personality.contactInfo.workAddress.postalCode", true);
                    fillWorkAddressFields(DynamicForm_JobInfo_JspTeacher.getValue("personality.contactInfo.workAddress.postalCode"));
                }
            }
        }

    });


    var VLayOut_JspJobInfo = isc.TrVLayout.create({
        showEdges: false,
        edgeImage: "",
        align: "right",
        members: [DynamicForm_JobInfo_JspTeacher]
    });



    //</script>