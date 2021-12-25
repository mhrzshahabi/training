package com.nicico.training.mapper.viewTrainingPost;

import com.nicico.copper.activiti.domain.UserTask;
import com.nicico.training.dto.ViewTrainingPostDTO;
import com.nicico.training.model.ViewTrainingPost;
import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import org.mapstruct.ReportingPolicy;

import javax.mail.search.SearchTerm;
import java.util.List;
import java.util.Set;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface ViewTrainingPostMapper {

    List<ViewTrainingPostDTO.Report> changeToPostReportDTOList(List<ViewTrainingPost> viewTrainingPostList, @MappingTarget List<ViewTrainingPostDTO.Report> trainingReportDto);

    List<ViewTrainingPostDTO.Info> changeToViewTrainingPostDtoInfo(List<ViewTrainingPost> viewTrainingPostList, @MappingTarget List<ViewTrainingPostDTO.Info> ViewTrainingPostDtoInfos);

}
