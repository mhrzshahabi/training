<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page import="com.nicico.training.controller.util.AppUtils" %>
<%@ page import="com.nicico.copper.core.SecurityUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="Spring" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
    final String tenantId = AppUtils.getTenantId();
    final String userNationalCode = SecurityUtil.getNationalCode();
    final String userUserName = SecurityUtil.getUsername();
%>

    // <script>

    //-------------------------------------------------- Rest DataSources --------------------------------------------------


    //----------------------------------------------------- Main Layout ----------------------------------------------------

    let HLayout_Main = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [
        ]
    });

    //------------------------------------------------------ Functions -----------------------------------------------------

    // </script>