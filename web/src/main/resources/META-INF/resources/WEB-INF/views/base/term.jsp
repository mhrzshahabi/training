<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="Spring" uri="http://java.sun.com/jsp/jstl/fmt" %>

	var ToolStripButton_Add = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/add.png",
		title: "ایجاد",
		click: function () {


		}
	});

var ToolStrip_Actions = isc.ToolStrip.create({
		width: "100%",
		members: [ToolStripButton_Add]
	});
	var HLayout_Actions_Group = isc.HLayout.create({
		width: "100%",
		members: [ToolStrip_Actions]
	});
	var VLayout_Body_Group = isc.VLayout.create({
		width: "100%",
		height: "100%",
		members: [
			HLayout_Actions_Group]
	});