/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/09/08
 * Last Modified: 2020/07/26
 */

package com.nicico.training.iservice;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

public interface ITrainingFileNAReportService {

    void exportToExcel(final HttpServletResponse response, List<String> personnelNos) throws Exception;
}
