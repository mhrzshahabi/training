package com.nicico.training.dto;


 import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;
 import org.apache.commons.lang3.builder.HashCodeBuilder;


@Getter
@Setter
@Accessors(chain = true)
public class NeedsAssessmentForBpms {

    private Long objectId;
    private String objectType;

}