package com.nicico.training.mapper.student;

import com.nicico.training.model.ClassStudent;
import org.mapstruct.*;
import request.student.UpdateStudentScoreRequest;
import response.student.UpdatePreTestScoreRequest;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface ClassStudentBeanMapper {

    @Mapping(source = "failureReasonId", target = "failureReasonId", qualifiedByName = "checkFailureReasonId")
    ClassStudent updateScoreClassStudent(UpdateStudentScoreRequest request, @MappingTarget ClassStudent classStudent);
    ClassStudent updatePreTestScoreClassStudent(UpdatePreTestScoreRequest request, @MappingTarget ClassStudent classStudent);

    @Named("checkFailureReasonId")
    default Long checkFailureReasonId(long failureReasonId) {
        return failureReasonId == 0 ? null : failureReasonId;
    }
}
