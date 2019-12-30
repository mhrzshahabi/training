/*
ghazanfari_f, 8/29/2019, 11:41 AM
*/
package com.nicico.training.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.dto.PostDTO;
import com.nicico.training.iservice.IPersonnelService;
import com.nicico.training.model.Personnel;
import com.nicico.training.model.Post;
import com.nicico.training.repository.PersonnelDAO;
import com.nicico.training.repository.PostDAO;
import com.nicico.training.service.CourseService;
import com.nicico.training.service.PersonnelService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/personnel/")
public class PersonnelRestController {

    final ObjectMapper objectMapper;
    final CourseService courseService;
    final DateUtil dateUtil;
    final ReportUtil reportUtil;
    private final PersonnelService personnelService;
    private final PersonnelDAO personnelDAO;
    private final PostDAO postDAO;

    @GetMapping("list")
    public ResponseEntity<List<PersonnelDTO.Info>> list() {
        return new ResponseEntity<>(personnelService.list(), HttpStatus.OK);
    }

    @GetMapping(value = "iscList")
    public ResponseEntity<TotalResponse<PersonnelDTO.Info>> list(@RequestParam MultiValueMap<String, String> criteria) {
        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
        return new ResponseEntity<>(personnelService.search(nicicoCriteria), HttpStatus.OK);
    }


    @Loggable
    @GetMapping(value = "/byPostCode/{postId}")
//    @PreAuthorize("hasAuthority('c_personnel')")
    public ResponseEntity<Personnel> findPersonnelByPostCode(@PathVariable Long postId) {
//    public ResponseEntity<Personnel> findPersonnelByPostCode(@RequestParam("postId") Long postId) {

//        Optional<Post>  post = (postDAO.findOneById(postId));
//        String postCode = post.get().getCode();
        String postCode = postDAO.findOneById(postId);
        if (((personnelDAO.findOneByPostCode(postCode)) == null )){
            return null;
        }
        else {
            if ((personnelDAO.findOneByPostCode(postCode)) == null ) {
                return null;
            }
            Optional<Personnel> optPersonnel = (personnelDAO.findOneByPostCode(postCode));
            Personnel personnel = optPersonnel.get();
            return new ResponseEntity<Personnel>(personnel, HttpStatus.OK);
        }

    }

}
