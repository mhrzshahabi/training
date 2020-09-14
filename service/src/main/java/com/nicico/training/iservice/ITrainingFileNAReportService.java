/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/09/08
 * Last Modified: 2020/07/26
 */

package com.nicico.training.iservice;

import com.nicico.training.dto.TrainingFileNAReportDTO;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewActivePersonnelDTO;

import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.function.Function;

public interface ITrainingFileNAReportService {

    <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter);

    void generateReport(final HttpServletResponse response, List<ViewActivePersonnelDTO.Info> data) throws Exception;

    void exportExcel(HttpServletResponse response, List<TrainingFileNAReportDTO.GenerateReport> data) throws Exception;
}
