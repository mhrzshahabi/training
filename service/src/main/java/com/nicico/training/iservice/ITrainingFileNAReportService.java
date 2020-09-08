/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/09/08
 * Last Modified: 2020/07/26
 */

package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;

import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.function.Function;

public interface ITrainingFileNAReportService {

    <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter);

    void generateReport(final HttpServletResponse response, List<String> personnelNos) throws Exception;
}
