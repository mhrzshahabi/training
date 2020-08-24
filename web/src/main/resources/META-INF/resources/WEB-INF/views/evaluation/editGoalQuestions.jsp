<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

var change_value_JspEGQ  = true;
    var RestDataSource_Golas_JspEGQ = isc.TrDS.create({
        fields: [
            {name: "teacherCode"}
        ],
        fetchDataURL: teacherUrl + "spec-list-grid"
    });


    var ListGrid_Goal_JspEGQ = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Golas_JspEGQ,
        selectionType: "single",
        editOnFocus: true,
        showRowNumbers: false,
        editByCell: true,
        editEvent: "click",
        modalEditing: true,
        canHover:true,
        canSelectCells: true,
        autoFetchData: true,
        initialSort: [
            {property: "teacherCode", direction: "descending", primarySort: true}
        ],
        fields: [
            {name: "teacherCode",
            canEdit: true,
            validateOnChange: false,
            editEvent: "click",
            change: function (form, item, value, oldValue) {

            if (value != null && value != '' && typeof (value) != 'undefined' && !value.match(/^(([1-9]\d{0,1})|100|0)$/)) {
            item.setValue(value.substring(0, value.length - 1));
            } else {
            item.setValue(value);
            }

            if (value == null || typeof (value) == 'undefined') {
            item.setValue('');
            }


            if (oldValue == null || typeof (oldValue) == 'undefined') {
            oldValue = '';
            }


            if (item.getValue() != oldValue) {
change_value_JspEGQ = true;
            }
            },
            editorExit: function (editCompletionEvent, record, newValue) {

            if (change_value_JspEGQ) {
            if (newValue != null && newValue != '' && typeof (newValue) != 'undefined') {

            ListGrid_Cell_ScorePreTest_Update(record, newValue);

            } else {
            ListGrid_Cell_ScorePreTest_Update(record, null);
            }
            }
change_value_JspEGQ = false;
            },
            }
        ],
    });

    var HLayout_Body_JspEGQ = isc.TrHLayout.create({
        members: [ListGrid_Goal_JspEGQ]
    });