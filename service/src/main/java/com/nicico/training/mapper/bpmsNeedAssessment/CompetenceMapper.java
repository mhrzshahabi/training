package com.nicico.training.mapper.bpmsNeedAssessment;


import com.nicico.training.model.Competence;
import com.nicico.training.model.NeedsAssessment;
import dto.BpmsNeedAssessmentDto;
import dto.CompetenceDTO;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface CompetenceMapper {


    @Mapping(target = "title", source = "title")
    @Mapping(target = "competenceTypeId", source = "competenceTypeId")
    Competence toCompetence(CompetenceDTO competenceDTO);


    @Mapping(target = "title", source = "title")
    @Mapping(target = "competenceTypeId", source = "competenceTypeId")
    CompetenceDTO toCompetenceDto(Competence competence);



}
