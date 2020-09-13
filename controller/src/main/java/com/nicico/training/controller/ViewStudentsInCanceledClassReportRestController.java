/* Author: Mehran Golrokhi
 * Created Date: 2020/09/13
 * Last Modified: 2020/08/24
 */


package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.*;
import com.nicico.training.service.ViewStudentsInCanceledClassReportService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/unjustifiedAbsenceReport")
public class ViewStudentsInCanceledClassReportRestController {
    private final ViewStudentsInCanceledClassReportService viewStudentsInCanceledClassService;
    private final ModelMapper modelMapper;

    @Loggable
    @GetMapping(value = "/spec-list")
    //@PreAuthorize("hasAuthority('Course_R')")
    public ResponseEntity<ViewStudentsInCanceledClassDTO.ViewStudentsInCanceledClassDTOSpecRs> list(HttpServletRequest req) throws IOException {
        SearchDTO.SearchRq request =ISC.convertToSearchRq(req);
        SearchDTO.SearchRs<ViewStudentsInCanceledClassDTO.Info> response = viewStudentsInCanceledClassService.search(request);

        final ViewStudentsInCanceledClassDTO.SpecRs specResponse = new ViewStudentsInCanceledClassDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(request.getStartIndex())
                .setEndRow(request.getStartIndex() + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        final ViewStudentsInCanceledClassDTO.ViewStudentsInCanceledClassDTOSpecRs specRs = new ViewStudentsInCanceledClassDTO.ViewStudentsInCanceledClassDTOSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }
}
