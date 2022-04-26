package com.nicico.training.controller;



import com.nicico.training.iservice.*;

import com.nicico.training.service.*;
import com.nicico.training.service.needsassessment.NeedsAssessmentTempService;
import lombok.RequiredArgsConstructor;

import org.springframework.web.bind.annotation.*;
import java.util.*;


@RestController
@RequestMapping("/anonym/api")
@RequiredArgsConstructor
public class AnonymRestController {
    private final IPersonnelRegisteredService personnelRegisteredService;
    private final NeedsAssessmentTempService needsAssessmentTempService;
    private final ITrainingPostService iTrainingPostService;
//    private final IClassStudentService classStudentService;

    @PostMapping("/changeContactInfo")
    public void changeContactInfo(@RequestBody List<Long> ids) {
        personnelRegisteredService.changeContactInfo(ids);
    }

    @PostMapping("/remove-un-complete-na")
    public void removeUnCompleteNa(@RequestParam String code,@RequestParam(value = "status", required = false)  String status) {
        needsAssessmentTempService.removeUnCompleteNa(code,status);
    }

    @GetMapping("/get-reapeatly")
    public Map<String,String> getReapeatlyPhones() {
       return personnelRegisteredService.getReapeatlyPhones();
    }

   @GetMapping("/changePost/{id}")
    public boolean changePost(@PathVariable long id) {
       return iTrainingPostService.updateToUnDeleted(id);
    }


//    @PostMapping("/test-add-student")
//    public void testAddStudent(@RequestBody String classCode) {
//        classStudentService.testAddStudent(classCode);
//    }
//

//    @Loggable
//    @PutMapping(value = "/edit-parameter-value/{id}")
//    public ResponseEntity editParameterValue(@RequestParam String des,@RequestParam String code,@PathVariable Long id) {
//        parameterValueService.editParameterValue(des,code,id);
//        return new ResponseEntity(null, HttpStatus.OK);
//    }
//    @Loggable
//    @PutMapping(value = "/edit-parameter-value-des/{id}")
//    public ResponseEntity editDescription(@PathVariable Long id) {
//        parameterValueService.editDescription(id);
//        return new ResponseEntity(null, HttpStatus.OK);
//    }

}
