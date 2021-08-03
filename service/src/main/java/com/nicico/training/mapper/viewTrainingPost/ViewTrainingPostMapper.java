package com.nicico.training.mapper.viewTrainingPost;

import com.nicico.training.dto.ViewTrainingPostDTO;
import com.nicico.training.model.ViewTrainingPost;
import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import org.mapstruct.ReportingPolicy;

import java.util.List;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface ViewTrainingPostMapper {

    List<ViewTrainingPostDTO.Report> changeToPostReportDTOList(List<ViewTrainingPost> viewTrainingPostList, @MappingTarget List<ViewTrainingPostDTO.Report> trainingReportDto);


}
