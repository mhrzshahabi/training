package com.nicico.training.mapper.NeedAssessmentGapBeanMapper;

import com.nicico.training.dto.NeedsAssessmentWithGapDTO;
import com.nicico.training.model.Attachment;
import com.nicico.training.model.NeedsAssessmentWithGap;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.ReportingPolicy;
import response.question.dto.ElsAttachmentDto;

import java.util.List;

@Mapper(componentModel = "spring",unmappedTargetPolicy = ReportingPolicy.WARN)
public interface NeedAssessmentGapBeanMapper {

//    @Mapping(target = "key",source = "fileKey")
//
//    Attachment toAttachment(AttachmentDto attachmentDto);

    @Mapping(target = "code",source = "competence.code")
    @Mapping(target = "title",source = "competence.title")
    @Mapping(target = "competenceType",source = "competence.competenceType.title")
    @Mapping(target = "needsAssessmentDomain",source = "needsAssessmentDomain.title")
    @Mapping(target = "needsAssessmentPriority",source = "needsAssessmentPriority.title")
    @Mapping(target = "courseCode",source = "skill.courseMainObjective.code")
    @Mapping(target = "courseTitleFa",source = "skill.courseMainObjective.titleFa")
    NeedsAssessmentWithGapDTO.allCompetence toNeedAssessment(NeedsAssessmentWithGap needsAssessmentWithGap);



    List<NeedsAssessmentWithGapDTO.allCompetence> toNeedAssessments(List<NeedsAssessmentWithGap> needsAssessmentWithGaps);





}
