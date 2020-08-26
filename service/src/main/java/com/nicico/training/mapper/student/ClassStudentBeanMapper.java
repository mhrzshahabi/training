package com.nicico.training.mapper.student;

import com.nicico.training.model.ClassStudent;
import org.mapstruct.*;
import request.student.UpdateStudentScoreRequest;
import response.student.UpdatePreTestScoreRequest;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface ClassStudentBeanMapper {

//    You can ignore mapping on specific field in target class
//    @Mapping(source = "request.scoresStateId", target = "classStudent.scoresStateId", ignore = true)
    @Mapping(source = "request.failureReasonId", target = "classStudent.failureReasonId", qualifiedByName = "checkFailureReasonId")
    @Mapping(source = "request.scoresStateId", target = "classStudent.scoresStateId", qualifiedByName = "checkNullScoresStateId")
    ClassStudent updateScoreClassStudent(UpdateStudentScoreRequest request, @MappingTarget ClassStudent classStudent);
    ClassStudent updatePreTestScoreClassStudent(UpdatePreTestScoreRequest request, @MappingTarget ClassStudent classStudent);

    @Named("checkFailureReasonId")
    default Long checkFailureReasonId(long failureReasonId) {
        return failureReasonId == 0 ? null : failureReasonId;
    }

    @Named("checkNullScoresStateId")
    default Long checkNullScoresStateId(Long scoreStateId) {
        return scoreStateId == null ? 410 : scoreStateId;
    }
}
