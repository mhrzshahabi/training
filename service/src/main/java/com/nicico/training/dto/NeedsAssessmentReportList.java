package com.nicico.training.dto;

import com.nicico.training.model.NeedsAssessment;
import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;

import java.io.Serializable;
import java.util.List;

@Setter
@Getter
public class NeedsAssessmentReportList extends BaseResponse implements Serializable {
    List<NeedsAssessment> needsAssessments;
}
